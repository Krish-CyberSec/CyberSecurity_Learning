# TShark

## Command-Line Packet Analysis

TShark is a text-based tool suitable for packet analysis, data carving, and automation with scripts. Its strength comes from the ability to pipe its output into other command-line tools.

### Common Tools and Utilities

| Tool/Utility | Purpose |
|---|---|
| `capinfos` | Provides details and statistics about a capture file. |
| `grep` | Searches plain-text data. |
| `cut` | Extracts parts of lines or fields. |
| `uniq` | Filters repeated lines or values. |
| `nl` | Displays line numbers. |
| `sed` | Filters and transforms text. |
| `awk` | Performs pattern searching and data processing. |

### Basic Workflow

1. Use `capinfos` to inspect the capture file.
2. Use `tshark` to extract and analyze packet data.
3. Use `grep` to search for specific patterns.
4. Use `cut` to extract specific fields.
5. Use `uniq` to remove duplicate values.
6. Use `nl` to display line numbers.
7. Use `sed` to manipulate text.
8. Use `awk` for advanced pattern matching.

### Example

```bash
tshark -r capture.pcap -T fields -e ip.src | sort | uniq
```

## Command-Line Interface and Parameters

TShark provides several options to control packet capture, reading, writing, filtering, and output. Learning these parameters helps analysts avoid unnecessary output and focus on relevant packets.

> **Note:** TShark may require superuser privileges to sniff live traffic and list available interfaces.

| Parameter | Purpose | Example |
|---|---|---|
| `-h` | Display the help page. | `tshark -h` |
| `-v` | Show version information. | `tshark -v` |
| `-D` | List available sniffing interfaces. | `tshark -D` |
| `-i` | Choose an interface for live capture. | `tshark -i 1` |
| `-i` | Choose an interface by name. | `tshark -i ens55` |
| No parameter | Sniff traffic similar to `tcpdump`. | `tshark` |
| `-r` | Read a capture file. | `tshark -r demo.pcapng` |
| `-c` | Stop after processing a specified number of packets. | `tshark -c 10` |
| `-w` | Write captured or filtered packets to a file. | `tshark -w sample-capture.pcap` |
| `-V` | Display detailed information for each packet. | `tshark -V` |
| `-q` | Suppress packet output on the terminal. | `tshark -q` |
| `-x` | Display packet bytes in hexadecimal and ASCII format. | `tshark -x` |

### Display Help

```bash
tshark -h
```

## Command-Line Interface and Parameters II

Let's continue discovering the main parameters of TShark.

### Read Capture Files

TShark can process PCAP and PCAPNG files using the `-r` parameter. You can limit the number of shown packets using the `-c` parameter.

#### Read Data

```shell-session
user@ubuntu$ tshark -r demo.pcapng
    1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
    2   0.911310 65.208.228.223 ? 145.254.160.237 TCP 80 ? 3372 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1380 SACK_PERM=1
    3   0.911310 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [ACK] Seq=1 Ack=1 Win=9660 Len=0

..
```

#### Read by Count

Show only the first two packets:

```shell-session
user@ubuntu$ tshark -r demo.pcapng -c 2
    1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
    2   0.911310 65.208.228.223 ? 145.254.160.237 TCP 80 ? 3372 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1380 SACK_PERM=1
```

### Write Data

TShark can write sniffed or filtered packets to a file using the `-w` parameter. This allows analysts to save specific packets for further analysis or share only suspicious traffic with other investigators.

```shell-session
# Read the first packet of demo.pcapng and save it to write-demo.pcap.
user@ubuntu$ tshark -r demo.pcapng -c 1 -w write-demo.pcap

# List the contents of the current folder.
user@ubuntu$ ls
demo.pcapng  write-demo.pcap

# Read the saved capture file.
user@ubuntu$ tshark -r write-demo.pcap
    1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
```

### Show Packet Bytes

TShark can display packet bytes in hexadecimal and ASCII format using the `-x` parameter. Because this output can be difficult to inspect, it is more efficient to use it after reducing the number of packets.

```shell-session
# Read the packets from write-demo.pcap.
user@ubuntu$ tshark -r write-demo.pcap
    1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1

# Read the packets and display their bytes.
user@ubuntu$ tshark -r write-demo.pcap -x
0000  fe ff 20 00 01 00 00 00 01 00 00 00 08 00 45 00   .. ...........E.
0010  00 30 0f 41 40 00 80 06 91 eb 91 fe a0 ed 41 d0   .0.A@.........A.
0020  e4 df 0d 2c 00 50 38 af fe 13 00 00 00 00 70 02   ...,.P8.......p.
0030  22 38 c3 0c 00 00 02 04 05 b4 01 01 04 02         "8............
```

