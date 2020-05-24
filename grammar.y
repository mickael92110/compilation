%{
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdarg.h>
#include <string.h>
#include <assert.h>

#include "defs.h"
#include "common.h"
#include "mips_inst.h"
#include "passe1.h"



/* Global variables */
/* A completer */
extern bool stop_after_syntax;
extern bool stop_after_verif;
extern char * infile;
extern char * outfile;

/* prototypes */
int yylex(void);
extern int yylineno;

void yyerror(node_t * program_root, char * s);
void analyse_tree(node_t root);
node_t make_node(node_nature nature, int nops, ...);
/* A completer */

%}

%parse-param { node_t * program_root }

%union {
    int32_t intval;
    char * strval;
    node_t ptr;
};


/* Definir les token ici avec leur associativite, dans le bon ordre */
%token TOK_VOID   TOK_INT     TOK_INTVAL  TOK_BOOL  TOK_TRUE  TOK_FALSE
%token TOK_IDENT  TOK_IF      TOK_ELSE    TOK_WHILE TOK_FOR   TOK_PRINT
%token TOK_AFFECT TOK_GE      TOK_LE      TOK_GT    TOK_LT    TOK_EQ
%token TOK_NE     TOK_PLUS    TOK_MINUS   TOK_MUL   TOK_DIV   TOK_MOD
%token TOK_UMINUS TOK_SEMICOL TOK_COMMA   TOK_LPAR  TOK_RPAR  TOK_LACC
%token TOK_RACC   TOK_STRING  TOK_DO

%nonassoc TOK_THEN
%nonassoc TOK_ELSE

%right TOK_AFFECT
%left TOK_OR
%left TOK_AND
%left TOK_BOR
%left TOK_BXOR
%left TOK_BAND
%left TOK_EQ TOK_NE
%left TOK_GT TOK_LT TOK_GE TOK_LE
%left TOK_SRL TOK_SRA TOK_SLL


%left TOK_PLUS TOK_MINUS
%left TOK_MUL TOK_DIV TOK_MOD
%left TOK_UMINUS TOK_NOT TOK_BNOT

%type <intval> TOK_INTVAL
%type <strval> TOK_IDENT TOK_STRING

%type <ptr> program listdecl listdeclnonnull vardecl ident type listtypedecl decl maindecl
%type <ptr> listinst listinstnonnull inst block expr listparamprint paramprint


%%

/* Regles ici */
program         : listdeclnonnull maindecl
                {

                    $$ = make_node(NODE_PROGRAM, 2, $1, $2);
                    *program_root = $$;
                }
                | maindecl
                {

                    $$ = make_node(NODE_PROGRAM, 2, NULL, $1);
                    //$$ = make_node(NODE_PROGRAM, 1, $1);
                    *program_root = $$;
                }
                ;

listdecl        : listdeclnonnull
                { $$ = $1; }
                |
                { $$ = NULL; }
                ;

listdeclnonnull : vardecl
                {
                  $$ = $1;
                }
                | listdeclnonnull vardecl
                {
                  $$ = make_node(NODE_LIST,2, $1,$2);
                }
                ;

vardecl         : type listtypedecl TOK_SEMICOL
                {
                  $$ = make_node(NODE_DECLS,2, $1,$2);
                }
                ;

type            : TOK_INT
                {
                  $$ = make_node(NODE_TYPE,1,TYPE_INT);
                }
                | TOK_BOOL
                {
                  $$ = make_node(NODE_TYPE,1,TYPE_BOOL);
                }
                | TOK_VOID
                {
                  $$ = make_node(NODE_TYPE,1,TYPE_VOID);
                }
                ;

listtypedecl    : decl
                {
                  $$ = $1;
                }
                | listtypedecl TOK_COMMA decl
                {
                  $$ = make_node(NODE_LIST, 2, $1, $3);
                }
                ;

decl            : ident
                {
                  $$ = make_node(NODE_DECL, 2, $1, NULL);
                }
                | ident TOK_AFFECT expr
                {
                  $$ = make_node(NODE_DECL,2, $1,$3);
                }
                ;

maindecl        : type ident TOK_LPAR TOK_RPAR block
                {
                  $$ = make_node(NODE_FUNC,3,$1,$2,$5);
                }
                ;

listinst        : listinstnonnull
                {
                  $$ = $1;
                  //$$ = NULL;
                }
                |
                {
                  $$ = NULL;
                }
                ;

listinstnonnull : inst
                {
                  $$ = $1;
                }
                | listinstnonnull inst
                {
                  $$ = make_node(NODE_LIST, 2, $1, $2);
                }
                ;

