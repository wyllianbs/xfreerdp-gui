# About 

`xfreerdp-gui.sh` is a GUI for ![xfreerdp](<https://github.com/FreeRDP/FreeRDP>) software,
development by Prof. ![Wyllian Bezerra da Silva](mailto:wyllianbs@gmail.com) at
![Federal University of Santa Catarina (UFSC)](<http://wyllian.prof.ufsc.br/>).


# Requirements/Dependencies

- Linux Packages:
  - `freerdp-x11`
  - `gawk`
  - `x11-utils`
  - `yad`
  - `zenity`


# Usage Instructions

![xfree-rdp overview](https://github.com/wyllianbs/xfreerdp-gui/blob/master/xfreerdp-gui.png)

1. Run the script in console, e.g., `bash xfreerdp-gui.sh` or change the permission (`chmod u+x xfreerdp-gui.sh`) and run by command line `./xfreerdp-gui.sh`.

2. Fill the form: 
  - Server address or IP address.
  - Port number.
  - Domain (optional).
  - User name.
  - Password.
  - Name of shared directory at the remote desktop.
  - Path of shared directory at the local host.
  - Any other options that you think should be included and supported by `xfreerdp`.
  - Select: 
    - Resolution of your screen or fill this field (last item in the list).
    - BPP (Bits per Pixel) or fill this field (last item in the list).
    - Full screen (optional).
    - Show log events (optional).
  
3. Click in `<OK>` to establish the connection or press `<Cancel>` to exit.
