# Linux Fundamentals

## 1. Finding Files — `find`

The `find` command searches for files and directories in the filesystem.

### Basic syntax

```bash
find [path] [options] [expression]
```

### Examples

Find a file by name:

```bash
find /home -name "notes.txt"
```

Find all `.txt` files:

```bash
find /home -name "*.txt"
```

Find directories:

```bash
find /home -type d
```

Find files:

```bash
find /home -type f
```

> **Remember:** `find` searches the filesystem for files and directories.

---

## 2. Searching Inside Files — `grep`

The `grep` command searches for text or patterns **inside files**.

### Basic syntax

```bash
grep "pattern" filename
```

### Examples

Search for `password` inside a file:

```bash
grep "password" notes.txt
```

Search without caring about uppercase/lowercase:

```bash
grep -i "password" notes.txt
```

Search recursively through a directory:

```bash
grep -r "password" /home/user/
```

Show line numbers:

```bash
grep -n "password" notes.txt
```

> **Remember:** `find` helps you locate files; `grep` helps you locate text inside files.

---

# 3. Combining Commands & Redirecting Output

Linux provides several operators that allow you to combine commands and control their input/output.

## `&` — Run in the Background

Adding `&` to the end of a command runs it in the background.

```bash
sleep 30 &
```

Example:

```text
[1] 12345
```

Here:

* `[1]` → Job ID
* `12345` → Process ID (PID)

You can continue using the terminal while the command runs.

When it finishes, the shell may display:

```text
[1]+  Done                    sleep 30
```

### Important

Do **not** type the `[1] 12345` part yourself.

The shell generates it.

Correct:

```bash
echo "THM" &
```

Incorrect:

```bash
echo "THM" & [1] 12345
```

---

## `&&` — Run Commands Sequentially

`&&` runs the second command **only if the first command succeeds**.

```bash
mkdir test && cd test
```

This means:

1. Create the `test` directory.
2. If that succeeds, change into it.

Another example:

```bash
sudo apt update && sudo apt upgrade
```

> **Remember:** `&&` means "run the next command if the previous command succeeded."

---

## `>` — Redirect and Overwrite

`>` redirects command output into a file.

If the file already exists, its contents are **overwritten**.

```bash
echo "Hello" > file.txt
```

Running:

```bash
echo "World" > file.txt
```

will replace `Hello` with `World`.

---

## `>>` — Redirect and Append

`>>` also redirects output, but **adds it to the end of the file** instead of overwriting it.

```bash
echo "Hello" > file.txt
echo "World" >> file.txt
```

The file will contain:

```text
Hello
World
```

### Quick Reference

| Operator | Meaning                                       |
| -------- | --------------------------------------------- |
| `&`      | Run command in the background                 |
| `&&`     | Run next command if previous command succeeds |
| `>`      | Redirect output and overwrite file            |
| `>>`     | Redirect output and append to file            |

---

# 4. Downloading Files — `wget`

`wget` is a command-line utility for downloading files from URLs.

### Basic syntax

```bash
wget [URL]
```

Example:

```bash
wget https://example.com/file.txt
```

The downloaded file will normally be saved in your current directory.

You can specify a different filename with `-O`:

```bash
wget -O myfile.txt https://example.com/file.txt
```

---

# 5. Transferring Files with `scp`

`scp` stands for **Secure Copy**.

It allows you to securely copy files between systems over SSH.

### Copy a local file to a remote machine

```bash
scp important.txt ubuntu@192.168.1.30:/home/ubuntu/transferred.txt
```

The general format is:

```bash
scp [source] [user]@[host]:[destination]
```

### Copy a remote file to your local machine

```bash
scp ubuntu@192.168.1.30:/home/ubuntu/file.txt .
```

Here, `.` means the current directory.

> **Remember:** `scp` is commonly used to transfer files between machines over an SSH connection.

---

# 6. Processes

A **process** is a running instance of a program.

Linux provides several commands for viewing and managing processes.

---

## `ps` — View Processes

To see processes associated with your current shell/user:

```bash
ps
```

For a more detailed view of processes from all users:

```bash
ps aux
```

### Common columns in `ps aux`

```text
USER       PID  %CPU  %MEM  COMMAND
```

* `USER` → User who owns the process
* `PID` → Process ID
* `%CPU` → CPU usage
* `%MEM` → Memory usage
* `COMMAND` → Command that started the process

---

## `top` — Real-Time Process Monitoring

`top` displays running processes and continuously updates the information.

```bash
top
```

It is useful for monitoring:

* CPU usage
* Memory usage
* Running processes
* Process IDs
* System load

Press:

```text
q
```

to exit `top`.

---

## `kill` — Terminate a Process

The `kill` command sends a signal to a process.

```bash
kill PID
```

Example:

```bash
kill 1234
```

By default, `kill` sends `SIGTERM`, which politely asks the process to terminate.

If a process refuses to stop, you can use:

```bash
kill -9 1234
```

> Use `kill -9` carefully. It forcefully terminates the process and does not give it an opportunity to clean up.

---

# 7. Managing Services with `systemctl`

`systemctl` is used to manage **systemd services**.

### Basic syntax

```bash
systemctl [option] [service]
```

### Common options

