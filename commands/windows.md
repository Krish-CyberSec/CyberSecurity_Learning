# Windows Commands 

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

## 19. Piping

Piping (|) sends the output of one command as input to another. In PowerShell, pipes pass objects along with their properties and methods.

### Examples

Sort files by size:
```cmd
Get-ChildItem | Sort-Object Length
```

Filter .txt files:
```cmd
Get-ChildItem | Where-Object -Property "Extension" -eq ".txt"
```
### Common Comparison Operators
Operator	Meaning
``-eq``	Equal to

``-ne``	Not equal to

``-gt``	Greater than

``-ge``	Greater than or equal to

``-lt``	Less than

``-le``	Less than or equal to


Filtered by selecting properties that match  a specified pattern:
```cmd
Get-ChildItem | Where-Object -Property "Name" -like "ship*"
```

This is used to select specific properties from objects or limit the number of objects returned. It’s useful for refining the output to show only the details one needs.
```cmd
Get-ChildItem | Select-Object Name,Length
```

This cmdlet searches for text patterns within files, similar to grep in Unix-based systems or findstr in Windows Command Prompt. It’s commonly used for finding specific content within log files or documents
```cmd
Select-String -Path ".\captain-hat.txt" -Pattern "hat"
```

Key idea: PowerShell piping allows you to filter, sort, and analyze data by chaining commands.
      
## 20. This cmdlet retrieves comprehensive system information, including operating system information, hardware specifications, BIOS details, and more. It provides a snapshot of the entire system configuration in a single command. Its traditional counterpart **systeminfo** retrieves only a small set of the same details.
```cmd
Get-ComputerInfo
```

## 21. Essential for managing user accounts and understanding the machine’s security configuration, this lists all the local user accounts on the system. The default output displays, for each user, username, account status, and description.
```cmd
 Get-LocalUser
```

## 22. Similar to the traditional **ipconfig** command, the following two cmdlets can be used to retrieve detailed information about the system’s network configuration.
   1. This provides detailed information about the network interfaces on the system, including IP addresses, DNS servers, and gateway configurations.
      ```cmd
      Get-NetIPConfiguration
      ```
   2. In case we need specific details about the IP addresses assigned to the network interfaces, this cmdlet will show details for all IP                              addresses configured on the system, including those that are not currently active.
      ```cmd
      Get-NetIPAddress
      ```
      
## 23. This is a PowerShell cmdlet used to read the contents of a file.
```cmd
Get-Content <path>
```

## 24. This provides a detailed view of all currently running processes, including CPU and memory usage, making it a powerful tool for monitoring and troubleshooting.
```cmd
Get-Process
```

## 25. This allows the retrieval of information about the status of services on the machine, such as which services are running, stopped, or paused. It is used extensively in troubleshooting by system administrators, but also by forensics analysts hunting for anomalous services installed on the system.
```cmd
Get-Service
```

## 26. This allows the retrieval of information about the status of services on the machine, such as which services are running, stopped, or paused. It is used extensively in troubleshooting by system administrators, but also by forensics analysts hunting for anomalous services installed on the system.
```cmd
Get-Service
```

## 27. This displays current TCP connections, giving insights into both local and remote endpoints. This cmdlet is particularly handy during an incident response or malware analysis task, as it can uncover hidden backdoors or established connections towards an attacker-controlled server.
```cmd
Get-NetTCPConnection
```

## 28. This is a useful cmdlet for generating file hashes, which is particularly valuable in incident response, threat hunting, and malware analysis, as it helps verify file integrity and detect potential tampering.
```cmd
Get-FileHash
```


## 29. Invoke-Command

Invoke-Command is a PowerShell cmdlet used to execute commands and scripts on local or remote computers.

It is particularly useful for system administration, security engineering, and penetration testing because it enables remote management and automation across multiple systems.

Syntax
```cmd
Invoke-Command -ComputerName <computer> -ScriptBlock { <command> }
```
### Examples
Run a script on a remote computer
```cmd
Invoke-Command -FilePath "C:\scripts\test.ps1" -ComputerName "Server01"
```

The -FilePath parameter specifies a script located on the local computer. PowerShell executes the script on the remote computer and returns the results to the local computer.

Run a command on a remote computer
```cmd
Invoke-Command -ComputerName "Server01" -ScriptBlock { Get-Culture }
```

The -ComputerName parameter specifies the remote computer, while -ScriptBlock specifies the command to execute remotely.

Run commands with specific credentials
```cmd
Invoke-Command -ComputerName "Server01" `
    -Credential "Domain01\User01" `
    -ScriptBlock { Get-Culture }
```

The -Credential parameter allows the command to run under the security context of a specified user account.

PowerShell may prompt for the user's password when the command is executed.

ScriptBlock

The -ScriptBlock parameter is one of the most useful features of Invoke-Command.

For example:
```cmd
Invoke-Command -ComputerName "Server01" -ScriptBlock {
    Get-Process
}
```

Multiple commands can be placed inside the script block:
```cmd
Invoke-Command -ComputerName "Server01" -ScriptBlock {
    Get-Date
    Get-Culture
    Get-Process
}
```

These commands execute on the remote computer, and their output is returned to the local PowerShell session.

Execute a Script on Multiple Computers

Invoke-Command can target multiple computers:
```cmd
Invoke-Command -ComputerName "Server01", "Server02", "Server03" -ScriptBlock {
    Get-ComputerInfo
}
```

This is useful for performing the same administrative task across multiple systems.

Important Parameters
Parameter	Description
-ComputerName	Specifies one or more computers on which to execute the command.

-ScriptBlock	Specifies the commands to execute on the remote computer.

-FilePath	Specifies a local script to execute on the remote computer.

-Credential	Specifies a user account under which the command should run.

-Session	Executes commands using an existing PowerShell session.

Key Concept

The important distinction is where the command executes.
```cmd
Invoke-Command -ComputerName "Server01" -ScriptBlock {
    Get-Process
}
```

Here, Get-Process executes on Server01, not on the local machine. The results are then returned to the local PowerShell session.

In short:

Invoke-Command allows you to execute PowerShell commands or scripts on remote computers and retrieve their results locally.
