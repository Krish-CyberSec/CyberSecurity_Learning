# Snort — Complete IDS & Network Intrusion Detection Guide

> Practical, beginner-friendly notes covering Snort, IDS concepts, operating modes, configuration, rules, custom detections, live monitoring, PCAP analysis, alert tuning, troubleshooting, and SOC workflows.

## Safety & Lab Notice

Use Snort only on networks and systems you own or are explicitly authorized to monitor. Practice custom rules with controlled traffic and test data.

---

## 1. What Is Snort?

**Snort** is an open-source network security tool used for network traffic analysis and intrusion detection.

Core workflow:

```text
Network Traffic
      ↓
    Snort
      ↓
Packet Inspection
      ↓
Rules / Detection Logic
      ↓
Match?
   ┌──┴──┐
  YES    NO
   ↓      ↓
 Alert  Continue
```

Snort can be used for:

- Intrusion detection
- Network monitoring
- Packet inspection
- Packet logging
- Security alerting
- PCAP analysis
- Custom traffic detection

---

## 2. IDS vs IPS

### IDS — Intrusion Detection System

An IDS primarily detects suspicious activity and generates alerts.

```text
Traffic → IDS → Detection → Alert
```

### IPS — Intrusion Prevention System

An IPS can detect activity and take preventive action.

```text
Traffic → IPS → Detection → Block / Drop
```

Easy memory trick:

```text
IDS = Detect
IPS = Detect + Prevent
```

Snort is commonly used as an IDS and can also participate in prevention deployments depending on configuration and architecture.

---

## 3. Snort Detection

Snort uses rules/signatures to identify traffic patterns.

```text
Traffic
   ↓
Inspect
   ↓
Apply rules
   ↓
Match?
   ↓
Alert
```

Built-in rules can detect many known patterns, while custom rules allow defenders to detect environment-specific traffic.

---

## 4. Signature-Based Detection

Signature-based detection searches for known patterns.

```text
Packet
  ↓
Known pattern?
  ↓
YES → Alert
```

### Advantages

- Effective for known threats
- Rules are explicit
- Easy to test
- Useful for repeatable detection

### Limitations

- Unknown threats may lack signatures
- Poor rules can create false positives
- Variations in traffic may evade simplistic signatures

---

## 5. Anomaly-Based Detection

Anomaly detection looks for deviations from expected behavior.

```text
Normal Behavior
      ↓
Baseline
      ↓
Observed Traffic
      ↓
Deviation?
      ↓
Potential Alert
```

This can help identify unusual activity, but accurate baselines can be difficult to maintain.

---

## 6. Snort Operating Modes

The three important modes are:

```text
Packet Sniffer
      ↓
Packet Logging
      ↓
NIDS
```

### Packet Sniffer Mode

Displays network packets without normal IDS analysis.

Useful for:

- Troubleshooting
- Traffic observation
- Protocol learning
- Network diagnostics

Mental model:

> **Sniffer = See**

---

### Packet Logging Mode

Records network traffic, commonly as PCAP, for later analysis.

Useful for:

- Forensics
- Incident investigation
- Root-cause analysis
- Historical traffic analysis

Mental model:

> **Logger = Save**

---

### NIDS Mode

Monitors network traffic and applies detection rules in real time.

```text
Traffic
   ↓
Snort
   ↓
Rules
   ↓
Match
   ↓
Alert
```

Mental model:

> **NIDS = Detect**

---

## 7. Mode Comparison

| Mode | Purpose | Typical Use |
|---|---|---|
| Packet Sniffer | Display traffic | Troubleshooting |
| Packet Logging | Save traffic | Forensics |
| NIDS | Detect suspicious traffic | Security monitoring |

---

## 8. Network Interface & Promiscuous Mode

Snort needs a network interface for packet capture.

Examples:

```text
eth0
ens33
enp0s3
lo
```

In a normal capture, the host generally receives traffic intended for it.

A network sensor may use **promiscuous mode** to receive packets beyond the host's normal destination traffic, depending on the network architecture.

However, promiscuous mode alone does not guarantee visibility into every packet on a switched network.

Real deployments may use:

- Network TAPs
- SPAN/mirror ports
- Inline placement
- Appropriate sensor architecture

Important concept:

```text
Sensor cannot detect traffic it cannot see.
```

---

