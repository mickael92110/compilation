
#include "env.h"

env_t env_courant;
int32_t offset_courant = 0;
int32_t offset_data = 0;y
// Y'aura forcement deux offset : un pour la pile et l'autre pour le .data
// Pas forcement d'apres le sujet en faite

void push_global_context(){
  env_courant = calloc(1,sizeof(env_s));
  env_courant->context = create_context();
  printf("push_global_context\n");
}

void push_context(){
  env_t new_env = calloc(1,sizeof(env_s));
  new_env->next = env_courant;
  new_env->context = create_context();
  env_courant = new_env;
  printf("push_context\n");

}
void pop_context(){
  env_t temp = env_courant;
  free_context(env_courant->context);
  env_courant = env_courant->next;
  free(temp);
  printf("pop_context\n");
}

// Ajouter fonctionnalite de regarder dans les autres contextes
int32_t env_add_element(char * ident, void * node, int32_t size){
  bool add = context_add_element(env_courant->context, ident, node);
  printf("Retour de add : %d\n", add);
  if(add){
    offset_courant += size;
    return size;
  }
  else{
    return -1;
  }
}

/*void * get_decl_node(char * ident){
  void * node = get_data(env_courant->context, ident);
  return node;
}*/

void * get_decl_node(char * ident) {
  void * donnee;
  env_t e = env_courant;
//On suppose que l'identifiant existe dans au moins 1 contexte
//Tant qu'on a pas trouvé l'identifiant donc tant que donnee == NULL
  do{
    donnee = get_data(e->context, ident);
    e = e->next;
    }while(donnee == NULL);

  return donnee;
}

void reset_env_current_offset(){
  offset_courant = 0;
}

int32_t get_env_current_offset(){
  return offset_courant;
}


// ajouter a la fin du global context
int32_t add_string(char * str){
  offset_data += 4*length(str);
  return offset_data ;

}
int32_t get_global_strings_number(){

  return 0;

}
char * get_global_string(int32_t index){
 return NULL;
}
void free_global_strings()
{

}
