# Burp Suite — Web Application Testing

> A living notebook for learning Burp Suite and building practical web application security testing skills.
>
> **How to use this README:** Keep adding your own notes, examples, findings, screenshots, commands, and techniques under the relevant sections as you learn.

---

## 1. What is Burp Suite?

**Burp Suite** is a toolkit used for testing web applications and APIs.

The easiest mental model:

```text
Browser
   ↓
Burp Suite
   ↓
Web Application
```

Burp can sit between the browser and the application so you can **see, inspect, modify, and resend HTTP traffic**.

Typical learning flow:

```text
Understand request
      ↓
Capture it
      ↓
Modify it
      ↓
Send it again
      ↓
Compare the response
      ↓
Understand the application's behavior
```

> ⚠️ Use Burp only on applications you own or are explicitly authorized to test.

---

# 2. Burp Suite Community Edition

Burp Suite has different editions.

The **Community Edition** is enough to learn many important web-security concepts, although some functionality is limited compared with Professional.

For learning, the most important tools are:

- Proxy
- Repeater
- Intruder
- Decoder
- Comparer
- Sequencer
- Extender
- BApp Store

---

# 3. The Burp Mental Model

Think of each Burp tool as answering a different question:

| Tool | Main Question |
|---|---|
| **Proxy** | What is being sent? Can I inspect/change it? |
| **Repeater** | What happens if I change it and send it again? |
| **Intruder** | What happens if I try many variations? |
| **Decoder** | What does this encoded data represent? |
| **Comparer** | What changed between these two pieces of data? |
| **Sequencer** | Are these tokens genuinely random? |
| **Extender** | How can I add more functionality? |
| **BApp Store** | What useful extensions already exist? |

Easy memory trick:

```text
Proxy     → Catch it
Repeater  → Try it again
Intruder  → Try many versions
Decoder   → Translate it
Comparer  → Find differences
Sequencer → Check randomness
Extender  → Add functionality
```

---

# 4. Proxy

## What is Proxy?

The **Proxy** is one of the most important parts of Burp.

It allows you to intercept HTTP requests and responses between your browser and the web application.

```text
Browser
   │
   │ HTTP Request
   ↓
[ Burp Proxy ]
   │
   │ Modified / Original Request
   ↓
Web Server
   │
   │ HTTP Response
   ↓
[ Burp Proxy ]
   │
   ↓
Browser
```

## What can you do?

You can:

- Inspect requests
- Inspect responses
- Modify parameters
- Modify headers
- Observe cookies
- Study API requests
- Understand how the application communicates

### Example

Suppose an application sends:

```http
GET /profile?id=101 HTTP/1.1
Host: example.test
Cookie: session=abc123
```

You can inspect questions such as:

```text
What does id control?
What does the session cookie do?
Which headers are important?
What changes when I change id?
```

The goal is not simply to "change things."

The goal is to understand:

> **How does the application trust and process user-controlled data?**

---

# 5. Repeater

## What is Repeater?

**Repeater** lets you capture a request, modify it, and send it repeatedly.

This is extremely useful when doing manual experimentation.

Mental model:

```text
Capture request
      ↓
Send to Repeater
      ↓
Change something
      ↓
Send
      ↓
Observe response
      ↓
Change again
      ↓
Send again
```

### Example

Original request:

```http
GET /product?id=10 HTTP/1.1
Host: example.test
```

You might test harmless variations such as:

```text
id=10
id=11
id=999
id=0
```

Then compare:

- HTTP status
- Response length
- Returned data
- Error messages
- Redirects
- Application behavior

### Why Repeater is powerful

It encourages a useful security-testing mindset:

> **Change one thing → observe one result.**

That makes it easier to understand cause and effect.

---

# 6. Intruder

## What is Intruder?

**Intruder** is designed for sending many variations of a request.

Mental model:

```text
One request
     ↓
Many variations
     ↓
Many responses
     ↓
Look for interesting differences
```

It can be useful for:

- Fuzzing
- Testing input handling
- Parameter variation
- Endpoint testing
- Authorized brute-force testing