### Verbosity

By default, TShark displays a single line of information for each packet. The `-V` parameter provides detailed information similar to Wireshark's **Packet Details Pane**.

Verbose output is useful for in-depth packet analysis, but it can be long and complex. It is best used after filtering or limiting the number of packets.

```shell-session
# Default view.
user@ubuntu$ tshark -r demo.pcapng -c 1
    1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1

# Verbose output.
user@ubuntu$ tshark -r demo.pcapng -c 1 -V
Frame 1: 62 bytes on wire (496 bits), 62 bytes captured (496 bits)
...
Ethernet II, Src: 00:00:01:00:00:00, Dst: fe:ff:20:00:01:00
...
Internet Protocol Version 4, Src: 145.254.160.237, Dst: 65.208.228.223
    0100 .... = Version: 4
    .... 0101 = Header Length: 20 bytes (5)
    Total Length: 48
    Identification: 0x0f41 (3905)
    Flags: 0x4000, Don't fragment
    Fragment offset: 0
    Time to live: 128
    Protocol: TCP (6)
    Source: 145.254.160.237
    Destination: 65.208.228.223
Transmission Control Protocol, Src Port: 3372, Dst Port: 80, Seq: 0, Len: 0
...
```

Verbosity provides full packet details and can make investigation difficult when used on many packets. However, it is valuable for in-depth analysis, scripting, carving, and correlation. The most effective approach is to filter the packets first and then use `-V` on the relevant results.


## Capture Condition Parameters

Imagine you are using a **security camera** to watch a busy road.

- **TShark** is the camera.
- **Packets** are the vehicles passing by.
- **Capture files** are the video recordings.
- **Autostop (`-a`)** tells the camera when to stop recording.
- **Ring buffer (`-b`)** tells the camera how to manage multiple recording files.

These options help you control **when TShark stops capturing** and **how it saves the captured packets**.

### 1. Autostop Parameters (`-a`)

Think of autostop as setting a **timer on your camera**. Once the condition is met, the camera stops recording.

| Parameter | Easy Explanation | Example |
|---|---|---|
| `-a duration:X` | Record for **X seconds**, then stop. | `tshark -w test.pcap -a duration:1` |
| `-a filesize:X` | Stop when the capture file reaches **X KB**. | `tshark -w test.pcap -a filesize:10` |
| `-a files:X` | Stop after creating **X capture files**. | `tshark -w test.pcap -a filesize:10 -a files:3` |

#### Example: Stop After 1 Second

```bash
tshark -w test.pcap -a duration:1
```

**Analogy:** Start your camera, record for 1 second, and then turn it off.

**Result:** TShark captures packets for 1 second and saves them to `test.pcap`.

#### Example: Stop When the File Reaches 10 KB

```bash
tshark -w test.pcap -a filesize:10
```

**Analogy:** Your camera has a memory card that can hold only 10 KB of video. Once it reaches that limit, recording stops.

**Result:** TShark stops when the capture file reaches approximately 10 KB.

#### Example: Stop After 3 Files

```bash
tshark -w test.pcap -a filesize:10 -a files:3
```

**Analogy:** You tell your camera:

> "Create files of 10 KB each, and stop after making 3 files."

**Result:** TShark stops after creating the specified number of files.

### 2. Ring Buffer Parameters (`-b`)

Now imagine a **security camera with a storage system that keeps only the latest recordings**.

When the storage is full, the camera creates a new file and eventually overwrites the oldest one.

This is called a **ring buffer**.

| Parameter | Easy Explanation | Example |
|---|---|---|
| `-b duration:X` | Create a new file after **X seconds**. | `tshark -w test.pcap -b duration:1` |
| `-b filesize:X` | Create a new file after reaching **X KB**. | `tshark -w test.pcap -b filesize:10` |
| `-b files:X` | Keep **X files** and overwrite the oldest when necessary. | `tshark -w test.pcap -b filesize:10 -b files:3` |

#### Example: Create a New File Every Second

```bash
tshark -w test.pcap -b duration:1
```

**Analogy:** Your camera creates a new video file every second.

```text
File 1 → File 2 → File 3 → File 4 → ...
```

**Result:** TShark keeps creating new capture files.

#### Example: Create a New File Every 10 KB

```bash
tshark -w test.pcap -b filesize:10
```

**Analogy:** Every time a recording reaches 10 KB, the camera starts a new file.

```text
File 1 (10 KB) → File 2 (10 KB) → File 3 (10 KB) → ...
```

