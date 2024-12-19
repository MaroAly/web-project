#!C:\Users\Mega Store\AppData\Local\Programs\Python\Python312\python.exe

from flask import Flask, render_template, request, jsonify, redirect, url_for, flash, session
from flask_mysqldb import MySQL
from datetime import date
app = Flask(__name__)
app.secret_key = 'hospital_system_secret_key'

# MySQL Configuration
app.config['MYSQL_HOST'] = 'localhost'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = ''
app.config['MYSQL_DB'] = 'hospitalsystem'
app.config['MYSQL_PORT'] = 3306
mysql = MySQL(app)

# Home route
@app.route('/')
def home():
    return render_template('index.html')
@app.route('/home')
def home2():
    return render_template('home.html')
@app.route('/about')
def about():
    return render_template('about.html')
@app.route('/doctors')
def doctors():
    cur = mysql.connection.cursor()

    # Fetch all doctors from the database
    cur.execute("SELECT * FROM doctors")
    doctors_list = cur.fetchall()

    cur.close()
    return render_template('doctors.html', doctors=doctors_list)

@app.route('/logout')
def logout():
    """Logout functionality."""
    session.clear()
    flash('Logged out successfully', 'success')
    return redirect('/')
@app.route('/doctors2')
def doctors2():
    if 'user_id' in session and session.get('user_type') == 'admin':
        flash('Admins cannot access this page.', 'danger')
        return redirect('/')

    cur = mysql.connection.cursor()

    # Fetch doctors with their departments and brief
    cur.execute("""
        SELECT d.department, d.first_name, d.last_name, d.profession, d.fee, d.brief
        FROM doctors d
        ORDER BY d.department, d.id
    """)
    doctors = cur.fetchall()

    # Organize doctors by department
    doctors_by_department = {}
    for department, first_name, last_name, profession, fee, brief in doctors:
        if department not in doctors_by_department:
            doctors_by_department[department] = []
        doctors_by_department[department].append({
            'name': f"{first_name} {last_name}",
            'profession': profession,
            'fee': fee,
            'brief': brief
        })

    cur.close()
    return render_template('doctors2.html', doctors_by_department=doctors_by_department)


@app.route('/contact', methods=['GET', 'POST'])
def contact():
    if request.method == 'POST':
        # Extract form data
        full_name = request.form['full_name']
        email = request.form['email']
        subject = request.form['subject']
        message = request.form['message']

        # Print data for debugging
        print(f"Full Name: {full_name}, Email: {email}, Subject: {subject}, Message: {message}")
        
        # Insert data into the database
        cur = mysql.connection.cursor()
        try:
            cur.execute("INSERT INTO contact (full_name, email, subject, message) VALUES (%s, %s, %s, %s)", 
                        (full_name, email, subject, message))
            mysql.connection.commit()  # Commit changes
        except Exception as e:
            print(f"Error: {e}")
            mysql.connection.rollback()
        cur.close()

        return redirect(url_for('contact'))  # Redirect to the contact page after sending the message
    
    # If the user is admin, fetch all messages from the database
    if session.get('user_type') == 'admin':
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM contact")
        messages = cur.fetchall()
        cur.close()
        return render_template('contact.html', messages=messages, is_admin=True)  # Pass messages to template


    # If the user is not an admin, show the contact form
    return render_template('contact.html', is_admin=False)

@app.route('/delete_message/<int:message_id>', methods=['POST'])
def delete_message(message_id):
    # Ensure that the user is an admin before allowing message deletion
    if session.get('user_type') != 'admin':
        return redirect(url_for('contact'))  # Redirect to contact page if not admin
    
    # Delete the message from the database
    cur = mysql.connection.cursor()
    try:
        cur.execute("DELETE FROM contact WHERE id = %s", (message_id,))
        mysql.connection.commit()  # Commit the change
    except Exception as e:
        print(f"Error: {e}")
        mysql.connection.rollback()  # Rollback if any error occurs
    finally:
        cur.close()

    return redirect(url_for('contact'))  # Redirect to contact page after deletion


# Handle signup logic
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        cur = mysql.connection.cursor()

        # Get form data
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        gov_id = request.form['gov_id']
        phone_number = request.form['phone_number']
        address = request.form['address']
        email = request.form['email']
        password = request.form['password']

        try:
            # Insert user into database
            cur.execute("""
                INSERT INTO users (first_name, last_name, gov_id, phone_number, address, email, password) 
                VALUES (%s, %s, %s, %s, %s, %s, %s)""",
                (first_name, last_name, gov_id, phone_number, address, email, password)
            )
            mysql.connection.commit()
            flash('User account created successfully.', 'success')
            return redirect(url_for('login'))
        except Exception as e:
            flash('Failed to create user account.', 'danger')
            print(e)
        finally:
            cur.close()

    return render_template('signup.html')


