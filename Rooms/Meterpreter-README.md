# Meterpreter

> A practical, beginner-friendly guide to understanding Meterpreter during authorized penetration testing.

---

## What is Meterpreter?

Meterpreter is a Metasploit payload designed for the **post-exploitation phase** of a penetration test.

Instead of giving only a basic command shell, Meterpreter provides a specialized interactive session with many built-in capabilities for interacting with the target system.

Think of it like this:

```text
Normal shell  = Basic remote terminal
Meterpreter   = Remote post-exploitation toolkit
```

Meterpreter runs as an agent on the target and communicates with the Metasploit system.

---

# How Meterpreter Works

One important characteristic of Meterpreter is that it can operate **in memory** rather than simply installing a visible `meterpreter.exe` file on disk.

This can make traditional file-based detection more difficult.

The source material also describes Meterpreter as using an encrypted communication channel with the Metasploit system. This can make network inspection more difficult when encrypted traffic is not decrypted and inspected.

However:

> **Memory-based does not mean undetectable.**

Modern security products can detect Meterpreter activity through behavioral, process, memory, and network indicators.

---

# Meterpreter Process Concept

Meterpreter can run inside another legitimate process.

For example, the source material shows Meterpreter associated with:

```text
spoolsv.exe
```

with a process ID:

```text
1304
```

The command:

```text
getpid
```

shows the process ID associated with the current Meterpreter session.

Example:

```text
meterpreter > getpid
Current pid: 1304
```

The important lesson is that the process containing Meterpreter does not necessarily have to be named `meterpreter.exe`.

---

# Viewing Processes

The `ps` command displays processes running on the target:

```text
meterpreter > ps
```

It can show:

- PID
- Parent PID
- Process name
- Architecture
- Session
- User
- Path

Example:

```text
PID    PPID    Name          Arch    User
----   ----    ----          ----    ----
1304   692     spoolsv.exe   x64     NT AUTHORITY\SYSTEM
```

### Why PID matters

A PID becomes useful when identifying processes for operations such as process migration.

---

# Checking Loaded DLLs

The source material demonstrates checking modules loaded by a process:

```text
tasklist /m /fi "pid eq 1304"
```

The example shows normal Windows DLLs associated with `spoolsv.exe`.

The important lesson is:

> Looking for a file literally named `meterpreter.dll` is not necessarily enough to identify a Meterpreter session.

Process-level and behavioral analysis can be more useful than simply searching the filesystem for a known filename.

---

# Meterpreter Payload Types

Meterpreter payloads exist in different forms:

- **Staged**
- **Stageless / inline**

## Staged Meterpreter

A staged payload is delivered in multiple parts.

Conceptually:

```text
Initial payload
      |
      v
   Stager
      |
      v
Requests remaining payload
      |
      v
   Meterpreter
```

The initial payload can be smaller because it does not contain everything at once.

---

## Stageless / Inline Meterpreter

A stageless payload contains the required functionality in a single payload.

```text
Payload
   |
   v
Meterpreter
```

---

# Listing Meterpreter Payloads

`msfvenom` can list available payloads:

```bash
msfvenom --list payloads | grep meterpreter
```

Examples from the source material include:

```text
android/meterpreter/reverse_tcp
android/meterpreter/reverse_https
java/meterpreter/reverse_tcp
linux/aarch64/meterpreter/reverse_tcp
windows/x64/meterpreter/reverse_tcp
```

The exact list depends on the installed Metasploit version.

---

# Choosing a Meterpreter Payload

The source material highlights three major factors.

## 1. Target Operating System

Determine what the target is running:

```text
Windows
Linux
macOS
Android
iOS
```

The payload must be compatible with the target environment.

## 2. Available Components

The target may have different runtime components available, such as:

```text
Python
PHP
Java
```

The available environment can influence which payload is practical.

## 3. Network Connection

Consider what network communication is possible:

```text
Reverse TCP
Reverse HTTP
Reverse HTTPS
Bind TCP
```

The network environment and filtering rules can affect which communication method works.

---

# Meterpreter and Exploit Modules

When Meterpreter is used as the payload of an exploit module, the exploit may have a default payload.

For example:

```text
msf6 > use exploit/windows/smb/ms17_010_eternalblue
```

The source material shows:

```text
[*] Using configured payload windows/x64/meterpreter/reverse_tcp
```

You can inspect compatible payloads with:

```text
show payloads
```

---

# Meterpreter Command Categories

Running:

```text
help
```

inside a Meterpreter session displays available commands.

Commands can appear under categories such as:

- Core commands
- File system commands
- Networking commands
- System commands
- User interface commands
- Webcam commands
- Audio output commands
- Elevate commands
- Password database commands
- Timestomp commands

> Available commands depend on the Meterpreter version and loaded extensions.

---

# Core Commands

## `help`

Displays available commands:

