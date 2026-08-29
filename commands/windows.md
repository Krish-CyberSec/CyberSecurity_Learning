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

## 9. checks the file system and disk volumes for errors and bad sectors
```
chkdsk
```

## 10. displays a list of installed device drivers.
```
driverquery
```

## 11.  Scans system files for corruption and repairs them if possible.
```
sfc /scannow
```

## 12. The command can shut down a system.
```
shutdown /s
```

## 13. The command can restart a system.
```
shutdown /r /t 0
```

## 14. Abort a Scheduled Shutdown

Cancels a scheduled shutdown or restart.

```cmd
shutdown /a
```

## 15. Alternative to dir in PowerShell
```cmd
Get-ChildItem -Path "./Documents"
```
If no path is specified, it displays the current directory's children


## 16. Alternative to cd in PowerShell
```cmd
 Set-Location -Path ".\Documents"
```

## 17. Alternative to mkdir or echo in PowerShell for creating a directory or file 
   1. For a directory
   ```cmd

         New-Item -Path ".\captain-cabin\captain-wardrobe" -ItemType "Directory"
   ```
  2. For a file
  ```cmd
   New-Item -Path ".\captain-cabin\captain-wardrobe\captain-boots.txt" -ItemType "File"
  ```

## 18. Alternative to rmdir or del in PowerShell for deleting a directory or file 

   ```cmd
    Remove-Item -Path ".\captain-cabin\captain-wardrobe\captain-boots.txt"
   ```
   same command will work for a directory; just write the path

## 19. 
      
