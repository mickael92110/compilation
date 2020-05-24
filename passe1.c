#include "passe1.h"

void passe1(node_t root){
  parcours_arbre(root);
}



// Cette fonction parcours l'arbre de maniere recursive
void parcours_arbre(node_t node){
  // On stock dans la variable temp, node->opr pour pouvoir retablir l'adresse original apres
  node_t * temp;

  if(node == NULL){
    printf("feuille NULL\n");
    return;
  }

  // Si on atteint l'extremite d'une branche on remonte
  if(node->opr == NULL){
    printf("feuille : %s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    return;
  }

  // Stockage dans temp
  temp = node->opr;

  printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);

  parcours_arbre(node->opr[0]);

  // Selon le nombre d'operateur on va parcourir plus ou moins de branches
  for(int i = 1; i<node->nops; ++i){
    ++node->opr;
    parcours_arbre(node->opr[0]);
    }

  // On retablie la valeur de node->opr
  node->opr = temp;
}
