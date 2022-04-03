#!/bin/bash
#exercici 10 esborraUsuaris.sh
#Pol Sanz
#

clear

#demanem i guardem en la variable qt els usuaris que es volen crear
echo "Usuaris que vols esborrar entre 1 i 100: "
read qt
#si no esta dintre de 1 i 100 salta el missatge d'error
if [[ $qt -lt 1 ]] || [[ $qt -gt 100 ]]
then
	echo "error: s'han de esborrar usuaris entre el numero 1 i 100."
	exit 1
fi

#demanen la uid inicial
echo "Valor inicial UID (5000 o més gran): "
read vinic
vinic=$((vinic-1))
#si no es mes gran o igual que 5000 salta missatge d'error
if (( $vinic < 4999 ))
then
	echo "error: UID té que ser igual o més gran que 5000."
	exit 2
fi

echo "Password admin ldap: "
read -s ctsAdm

#esborrem el fitxer nousUsuaris.ldif
sudo rm esborraUsuaris.ldif

#creem el fitxer nous.Usuaris.ldif nou
sudo touch esborraUsuaris.ldif

NumUsr=$vinic

for (( i=1; i<=$qt; i++ ))
do
	NumUsr=$((vinic+i))
	idUsr=usr$NumUsr
	echo "dn: uid=$idUsr,cn=UsuarisDomini,ou=UsuarisGrups,dc=fjeclot,dc=net" > esborraUsuaris.ldif
	echo "changetype: delete" >> esborraUsuaris.ldif
	echo "" >> esborraUsuaris.ldif
	NumUsr=$(( $NumUsr + 1 ))

	ldapmodify -h localhost -x -D "cn=admin,dc=fjeclot,dc=net" -w "$ctsAdm" -f esborraUsuaris.ldif
	
	if (( $? != 0 ))
	then
		echo "Error: Contrasenya incorrecte o usuari no existeix"
		exit 3
	fi


done

echo "Usuaris esborrats correctament!!!"

exit 0
