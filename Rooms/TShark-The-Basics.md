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