### Community Edition limitation

The Community Edition has significant rate limitations compared with Burp Professional.

For learning, you can still understand the workflow and use it for small, controlled tests.

### Important mindset

Do not think:

> "Intruder = brute force tool"

Think:

> **"Intruder = systematically test many input variations."**

---

# 7. Decoder

## What is Decoder?

**Decoder** helps encode and decode data.

Common formats you may encounter include:

- Base64
- URL encoding
- HTML encoding
- Hex
- Other transformations supported by Burp

### Example

Base64:

```text
SGVsbG8=
```

decodes to:

```text
Hello
```

### Important distinction

Encoding ≠ Encryption.

For example:

```text
Base64
   ↓
Encoding
   ↓
Easy to reverse
```

Whereas encryption is intended to require a key or cryptographic process to recover the protected data.

### Cybersecurity mindset

When you see strange-looking data, ask:

```text
Is it encoded?
Is it encrypted?
Is it compressed?
Is it hashed?
Is it simply formatted differently?
```

---

# 8. Comparer

## What is Comparer?

**Comparer** helps compare two pieces of data.

You can compare data at different levels, including:

- Word level
- Byte level

This is useful when two requests or responses look almost identical but something small changed.

### Example

Response A:

```text
role=user
status=active
```

Response B:

```text
role=admin
status=active
```

Comparer helps make the difference obvious.

### Useful question

> **"What exactly changed?"**

This is especially useful when manually testing application behavior.

---

# 9. Sequencer

## What is Sequencer?

**Sequencer** can be used to assess the randomness of tokens.

Examples of tokens include:

- Session cookies
- Authentication-related tokens
- Other generated identifiers

The basic security question is:

> **Are these values sufficiently unpredictable?**

### Example

Imagine an application generates:

```text
10001
10002
10003
10004
```

That pattern would raise a question about predictability.

A secure token-generation system should make it difficult for an attacker to predict future valid tokens.

### Key concept

```text
Random-looking ≠ necessarily random
```

Sequencer helps analyze this kind of behavior.

---

# 10. Extender

## What is Extender?

**Extender** allows Burp's functionality to be extended with additional code and extensions.

Burp has a Java-based codebase, and extensions can be developed using supported languages/runtimes such as:

- Java
- Python through Jython
- Ruby through JRuby

This creates a larger ecosystem around Burp.

### Why extensions matter

Instead of building every feature yourself:

```text
Burp
  +
Extensions
  +
Your workflow
  =
More powerful testing environment
```

---

# 11. BApp Store

The **BApp Store** provides third-party Burp extensions.

These extensions can add functionality that is not available in the basic installation.

Some extensions may require Burp Professional.

Before installing an extension, understand:

```text
What does it do?
What permissions/access does it need?
Is it maintained?
Do I actually need it?
```

---

# 12. Logger++

**Logger++** is an example of a Burp extension.

It can provide additional logging and visibility into HTTP traffic.

Extensions like this can become useful as your testing workflow grows.

> Add your own extension notes below as you discover useful ones.

### Extensions I Want to Explore

- [ ] Logger++
- [ ] Extension #2
- [ ] Extension #3
- [ ] Extension #4

---

# 13. Which Burp Tool Should I Use?

| Situation | Tool |
|---|---|
| I want to intercept traffic | **Proxy** |
| I want to manually modify and resend a request | **Repeater** |
| I want to test many input variations | **Intruder** |
| I don't understand an encoded value | **Decoder** |
| I want to see differences between responses | **Comparer** |
| I want to investigate token randomness | **Sequencer** |
| I want additional functionality | **Extender** |
| I want to find third-party extensions | **BApp Store** |

---

# 14. Simple Burp Workflow

A beginner-friendly workflow:

```text
        ┌───────────────┐
        │    Browser    │
        └───────┬───────┘
                │
                ↓
        ┌───────────────┐
        │     Proxy     │
        └───────┬───────┘
                │
        Capture request
                │
                ↓
        ┌───────────────┐
        │    Repeater   │
        └───────┬───────┘
                │
       Modify / experiment
                │
                ↓
        ┌───────────────┐
        │   Response    │
        └───────┬───────┘
                │
                ↓
        Compare / Decode
                │
                ↓
        Understand behavior
```