## 9. Snort Configuration

A common Snort configuration directory is:

```text
/etc/snort/
```

But the actual location depends on installation.

Typical files may include:

```text
snort.lua
rules/
classification.config
reference.config
threshold.config
```

For Snort 3, `snort.lua` is commonly the main configuration file.

Configuration is supplied using:

```text
-c
```

Example:

```bash
snort -c /path/to/snort.lua
```

---

## 10. HOME_NET

`$HOME_NET` represents the protected/local network defined in Snort's configuration.

Conceptually:

```text
$HOME_NET = 192.168.1.0/24
```

A rule can then use:

```text
$HOME_NET
```

instead of hard-coding the network.

This makes rules easier to maintain when the network changes.

---

## 11. Snort Rule Structure

A Snort rule consists broadly of a **header** and **options**.

```text
action protocol source source_port
    ->
destination destination_port
    (options)
```

Example structure:

```text
alert icmp any any -> $HOME_NET any
(msg:"Example"; sid:10001; rev:1;)
```

---

## 12. Rule Header Components

### Action

Defines what happens when the rule matches.

Common detection action:

```text
alert
```

### Protocol

Examples:

```text
TCP
UDP
ICMP
IP
```

### Source IP

Where traffic originates.

```text
any
```

means any source.

### Source Port

The originating port.

```text
any
```

means any source port.

### Direction

Common operator:

```text
->
```

### Destination IP

Where traffic is going.

Example:

```text
$HOME_NET
```

### Destination Port

Example:

```text
any
```

means any destination port.

---

## 13. Rule Options

Rule options provide additional detection logic and metadata.

### `msg`

Describes the alert.

```text
msg:"Loopback Ping Detected";
```

### `sid`

The **Signature ID** uniquely identifies the rule.

```text
sid:10003;
```

Think:

```text
SID = Rule ID
```

### `rev`

The rule revision number.

```text
rev:1;
```

Increment it when modifying the rule.

```text
rev:1
  ↓
Rule changed
  ↓
rev:2
```

---

## 14. Example Custom Rule

A simple lab rule can detect ICMP traffic to the loopback address:

```text
alert icmp any any -> 127.0.0.1 any
(msg:"Loopback Ping Detected"; sid:10003; rev:1;)
```

Breakdown:

```text
alert
  ↓
Generate alert

icmp
  ↓
Watch ICMP

any
  ↓
Any source

any
  ↓
Any source port

->
  ↓
Traffic direction

127.0.0.1
  ↓
Destination

any
  ↓
Any destination port

msg
  ↓
Alert message

sid
  ↓
Rule identifier

rev
  ↓
Revision
```

---

## 15. Custom Rules

Custom rules are useful when built-in detection does not cover your environment's requirements.

Possible defensive use cases:

- Unexpected ICMP activity
- Specific protocol behavior
- Traffic to a sensitive internal service
- Known test indicators
- Environment-specific network patterns

A good custom rule should have:

- Clear purpose
- Correct scope
- Unique SID
- Useful message
- Correct protocol
- Correct direction
- Test coverage
- Revision tracking

---

## 16. Local Rules

Custom rules are often maintained in a local rule file such as:

```text
local.rules
```

A common location is:

```text
/etc/snort/rules/local.rules
```

The exact path depends on your installation.

Avoid deleting existing rules blindly.

---

## 17. Rule Development Workflow

Use this process:

```text
Detection Goal
      ↓
Write Rule
      ↓
Validate Configuration
      ↓
Start Snort
      ↓
Generate Controlled Traffic
      ↓
Observe Alert
      ↓
Test Legitimate Traffic
      ↓
Tune
      ↓
Document Revision
```

This is the beginning of **detection engineering**.

---

## 18. Running Snort for Real-Time Detection

A typical command pattern is:

```bash
sudo snort -q -l /var/log/snort -i <interface> -A alert_fast -c /path/to/snort.lua
```

Important options:

```text
-q
 ↓
Reduce startup output

-l
 ↓
Log directory

-i
 ↓
Interface

-A alert_fast
 ↓
Alert output format

-c
 ↓
Configuration file
```

Example for a controlled loopback lab:

```bash
sudo snort -q -l /var/log/snort -i lo -A alert_fast -c /etc/snort/snort.lua
```

Use the interface and configuration path that exist on your system.

---

