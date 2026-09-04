# TShark 

## Command-Line Packet Analysis Hints

TShark is a text-based tool that is suitable for data carving, in-depth packet analysis, and automation with scripts. Its strength and flexibility come from the nature of CLI tools, as the produced and processed data can be pipelined to additional tools.

### Common Tools and Utilities

| Tool/Utility | Purpose and Benefit |
|---|---|
| `capinfos` | A program that provides details of a specified capture file. It is suggested to view the summary of the capture file before starting an investigation. |
| `grep` | Helps search plain-text data. |
| `cut` | Helps cut parts of lines from a specified data source. |
| `uniq` | Filters repeated lines or values. |
| `nl` | Views the number of shown lines. |
| `sed` | A stream editor used to filter and transform text. |
| `awk` | A scripting language that helps with pattern searching and processing. |

### Basic Workflow

1. Use `capinfos` to inspect the capture file.
2. Use `tshark` to extract and analyze packet data.
3. Use `grep` to search for specific patterns or values.
4. Use `cut` to extract specific fields.
5. Use `uniq` to remove duplicate values.
6. Use `nl` to display line numbers.
7. Use `sed` to manipulate or filter text.
8. Use `awk` for advanced pattern matching and data processing.

## Example

```bash
tshark -r capture.pcap -T fields -e ip.src | sort | uniq
```

## Command-Line Interface and Parameters

TShark is a text-based (command-line) tool. Therefore, conducting an in-depth and consecutive analysis of the obtained results is easy.

Multiple built-in options are available to help analysts conduct such investigations. However, learning the parameters is essential. You will need the built-in options and associated parameters to control the output and avoid being flooded with detailed TShark output.

> **Note:** TShark requires superuser privileges to sniff live traffic and list all available interfaces.

### Common Parameters

| Parameter | Purpose | Example |
|---|---|---|
| `-h` | Display the help page with the most common features. | `tshark -h` |
| `-v` | Show version information. | `tshark -v` |
| `-D` | List available sniffing interfaces. | `tshark -D` |
| `-i` | Choose an interface to capture live traffic. | `tshark -i 1` |
| `-i` | Choose an interface by its name. | `tshark -i ens55` |
| No parameter | Sniff traffic similar to `tcpdump`. | `tshark` |

### Examples

#### Display Help

```bash
tshark -h
```

# Command-Line Packet Analysis

TShark is a text-based (command-line) tool suitable for data carving, in-depth packet analysis, and automation with scripts. Its strength and flexibility come from the ability to pipe processed data into additional command-line tools.

## Common Command-Line Tools

| Tool/Utility | Purpose |
|---|---|
| `capinfos` | Provides details and statistics about a capture file. |
| `grep` | Searches plain-text data. |
| `cut` | Extracts parts of lines or fields from a data source. |
| `uniq` | Filters repeated lines or values. |
| `nl` | Displays line numbers. |
| `sed` | Stream editor used to filter and transform text. |
| `awk` | Performs pattern searching and text processing. |

## Command-Line Interface and Parameters

TShark provides multiple built-in options that allow analysts to control packet capture, reading, writing, filtering, and output. Learning these parameters is essential to avoid being flooded with unnecessary output.

> **Note:** TShark requires superuser privileges to sniff live traffic and list all available interfaces.

| Parameter | Purpose | Example |
|---|---|---|
| `-h` | Display the help page with the most common features. | `tshark -h` |
| `-v` | Show version information. | `tshark -v` |
| `-D` | List available sniffing interfaces. | `tshark -D` |
| `-i` | Choose an interface to capture live traffic. | `tshark -i 1` |
| `-i` | Choose an interface by name. | `tshark -i ens55` |
| No parameter | Sniff traffic similar to `tcpdump`. | `tshark` |
| `-r` | Read/input function. Read a capture file. | `tshark -r demo.pcapng` |
| `-c` | Packet count. Stop after capturing, filtering, or reading a specified number of packets. | `tshark -c 10` |
| `-w` | Write/output function. Write sniffed or filtered traffic to a file. | `tshark -w sample-capture.pcap` |
| `-V` | Verbose output. Provide detailed information for each packet. | `tshark -V` |
| `-q` | Silent mode. Suppress packet output on the terminal. | `tshark -q` |
| `-x` | Display packet bytes in hexadecimal and ASCII format. | `tshark -x` |

## Read Capture Files

TShark can process PCAP and PCAPNG files using the `-r` parameter.

### Read a Capture

```bash
tshark -r demo.pcapng
```

# TShark Command-Line Packet Analysis

TShark is Wireshark's command-line network packet analyzer. It can read capture files, display packet details, filter traffic, save packets to new files, and inspect raw packet bytes.

## Table of Contents

