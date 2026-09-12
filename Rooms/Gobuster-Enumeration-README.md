# Gobuster — Web & DNS Enumeration

> A living notebook for learning **Gobuster** and practical enumeration.
>
> Keep adding your own commands, examples, findings, mistakes, and notes as you learn.
>
> ⚠️ Use Gobuster only against systems you own or are explicitly authorized to assess.

---

## 1. What is Gobuster?

Gobuster is an open-source offensive security tool written in **Go (Golang)**. It uses wordlists to enumerate resources such as:

- Web directories and files
- DNS subdomains
- Virtual hosts
- Amazon S3 buckets
- Google Cloud Storage buckets
- Other supported targets

A simple mental model:

```text
Target
  ↓
Wordlist
  ↓
Gobuster
  ↓
Many controlled requests
  ↓
Responses
  ↓
Interesting resources
```

Gobuster commonly fits around the **reconnaissance / scanning / enumeration** stages of an ethical hacking workflow.

---

# 2. Enumeration vs Brute Force

## Enumeration

Enumeration means systematically listing available resources.

Example:

```text
Website
  ↓
/admin
/login
/uploads
/api
```

## Brute Force

Brute force means trying possibilities until a match is found.

Gobuster generally uses **wordlists** rather than blindly trying every possible combination.

Mental model:

```text
Wordlist
   ↓
Candidate
   ↓
Request
   ↓
Response
```

---

# 3. Gobuster Modes

| Mode | Purpose |
|---|---|
| `dir` | Directory/file enumeration |
| `dns` | DNS subdomain enumeration |
| `vhost` | Virtual host enumeration |
| `fuzz` | Fuzz URLs, headers, or request bodies |
| `s3` | AWS S3 bucket enumeration |
| `gcs` | Google Cloud Storage enumeration |
| `tftp` | TFTP enumeration |
| `version` | Show version |
| `completion` | Generate shell completion |

The main modes in these notes are:

```text
dir
dns
vhost
```

---

# 4. Getting Help

Always start with:

```bash
gobuster --help
```

Mode-specific help:

```bash
gobuster dir --help
gobuster dns --help
gobuster vhost --help
```

A good habit:

```text
Need an option?
     ↓
Check --help
     ↓
Understand it
     ↓
Use it in an authorized environment
```

---

# 5. Important Global Flags

| Flag | Meaning |
|---|---|
| `-t` | Number of concurrent threads |
| `-w` | Wordlist |
| `--delay` | Delay between requests |
| `--debug` | Debug output |
| `-o` | Save output to a file |
| `-q` | Quiet output |
| `-v` | Verbose output |
| `-z` | Hide progress |
| `--no-color` | Disable color |
| `--no-error` | Hide errors |

### Easy memory trick

```text
-t → threads
-w → wordlist
-o → output
-v → verbose
```

---

# 6. Threads — `-t`

Example:

```bash
-t 10
```

Controls concurrent tasks.

More threads can make scanning faster, but can also:

- Increase traffic
- Increase server load
- Trigger rate limits
- Generate more noise

Think:

```text
More threads
    ↓
Usually faster
    +
More traffic
```

Use a reasonable value for the authorized environment.

---

# 7. Wordlists — `-w`

Example:

```bash
-w /path/to/wordlist
```

The wordlist supplies candidates.

For directory mode:

```text
Word:
images

Target:
http://example.test/

Request:
http://example.test/images/
```

The quality of the wordlist directly affects what you can discover.

---

# 8. Delay — `--delay`

Example:

```bash
--delay 1500ms
```

Adds time between requests.

Useful when an environment has:

- Rate limiting
- Detection mechanisms
- Limited resources
- Request thresholds

Mental model:

```text
Request
  ↓
Wait
  ↓
Request
  ↓
Wait
  ↓
Request
```

---

# 9. Output — `-o`

Example:

```bash
-o results.txt
```

Saves results for later analysis.

Useful for:

- Assessment notes
- Evidence
- Comparing scans
- Documentation

