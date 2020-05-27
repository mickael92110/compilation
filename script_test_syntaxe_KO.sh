make realclean
make
echo
cp ./minicc ./Tests/Syntaxe/KO/
cd Tests/Syntaxe/KO/
list=`ls *.c`
variable="true"

for i in $list
do
  echo Nom fichier : $i :
  ./minicc -s $i
  temp=$?
  echo return  : $temp
  if [ $temp = 0 ]
  then
    variable="false"
  fi
  echo
done

if [ $variable = "true" ]
then
  echo Fin script test syntax KO
else
  echo Erreur : bonne syntaxe détecté
  rm *.dot
fi

rm minicc
