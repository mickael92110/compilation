make realclean
make
echo
cp ./minicc ./Tests/Syntaxe/KO/
cd Tests/Syntaxe/KO/
list=`ls *.c`
for i in $list
do
  echo Nom fichier : $i :
  ./minicc -s $i
  echo return  : $?
  echo
done
rm minicc
echo Fin script test syntax KO
