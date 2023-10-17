# heating-boiler-controller

NodeMCU heating boiler controller

## Firmware upload command

```sh
./esptool -p /dev/ttyUSB0 write_flash -fm qio 0x00000 ../nodemcu-release-*-float.bin
```
