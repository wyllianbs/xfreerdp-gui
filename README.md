# About 

`xfreerdp-gui.sh` is a GUI for [xfreerdp](<https://github.com/FreeRDP/FreeRDP>) software,
development by Prof. [Wyllian Bezerra da Silva](mailto:wyllianbs@gmail.com) at
[Federal University of Santa Catarina (UFSC)](<http://wyllian.prof.ufsc.br/>).


# Requirements/Dependencies

- Linux Packages:
  - `xfreerdp`
  - `yad`
  - `zenity`


# Installation Instructions

- Run the script in console, e.g., `bash xfreerdp-gui.sh` or change the permission (`chmod u+x xfreerdp-gui.sh`) and run by command line `./xfreerdp-gui.sh`.


# Usage Instructions

1. Fill the form: 
  - Server address or IP address.
  - Port number.
  - Domain (optional).
  - User name.
  - Password.
  - Name of shared directory at the remote desktop.
  - Path of shared directory at the local host.
  - Select: 
    - Resolution of your screen or fill this field (last item in the list).
    - BPP (Bits per Pixel) or fill this field (last item in the list).
    - Full screen (optional).
    - Show log events (optional).
  
2. Click in `<OK>` to establish the connection.
