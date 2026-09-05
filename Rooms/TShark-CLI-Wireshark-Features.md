# Command-Line Wireshark Features I | Statistics

TShark is the command-line version of Wireshark. It supports many Wireshark features, including statistics and traffic analysis.

Think of TShark as a **security guard checking CCTV recordings**:

- Packets are like vehicles passing through a gate.
- A capture file is like a recorded CCTV video.
- Filters are like searching for a specific vehicle.
- Statistics are like a report showing how many vehicles passed, their sizes, and where they went.

## Important Notes

When using Wireshark-like features in TShark:

- The selected option is applied to all packets being analyzed unless a display filter is provided.
- Most commands are command-line versions of features available in Wireshark.
- TShark usually explains the selected parameter at the beginning of the output.

For example:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z io,phs -q
```

The output begins with:

```text
Protocol Hierarchy Statistics
```

The `phs` option means **Packet Hierarchy Statistics**.

## Common Statistics Parameters

| Parameter | Purpose |
|---|---|
| `--color` | Displays packet information using colours |
| `-z` | Displays different types of statistics |

To see the available statistics options:

```shell-session
user@ubuntu$ tshark -z help
```

A statistics command may display packets first and statistics afterward. Use `-q` when you want to hide the packet details and show only the statistics.

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z io,phs -q
```

Think of `-q` as saying:

> “Do not show me every vehicle. Just give me the traffic report.”

---

## Colourised Output

TShark can display packet information using colours. This makes it easier to identify different types of traffic and quickly notice unusual activity.

It works similarly to Wireshark's packet highlighting.

### Example

```shell-session
user@ubuntu$ tshark -r colour.pcap --color
```

### Analogy

Without colours, a security guard sees every vehicle in black and white.

With `--color`, different vehicles are highlighted so the guard can identify them more quickly.

---

# Statistics | Protocol Hierarchy

The protocol hierarchy shows the protocols used in a capture file.

It presents the information in a tree structure and displays:

- Protocol names
- Number of packets
- Number of bytes
- Relationships between protocols

This helps analysts understand the overall structure of the traffic.

### Example

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z io,phs -q
```

Example output:

```text
Protocol Hierarchy Statistics
Filter:

  eth                                    frames:43 bytes:25091
    ip                                   frames:43 bytes:25091
      tcp                                frames:41 bytes:24814
        http                             frames:4 bytes:2000
          data-text-lines                frames:1 bytes:214
          xml                            frames:1 bytes:478
      udp                                frames:2 bytes:277
        dns                              frames:2 bytes:277
```

### How to Understand the Tree

```text
Ethernet
└── IP
    ├── TCP
    │   └── HTTP
    └── UDP
        └── DNS
```

This means:

- 43 packets used Ethernet.
- 43 packets used IP.
- 41 packets used TCP.
- 2 packets used UDP.
- HTTP traffic was carried inside TCP.
- DNS traffic was carried inside UDP.

### Analogy

Imagine checking a delivery report:

```text
All vehicles
├── Cars
│   └── Delivery cars
└── Trucks
    └── DNS delivery trucks
```

The protocol hierarchy tells you what types of traffic were present and how much traffic belonged to each type.

## Filtering the Protocol Hierarchy

You can focus on one protocol by adding its name to the statistics filter.

### View only UDP traffic

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z io,phs,udp -q
```

Example output:

```text
Protocol Hierarchy Statistics
Filter: udp

  eth                                    frames:2 bytes:277
    ip                                   frames:2 bytes:277
      udp                                frames:2 bytes:277
        dns                              frames:2 bytes:277
```

### Side-by-Side Comparison

| All protocols | Only UDP |
|---|---|
| `tshark -r demo.pcapng -z io,phs -q` | `tshark -r demo.pcapng -z io,phs,udp -q` |
| Shows the complete protocol tree | Shows only the UDP-related tree |

### Analogy

The complete report is:

> “Show me every type of vehicle.”

The filtered report is:

> “Show me only delivery trucks.”

---

# Statistics | Packet Lengths Tree

The packet lengths tree shows how packets are distributed by size.

It helps analysts identify:

- Small packets
- Large packets
- The most common packet sizes
- Unusually large or small packets

Use the following command:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z plen,tree -q
```

Example output:

```text
Packet Lengths:
Topic / Item       Count     Average       Min val       Max val       Percent

