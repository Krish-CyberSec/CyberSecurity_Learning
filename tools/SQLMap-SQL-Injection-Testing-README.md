# SQLMap — SQL Injection Testing & Database Enumeration

> A practical, beginner-friendly guide to understanding SQLMap, SQL injection testing, request handling, and database enumeration.

---

## ⚠️ Legal & Safety First

SQLMap is a powerful security testing tool. Use it **only on applications you own or have explicit permission to test**, such as a local lab, CTF environment, or authorized security assessment.

The commands in this README are intended for controlled environments.

---

# 1. What is SQLMap?

**SQLMap** is an automated tool for detecting and exploiting **SQL injection (SQLi)** vulnerabilities in web applications.

Instead of manually testing many SQL injection payloads, SQLMap automates much of the process:

```text
Find parameter
     ↓
Test whether it is injectable
     ↓
Identify injection technique
     ↓
Identify database
     ↓
Enumerate databases
     ↓
Enumerate tables
     ↓
Retrieve authorized test data
```

### Simple analogy

Think of a web application like a restaurant:

- **URL/form parameter** → order form
- **Backend application** → waiter
- **Database** → kitchen
- **SQL query** → order sent to the kitchen
- **SQL injection** → manipulating the order so the kitchen performs something unintended
- **SQLMap** → automated security tester checking whether the ordering system can be manipulated

---

# 2. Why SQL Injection Happens

A vulnerable application may construct SQL queries using untrusted input.

Conceptually:

```text
User input
   ↓
Application
   ↓
SQL query
   ↓
Database
```

If input is inserted into a query without proper parameterization, the input may change the meaning of the query.

Secure applications should use:

- Parameterized queries / prepared statements
- Appropriate input handling
- Least-privilege database accounts
- Safe error handling

---

# 3. Starting SQLMap

SQLMap is a command-line tool.

Show available options:

```bash
sqlmap --help
```

For beginners, SQLMap also provides an interactive wizard:

```bash
sqlmap --wizard
```

The wizard asks questions interactively, making it easier to understand the basic workflow before memorizing options.

---

# 4. SQLMap Testing Workflow

A useful mental model:

```text
Target request
      │
      ▼
Injection testing
      │
      ▼
Injection point
      │
      ▼
DBMS identification
      │
      ▼
Database enumeration
      │
      ▼
Table enumeration
      │
      ▼
Authorized data retrieval
```

Don't think of SQLMap as simply a "database dumping tool."

Its first job is determining whether an input is injectable and what type of SQL injection may be possible.

---

# 5. Testing a GET Parameter

Many applications use parameters in URLs.

Example:

```text
https://lab.example/search?cat=1
```

Here:

```text
/search
   └── cat=1
       └── parameter
```

An authorized test can target that parameter:

```bash
sqlmap -u "https://lab.example/search?cat=1"
```

### Important

A GET parameter is **not automatically vulnerable**.

The presence of:

```text
?id=1
```

does not prove SQL injection exists. The application has to be tested.

---

# 6. Understanding SQLMap Results

SQLMap may report that a parameter is injectable and identify different SQL injection techniques.

The source material demonstrates four major categories.

## 6.1 Boolean-Based Blind SQL Injection

The application behaves differently depending on whether a condition is true or false.

```text
Condition TRUE  → response A
Condition FALSE → response B
```

The tester infers information from application behavior rather than directly seeing the database result.

---

## 6.2 Error-Based SQL Injection

The application/database generates an error that may reveal information.

```text
Manipulated input
      ↓
Database error
      ↓
Application response
      ↓
Potential database information
```

This depends on how database errors are handled by the application.

---

## 6.3 Time-Based Blind SQL Injection

The application may not return useful data directly.

Instead, a measurable delay can be used as an indication that a condition was satisfied.

```text
Condition false → normal response
Condition true  → delayed response
```

The tester can infer information from response timing.

---

## 6.4 UNION-Based SQL Injection

UNION-based injection attempts to combine the application's query with another query so information can potentially be returned through the application's normal output.

Conceptually:

```text
Original query
      +
Additional SELECT
      ↓
Combined result
```

Column count and data compatibility matter.

---

# 7. DBMS Identification

SQLMap can often identify the backend database management system.

For example:

```text
MySQL
```

Other database technologies include:

- PostgreSQL
- Microsoft SQL Server
- Oracle
- SQLite

Knowing the DBMS matters because SQL syntax and behavior can differ between database systems.

---

# 8. Enumerating Databases

Once an injection point has been confirmed in an authorized environment, SQLMap can enumerate database names.

```bash
sqlmap -u "https://lab.example/search?cat=1" --dbs
```

Mental model:

```text
Web parameter
     ↓
SQL injection
     ↓
DBMS
     ↓
Database names
```

Example conceptual result:

```text
available databases:
- users
- members
```

---

# 9. Enumerating Tables

After identifying a database, specify it with:

```text
-D <database_name>
```

and request table enumeration with:

```text
--tables
```

Example:

```bash
sqlmap -u "https://lab.example/search?cat=1" -D users --tables
```

Conceptually:

```text
Database
   ↓
Tables
   ↓
Columns
   ↓
Records
```

### Remember

A **database** and a **table** are different things.

Example:

```text
users
│
├── accounts
├── profiles
└── sessions
```

---

# 10. Retrieving Records from a Table

To work with a specific table:

```text
-D <database>
-T <table>
```

The `--dump` option can retrieve table records in an authorized testing environment.

Example:

```bash
sqlmap -u "https://lab.example/search?cat=1" \
-D users \
-T test_table \
--dump
```

Database extraction can expose:

- User accounts
- Email addresses
- Application data
- Session information
- Password hashes
- Business records

Use test data whenever possible and follow the agreed scope of a security assessment.

---

# 11. SQLMap Command Cheat Sheet

| Goal | Option |
|---|---|
| Show help | `--help` |
| Beginner wizard | `--wizard` |
| Specify URL | `-u` |
| Enumerate databases | `--dbs` |
| Select database | `-D` |
| Enumerate tables | `--tables` |
| Select table | `-T` |
| Retrieve table records | `--dump` |
| Supply session cookies | `--cookie` |
| Use an intercepted request | `-r` |

---

# 12. Authenticated Testing with Cookies

Some functionality exists only after login.

A normal browser request may contain a session cookie such as:

```text
SESSIONID=...
```

SQLMap can be given cookies with:

```bash
--cookie="SESSIONID=example"
```

Conceptually:

```text
Browser
   ↓
Login
   ↓
Session cookie
   ↓
Authenticated request
   ↓
SQLMap
   ↓
Authorized security test
```

Example structure:

```bash
sqlmap -u "https://lab.example/profile?id=1" \
--cookie="SESSIONID=authorized-test-session"
```

Use only an authorized test account/session.

---

# 13. GET vs POST Testing

SQL injection is not limited to URL parameters.

Applications can also send input through HTTP POST requests.

### GET

```text
/search?cat=1
```

### POST

```http
POST /login HTTP/1.1
Content-Type: application/x-www-form-urlencoded

username=test&password=test
```

The security principle is the same:

```text
User-controlled input
        ↓
Application
        ↓
SQL query
        ↓
Database
```

---

# 14. Testing an Intercepted POST Request

For POST-based testing, an intercepted request can be saved into a text file and supplied to SQLMap.

```bash
sqlmap -r intercepted_request.txt
```

A request file can preserve details such as:

- HTTP method
- URL
- Headers
- Cookies
- Request body
- Parameters

This is useful for authenticated or more complex requests.

---

# 15. SQLMap + Burp Suite Mental Model

A common authorized workflow:

```text
Browser
   │
   ▼
Burp Suite
   │
   ├── Capture request
   │
   ▼
Request file
   │
   ▼
SQLMap
   │
   ▼
SQL injection testing
```

**Burp Suite** helps inspect and capture HTTP requests.

**SQLMap** automates SQL injection testing against those requests.

They solve different parts of the workflow.

---

# 16. What SQLMap Is Actually Doing

Don't memorize commands blindly.

Think through the process:

### Step 1 — Find input

```text
?id=1
```

### Step 2 — Determine whether it is dynamic

Does changing the parameter affect the application's response?

### Step 3 — Test injection techniques

SQLMap may test:

```text
Boolean-based
Error-based
Time-based
UNION-based
```

### Step 4 — Fingerprint the DBMS

Example:

```text
MySQL
```

### Step 5 — Enumerate

```text
Databases
   ↓
Tables
   ↓
Columns
   ↓
Records
```

This is the core mental model.

---

# 17. Safe Practice Scenario

Use a deliberately vulnerable application in a local or otherwise authorized environment.

```text
┌──────────────────────────┐
│ Vulnerable Web App       │
│ Local / isolated lab     │
└────────────┬─────────────┘
             │
             ▼
       HTTP Request
             │
             ▼
        SQL Parameter
             │
             ▼
       Test with SQLMap
             │
             ▼
       Observe Results
```

Use only synthetic/test data.

---

# 18. Common Mistakes

## Mistake 1 — Assuming Every Parameter Is SQLi

```text
?id=1
```

does not automatically mean:

```text
SQL injection
```

Always verify.

## Mistake 2 — Forgetting Authentication

A page may require a session.

Without the correct authorized cookie:

```text
SQLMap → login page / redirect / access denied
```

rather than:

```text
SQLMap → intended functionality
```

## Mistake 3 — Confusing GET and POST

If the parameter is inside the request body, simply testing the URL may not test the intended input.

Understand the HTTP request first.

## Mistake 4 — Dumping Data Without Understanding Impact

Database extraction can expose sensitive information.

In professional testing, minimize data access and follow the agreed scope.

## Mistake 5 — Treating SQLMap as a Magic Button

SQLMap automates testing, but you still need to understand:

- HTTP
- Parameters
- SQL
- Databases
- Authentication
- Sessions
- Injection techniques
- Application behavior

---

# 19. SQL Injection Defense

Understanding SQLMap should also teach you how to defend applications.

## Parameterized Queries

Prefer:

```text
Prepared statement
       ↓
User input treated as data
```

