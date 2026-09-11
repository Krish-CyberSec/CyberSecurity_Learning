# Web Applications, HTTP & Web Security

# 1. The Big Picture — Web Application as a Planet 🌍

Imagine a web application as a planet.

You can see the **surface** through your browser, but lots of important things exist underneath.

```text
                 WEB APPLICATION 🌍
                       |
        +--------------+--------------+
        |              |              |
    Front End       Back End     Infrastructure
        |              |              |
   HTML/CSS/JS     Database       Web Server
                                  Networking
                                      |
                                     WAF
```

The browser shows the surface. The backend and infrastructure make that surface actually work.

---

# 2. Front End

The **front end** is what the user sees and interacts with.

Main technologies:

- HTML
- CSS
- JavaScript

Think:

```text
Front End = What I see + what I interact with
```

---

## HTML — Structure

HTML (HyperText Markup Language) tells the browser what to display.

```html
<h1>Hello World</h1>
<p>Welcome to my website.</p>
<button>Login</button>
```

### Easy analogy

```text
HTML = Skeleton
```

It provides the basic structure: headings, paragraphs, buttons, images, forms, etc.

---

## CSS — Appearance

CSS (Cascading Style Sheets) controls how the website looks.

```css
h1 {
    font-size: 40px;
}

button {
    border-radius: 8px;
}
```

It controls colours, fonts, sizes, layout, and appearance.

```text
HTML = Structure
CSS  = Appearance
```

---

## JavaScript — Brain

JavaScript allows the webpage to perform more complex actions and respond to interaction.

```javascript
if (userLoggedIn) {
    showDashboard();
}
```

```text
HTML       = Skeleton
CSS        = Appearance
JavaScript = Brain
```

This is a useful mental model to remember.

---

# 3. Back End

The **back end** contains the parts of the application the user normally does not directly see.

```text
Browser
   |
   v
Front End
   |
   v
Back End
   |
   +---- Database
   +---- Application logic
   +---- Web server
```

The backend processes requests, handles application logic, and works with data.

---

# 4. Database

A **database** stores, modifies, and retrieves information.

Example:

```text
User
 ├── Name
 ├── Preferences
 ├── Account information
 └── Other application data
```

Typical flow:

```text
You change a setting
       ↓
Browser sends request
       ↓
Backend processes it
       ↓
Database stores the value
       ↓
Backend responds
       ↓
Browser shows the result
```

### Easy analogy

```text
Database = Library / Storage room
```

The application can store, read, modify, and retrieve data.

---

# 5. Infrastructure

Web applications also depend on infrastructure such as:

- Web servers
- Application servers
- Storage
- Networking devices
- Supporting software

Think of infrastructure as the **roads, vehicles, and fuel** that allow the web application ecosystem to function.

```text
User
 ↓
Internet
 ↓
Networking
 ↓
Web Server
 ↓
Application
 ↓
Database
```

---

# 6. WAF — Web Application Firewall

A **WAF** is an optional security component that helps filter dangerous requests before they reach the web server.

```text
Internet
    |
    v
   WAF
    |
    v
Web Server
```

### Easy analogy

Think of a WAF as a **security checkpoint**:

```text
Visitor
   ↓
Security Check
   ↓
Allowed? ── Yes ──> Application
   |
   No
   ↓
Blocked
```

A WAF is an additional layer of protection, not a replacement for secure application design.

---

# 7. Putting Everything Together

```text
                    USER
                      |
                      v
                 WEB BROWSER
                      |
              +---------------+
              |   FRONT END   |
              | HTML CSS JS   |
              +---------------+
                      |
                      v
              +---------------+
              |      WAF      |
              +---------------+
                      |
                      v
              +---------------+
              |  WEB SERVER   |
              +---------------+
                      |
                      v
              +---------------+
              | BACKEND / APP |
              +---------------+
                      |
                      v
              +---------------+
              |    DATABASE   |
              +---------------+
```

This is the basic architecture to keep in your head before learning web application security.

---

# 8. What is a URL?

URL stands for **Uniform Resource Locator**.

Example:

```text
https://example.com:443/products?id=10#reviews
```

A URL can contain several components:

```text
https://example.com:443/products?id=10#reviews
  |       |          |       |        |
scheme   host       port    query   fragment
```

