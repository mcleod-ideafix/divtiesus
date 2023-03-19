# DivTIESUS
DivTIESUS is a SD/MMC card interface for the ZX Spectrum. First designed by Mario Pratto as DivMMC, DivTIESUS is an independent design, compatible with the I/O ports and mapper used both in DivIDE and DivMMC, but adding more features.

There is a larger version of DivTIESUS, nicknamed "Pijus Magnificus" edition. This one is the "Tiesus del tó" version, which I have released for the community, so anyone can build their own interface.

# Features
- DivMMC compatible interface with 8 KiB of EEPROM and 512 KiB of RAM. Standard utils for EEPROM flashing, as provided by the ESXDOS team, are compatible with DivTIESUS.
- Model autodetection. This means you don't need to put a jumper, or flip a switch to change from using it with a Spectrum 48K and a +3.
- Tested with ZX Spectrum 48K issue 1, 2, 3, 3B, 4A, 4B and 6A. NEC and Hitachi ROM chips. Also tested on Inves Spectrum, Spectrum 128K (both english and spanish versions), +2 grey, +2A, +2B and +3. Also tested on Harlequin 48K. Compatible with TK90X also.
- It uses its own fast clock (25 MHz). It does not need the CPU clock at all.
- Rear expansion port continuation, allowing the user to plug another device. Note that ROMCS and other signals are not filtered.
- NMI button to call file browser in ESXDOS, and handy RESET button. The RESET button is placed so that it won't be accidentally pressed while operating the interface.
- Standard SD card slot (accepts both big SD cards and microSD cards (with adapter).
- A single switch is used to indicate DivTIESUS that the EEPROM can be flashed (JP2 equivalent) and the automapping feature is disabled.
- Visual feedback for SD activity (blue led) and update EEPROM mode (red led).
- ESXDOS shadowing does not collide with all-RAM feature in +2A/B/3 machines. If the system is in all-RAM mode, ESXDOS ROM mapping is disabled.
- Soft +3E feature: DivTIESUS is able to load +3E ROM images from the SD card, install them as the system ROM (using its own RAM), and make them available to the computer, while disabling the automapping feature (needed for ESXDOS but not for +3eDOS). This, effectively, allows the user to operate his/her +2A/B/3 machine as a +2e/3e one, all without having to open the case and exchange ROMs. A new dot command, ".go3e" makes this possible. Such command only works with DivTIESUS.
- Soft ROM feature: the soft +3E feature can also be used to load any 16K, 32K or 64K ROM and make the computer to boot with that ROM (the dot command currently supports only 16K ROMs). This means that ROM images for some util/games available for the Spectrum can be run in their original form. No need to have a +2A/B/3 machine to use them.

# Pictures
![](img/divtiesus_front.jpg)

# Bill of materials
|Qty|Value|PCB part|Mouser ref.|
| ------------ | ------------ | ------------ | ------------ |
|2|WS-TATU-TH 431256058726|NMI, RESET|710-431256058726|
|1|SDCARD SLOT|SDCARD|523-GMC020080HR|
|2|1K|R1, R5|603-RC0603FR-131KL|
|5|10K|R2, R4, R6, R7, R8|603-RC0603FR-1310KL|
|3|10uF|C1, C2, C13|581-0805YC106KAT2A|
|1|22K|R3|603-RC0603FR-1322KL|
|1|25 MHz 3225|Q1|520-3225Q-33-240-BST|
|1|28C64ASO|IC2|556-AT28C64B15SU|
|10|100nF|C3, C4, C5, C6, C7, C8, C9, C10, C11, C12|581-0603YC104J4T4A|
|1|CONECTOR_BUS_TRASERO|U$1|571-5530843-6|
|1|EPM240T100C4|IC3|989-EPM240T100C4|
|1|IS65C1024ALSO32|IC4|727-CY62128ELL45SXIT|
|1|JTAG|JTAG|517-N2510-6002RB|
|1|LED0805-BLUE|SD ACTIVITY|710-150080BS75000|
|1|LED0805-RED|FIRMWARE UPDATE ENABLED|710-150080RS75000|
|1|LM1117-3.3|IC1|579-TC1264-3.3VDB|
|1|SWITCH_SMD_6PIN|JUMPER_E|4000030382277 (Aliexpress)|