inst            : expr TOK_SEMICOL
                {
                  $$ = $1;
                }
                | TOK_IF TOK_LPAR expr TOK_RPAR inst TOK_ELSE inst
                {
                  $$ = make_node(NODE_IF,3,$3,$5,$7);
                }
                | TOK_IF TOK_LPAR expr TOK_RPAR inst %prec TOK_THEN
                {
                  $$ = make_node(NODE_IF,2,$3,$5);
                }
                | TOK_WHILE TOK_LPAR expr TOK_RPAR inst
                {
                  $$ = make_node(NODE_WHILE,2,$3,$5);
                }
                | TOK_FOR TOK_LPAR expr TOK_SEMICOL expr TOK_SEMICOL expr TOK_RPAR inst
                {
                  $$ = make_node(NODE_FOR,4,$3,$5,$7,$9);
                }
                | TOK_DO inst TOK_WHILE TOK_LPAR expr TOK_RPAR TOK_SEMICOL
                {
                  $$ = make_node(NODE_DOWHILE,2,$2,$5);
                }
                | block
                {
                  $$ = $1;
                }
                | TOK_SEMICOL
                {
                  $$ = NULL;
                }
                | TOK_PRINT TOK_LPAR listparamprint TOK_RPAR TOK_SEMICOL
                {
                  $$ = make_node(NODE_PRINT,1,$3);
                }
                ;

block           : TOK_LACC listdecl listinst TOK_RACC
                {
                  $$ = make_node(NODE_BLOCK,2,$2,$3);
                }
                ;

expr            : expr TOK_MUL expr
                {
                  $$ = make_node(NODE_MUL,2,$1,$3);
                }
                |expr TOK_DIV expr
                {
                  $$ = make_node(NODE_DIV,2,$1,$3);
                }
                |expr TOK_PLUS expr
                {
                  $$ = make_node(NODE_PLUS,2,$1,$3);
                }
                |expr TOK_MINUS expr
                {
                  $$ = make_node(NODE_MINUS,2,$1,$3);
                }
                |expr TOK_MOD expr
                {
                  $$ = make_node(NODE_MOD,2,$1,$3);
                }
                |expr TOK_LT expr
                {
                  $$ = make_node(NODE_LT,2,$1,$3);
                }
                |expr TOK_GT expr
                {
                  $$ = make_node(NODE_GT,2,$1,$3);
                }
                |TOK_MINUS expr %prec TOK_UMINUS
                {
                  $$ = make_node(NODE_UMINUS,1,$2);
                }
                |expr TOK_GE expr
                {
                  $$ = make_node(NODE_GE,2,$1,$3);
                }
                |expr TOK_LE expr
                {
                  $$ = make_node(NODE_LE,2,$1,$3);
                }
                |expr TOK_EQ expr
                {
                  $$ = make_node(NODE_EQ,2,$1,$3);
                }
                |expr TOK_NE expr
                {
                  $$ = make_node(NODE_NE,2,$1,$3);
                }
                |expr TOK_AND expr
                {
                  $$ = make_node(NODE_AND,2,$1,$3);
                }
                |expr TOK_OR expr
                {
                  $$ = make_node(NODE_OR,2,$1,$3);
                }
                |expr TOK_BAND expr
                {
                  $$ = make_node(NODE_BAND,2,$1,$3);
                }
                |expr TOK_BOR expr
                {
                  $$ = make_node(NODE_BOR,2,$1,$3);
                }
                |expr TOK_BXOR expr
                {
                  $$ = make_node(NODE_BXOR,2,$1,$3);
                }
                |expr TOK_SRL expr
                {
                  $$ = make_node(NODE_SRL,2,$1,$3);
                }
                |expr TOK_SRA expr
                {
                  $$ = make_node(NODE_SRA,2,$1,$3);
                }
                |expr TOK_SLL expr
                {
                  $$ = make_node(NODE_SLL,2,$1,$3);
                }
                |TOK_NOT expr
                {
                  $$ = make_node(NODE_NOT,1,$2);
                }
                |TOK_BNOT expr
                {
                  $$ = make_node(NODE_BNOT,1,$2);
                }
                |TOK_LPAR expr TOK_RPAR
                {
                  $$ = $2;
                }
                |ident TOK_AFFECT expr
                {
                  $$ = make_node(NODE_AFFECT,2,$1,$3);
                }
                |TOK_INTVAL
                {
                  $$ = make_node(NODE_INTVAL,1,$1);
                }
                |TOK_TRUE
                {
                  $$ = make_node(NODE_BOOLVAL,1,true);
                }
                |TOK_FALSE
                {
                  $$ = make_node(NODE_BOOLVAL,1,false);
                }
                |ident
                {
                  $$ = $1;
                }
                ;

