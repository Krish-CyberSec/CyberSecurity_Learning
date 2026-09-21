# Firewalls — Types, Rules, Directionality & Linux UFW

> Beginner-friendly cybersecurity notes on firewall types, OSI layers, rules, traffic direction, Netfilter, and UFW.

## ⚠️ Safety Note
Practice firewall changes only on systems you own or are authorized to administer. On remote systems, verify recovery access before changing firewall rules.

---

## 1. What Is a Firewall?

A firewall controls network traffic entering, leaving, or moving through a network.

```text
Network Traffic
      ↓
   Firewall
      ↓
Evaluate Rules
      ↓
Allow / Deny / Forward
```

Different firewall types operate at different OSI layers and provide different levels of inspection.

---

## 2. Firewall Types

The main types covered here are:

- Stateless Firewall
- Stateful Firewall
- Proxy Firewall
- Next-Generation Firewall (NGFW)

---

## 3. Stateless Firewall

A stateless firewall operates at **OSI Layer 3 and Layer 4**.

It filters packets using predefined rules but does not track previous connection state.

### Mental model

Think of a guard who checks every person against a rulebook but does not remember previous visits.

```text
Packet → Rules → Decision
```

### Characteristics

- Layer 3 and Layer 4
- Basic packet filtering
- No connection-state tracking
- Fast processing
- Cannot make decisions using previous connection history

---

## 4. Stateful Firewall

A stateful firewall also operates at **Layer 3 and Layer 4**, but tracks connections using a **state table**.

```text
Packet
  ↓
Rules + Connection State
  ↓
Decision
```

### Characteristics

- Tracks previous connections
- Maintains a state table
- Can apply rules based on connection history
- Provides more context than stateless filtering

### Easy comparison

```text
Stateless → "What does this packet look like?"
Stateful  → "What does this packet look like, and
             does it belong to a known connection?"
```

---

## 5. Proxy Firewall

A proxy firewall, or application-level gateway, operates at **OSI Layer 7**.

It acts as an intermediary:

```text
Client
  ↓
Proxy Firewall
  ↓
Internet / Server
```

It can inspect application-level content and apply content-filtering policies.

### Characteristics

- Layer 7
- Acts as an intermediary
- Application/content inspection
- Content filtering
- Application control
- Can mask internal IP addresses

---

## 6. Next-Generation Firewall (NGFW)

An NGFW provides advanced inspection and security capabilities across **Layer 3 to Layer 7**.

The source material describes capabilities including:

- Deep packet inspection
- Intrusion prevention
- Heuristic analysis
- Advanced threat protection
- SSL/TLS decryption and inspection
- Threat-intelligence correlation

### Mental model

```text
Stateless → packet rules
Stateful  → packet rules + connection state
Proxy     → application-level inspection
NGFW      → advanced inspection + threat protection
```

---

## 7. Firewall Comparison

| Firewall | OSI Layer | Main Idea |
|---|---|---|
| Stateless | L3/L4 | Basic rule-based filtering |
| Stateful | L3/L4 | Tracks connection state |
| Proxy | L7 | Application-level intermediary |
| NGFW | L3–L7 | Advanced inspection and threat protection |

---

## 8. Firewall Rules

Firewall rules define what happens to matching traffic.

A common rule contains:

```text
Source
Destination
Port
Protocol
Action
Direction
```

### Source Address
Where the traffic originates.

### Destination Address
Where the traffic is going.

### Port
The network port involved.

Examples:

```text
22  → SSH
80  → HTTP
443 → HTTPS
```

### Protocol

Examples:

```text
TCP
UDP
```

### Action

Common actions:

```text
Allow
Deny
Forward
```

### Direction

```text
Inbound
Outbound
Forward
```

---

## 9. Firewall Actions

### Allow

Permits matching traffic.

Example:

```text
Action:      Allow
Source:      192.168.1.0/24
Destination: Any
Protocol:    TCP
Port:        80
Direction:   Outbound
```

### Deny

Blocks matching traffic.

Example:

```text
Action:      Deny
Source:      Any
Destination: 192.168.1.0/24
Protocol:    TCP
Port:        22
Direction:   Inbound
```

### Forward

Redirects matching traffic to another network segment or destination.

Example:

```text
Action:      Forward
Source:      Any
Destination: 192.168.1.8
Protocol:    TCP
Port:        80
Direction:   Inbound
```

---

## 10. Rule Directionality

### Inbound

Applies to incoming traffic.

Example:

```text
Allow incoming HTTP
Port 80
```

### Outbound

Applies to outgoing traffic.

Example:

```text
Block outgoing SMTP
Port 25
```

### Forward

Handles traffic forwarded to another internal destination.

Example:

```text
Internet
   ↓
Firewall
   ↓
Internal Web Server
```

---

## 11. Linux Firewall Architecture

Linux provides firewall functionality through **Netfilter**.

```text
Linux Kernel
     ↓
  Netfilter
     ↓
 ┌───┼───────────────┐
 ↓   ↓       ↓       ↓
iptables nftables firewalld UFW
```

### Netfilter

Netfilter is the Linux framework providing core functionality such as:

- Packet filtering
- NAT
- Connection tracking

### iptables

A widely used firewall utility based on Netfilter.

### nftables

The successor to iptables, also based on Netfilter.

### firewalld

A Netfilter-based utility using predefined rule sets and network-zone configurations.

---

## 12. UFW — Uncomplicated Firewall

**UFW** provides a simpler interface for Linux firewall management.

Mental model:

```text
Your Command
     ↓
    UFW
     ↓
Netfilter Firewall Configuration
```

It is beginner-friendly compared with directly managing complex firewall syntax.

---

## 13. Check UFW Status

```bash
sudo ufw status
```

Example:

```text
Status: inactive
```

This tells you whether UFW is currently active.

---

## 14. Enable UFW

```bash
sudo ufw enable
```

UFW can then remain enabled across system startup.

### ⚠️ Important

Before enabling a firewall on a remote system, make sure required management access is allowed so you do not lock yourself out.

---

## 15. Default Outgoing Policy

To allow outgoing traffic by default:

```bash
sudo ufw default allow outgoing
```

Conceptually:

```text
Outgoing Traffic
       ↓
Default Policy
       ↓
     ALLOW
```

---

## 16. Deny Incoming SSH

SSH commonly uses TCP port 22.

```bash
sudo ufw deny 22/tcp
```

Conceptually:

```text
Incoming TCP/22
       ↓
      UFW
       ↓
     DENY
```

### ⚠️ Remote-access warning

If you are connected through SSH, blocking TCP/22 can disconnect you. Practice this in a VM or ensure you have another access method.

---

## 17. List Numbered UFW Rules

```bash
sudo ufw status numbered
```

Example:

```text
To                         Action      From
--                         ------      ----
[ 1] 22/tcp                DENY IN     Anywhere
[ 2] 22/tcp (v6)           DENY IN     Anywhere (v6)
```

Numbered rules make individual rule management easier.

---

## 18. Delete a Rule

Delete a rule using its number:

```bash
sudo ufw delete 2
```

UFW asks for confirmation.

Workflow:

```text
List rules
    ↓
Find rule number
    ↓
Delete rule
    ↓
Confirm
```

---

## 19. Firewall Rule Mental Model

Whenever you create a rule, ask:

```text
WHO?
 ↓
Source

WHERE?
 ↓
Destination

WHAT?
 ↓
Port + Protocol

DIRECTION?
 ↓
Inbound / Outbound / Forward

WHAT SHOULD HAPPEN?
 ↓
Allow / Deny / Forward
```

Example:

```text
Source:      192.168.1.0/24
Destination: Any
Protocol:    TCP
Port:        80
Direction:   Outbound
Action:      Allow
```

Read it as:

> Allow TCP port 80 traffic going outbound from the 192.168.1.0/24 network.

---

## 20. Firewall Troubleshooting Mindset

When a connection fails, do not immediately assume the application is broken.

Think through the entire path:

```text
Application
    ↓
Host
    ↓
Local Firewall
    ↓
Network Firewall
    ↓
Router
    ↓
Destination Firewall
    ↓
Destination
```

Ask:

1. Is the service running?
2. Is the correct port being used?
3. Is the protocol TCP or UDP?
4. Is traffic inbound or outbound?
5. Is a firewall blocking it?
6. Is there another firewall in the path?
7. Is the destination filtering traffic?

---

## 21. Firewall vs IDS vs IPS

| Technology | Main Purpose |
|---|---|
| Firewall | Control network traffic |
| IDS | Detect suspicious activity |
| IPS | Detect and actively block suspicious activity |
| NGFW | Firewall plus advanced inspection/security capabilities |

A simplified architecture:

```text
Internet
   ↓
Firewall
   ↓
Security Controls
   ↓
Internal Network
```

---

## 22. Common Mistakes

### Mistake 1 — Thinking a firewall is only port blocking

Depending on the firewall type, decisions may involve:

- Source
- Destination
- Protocol
- Connection state
- Application content
- Threat patterns
- Security policies

