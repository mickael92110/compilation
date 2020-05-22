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
SIGNE           [+|-]?
ENTIER          {SIGNE}{CHIFFRE}*
CHAINE          \"[^"]*\"
COMMENTAIRE     \/\/([^\n])*
ESPACE          [ \t\n]

%%

"void" {
                //printf("TOK_VOID\n");
                return TOK_VOID;
}

"int" {
                //printf("TOK_INT\n");
                return TOK_INT;
}

"=" {
                //printf("TOK_AFFECT\n");
                return TOK_AFFECT;
}
"==" {
                //printf("TOK_EQ\n");
                return TOK_EQ;
}

";" {
                //printf("TOK_SEMICOL\n");
                return TOK_SEMICOL;
}

")" {
                //printf("TOK_RPAR\n");
                return TOK_RPAR;
}


"(" {
                //printf("TOK_LPAR\n");
                return TOK_LPAR;
}
"{" {
                //printf("TOK_LACC\n");
                return TOK_LACC;
}

"}" {
                //printf("TOK_RACC\n");
                return TOK_RACC;
}

"," {
                //printf("TOK_COMMA\n");
                return TOK_COMMA;
}

"for" {
                //printf("TOK_FOR\n");
                return TOK_FOR;
}

"<" {
                //printf("TOK_LT\n");
                return TOK_LT;
}
">" {
                //printf("TOK_GT\n");
                return TOK_GT;
}
"<=" {
                //printf("TOK_LE\n");
                return TOK_LE;
}
">=" {
                //printf("TOK_GE\n");
                return TOK_GE;
}
"!=" {
                //printf("TOK_NE\n");
                return TOK_NE;
}

"+" {
                //printf("TOK_PLUS\n");
                return TOK_PLUS;
}
"-" {
                //printf("TOK_MINUS\n");
                return TOK_MINUS;
}

"*" {
                //printf("TOK_MUL\n");
                return TOK_MUL;
}

"/" {
                //printf("TOK_DIV\n");
                return TOK_DIV;
}

"%" {
                //printf("TOK_MOD\n");
                return TOK_MOD;
}

"print" {
                //printf("TOK_PRINT\n");
                return TOK_PRINT;
}

"bool" {
                //printf("TOK_BOOL\n");
                return TOK_BOOL;
}
"true" {
                //printf("TOK_TRUE\n");
                return TOK_TRUE;
}

"false" {
                //printf("TOK_FALSE\n");
                return TOK_FALSE;
}
"if" {
                //printf("TOK_IF\n");
                return TOK_IF;
}
"else" {
                //printf("TOK_ELSE\n");
                return TOK_ELSE;
}

"while" {
                //printf("TOK_WHILE\n");
                return TOK_WHILE;
}
"!" {
                //printf("TOK_NOT\n");
                return TOK_NOT;
}

"~" {
                //printf("TOK_BNOT\n");
                return TOK_BNOT;
}

"&" {
                //printf("TOK_BAND\n");
                return TOK_BAND;
}

"|" {
                //printf("TOK_BOR\n");
                return TOK_BOR;
}
"&&" {
                //printf("TOK_AND\n");
                return TOK_AND;
}
"||" {
                //printf("TOK_OR\n");
                return TOK_OR;
}

"do" {
                //printf("TOK_DO\n");
                return TOK_DO;
}

{IDF} {
                yylval.strval = strdup(yytext);
                //printf("TOK_IDF str = %s\n", yytext );
                //printf("TOK_IDF\n");
                return TOK_IDENT;
}

{ENTIER} {
                /* A completer : affecter yylval.intval et faire des verifications */
                yylval.intval =(int32_t)atoi(yytext);
                //printf("TOK_INTVAL val = %d\n", atoi(yytext) );
                return TOK_INTVAL;
}

{CHAINE} {
                /* A completer : affecter yylval.strval */
                yylval.strval = strdup(yytext);
                //printf("TOK_STRING str = %s\n", yytext );
                return TOK_STRING;
}

{COMMENTAIRE} {
                //printf("Commentaire str = %s\n", yytext );
}

[ \t\n]+


{ENTIER}{CHAINE} {
                fprintf(stderr, "Error line %d: Lexical error (entier)(chaine)\n", yylineno);
                exit(1);
}

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
    dump_tree(program_root, "testy");
    //analyse_tree(program_root);
    yylex_destroy();

    return 0;
}
