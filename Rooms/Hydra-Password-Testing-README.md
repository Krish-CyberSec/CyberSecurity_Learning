# Hydra — Password Brute-Force & Login Testing

> A living notebook for learning **Hydra** and understanding how automated login/password testing works across network services and web forms.
>
> **How to use this README:** Keep adding your own commands, protocol notes, examples, observations, mistakes, and defensive lessons as you learn.

---

# 1. What is Hydra?

**Hydra** is a password-testing tool that can automate authentication attempts against supported services and protocols.

The basic idea is:

```text
Username
   +
Password List
   ↓
Hydra
   ↓
Authentication Service
   ↓
Responses
   ↓
Identify successful / failed attempts
```

Hydra's command syntax changes depending on the **service/protocol** being tested.

Examples include:

- FTP
- SSH
- HTTP forms
- Other supported authentication services

> ⚠️ Use Hydra only against systems you own or environments where you have explicit authorization to perform password testing.

---

# 2. The Core Hydra Pattern

A useful way to understand Hydra commands is:

```text
hydra
  ↓
Username
  ↓
Password list
  ↓
Target
  ↓
Protocol / service
  ↓
Optional settings
```

The exact syntax depends on the protocol.

For example, an FTP test can follow this pattern:

```bash
hydra -l user -P passlist.txt ftp://TARGET
```

Where:

```text
-l  → username
-P  → password list
TARGET → authorized target
ftp:// → service/protocol
```

---

# 3. Important Options

These options appear frequently when working with Hydra:

| Option | Meaning |
|---|---|
| `-l` | Specifies a single username |
| `-L` | Specifies a username list |
| `-p` | Specifies a single password |
| `-P` | Specifies a password list |
| `-t` | Number of parallel tasks/threads |
| `-V` | Verbose output; shows attempts |
| `-s` | Specify a non-default service port |

### Easy memory trick

```text
-l → login/user
-L → Login list
-p → password
-P → Password list
-t → threads
-V → Verbose
-s → service port
```

---

# 4. FTP

For an authorized FTP password test where the username is `user` and the password list is `passlist.txt`:

```bash
hydra -l user -P passlist.txt ftp://TARGET
```

Breakdown:

```text
hydra
   ↓
-l user
   ↓
Use "user" as username

-P passlist.txt
   ↓
Use passwords from passlist.txt

ftp://TARGET
   ↓
Test the FTP service on the authorized target
```

### Mental model

```text
One username
      +
Many candidate passwords
      ↓
FTP authentication testing
```

---

# 5. SSH

SSH authentication testing uses syntax such as:

```bash
hydra -l <username> -P <full-path-to-password-list> TARGET -t 4 ssh
```

Example:

```bash
hydra -l root -P passwords.txt TARGET -t 4 ssh
```

### What happens?

Hydra will:

```text
Username
   ↓
root

Password list
   ↓
passwords.txt

Parallel tasks
   ↓
4

Service
   ↓
SSH
```

It then performs the authentication attempts against the authorized target.

---

# 6. SSH Options Explained

| Option | Meaning |
|---|---|
| `-l root` | Use `root` as the username |
| `-P passwords.txt` | Use passwords from the file |
| `-t 4` | Run four parallel tasks |
| `ssh` | Test the SSH service |
| `TARGET` | Authorized SSH target |

### Important concept: Threads

`-t` controls the number of parallel tasks.

For example:

```text
-t 1
```

means fewer simultaneous attempts.

```text
-t 4
```

means four parallel tasks.

More parallelism can increase speed, but it can also increase load and may trigger security controls.

---

# 7. Web Form Authentication

Hydra can also test web login forms.

Before creating a command, you need to understand how the login request works.

Common HTTP methods include:

```text
GET
POST
```

For a login form, you need information such as:

```text
HTTP method
Login path
Username parameter
Password parameter
How failed authentication is indicated
```

You can inspect the request using browser developer tools/network inspection.

---

# 8. HTTP POST Form Syntax

A POST-form Hydra command follows this general structure:

