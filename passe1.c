#include "passe1.h"

int indent_type_flag = 0;
int func_main_flag = 0;


void passe1(node_t root){
  parcours_arbre(root);
  root->opr[1]->offset = get_env_current_offset();
  root->opr[1]-> stack_size =  get_env_current_offset();
}


// Cette fonction parcours l'arbre de maniere recursive
void parcours_arbre(node_t node){
  // On stock dans la variable temp, node->opr pour pouvoir retablir l'adresse original apres
  node_t * temp;

  if(node == NULL) return;

  // Si on atteint l'extremite d'une branche on remonte
  if(node->opr == NULL){
    condition_feuille(node);
    return;
  }

  // Stockage dans temp
  temp = node->opr;

  condition_parcours(node);

  parcours_arbre(node->opr[0]);

  // Selon le nombre d'operateur on va parcourir plus ou moins de branches
  for(int i = 1; i<node->nops; ++i){
    ++node->opr;
    parcours_arbre(node->opr[0]);
    }

  // On retablie la valeur de node->opr
  node->opr = temp;

  condition_fin_arbre(node);
}


void condition_parcours(node_t node){
  // Si on tombe sur un noeud DECLS alors on leve un flag pour donner le type
  // des declarations d'apres
  if(node->nature == NODE_DECLS && node->opr[0]->nature == NODE_TYPE){
    if(node->opr[0]->type == TYPE_INT) indent_type_flag = 1;
    if(node->opr[0]->type == TYPE_BOOL) indent_type_flag = 2;
  }

  if(node->nature == NODE_PROGRAM && node->opr[0] != NULL){
  //if(node->nature == NODE_PROGRAM){
    //printf("push_global_context()\n");
    push_global_context();
  }

  if(node->nature == NODE_BLOCK && node->opr[0] != NULL){
    push_context();
  }

  if(node->nature == NODE_FUNC){
    func_main_flag = 1;
    reset_env_current_offset();
  }
}

void condition_feuille(node_t node){
  // Si il s'agit d'un noeud nature alors on met a jour son type
  if(indent_type_flag && node->nature == NODE_IDENT ){
    if(indent_type_flag == 1) node->type = TYPE_INT;
    if(indent_type_flag == 2) node->type = TYPE_BOOL;
  }

  if(node->nature == NODE_IDENT){

    node->decl_node = get_decl_node(node->ident);

    if(node->decl_node==NULL && func_main_flag==0){
      node->offset = env_add_element(node->ident,node,4);
    }
    func_main_flag = 0;
  }
}

void condition_fin_arbre(node_t node){
  // Met a jour les noeuds AFFECT
  if(node->nature == NODE_AFFECT && node->opr[0]->nature == NODE_IDENT){
    node->type = node->opr[0]->type;
  }

  if(node->nature == NODE_BLOCK && node->opr[0] != NULL){
    pop_context();
  }

  if(node->nature == NODE_PROGRAM && node->opr[0] != NULL){
    pop_context();
  }
}
