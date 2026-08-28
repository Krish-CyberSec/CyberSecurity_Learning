## 1.  Displays hidden and system files as well
```
dir /a
```

## 2. Displays files in the current directory and all subdirectories.
```
dir /s
```

## 3. To create a directory
```
 mkdir directory_name
```

## 4. for remove directory
```
rmdir directory_name
```

## 5. To display enough text file contents to fill your terminal window
```
more file_name
```

## 6. To see processes running using CMD
```
tasklist
```
## 7. To kill a process
```
taskkill /PID the_PID_number
```

## 8. Filter Running Processes

Filters the process list to find a specific process.

```cmd
tasklist /FI "imagename eq sshd.exe"
```

