*** Settings ***
Documentation           This example demonstrates executing external junos library
...                     and checking the OS version of the device.
...                     Needs PyYAML library to import variables

Library                 CustomLib/JunosDevice.py
Variables               variables/inventory.yaml
Variables               variables/credentials.yaml

*** Variables ***
${JUNOS}                 19.4R1.10

*** Test Cases ***
Ckeck Junos OS Version
    : FOR   ${VQFX}     IN  @{VQFXS}
    \       Connect Device  host=${VQFX['ip']}    port=${VQFX['port']}    user=${USERNAME}    password=${PASSWORD}
    \       ${version}=     Get Device Os Version
    \       Should Be Equal As Strings      ${version}      ${JUNOS}
    \       Close Device
