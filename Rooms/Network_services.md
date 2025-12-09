# SMB (Server Message Block) Protocol

## Overview

**SMB (Server Message Block)** ek protocol hai jo **files, printers**, aur **resources** ko **client-server** ke beech share karne mein madad karta hai. Ye protocol mainly **Ports 139 aur 445** par work karta hai.

SMB **inter-process communication (IPC)** ke liye bhi use ho sakta hai, matlab ye ek **Transport Layer** ki tarah kaam kar sakta hai, jo structured information exchange ke liye hota hai. Ye **Response-Request Protocol** hai, iska matlab hai ki ye client aur server ke beech multiple messages send karta hai connection establish karne ke liye.

## Key Features:
- **File aur Printer Sharing**: SMB client ko server par shared files, printers, aur resources access karne ki suvidha deta hai.
- **Inter-Process Communication**: Ye alag-alag machines ke processes ke beech data exchange karne ke liye use hota hai.
- **Response-Request Protocol**: SMB multiple messages ko request-response manner mein transmit karta hai connection establish karne ke liye.
- **Transport Layer**: Ye ek transport layer ki tarah bhi function kar sakta hai, jo structured information exchange karta hai.

## Communication Methods:
- **TCP/IP**: Clients server se connect hone ke liye **TCP/IP** ka use karte hain, khaas karke **NetBIOS over TCP/IP** jo **RFC1001** aur **RFC1002** mein define hai.
- **NetBEUI ya IPX/SPX**: Ye alternative protocols hain jo SMB ke saath use kiye ja sakte hain communication ke liye.

## Ports:
- **Port 139**: Ye SMB over NetBIOS ke liye use hota hai.
- **Port 445**: Ye SMB over TCP/IP direct connection ke liye use hota hai, bina NetBIOS ke.

## Use Cases:
- **File Sharing**: SMB file sharing ko easy banata hai network par.
- **Printer Sharing**: SMB printers ko network par share karne ke liye use hota hai.
- **Network Communication**: Ye inter-process communication ke liye bhi use hota hai, jisme applications ke beech data exchange hota hai.
