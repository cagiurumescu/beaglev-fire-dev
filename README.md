### beaglev-fire-dev

Repo for work on beaglev-fire board. Developer
[repo](https://git.beagleboard.org/beaglev-fire/).

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

#### Licensing
Get a license from Microchip licensing [website](https://www.microchipdirect.com/fpga-software-products). Download the licensing daemons from [this](https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/fpga/licensing) Microchip page. Unzip and the daemon executables to some location. Add the path to the license file (Silver License requested from Microchip) to LM_LICENSE_FILE variable. Add the path to licensing daemons to PATH. `lmdown` is not provided but can be found with Modelsim/Questa (to shut down the licensing daemons). Start the licensing with

```
lmgrd -c license.dat -l /tmp/mylog.log
```

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

#### ~Blinky

Turns out we need the whole beaglev-fire package from [GitLab](https://git.beagleboard.org/beaglev-fire/gateware.git).

To run the BUILD_BVF_GATEWARE.tcl make sure that Libero and the gateware repo are on the same disk drive otherwise some Microchip IP shows file copy errors.

On Linux Mint need:
```
sudo apt install python3-git
sudo apt install python3-yaml
```

After running build-bitstream.py in the `gateware` repo (seems newer and provides working overlays) one gets a set of files for programming the FPGA in DirectC, FlashProExpress, LinuxProgramming formats as detailed [here](https://docs.beagleboard.org/latest/boards/beaglev/fire/demos-and-tutorials/gateware/gateware-full-flow.html#programming-beaglev-fire-with-new-gateware).

To copy the LinuxProgramming files mount the BeagleVFire on your PC using [usbdmsc](https://docs.beagleboard.org/latest/boards/beaglev/fire/demos-and-tutorials/flashing-board.html#flashing-emmc) method. Copy the LinuxProgramming directory in a folder `abcd` under `/usr/share/beagleboard/gateware`, boot the BeagleVFire and run `change-gateware.sh abcd`. Wait for it to complete programming and reboot. You should be able to see the new gateware installed by checking overlay version.