## 19. Testing the ICMP Rule

Generate controlled loopback traffic:

```bash
ping 127.0.0.1
```

Workflow:

```text
ping
  ↓
ICMP packet
  ↓
Snort
  ↓
Rule matches
  ↓
Alert
```

An alert may look conceptually like:

```text
[**] [1:10003:1] "Loopback Ping Detected" [**]
{ICMP} 127.0.0.1 -> 127.0.0.1
```

Exact formatting depends on the Snort version and configuration.

---

## 20. Understanding Alert IDs

An alert may contain:

```text
[1:10003:1]
```

This can be read conceptually as:

```text
Generator ID : Signature ID : Revision
```

Therefore:

```text
1 : 10003 : 1
```

represents:

```text
Generator → 1
SID       → 10003
Revision  → 1
```

For custom detection management, the SID and revision are especially important.

---

## 21. PCAP Analysis

Snort can analyze historical packet captures.

This is useful for:

- Incident response
- Digital forensics
- Threat hunting
- Detection validation
- Historical investigation

Workflow:

```text
PCAP
 ↓
Snort
 ↓
Rules
 ↓
Alerts
 ↓
Investigation
```

---

## 22. Running Snort Against a PCAP

General command:

```bash
sudo snort -q -l /var/log/snort -r <file.pcap> -A alert_fast -c /path/to/snort.lua
```

Example:

```bash
sudo snort -q -l /var/log/snort -r Task.pcap -A alert_fast -c /etc/snort/snort.lua
```

The key difference is:

```text
-i <interface>
```

for live traffic versus:

```text
-r <pcap>
```

for recorded traffic.

---

## 23. Live Traffic vs PCAP

| Scenario | Input |
|---|---|
| Real-time monitoring | Network interface |
| Historical investigation | PCAP |
| Troubleshooting | Packet stream |
| Forensics | Recorded traffic |

Mental model:

```text
LIVE
Interface → Snort → Alert

PCAP
PCAP → Snort → Alert
```

---

## 24. Snort + Wireshark

These tools complement each other.

### Snort

Best for:

- Automated detection
- Rule-based alerting
- IDS monitoring
- Detection engineering

### Wireshark

Best for:

- Deep packet inspection
- Manual protocol analysis
- Conversation analysis
- Individual packet investigation

Workflow:

```text
Snort Alert
     ↓
Identify suspicious traffic
     ↓
Open PCAP
     ↓
Wireshark
     ↓
Investigate packets
```

---

## 25. Snort + SIEM

In a SOC, Snort alerts can become security telemetry.

```text
Network
   ↓
Snort
   ↓
Alerts
   ↓
Log Collection
   ↓
SIEM
   ↓
Correlation
   ↓
SOC Analyst
```

A SIEM can correlate Snort alerts with:

- Firewall logs
- Authentication logs
- Endpoint telemetry
- DNS logs
- Proxy logs
- Cloud security events

---

## 26. False Positives

A **false positive** occurs when legitimate activity triggers an alert.

Example:

```text
Legitimate traffic
      ↓
Snort rule
      ↓
Alert
```

Too many false positives can cause:

- Alert fatigue
- Wasted analyst time
- Missed important alerts
- Reduced confidence in detections

---

## 27. False Negatives

A **false negative** occurs when suspicious/malicious activity happens but the detection does not trigger.

Possible causes:

- No suitable rule
- Rule too narrow
- Traffic differs from expected pattern
- Encryption hides content
- Evasion
- Incorrect sensor placement

A good detection program balances:

```text
Detection Coverage
        ↕
False Positives
        ↕
Operational Value
```

---

## 28. Rule Tuning

If a rule is noisy, improve its precision rather than blindly disabling it.

Possible approaches:

- Narrow source scope
- Narrow destination scope
- Narrow ports
- Add protocol constraints
- Add content/context conditions
- Use thresholds where appropriate
- Carefully exclude known legitimate traffic

Example:

```text
Too broad:
Alert on all ICMP

Better:
Alert on a specific ICMP behavior
relevant to the environment
```

Always test tuning changes against both suspicious and legitimate traffic.

---

## 29. Rule Lifecycle

Treat rules like software:

```text
Create
  ↓
Test
  ↓
Deploy
  ↓
Monitor
  ↓
Tune
  ↓
Revise
  ↓
Retire
```

