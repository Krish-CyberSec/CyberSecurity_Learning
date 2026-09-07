# Metasploit Framework — Practical Notes

A beginner-friendly reference for understanding the Metasploit Framework, its module types, `msfconsole`, module context, payloads, parameters, sessions, and the basic workflow used in an authorized penetration-testing lab.

> **Scope:** These notes are based on the supplied learning material. Use Metasploit only against systems you own or are explicitly authorized to test.

---

## 1. What Is Metasploit?

Metasploit Framework is a penetration-testing framework that provides modules for tasks such as:

- Exploiting vulnerabilities
- Scanning targets
- Running supporting security tasks
- Delivering payloads
- Performing post-exploitation activities

The primary interface covered in these notes is:

```bash
msfconsole
```

After launching it, the prompt normally becomes similar to:

```text
msf6 >
```

---

## 2. Three Core Concepts

### Vulnerability

A **vulnerability** is a design, coding, or logic flaw affecting a target system.

Think of it as a **weakness**.

### Exploit

An **exploit** is code that takes advantage of a vulnerability.

Think of it as the **method used to exploit the weakness**.

### Payload

A **payload** is code that runs on the target system after an exploit successfully takes advantage of a vulnerability.

Think of it as the **action or result you want from the exploit**.

```text
Vulnerability → Exploit → Payload → Desired Result
```

---

# 3. Metasploit Module Categories

The main module categories covered in the material are:

- Auxiliary
- Encoders
- Evasion
- Exploits
- NOPs
- Payloads
- Post

---

## 3.1 Auxiliary

Auxiliary modules provide supporting functionality such as:

- Scanners
- Crawlers
- Fuzzers
- Other security tasks

Example structure:

```text
auxiliary/
├── admin
├── analyze
├── bnat
├── client
├── cloud
├── crawler
├── docx
├── dos
├── fileformat
├── fuzzers
├── gather
├── parser
├── pdf
├── scanner
├── server
├── sniffer
├── spoof
├── sqli
├── voip
└── vsploit
```

---

## 3.2 Encoders

**Encoders** encode exploits and payloads. The material notes that encoding may sometimes help a payload avoid detection by signature-based antivirus, although this has limited success because security solutions can perform additional checks.

```text
Encoder → transforms/encodes
```

Example categories include:

```text
encoders/
├── cmd
├── generic
├── mipsbe
├── mipsle
├── php
├── ppc
├── ruby
├── sparc
├── x64
└── x86
```

---

## 3.3 Evasion

**Evasion modules** specifically attempt to evade antivirus or other security detection.

The key distinction is:

```text
Encoder → encodes
Evasion → attempts to evade detection
```

Example:

```text
evasion/
└── windows
    ├── applocker_evasion_install_util.rb
    ├── applocker_evasion_msbuild.rb
    ├── applocker_evasion_presentationhost.rb
    ├── applocker_evasion_regasm_regsvcs.rb
    ├── applocker_evasion_workflow_compiler.rb
    ├── process_herpaderping.rb
    ├── syscall_inject.rb
    ├── windows_defender_exe.rb
    └── windows_defender_js_hta.rb
```

---

## 3.4 Exploits

Exploit modules contain exploits organized by target platform/system.

Example categories:

```text
exploits/
├── aix
├── android
├── apple_ios
├── bsd
├── bsdi
├── dialup
├── firefox
├── freebsd
├── hpux
├── irix
├── linux
├── mainframe
├── multi
├── netware
├── openbsd
├── osx
├── qnx
├── solaris
├── unix
└── windows
```

---

## 3.5 NOPs

NOP means **No Operation**.

A NOP instruction does nothing. The supplied material gives `0x90` as the Intel x86 NOP instruction and explains that NOPs can be used as a buffer to achieve consistent payload sizes.

```text
nops/
├── aarch64
├── armle
├── cmd
├── mipsbe
├── php
├── ppc
├── sparc
├── tty
├── x64
└── x86
```

---

# 4. Payloads

Payloads are code that runs on the target system.

Examples mentioned in the material include:

- Getting a shell
- Loading malware or a backdoor
- Running a command
- Launching `calc.exe` as a benign proof of concept

An interactive command-line connection is called a **shell**.

---

## 4.1 Payload Structure

Metasploit organizes payloads into:

```text
payloads/
├── adapters
├── singles
├── stagers
└── stages
```

### Adapters

Adapters wrap single payloads and convert them into different formats. The material gives a PowerShell adapter as an example.

### Singles

Self-contained payloads that do not need to download an additional component.

Examples include adding a user or launching Notepad.

### Stagers

Stagers establish a connection channel between Metasploit and the target. With a staged payload, the stager is delivered first and then downloads the larger stage.

### Stages

Stages are the larger payload components downloaded by the stager.

```text
Stager → establishes connection → Stage downloaded
```

---

## 4.2 Single vs Staged Payloads

The material uses naming conventions to distinguish them.

**Single / inline:**

```text
generic/shell_reverse_tcp
```

**Staged:**

```text
windows/x64/shell/reverse_tcp
```

Quick comparison:

| Type | Example | Structure |
|---|---|---|
| Single / Inline | `generic/shell_reverse_tcp` | Self-contained |
| Staged | `windows/x64/shell/reverse_tcp` | Stager + Stage |

---

# 5. Post Modules

**Post modules** are useful during the post-exploitation phase.

They work with an existing connection/session.

Example categories include:

```text
post/
├── aix
├── android
├── apple_ios
├── bsd
├── firefox
├── hardware
├── linux
├── multi
├── networking
├── osx
├── solaris
└── windows
```

---

# 6. Starting Metasploit

Launch Metasploit with:

```bash
msfconsole
```

Then you normally see:

```text
msf6 >
```

The console is the main interface for interacting with Metasploit modules.

---

# 7. Linux Commands in Metasploit

`msfconsole` supports many Linux commands.

Example:

```text
msf6 > ls
[*] exec: ls
```

You can also run:

```text
msf6 > ping -c 1 8.8.8.8
```

However, `msfconsole` is not identical to a normal shell. For example, output redirection does not work in the same way:

```text
msf6 > help > help.txt
[-] No such command
```

---

# 8. Useful Console Commands

## `help`

Displays help.

```text
help
help set
```

## `history`

Displays previously entered commands.

```text
history
```

## Tab completion

Pressing `Tab` can autocomplete commands and module names.

---

# 9. Metasploit Context

Metasploit is **context-based**.

When you select a module with `use`, the prompt changes to show the active module.

Example:

```text
msf6 > use exploit/windows/smb/ms17_010_eternalblue
```

The prompt becomes:

```text
msf6 exploit(windows/smb/ms17_010_eternalblue) >
```

Settings created with `set` belong to the current module context.

If you switch modules, those settings normally do not carry over.

---

# 10. `use`

Select a module with:

```text
use <module>
```

Example:

```text
use exploit/windows/smb/ms17_010_eternalblue
```

You can also use a result number from `search`:

```text
use 2
```

---

# 11. `show`

The `show` command displays information available in the current context.

Common examples:

```text
show options
show payloads
```

### `show options`

Displays parameters required by the current module.

### `show payloads`

Displays payloads compatible with the selected exploit.

---

# 12. Important Parameters

| Parameter | Meaning |
|---|---|
| `RHOSTS` | Remote target host(s) |
| `RPORT` | Remote target service port |
| `PAYLOAD` | Payload used with the exploit |
| `LHOST` | Local/listening address |
| `LPORT` | Local/listening port |
| `SESSION` | Existing session ID |

### RHOSTS

Remote host(s). Can specify a single IP, network range, CIDR notation, or a target file.

Example:

```text
set RHOSTS 10.10.165.39
```

### RPORT

Remote port where the target service is running.

Example:

```text
set RPORT 445
```

### PAYLOAD

Specifies the payload.

### LHOST

The local/testing machine address that receives a reverse connection.

### LPORT

The local port used for a reverse connection.

### SESSION

The ID of an established Metasploit connection. Post-exploitation modules can use this value.

---

# 13. `set`

Basic syntax:

```text
set PARAMETER_NAME VALUE
```

Example:

```text
set RHOSTS 10.10.165.39
```

Always verify important settings with:

```text
show options
```

---

# 14. Clearing Settings

Clear one option:

```text
unset RHOSTS
```

Clear all module settings:

```text
unset all
```

Then verify with:

```text
show options
```

---

# 15. Global Settings with `setg`

`setg` sets a value in the global datastore.

Example:

```text
setg RHOSTS 10.10.165.39
```

Unlike `set`, a global value can be reused across different module contexts.

Clear a global value with:

```text
unsetg RHOSTS
```

Quick comparison:

```text
set
 ↓
Current module

setg
 ↓
Global datastore
 ↓
Reusable across modules
```

---

# 16. Leaving a Module

Use:

```text
back
```

to leave the current module context.

Example:

```text
msf6 exploit(...) > back
msf6 >
```

This returns to the main Metasploit console; it does not exit Metasploit.

---

# 17. `info`

Use:

```text
info
```

inside a module context to see detailed information about the module.

You can also specify a module path:

```text
info exploit/windows/smb/ms17_010_eternalblue
```

Information can include:

- Module name/path
- Platform and architecture
- Privilege requirements
- Rank
- Disclosure date
- Authors/providers
- Targets
- Options
- Description
- References

`info` is more than a basic help menu; it provides detailed module information.

---

# 18. Searching for Modules

Use:

```text
search <term>
```

You can search using things such as:

- CVE numbers
- Exploit names
- Target systems
- Other supported keywords

Example:

```text
search ms17-010
```

Search results may include different module types.

You can select a result using its number:

```text
use 2
```

---

# 19. Search Filters

Metasploit supports filters such as `type`.

Example:

```text
search type:auxiliary telnet
```

This restricts the results to auxiliary modules matching the search.

Search results commonly include:

| Column | Meaning |
|---|---|
| `#` | Result index |
| `Name` | Module path |
| `Disclosure Date` | Disclosure date |
| `Rank` | Exploit reliability ranking |
| `Check` | Whether checking is supported |
| `Description` | Module description |

---

# 20. Exploit Ranking

Metasploit ranks exploits according to their reliability.

The important point is:

> A highly ranked exploit is not guaranteed to work, and a lower-ranked exploit may still work.

Exploitation can also produce unexpected behavior, including system instability or crashes.

---

# 21. MS17-010 / EternalBlue Example

The supplied material uses **MS17-010 EternalBlue** to demonstrate Metasploit concepts.

Module:

```text
exploit/windows/smb/ms17_010_eternalblue
```

The example works with SMB and uses port:

```text
445
```

The example demonstrates:

- Selecting an exploit
- Viewing options
- Setting parameters
- Viewing compatible payloads
- Reading module information
- Running the module
- Creating and managing sessions

> The EternalBlue example is included here as a learning example from the supplied material. Reproduce exploitation only in an authorized lab.

---

# 22. Module Configuration Workflow

A common workflow is:

```text
use module
     ↓
show options
     ↓
set parameters
     ↓
show options
     ↓
check (if supported)
     ↓
run / exploit
```

Example structure:

```text
msf6 > use <module>
msf6 exploit(...) > info
msf6 exploit(...) > show options
msf6 exploit(...) > set RHOSTS <LAB_TARGET>
msf6 exploit(...) > show options
msf6 exploit(...) > check
msf6 exploit(...) > run
```

Only use real target values when the target is explicitly authorized.

---

# 23. `run` vs `exploit`

Metasploit supports:

```text
run
```

and:

```text
exploit
```

The material explains that `run` is an alias for `exploit` and is useful because not every module is an exploit, such as scanners.

For exploit modules:

```text
exploit
```

is commonly used.

---

# 24. `exploit -z`

The material describes:

```text
exploit -z
```

as a way to run an exploit and background the resulting session when it opens.

This is useful when you want to return to the Metasploit console instead of immediately entering the session.

---

# 25. Sessions

A **session** is the communication channel established between Metasploit and a target after successful exploitation.

List sessions with:

```text
sessions
```

Example:

```text
msf6 > sessions
```

A session listing can contain:

- Session ID
- Session type
- Target information
- Connection details

---

# 26. Interacting with Sessions

Use:

```text
sessions -i <SESSION_ID>
```

Example:

```text
sessions -i 2
```

This can take you into a Meterpreter prompt:

```text
meterpreter >
```

---

# 27. Backgrounding a Session

From Meterpreter:

```text
background
```

You can also use:

```text
CTRL+Z
```

to background the session.

Then return to the Metasploit console and list sessions with:

```text
sessions
```

---

# 28. Understanding the Prompts

Metasploit can have several different prompts.

### Normal terminal

```text
root@machine:~#
```

The operating system's regular shell.

### Metasploit console

```text
msf6 >
```

No module context is selected.

### Module context

```text
msf6 exploit(windows/smb/ms17_010_eternalblue) >
```

A module is selected.

### Meterpreter

```text
meterpreter >
```

You are interacting with a Meterpreter session.

### Target shell

Example:

```text
C:\Windows\system32>
```

Commands entered here execute on the target system.

Visual model:

```text
Local Terminal
      ↓
  msfconsole
      ↓
    msf6 >
      ↓
 Module Context
      ↓
  Meterpreter
      ↓
 Target Shell
```

---

# 29. `check`

Some modules support:

```text
check
```

This checks whether the target appears vulnerable without performing the actual exploitation step.

It is useful for validating the target when the selected module supports vulnerability checking.

---

# 30. Practical Command Reference

| Command | Purpose |
|---|---|
| `msfconsole` | Start Metasploit |
| `help` | Display help |
| `help <command>` | Help for a specific command |
| `history` | Show command history |
| `search <term>` | Search modules |
| `use <module>` | Select a module |
| `show options` | Display module parameters |
| `show payloads` | Display compatible payloads |
| `info` | Display detailed module information |
| `set <option> <value>` | Set a module option |
| `setg <option> <value>` | Set a global option |
| `unset <option>` | Clear an option |
| `unset all` | Clear module options |
| `unsetg <option>` | Clear a global option |
| `back` | Leave current module context |
| `check` | Check vulnerability when supported |
| `run` | Execute the current module |
| `exploit` | Execute an exploit module |
| `exploit -z` | Run exploit and background resulting session |
| `sessions` | List sessions |
| `sessions -i <id>` | Interact with a session |
| `background` | Background a Meterpreter session |

---

# 31. Core Metasploit Mental Model

Remember the module structure:

```text
Metasploit
   │
   ├── Auxiliary
   ├── Encoders
   ├── Evasion
   ├── Exploits
   ├── NOPs
   ├── Payloads
   └── Post
```

Remember the exploitation concepts:

```text
Vulnerability
      ↓
   Exploit
      ↓
   Payload
      ↓
   Session
      ↓
Post-exploitation
```

Remember configuration:

```text
set
 ↓
Current module

setg
 ↓
Global datastore
```

Remember payload types:

```text
Single
 ↓
Self-contained

Staged
 ↓
Stager
 ↓
Stage
```

---

# 32. Safety and Lab Practice

Metasploit contains powerful offensive-security capabilities.

Use it only in environments where you have explicit authorization, such as:

- Your own virtual machines
- A dedicated cybersecurity lab
- A CTF environment
- An authorized training platform
- Systems for which you have written permission

Some exploits can cause instability, crashes, or reboots. The supplied material specifically warns about this possibility.

For learning, an isolated lab is the safest environment.

---

## Quick Cheat Sheet

```text
START
  msfconsole

SEARCH
  search <term>

SELECT
  use <module>

READ
  info

VIEW SETTINGS
  show options

CONFIGURE
  set <OPTION> <VALUE>

VERIFY
  show options

CHECK
  check

RUN
  run
  exploit

SESSIONS
  sessions
  sessions -i <ID>

BACKGROUND
  background

EXIT MODULE
  back
```

### The four terms to remember

```text
Vulnerability = weakness
Exploit       = code that takes advantage of the weakness
Payload       = code that runs after exploitation
Session       = communication channel with the target
```