**Result:** TShark creates a new file whenever the previous file reaches the specified size.

#### Example: Keep Only 3 Files

```bash
tshark -w test.pcap -b filesize:10 -b files:3
```

**Analogy:** Your camera has room for only 3 video files.

```text
File 1 → File 2 → File 3
```

When a new file is created:

```text
File 2 → File 3 → File 4
```

The oldest file is overwritten.

**Result:** TShark keeps a maximum of 3 files and continuously replaces the oldest file.

### 3. Autostop vs Ring Buffer

The easiest way to remember the difference is:

| Option | Analogy | What It Does |
|---|---|---|
| `-a` | **Stopwatch** | Stops the capture when a condition is met. |
| `-b` | **Circular storage** | Creates new files and can overwrite the oldest file. |

### 4. Combining `-a` and `-b`

You can combine both options.

Think of it like telling your camera:

> "Keep recording in separate files, but stop the entire recording after a certain time."

#### Example

```bash
tshark -w test.pcap -a duration:10 -b filesize:5
```

**Meaning:**

- Create a new file whenever the current file reaches **5 KB**.
- Stop the entire capture after **10 seconds**.

**Analogy:** Record continuously, split the recording into 5 KB files, and turn the camera off after 10 seconds.

### 5. Important Note

Capture condition parameters work only in **live capturing/sniffing mode**.

They do **not** work when reading an existing capture file with `-r`.

#### Incorrect Example

```bash
tshark -r demo.pcapng -a duration:10
```

**Why?**

You are reading an existing recording, not creating a new one.

**Analogy:** You cannot tell a camera to "stop recording" when you are only watching an old video.

If you want to extract specific packets from an existing capture file, use the **read (`-r`) and write (`-w`)** options.

### 6. Sample Autostop Query

Start sniffing traffic, stop after **2 seconds**, and save the capture into **5 files**, each with a maximum size of **5 KB**.

```shell-session
user@ubuntu$ tshark -w autostop-demo.pcap -a duration:2 -a filesize:5 -a files:5
Capturing on 'ens5'
13
```

**Analogy:** Tell your camera:

> "Record for 2 seconds. Split the recording into 5 KB files. Stop after creating 5 files."

### 7. List the Capture Files

```shell-session
# List the contents of the current folder.
user@ubuntu$ ls
autostop-demo_..1_2022.pcap
autostop-demo_..2_2022.pcap
autostop-demo_..3_2022.pcap
autostop-demo_..4_2022.pcap
autostop-demo_..5_2022.pcap
```

### Quick Memory Trick

> **`-a` = Stop**
>
> **`-b` = Keep creating files**
>
> **`-a duration:10` = Stop after 10 seconds**
>
> **`-a filesize:10` = Stop after 10 KB**
>
> **`-b filesize:10` = Create a new file after 10 KB**
>
> **`-b files:3` = Keep 3 files and overwrite the oldest**

### Summary

| Option | Simple Meaning |
|---|---|
| `-a` | Stop the capture when a condition is met. |
| `-b` | Create multiple files and manage them like a circular storage system. |
| `-a duration:X` | Stop after X seconds. |
| `-a filesize:X` | Stop after reaching X KB. |
| `-a files:X` | Stop after creating X files. |
| `-b duration:X` | Create a new file after X seconds. |
| `-b filesize:X` | Create a new file after reaching X KB. |
| `-b files:X` | Overwrite the oldest file after X files. |

# Packet Filtering Parameters

## Capture Filters vs Display Filters

TShark provides two different ways to filter packets:

1. **Capture filters** — decide which packets are captured and saved.
2. **Display filters** — decide which captured packets are shown for analysis.

### Simple Analogy

Imagine a security camera recording vehicles:

- A **capture filter** tells the camera which vehicles to record.
- A **display filter** records everything but shows only selected vehicles when you review the footage.

---

## Filter Timing

| Filter Type | When It Is Applied | What It Does |
|-------------|--------------------|--------------|
| **Capture Filter** | Before a packet is saved | Prevents unwanted packets from being captured |
| **Display Filter** | After a packet has been captured | Hides packets that do not match the filter |

Capture filters reduce the amount of data written to the capture file.

Display filters do not remove packets from the capture file. They only control which packets are displayed.

> **Important:** A display filter can also be used while TShark is processing a live capture, but it is applied after packets have been captured.

---

## Capture Filters

Capture filters are applied during live packet capture.

They use **Berkeley Packet Filter (BPF)** syntax, which is also used by Wireshark capture filters.

The capture filter parameter is:

```bash
-f
```

### Example

```bash
tshark -i 1 -f "port 80"
```