```bash
hydra -l <username> -P <wordlist> TARGET http-post-form "<path>:<login_credentials>:<invalid_response>"
```

For example:

```bash
hydra -l <username> -P <wordlist> TARGET http-post-form "/:username=^USER^&password=^PASS^:F=incorrect" -V
```

---

# 9. Breaking Down `http-post-form`

This is one of the most important Hydra syntaxes to understand.

```text
http-post-form
```

tells Hydra that the target is a web form using an HTTP POST request.

The quoted section follows:

```text
<path>:<login_credentials>:<invalid_response>
```

Think:

```text
WHERE?
  ↓
WHAT?
  ↓
HOW DO I KNOW IT FAILED?
```

---

# 10. The Path

Example:

```text
/
```

This means the form is located at the site's root path.

Another example could look like:

```text
/login.php
```

So:

```text
http-post-form "/login.php:..."
```

would indicate a form at that path.

---

# 11. Login Credentials

Example:

```text
username=^USER^&password=^PASS^
```

The placeholders are important.

```text
^USER^
```

is replaced with the username supplied to Hydra.

```text
^PASS^
```

is replaced with each password from the password list.

So conceptually:

```text
username=^USER^
        ↓
username=<candidate username>

password=^PASS^
        ↓
password=<candidate password>
```

---

# 12. Invalid Response

Hydra needs a way to recognize a failed login.

Example:

```text
F=incorrect
```

This tells Hydra that a response containing:

```text
incorrect
```

indicates authentication failure.

Conceptually:

```text
Request
   ↓
Server response
   ↓
Contains "incorrect"?
   ├── YES → Failure
   └── NO  → Potentially successful / investigate
```

### Important

The failure string must actually correspond to the application's behavior.

Don't blindly copy:

```text
F=incorrect
```

from another application.

First understand what the application returns when authentication fails.

---

# 13. Verbose Mode

The option:

```bash
-V
```

enables verbose output.

It can help you see individual attempts while testing.

Example:

```bash
hydra -l <username> -P <wordlist> TARGET http-post-form "/:username=^USER^&password=^PASS^:F=incorrect" -V
```

Mental model:

```text
Normal output
    ↓
Less detail

-V
    ↓
More visibility into attempts
```

Verbose output can be useful while learning because you can see how Hydra is processing the test.

---

# 14. Non-Default Ports

Sometimes a web service is not running on its standard port.

Hydra can explicitly specify a port with:

```bash
-s <port>
```

Example:

```bash
hydra -l <username> -P <wordlist> TARGET http-post-form "/:username=^USER^&password=^PASS^:F=incorrect" -s <port> -V
```

Conceptually:

```text
Target
  +
Custom port
  ↓
Connect to the specified service location
```

---

# 15. How to Understand a Web Form Before Using Hydra

Don't start with the Hydra command.

Start with the HTTP request.

Ask:

```text
1. What URL/path receives the login request?

2. Is the request GET or POST?

3. What is the username field called?

4. What is the password field called?

5. Does the request contain additional parameters?

6. How does a failed login appear in the response?

7. Is there a CSRF token?

8. Does the application require a session cookie?

9. Is there rate limiting or lockout?
```

This is the **cybersecurity mindset** behind the command.

---

# 16. Example: Understanding a POST Login

Imagine a form submits:

```http
POST /login.php HTTP/1.1
Host: example.test
Content-Type: application/x-www-form-urlencoded

username=alice&password=test123
```

The important pieces are:

```text
Path:
    /login.php

Method:
    POST

Username parameter:
    username

Password parameter:
    password
```

A Hydra-style form definition therefore needs to represent:

```text
/login.php
:
username=^USER^&password=^PASS^
:
<failure indicator>
```

The point is to map Hydra's syntax to the application's actual HTTP request.

---

# 17. GET vs POST

## GET

Data is commonly included in the URL:

```text
/login?username=alice&password=test123
```

## POST

Data is commonly included in the request body:

```text
username=alice&password=test123
```

### Why this matters

Hydra needs to know which kind of HTTP request the application expects.

So before testing a web form:

```text
Inspect request
      ↓
Identify HTTP method
      ↓
Identify parameters
      ↓
Identify failure behavior
      ↓
Build the appropriate Hydra syntax
```

---

# 18. Hydra vs Repeater

Hydra and Burp Repeater are useful for different jobs.

| Tool | Best for |
|---|---|
| **Burp Repeater** | Manual experimentation |
| **Hydra** | Automated authentication attempts |
| **Burp Proxy** | Capturing/inspecting HTTP traffic |
| **Intruder** | Controlled HTTP input variation |

A useful workflow can be:

```text
Browser
   ↓
Burp Proxy
   ↓
Understand login request
   ↓
Burp Repeater
   ↓
Confirm application behavior
   ↓
Hydra
   ↓
Authorized automated testing
```

---

# 19. Common Mistakes

## Mistake 1 — Wrong username parameter

You might assume:

```text
username=
```

but the application actually uses:

```text
user=
```

Always inspect the real request.

---

## Mistake 2 — Wrong password parameter

Same problem:

```text
password=
```

may actually be:

```text
passwd=
```

---

## Mistake 3 — Wrong failure string

If the application returns:

```text
Invalid credentials
```

but you configure:

```text
F=incorrect
```

Hydra may not correctly identify failures.

---

## Mistake 4 — Wrong path

The form might be:

```text
/login
```

rather than:

```text
/
```

---

## Mistake 5 — Ignoring CSRF/session requirements

Modern applications may require additional values such as:

```text
CSRF token
Session cookie
Hidden form field
Other dynamic parameters
```

A simple username/password request may therefore not be enough.

---

## Mistake 6 — Too many threads

Increasing:

```text
-t
```

is not automatically better.

High concurrency can:

- Increase server load
- Trigger rate limits
- Trigger account lockouts
- Make testing noisy
- Produce unreliable results

Use controlled settings in authorized environments.

---

# 20. Defensive Security Perspective

Hydra is useful not only for learning offensive techniques.

It also helps you understand why applications need protections against automated authentication attempts.

Important defenses include:

```text
Rate limiting
Account lockout / throttling
Strong passwords
Multi-factor authentication
CAPTCHA where appropriate
IP/device monitoring
Authentication logging
Alerting
Detection of abnormal login patterns
```

The attack model:

```text
Many authentication attempts
          ↓
Potential password discovery
```

The defensive model:

```text
Detect unusual attempts
          ↓
Throttle / block
          ↓
Alert
          ↓
Protect account
```

---

# 21. Hydra Learning Checklist

## Fundamentals

- [ ] Understand Hydra's purpose
- [ ] Understand username vs password lists
- [ ] Understand protocols/services
- [ ] Understand `-l`
- [ ] Understand `-L`
- [ ] Understand `-p`
- [ ] Understand `-P`
- [ ] Understand `-t`
- [ ] Understand `-V`
- [ ] Understand `-s`

## Services

- [ ] FTP
- [ ] SSH
- [ ] HTTP forms
- [ ] Other supported services

## Web Forms

- [ ] Understand GET
- [ ] Understand POST
- [ ] Identify login path
- [ ] Identify username parameter
- [ ] Identify password parameter
- [ ] Identify failure response
- [ ] Understand CSRF/session requirements

## Defensive Concepts

- [ ] Rate limiting
- [ ] Account lockout
- [ ] MFA
- [ ] Authentication logging
- [ ] Detection and alerting

---

# 22. My Hydra Notes

> Add your own observations here.

## Command I Learned

```bash

```

### What it does

```text

```

### Options

| Option | Meaning | My Notes |
|---|---|---|
| | | |
| | | |
| | | |

### What I observed

```text

```

### Mistake I made

```text

```

### What fixed it

```text

```

---

# 23. Protocol Notes Template

Copy this whenever you learn Hydra with a new protocol.

```markdown
## [Protocol / Service]

### What is it?

Explain the service.

### Hydra syntax

```bash
hydra ...
```

### Important options

| Option | Meaning |
|---|---|
| | |
| | |

### What does Hydra send?

```text

