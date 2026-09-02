# WireShark 

## 1. View File Details
``
ou can view the details by following "Statistics --> Capture File Properties" or by clicking the "pcap icon located on the bottom left".
``

<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/9e941375-f2d6-4497-b759-7c52d0a0aa38" />
<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/2eab889e-73c5-476b-834b-6a8d736ada72" />

## 2. Packet Filtering
  1. ``Apply as Filter``
     This is the most basic way of filtering traffic. While investigating a capture file, you can click on the field you want to filter and use the "right-click          menu" or "Analyse --> Apply as Filter" menu to filter the specific value. Note that the total and displayed packet numbers are always shown on the status        bar.

  2. ``Conversation Filter``
     When you use the "Apply as a Filter" option, you will filter only a single entity of the packet. This option is a good way of investigating a particular value      in packets. However, suppose you want to investigate a specific packet number and all linked packets by focusing on IP addresses and port numbers. In that          case, the "Conversation Filter" option helps you view only the related packets and hide the rest of the packets easily. You can use the"right-click menu" or        the "Analyse --> Conversation Filter" menu to filter conversations.

  3. ``Colourise Conversation``
     This option is similar to the "Conversation Filter" with one difference. It highlights the linked packets without applying a display filter and decreasing the      number of viewed packets. This option works with the "Colouring Rules" option to apply changes to the colored packets without taking the previously applied         colour rules into account. You can use the "right-click menu" or "View --> Colourise Conversation" menu to colourise a linked packet in a single click. Note        that you can use the "View --> Colourise Conversation --> Reset Colourisation" menu to undo this operation.

  4. ``Apply as Column``
     By default, the packet list pane provides basic information about each packet. You can use the "right-click menu" or "Analyse --> Apply as Column" menu to add columns to the packet list pane. Once you click on a value and apply it as a column, it will be visible on the packet list pane. This function helps analysts examine the appearance of a specific value/field across the available packets in the capture file. You can enable/disable the columns shown in the packet list pane by clicking on the top of the packet list pane.

5. ``Follow Stream``
   Wireshark displays everything in packet portion size. However, it is possible to reconstruct the streams and view the raw traffic as it is presented at the application level. Following the protocol, streams help analysts recreate the application-level data and understand the event of interest. It is also possible to view the unencrypted protocol data like usernames, passwords and other transferred data.

    You can use the"right-click menu" or "Analyse --> Follow TCP/UDP/HTTP Stream" menu to follow traffic streams. Streams are shown in a separate dialogue box;       packets originating from the server are highlighted with blue, and those originating from the client are highlighted with red.