| Command   | Purpose                           |
| --------- | --------------------------------- |
| `start`   | Start a service                   |
| `stop`    | Stop a service                    |
| `restart` | Restart a service                 |
| `enable`  | Enable a service at boot          |
| `disable` | Disable a service at boot         |
| `status`  | Show the service's current status |

### Examples

Start a service:

```bash
sudo systemctl start nginx
```

Stop a service:

```bash
sudo systemctl stop nginx
```

Restart a service:

```bash
sudo systemctl restart nginx
```

Check its status:

```bash
systemctl status nginx
```

Enable it to start automatically at boot:

```bash
sudo systemctl enable nginx
```

Disable automatic startup:

```bash
sudo systemctl disable nginx
```

### Important distinction

```bash
systemctl start nginx
```

starts the service **now**.

```bash
systemctl enable nginx
```

configures the service to start **automatically during boot**.

You can do both with:

```bash
sudo systemctl enable --now nginx
```

---

# 8. Backgrounding and Foregrounding Jobs

Linux shells allow you to move processes between the foreground and background.

## Run a Command in the Background

Add `&` to the end of a command:

```bash
sleep 30 &
```

Example output:

```text
[1] 12345
```

Where:

* `[1]` → Job ID
* `12345` → PID

You can continue using the terminal while `sleep` runs.

For example:

```bash
echo "I can still use the terminal"
```

Output:

```text
I can still use the terminal
```

After the command finishes:

```text
[1]+  Done                    sleep 30
```

---

# 9. Suspend a Foreground Process — `Ctrl + Z`

Suppose you start a command in the foreground:

```bash
sleep 60
```

Press:

```text
Ctrl + Z
```

The shell will suspend the job.

You may see:

```text
[1]+  Stopped                 sleep 60
```

The process is now **stopped**, not running normally.

---

# 10. View Background Jobs — `jobs`

Use `jobs` to see jobs managed by the current shell.

```bash
jobs
```

Example:

```text
[1]+  Stopped                 sleep 60
```

You can also use:

```bash
ps aux
```

to inspect system processes, but `jobs` specifically shows jobs belonging to your current shell.

---

# 11. Bring a Job to the Foreground — `fg`

Use:

```bash
fg
```

to bring the current/default job back to the foreground.

To specify a particular job:

```bash
fg %1
```

Here:

```text
%1
```

means **job number 1**.

---

# 12. Continue a Stopped Job in the Background — `bg`

After pressing `Ctrl + Z`, you can continue the stopped job in the background using:

```bash
bg
```

Or specify a particular job:

```bash
bg %1
```

For example:

```bash
sleep 60
```

Press:

```text
Ctrl + Z
```

Then:

```bash
bg
```

The `sleep` process will continue running in the background.

---

# 13. Useful Job-Control Commands

| Command     | Meaning                                  |
| ----------- | ---------------------------------------- |
| `command &` | Start a command in the background        |
| `Ctrl + Z`  | Suspend the foreground job               |
| `jobs`      | Show jobs managed by the current shell   |
| `bg`        | Continue a stopped job in the background |
| `fg`        | Bring a background job to the foreground |
| `fg %1`     | Bring job 1 to the foreground            |
| `ps aux`    | Display processes from all users         |
| `top`       | Monitor processes in real time           |
| `kill PID`  | Send a termination signal to a process   |

---

# 14. Example Workflow

A typical job-control workflow looks like this:

```text
             Foreground Process
                    |
                    | Ctrl + Z
                    v
                 Stopped
                /       \
               /         \
             bg           fg
              |            |
              v            v
       Background      Foreground
              |
              | jobs
              v
          View Job
```

Example:

```bash
sleep 60
```

Press:

```text
Ctrl + Z
```

Then:

```bash
jobs
```

Continue it in the background:

```bash
bg %1
```

Check the job:

```bash
jobs
```

Bring it back to the foreground:

```bash
fg %1
```

---

# 15. Key Differences to Remember

### `find` vs `grep`

```text
find  → Find files/directories
grep  → Find text inside files
```

### `>` vs `>>`

```text
>   → Overwrite
>>  → Append
```

### `&` vs `&&`

```text
&   → Background the command
&&  → Run the next command after successful completion
```

### Job ID vs PID

```text
%1  → Job ID used by the shell
1234 → PID used by the operating system
```

For example:

```text
[1] 1234
```

means:

```text
Job ID = 1
PID     = 1234
```

# Cheat Sheet

```bash
# Find files
find /path -name "file.txt"

# Search inside files
grep "text" file.txt

# Run in background
command &

# Run next command only if previous succeeds
command1 && command2

# Overwrite a file
command > file.txt

# Append to a file
command >> file.txt

# Download a file
wget https://example.com/file.txt

# Copy a file over SSH
scp file.txt user@host:/path/

# View your processes
ps

# View all processes
ps aux

# Monitor processes
top

# Kill a process
kill PID

# Manage services
systemctl status service
systemctl start service
systemctl stop service
systemctl restart service
systemctl enable service
systemctl disable service

# View shell jobs
jobs

# Continue stopped job in background
bg %1

# Bring job to foreground
fg %1
```

> **Mental model:**
> `find` finds **files** → `grep` finds **text** → `ps/top` find **processes** → `kill` manages **processes** → `systemctl` manages **services** → `jobs/bg/fg` manage **shell jobs**.