```

### What indicates success/failure?

```text

```

### Common mistakes

- 
- 
- 

### Defensive protections

- 
- 
- 

### My notes

- 
- 
- 
```

---

# 24. Web Form Testing Template

Use this whenever you encounter a new login form in an authorized lab.

```markdown
## Web Login Form

### URL/path

```text

```

### HTTP method

```text
GET / POST
```

### Username parameter

```text

```

### Password parameter

```text

```

### Additional parameters

```text

```

### Failure indicator

```text

```

### Session/cookies required?

```text
Yes / No
```

### CSRF token?

```text
Yes / No
```

### Rate limiting?

```text
Unknown / Yes / No
```

### Notes

```text

```
```

---

# 25. Quick Revision Cheat Sheet

```text
HYDRA
│
├── -l USER       → Single username
├── -L USERS      → Username list
├── -p PASS       → Single password
├── -P WORDLIST   → Password list
├── -t N          → Parallel tasks
├── -V            → Verbose output
└── -s PORT       → Custom service port
```

### Service model

```text
hydra
  ↓
Credentials
  ↓
Target
  ↓
Protocol
  ↓
Optional settings
```

### Web POST form model

```text
http-post-form
       ↓
   <path>
       ↓
   <credentials>
       ↓
   <failure indicator>
```

Remember:

```text
^USER^ → username placeholder
^PASS^ → password placeholder
F=...  → failure condition
```

---

# 26. Final Mental Model

Hydra is easiest to understand when you stop thinking of it as "a command to memorize."

Think:

```text
                 HYDRA
                   │
                   ↓
        Automated authentication
                   │
        ┌──────────┴──────────┐
        ↓                     ↓
     Network               Web Form
     Service                Login
        │                     │
      SSH/FTP             GET/POST
        │                     │
        └──────────┬──────────┘
                   ↓
            Candidate inputs
                   ↓
              Responses
                   ↓
          Analyze the result
```

The most important skill is understanding **what the application expects**.

For a network service:

```text
Which protocol?
Which username?
Which password list?
Which port?
```

For a web form:

```text
Which path?
Which HTTP method?
Which parameters?
What indicates failure?
Are session/CSRF values required?
```

---

# 27. Final Takeaways

1. Hydra automates authentication testing across supported services.
2. The command syntax depends on the protocol being tested.
3. `-l` specifies a username; `-P` specifies a password list.
4. `-t` controls parallel tasks.
5. `-V` provides verbose output.
6. `-s` allows a custom port.
7. Web-form testing requires understanding the actual HTTP request.
8. `^USER^` represents the username placeholder.
9. `^PASS^` represents the password placeholder.
10. `F=...` defines a failure indicator for a web form.
11. Understanding HTTP is more important than memorizing Hydra syntax.
12. Always account for sessions, CSRF tokens, rate limits, and lockouts.
13. The same knowledge can be used defensively to design and detect protections against automated login attempts.

---

# 28. Future Content

This section is intentionally left open.

Add topics as you learn them:

- [ ] Hydra installation
- [ ] Hydra help/manual
- [ ] More protocols
- [ ] Username lists
- [ ] Password-list preparation
- [ ] Custom ports
- [ ] Web form analysis
- [ ] CSRF-protected forms
- [ ] Session-based authentication
- [ ] Rate limiting
- [ ] Account lockout behavior
- [ ] Authentication logging
- [ ] Detection rules
- [ ] Defensive monitoring
- [ ] CTF notes
- [ ] Lab notes
- [ ] Interview questions
- [ ] My own Hydra cheat sheet

---

# 29. Lab Safety

Only perform password-testing activities against:

- Your own systems
- Intentionally vulnerable machines
- CTF environments
- Security training labs
- Systems where you have explicit authorization

Password testing against real systems without permission can cause account lockouts, service disruption, alerts, or unauthorized access.

Use Hydra to **learn how authentication security works**, not to attack systems you do not own.

---

> **My rule:** First understand the authentication request manually. Then automate only the testing that is authorized and necessary.