Understanding these parts is important for browsing, development, troubleshooting, and web security.

---

## Scheme

The scheme specifies the protocol.

Common examples:

```text
http
https
```

Example:

```text
https://example.com
```

Here `https` is the scheme.

---

## Host / Domain

The host tells the browser which website/server it is trying to reach.

```text
https://example.com
        ^^^^^^^^^^^
           Host
```

### Cybersecurity point — Typosquatting

Attackers can register domains that look similar to legitimate ones:

```text
realbank.com
rea1bank.com
```

A tiny visual difference can be used in phishing.

**Habit:** when opening a login page, check the actual domain — not just the page design.

---

## Port

A port identifies a service endpoint on a host.

```text
https://example.com:443
                  ^^^
                 Port
```

Ports range from:

```text
1 - 65535
```

Common web ports:

```text
80  → HTTP
443 → HTTPS
```

### Easy analogy

```text
Server = Building

Port 80  = Door 80
Port 443 = Door 443
```

---

## Path

The path identifies the requested resource.

```text
https://example.com/products/123
                       ^^^^^^^^^^^
                           Path
```

Examples:

```text
/page
/products
/users/123
/api/users
```

### Security perspective

Sensitive paths must have proper access control. A user should not gain access simply by changing a URL.

---

## Query String

The query string starts with `?`.

Example:

```text
https://example.com/search?q=cybersecurity
```

It is commonly used for search terms, filters, and parameters.

Users can modify these values:

```text
?id=10
```

could become:

```text
?id=11
```

The application must validate input and enforce authorization. Never assume a browser-supplied value is trustworthy.

---

## Fragment

A fragment starts with `#`.

```text
https://example.com/docs#authentication
```

It commonly points to a particular section of a page:

```text
#login
#about
#contact
```

---

# 9. Full URL Example

Let's break this apart:

```text
https://example.com:443/products?id=10#reviews
```

```text
https       → Scheme
example.com → Host
443         → Port
/products   → Path
id=10       → Query
reviews     → Fragment
```

Mental model:

```text
https://example.com:443/products?id=10#reviews
  |         |       |       |       |
  |         |       |       |       +-- Fragment
  |         |       |       +---------- Query
  |         |       +------------------ Path
  |         +-------------------------- Port
  +------------------------------------ Scheme + Host
```

---

# 10. HTTP Messages

HTTP messages are how a client and web server communicate.

There are two main types:

```text
HTTP Request
HTTP Response
```

Think of it like a conversation:

```text
Browser: "Give me this page."
           ↓
        REQUEST
           ↓
        SERVER
           ↓
        RESPONSE
           ↓
Browser: "Here is the page."
```

---

# 11. HTTP Request

An HTTP request is sent by the client to the server.

Example:

```http
GET /login HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0
```

The request tells the server what the client wants.

---

# 12. HTTP Response

The server sends an HTTP response back.

Example:

```http
HTTP/1.1 200 OK
Content-Type: text/html

<html>
    ...
</html>
```

The response tells the client what happened and may contain the requested content.

---

# 13. HTTP Message Structure

Every HTTP message can be understood as:

```text
Start Line
   ↓
Headers
   ↓
Empty Line
   ↓
Body
```

Example:

```http
POST /login HTTP/1.1
Host: example.com
Content-Type: application/json

{"username":"alex","password":"example"}
```

Breakdown:

```text
POST /login HTTP/1.1   ← Start Line
Host: example.com      ← Header
Content-Type: ...      ← Header
                       ← Empty Line
{"username":...}       ← Body
```

---

# 14. HTTP Request Methods

HTTP methods tell the server what action the client wants to perform.

---

## GET

Used to retrieve data.

```http
GET /products HTTP/1.1
```

Meaning:

> "Give me the products."

**Security reminder:** avoid putting sensitive information such as secrets in GET URLs because URLs may appear in logs, history, analytics, or other places.

---

## POST

Used to send data.

```http
POST /login HTTP/1.1
Content-Type: application/json

{
    "username": "alex",
    "password": "example"
}
```

Think:

> "Here is some data for the server to process."

Input should be properly validated and handled to reduce risks such as SQL injection and XSS.

---

## PUT

Usually used to replace or update a resource.

