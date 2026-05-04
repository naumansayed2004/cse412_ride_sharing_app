from flask import Flask, render_template, request, redirect, url_for, flash
import psycopg2

app = Flask(__name__)
app.secret_key = "phase3_secret_key"

def get_connection():
    return psycopg2.connect(
        dbname="cse412_group_project",
        user="postgres",
        password="postgres",
        host="localhost",
        port="5432"
    )

@app.route("/")
def index():
    conn = get_connection()
    cur = conn.cursor()

    cur.execute("SELECT * FROM ride ORDER BY r_rideid;")
    rides = cur.fetchall()

    cur.execute("""
        SELECT p.p_passengerid, u.u_name
        FROM passenger p
        JOIN app_user u ON p.p_userid = u.u_userid
        ORDER BY p.p_passengerid;
    """)
    passengers = cur.fetchall()

    cur.execute("""
        SELECT d.d_driverid, u.u_name
        FROM driver d
        JOIN app_user u ON d.d_userid = u.u_userid
        ORDER BY d.d_driverid;
    """)
    drivers = cur.fetchall()

    cur.execute("SELECT r_rideid FROM ride ORDER BY r_rideid;")
    ride_ids = cur.fetchall()

    cur.close()
    conn.close()

    return render_template(
        "index.html",
        rides=rides,
        passengers=passengers,
        drivers=drivers,
        ride_ids=ride_ids
    )


@app.route("/add_ride", methods=["POST"])
def add_ride():
    passenger_id = request.form["passenger_id"]
    driver_id = request.form["driver_id"]
    pickup = request.form["pickup"]
    dropoff = request.form["dropoff"]
    status = request.form["status"]
    fare = request.form["fare"]
    distance = request.form["distance"]
    duration = request.form["duration"]

    if driver_id == "":
        driver_id = None

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO ride
            (r_passengerid, r_driverid, r_pickuplocation, r_dropofflocation,
             r_requesttime, r_status, r_totalfare, r_distance, r_duration)
            VALUES (%s, %s, %s, %s, NOW(), %s, %s, %s, %s);
        """, (passenger_id, driver_id, pickup, dropoff, status, fare, distance, duration))

        conn.commit()
        flash("Ride added successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash("Error adding ride. Please check the input values.", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))


@app.route("/update_ride", methods=["POST"])
def update_ride():
    ride_id = request.form["ride_id"]
    new_status = request.form["new_status"]
    driver_id = request.form["driver_id"]

    if driver_id == "":
        driver_id = None

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            UPDATE ride
            SET r_status = %s,
                r_driverid = %s
            WHERE r_rideid = %s;
        """, (new_status, driver_id, ride_id))

        conn.commit()

        if cur.rowcount == 0:
            flash("No ride was found with that Ride ID.", "error")
        else:
            flash("Ride updated successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash("Error updating ride. Please check the input values.", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))


@app.route("/delete_ride", methods=["POST"])
def delete_ride():
    ride_id = request.form["ride_id"]

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            DELETE FROM ride
            WHERE r_rideid = %s;
        """, (ride_id,))

        conn.commit()

        if cur.rowcount == 0:
            flash("No ride was found with that Ride ID.", "error")
        else:
            flash("Ride deleted successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash("Error deleting ride. This ride may be connected to payment or rating records.", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))

@app.route("/add_user", methods=["POST"])
def add_user():
    name = request.form["name"]
    email = request.form["email"]
    phone = request.form["phone"]
    password = request.form["password"]
    usertype = request.form["usertype"]

    vehicle_type = request.form.get("vehicle_type")
    vehicle_model = request.form.get("vehicle_model")
    license_plate = request.form.get("license_plate")
    online_status = request.form.get("online_status")

    try:
        conn = get_connection()
        cur = conn.cursor()

        cur.execute("""
            INSERT INTO app_user (u_name, u_email, u_phone, u_password, u_usertype)
            VALUES (%s, %s, %s, %s, %s)
            RETURNING u_userid;
        """, (name, email, phone, password, usertype))

        user_id = cur.fetchone()[0]

        if usertype == "Passenger":
            cur.execute("""
                INSERT INTO passenger (p_userid)
                VALUES (%s);
            """, (user_id,))
        else:
            cur.execute("""
                INSERT INTO driver
                (d_userid, d_vehicletype, d_vehiclemodel, d_licenseplate, d_onlinestatus)
                VALUES (%s, %s, %s, %s, %s);
            """, (user_id, vehicle_type, vehicle_model, license_plate, online_status))

        conn.commit()
        flash("User created successfully.", "success")

    except Exception as e:
        conn.rollback()
        flash("Error creating user. Email might already exist.", "error")

    finally:
        cur.close()
        conn.close()

    return redirect(url_for("index"))


if __name__ == "__main__":
    app.run(debug=True)