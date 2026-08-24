# Commands 

1. ``` find ```

    ---
   us to find files inside the system
   ---
   
2. ```grep```
   
   ---
   use to find things inside a file like finding a txt
   ---


 3.  ## Combine commands and capture their output
   
        1 . ``` & ```
           
        ---
          Runs the command, but does not wait for it to finish before you can do anything else. The command runs in the backgorund, and is helpful for                        commands that might take a while to complete, or ones that you want to keep running.
        ---
    
        2.  ``` && ```
          
            ---
            Runs both commands, but waits for the first command to finish first, before the next. Like a set of dominoes.
            ---
    
        3.  ```>```
          
              ---
              Used to redirect output. We can take the output of a command and send it to a file. This operator will overwrite anything that exists in the file.
              ---
       
        4.  ```>>```
          
              ---
              This redirector does the same thing, but instead of overwriting, it will just add the output to the bottom of the file.
              ---

4.  Downloading Files (Wget)

     ```
     ex: wget  https://assets.tryhackme.com/additional/linux-fundamentals/part3/myfile.txt
     ```

    
5.  Transferring Files From Your Host - SCP (SSH)

    ```
    ex : scp important.txt ubuntu@192.168.1.30:/home/ubuntu/transferred.txt
    ```

6. processes
    1. to see the processes running in current user 
    ```
    ps
    ```
    
    2. to see all the processes running by all the user
    ```
    ps aux
    ```

    3. this gives you real-time statistics about the processes running on your system instead of a one-time view.
    ```
    top
    ```

    4. to kill a process
    ```
    kill PSID
    ```

    5. Getting processes/services to start on BOOT
       ```
       systemctl [option] [service]
       ```
       options:
         1. Start
         2. Stop
         3. Enable
         4. Disable
         5. Status
    
