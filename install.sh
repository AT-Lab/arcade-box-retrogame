#!/usr/bin/env/ sh

echo "Script di installazione dei file necessari all'utilizzo delle GPIO come tastiera"
echo "Creato dal team AT Lab"

if [ "$(id -u)" -ne 0 ]
then echo "Lanciare questo script come sudo ./$0"
    exit
else
    if [ -e retrogame ]
    then
        echo "Copio retrogame in .bin..."
        cp retrogame "/storage/retrogame"
    else
        echo "File retrograme non trovato"
        exit
    fi

    if [ -e retrogame.cfg ]
    then
        echo "Copio retrogame.cfg in .bin..."
        cp retrogame "/storage/retrogame.cfg"
    else
        echo "File retrograme.cfg non trovato"
        exit
    fi

    if [ -e retrogame.service ]
    then
        echo "Copio retrogame.service in .bin..."
        cp retrogame "/storage/.config/systemd/user/retrogame.service"
    else
        echo "File retrograme.service non trovato"
        exit
    fi

    systemctl enable retrogame.service
    systemctl start retrogame.sercice
    
    echo "SUBSYSTEM==\"input\", ATTRS{name}==\"retrogame\", ENV{ID_INPUT_KEYBOARD}=\"1\"" >> /etc/udev/rules.d/10-retrogame.rules
    echo "Imposto l'ora italiana..."
    echo "TIMEZONE=Europe/Rome" > /storage/.cache/timezone
    
    printf "Finito, riavvia la macchina con il comando\nsudo systemctl reboot"

fi