This captures only traffic using port `80`.

Packets that do not match the filter are not saved.

### Analogy

This is like telling a security camera:

> “Record only vehicles entering through gate 80.”

---

## Display Filters

Display filters use Wireshark display-filter syntax.

The display filter parameter is:

```bash
-Y
```

Display filters are useful when investigating a capture file because they allow you to focus on specific packets without modifying the original capture.

### Example

```bash
tshark -r capture.pcap -Y "http"
```

This reads `capture.pcap` and displays only HTTP packets.

### Analogy

This is like saying:

> “Show me only the HTTP-related vehicles from the recording.”

---

## Side-by-Side Examples

### Filter Traffic by Port

| Capture Filter | Display Filter |
|----------------|----------------|
| ```bash<br>tshark -i 1 -f "port 80"<br>``` | ```bash<br>tshark -r capture.pcap -Y "tcp.port == 80"<br>``` |
| Captures only traffic using port `80`. | Displays packets using port `80` from an existing capture. |
| Unmatched packets are not saved. | Unmatched packets remain in the capture file but are hidden. |

### Filter Traffic by IP Address

| Capture Filter | Display Filter |
|----------------|----------------|
| ```bash<br>tshark -i 1 -f "host 192.168.1.10"<br>``` | ```bash<br>tshark -r capture.pcap -Y "ip.addr == 192.168.1.10"<br>``` |
| Captures traffic involving `192.168.1.10`. | Displays packets involving `192.168.1.10`. |
| Uses BPF syntax. | Uses Wireshark display-filter syntax. |

### Filter HTTP Traffic

| Capture Filter | Display Filter |
|----------------|----------------|
| ```bash<br>tshark -i 1 -f "tcp port 80"<br>``` | ```bash<br>tshark -r capture.pcap -Y "http"<br>``` |
| Captures TCP traffic on port `80`. | Displays packets identified as HTTP. |
| The filter is applied while capturing. | The filter is applied while reading or displaying packets. |

### Filter DNS Traffic

| Capture Filter | Display Filter |
|----------------|----------------|
| ```bash<br>tshark -i 1 -f "port 53"<br>``` | ```bash<br>tshark -r capture.pcap -Y "dns"<br>``` |
| Captures traffic using port `53`. | Displays packets recognized as DNS traffic. |

---

## Main Differences

| Feature | Capture Filter (`-f`) | Display Filter (`-Y`) |
|---------|------------------------|------------------------|
| Syntax | BPF syntax | Wireshark display-filter syntax |
| Applied before saving | Yes | No |
| Applied after capture | No | Yes |
| Reduces capture file size | Yes | No |
| Hides packets from output | No | Yes |
| Changes the original capture | The original traffic is never saved | No |
| Best use | Limiting live traffic | Detailed packet investigation |

---

## Quick Memory Trick

- `-f` means **filter before saving**.
- `-Y` means **filter what you display**.

Think of it this way:

> **Capture filter = security guard**  
> **Display filter = video search tool**

Both help you find useful traffic, but they work at different stages.


# Capture Filters

Capture filters are used to select packets **before they are saved**.

TShark uses the same capture-filter syntax as Wireshark. This syntax is based on **Berkeley Packet Filters (BPF)**.

Capture filters help reduce:

- The amount of captured traffic
- The capture file size
- The time needed to investigate packets

## Simple Analogy

Imagine a security camera recording vehicles on a road.

A capture filter is like telling the camera:

> “Record only vehicles coming from this address or using this port.”

Unwanted vehicles are ignored and are not saved in the recording.

---

## Capture Filter Syntax

The basic capture-filter structure is:

```text
[protocol] [direction] [type] [value]
```

For example:

```bash
tshark -f "tcp dst port 80"
```

This means:

- `tcp` — use TCP traffic
- `dst` — match the destination
- `port` — filter by port
- `80` — destination port 80

Capture filters can also use Boolean operators such as:

- `and`
- `or`
- `not`

Example:

```bash
tshark -f "tcp port 80 or tcp port 443"
```

This captures TCP traffic using either port `80` or port `443`.

---

## Capture Filter Qualifiers

Capture filters are commonly built using three parts:

| Qualifier | Purpose | Common Options |
|-----------|---------|----------------|
| **Type** | Defines what should be matched | `host`, `net`, `port`, `portrange` |
| **Direction** | Defines the traffic direction | `src`, `dst` |
| **Protocol** | Defines the network protocol | `tcp`, `udp`, `icmp`, `ip`, `ip6`, `arp`, `ether` |

If no direction is specified, the filter normally matches traffic in **either direction**.