```text
meterpreter > help
```

Use this whenever you start working with a new Meterpreter version or session.

## `background`

Backgrounds the current session:

```text
meterpreter > background
```

This allows you to return to the Metasploit console while keeping the session available.

## `sessions`

Used to interact with available sessions:

```text
meterpreter > sessions
```

## `exit`

Terminates the current Meterpreter session:

```text
meterpreter > exit
```

---

# Identity and System Commands

## `getuid`

Displays the account under which Meterpreter is running:

```text
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```

This helps determine the current privilege level.

Think:

```text
getuid
   |
   v
Who am I?
   |
   v
What access do I have?
```

## `getpid`

Shows the current process ID:

```text
meterpreter > getpid
```

## `sysinfo`

Displays information about the remote system:

```text
meterpreter > sysinfo
```

This can help identify the target operating system and environment.

---

# Process Commands

## `ps`

Lists running processes:

```text
meterpreter > ps
```

Useful for:

- Understanding the target
- Finding interesting processes
- Identifying PIDs
- Selecting a process for migration

## `migrate`

Moves the Meterpreter session into another process:

```text
meterpreter > migrate <PID>
```

Example:

```text
meterpreter > migrate 716
```

Conceptually:

```text
Current Process
      |
      | migrate
      v
Target Process
```

Migration can sometimes improve session stability.

### Important Warning

Process migration can affect privileges.

If Meterpreter is running with high privileges and you migrate into a process owned by a lower-privileged account, you may lose access that you previously had.

Always understand the target process and its privilege level before migrating.

---

# File System Commands

| Command | Purpose |
|---|---|
| `cd` | Change directory |
| `ls` | List files |
| `pwd` | Show current directory |
| `cat` | Display file contents |
| `edit` | Edit a file |
| `rm` | Remove a file |
| `search` | Search for files |
| `upload` | Upload files/directories |
| `download` | Download files/directories |

Examples:

```text
meterpreter > pwd
meterpreter > ls
```

---

# Searching for Files

The `search` command can locate files.

Example:

```text
meterpreter > search -f <filename>
```

In a lab, this can be useful for locating:

- Flags
- Configuration files
- Interesting documents
- Application files

In real penetration tests, searches should follow the engagement scope.

---

# Networking Commands

Meterpreter provides commands for examining network information.

| Command | Purpose |
|---|---|
| `arp` | Displays ARP cache |
| `ifconfig` | Shows network interfaces |
| `netstat` | Shows network connections |
| `route` | Shows/modifies routing information |
| `portfwd` | Provides port forwarding |

Examples:

```text
meterpreter > ifconfig
meterpreter > netstat
```

These can help identify:

- IP addresses
- Network interfaces
- Existing connections
- Routing information
- Additional reachable networks

---

# System Commands

| Command | Purpose |
|---|---|
| `sysinfo` | Displays system information |
| `getuid` | Shows current user |
| `getpid` | Shows current PID |
| `ps` | Lists processes |
| `execute` | Executes a command |
| `shell` | Opens a normal command shell |
| `kill` | Terminates a process |
| `pkill` | Terminates processes by name |
| `reboot` | Reboots the system |
| `shutdown` | Shuts down the system |

---

# Opening a Normal Shell

Meterpreter can open the target's regular command-line shell:

```text
meterpreter > shell
```

Example:

```text
Process 2124 created.
Channel 1 created.

Microsoft Windows [Version ...]
C:\Windows\system32>
```

The source material uses:

```text
CTRL + Z
```

to return from the shell to Meterpreter.

---

# `hashdump`

The `hashdump` command can retrieve password hashes from the Windows SAM database when sufficient privileges are available:

```text
meterpreter > hashdump
```

The source material shows account entries containing NTLM password hashes.

Conceptually:

```text
Windows SAM
     |
     v
Account information
     |
     v
NTLM password hashes
```

These hashes are not plaintext passwords.

They can nevertheless be valuable during authorized password auditing and may be relevant to authentication techniques such as Pass-the-Hash.

> Credential extraction should only be performed in controlled labs or explicitly authorized penetration tests.

---

# Post-Exploitation

Meterpreter is especially useful during the **post-exploitation phase**.

The source material identifies several common goals.

## 1. Information Gathering

Collect information about:

- Operating system
- Users
- Processes
- Network interfaces
- Interesting files

## 2. Credential Discovery

Depending on privileges and loaded functionality, credential material may be accessible.

## 3. Privilege Escalation

Determine whether the current access can be elevated.

## 4. Lateral Movement

Use information obtained from the compromised system to understand possible access to other systems.

The exact techniques depend on the target and the authorization scope.

---

# Loading Extensions

Meterpreter can load additional functionality:

```text
meterpreter > load <extension>
```

The source material demonstrates:

```text
meterpreter > load python
```

and:

```text
meterpreter > load kiwi
```

