# TCP DUMP 

- You can run ``tcpdump`` without providing any arguments; however, this is only useful to test that you have it installed!

1. Specify the Network Interface
   The first thing to decide is which network interface to listen to using ``-i INTERFACE``. You can listen on all available interfaces with ``-i any``;               alternatively, you can specify an interface, such as ``-i eth0``.

2. Save the Captured Packets
   In many cases, you should check the captured packets again later. This can be achieved by saving to a file using ``-w FILE.`` The file extension is most            commonly       set to .pcap. The saved packets can be inspected later using another program, such as Wireshark. You won’t see the packets scrolling when you        choose the ``-w ``  option.

3. Read Captured Packets from a File
   You can use Tcpdump to read packets from a file by using ``-r FILE. ``This is very useful for learning about protocol behaviour. You can capture network traffic    over a suitable time frame to inspect a specific protocol, then read the captured file while applying filters to display the packets you are interested in.         Furthermore, it might be a packet capture file that contains a network attack that took place, and you inspect it to analyze the attack.

4. Limit the Number of Captured Packets
   You can specify the number of packets to capture by specifying the count using ``-c COUNT.`` Without specifying a count, the packet capture will continue till      you interrupt it, for example, by pressing`` CTRL-C. ``Depending on your goal, you only need a limited number of packets.

5. Don’t Resolve IP Addresses and Port Numbers
   Tcpdump will resolve IP addresses and print friendly domain names where possible. To avoid making such DNS lookups, you can use the ``-n ``argument. Similarly,     if you don’t want port numbers to be resolved, such as ``80`` being resolved to ``http`` you can use the ``-nn`` to stop both DNS and port number lookups.          Consider the following example shown in the terminal below. We captured and displayed five packets without resolving the IP addresses.

6. Produce (More) Verbose Output
   If you want to print more details about the packets, you can use ``-v ``to produce a slightly more verbose output. According to the Tcpdump manual page (man      tcpdump), the addition of ``-v`` will print “the time to live, identification, total length and options in an IP packet” among other checks. The ``-vv``          will produce more verbose output; the ``-vvv`` will provide even more verbosity; check the manual page for details.