---

## 1. Type Qualifier

The type qualifier defines what you want to filter.

### Available Types

| Type | Purpose |
|------|---------|
| `host` | Match an IP address or hostname |
| `net` | Match a network range |
| `port` | Match a single port |
| `portrange` | Match a range of ports |

### Filtering a Host

```bash
tshark -f "host 10.10.10.10"
```

This captures traffic to or from `10.10.10.10`.

### Filtering a Network

```bash
tshark -f "net 10.10.10.0/24"
```

This captures traffic involving the network `10.10.10.0/24`.

### Filtering a Port

```bash
tshark -f "port 80"
```

This captures traffic using port `80`.

### Filtering a Port Range

```bash
tshark -f "portrange 80-100"
```

This captures traffic using ports from `80` through `100`.

### Analogy

The type qualifier is like choosing what the security camera should look for:

- `host` — a specific vehicle
- `net` — vehicles from a particular area
- `port` — a specific entrance
- `portrange` — several entrances

---

## 2. Direction Qualifier

The direction qualifier defines whether the traffic is coming from or going to a target.

### Available Directions

| Direction | Meaning |
|-----------|---------|
| `src` | Source of the traffic |
| `dst` | Destination of the traffic |

### Filtering a Source Host

```bash
tshark -f "src host 10.10.10.10"
```

This captures packets sent **from** `10.10.10.10`.

### Filtering a Destination Host

```bash
tshark -f "dst host 10.10.10.10"
```

This captures packets sent **to** `10.10.10.10`.

### Filtering a Source Port

```bash
tshark -f "src port 4444"
```

This captures packets sent from source port `4444`.

### Filtering a Destination Port

```bash
tshark -f "dst port 80"
```

This captures packets sent to destination port `80`.

### Analogy

The direction qualifier is like checking traffic flow:

- `src` — where the vehicle came from
- `dst` — where the vehicle is going

If no direction is specified, TShark checks both directions.

---

## 3. Protocol Qualifier

The protocol qualifier defines the type of network traffic to capture.

### Common Protocols

| Protocol | Purpose |
|----------|---------|
| `tcp` | TCP traffic |
| `udp` | UDP traffic |
| `icmp` | ICMP traffic, such as ping |
| `ip` | IPv4 traffic |
| `ip6` | IPv6 traffic |
| `arp` | ARP traffic |
| `ether` | Ethernet traffic |

### Filtering TCP Traffic

```bash
tshark -f "tcp"
```

### Filtering UDP Traffic

```bash
tshark -f "udp"
```

### Filtering ICMP Traffic

```bash
tshark -f "icmp"
```

### Filtering IPv6 Traffic

```bash
tshark -f "ip6"
```

### Filtering a MAC Address

```bash
tshark -f "ether host F8:DB:C5:A2:5D:81"
```

This captures Ethernet traffic to or from the specified MAC address.

### Filtering by IP Protocol Number

You can also filter protocols using their assigned IP protocol numbers.

For example, ICMP uses protocol number `1`:

```bash
tshark -f "ip proto 1"
```

### Analogy

The protocol qualifier is like telling the camera what kind of vehicle to record:

- `tcp` — trucks
- `udp` — motorcycles
- `icmp` — emergency vehicles
- `ip6` — vehicles using a different road system

---

## Combining Qualifiers

Qualifiers can be combined to create more specific filters.

### TCP Traffic to Port 80

```bash
tshark -f "tcp dst port 80"
```

### UDP Traffic from Port 53

```bash
tshark -f "udp src port 53"
```

### Traffic from a Specific Host to Port 443

```bash
tshark -f "host 10.10.10.10 and port 443"
```

### Traffic from a Specific Network

```bash
tshark -f "net 10.10.10.0/24 and tcp"
```

---

## Boolean Operators

Boolean operators allow you to combine multiple conditions.

| Operator | Meaning | Example |
|----------|---------|---------|
| `and` | Both conditions must match | `tcp and port 80` |
| `or` | Either condition can match | `port 80 or port 443` |
| `not` | Excludes matching traffic | `not tcp` |

### Using `and`

```bash
tshark -f "tcp and port 80"
```

Captures TCP traffic using port `80`.

### Using `or`

```bash
tshark -f "port 80 or port 443"
```

Captures traffic using port `80` or port `443`.

### Using `not`

```bash
tshark -f "not arp"
```

Captures all traffic except ARP packets.

### Using Parentheses

```bash
tshark -f "tcp and (port 80 or port 443)"
```

Captures TCP traffic using port `80` or `443`.

---

## Testing Capture Filters

To practice capture filters, you can use two terminal windows.

