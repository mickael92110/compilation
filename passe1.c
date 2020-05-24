#include "passe1.h"

void passe1(node_t root){
  printf("J'existe\n");
  parcours_arbre(root);
}


void parcours_arbre(node_t node){
  node_t * temp;

  if(node == NULL){
    printf("NULL\n");
    return;
  }

  if(node->opr == NULL){
    printf("feuille :%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    return;
  }

  if(node->opr[0] != NULL){
    //printf("here\n");
    temp = node->opr;
  }

  printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
  //node_t temp = node->opr[0];

  parcours_arbre(node->opr[0]);
  for(int i = 1; i<node->nops; ++i){
    ++node->opr;
    parcours_arbre(node->opr[0]);
    }


  node->opr = temp;

}
