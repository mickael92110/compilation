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

%type <ptr> program vardecls listdecls decls listdecl decl type maindecl
%type <ptr> listinst inst listinstnonnull block expr listparamprint paramprint ident


%%

/* Regles ici */
program         : vardecls maindecl
                {
                    $$ = make_node(NODE_PROGRAM, 2, $1, $2);
                    *program_root = $$;
                }
                | maindecl
                {
                    $$ = make_node(NODE_PROGRAM, 2, NULL, $1);
                    *program_root = $$;
                }
                ;

vardecls        : listdecls
		{
                    $$ = $1;
                }
                ;

listdecls       : decls
		{
		    $$ = $1;
		}
                | listdecls TOK_COMMA decls
		{
                    $$ = make_node(NODE_LIST,2, $1,$3);
                }
                ;

decls            : type listdecl
                {
                  printf("node_decl \n");
                    $$ = make_node(NODE_DECL,2, $1,$2);
                }
                ;

listdecl        : decl
		{
		    $$ = $1;
		}
                | listdecl TOK_COMMA decl
		{
                    $$ = make_node(NODE_LIST,2, $1,$3);
                }
                ;
decl            : ident
		{
		    $$ = $1;
		}
                | ident TOK_AFFECT expr
                {
                  printf("node_decl \n");
                    $$ = make_node(NODE_DECL,2, $1,$3);
                }
                ;

type            : TOK_INT
                {
                  printf("node_type int \n");
                    $$ = make_node(NODE_TYPE,0);
                }
                | TOK_BOOL
                {   $$ = make_node(NODE_TYPE,0);
		}
                | TOK_VOID
                {
                  printf("node_type void \n");
                    $$ = make_node(NODE_TYPE,0);
                }
                ;






maindecl        : type ident TOK_LPAR TOK_RPAR block
                {
                  printf("node_maindecl main \n");
                    $$ = make_node(NODE_FUNC,2,$1,$2,$5);
                }
                ;


listinst        : listinstnonnull
                {   $$ = $1; }
                |
                { $$ = NULL; }
                ;

listinstnonnull : inst
                | listinstnonnull inst
                ;

inst            : expr TOK_SEMICOL
                {
                  printf("node_inst inst \n");
                  $$ = $1;
                }
                | TOK_IF TOK_LPAR expr TOK_RPAR inst TOK_ELSE inst
                { $$ = make_node(NODE_IF,3,$3,$5,$7); }
                | TOK_IF TOK_LPAR expr TOK_RPAR inst %prec TOK_THEN
                { $$ = make_node(NODE_IF,2,$3,$5); }
                | TOK_WHILE TOK_LPAR expr TOK_RPAR inst
                { $$ = make_node(NODE_WHILE,2,$3,$5); }
                | TOK_FOR TOK_LPAR expr TOK_SEMICOL expr TOK_SEMICOL expr TOK_RPAR inst
                { $$ = make_node(NODE_FOR,4,$3,$5,$7,$9); }
                | TOK_DO inst TOK_WHILE TOK_LPAR expr TOK_RPAR TOK_SEMICOL
                { $$ = make_node(NODE_DOWHILE,2,$2,$5); }
                | block
                { $$ = $1; }
                /*| TOK_SEMICOL
                { $$ = $1; }*/
                | TOK_PRINT TOK_LPAR listparamprint TOK_RPAR TOK_SEMICOL
                { $$ = make_node(NODE_PRINT,1,$3); }
                ;

block           : TOK_LACC listdecl listinst TOK_RACC
                { $$ = make_node(NODE_BLOCK,2,$2,$3); }
                ;

expr            : expr TOK_MUL expr
                { $$ = make_node(NODE_MUL,2,$1,$3); }
                |expr TOK_DIV expr
                { $$ = make_node(NODE_DIV,2,$1,$3); }
                |expr TOK_PLUS expr
                { $$ = make_node(NODE_PLUS,2,$1,$3); }
                |expr TOK_MINUS expr
                { $$ = make_node(NODE_MINUS,2,$1,$3); }
                |expr TOK_MOD expr
                { $$ = make_node(NODE_MOD,2,$1,$3); }
                |expr TOK_LT expr
                { $$ = make_node(NODE_LT,2,$1,$3); }
                |expr TOK_GT expr
                { $$ = make_node(NODE_GT,2,$1,$3); }
                |TOK_MINUS expr %prec TOK_UMINUS
                { $$ = NULL; }
                |expr TOK_GE expr
                { $$ = make_node(NODE_GE,2,$1,$3); }
                |expr TOK_LE expr
                { $$ = make_node(NODE_LE,2,$1,$3); }
                |expr TOK_EQ expr
                { $$ = make_node(NODE_EQ,2,$1,$3); }
                |expr TOK_NE expr
                { $$ = make_node(NODE_NE,2,$1,$3); }
                |expr TOK_AND expr
                { $$ = make_node(NODE_AND,2,$1,$3); }
                |expr TOK_OR expr
                { $$ = make_node(NODE_OR,2,$1,$3); }
                |expr TOK_BAND expr
                { $$ = make_node(NODE_BAND,2,$1,$3); }
                |expr TOK_BOR expr
                { $$ = make_node(NODE_BOR,2,$1,$3); }
                |expr TOK_BXOR expr
                { $$ = make_node(NODE_BXOR,2,$1,$3); }
                |expr TOK_SRL expr
                { $$ = make_node(NODE_SRL,2,$1,$3); }
                |expr TOK_SRA expr
                { $$ = make_node(NODE_SRA,2,$1,$3); }
                |expr TOK_SLL expr
                { $$ = make_node(NODE_SLL,2,$1,$3); }
                |TOK_NOT expr
                { $$ = make_node(NODE_NOT,1,$2); }
                |TOK_BNOT expr
                { $$ = make_node(NODE_BNOT,1,$2); }
                |TOK_LPAR expr TOK_RPAR
                { $$ = NULL; }
                |ident TOK_AFFECT expr
                { $$ = make_node(NODE_BNOT,2,$1,$3); }
                |TOK_INTVAL
                { $$ = make_node(NODE_INTVAL,1,$1); }
                |TOK_TRUE
                { $$ = make_node(NODE_BOOLVAL,0); }
                |TOK_FALSE
                { $$ = make_node(NODE_BOOLVAL,0); }
		|TOK_STRING
                { $$ = make_node(NODE_STRINGVAL,0); }
                |ident
                { $$ = $1; }
                ;

listparamprint  : listparamprint TOK_COMMA paramprint
                { $$ = make_node(NODE_LIST,2, $1,$3); }
                | paramprint
                { $$ = $1; }
                ;

paramprint      : ident
                { $$ = $1; }
                | TOK_STRING
                { $$ = make_node(NODE_STRINGVAL,0); }
                ;

ident           : TOK_IDENT
                { $$ = make_node(NODE_IDENT,0); }
                ;
%%

/* A completer et/ou remplacer avec d'autres fonctions */
node_t make_node(node_nature nature, int nops, ...) {
    va_list ap;

    return NULL;
}



/* A completer */
void analyse_tree(node_t root) {
    if (!stop_after_syntax) {
        // Appeler la passe 1

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