After loading an extension:

```text
meterpreter > help
```

may display additional commands.

Think of extensions like plugins:

```text
Meterpreter
     |
     +---- Core commands
     |
     +---- File tools
     |
     +---- Network tools
     |
     +---- Extension
              |
              +---- Extra functionality
```

---

# Kiwi Extension

The source material demonstrates loading the Kiwi extension:

```text
meterpreter > load kiwi
```

It adds credential and authentication-related functionality.

Examples shown in the material include:

```text
creds_all
creds_kerberos
creds_msv
creds_ssp
creds_tspkg
creds_wdigest
dcsync
dcsync_ntlm
golden_ticket_create
kerberos_ticket_list
kerberos_ticket_purge
kerberos_ticket_use
lsa_dump_sam
lsa_dump_secrets
password_change
wifi_list
wifi_list_shared
```

These capabilities can expose highly sensitive credential material.

Use them only in controlled labs or explicitly authorized penetration tests.

---

# A Simple Meterpreter Workflow

A useful learning workflow is:

```text
Get Meterpreter Session
        |
        v
      help
        |
        v
      getuid
        |
        v
     sysinfo
        |
        v
        ps
        |
        v
Network Enumeration
        |
        v
File Enumeration
        |
        v
Privilege Assessment
        |
        v
Post-Exploitation
```

The exact order can change depending on the engagement.

---

# Practical Command Cheat Sheet

## Session

```text
help
background
sessions
exit
```

## Identity & System

```text
getuid
getpid
sysinfo
```

## Processes

```text
ps
migrate <PID>
kill <PID>
pkill <name>
```

## Files

```text
pwd
cd <directory>
ls
cat <file>
search -f <filename>
upload <source> <destination>
download <source> <destination>
```

## Network

```text
ifconfig
arp
netstat
route
portfwd
```

## Shell

```text
shell
```

## Credential-related

```text
hashdump
load kiwi
```

---

# Meterpreter Mental Model

The easiest way to remember Meterpreter:

```text
                 METERPRETER
                      |
        +-------------+-------------+
        |             |             |
      SYSTEM        FILES         NETWORK
        |             |             |
       ps            ls          ifconfig
     getuid        search        netstat
     sysinfo       upload         route
        |
   POST-EXPLOITATION
        |
   +----+----+
   |         |
 ENUM     PRIVILEGES
```

Meterpreter is not just a shell.

It is a **post-exploitation interface** that combines system interaction, enumeration, session management, and additional extensions.

---

# Important Security Lessons

### 1. Memory-based does not mean undetectable

Security products can still identify suspicious behavior.

### 2. Encryption does not guarantee invisibility

Encrypted traffic can still produce metadata and behavioral indicators.

### 3. Privileges matter

The same command can behave differently depending on the account running Meterpreter.

### 4. Extensions increase capability

Loading extensions can significantly expand what a session can do.

### 5. Every target is different

Available commands, payloads, architectures, network paths, and privileges depend on the target.

---

# Quick Revision

```text
Meterpreter
    ↓
Metasploit post-exploitation payload
    ↓
Runs as an agent on the target
    ↓
Provides an interactive session
    ↓
Can perform:
    ├── System enumeration
    ├── Process enumeration
    ├── File operations
    ├── Network enumeration
    ├── Privilege-related operations
    └── Extension-based functionality
```

### Most Important Commands

```text
help       → What can I do?
getuid     → Who am I?
sysinfo    → What system am I on?
getpid     → What process am I in?
ps         → What processes are running?
migrate    → Move the session to another process
pwd / ls   → Where am I / what is here?
search     → Find files
ifconfig   → Show network interfaces
netstat    → Show network connections
shell      → Open a normal command shell
hashdump   → Retrieve Windows SAM hashes (with required privileges)
load       → Add Meterpreter functionality
```

---

# Final Takeaways

- Meterpreter is a **Metasploit post-exploitation payload**.
- It provides much more functionality than a basic command shell.
- It can operate from memory and communicate through an encrypted channel.
- Meterpreter has **staged and stageless** variants.
- Payload selection depends on the **target OS, available components, and network connectivity**.
- `help` is essential because commands vary by Meterpreter version and loaded extensions.
- `getuid`, `sysinfo`, and `ps` are excellent starting points for understanding a session.
- Process migration can affect session stability and privileges.
- Meterpreter supports file, network, and system interaction.
- Extensions such as `kiwi` can add powerful functionality.
- Meterpreter should be practiced only in **authorized labs and penetration-testing environments**.

---

## Lab Safety

The commands and techniques in this README can provide significant access to a target system.

Use them only against:

- Your own systems
- Dedicated cybersecurity labs
- CTF environments
- Systems for which you have explicit authorization

The goal of learning Meterpreter should be to understand **how post-exploitation works and how defenders can detect and prevent it**, not to access systems without permission.
