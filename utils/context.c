#include "context.h"

context_t create_context(){
  context_t out = calloc(1,sizeof(context_s));
  out->root = calloc(1,sizeof(noeud_s));

  return out;
}

bool context_add_element(context_t context, char * idf, void * data){

  noeud_t noeud = context->root;
  int indice;

  // On parcourt la liste tant que idf n'est pas egale au caractere de fin
  do{

      indice = get_indice(idf[0]);

      // On regarde la premiere lettre de idf
      // si on a pas alloue de l'espace pour cette lettre on alloue de l'espace

      if(noeud->suite_idf[indice] == NULL)
      {
        noeud->suite_idf[indice] = calloc(1,sizeof(noeud_s));
        noeud->suite_idf[indice]->lettre = idf[0];
        noeud->suite_idf[indice]->data = NULL;
      }

      //On passe au noeuds suivant (le premier noeud ne contient pas d'attribu lettre)
      noeud = noeud->suite_idf[indice];
      ++idf;

  }while(idf[0] != '\0');

  //Si le mot existe deja dans ce contexte alors on return false
  if(noeud->idf_existant == true){
    printf("erreur IDF déja existant\n");
    return false;
  }
  //Sinon on afficte data et termine le mot en mettant idf_existant a true
  else
  {
    noeud->idf_existant = true;
    noeud->data = data;
  }

  return true;
}


void * get_data(context_t context, char * idf){
  noeud_t noeud = context->root;
  int indice;

  //On va a la derniere lettre pour avoir data
  while(idf[0] != '\0'){
    indice = get_indice(idf[0]);
    //Si jamais l'idf n'existe pas dans ce contexte on retourn null
    if(noeud->suite_idf[indice] == NULL)
    {
     return NULL;
    }
    printf("lettre : %c\n",noeud->suite_idf[indice]->lettre);
    noeud = noeud->suite_idf[indice];
    ++idf;
  }
    return noeud->data;
}

void free_context(context_t context){
  for(int i = 0; i < NB_ELEM_ALPHABET ; ++i){
    if(context->root->suite_idf[i] != NULL){
      free_noeud(context->root->suite_idf[i]);
    }
  }
  free(context->root);
  free(context);
}


//fonction recursive qui parcourt tous les noeuds
void free_noeud(noeud_t noeud){
  for(int i = 0; i < NB_ELEM_ALPHABET ; ++i){
    if(noeud->suite_idf[i] != NULL){
      free_noeud(noeud->suite_idf[i]);
    }
  }
  free(noeud);
}

//Fonction qui renvoie l'indice d'une lettre entre 0 et 63
int get_indice(char str){

  if(str >= 'a' && str <= 'z' ){
    //printf("indice : %d\n", str-'a');
    return  str -'a';
  }

  if(str >= 'A' && str <= 'Z' ){
    //printf("indice : %d\n", str-'A' + 26);
    return str -'A' + 26;
  }

  if(str >= '0' && str <= '9' ){
    //printf("indice : %d\n", str-'0' + 52);
    return str -'0' + 52;
  }

  if(str == '_' ){
    //printf("indice : 63\n");
    return 63;
  }

  else{
    printf("erreur indice\n");
    return 0;
  }
}