---

# 10. Directory Mode — `dir`

`dir` mode enumerates **web directories and files**.

Basic syntax:

```bash
gobuster dir -u "http://example.test" -w /path/to/wordlist
```

The important pieces are:

```text
dir
 ↓
Directory/file mode

-u
 ↓
Target URL

-w
 ↓
Wordlist
```

---

# 11. How `dir` Mode Works

Suppose a wordlist contains:

```text
admin
images
login
uploads
```

Gobuster can request:

```text
http://example.test/admin/
http://example.test/images/
http://example.test/login/
http://example.test/uploads/
```

The responses can then be investigated using status codes, response size, redirects, and content.

---

# 12. Directory Enumeration Example

```bash
gobuster dir -u "http://example.test/" -w /path/to/wordlist -t 64
```

Breakdown:

```text
gobuster dir
→ directory/file enumeration

-u
→ target URL

-w
→ wordlist

-t 64
→ 64 concurrent threads
```

---

# 13. Important `dir` Flags

| Flag | Purpose |
|---|---|
| `-c` | Send cookies |
| `-x` | Scan specified file extensions |
| `-H` | Add headers |
| `-k` | Skip TLS certificate validation |
| `-n` | Hide status codes |
| `-P` | Password for authenticated requests |
| `-U` | Username for authenticated requests |
| `-s` | Show selected status codes |
| `-b` | Exclude selected status codes |
| `-r` | Follow redirects |

---

# 14. File Extensions — `-x`

Example:

```bash
gobuster dir -u "http://example.test" -w /path/to/wordlist -x .php,.js
```

This can test candidates such as:

```text
login.php
admin.php
script.js
config.js
```

Mental model:

```text
Wordlist
   +
Extensions
   ↓
More candidate resources
```

---

# 15. Cookies — `-c`

Cookies can be supplied when authorized enumeration requires a session.

Conceptually:

```text
Request
  +
Session cookie
  ↓
Authenticated context
```

This can be useful for resources that are not accessible anonymously.

---

# 16. Headers — `-H`

`-H` adds an HTTP header to requests.

Useful when reproducing an application's expected request context.

Always understand the purpose of the header before adding it.

---

# 17. TLS — `-k`

`-k` / `--no-tls-validation` skips certificate validation.

This can be useful in controlled labs using self-signed certificates.

It should not be treated as a general production recommendation.

---

# 18. Status Code Filtering

Show selected status codes:

```bash
-s 200
```

Exclude unwanted status codes:

```bash
-b 404
```

Common codes:

```text
200 → OK
301 → Redirect
302 → Redirect
403 → Forbidden
404 → Not Found
```

Don't assume a status code alone proves a security issue.

---

# 19. Redirects — `-r`

`-r` / `--followredirect` follows HTTP redirects.

Mental model:

```text
Request
  ↓
301 / 302
  ↓
Redirect location
  ↓
Follow
```

Redirect behavior can provide useful context about an application's structure.

---

# 20. Important `dir` Concept — Not Recursive

Gobuster does **not automatically enumerate recursively**.

If you discover:

```text
/admin/
```

and want to investigate inside it, you need to explicitly enumerate that path if it is within scope.

Mental model:

```text
Root
 ↓
/admin discovered
 ↓
You decide whether to enumerate /admin
```

---

# 21. DNS Mode — `dns`

`dns` mode enumerates **subdomains**.

Example:

```text
example.test
   ├── www.example.test
   ├── shop.example.test
   ├── api.example.test
   └── mail.example.test
```

Basic syntax:

```bash
gobuster dns -d example.test -w /path/to/wordlist
```

Important options:

```text
-d → domain
-w → wordlist
```

---

# 22. How DNS Enumeration Works

If the wordlist contains:

```text
www
shop
api
mail
```

Gobuster can construct DNS queries for:

```text
www.example.test
shop.example.test
api.example.test
mail.example.test
```

It then reports discovered names.

---

# 23. DNS Options

