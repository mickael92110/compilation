#include "context.h"
#include "env.h"
#include <string.h>

int main(void){
  printf("================= Test context =================\n");
  context_t con = create_context();
  void * data;
  void * data2;
  void *data3;
  int val11 = 11;
  int val22 = 22;
  int val33 = 33;
  data = &val11;
  data2 = &val22;
  data3 = &val33;
  char * idf = "val11";
  char * idf2 = "val22";
  char * idf3 = "val22";

  bool test = context_add_element(con,idf,data);
  printf("retour context_add_element test1 = %d\n", test);
  bool test2 = context_add_element(con,idf2,data2);
  printf("retour context_add_element test2 = %d\n", test2);
  bool test3 = context_add_element(con,idf3,data3);
  printf("retour context_add_element test3 = %d\n", test3);

  printf("Affichage des lettres et de la valeur du test1 \n");
  int valeur11 = *((int*)get_data(con, idf));
  printf("valeur11: %d\n", valeur11);

  printf("Affichage des lettres et de la valeur du test2 \n");
  int valeur22 = *((int*)get_data(con, idf2));
  printf("valeur22 : %d\n", valeur22);

  free_context(con);


  //int indice;
  // noeud_t noeud = con->root;
  // noeud_t prec;
  //
  // while(idf[0] != '\0'){
  //   indice = get_indice(idf[0]);
  //   printf("lettre : %c\n",noeud->suite_idf[indice]->lettre);
  //   prec = noeud;
  //   noeud = noeud->suite_idf[indice];
  //   ++idf;
  // }
  //   printf("data : %d\n", *((int*)(prec->data)));
  //
  //   noeud = con->root;
  //
  //   while(idf2[0] != '\0'){
  //     indice = get_indice(idf2[0]);
  //     printf("lettre : %c\n",noeud->suite_idf[indice]->lettre);
  //     prec = noeud;
  //     noeud = noeud->suite_idf[indice];
  //     ++idf2;
  //   }
  //     printf("data : %d\n", *((int*)(prec->data)));

  //printf("nice : %d\n", *((int*)data));

  // noeud_t noeud = con->root;
  //
  //
  // //noeud = noeud->suite_idf[0];
  // printf("\n");
  // //printf("Test NULL : %d\n", noeud->suite_idf[5]==NULL);
  // printf("lettre : %c\n", noeud->suite_idf[0]->lettre);
  // printf("bool : %d\n", noeud->idf_existant);
  // noeud = noeud->suite_idf[0];
  // printf("lettre : %c\n", noeud->suite_idf[1]->lettre);
  // printf("bool : %d\n", noeud->idf_existant);
  // //printf("Test NULL : %d\n", noeud->suite_idf[5]==NULL);
  // noeud = noeud->suite_idf[1];
  // printf("lettre : %c\n", noeud->suite_idf[2]->lettre);
  // printf("bool : %d\n", noeud->idf_existant);
  // noeud = noeud->suite_idf[2];
  // printf("lettre : %c\n", noeud->suite_idf[3]->lettre);
  // printf("bool : %d\n", noeud->idf_existant);
  // noeud = noeud->suite_idf[3];
  // printf("lettre : %c\n", noeud->suite_idf[4]->lettre);
  // printf("bool : %d\n", noeud->idf_existant);



  // char * str = "ab_AB_19";
  //
  // while(str[0] != '\0'){
  //
  //   if(str[0] >= 'a' && str[0] <= 'z' ){
  //     printf("indice : %d\n", str[0]-'a');
  //   }
  //
  //   if(str[0] >= 'A' && str[0] <= 'Z' ){
  //     printf("indice : %d\n", str[0]-'A' + 26);
  //   }
  //
  //   if(str[0] >= '0' && str[0] <= '9' ){
  //     printf("indice : %d\n", str[0]-'0' + 52);
  //   }
  //
  //   if(str[0] == '_' ){
  //     printf("indice : 63\n");
  //   }
  //
  //   ++str;
  // }

  printf("================= Test env =================\n");

push_global_context();
push_context();
char * ident = "test";
char * ident2 = "test";
void * node;
void *node2;
int val44 = 44;
int val55 = 55;
node = &val44;
node2 = &val55;
int32_t size = 4;
int32_t test4 = env_add_element(ident, node, size);
printf("retour context_add_element test3 = %d\n", test4);
int32_t test5 = env_add_element(ident2, node2, size);
printf("retour context_add_element test4 = %d\n", test5);

printf("Affichage des lettres et de la valeur du test4 \n");
int valeur44 = *((int*)get_decl_node(ident));
printf("valeur44: %d\n", valeur44);

pop_context();

printf("=================test env suite============\n");
char * chaine = "hello";
printf("nb chaines: %d\n", get_global_strings_number());

int32_t t = add_string(chaine);
printf("get_global_strings_number : %d\n", get_global_strings_number());
printf("get_global_string %s\n", get_global_string(0));
printf("offset data : %d\n", t);

int32_t t2 = add_string("coucou");
printf("get_global_strings_number: %d\n", get_global_strings_number());
printf("get_global_string %s\n", get_global_string(1));
printf("offset data : %d\n", t2);
free_global_strings();
  return 0;
}
