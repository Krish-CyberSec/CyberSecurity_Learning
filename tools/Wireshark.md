# WireShark 

## 1. View File Details
``
ou can view the details by following "Statistics --> Capture File Properties" or by clicking the "pcap icon located on the left bottom".
``

<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/9e941375-f2d6-4497-b759-7c52d0a0aa38" />
<img width="400" height="400" alt="image" src="https://github.com/user-attachments/assets/2eab889e-73c5-476b-834b-6a8d736ada72" />

## 2. Packet Filtering
  1. ``Apply as Filter``
     This is the most basic way of filtering traffic. While investigating a capture file, you can click on the field you want to filter and use the "right-click          menu" or "Analyse --> Apply as Filter" menu to filter the specific value. Note that the number of total and displayed packets are always shown on the status        bar.

  2. ``Conversation Filter``
     When you use the "Apply as a Filter" option, you will filter only a single entity of the packet. This option is a good way of investigating a particular value      in packets. However, suppose you want to investigate a specific packet number and all linked packets by focusing on IP addresses and port numbers. In that          case, the "Conversation Filter" option helps you view only the related packets and hide the rest of the packets easily. You can use the"right-click menu" or        the "Analyse --> Conversation Filter" menu to filter conversations.

  3. ``Colourise Conversation``
     This option is similar to the "Conversation Filter" with one difference. It highlights the linked packets without applying a display filter and decreasing the      number of viewed packets. This option works with the "Colouring Rules" option to apply changes to the colored packets without taking the previously applied         colour rules into account. You can use the "right-click menu" or "View --> Colourise Conversation" menu to colourise a linked packet in a single click. Note        that you can use the "View --> Colourise Conversation --> Reset Colourisation" menu to undo this operation.

  
