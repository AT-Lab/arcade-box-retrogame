#!/usr/bin/sh

echo "Script di installazione dei file necessari all'utilizzo delle GPIO come tastiera"
echo "Creato dal team AT Lab"

if [ "$(id -u)" -ne 0 ]
then echo "Lanciare questo script come sudo ./$0"
    exit
else
    if [ -e retrogame ]
    then
        echo "Copio retrogame in .bin..."
        mkdir -p /storage/.bin
	cp retrogame /storage/.bin/retrogame
	chmod u+x /storage/.bin/retrogame
    else
        echo "File retrograme non trovato"
        exit
    fi

    if [ -e retrogame.cfg ]
    then
        echo "Copio retrogame.cfg in .bin..."
        cp retrogame.cfg /storage/.bin/retrogame.cfg
    else
        echo "File retrograme.cfg non trovato"
        exit
    fi

    if [ -e retrogame.service ]
    then
        echo "Copio retrogame.service..."
        cp retrogame.service /storage/.config/system.d/retrogame.service
	systemctl enable retrogame.service
	systemctl start retrogame.service
    else
        echo "File retrograme.service non trovato"
        exit
    fi

    echo "SUBSYSTEM==\"input\", ATTRS{name}==\"retrogame\", ENV{ID_INPUT_KEYBOARD}=\"1\"" >> /etc/udev/rules.d/10-retrogame.rules
    echo "Imposto l'ora italiana..."
    echo "TIMEZONE=Europe/Rome" > /storage/.cache/timezone
    
    echo "Riavvare la macchina? (y/n)? "
    read answer
    if [ "$answer" != "${answer#[Yy]}" ] ;then
    	echo "Riavvio..."
	systemctl reboot
    else
    	echo "Per testare al meglio se tutto funziona meglio riavviare la macchina."
    fi

fi

