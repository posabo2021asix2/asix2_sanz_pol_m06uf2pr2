#!/bin/bash
#exercici 3 mltpusr.sh
#Pol Sanz
#
clear

#amb aquest if només l'usuari root pot executar l'arxiu
if (($EUID != 0))
then
	echo "Només es pot executar amb permisos de root"
	exit 1
fi

#mirem si esta el pwgen instal·lat i si no esta s'isntal·la
echo "instal·lant pwgen"
apt-get install pwgen
aptitude search pwgen

if [[$? == 1]]
then aptitude install pwgen
fi

#demanem el numero d'usuaris a crear entre 1 i 30
echo "dona el numero d'usuaris que vols crear: "
read num
if (( num > 30 )) && (( $num < 1 ))
then
	echo "error: s'han de crear usuaris entre el numero 1 i 30."
	exit 1
fi

#demanen el nom base pels usuaris
echo "dona un nom base per els usuaris: "
read nom

#demanem la UID inicial
echo "dona UID inicial: "
read uid

#es crea el fitxer d'usuaris
if [[ $? -ne 0 ]]
then
echo "Error al crear el fitxer d'usuaris i contrasenyes"
exit 3
fi

echo "Format de la llista: Nom d'usuari Contrasenya" >> /root/$nom

#creació dels usuaris
for (( n=1; n<=$num; n++ ))
do

	pass=$(pwgen 10 1) #genera 1 password de 10 xifres
	nom_usr=$nom$n.clot
	echo "$nom  $pass" >> /root/$nom
	useradd $nom$n.clot -u $uid -g users -d /home/$nom$n.clot -m -s /bin/bash -p $(mkpasswd $pass)
	if (( $? != 0 ))
	then
		echo "Error al crear els usuaris."
		exit 2
	fi
	uid=$(( $uid + 1 ))   
done 

echo "script executat correctament."

exit 0