| Option | Purpose |
|---|---|
| `-d` | Target domain |
| `-w` | Subdomain wordlist |
| `-i` | Show resolved IP addresses |
| `--show-cname` | Show CNAME records |
| `-r` | Use a custom DNS resolver |

Check the installed version's help page because available flags can vary between versions.

---

# 24. DNS Mental Model

```text
Wordlist
   ↓
Candidate subdomain
   ↓
DNS query
   ↓
Does it resolve?
   ↓
Interesting result
```

Remember:

> DNS mode asks the DNS system about hostnames.

---

# 25. Vhost Mode — `vhost`

A **virtual host** allows multiple websites to run on the same server/IP.

Example:

```text
Same IP
   ├── www.example.test
   ├── blog.example.test
   └── shop.example.test
```

Vhost enumeration tests how the web server responds to different hostnames.

---

# 26. DNS vs Vhost

This is one of the most important distinctions.

### DNS

```text
Word
 ↓
word.example.test
 ↓
DNS lookup
```

Question:

> Does this hostname resolve?

### Vhost

```text
Word
 ↓
word.example.test
 ↓
Web request
 ↓
Host header
 ↓
Server response
```

Question:

> Does the web server recognize/respond differently to this hostname?

### Easy memory trick

```text
DNS  → Ask DNS
VHOST → Ask the web server
```

---

# 27. Basic Vhost Syntax

```bash
gobuster vhost -u "http://example.test" -w /path/to/wordlist
```

Important options:

```text
-u → base URL
-w → wordlist
```

---

# 28. Vhost Host Header Concept

A request may look like:

```http
GET / HTTP/1.1
Host: www.example.test
```

Gobuster can change the hostname being tested.

Conceptually:

```text
Host: www.example.test
Host: blog.example.test
Host: shop.example.test
Host: api.example.test
```

The web server may return different responses.

---

# 29. `--domain` and `--append-domain`

Suppose the wordlist contains:

```text
blog
shop
api
```

and the domain is:

```text
example.test
```

Appending the domain creates:

```text
blog.example.test
shop.example.test
api.example.test
```

Useful options include:

```text
--domain
--append-domain
```

---

# 30. Vhost False Positives

A server may return a similar response for every unknown hostname.

Example:

```text
random.example.test
→ 404
→ 279 bytes

another.example.test
→ 404
→ 279 bytes
```

A real host might respond:

```text
blog.example.test
→ 200
→ 1493 bytes
```

This is why response size can help identify false positives.

---

# 31. `--exclude-length`

The option:

```text
--exclude-length
```

can filter responses based on body length.

Mental model:

```text
Many results
    ↓
Find common baseline response
    ↓
Exclude that response size
    ↓
Investigate unusual results
```

Important:

> A different response size is a clue, not automatic proof that the host is valid or vulnerable.

---

# 32. Vhost Workflow

```text
Identify target
      ↓
Identify expected domain
      ↓
Choose wordlist
      ↓
Run vhost enumeration
      ↓
Observe status + size
      ↓
Identify baseline response
      ↓
Filter false positives
      ↓
Manually verify interesting hosts
```

---

# 33. `dir` vs `dns` vs `vhost`

| Mode | Main question | Technique |
|---|---|---|
| `dir` | What paths/files exist? | HTTP requests |
| `dns` | What subdomains resolve? | DNS queries |
| `vhost` | What hostnames does the server recognize? | Web requests / Host header |

Remember:

```text
DIR
→ Paths/files

DNS
→ DNS names

VHOST
→ Web hostnames
```

---

# 34. Gobuster + HTTP

Understanding HTTP makes Gobuster much easier.

Example:

```http
GET /admin HTTP/1.1
Host: example.test
```

Recognize:

```text
GET
 ↓
HTTP method

/admin
 ↓
Path

example.test
 ↓
Host
```

This connects directly to Gobuster:

```text
dir
 ↓
Changes paths

dns
 ↓
Changes DNS hostname candidates

vhost
 ↓
Changes web hostname / Host header
```

