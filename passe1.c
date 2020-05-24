#include "passe1.h"

int indent_type_flag = 0;

void passe1(node_t root){
  parcours_arbre(root);
}



// Cette fonction parcours l'arbre de maniere recursive
void parcours_arbre(node_t node){
  // On stock dans la variable temp, node->opr pour pouvoir retablir l'adresse original apres
  node_t * temp;

  if(node == NULL) return;

  // Si on atteint l'extremite d'une branche on remonte
  if(node->opr == NULL){
    // Si il s'agit d'un noeud nature alors on met a jour son type
    if(indent_type_flag && node->nature == NODE_IDENT ){
      if(indent_type_flag == 1) node->type = TYPE_INT;
      if(indent_type_flag == 2) node->type = TYPE_BOOL;
    }
    //printf("feuille : %s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    return;
  }

  // Stockage dans temp
  temp = node->opr;

  //printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);

  // Si on tombe sur un noeud DECLS alors on leve un flag pour donner le type
  // des declarations d'apres
  if(node->nature == NODE_DECLS && node->opr[0]->nature == NODE_TYPE){
    if(node->opr[0]->type == TYPE_INT) indent_type_flag = 1;
    if(node->opr[0]->type == TYPE_BOOL) indent_type_flag = 2;
  }

  parcours_arbre(node->opr[0]);

  // Selon le nombre d'operateur on va parcourir plus ou moins de branches
  for(int i = 1; i<node->nops; ++i){
    ++node->opr;
    parcours_arbre(node->opr[0]);
    }

  // On retablie la valeur de node->opr
  node->opr = temp;

  // normalement deuxieme condition toujours vrai
  if(node->nature == NODE_AFFECT && node->opr[0]->nature == NODE_IDENT){
    //printf("flag up\n");
    //printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    //printf("type : %s   ligne : %d\n",node_type2string(node->opr[0]->type), node->lineno);
    node->type = node->opr[0]->type;
  }
}