- **Terminal 1:** Run TShark to capture traffic.
- **Terminal 2:** Generate traffic using tools such as `curl` or `nc`.
- Return to **Terminal 1** to view the captured packets.

A terminal multiplexer such as `terminator` can be used to display both terminals in one window.

---

## Example: Filtering Traffic from a Host

### Terminal 1 — Start TShark

```bash
tshark -f "host 10.10.10.10"
```

Example output:

```text
Capturing on 'ens5'
1  0.000000000  YOUR-IP → 10.10.10.10  TCP 74 36150 → 80 [SYN]
2  0.003452830  10.10.10.10 → YOUR-IP  TCP 74 80 → 36150 [SYN, ACK]
3  0.003487830  YOUR-IP → 10.10.10.10  TCP 66 36150 → 80 [ACK]
4  0.003610800  YOUR-IP → 10.10.10.10  HTTP 141 GET / HTTP/1.1
```

### Terminal 2 — Generate Traffic

```bash
curl -v http://10.10.10.10
```

TShark displays only packets involving `10.10.10.10`.

---

## Practice Examples

### Host Filtering

Capture traffic to or from a specific host.

Generate traffic:

```bash
curl http://tryhackme.com
```

Capture traffic:

```bash
tshark -f "host tryhackme.com"
```

---

### IP Filtering

Capture traffic to or from a specific IP address.

Generate traffic:

```bash
nc 10.10.10.10 4444 -vw 5
```

Capture traffic:

```bash
tshark -f "host 10.10.10.10"
```

---

### Port Filtering

Capture traffic using a specific port.

Generate traffic:

```bash
nc 10.10.10.10 4444 -vw 5
```

Capture traffic:

```bash
tshark -f "port 4444"
```

---

### Protocol Filtering

Capture traffic using a specific protocol.

Generate UDP traffic:

```bash
nc -u 10.10.10.10 4444 -vw 5
```

Capture UDP traffic:

```bash
tshark -f "udp"
```

---

## Quick Reference

| Goal | Capture Filter |
|------|----------------|
| Capture traffic from or to a host | `tshark -f "host 10.10.10.10"` |
| Capture traffic from a source host | `tshark -f "src host 10.10.10.10"` |
| Capture traffic to a destination host | `tshark -f "dst host 10.10.10.10"` |
| Capture a network range | `tshark -f "net 10.10.10.0/24"` |
| Capture traffic on port 80 | `tshark -f "port 80"` |
| Capture traffic on ports 80–100 | `tshark -f "portrange 80-100"` |
| Capture TCP traffic | `tshark -f "tcp"` |
| Capture UDP traffic | `tshark -f "udp"` |
| Capture ICMP traffic | `tshark -f "icmp"` |
| Capture traffic except ARP | `tshark -f "not arp"` |

## Important Note

Capture filters use **BPF syntax** and are applied while capturing traffic.

Display filters use **Wireshark display-filter syntax** and are applied after packets have been captured.

```bash
# Capture filter
tshark -i 1 -f "tcp port 80"

# Display filter
tshark -r capture.pcap -Y "tcp.port == 80"
```

> **Capture filter:** Decide what gets recorded.  
> **Display filter:** Decide what gets shown.


# Display Filters

Display filters are used to **show only selected packets after they have been captured**.

TShark uses Wireshark's display-filter syntax with the `-Y` parameter.

```bash
tshark -r capture.pcap -Y 'filter'
```

## Simple Analogy

Imagine a security camera that records every vehicle on a road.

A display filter is like searching the recording and saying:

> “Show me only the red cars.”

The other vehicles are still in the recording. They are only hidden from the current view.

---

## Capture Filters vs Display Filters

| Feature | Capture Filter | Display Filter |
|---------|----------------|----------------|
| Parameter | `-f` | `-Y` |
| Syntax | BPF syntax | Wireshark display-filter syntax |
| Applied | During capture | After capture |
| Reduces saved file size | Yes | No |
| Deletes or removes packets | Packets are never saved | No |
| Can be changed during investigation | No | Yes |

### Side-by-Side Example

```bash
# Capture filter: only capture traffic on port 80
tshark -i 1 -f 'tcp port 80'

# Display filter: show port 80 traffic from an existing capture
tshark -r capture.pcap -Y 'tcp.port == 80'
```

---

## Display Filter Syntax

The basic display-filter structure is:

```text
field operator value
```

Example:

```bash
tshark -Y 'ip.addr == 10.10.10.10'
```

Here:

- `ip.addr` is the packet field
- `==` means “equals”
- `10.10.10.10` is the value being searched for

