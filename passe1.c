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

    if(node->nature == NODE_IDENT){
      node->offset = env_add_element(node->ident,node,4);
      node->decl_node = get_decl_node(node->ident);
      //printf("decl_node ident : %s\n", node->decl_node->ident);
      //if(node->decl_node == NULL) //printf("NULL\n");
      //printf("%s   ligne : %d  ident : %s\n",node_nature2string(node->nature), node->lineno, node->ident);
    }
    ////printf("feuille : %s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    return;
  }

  // Stockage dans temp
  temp = node->opr;

  ////printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);

  // Si on tombe sur un noeud DECLS alors on leve un flag pour donner le type
  // des declarations d'apres

  node_decl_type(node);

  if(node->nature == NODE_PROGRAM && node->opr[0] != NULL){
  //if(node->nature == NODE_PROGRAM){
    //printf("push_global_context()\n");
    push_global_context();
  }

  if(node->nature == NODE_BLOCK && node->opr[0] != NULL){
    //printf("push_context()\n");
    //printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    push_context();
  }

  if(node->nature == NODE_FUNC){
    //printf("reset_env_current_offset()\n");
    reset_env_current_offset();
  }

  parcours_arbre(node->opr[0]);

  // Selon le nombre d'operateur on va parcourir plus ou moins de branches
  for(int i = 1; i<node->nops; ++i){
    ++node->opr;
    parcours_arbre(node->opr[0]);
    }

  // On retablie la valeur de node->opr
  node->opr = temp;

  // Met a jour les noeuds AFFECT
  node_affect_type(node);

  if(node->nature == NODE_BLOCK && node->opr[0] != NULL){
    //printf("pop_context()\n");
    //printf("%s   ligne : %d\n",node_nature2string(node->nature), node->lineno);
    pop_context();
  }

  if(node->nature == NODE_PROGRAM && node->opr[0] != NULL){
  //if(node->nature == NODE_PROGRAM){
    //printf("pop_global_context()\n");
    pop_context();
  }
}


void node_decl_type(node_t node){
  if(node->nature == NODE_DECLS && node->opr[0]->nature == NODE_TYPE){
    if(node->opr[0]->type == TYPE_INT) indent_type_flag = 1;
    if(node->opr[0]->type == TYPE_BOOL) indent_type_flag = 2;
  }
}

void node_affect_type(node_t node){
  if(node->nature == NODE_AFFECT && node->opr[0]->nature == NODE_IDENT){
    node->type = node->opr[0]->type;
  }
}