```http
PUT /users/123 HTTP/1.1
```

Security question:

> Is this user actually authorized to modify user 123?

---

## DELETE

Used to delete a resource.

```http
DELETE /users/123 HTTP/1.1
```

Security question:

> Is the current user allowed to delete this resource?

---

## PATCH

Updates part of a resource.

```http
PATCH /users/123
```

Useful when only specific fields need changing.

---

## HEAD

Similar to GET, but retrieves headers rather than the full response body. Useful for checking metadata.

---

## OPTIONS

Can tell a client which HTTP methods are supported for a resource.

---

## TRACE

Used for diagnostic purposes. It is often disabled depending on server configuration and security requirements.

---

## CONNECT

Used to establish a tunnel, commonly in proxy scenarios.

---

# 15. HTTP Method Security Mindset

Whenever you see a request, ask:

```text
What action is being requested?
          ↓
Who is requesting it?
          ↓
Are they authorized?
          ↓
Is the input trusted?
          ↓
What data will be affected?
```

For:

```http
DELETE /users/123
```

Don't only think "DELETE request."

Think:

> "Who is allowed to delete user 123?"

That is the cybersecurity mindset.

---

# 16. HTTP Versions

| Version | Key idea |
|---|---|
| HTTP/0.9 | Early version; GET only |
| HTTP/1.0 | Added headers and improved content handling |
| HTTP/1.1 | Persistent connections and other improvements |
| HTTP/2 | Multiplexing, header compression, prioritization |
| HTTP/3 | Uses QUIC and modern web transport |

The important point: HTTP has evolved to improve performance and communication capabilities.

---

# 17. Request Headers

Headers provide additional information about an HTTP request.

Example:

```http
Host: example.com
User-Agent: Mozilla/5.0
Cookie: session=abc123
Content-Type: application/json
```

---

## Important Request Headers

| Header | Example | Purpose |
|---|---|---|
| `Host` | `Host: example.com` | Identifies the intended host |
| `User-Agent` | `User-Agent: Mozilla/5.0` | Describes the client/browser |
| `Referer` | `Referer: https://example.com/` | Indicates where the request came from |
| `Cookie` | `Cookie: session=abc123` | Sends stored cookie data |
| `Content-Type` | `Content-Type: application/json` | Describes the request body format |

---

# 18. HTTP Request Body

Requests such as POST and PUT can send data in the body.

Common formats:

```text
URL encoded
Form data
JSON
XML
```

---

## URL-Encoded Data

Content type:

```text
application/x-www-form-urlencoded
```

Example:

```http
POST /profile HTTP/1.1
Content-Type: application/x-www-form-urlencoded

name=Alex&age=27&country=US
```

Structure:

```text
key=value&key=value
```

---

## Form Data

Content type:

```text
multipart/form-data
```

This can send multiple data blocks and binary data such as files.

Conceptually:

```text
Text field
    +
File
    +
Other fields
```

---

## JSON

Content type:

```text
application/json
```

Example:

```http
POST /api/user HTTP/1.1
Content-Type: application/json

{
    "name": "Alex",
    "age": 27,
    "country": "US"
}
```

JSON is extremely common in modern web applications and APIs.

---

## XML

Content type:

```text
application/xml
```

Example:

```xml
<user>
    <name>Alex</name>
    <age>27</age>
    <country>US</country>
</user>
```

XML structures information using nested opening and closing tags.

---

# 19. HTTP Response

A server sends a response after processing a request.

Example:

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "message": "Success"
}
```

The response contains:

```text
Status Line
Headers
Empty Line
Body
```

---

# 20. HTTP Status Line

The status line contains:

```text
HTTP Version
Status Code
Reason Phrase
```

Example:

```text
HTTP/1.1 200 OK
```

```text
HTTP/1.1 → Version
200      → Status code
OK       → Reason phrase
```

---

# 21. HTTP Status Code Categories

```text
100 - 199 → Informational
200 - 299 → Successful
300 - 399 → Redirection
400 - 499 → Client Errors
500 - 599 → Server Errors
```

Easy memory trick:

```text
1xx → Keep going
2xx → Success
3xx → Go somewhere else
4xx → Request problem
5xx → Server problem
```

---

# 22. Common Status Codes

### 100 — Continue

The server indicates that it is ready for the rest of the request.

### 200 — OK

The request was successful.

```text
200 OK
```

### 301 — Moved Permanently

The resource has permanently moved to another location.

### 404 — Not Found

The requested resource could not be found.

```text
GET /does-not-exist
        ↓
       404