Document:

- Why the rule exists
- What behavior it detects
- Expected legitimate traffic
- Known false positives
- Test procedure
- Owner
- Revision history

---

## 30. Sensor Placement

Snort can only detect traffic visible to its sensor.

Possible architectures include:

```text
Network
   ↓
TAP / SPAN
   ↓
Snort Sensor
   ↓
Alerts
```

Important deployment concepts:

- Host-based visibility
- Network-segment visibility
- TAP
- SPAN/mirror port
- Inline deployment

The placement determines what Snort can actually observe.

---

## 31. Encryption and IDS Visibility

Encrypted traffic creates a visibility challenge.

```text
Client
  ↓
TLS Encryption
  ↓
Network
  ↓
Snort
```

Depending on the deployment, Snort may still observe metadata such as:

- Source
- Destination
- Ports
- Protocol
- Timing
- Packet sizes

But encrypted application content may not be directly visible.

TLS inspection can provide additional visibility, but it introduces operational, privacy, and security considerations.

---

## 32. Detection Engineering Mindset

Do not think:

> "I need another rule."

Think:

```text
Threat / Behavior
       ↓
What observable evidence exists?
       ↓
Can I express it as a detection?
       ↓
What legitimate traffic also matches?
       ↓
How noisy will it be?
       ↓
What will the analyst do next?
```

A useful detection should be actionable, not merely technically correct.

---

## 33. Troubleshooting

### Snort sees no traffic

Check:

- Interface name
- Capture permissions
- Sensor placement
- Capture configuration
- Network path

Find interfaces with:

```bash
ip addr
```

---

### Rule does not trigger

Check:

```text
Rule syntax
Rule file path
Rule enabled in configuration
Correct interface
Correct source/destination
Correct protocol
Correct test traffic
```

---

### Too many alerts

Likely causes:

- Rule too broad
- Legitimate traffic matches
- Missing context
- Insufficient tuning

Investigate samples before changing the rule.

---

### PCAP produces no alerts

Check:

```text
PCAP readable?
Expected traffic present?
Correct configuration loaded?
Rule enabled?
Rule actually matches packet?
```

---

## 34. Practical Lab

A small authorized lab can look like:

```text
┌─────────────────┐
│ Test Client     │
└────────┬────────┘
         │
      Network
         │
         ▼
┌─────────────────┐
│ Snort Sensor    │
│ Linux VM        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Test Server     │
└─────────────────┘
```

Practice progression:

### Level 1
Understand packets.

### Level 2
Capture traffic.

### Level 3
Create a simple detection rule.

### Level 4
Run live detection.

### Level 5
Analyze a PCAP.

### Level 6
Tune false positives.

### Level 7
Integrate alerts into a SIEM.

---

## 35. Snort in a SOC

Snort connects several cybersecurity skills:

```text
Networking
    ↓
TCP/IP
    ↓
Packet Analysis
    ↓
IDS
    ↓
Detection Engineering
    ↓
Threat Detection
    ↓
Incident Response
    ↓
SIEM / SOC
```

A SOC analyst should be able to answer:

```text
What triggered the alert?
Who communicated with whom?
Which protocol/port was involved?
Is the traffic expected?
What evidence supports the alert?
What other logs should I correlate?
What should happen next?
```

---

## 36. Quick Command Reference

### Identify interfaces

```bash
ip addr
```

### Show help

```bash
snort --help
```

### Load a configuration

```bash
sudo snort -c /path/to/snort.lua
```

### Live detection

```bash
sudo snort -q -l /var/log/snort -i <interface> -A alert_fast -c /path/to/snort.lua
```

### PCAP analysis

```bash
sudo snort -q -l /var/log/snort -r <file.pcap> -A alert_fast -c /path/to/snort.lua
```

### Controlled ICMP rule

```text
alert icmp any any -> 127.0.0.1 any
(msg:"Loopback Ping Detected"; sid:10003; rev:1;)
```

---

## 37. Quick Revision Cheat Sheet

