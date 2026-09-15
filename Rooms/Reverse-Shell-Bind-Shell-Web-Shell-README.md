# Reverse Shells, Bind Shells & Web Shells

> A living notebook for understanding remote shell concepts, listener tools, shell payloads, and web shells.
>
> Keep adding your own notes, diagrams, lab observations, troubleshooting, and defensive detection ideas as you learn.
>
> ⚠️ Use these techniques only in CTFs, intentionally vulnerable labs, or systems where you have explicit authorization.

---

## 1. What is a Shell?

A shell provides an interface for interacting with an operating system.

```text
User
 ↓
Shell
 ↓
Operating System
 ↓
Commands / Processes / Files
```

A remote shell extends this over a network.

The key question is:

> **Which machine initiates the connection?**

```text
Reverse Shell → Target connects back
Bind Shell    → Target listens for connection
```

---

## 2. Reverse Shell

A **reverse shell** is a shell session where the target initiates a connection back to a listener.

```text
Target ─────────→ Listener
       connection
```

This is important in security testing because network controls can treat outbound and inbound connections differently.

### Defensive questions

```text
Which outbound connections are normal?
Which processes create them?
Which destinations are contacted?
Which ports are used?
```

---

## 3. Netcat Listener

Netcat (`nc`) can listen for incoming connections.

General form:

```bash
nc -lvnp <PORT>
```

Example for an authorized lab:

```bash
nc -lvnp 443
```

| Option | Meaning |
|---|---|
| `-l` | Listen mode |
| `-v` | Verbose output |
| `-n` | Disable DNS resolution |
| `-p` | Listening port |

Mental model:

```text
-l → wait
-v → show details
-n → don't resolve names
-p → port
```

---

## 4. Reverse Shell Payload

A reverse-shell payload connects a target process to a remote listener and attaches shell input/output to that connection.

Conceptually:

```text
Create connection
      ↓
Connect outward
      ↓
Attach shell I/O
      ↓
Interactive communication
```

Payloads vary by:

- Operating system
- Shell
- Installed utilities
- Network restrictions
- Language/runtime
- Security controls

The important skill is understanding the architecture, not memorizing payload strings.

---

## 5. Named Pipes / FIFOs

Some shell techniques use a **named pipe (FIFO)**.

```text
Process A
   ↓
Named Pipe
   ↓
Process B
```

A named pipe provides a communication channel between processes.

The important commands are:

```bash
rm -f /tmp/f
mkfifo /tmp/f
```

The overall concept is:

```text
Named pipe
   +
Shell
   +
Network connection
   =
Bidirectional communication
```

---

## 6. Shell Input & Output

A shell uses standard streams:

```text
0 → stdin
1 → stdout
2 → stderr
```

A remote shell generally connects these streams to a network socket.

```text
Network
   ↓
stdin
   ↓
Shell
   ↓
stdout / stderr
   ↓
Network
```

Understanding redirection makes reverse-shell syntax much easier to understand.

---

## 7. File Descriptors

Linux/Unix systems use file descriptors for open input/output resources.

The standard descriptors are:

```text
0 → stdin
1 → stdout
2 → stderr
```

Other descriptors can also be created.

Mental model:

```text
Socket
  ↓
File descriptor
  ↓
Shell input/output
```

This concept appears frequently in shell payloads.

---

# 8. Bind Shell

A **bind shell** works in the opposite direction.

The target creates a listening socket and waits for another machine to connect.

```text
Target
   │
   └── Listening port
          ↑
          │
       Client
```

### Reverse vs Bind

```text
REVERSE
Target ───────→ Listener


BIND
Target ←────── Client
Target listens
```

---

## 9. Why Bind Shells Matter

A bind shell can be useful in an authorized lab when the target cannot make outbound connections.

However, the listening port can become a detection opportunity.

Defenders can monitor:

```text
Unexpected listening ports
New listening processes
Services appearing without approval
Unexpected network listeners
```

---

## 10. Connecting to a Bind Shell

A client can connect to an authorized listener with:

```bash
nc -nv TARGET_IP <PORT>
```