```

### 500 — Internal Server Error

The server encountered a problem while processing the request.

---

# 23. Response Headers

Response headers provide information and instructions about the response.

Example:

```http
Date: ...
Content-Type: text/html
Server: nginx
Set-Cookie: session=abc123
Cache-Control: no-cache
Location: /login
```

---

## Important Response Headers

### Date

Shows when the response was generated.

### Content-Type

Tells the browser what kind of content it received:

```text
text/html
application/json
image/jpeg
```

### Server

May reveal server software such as:

```http
Server: nginx
```

Unnecessary technology disclosure can provide useful information to attackers.

---

## Set-Cookie

Example:

```http
Set-Cookie: sessionId=example
```

The server can use this to tell the browser to store a cookie.

Important security attributes include:

```text
HttpOnly
Secure
```

- **HttpOnly** helps prevent JavaScript from directly accessing the cookie.
- **Secure** restricts cookie transmission to HTTPS connections.

---

## Cache-Control

Example:

```http
Cache-Control: max-age=600
```

Controls how responses may be cached.

Sensitive information should have appropriate caching controls.

---

## Location

Example:

```http
Location: /login
```

Commonly used with redirects.

```text
Request
   ↓
3xx Response
   ↓
Location: /login
```

Redirect destinations should be handled carefully to avoid issues such as open redirects.

---

# 24. Response Body

The response body contains the actual content being returned.

Examples:

```text
HTML
JSON
Images
Other data
```

Example:

```http
HTTP/1.1 200 OK
Content-Type: application/json

{
    "status": "success"
}
```

---

# 25. Security Headers

The source focuses on four useful security headers:

```text
Content-Security-Policy
Strict-Transport-Security
X-Content-Type-Options
Referrer-Policy
```

These provide additional browser-side protections against various web security risks.

---

## Content-Security-Policy (CSP)

CSP helps control which sources the browser is allowed to load content from.

Example:

```http
Content-Security-Policy: default-src 'self'; script-src 'self' https://cdn.example.com; style-src 'self'
```

Think:

> **"Browser, only load content from these allowed sources."**

Common directives include:

```text
default-src
script-src
style-src
```

`'self'` refers to the current website's own origin.

---

## Strict-Transport-Security (HSTS)

HSTS stands for **HTTP Strict Transport Security**.

Example:

```http
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

It tells browsers to use HTTPS for the website.

### Directives

```text
max-age
```

How long the policy is enforced, in seconds.

```text
includeSubDomains
```

Applies the policy to subdomains.

```text
preload
```

Allows a site to be included in browser preload lists when the relevant requirements are met.

---

## X-Content-Type-Options

Example:

```http
X-Content-Type-Options: nosniff
```

`nosniff` tells the browser not to guess the MIME type and to respect the declared `Content-Type`.

---

## Referrer-Policy

Controls how much referrer information is shared with another destination.

Examples:

```http
Referrer-Policy: no-referrer
Referrer-Policy: same-origin
Referrer-Policy: strict-origin
Referrer-Policy: strict-origin-when-cross-origin
```

### `no-referrer`

Sends no referrer information.

### `same-origin`

Sends referrer information for same-origin destinations.

### `strict-origin`

Shares origin-level information under the policy's protocol conditions.

### `strict-origin-when-cross-origin`

Uses stricter behavior for cross-origin requests while allowing more information for same-origin requests.

---

# 26. Complete Request/Response Example

Let's imagine a login request.

## Request

```http
POST /login HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0
Content-Type: application/json

{
    "username": "alex",
    "password": "example"
}
```

Think:

```text
POST
 ↓
We are sending login data

/login
 ↓
Target resource

Host
 ↓
Which website?

Content-Type
 ↓
Data format

Body
 ↓
Username + password
```

## Response

```http
HTTP/1.1 200 OK
Content-Type: application/json
Set-Cookie: session=example; Secure; HttpOnly

{
    "message": "Login successful"
}
```

