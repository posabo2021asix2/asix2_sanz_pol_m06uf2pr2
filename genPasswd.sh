#!/bin/bash
#exercici 9 genPasswd.sh
#Pol Sanz
#

clear

#demanem i guardem en la variable qt els usuaris que es volen crear
echo "Contrasenyes que vols generar entre 1 i 100: "
read qt
#si no esta dintre de 1 i 100 salta el missatge d'error
if [[ $qt -lt 1 ]] || [[ $qt -gt 100 ]]
then
	echo "error: s'han de generar contrasenyes entre el numero 1 i 100."
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
sudo rm ctsUsuaris.txt

#creem el fitxer nous.Usuaris.ldif nou
sudo touch ctsUsuaris.txt

NumUsr=$vinic

for (( i=1; i<=$qt; i++ ))
do
	NumUsr=$((vinic+i))
	idUsr=usr$NumUsr
	ctsnya=$(pwgen 10 1)
	echo "dn: uid=$idUsr,cn=UsuarisDomini,ou=UsuarisGrups,dc=fjeclot,dc=net" > ctsUsuaris.txt
	echo "$idUsr $ctsnya" >> ctsUsuaris.txt
	echo "objectClass: top" >> ctsUsuaris.txt
	echo "objectClass: person" >> ctsUsuaris.txt
	echo "objectClass: organizationalPerson" >> ctsUsuaris.txt
	echo "objectClass: inetOrgPerson" >> ctsUsuaris.txt
	echo "objectClass: posixAccount" >> ctsUsuaris.txt
	echo "objectClass: shadowAccount" >> ctsUsuaris.txt
	
	NumUsr=$(( $NumUsr + 1 ))

	ldappasswd -h localhost -x -D "cn=admin,dc=fjeclot,dc=net" -w "$ctsAdm" -s "$ctsnya" "uid=$idUsr,ou=UsuarisGrups,dc=fjeclot,dc=net"
#-w "$ctsAdm" -s "$ctsnya"
	if (( $? != 0 ))
	then
		echo "Contrasenya incorrecte o usuari no existeix"
		exit 3
	fi

done

echo "Password(s) generada correctament!!!"

exit 0