Packet Lengths     43        583.51        54            1484          100
40-79              22        54.73         54            62            51.16
80-159             1         89            89            89            2.33
160-319            2         201           188           214           4.65
320-639            2         505.50        478           533           4.65
640-1279           1         775           775           775           2.33
1280-2559          15        1440.67       1434          1484          34.88
```

## Important Columns

| Column | Meaning |
|---|---|
| `Count` | Number of packets in that size range |
| `Average` | Average packet size |
| `Min val` | Smallest packet in that range |
| `Max val` | Largest packet in that range |
| `Percent` | Percentage of all packets in that range |

### Analogy

Imagine a warehouse checking package sizes:

- 22 packages are small.
- 15 packages are large.
- Only 1 package is medium-sized.

This can help identify unusual traffic. For example, a capture containing many unusually large packets may deserve further investigation.

---

# Statistics | Endpoints

An endpoint is a communication address involved in network traffic.

For example:

- An IPv4 address
- An IPv6 address
- A MAC address
- A TCP address
- A UDP address

Endpoint statistics show:

- Which addresses communicated
- How many packets they sent or received
- How many bytes were transferred

Use the following command to view IPv4 endpoints:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z endpoints,ip -q
```

Example output:

```text
IPv4 Endpoints

Address             Packets   Bytes    Tx Packets   Rx Packets

145.254.160.237     43        25091    20           23
65.208.228.223      34        20695    18           16
216.239.59.99       7         4119     4            3
145.253.2.203       2         277      1            1
```

## Common Endpoint Filters

| Filter | Purpose |
|---|---|
| `eth` | Ethernet addresses |
| `ip` | IPv4 addresses |
| `ipv6` | IPv6 addresses |
| `tcp` | TCP addresses |
| `udp` | UDP addresses |
| `wlan` | Wireless network addresses |

### Analogy

Think of endpoints as houses in a neighbourhood.

The endpoint report tells you:

- Which houses communicated
- How many messages were sent
- How much data was transferred
- Which house sent or received more traffic

This can help identify the busiest or most important systems in a capture.

---

# Statistics | Conversations

A conversation shows traffic exchanged between two endpoints.

Unlike endpoint statistics, which list individual addresses, conversation statistics show the communication between two addresses.

Use the following command:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z conv,ip -q
```

Example output:

```text
IPv4 Conversations

Address A              Address B              Total Frames   Total Bytes

65.208.228.223          145.254.160.237        34             20695
145.254.160.237         216.239.59.99         7              4119
145.253.2.203           145.254.160.237       2              277
```

The report can also show:

- Frames sent in each direction
- Bytes sent in each direction
- Total frames
- Total bytes
- Conversation start time
- Conversation duration

### Analogy

An endpoint report tells you:

> “House A sent 20 messages.”

A conversation report tells you:

> “House A exchanged 20 messages with House B.”

This makes conversation statistics useful for finding:

- The busiest connections
- Long-running connections
- Large data transfers
- Communication between suspicious systems

---

# Statistics | Expert Info

Expert Info displays automatic observations generated by Wireshark.

It can help identify possible network problems, such as:

- Retransmissions
- Duplicate acknowledgements
- Connection issues
- Suspicious packet behaviour
- Protocol warnings

Use the following command:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -z expert -q
```

Example output:

```text
Notes (3)

Frequency   Group       Protocol   Summary

1           Sequence    TCP        Suspected spurious retransmission
1           Sequence    TCP        Suspected retransmission
1           Sequence    TCP        Duplicate ACK
```

Other messages may include:

```text
Connection establish request (SYN)
Connection establish acknowledge (SYN+ACK)
HTTP GET request
HTTP 200 OK response
Connection finish (FIN)
```

## Understanding Expert Info

| Message | Meaning |
|---|---|
| Retransmission | A packet may have been sent again because it was not acknowledged |
| Duplicate ACK | An acknowledgement was repeated |
| SYN | A connection request |
| SYN+ACK | The connection request was accepted |
| FIN | A connection is being closed |
| HTTP 200 OK | The HTTP request was successful |

### Analogy

Expert Info is like an automatic security system that reports:

- “A vehicle entered twice.”
- “A delivery was repeated.”
- “A connection was successfully established.”
- “A connection was closed.”

It does not replace manual analysis, but it helps you quickly find packets that may need attention.

---

# Quick Reference

| Feature | Command |
|---|---|
| Show colourised output | `tshark -r colour.pcap --color` |
| Show all protocol hierarchy | `tshark -r demo.pcapng -z io,phs -q` |
| Show UDP protocol hierarchy | `tshark -r demo.pcapng -z io,phs,udp -q` |
| Show packet length statistics | `tshark -r demo.pcapng -z plen,tree -q` |
| Show IPv4 endpoints | `tshark -r demo.pcapng -z endpoints,ip -q` |
| Show IPv4 conversations | `tshark -r demo.pcapng -z conv,ip -q` |
| Show expert information | `tshark -r demo.pcapng -z expert -q` |
| Show available statistics options | `tshark -z help` |

## Memory Trick

- `--color` → Add colours to the output.
- `-z io,phs` → Show the protocol hierarchy.
- `-z plen,tree` → Show packet sizes.
- `-z endpoints,ip` → Show communicating IP addresses.
- `-z conv,ip` → Show conversations between IP addresses.
- `-z expert` → Show Wireshark's automatic analysis.
- `-q` → Show the report without displaying every packet.
