%{
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

#include "defs.h"
#include "common.h"

#include "y.tab.h"

void yyerror(char *);
int yyparse(node_t * program_root);
int fileno(FILE * stream);
void analyse_tree(node_t root);


char * infile = NULL;
char * outfile = NULL;
bool stop_after_syntax = false;
bool stop_after_verif = false;
/* A completer */

#if YYDEBUG
extern int yydebug;
#endif


%}

%option yylineno

LETTRE          [a-zA-Z]
/* A completer ; fausses definitions pour que lex ne fasse pas d'erreur */
CHIFFRE         [0-9]
IDF             {LETTRE}({LETTRE}|{CHIFFRE}|'_')*
CHIFFRE_NON_NUL [1-9]
ENTIER_DEC      '0'|{CHIFFRE_NON_NUL}{CHIFFRE}*
SIGNE           [-]?
ENTIER          {SIGNE}{ENTIER_DEC}
CHAINE          {LETTRE}+
COMMENTAIRE     A
ESPACE          [ \t\n]

%%

"void" {
                printf("TOK_VOID\n");
                return TOK_VOID;
}

"int" {
                printf("TOK_INT\n");
                return TOK_INT;
}

"=" {
                printf("TOK_AFFECT\n");
                return TOK_AFFECT;
}

";" {
                printf("SEMI_COL\n");
                return SEMI_COL;
}

"(" {
                printf("TOK_RPAR\n");
                return TOK_RPAR;
}


")" {
                printf("TOK_LPAR\n");
                return TOK_LPAR;
}
"{" {
                printf("TOK_LACC\n");
                return TOK_LACC;
}

"}" {
                printf("TOK_RACC\n");
                return TOK_RACC;
}

"," {
                printf("TOK_COMMA\n");
                return TOK_COMMA;
}

"for" {
                printf("TOK_FOR\n");
                return TOK_FOR;
}

"<" {
                printf("TOK_LT\n");
                return TOK_LT;
}

"GT" {
                printf("TOK_GT\n");
                return TOK_GT;
}

"+" {
                printf("TOK_PLUS\n");
                return TOK_PLUS;
}
"-" {
                printf("TOK_MINUS\n");
                return TOK_MINUS;
}

"*" {
                printf("TOK_MUL\n");
                return TOK_MUL;
}

"/" {
                printf("TOK_DIV\n");
                return TOK_DIV;
}

"%" {
                printf("TOK_MOD\n");
                return TOK_MOD;
}

"print" {
                printf("TOK_PRINT\n");
                return TOK_PRINT;
}

"bool" {
                printf("TOK_BOOL\n");
                return TOK_BOOL;
}
"true" {
                printf("TOK_TRUE\n");
                return TOK_TRUE;
}

"false" {
                printf("TOK_FALSE\n");
                return TOK_FALSE;
}
"if" {
                printf("TOK_IF\n");
                return TOK_IF;
}
"else" {
                printf("TOK_ELSE\n");
                return TOK_ELSE;
}

"while" {
                printf("TOK_WHILE\n");
                return TOK_WHILE;
}



{IDF} {
                yylval.strval = strdup(yytext);
                printf("TOK_IDF\n");
                return TOK_IDENT;
}

{ENTIER} {
                /* A completer : affecter yylval.intval et faire des verifications */
                printf("TOK_INTVAL\n");
                return TOK_INTVAL;
}

{CHAINE} {
                /* A completer : affecter yylval.strval */
                return TOK_STRING;
}

{COMMENTAIRE} {
}

[ \t\n]+

. {
                fprintf(stderr, "Error line %d: Lexical error\n", yylineno);
                exit(1);
}


%%

int yywrap(void) {
    return 1;
}


int main(int argc, char ** argv) {
    /* A completer */
    node_t program_root;
    parse_args(argc, argv);
    #if YYDEBUG
    yydebug = 1;
    #endif

    yyin = fopen(infile, "r");
    yyparse(&program_root);
    fclose(yyin);
    analyse_tree(program_root);
    yylex_destroy();
    return 0;
}