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
