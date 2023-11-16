### beaglev-fire-dev

Repo for work on beaglev-fire board. Developer
[repo](https://git.beagleboard.org/beaglev-fire/beaglev-fire/).

#### Unboxing

* power on thru USB-C
* connect UART on DEBUG header and boot default image. Pressing reset shows the
boot process. Can break into the "boot" mode (a-la uboot) by pressing any key.
`help` shows the available commands including selecting boot media.
* Install the Microchip development tools. Libero can be installed on Linux Mint
by replacing `Ubuntu` with `Mint` in the installer.
* Using 1yr Libero Silver license which should be fine for the MPFS025T FPGA on
this board.
* To run Libero one needs to run the provided floating license daemon. Only 64
bit works (didn't go to multilib path) and to be able to run `lmgrd` one really
needs to install the `lsb` package (`ldd lmgrd` helped). Do not run Libero right
after starting the daemon, takes a few 10-15 secs to start.
* Update the LM_LICENSE_FILE environment variable for the user running Libero
with the path to the license.dat from Microchip website.
* Likely advisable to heed the advice of installing Libero under a user account
rather than as root/sudo at some system location. While all is good running 
Libero, downloading IP fails because of write permissions. Still, it can be made
to work if Libero was installed at system location using:
> sudo LM_LICENSE_FILE=$LM_LICENSE_FILE /path/to/libero
Notice that in this case even if the licensing daemon is started by a user
account it will still work when running `libero` as sudo.

#### Blinky
The FPGA is
[MPFS025T-FCVG484E](https://www.microchip.com/en-us/products/fpgas-and-plds/system-on-chip-fpgas/polarfire-soc-fpgas).
Can start a Libero project with this part. There's 11 LEDs available and they 
seem to be visible from the fabric of the FPGA.

There doesn't seem to be any clocking available (didn't try the XCVR refclk) but
the PolarFire FPGAs have two internal RC oscillators of 2MHz and 160MHz. Need IP
for those, which can be downloaded.

Create an empty project. Generate some Verilog and place it in `hdl` folder.
Generate the PDC constraints and put them in the `constraint/io` folder. Import
the Verilog file, build hierarchy then set the Verilog as root file. Go to IP
catalog and instantiate a "PolarFire RC Oscillators" IP with default module
name. Then re-build hierarchy. Go back to Design flow and import constraints
from manage constraints. Git commit minimal files, make sure to regenerate the
160 MHz oscillator IP on clone.

How to program this file? To be continued...