listparamprint  : listparamprint TOK_COMMA paramprint
                {
                  $$ = make_node(NODE_LIST,2, $1,$3);
                }
                | paramprint
                { $$ = $1; }
                ;

paramprint      : ident
                { $$ = $1; }
                | TOK_STRING
                {
                  $$ = make_node(NODE_STRINGVAL,1,$1);
                }
                ;

ident           : TOK_IDENT
                {
                  $$ = make_node(NODE_IDENT,1,$1);
                }
                ;
%%

/* A completer et/ou remplacer avec d'autres fonctions */
node_t make_node(node_nature nature, int nops, ...) {
    va_list ap;

    va_start(ap, nops);

    node_t n;

    // On initialise la structure a retourner
    n = malloc(sizeof(node_s));


    switch (nature){

      case NODE_PROGRAM:
      case NODE_BLOCK:
      case NODE_DECLS:
      case NODE_DECL:
      case NODE_IF:
      case NODE_WHILE:
      case NODE_FOR:
      case NODE_DOWHILE:
      case NODE_PRINT:

            n->opr = calloc(nops,sizeof(node_t));

            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = nops;
            //n->opr = NULL;
            n->decl_node = NULL;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;

            for(int i = 0; i < n->nops; ++i){
              n->opr[i] = va_arg(ap, node_t);
            }

            break;

      case NODE_TYPE:
            n->nature = nature;
            n->type = va_arg(ap,node_type);
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = 0;
            n->opr = NULL;
            n->decl_node = NULL;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;
            break;

      case NODE_IDENT:

            n->ident = calloc(100,sizeof(char*));

            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = -1;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = 0;
            n->opr = 0;
            n->decl_node = 0;
            n->ident = va_arg(ap, char*);
            n->str = NULL;
            n->node_num = 0;
            break;

      case NODE_INTVAL:

            n->nature = nature;
            n->type = TYPE_INT;
            n->value = va_arg(ap, int);
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = 0;
            n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;
            break;

      case NODE_BOOLVAL:
            n->nature = nature;
            n->type = TYPE_BOOL;
            n->value = va_arg(ap, int);
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = 0;
            n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;
            break;

      case NODE_FUNC:
            n->opr = calloc(nops,sizeof(node_t));

            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = nops;
            //n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;

            for(int i = 0; i < n->nops; ++i){
              n->opr[i] = va_arg(ap, node_t);
            }
            break;


      case NODE_LIST:

            n->opr = calloc(nops,sizeof(node_t));

            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = nops;
            //n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;

            for(int i = 0; i < n->nops; ++i){
              n->opr[i] = va_arg(ap, node_t);
            }
            break;

      case NODE_PLUS:
      case NODE_MINUS:
      case NODE_MUL:
      case NODE_DIV:
      case NODE_MOD:
      case NODE_LT:
      case NODE_GT:
      case NODE_LE:
      case NODE_GE:
      case NODE_EQ:
      case NODE_NE:
      case NODE_AND:
      case NODE_OR:
      case NODE_BAND:
      case NODE_BOR:
      case NODE_BXOR:
      case NODE_SRA:
      case NODE_SRL:
      case NODE_SLL:
      case NODE_NOT:
      case NODE_BNOT:
      case NODE_UMINUS:
      case NODE_AFFECT:
            n->opr = calloc(nops,sizeof(node_t));

            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = nops;
            //n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = NULL;
            n->node_num = 0;

            for(int i = 0; i < n->nops; ++i){
              n->opr[i] = va_arg(ap, node_t);
            }
            break;


      case NODE_STRINGVAL:
            n->nature = nature;
            n->type = 0;
            n->value = 0;
            n->offset = 0;
            n->global_decl = 0;
            n->lineno = yylineno;
            n->stack_size = 0;
            n->nops = 0;
            n->opr = 0;
            n->decl_node = 0;
            n->ident = NULL;
            n->str = va_arg(ap, char*);
            n->node_num = 0;

            break;

      default:
          printf("%s   ligne : %d\n",node_nature2string(nature), yylineno);
          break;
    }
    va_end(ap);
    return n;
}



/* A completer */
void analyse_tree(node_t root) {
    if (!stop_after_syntax) {
        // Appeler la passe 1
        passe1(root);
        if (!stop_after_verif) {
            create_program();
            // Appeler la passe 2
            dump_mips_program(outfile);
            free_program();
        }
        free_global_strings();
    }
}



void yyerror(node_t * program_root, char * s) {
    fprintf(stderr, "Error line %d: %s\n", yylineno, s);
    exit(1);
}