For broader testing:

```text
Proxy
  ↓
Understand traffic
  ↓
Repeater
  ↓
Manual testing
  ↓
Comparer / Decoder
  ↓
Intruder (controlled variations)
  ↓
Sequencer (token analysis)
  ↓
Extensions when needed
```

---

# 15. Practical API Testing Example

Suppose an application has:

```http
GET /api/user?id=101 HTTP/1.1
Host: example.test
Authorization: Bearer <token>
```

### Step 1 — Proxy

Capture the request.

Questions:

```text
What endpoint is being called?
What parameters exist?
What authentication mechanism is used?
What headers are present?
```

### Step 2 — Repeater

Send the request to Repeater.

Try controlled changes:

```text
id=101
id=102
id=999
```

Observe:

```text
Status code
Response body
Response size
Error behavior
Authorization behavior
```

### Step 3 — Comparer

If two responses look similar:

```text
Response A
vs
Response B
```

use Comparer to identify meaningful differences.

### Step 4 — Decoder

If a parameter or token appears encoded:

```text
Encoded value
      ↓
Decoder
      ↓
Understand representation
```

### Step 5 — Intruder

If you need to test many controlled values:

```text
Input position
      ↓
Multiple test values
      ↓
Responses
      ↓
Identify unusual behavior
```

---

# 16. Cybersecurity Mindset With Burp

Don't use Burp just by memorizing buttons.

For every request, ask:

### Request

```text
Who sent this?
What data is controlled by the user?
What is trusted?
```

### Parameters

```text
Can this value affect authorization?
Can it change application state?
Is it validated?
```

### Headers

```text
Which headers influence application behavior?
Which contain authentication/session information?
```

### Cookies

```text
What does this cookie represent?
Is it predictable?
Does it change after authentication?
```

### Response

```text
What information is returned?
What changes after my input changes?
Are errors revealing useful implementation details?
```

### Core mindset

> **Don't just look at the request. Understand the trust boundary.**

---

# 17. Burp Tool Decision Tree

```text
I found an HTTP request
        │
        ↓
Do I need to inspect/change it?
        │
       YES
        ↓
      Proxy
        │
        ↓
Do I want to manually experiment?
        │
       YES
        ↓
     Repeater
        │
        ├── Need to decode data? → Decoder
        │
        ├── Need to compare data? → Comparer
        │
        └── Need many variations? → Intruder
                         │
                         ↓
                 Need token analysis?
                         │
                        YES
                         ↓
                     Sequencer

Need more functionality?
        ↓
    Extender
        ↓
   BApp Store
```

---

# 18. My Burp Notes

> Keep adding your own discoveries here.

## Proxy Notes

### What I learned

- 
- 
- 

### Useful examples

```text

```

### Things I want to investigate

- [ ] 
- [ ] 
- [ ] 

---

## Repeater Notes

### What I learned

- 
- 
- 

### Experiments

```text

```

### Observations

```text

```

---

## Intruder Notes

### What I learned

- 
- 
- 

### Use cases

- 
- 
- 

---

## Decoder Notes

### Encodings I learned

| Encoding | Example | Notes |
|---|---|---|
| Base64 | | |
| URL Encoding | | |
| Hex | | |
| HTML Encoding | | |

---

## Comparer Notes

### What I learned

- 
- 
- 

---

## Sequencer Notes

### Token observations

```text

```

### Questions

- 
- 
- 

---

## Extender Notes

### Extensions I tested

| Extension | Purpose | Useful? | Notes |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

---

# 19. New Burp Tool Notes Template

Copy this section whenever you learn a new Burp feature.

```markdown
## [Tool / Feature Name]

### What is it?

Write a simple explanation.

### Why does it matter?

Explain the security/testing value.

### Mental model

```text
Your simple analogy here
```

### Example

```text
Add a harmless example here
```

### When would I use it?

- 
- 
- 

### What did I learn?

- 
- 
- 

### Mistakes I made

- 
- 
- 

### Things to explore later

- [ ] 
- [ ] 
- [ ] 

### My notes

Write your own observations here.
```

