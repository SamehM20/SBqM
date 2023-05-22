# SBqM
#### Bank Queue Manager

The idea is to provide a module for a sysytem which gives an indication for a queue(ex: Bank Teller Queue) emptiness and fullness.

Two signals, int_start and int_end, representing the sensors at the start and the end of the queue respectively.
That sensor outputd a logic '1' until getting interrupted at which it outputs a logic '0' until they are no longer interrupted.  

The queue length is controlled by a parameter N, which represents the maximum length available for the queue.
The output Pcout represents the current queue length.

A directed testbench with various testing scenarios is available.