instead of:

```text
String concatenation
       ↓
User input becomes part of SQL syntax
```

## Least Privilege

The application's database account should have only the permissions it actually needs.

```text
Web application
      ↓
Limited DB account
      ↓
Required permissions only
```

## Safe Error Handling

Avoid exposing detailed database errors to users.

Instead of showing query/database details, return a generic error and log useful diagnostic information securely.

## Defense-in-Depth

Use:

- Parameterized queries
- Secure ORM usage
- Appropriate input validation
- Least-privilege DB accounts
- Safe error handling
- Monitoring and logging
- Regular security testing

Input validation alone should not be treated as the primary SQL injection defense.

---

# 20. SQLMap vs Manual Testing

| Approach | Main purpose |
|---|---|
| Manual SQLi testing | Understand application and SQL behavior |
| Burp Suite | Inspect/manipulate HTTP requests |
| SQLMap | Automate SQL injection testing |
| Database logs | Defensive visibility |
| WAF | Additional protective layer |

A strong security tester knows when automation helps and when manual investigation is necessary.

---

# 21. Cybersecurity Mindset

When you see:

```text
/search?cat=1
```

don't immediately think:

> Run SQLMap.

Think:

```text
What is this parameter?
        ↓
Where does it go?
        ↓
Does it influence a database query?
        ↓
How does the application respond to input changes?
        ↓
Is this within my authorization?
        ↓
What testing method is appropriate?
```

That's the difference between **command memorization** and **security understanding**.

---

# 22. Practical Learning Checklist

### SQL Fundamentals

- [ ] Understand SELECT
- [ ] Understand WHERE
- [ ] Understand UNION
- [ ] Understand database/table/column concepts
- [ ] Understand SQL errors
- [ ] Understand prepared statements

### Web Fundamentals

- [ ] Understand GET
- [ ] Understand POST
- [ ] Understand cookies
- [ ] Understand sessions
- [ ] Understand HTTP headers
- [ ] Understand request bodies

### SQL Injection

- [ ] Understand SQL injection
- [ ] Understand boolean-based blind SQLi
- [ ] Understand error-based SQLi
- [ ] Understand time-based blind SQLi
- [ ] Understand UNION-based SQLi
- [ ] Understand why parameterization prevents SQLi

### SQLMap

- [ ] `--help`
- [ ] `--wizard`
- [ ] `-u`
- [ ] `--dbs`
- [ ] `-D`
- [ ] `--tables`
- [ ] `-T`
- [ ] `--dump`
- [ ] `--cookie`
- [ ] `-r`

---

# 23. Quick Revision

```text
SQLMap
│
├── Automated SQL injection testing
│
├── Input sources
│   ├── GET parameters
│   └── POST requests
│
├── Authentication
│   └── Cookies
│
├── Injection techniques
│   ├── Boolean-based blind
│   ├── Error-based
│   ├── Time-based blind
│   └── UNION-based
│
└── Enumeration
    ├── Databases
    ├── Tables
    └── Records
```

### Core commands

```bash
sqlmap --help
sqlmap --wizard

sqlmap -u "URL"

sqlmap -u "URL" --dbs

sqlmap -u "URL" -D database --tables

sqlmap -u "URL" -D database -T table --dump

sqlmap -u "URL" --cookie="SESSION=authorized-test-session"

sqlmap -r intercepted_request.txt
```

---

# 24. Final Mental Model

Remember:

```text
HTTP
  ↓
Parameter
  ↓
Application
  ↓
SQL Query
  ↓
Database
```

If untrusted input can alter the SQL query:

```text
User Input
     ↓
Unsafe SQL Construction
     ↓
SQL Injection
     ↓
Database Access
```

SQLMap automates the investigation of this class of vulnerability.

But the real skill isn't knowing:

```bash
sqlmap -u ...
```

The real skill is understanding **why the request is interesting, how the application processes it, what the database is doing, what the result means, and how the vulnerability should be fixed.**

---

# 25. Future Topics to Add

- [ ] SQL injection manually from scratch
- [ ] SQL syntax revision
- [ ] Prepared statements
- [ ] SQLMap advanced options
- [ ] POST request testing
- [ ] Authenticated SQLMap testing
- [ ] API SQL injection
- [ ] JSON request testing
- [ ] Second-order SQL injection
- [ ] Out-of-band SQL injection
- [ ] SQL injection detection
- [ ] SQLMap output interpretation
- [ ] SQL injection remediation
- [ ] WAF behavior
- [ ] SQL injection logging and detection

---

# 26. Personal Notes

## New Concept

```text
Concept:
What I learned:
Example:
Why it matters:
```

## Command I Learned

```text
Command:

Purpose:

Important options:

Example in my lab:

Result:
```

## Vulnerability Analysis

```text
Entry point:

HTTP method:

Parameter:

Authentication required:

Observed behavior:

Injection type:

DBMS:

Impact:

Root cause:

Fix:
```

---

## One-Line Takeaway

> **SQLMap automates SQL injection testing, but understanding HTTP + SQL + databases is what makes you effective at using it.**