| Component | Meaning |
|---|---|
| `nc` | Netcat |
| `-n` | Disable DNS resolution |
| `-v` | Verbose output |
| `TARGET_IP` | Target address |
| `<PORT>` | Listening port |

---

# 11. Reverse Shell vs Bind Shell

| Feature | Reverse Shell | Bind Shell |
|---|---|---|
| Listener | Remote/listener machine | Target |
| Connection starts from | Target | Remote client |
| Main direction | Outbound from target | Inbound to target |
| Useful when | Target can make outbound connections | Target cannot make outbound connections |
| Main concern | Outbound connection | Listening port |

### Easy memory trick

> **Reverse = target calls you.**  
> **Bind = target waits for you.**

---

# 12. Improving Shell Interaction

Basic Netcat shells may have limited terminal functionality.

Common issues:

- Arrow keys behave poorly
- No command history
- Poor line editing
- Limited terminal behavior

This is where `rlwrap` can help.

---

## 13. Rlwrap

`rlwrap` uses GNU readline to provide features such as:

- Command history
- Keyboard editing
- Arrow-key navigation

Example:

```bash
rlwrap nc -lvnp <PORT>
```

Mental model:

```text
rlwrap
   ↓
Better command-line interaction
   ↓
nc
```

---

# 14. Ncat

**Ncat** is an improved networking utility from the Nmap project.

It provides additional functionality beyond traditional Netcat.

Basic listener:

```bash
ncat -lvnp <PORT>
```

---

## 15. Ncat with SSL

Ncat can create an SSL-enabled listener:

```bash
ncat --ssl -lvnp <PORT>
```

Conceptually:

```text
Normal connection
      ↓
Network traffic

SSL-enabled connection
      ↓
Encrypted transport
```

Encryption can protect traffic confidentiality, but it does not make a shell invisible to endpoint monitoring.

---

# 16. Socat

**Socat** is a flexible utility for connecting data sources and network sockets.

A TCP listener can be represented by:

```bash
socat -d -d TCP-LISTEN:<PORT> STDOUT
```

Concepts:

```text
-d -d
 ↓
More diagnostic output

TCP-LISTEN:<PORT>
 ↓
Create TCP listener

STDOUT
 ↓
Send incoming data to terminal
```

---

# 17. Shell Payload Families

Different target environments may have different tools available.

Common families include:

```text
Bash
PHP
Python
Telnet
AWK
BusyBox
```

The underlying architecture is similar:

```text
Create socket
     ↓
Connect to remote endpoint
     ↓
Attach shell I/O
     ↓
Exchange commands/data
```

---

# 18. Bash

Bash can use TCP connections through `/dev/tcp` on systems where that feature is supported.

The important concept is:

```text
Bash
 ↓
TCP connection
 ↓
stdin/stdout/stderr
 ↓
Remote endpoint
```

Focus on understanding the redirections rather than memorizing a single payload.

---

# 19. PHP

PHP applications can create network connections and execute processes when the environment permits it.

The source material introduces functions such as:

```text
fsockopen()
exec()
shell_exec()
system()
passthru()
popen()
```

The security concept is:

```text
Network socket
      +
Process execution
      ↓
Potential remote shell
```

### Defensive lesson

Never pass untrusted input directly into operating-system command execution.

---

# 20. Python

Python can create sockets and interact with processes.

Basic architecture:

```text
Python
  ↓
Create socket
  ↓
Connect
  ↓
Connect socket to stdin/stdout/stderr
  ↓
Spawn shell
```

Useful concepts include:

```text
socket
os.dup2()
pty
subprocess
```

Understanding these components is more useful than memorizing a payload.

---

# 21. Other Techniques

The material also introduces techniques using:

- Telnet
- AWK
- BusyBox

Different techniques exist because target systems have different available utilities.

Mental model:

```text
Available tools
      ↓
Available runtime/shell
      ↓
Possible technique
```

---

# 22. Web Shell

A **web shell** is a server-side script that executes commands through a web server/runtime.

```text
Browser
   ↓
HTTP request
   ↓
Web server
   ↓
Web shell
   ↓
Command execution
```

