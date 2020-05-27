make realclean
make
echo
cp ./minicc ./Tests/Syntaxe/OK/
cd Tests/Syntaxe/OK/
list=`ls *.c`
variable="true"

for i in $list
do
  echo Nom fichier : $i :
  ./minicc -s $i
  temp=$?
  echo return  : $temp
  if [ $temp = 1 ]
  then
    variable="false"
  fi
  echo
done

if [ $variable = "true" ]
then
  echo Fin script test syntax OK
else
  echo Erreur syntaxe
fi

rm minicc *.dot
