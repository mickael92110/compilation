
#include "env.h"

env_t env;
int32_t current_offset;

void push_global_context() {
    env = malloc(sizeof(env_s));
    env->context = create_context();
}
void push_context() {
    context_t bloc = create_context();
    env->next = env;
    env->context = bloc;
}

void pop_context() {
    free_context(env->context);
    env = env->next;
}
void * get_decl_node(char * ident) {
  noeud_t donnee;
  env_t e = env;
//On suppose que l'identifiant existe dans au moins 1 contexte
//Tant qu'on a pas trouvé l'identifiant donc tant que donnee == NULL
  do{
    donnee = get_data(e->context, ident);
    e = e->next;

    }while(donnee == NULL);

  return donnee;
}


//Je ne suis pas du tout sure pour les retours de cette fonction j'ai pas comprisexactement quelle valeur il fallait retourner
int32_t env_add_element(char * ident, void * node, int32_t size){
    //On ajoute l'association ident nodedans le context courant
    //Si jamais l'association existe déja on retourne négatif
    if(context_add_element(env->context, ident, node) == 0) {
        return -1;
    }
    //Si jamais l'association n'existe pas on l'ajouote, on met à jour l'offet courant et on retrourn 0 ou positif
    //current_offset += size;
    return 0;
}
void reset_env_current_offset() {
    current_offset = 0;
}
int32_t get_env_current_offset(){
    return current_offset;
}
//int32_t add_string(char * str);
//int32_t get_global_strings_number();
//char * get_global_string(int32_t index);
//void free_global_strings();
