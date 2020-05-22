#include "context.h"
#include "env.h"

int main(void){
  printf("Test main\n");
  context_t con = create_context();
  void * data;
  void * data2;
  int nicee = 420;
  int nice = 69;
  data = &nice;
  data2 = &nicee;
  char * idf = "abcdef";
  char * idf2 = "skdlfgbjmegglbergoa";
  bool test = context_add_element(con,idf,data);

  printf("test = %d\n", test);
  bool test2 = context_add_element(con,idf2,data2);
  printf("test2 = %d\n", test2);

  int veryNice = *((int*)get_data(con, idf));
  printf("very nice : %d\n", veryNice);

  int ultraNice = *((int*)get_data(con, idf2));
  printf("ultra nice : %d\n", ultraNice);

  free_context(con);

  // for(int i = 0; i < 63 ; ++i){
  //   printf("suite_idf[%2d] : %d\n", i, con->root->suite_idf[i] != NULL);
  //   if(con->root->suite_idf[i]){
  //     while(con->root->suite_idf[i]-)
  //   }
  // }

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
  printf("============================Test env.c=============================\n");
  push_global_context();
  /*void * data4;
  int deux = 2;
  data4 = &deux;
  char * idf4 = "lmnop";
  int32_t k = env_add_element(idf4,data4,4);
  printf("création 0 ; déja présent -1 = %d\n", k);*/
  pop_context();

  /*push_context();
  void * data3;
  void * data5;
  int un = 1;
  int trois = 3;
  data3 = &un;
  data5 = &trois;
  char * idf3 = "ghijk";
  char * idf5 = "qrstuv";
  int32_t i = env_add_element(idf3,data3,4);
  printf("création 0 ; déja présent -1 = %d\n", i);
  int32_t j = env_add_element(idf3,data3,4);
  printf("création 0 ; déja présent -1 = %d\n", j);

  int32_t h = env_add_element(idf5,data5,4);
  printf("création 0 ; déja présent -1 = %d\n", h);

  int val_deux = *((int*)get_decl_node(idf4));
  printf("val_deux : %d\n", val_deux);

  pop_context();*/

  return 0;
}