# AJAX endpoint for real-time validation of email or gov_id
@app.route('/check_signup', methods=['POST'])
def check_signup():
    email = request.form.get('email', '')
    gov_id = request.form.get('gov_id', '')
    cur = mysql.connection.cursor()

    # Check if email exists in users table
    cur.execute("SELECT * FROM users WHERE email = %s", (email,))
    if cur.fetchone():
        return jsonify({"status": "email_exists"})

    # Check if email exists in admin table
    cur.execute("SELECT * FROM admin WHERE email = %s", (email,))
    if cur.fetchone():
        return jsonify({"status": "email_exists"})

    # Check if gov_id exists
    cur.execute("SELECT * FROM users WHERE gov_id = %s", (gov_id,))
    if cur.fetchone():
        return jsonify({"status": "gov_id_exists"})
    cur.close()
    # No conflicts
    return jsonify({"status": "valid"})
@app.route('/check_doctors', methods=['POST'])
def check_doctors():
    email = request.form.get('email', '')
    gov_id = request.form.get('gov_id', '')
    phone_number = request.form.get('phone_number', '')  # إضافة تحقق من رقم الهاتف
    cur = mysql.connection.cursor()

    # Check if email exists
    cur.execute("SELECT * FROM doctors WHERE email = %s", (email,))
    if cur.fetchone():
        return jsonify({"status": "email_exists"})

    # Check if gov_id exists in doctors table
    cur.execute("SELECT * FROM doctors WHERE gov_id = %s", (gov_id,))  # تأكد من التحقق في الجدول الصحيح
    if cur.fetchone():
        return jsonify({"status": "gov_id_exists"})

    # Check if phone_number exists in doctors table
    cur.execute("SELECT * FROM doctors WHERE phone_number = %s", (phone_number,))  # تحقق من وجود رقم الهاتف
    if cur.fetchone():
        return jsonify({"status": "phone_exists"})

    cur.close()

    # No conflicts
    return jsonify({"status": "valid"})

# Handle login logic
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        cur = mysql.connection.cursor()

        # First check if it's an admin login
        cur.execute("SELECT * FROM admin WHERE email = %s AND password = %s", (email, password))
        admin_user = cur.fetchone()
        if admin_user:
            session['user_id'] = admin_user[0]
            session['user_type'] = 'admin'
            session['admin_name'] = admin_user[1]  # Assuming the admin's name is stored in the second column
            flash('Admin logged in successfully!', 'success')
            return redirect(url_for('login_success'))

         # If it's not an admin, check if it's a regular user
        cur.execute(
            "SELECT * FROM users WHERE email = %s AND password = %s", (email, password))
        regular_user = cur.fetchone()
        if regular_user:
            # User found, set session variables
            # Assuming user ID is stored in the first column
            session['user_id'] = regular_user[0]
            session['user_type'] = 'user'  # Set user type as 'user'
            # Assuming the user's name is stored in the second column
            session['user_name'] = regular_user[1]
            session['email'] = regular_user[6]    # Email (6th column)
            session['phone_number'] = regular_user[4]  # Phone number
            session['gov_id'] = regular_user[3]   # Government ID
            flash('User logged in successfully!', 'success')
            return redirect(url_for('login_success'))
        else:
            return render_template('login.html', message="This email is not registered. Please sign up.")
        # Handle invalid credentials
        flash('Invalid email or password.', 'danger')
        cur.close()
    return render_template('login.html')

# Success route after login
@app.route('/login_success')
def login_success():
    if 'user_id' not in session:
        flash('You need to login first.', 'danger')
        return redirect(url_for('login'))
    
    if session['user_type'] == 'admin':
        return redirect(url_for('doctors'))  # Redirect to the doctors page
    else:
        return redirect(url_for('home')) 
    

@app.route('/appointment', methods=['GET', 'POST'])
def book_appointment():
    if 'user_id' not in session or session.get('user_type') != 'user':
        flash('Please login first', 'danger')
        return redirect('/login')

    cur = mysql.connection.cursor()
    if request.method == 'POST':
        department = request.form['department']
        doctor_id = request.form['doctor_id']
        appointment_date = request.form['date']
        email = session['email']
        phone_number = session.get('phone_number')
        gov_id = session.get('gov_id')

        # Check if the doctor is fully booked
        cur.execute(
            "SELECT COUNT(*) FROM appointments WHERE doctor_id=%s AND date=%s", (doctor_id, appointment_date))
        count = cur.fetchone()[0]

        if count >= 20:
            flash('Doctor is fully booked for this date.', 'danger')
        else:
            try:
                # Insert appointment into the database
                cur.execute("""
                    INSERT INTO appointments (patient_id, doctor_id, email, phone, gov_id, date, time, status)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, 'Scheduled')
                """, (session['user_id'], doctor_id, session['email'], session['phone_number'], session['gov_id'], appointment_date, '00:00:00'))
                mysql.connection.commit()
                flash('Appointment booked successfully.', 'success')
                return redirect('/my_appointments')
            except Exception as e:
                flash('An error occurred while booking the appointment.', 'danger')
                print(e)
            finally:
                cur.close()

    cur.execute("SELECT DISTINCT department FROM doctors")
    departments = cur.fetchall()
    cur.close()
    return render_template('book_appointment.html', departments=departments, today_date=date.today())


