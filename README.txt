Single-step STM8 flash tool for the HDK IR LED driver board.

Connect your ST-Link v2 compatible USB device to the programming header and to USB (installing the drivers if needed),
and double-click "Program-IRFirmware.cmd" to automatically program the contents of the "ir_led_driver_production.hex"
file (both program flash and eeprom) to the STM8S003K3 on the IR driver board. The other .txt files in this directory
should contain metadata about that firmware image's configuration.

Driven by a powershell script by Ryan Pavlik (that takes in a single HEX file, splits it into program and EEPROM hexes
using srecord/scat, then calls the STM8FLASH command line tool to write the program and eeprom data over an ST-Link V2 USB device),
as well as srecord 1.64 binaries (downloaded from http://sourceforge.net/projects/srecord/files/srecord-win32/1.64/),
and binaries and sources for the STM8FLASH tool (open source - GPL licensed - https://github.com/vdudouyt/stm8flash ).

All you need besides this is to install the ST-Link V2 drivers.