---

# 20. My Burp Learning Progress

## Fundamentals

- [ ] Understand HTTP requests
- [ ] Understand HTTP responses
- [ ] Understand cookies
- [ ] Understand sessions
- [ ] Understand parameters
- [ ] Understand headers

## Burp Tools

- [ ] Proxy
- [ ] Repeater
- [ ] Intruder
- [ ] Decoder
- [ ] Comparer
- [ ] Sequencer
- [ ] Extender
- [ ] BApp Store

## Web Security Topics to Connect With Burp

- [ ] Authentication
- [ ] Authorization
- [ ] Session management
- [ ] Input validation
- [ ] Access control
- [ ] Security headers
- [ ] API security
- [ ] Common web vulnerabilities
- [ ] Logging and monitoring

---

# 21. Quick Revision Cheat Sheet

```text
┌──────────────────────────────────────────────┐
│              BURP SUITE CHEAT SHEET          │
├──────────────────────────────────────────────┤
│ Proxy      → Intercept & modify traffic      │
│ Repeater   → Manually resend requests        │
│ Intruder   → Test many variations            │
│ Decoder    → Encode/decode data              │
│ Comparer   → Find differences                │
│ Sequencer  → Analyze token randomness        │
│ Extender   → Add custom functionality        │
│ BApp Store → Find third-party extensions     │
└──────────────────────────────────────────────┘
```

### One-line memory trick

> **Catch → Repeat → Vary → Decode → Compare → Analyze → Extend**

---

# 22. Final Mental Model

Think of Burp as a **laboratory for HTTP traffic**.

```text
                    BURP SUITE
                        │
        ┌───────────────┼────────────────┐
        ↓               ↓                ↓
     Observe         Experiment        Analyze
        │               │                │
      Proxy          Repeater        Comparer
                                      Decoder
                                      Sequencer
        │
        └───────────────┬────────────────┘
                        ↓
                    Automate
                        │
                     Intruder
                        │
                        ↓
                    Customize
                        │
                  Extender / BApps
```

The important skill is not memorizing every Burp button.

The important skill is learning to look at an HTTP request and think:

> **"What is the application trusting, what can I control, and what happens when that input changes?"**

---

# 23. Future Content

This README is intentionally designed to grow.

Add future sections here:

- [ ] Burp installation/setup
- [ ] Browser proxy configuration
- [ ] HTTPS interception
- [ ] Scope configuration
- [ ] Site map
- [ ] HTTP history
- [ ] Repeater workflows
- [ ] Intruder attack types
- [ ] API testing
- [ ] Authentication testing
- [ ] Authorization testing
- [ ] Session testing
- [ ] Input validation testing
- [ ] Common web vulnerability workflows
- [ ] Custom extensions
- [ ] Useful BApps
- [ ] Personal Burp shortcuts
- [ ] CTF notes
- [ ] Lab notes
- [ ] Interview questions
- [ ] Real-world case studies

---

# 24. Lab Safety

Only use Burp Suite against:

- Your own applications
- Intentionally vulnerable applications
- CTF environments
- Training labs
- Systems where you have explicit authorization to test

Avoid testing random public websites without permission.

A good security tester learns both:

```text
How attacks work
        +
How to test responsibly
```

---

# 25. Final Takeaways

1. **Proxy** helps you see and modify traffic.
2. **Repeater** is your manual experimentation tool.
3. **Intruder** handles controlled large-scale input variation.
4. **Decoder** helps understand encoded data.
5. **Comparer** highlights differences.
6. **Sequencer** helps investigate token randomness.
7. **Extender** lets you expand Burp.
8. **BApp Store** provides third-party extensions.
9. The most important skill is understanding **HTTP and application behavior**, not memorizing the UI.
10. Keep adding your own observations to this README — your personal notes will eventually become more valuable than the original documentation.