### Mistake 2 — Forgetting direction

Inbound and outbound rules are different.

### Mistake 3 — Blocking SSH without a recovery plan

```bash
sudo ufw deny 22/tcp
```

can remove remote SSH access.

### Mistake 4 — Ignoring existing rules

Inspect the current configuration first:

```bash
sudo ufw status numbered
```

### Mistake 5 — Allowing more traffic than necessary

Prefer rules that allow only the traffic actually required.

---

## 23. Safe Practice Lab

Use two VMs that you control:

```text
┌─────────────────┐
│ VM 1            │
│ Client          │
└────────┬────────┘
         │
      Network
         │
         ▼
┌─────────────────┐
│ VM 2            │
│ Linux Server    │
│ UFW             │
└─────────────────┘
```

Practice:

```text
1. Check UFW status
2. Identify a test service
3. Test connectivity
4. Create a firewall rule
5. Test again
6. Inspect the rule
7. Remove the rule
8. Test again
```

Use only systems and services you control.

---

## 24. Quick Revision

```text
FIREWALL
│
├── Types
│   ├── Stateless
│   ├── Stateful
│   ├── Proxy
│   └── NGFW
│
├── Rule Components
│   ├── Source
│   ├── Destination
│   ├── Port
│   ├── Protocol
│   ├── Action
│   └── Direction
│
├── Actions
│   ├── Allow
│   ├── Deny
│   └── Forward
│
├── Direction
│   ├── Inbound
│   ├── Outbound
│   └── Forward
│
└── Linux
    ├── Netfilter
    ├── iptables
    ├── nftables
    ├── firewalld
    └── UFW
```

---

## 25. UFW Cheat Sheet

```bash
# Check status
sudo ufw status

# Enable
sudo ufw enable

# Allow outgoing traffic by default
sudo ufw default allow outgoing

# Deny incoming SSH
sudo ufw deny 22/tcp

# Show numbered rules
sudo ufw status numbered

# Delete a numbered rule
sudo ufw delete <rule-number>
```

---

## 26. Learning Checklist

### Firewall Fundamentals

- [ ] Understand what a firewall does
- [ ] Understand OSI layers
- [ ] Understand stateless firewalls
- [ ] Understand stateful firewalls
- [ ] Understand proxy firewalls
- [ ] Understand NGFWs

### Firewall Rules

- [ ] Source
- [ ] Destination
- [ ] Port
- [ ] Protocol
- [ ] Action
- [ ] Direction

### Traffic Direction

- [ ] Inbound
- [ ] Outbound
- [ ] Forward

### Linux

- [ ] Netfilter
- [ ] iptables
- [ ] nftables
- [ ] firewalld
- [ ] UFW
- [ ] Create a test rule
- [ ] Inspect numbered rules
- [ ] Delete a test rule safely

---

## 27. Personal Notes Template

### Firewall Concept

```text
Concept:

OSI Layer:

What it does:

Mental model:

Example:

Security benefit:
```

### Firewall Rule

```text
Source:

Destination:

Protocol:

Port:

Direction:

Action:

Reason:

Expected behavior:

Observed behavior:
```

### Troubleshooting

```text
Source:

Destination:

Port:

Protocol:

Expected connection:

Actual result:

Firewall involved:

Rule responsible:

Fix:
```

---

## 28. Future Topics

- [ ] Stateful inspection in depth
- [ ] ACLs
- [ ] Default-deny vs default-allow
- [ ] Firewall rule ordering
- [ ] NAT and firewalls
- [ ] Port forwarding
- [ ] DMZ architecture
- [ ] Network segmentation
- [ ] Host-based vs network-based firewalls
- [ ] Windows Firewall
- [ ] nftables in depth
- [ ] Firewall logging
- [ ] Firewall monitoring with SIEM
- [ ] IDS/IPS integration
- [ ] NGFW architecture
- [ ] TLS inspection
- [ ] Zero Trust and firewall policy

---

## 29. Final Mental Model

```text
Traffic
   ↓
Firewall
   ↓
Who is sending?
   ↓
Who is receiving?
   ↓
Which protocol?
   ↓
Which port?
   ↓
Which direction?
   ↓
What does the rule say?
   ↓
ALLOW / DENY / FORWARD
```

Linux model:

```text
Linux
  ↓
Netfilter
  ↓
iptables / nftables / firewalld / UFW
  ↓
Firewall Rules
  ↓
Network Traffic
```

## One-Line Takeaway

> **A firewall is a traffic-control system: understand the traffic, understand the rule, understand the direction, and then understand why the firewall allowed, denied, or forwarded it.**
