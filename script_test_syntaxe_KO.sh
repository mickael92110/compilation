cp ./minicc ./Tests/Syntaxe/KO/
cd Tests/Syntaxe/KO/
list=`ls *.c`
for i in $list
do
  ./minicc -s $i
  echo $?
done
rm minicc 
echo fin script test