Unlike a reverse shell, communication can happen through HTTP requests.

---

# 23. Web Shell — Concept

A simple web shell conceptually:

```text
Receive parameter
      ↓
Pass parameter to command execution
      ↓
Return output
```

A deliberately vulnerable example:

```php
<?php
if (isset($_GET['cmd'])) {
    system($_GET['cmd']);
}
?>
```

This demonstrates why passing user-controlled input into OS command execution is dangerous.

Use such examples only in isolated training environments.

---

# 24. How Web Shells Become Dangerous

A web shell needs a way to be placed or executed on the server.

Possible entry points include:

```text
Unrestricted file upload
File inclusion
Command injection
Unauthorized access
```

Conceptually:

```text
Initial vulnerability
       ↓
Code placed/executed
       ↓
Web shell
       ↓
Remote command execution
```

---

# 25. Web Shell vs Reverse Shell

| Feature | Web Shell | Reverse Shell |
|---|---|---|
| Main interface | HTTP | Network socket |
| Execution | Web server/runtime | Shell process |
| Interaction | Request/response | Interactive connection |
| Typical dependency | Web application | Network + shell |
| Detection | Web + host monitoring | Network + host monitoring |

---

# 26. Defensive Detection

Remote shells create useful detection opportunities.

## Network

Look for:

```text
Unexpected outbound connections
Unusual destinations
Unexpected listening ports
Rare destination ports
Long-lived unusual connections
```

## Process

Look for:

```text
Web server spawning shell processes
Unexpected child processes
Shells launched by application runtimes
Command interpreters started by unusual services
```

## Web

Look for:

```text
Suspicious uploaded scripts
Unexpected executable files
Requests containing command-like parameters
Unexpected web-directory changes
```

---

# 27. Reverse Shell Detection

A suspicious process chain may look like:

```text
Web server
   ↓
Shell process
   ↓
Outbound network connection
   ↓
Unusual destination
```

This relationship is valuable for defenders.

---

# 28. Bind Shell Detection

Monitor:

```text
New listening sockets
Unexpected open ports
Unexpected processes listening
Services appearing without change approval
```

Mental model:

```text
Normal host
    ↓
Unexpected listener
    ↓
Investigate
```

---

# 29. Web Shell Detection

Combine:

```text
File monitoring
+
Web server logs
+
Process monitoring
+
Network monitoring
```

Ask:

```text
Was a new script uploaded?
Who created it?
When was it created?
Was it executed?
Which process executed it?
What commands did it launch?
Did it make network connections?
```

---

# 30. Common Learning Mistakes

### Memorizing payloads

Instead learn:

```text
Socket
+
Shell
+
Redirection
+
Process
```

### Confusing reverse and bind

```text
Reverse → target connects out
Bind    → target listens
```

### Assuming every shell is fully interactive

A basic network shell may have limited terminal behavior.

### Ignoring network controls

Firewalls, egress filtering, IDS/IPS, proxies, and endpoint security can affect connections.

### Treating encryption as invisibility

Encryption protects traffic confidentiality but does not eliminate endpoint or network metadata.

---

# 31. Practical Lab Workflow

```text
Understand vulnerability
        ↓
Understand target OS/runtime
        ↓
Choose shell type
        ↓
Prepare controlled listener
        ↓
Establish connection
        ↓
Verify shell context
        ↓
Understand limitations
        ↓
Study detection
        ↓
Document
```

The goal is understanding the complete chain.

---

# 32. Listener Tools

| Tool | Main purpose |
|---|---|
| `nc` | Simple network listener/client |
| `rlwrap` | Better command-line interaction |
| `ncat` | Extended Netcat from Nmap |
| `socat` | Flexible socket/data connections |

---

# 33. My Reverse Shell Notes

## Concept

```text

```

## Reverse vs Bind

```text

```

## Listener

```bash

```

## What happened?

```text

```

## Problems

- 
- 
- 

## Solution

- 
- 
- 

---

# 34. Shell Payload Notes Template

Copy this for each new payload family:

```markdown
## [Bash / PHP / Python / Other]

### Available on

```text

```

### Core components

```text

```

### How it works

```text

```

### Important commands/functions

- 
- 
- 

### Limitations

- 
- 
- 

### Detection opportunities

- 
- 
- 

### My notes

- 
- 
- 
```

---

# 35. Web Shell Notes

## Server/runtime

```text

```

## Execution mechanism

```text

```

## Lab entry point

```text

```

## Indicators

```text

```

## Detection ideas

```text

```

## Mitigation

```text

```

---

# 36. Learning Progress

## Fundamentals

- [ ] Shell basics
- [ ] TCP/socket basics
- [ ] stdin/stdout/stderr
- [ ] File descriptors
- [ ] Named pipes
- [ ] Reverse shells
- [ ] Bind shells
- [ ] Web shells

## Listener Tools

- [ ] Netcat
- [ ] Rlwrap
- [ ] Ncat
- [ ] Socat

## Payload Families

- [ ] Bash
- [ ] PHP
- [ ] Python
- [ ] Telnet
- [ ] AWK
- [ ] BusyBox

## Defensive Skills

- [ ] Network detection
- [ ] Process detection
- [ ] Web-log analysis
- [ ] File monitoring
- [ ] Listening-port monitoring
- [ ] Egress filtering
- [ ] Web-shell detection

---

# 37. Quick Cheat Sheet

```text
REVERSE SHELL
→ Target connects back to listener

BIND SHELL
→ Target listens for connection

WEB SHELL
→ Web server executes commands through a script

NETCAT
→ Network listener/client

RLWRAP
→ Better terminal editing/history

NCAT
→ Extended Netcat from Nmap

SOCAT
→ Flexible socket/data connection
```

### Shell architecture

```text
Network Socket
      │
      ↓
stdin / stdout / stderr
      │
      ↓
    Shell
      │
      ↓
OS commands
```

---

# 38. Final Mental Model

Think of a remote shell as three components:

```text
        REMOTE SHELL
             │
      ┌──────┼──────┐
      ↓      ↓      ↓
   Network  Shell   I/O
   socket   process streams
      │      │      │
      └──────┼──────┘
             ↓
       Remote control
```

Ask:

```text
Who creates the connection?
Who listens?
Which process owns the socket?
Where does stdin go?
Where does stdout go?
Where does stderr go?
What process spawned the shell?
What network activity follows?
```

---

# 39. Future Content

Keep expanding this README:

- [ ] TCP socket fundamentals
- [ ] TTY vs non-TTY
- [ ] Shell stabilization concepts
- [ ] Reverse-shell troubleshooting
- [ ] Bind-shell troubleshooting
- [ ] Listener comparison
- [ ] Bash internals
- [ ] Python socket concepts
- [ ] PHP process execution
- [ ] Web-shell detection
- [ ] EDR detection
- [ ] SIEM detection
- [ ] Network indicators
- [ ] Incident-response workflow
- [ ] CTF notes
- [ ] Lab notes
- [ ] Interview questions
- [ ] Personal cheat sheet

---

# 40. Lab Safety

Only practice against:

- Your own machines
- Intentionally vulnerable applications
- CTF environments
- Security training labs
- Systems where you have explicit authorization

A shell provides powerful OS access. Treat these techniques as controlled security-testing skills.

---

# 41. Final Takeaways

1. A shell provides an interface to the operating system.
2. A reverse shell has the target initiate the connection.
3. A bind shell has the target listen for a connection.
4. Netcat can act as a network listener/client.
5. Rlwrap improves command-line interaction.
6. Ncat provides additional Netcat capabilities.
7. Socat provides flexible socket/data connections.
8. File descriptors and standard streams explain much of shell-payload syntax.
9. Web shells execute commands through a web server/runtime.
10. Reverse, bind, and web shells all create useful defensive detection opportunities.
11. Understanding the components is more valuable than memorizing payloads.
12. Always learn both the **offensive mechanism** and the **defensive detection**.

> **My rule:** Understand the socket → understand the shell → understand the I/O → understand the detection.
