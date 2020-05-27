
#include "env.h"
#include <string.h>


env_t env_courant;
int32_t offset_courant = 0;
char ** liste_chaine = NULL;
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
  if(add){
    offset_courant += size;
    return size;
  }
  else{
    return -1;
  }
}

void * get_decl_node(char * ident) {
  void * donnee = NULL;
  env_t e = env_courant;
  //On suppose que l'identifiant existe dans au moins 1 contexte
//Tant qu'on a pas trouvé l'identifiant donc tant que donnee == NULL
  do{

    donnee = get_data(e->context, ident);
    //printf("valeur1: %d\n", *((int*)donnee));
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
  printf("ajout de %s\n", str);
  int32_t nb_chaine = get_global_strings_number();
  size_t taille = strlen(str) +1;

  //SI c'est la première fois qu'on ajoute une chaine on alloue de la mémoire poir liste_chaine
  if (liste_chaine == NULL) liste_chaine = malloc(sizeof(char));
  //On alloue de la mémoire pour la chaine
  liste_chaine[nb_chaine] = malloc(taille * sizeof(char));
  strcpy(liste_chaine[nb_chaine], str);
  liste_chaine[nb_chaine +1] = NULL;
  offset_courant = offset_courant + taille *4;
  return offset_courant;

}
int32_t get_global_strings_number(){
  int i = 0;
  int res = 0;
  if (liste_chaine == NULL) return 0;
  while(liste_chaine[i] != NULL ) {
    //printf("liste chaine : %s\n", liste_chaine[i]);
    res = res +1;
    i = i +1;
  }

  return res;

}
char * get_global_string(int32_t index){
 return liste_chaine[index];
}
void free_global_strings()
{
  int i = 0;
  while(liste_chaine[i] != NULL ) {
    printf("free chaine %s\n",liste_chaine[i] );
    free(liste_chaine[i]);
    i++;
  }
  free(liste_chaine);
}