```text
SNORT
│
├── IDS
│   └── Detect + Alert
│
├── Modes
│   ├── Packet Sniffer → See
│   ├── Packet Logger  → Save
│   └── NIDS           → Detect
│
├── Configuration
│   ├── snort.lua
│   ├── HOME_NET
│   └── Rule files
│
├── Rule Header
│   ├── Action
│   ├── Protocol
│   ├── Source
│   ├── Source Port
│   ├── Direction
│   ├── Destination
│   └── Destination Port
│
├── Rule Options
│   ├── msg
│   ├── sid
│   └── rev
│
└── Investigation
    ├── Live Traffic
    ├── PCAP
    ├── Wireshark
    └── SIEM
```

---

## 38. Learning Checklist

### Fundamentals

- [ ] Understand IDS
- [ ] Understand IPS
- [ ] Understand Snort
- [ ] Signature-based detection
- [ ] Anomaly-based detection
- [ ] False positives
- [ ] False negatives

### Modes

- [ ] Packet Sniffer
- [ ] Packet Logging
- [ ] NIDS

### Configuration

- [ ] `snort.lua`
- [ ] `$HOME_NET`
- [ ] Rule directories
- [ ] Network interfaces
- [ ] Capture visibility

### Rules

- [ ] Action
- [ ] Protocol
- [ ] Source IP
- [ ] Source port
- [ ] Direction
- [ ] Destination IP
- [ ] Destination port
- [ ] `msg`
- [ ] `sid`
- [ ] `rev`

### Detection Engineering

- [ ] Write a custom rule
- [ ] Test it
- [ ] Analyze alerts
- [ ] Identify false positives
- [ ] Tune it
- [ ] Track revisions

### Forensics

- [ ] Analyze PCAPs
- [ ] Understand packet capture
- [ ] Use Snort with historical traffic
- [ ] Combine Snort with Wireshark

### SOC

- [ ] Alert triage
- [ ] Detection-to-investigation workflow
- [ ] SIEM integration
- [ ] Sensor placement

---

## 39. Personal Notes Template

### Detection Rule

```text
Rule Name:

Threat / Behavior:

Protocol:

Source:

Source Port:

Destination:

Destination Port:

Action:

SID:

Revision:

Why does this rule exist?

Expected legitimate traffic:

Expected suspicious traffic:

Known false positives:

How I tested it:

Result:
```

### Alert Investigation

```text
Alert:

Timestamp:

Source IP:

Destination IP:

Source Port:

Destination Port:

Protocol:

SID:

Revision:

Related packets:

Related hosts:

What happened?

Is it expected?

Evidence:

Next action:
```

### PCAP Investigation

```text
PCAP:

Capture Time:

Network:

Interesting Hosts:

Interesting Ports:

Protocols:

Snort Alerts:

Wireshark Findings:

Potential Incident:

Evidence:

Conclusion:
```

---

## 40. Future Topics

- [ ] Snort 3 architecture
- [ ] Snort modules
- [ ] Advanced rule syntax
- [ ] Content matching
- [ ] PCRE-based detection
- [ ] Flow-based detection
- [ ] Thresholding
- [ ] Suppression
- [ ] Classification
- [ ] Priority
- [ ] Rule optimization
- [ ] Detection engineering
- [ ] Snort logging formats
- [ ] Snort + Wireshark
- [ ] Snort + ELK
- [ ] Snort + Splunk
- [ ] Snort + SIEM
- [ ] Snort IPS deployments
- [ ] Network TAP/SPAN design
- [ ] TLS visibility
- [ ] Threat hunting with PCAP
- [ ] Production-quality IDS signatures

---

## 41. Final Mental Model

```text
             NETWORK TRAFFIC
                    ↓
              ┌──────────┐
              │  SNORT   │
              └────┬─────┘
                   ↓
              Inspect Traffic
                   ↓
              Apply Rules
                   ↓
              Match Found?
              /                      YES           NO
             ↓             ↓
          ALERT          Continue
             ↓
       Analyst / SIEM
             ↓
      Investigate / Respond
```

Historical analysis:

```text
PCAP
 ↓
Snort
 ↓
Rules
 ↓
Alerts
 ↓
Investigation
```

Detection engineering:

```text
Threat Behavior
      ↓
Observable Pattern
      ↓
Snort Rule
      ↓
Controlled Test
      ↓
Alert
      ↓
Tune
      ↓
Deploy
      ↓
Monitor
      ↓
Revise
```

## One-Line Takeaway

> **Snort is not just a packet sniffer — it is a detection engine. The real skill is learning how to turn network behavior into reliable, testable, low-noise security detections.**