### Shell Quoting

Using single quotes around display filters is recommended:

```bash
tshark -Y 'ip.addr == 10.10.10.10'
```

Single quotes help prevent spaces and special characters from being interpreted by the shell.

---

## Display Filter Operators

| Operator | Meaning | Example |
|----------|---------|---------|
| `==` | Equals | `ip.addr == 10.10.10.10` |
| `!=` | Does not equal | `tcp.port != 80` |
| `>` | Greater than | `tcp.len > 100` |
| `<` | Less than | `tcp.len < 100` |
| `>=` | Greater than or equal to | `tcp.len >= 100` |
| `<=` | Less than or equal to | `tcp.len <= 100` |
| `contains` | Contains text or data | `http.request.uri contains 'login'` |
| `matches` | Matches a regular expression | `http.host matches 'example'` |

---

## Boolean Operators

Boolean operators allow you to combine multiple conditions.

| Operator | Meaning | Example |
|----------|---------|---------|
| `and` | Both conditions must match | `tcp and tcp.port == 80` |
| `or` | Either condition can match | `tcp.port == 80 or tcp.port == 443` |
| `not` | Excludes matching packets | `not arp` |

### Example

```bash
tshark -r capture.pcap -Y 'tcp.port == 80 or tcp.port == 443'
```

This displays TCP traffic using port `80` or port `443`.

### Using Parentheses

```bash
tshark -r capture.pcap -Y 'ip.addr == 10.10.10.10 and (tcp.port == 80 or tcp.port == 443)'
```

This displays traffic involving `10.10.10.10` that uses port `80` or `443`.

---

# Common Display Filters

## Protocol: IP

### Filter an IP Address

```bash
tshark -r capture.pcap -Y 'ip.addr == 10.10.10.10'
```

Displays packets sent to or received from `10.10.10.10`.

### Filter an IP Network

```bash
tshark -r capture.pcap -Y 'ip.addr == 10.10.10.0/24'
```

Displays packets involving the specified IPv4 network.

### Filter a Source IP

```bash
tshark -r capture.pcap -Y 'ip.src == 10.10.10.10'
```

Displays packets sent from `10.10.10.10`.

### Filter a Destination IP

```bash
tshark -r capture.pcap -Y 'ip.dst == 10.10.10.10'
```

Displays packets sent to `10.10.10.10`.

### Side-by-Side IP Examples

| Goal | Capture Filter | Display Filter |
|------|----------------|-----------------|
| Any traffic involving an IP | `-f 'host 10.10.10.10'` | `-Y 'ip.addr == 10.10.10.10'` |
| Traffic from an IP | `-f 'src host 10.10.10.10'` | `-Y 'ip.src == 10.10.10.10'` |
| Traffic to an IP | `-f 'dst host 10.10.10.10'` | `-Y 'ip.dst == 10.10.10.10'` |

---

## Protocol: TCP

### Filter TCP Traffic

```bash
tshark -r capture.pcap -Y 'tcp'
```

Displays TCP packets.

### Filter a TCP Port

```bash
tshark -r capture.pcap -Y 'tcp.port == 80'
```

Displays TCP packets using port `80`.

### Filter a Source TCP Port

```bash
tshark -r capture.pcap -Y 'tcp.srcport == 80'
```

Displays packets sent from TCP source port `80`.

### Filter a Destination TCP Port

```bash
tshark -r capture.pcap -Y 'tcp.dstport == 80'
```

Displays packets sent to TCP destination port `80`.

### Side-by-Side TCP Examples

| Goal | Capture Filter | Display Filter |
|------|----------------|-----------------|
| Any TCP traffic | `-f 'tcp'` | `-Y 'tcp'` |
| TCP port 80 | `-f 'tcp port 80'` | `-Y 'tcp.port == 80'` |
| TCP source port 80 | `-f 'tcp src port 80'` | `-Y 'tcp.srcport == 80'` |
| TCP destination port 80 | `-f 'tcp dst port 80'` | `-Y 'tcp.dstport == 80'` |

---

## Protocol: HTTP

### Filter HTTP Packets

```bash
tshark -r capture.pcap -Y 'http'
```

Displays HTTP packets.

### Filter HTTP Response Code 200

```bash
tshark -r capture.pcap -Y 'http.response.code == 200'
```

Displays HTTP responses with status code `200`.

### Filter HTTP GET Requests

```bash
tshark -r capture.pcap -Y 'http.request.method == "GET"'
```

Displays HTTP GET requests.

### Filter a Specific HTTP Host

```bash
tshark -r capture.pcap -Y 'http.host == "example.com"'
```