Think:

```text
200
 ↓
Request succeeded

Content-Type
 ↓
Response is JSON

Set-Cookie
 ↓
Session information

Body
 ↓
Application response
```

---

# 27. Web Application Security Checklist

### Architecture

```text
What is the front end?
What is the backend?
What database is used?
Is there a WAF?
What infrastructure exists?
```

### URL

```text
What is the scheme?
What is the domain?
What port is being used?
What is the path?
What query parameters exist?
Is there a fragment?
```

### Request

```text
What method is being used?
What headers exist?
Are cookies present?
What is the Content-Type?
What data is in the body?
```

### Authorization

```text
Can I access another user's resource?
Can I modify another user's resource?
Can I delete something I shouldn't?
```

### Response

```text
What status code is returned?
What headers are present?
Is sensitive information exposed?
What does the response body contain?
```

### Security Headers

```text
CSP?
HSTS?
X-Content-Type-Options?
Referrer-Policy?
```

---

# 28. The Cybersecurity Mindset

If you see:

```text
https://example.com/api/users?id=10
```

Don't just think:

> "It's a URL."

Think:

```text
Scheme? → HTTPS
Host?   → example.com
Port?   → 443 by default
Path?   → /api/users
Query?  → id=10
```

Then ask:

```text
Can id be changed?
Is the user authorized?
What HTTP method is used?
What headers are present?
Are cookies involved?
What does the server return?
What status code is returned?
Are security headers configured?
```

This is where web development knowledge starts turning into **web security knowledge**.

---

# 29. Quick Revision Cheat Sheet

## Web Application

```text
Front End
 ├── HTML → Structure
 ├── CSS  → Appearance
 └── JS   → Behaviour / browser logic

Back End
 ├── Application logic
 ├── Web server
 └── Database

Security
 └── WAF
```

## URL

```text
https://example.com:443/products?id=10#reviews
   |         |       |       |       |
 scheme     host    port    query   fragment
```

## HTTP Message

```text
Start Line
Headers
Empty Line
Body
```

## Request Methods

```text
GET
POST
PUT
DELETE
PATCH
HEAD
OPTIONS
TRACE
CONNECT
```

## Status Codes

```text
1xx → Informational
2xx → Success
3xx → Redirect
4xx → Client error
5xx → Server error
```

## Common Codes

```text
100 → Continue
200 → OK
301 → Moved Permanently
404 → Not Found
500 → Internal Server Error
```

## Security Headers

```text
CSP
HSTS
X-Content-Type-Options
Referrer-Policy
```

---

# 30. Final Mental Model

```text
                         WEB APPLICATION
                               |
              +----------------+----------------+
              |                                 |
          FRONT END                         BACK END
              |                                 |
        +-----+-----+                     +-----+-----+
        |     |     |                     |           |
      HTML  CSS    JS                 Web Server   Database

                               |
                              WAF
                               |
                            Security
```

And HTTP:

```text
USER
  |
  v
BROWSER
  |
  | HTTP Request
  v
SERVER
  |
  | HTTP Response
  v
BROWSER
```

Every message:

```text
START LINE
    ↓
HEADERS
    ↓
EMPTY LINE
    ↓
BODY
```

---

# Final Takeaways

- **HTML** provides structure.
- **CSS** controls appearance.
- **JavaScript** adds browser-side behaviour.
- The **backend** handles functionality behind the interface.
- A **database** stores and retrieves application data.
- **Infrastructure** supports the application and networking.
- A **WAF** can filter potentially dangerous web requests.
- A **URL** contains components such as scheme, host, port, path, query, and fragment.
- HTTP communication happens through **requests and responses**.
- Requests contain methods, paths, headers, and sometimes bodies.
- Responses contain status codes, headers, and response bodies.
- User-controlled values such as paths and query parameters must not be blindly trusted.
- Security headers such as **CSP, HSTS, X-Content-Type-Options, and Referrer-Policy** provide additional protection.

Most importantly, whenever you see a web request, ask:

```text
"What is happening here?"
        ↓
"Who controls this value?"
        ↓
"Does the server trust it?"
        ↓
"Is the user authorized?"
        ↓
"What could go wrong?"
```

That mindset is the foundation for learning web application security.

---