---

# 35. Common Mistakes

### Wrong protocol

Using HTTP against an HTTPS-only target can fail.

### Poor wordlist

A wordlist that doesn't match the application may miss useful resources.

### Too many threads

High concurrency can cause excessive traffic and rate limiting.

### Trusting every result

A `200` response does not automatically mean a finding.

### Ignoring response size

Custom error pages can create many false positives.

### Forgetting recursion behavior

`dir` mode does not automatically scan discovered directories.

### Confusing DNS and Vhost

A hostname resolving in DNS is not the same thing as a web server recognizing it as a virtual host.

---

# 36. Cybersecurity Mindset

When Gobuster finds something, don't immediately think:

> "I found a vulnerability."

Instead ask:

```text
What did I discover?
       ↓
Why does it exist?
       ↓
Is it accessible?
       ↓
Does it require authentication?
       ↓
What technology is behind it?
       ↓
Does it expose sensitive information?
       ↓
Is it actually a security issue?
```

Enumeration is the **beginning of understanding the attack surface**, not the final conclusion.

---

# 37. Gobuster Workflow

```text
Target
  ↓
Understand scope
  ↓
Identify services
  ↓
┌───────────────┐
│ Enumeration   │
├───────────────┤
│ dir           │
│ dns           │
│ vhost         │
└───────┬───────┘
        ↓
Interesting results
        ↓
Manual validation
        ↓
Document findings
```

---

# 38. Gobuster + Other Tools

| Tool | Typical role |
|---|---|
| Gobuster | Wordlist-based enumeration |
| Nmap | Network/service discovery |
| Burp Suite | HTTP inspection/testing |
| Browser DevTools | Browser/network inspection |
| DNS utilities | DNS information |

No single tool tells the whole story.

A strong workflow is:

```text
Tool output
   ↓
Understand what happened
   ↓
Manually validate
   ↓
Document accurately
```

---

# 39. My Gobuster Notes

## Command I Learned

```bash

```

### What it does

```text

```

### Important options

| Option | Meaning | My Notes |
|---|---|---|
| | | |
| | | |
| | | |

### Output

```text

```

### What I learned

- 
- 
- 

### Mistake

```text

```

### Fix

```text

```

---

# 40. Directory Enumeration Notes

## Target

```text

```

## Wordlist

```text

```

## Extensions

```text

```

## Interesting results

| Path | Status | Size | Notes |
|---|---:|---:|---|
| | | | |
| | | | |
| | | | |

---

# 41. DNS Enumeration Notes

## Domain

```text

```

## Wordlist

```text

```

## Resolver

```text

```

## Discovered subdomains

| Subdomain | IP | CNAME | Notes |
|---|---|---|---|
| | | | |
| | | | |
| | | | |

---

# 42. Vhost Enumeration Notes

## Target URL

```text

```

## Domain

```text

```

## Wordlist

```text

```

## Baseline response

```text
Status:
Size:
Response pattern:
```

## Interesting hosts

| Host | Status | Size | Notes |
|---|---:|---:|---|
| | | | |
| | | | |
| | | | |

---

# 43. New Gobuster Mode Template

Copy this whenever you learn another mode.

```markdown
## [Mode Name]

### What is it?

### What does it enumerate?

```text

```

### Basic syntax

```bash
gobuster ...
```

### Important options

| Option | Purpose |
|---|---|
| | |
| | |

### How it works

```text

```

### Example

```bash

```

### What did I observe?

```text

```

### Common mistakes

- 
- 
- 

### Defensive relevance

- 
- 
- 

### My notes

- 
- 
- 
```

---

# 44. Learning Progress

## Fundamentals

- [ ] Enumeration
- [ ] Wordlists
- [ ] Brute-force concept
- [ ] HTTP status codes
- [ ] Response size
- [ ] DNS
- [ ] Virtual hosts

## Modes

- [ ] `dir`
- [ ] `dns`
- [ ] `vhost`
- [ ] `fuzz`
- [ ] `s3`
- [ ] `gcs`
- [ ] `tftp`

