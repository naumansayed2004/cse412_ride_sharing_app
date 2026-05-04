## Features

- View all rides (Read)
- Create new ride requests (Insert)
- Update ride status and assign drivers (Update)
- Delete rides (Delete)
- Create new users (Passenger or Driver)
- Dropdown selection for valid IDs (prevents invalid input)
- Status messages for success and error handling

---

## Technology Stack

- **Frontend:** HTML, CSS  
- **Backend:** Python (Flask)  
- **Database:** PostgreSQL  
- **Library:** psycopg2  

---

## Setup Instructions

### 1. Install dependencies

```bash
pip install -r requirements.txt
```

### 2. Setup PostgreSQL Database

#### Step 1: Create database
Run this in pgAdmin Query Tool or psql terminal:
```bash
CREATE DATABASE cse412_group_project;
```

#### Step 2: Load database dump
Run this command in your terminal (psql), not inside pgAdmin.
```bash
psql -U <your_postgres_user> -d cse412_group_project -f database_dump.sql
```
Replace <your_postgres_user> with your PostgreSQL username (e.g., postgres)

This command will automatically:

- Create all tables
- Apply constraints
- Insert sample data

### 3. Configure database connection
Open ```app.py``` and update credentials if needed:
```
dbname="cse412_group_project"
user="<your_postgres_user>"
password="<your_postgres_passsword>"
host="localhost"
port="5432"
```

### 4. Run the application
```bash
python app.py
```

### 5. Open in browser
```
http://127.0.0.1:5000
```

## Notes

- Make sure PostgreSQL is running before executing commands
- Update username and password based on your local setup
- Use pgAdmin or psql terminal to create database