@app.route('/doctors/<department>')
def get_doctors(department):
    """Retrieve doctors based on the selected department."""
    cur = mysql.connection.cursor()
    cur.execute(
        "SELECT id, first_name, last_name FROM doctors WHERE department=%s", (department,))
    doctors = cur.fetchall()
    cur.close()
    return jsonify(doctors)


@app.route('/my_appointments')
def my_appointments():
    """View user's appointments."""
    if 'user_id' not in session:
        flash('Please log in to view your appointments.', 'danger')
        return redirect('/login')

    user_id = session['user_id']
    cur = mysql.connection.cursor()
    cur.execute("""
        SELECT a.date, d.first_name, d.last_name, d.department 
        FROM appointments a 
        JOIN doctors d ON a.doctor_id = d.id 
        WHERE a.patient_id = %s
    """, (user_id,))
    appointments = cur.fetchall()
    cur.close()
    return render_template('my_appointments.html', appointments=appointments)


# Handle Add Doctor logic
@app.route('/add_doctor', methods=['POST'])
def add_doctor():
    if request.method == 'POST':
        # Get form data
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        profession = request.form['profession']
        gov_id = request.form['gov_id']
        phone_number = request.form['phone_number']
        address = request.form['address']
        email = request.form['email']
        fee = request.form['fee']
        department = request.form['department']  # Add department field
        brief = request.form['brief']  # New brief field
        
        cur = mysql.connection.cursor()

        # Check if doctor already exists
        cur.execute("SELECT * FROM doctors WHERE gov_id = %s OR email = %s", (gov_id, email))
        if cur.fetchone():
            flash('Doctor with this ID or Email already exists.', 'danger')
            return redirect(url_for('doctors'))

        # Check if department exists in the departments table
        cur.execute("SELECT * FROM departments WHERE name = %s", (department,))
        existing_department = cur.fetchone()
        if not existing_department:
            # If department doesn't exist, insert it into the departments table
            try:
                cur.execute("INSERT INTO departments (name) VALUES (%s)", (department,))
                mysql.connection.commit()
            except Exception as e:
                flash('Failed to add department. Please try again.', 'danger')
                print(e)
                cur.close()
                return redirect(url_for('doctors'))

        try:
            # Insert doctor with the brief field
            cur.execute(""" 
                INSERT INTO doctors (first_name, last_name, profession, gov_id, phone_number, address, email, fee, department, brief) 
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (first_name, last_name, profession, gov_id, phone_number, address, email, fee, department, brief))

            mysql.connection.commit()
            flash('Doctor added successfully.', 'success')
            return redirect(url_for('doctors'))

        except Exception as e:
            flash('Failed to add doctor. Please try again.', 'danger')
            print(e)
        finally:
            cur.close()

# Handle Delete Doctor logic
@app.route('/delete_doctor/<gov_id>', methods=['POST'])
def delete_doctor(gov_id):
    cur = mysql.connection.cursor()

    try:
        # Delete doctor from the database by gov_id
        cur.execute("DELETE FROM doctors WHERE gov_id = %s", (gov_id,))
        mysql.connection.commit()

        # Check if any rows were affected
        if cur.rowcount > 0:
            flash('Doctor deleted successfully.', 'success')
        else:
            flash('No doctor found with this Government ID.', 'danger')

    except Exception as e:
        flash('Failed to delete doctor.', 'danger')
        print(e)
    finally:
        cur.close()

    return redirect(url_for('doctors'))  # Redirect back to the doctors page to update the table

@app.route('/dashboard')
def dashboard():
    """Admin Dashboard for viewing appointments."""
    if session.get('user_type') != 'admin':  
        flash('Unauthorized access. Admins only.', 'danger')
        return redirect('/login')  

    cur = mysql.connection.cursor()
    try:
        cur.execute("""
            SELECT a.id AS appointment_id, a.date, a.time, a.status,
                   u.first_name AS patient_first, u.last_name AS patient_last, 
                   u.email AS patient_email, u.phone_number AS patient_phone, u.gov_id AS patient_gov_id,
                   d.id AS doctor_id, d.first_name AS doctor_first, d.last_name AS doctor_last, d.department
            FROM appointments a
            JOIN users u ON a.patient_id = u.id
            JOIN doctors d ON a.doctor_id = d.id
            ORDER BY a.date ASC  -- Sort by date in ascending order                    
        """)
        appointments = cur.fetchall()
    except Exception as e:
        flash('Error fetching data from the database.', 'danger')
        print(e)
        appointments = []
    finally:
        cur.close()
    
    return render_template('dashboard.html', appointments=appointments)

if __name__ == '__main__':
    print("Starting the Flask app...")
    app.run(debug=True)