## `dir`

- [ ] Extensions
- [ ] Cookies
- [ ] Headers
- [ ] Status filtering
- [ ] Redirects
- [ ] Authenticated enumeration
- [ ] TLS handling

## `dns`

- [ ] Subdomains
- [ ] IP resolution
- [ ] CNAMEs
- [ ] Custom resolver

## `vhost`

- [ ] Host header
- [ ] Domain appending
- [ ] Response-size filtering
- [ ] False positives
- [ ] Manual validation

---

# 45. Quick Cheat Sheet

```text
GOBUSTER
│
├── dir
│   └── Directories / files
│
├── dns
│   └── DNS subdomains
│
├── vhost
│   └── Virtual hosts
│
├── fuzz
│   └── URL / headers / body fuzzing
│
├── s3
│   └── AWS S3
│
└── gcs
    └── Google Cloud Storage
```

### Important flags

```text
-w → Wordlist
-t → Threads
-o → Output
-u → URL
-d → Domain
-x → Extensions
-H → Headers
-c → Cookies
-s → Show status codes
-b → Exclude status codes
-r → Follow redirects
-k → Skip TLS validation
-v → Verbose
```

### Three core questions

```text
dir
→ "What paths/files exist?"

dns
→ "What subdomains resolve?"

vhost
→ "What hostnames does this web server recognize?"
```

---

# 46. Final Mental Model

Think of Gobuster as a **wordlist-driven discovery engine**.

```text
                    GOBUSTER
                        │
             ┌──────────┼──────────┐
             ↓          ↓          ↓
            DIR        DNS        VHOST
             │          │          │
             ↓          ↓          ↓
          Paths      Domains      Hosts
             │          │          │
             └──────────┼──────────┘
                        ↓
                   Responses
                        ↓
                  Filter noise
                        ↓
                 Manual validation
                        ↓
                 Security finding
```

The key skill is not memorizing commands.

It is understanding:

```text
What am I enumerating?
How does the protocol work?
What does the response mean?
What is normal?
What is unusual?
Does the result actually matter?
```

---

# 47. Future Content

Keep expanding this README with:

- [ ] Wordlist selection
- [ ] SecLists notes
- [ ] Advanced `dir`
- [ ] Advanced `dns`
- [ ] Advanced `vhost`
- [ ] Fuzz mode
- [ ] S3/GCS enumeration
- [ ] Authenticated enumeration
- [ ] Cookies and headers
- [ ] HTTPS/TLS
- [ ] False-positive filtering
- [ ] Rate limiting
- [ ] Gobuster + Burp workflow
- [ ] Gobuster + Nmap workflow
- [ ] CTF notes
- [ ] Lab notes
- [ ] Interview questions
- [ ] Personal command cheat sheet
- [ ] Real-world case studies

---

# 48. Lab Safety

Only use Gobuster against:

- Your own infrastructure
- Intentionally vulnerable machines
- CTF environments
- Training labs
- Systems where you have explicit authorization

Enumeration can generate substantial traffic.

Always consider:

```text
Scope
+
Threads
+
Delay
+
Wordlist
+
Testing window
```

---

# 49. Final Takeaways

1. Gobuster is a Go-based wordlist-driven enumeration tool.
2. `dir` discovers web directories and files.
3. `dns` discovers DNS subdomains.
4. `vhost` discovers virtual hosts through web requests.
5. `-w` specifies a wordlist.
6. `-t` controls concurrency.
7. `-o` saves results.
8. `-x` adds file extensions.
9. `-H` and `-c` provide headers and cookies.
10. `-s` and `-b` help filter status codes.
11. `--exclude-length` helps reduce vhost false positives.
12. `dir` is not automatically recursive.
13. DNS and vhost enumeration are different techniques.
14. A discovered resource is not automatically a vulnerability.
15. Always manually validate interesting results.

---

> **My rule:** Enumerate → understand → validate → document.
