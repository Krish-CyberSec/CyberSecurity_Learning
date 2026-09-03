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

- Although you can run tcpdump without providing any filtering expressions, this won’t be useful. Just like in a social gathering, you don’t try to listen to everyone at the same time; you would rather give your attention to a specific person or conversation. Considering the number of packets seen by our network card, it is impossible to see everything at once; we need to be specific and capture what we are interested in inspecting.


1. Filtering by Host
   Let’s say you are only interested in ``IP ``packets exchanged with your network printer or a specific game server. You can easily limit the captured packets      to this host using ``host IP ``or ``host`` ``HOSTNAME``. In the terminal below, we capture all the packets exchanged with example.com and save them to            ``http.pcap.``     Note that capturing packets requires you to be logged in as ``root ``or to use ``sudo``.

   ```cmd
   sudo tcpdump host example.com -w http.pcap
   ```

  If you want to limit the packets to those from a particular ``source IP address ``or ``hostname``, you must use ``src host IP`` or ``src host HOSTNAME``.         Similarly, you can      limit packets to those sent to a specific destination using ``dst host IP`` or ``dst host HOSTNAME``.

2.  Filtering by Port
    If you want to capture all DNS traffic, you can limit the captured packets to those on port 53. Remember that DNS uses UDP and TCP ports 53 by default. In        the following example, we can see all the DNS queries read by our network card. The terminal below shows two DNS queries: the first query requests the IPv4       address used by example.org, while the second requests the IPv6 address associated with example.org.

    ```cmd
    sudo tcpdump -i ens5 port 53 -n
    ```

   In the above example, we captured all the packets sent to or from a specific port number. You can limit the packets to those from a particular source port        number or to a particular destination port number using ``src port PORT_NUMBER`` and ``dst port PORT_NUMBER``, respectively.


3. Filtering by Protocol
   The final type of filtering we will cover is filtering by protocol. You can limit your packet capture to a specific protocol; examples include: ``ip``,           ``ip6``, ``udp``, ``tcp``, and ``icmp``. In the example below, we limit our packet capture to ICMP packets. We can see an ICMP echo request and reply, which      is a possible indication that someone is running the ``ping`` command. There is also an ICMP time exceeded; this might be due to running the ``traceroute         ``command

   ```cmd
   sudo tcpdump -i ens5 icmp -n
   ```

4. Logical Operators
   - Three logical operators that can be handy:
      - ``and``: Captures packets where both conditions are true. For example, ``tcpdump host 1.1.1.1 and tcp`` captures ``tcp `` traffic with ``host 1.1.1.1``.
      - ``or:`` Captures packets when either one of the conditions is true. For instance, ``tcpdump udp or icmp ``captures UDP or ICMP traffic.
      - ``not:`` Captures packets when the condition is not true. For example, ``tcpdump not tcp`` captures all packets except TCP segments; we expect to find             UDP, ICMP, and ARP packets among the results.


- Consider the following examples:

    - ``tcpdump -i any tcp port 22 ``listens on all interfaces and captures tcp packets to or from port 22, i.e., SSH traffic.
    - ``tcpdump -i wlo1 udp port 123 ``listens on the WiFi network card and filters udp traffic to port 123, the Network Time Protocol (NTP).
    - ``tcpdump -i eth0 host example.com and tcp port 443 -w https.pcap`` will listen on eth0, the wired Ethernet interface and filter traffic exchanged with           example.com that uses tcp and port 443. In other words, this command is filtering HTTPS traffic related to example.com.