Displays HTTP traffic for `example.com`.

---

## Protocol: DNS

### Filter DNS Packets

```bash
tshark -r capture.pcap -Y 'dns'
```

Displays DNS packets.

### Filter DNS A Queries

```bash
tshark -r capture.pcap -Y 'dns.qry.type == 1'
```

Displays DNS queries for IPv4 address records, also called `A` records.

### Filter DNS Queries for a Domain

```bash
tshark -r capture.pcap -Y 'dns.qry.name == "example.com"'
```

Displays DNS queries for `example.com`.

---

# Testing Display Filters

The following examples use a capture file named `demo.pcapng`.

## Filter by IP Address

```bash
tshark -r demo.pcapng -Y 'ip.addr == 145.253.2.203'
```

Example output:

```text
13  2.55  145.254.160.237 → 145.253.2.203  DNS  Standard query
17  2.91  145.253.2.203 → 145.254.160.237  DNS  Standard query response
```

The filter matched two packets.

However, the packet numbers are `13` and `17`, not `1` and `2`.

This happens because TShark displays the **original packet numbers from the capture file**.

It does not renumber packets after filtering.

---

## Filter by HTTP

```bash
tshark -r demo.pcapng -Y 'http'
```

Example output:

```text
4   0.911  145.254.160.237 → 65.208.228.223  HTTP  GET /download.html
18  2.984  145.254.160.237 → 216.239.59.99   HTTP  GET /pagead/ads
27  3.955  216.239.59.99 → 145.254.160.237   HTTP  HTTP/1.1 200 OK
38  4.846  65.208.228.223 → 145.254.160.237  HTTP  HTTP/1.1 200 OK
```

The matching packets have original packet numbers `4`, `18`, `27`, and `38`.

Therefore, the output contains four matching packets, even though the packet numbers are not sequential.

---

# Counting Filtered Packets

You can use the `nl` command to add a new sequential number to each line of output.

```bash
tshark -r demo.pcapng -Y 'http' | nl
```

Example output:

```text
     1  4   0.911  145.254.160.237 → 65.208.228.223  HTTP  GET /download.html
     2  18  2.984  145.254.160.237 → 216.239.59.99   HTTP  GET /pagead/ads
     3  27  3.955  216.239.59.99 → 145.254.160.237   HTTP  HTTP/1.1 200 OK
     4  38  4.846  65.208.228.223 → 145.254.160.237  HTTP  HTTP/1.1 200 OK
```

The first column added by `nl` is the number of matching output lines.

In this example:

- Original packet numbers: `4`, `18`, `27`, `38`
- Number of filtered packets: `4`

### Analogy

Think of the original packet number as the vehicle's position in the complete recording.

The number added by `nl` is the vehicle's position in your filtered search results.

---

# Useful Display Filter Examples

| Goal | Display Filter |
|------|----------------|
| Show IP traffic | `tshark -r capture.pcap -Y 'ip'` |
| Show IPv6 traffic | `tshark -r capture.pcap -Y 'ipv6'` |
| Show TCP traffic | `tshark -r capture.pcap -Y 'tcp'` |
| Show UDP traffic | `tshark -r capture.pcap -Y 'udp'` |
| Show ICMP traffic | `tshark -r capture.pcap -Y 'icmp'` |
| Show HTTP traffic | `tshark -r capture.pcap -Y 'http'` |
| Show DNS traffic | `tshark -r capture.pcap -Y 'dns'` |
| Show traffic from an IP | `tshark -r capture.pcap -Y 'ip.src == 10.10.10.10'` |
| Show traffic to an IP | `tshark -r capture.pcap -Y 'ip.dst == 10.10.10.10'` |
| Show traffic involving an IP | `tshark -r capture.pcap -Y 'ip.addr == 10.10.10.10'` |
| Show TCP port 80 | `tshark -r capture.pcap -Y 'tcp.port == 80'` |
| Show HTTP status 200 | `tshark -r capture.pcap -Y 'http.response.code == 200'` |
| Show DNS A queries | `tshark -r capture.pcap -Y 'dns.qry.type == 1'` |

---

## Important Notes

- Capture filters use **BPF syntax** and use the `-f` parameter.
- Display filters use **Wireshark display-filter syntax** and use the `-Y` parameter.
- Display filters do not modify the original capture file.
- TShark keeps the original packet numbers when displaying filtered packets.
- Use `nl` when you need a simple count of the displayed results.
- Use single quotes around filters to avoid shell expansion and spacing problems.

## Quick Memory Trick

> **Capture filter:** Decide what gets recorded.  
> **Display filter:** Decide what gets shown.