* [Prerequisites](#prerequisites)
* [Read Packets](#read-packets)
* [Read by Packet Count](#read-by-packet-count)
* [Write Data](#write-data)
* [Show Packet Bytes](#show-packet-bytes)
* [Verbosity](#verbosity)
* [Quick Reference](#quick-reference)
* [Useful Examples](#useful-examples)

## Prerequisites

Install Wireshark or TShark before running these commands.

Check whether TShark is installed:

```bash
tshark -v
```

## Read Packets

TShark can read packets from a capture file using the `-r` parameter.

### Command

```bash
tshark -r demo.pcapng
```

### Example Output

```text
1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
2   0.911310 65.208.228.223 ? 145.254.160.237 TCP 80 ? 3372 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1380 SACK_PERM=1
3   0.911310 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [ACK] Seq=1 Ack=1 Win=9660 Len=0
```

## Read by Packet Count

Use the `-c` parameter to limit the number of packets displayed.

### Show Only the First Two Packets

```bash
tshark -r demo.pcapng -c 2
```

### Example Output

```text
1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
2   0.911310 65.208.228.223 ? 145.254.160.237 TCP 80 ? 3372 [SYN, ACK] Seq=0 Ack=1 Win=5840 Len=0 MSS=1380 SACK_PERM=1
```

## Write Data

TShark can write sniffed or filtered packets to a file using the `-w` parameter.

This is useful for separating specific packets from a capture and saving them for further analysis or sharing suspicious traffic with other investigators.

### Write a Capture

Read the first packet from `demo.pcapng` and save it to `write-demo.pcap`:

```bash
tshark -r demo.pcapng -c 1 -w write-demo.pcap
```

### List the Files in the Current Directory

```bash
ls
```

### Example Output

```text
demo.pcapng  write-demo.pcap
```

### Read the Newly Created Capture

```bash
tshark -r write-demo.pcap
```

### Example Output

```text
1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
```

## Show Packet Bytes

TShark can display packet bytes in hexadecimal and ASCII format using the `-x` parameter.

### Command

```bash
tshark -r write-demo.pcap -x
```

### Example Output

```text
0000  fe ff 20 00 01 00 00 00 01 00 00 00 08 00 45 00   .. ...........E.
0010  00 30 0f 41 40 00 80 06 91 eb 91 fe a0 ed 41 d0   .0.A@.........A.
0020  e4 df 0d 2c 00 50 38 af fe 13 00 00 00 00 70 02   ...,.P8.......p.
0030  22 38 c3 0c 00 00 02 04 05 b4 01 01 04 02         "8............
```

Because `-x` displays packet bytes for each packet, it can produce a large amount of output. It is more efficient to reduce the number of packets first.

### Example

```bash
tshark -r demo.pcapng -c 1 -x
```

## Verbosity

By default, TShark provides a single line of information for each packet. The `-V` parameter provides detailed information for every packet, similar to Wireshark's Packet Details Pane.

### Default Output

```bash
tshark -r demo.pcapng -c 1
```

### Example Output

```text
1   0.000000 145.254.160.237 ? 65.208.228.223 TCP 3372 ? 80 [SYN] Seq=0 Win=8760 Len=0 MSS=1460 SACK_PERM=1
```

### Verbose Output

```bash
tshark -r demo.pcapng -c 1 -V
```

### Example Output

```text
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

Verbose output provides full packet details and can make analysis difficult when used against many packets. However, it is extremely useful for in-depth packet analysis, scripting, data carving, and correlation.

> **Tip:** Filter or reduce the number of packets first, then use `-V` for detailed analysis.

## Quick Reference

| Command    | Description                      |
| ---------- | -------------------------------- |
| `capinfos` | Capture file information         |
| `tshark`   | Command-line packet analysis     |
| `grep`     | Search text                      |
| `cut`      | Extract fields                   |
| `uniq`     | Remove duplicates                |
| `nl`       | Show line numbers                |
| `sed`      | Stream editor                    |
| `awk`      | Pattern searching and processing |

### TShark Options

| Option | Description                           |
| ------ | ------------------------------------- |
| `-h`   | Display help                          |
| `-v`   | Show version information              |
| `-D`   | List available interfaces             |
| `-i`   | Select an interface for live capture  |
| `-r`   | Read a capture file                   |
| `-c`   | Limit the number of packets           |
| `-w`   | Write packets to a capture file       |
| `-V`   | Display detailed packet information   |
| `-q`   | Suppress packet output                |
| `-x`   | Display packet bytes in hex and ASCII |

## Useful Examples

### Display Help

```bash
tshark -h
```

### Show Version

```bash
tshark -v
```

### List Available Interfaces

```bash
tshark -D
```

### Capture Traffic on Interface 1

```bash
tshark -i 1
```

### Capture Traffic on ens55

```bash
tshark -i ens55
```

### Read a Capture File

```bash
tshark -r demo.pcapng
```

### Read Only the First 10 Packets

```bash
tshark -r demo.pcapng -c 10
```

### Write the First Packet to a New Capture

```bash
tshark -r demo.pcapng -c 1 -w write-demo.pcap
```

### Read the New Capture

```bash
tshark -r write-demo.pcap
```

### Display Packet Bytes

```bash
tshark -r write-demo.pcap -x
```

### Display Detailed Packet Information

```bash
tshark -r demo.pcapng -c 1 -V
```

### Suppress Packet Output

```bash
tshark -r demo.pcapng -q
```

## Notes

* Replace `demo.pcapng` with the name of your capture file.
* Use `-c` to limit output when working with large captures.
* Use `-V` for detailed packet analysis.
* Use `-x` to inspect raw packet bytes.
* Use `-w` to save selected packets to a new capture file.
* Run `tshark -D` before live capture to identify the correct network interface.
