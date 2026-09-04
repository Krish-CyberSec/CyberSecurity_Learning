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

