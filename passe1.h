#ifndef _PASSE1_H_
#define _PASSE1_H_

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#include "common.h"
#include "defs.h"


void passe1(node_t root);
void parcours_arbre(node_t node);
void condition_parcours(node_t node);
void condition_feuille(node_t node);
void condition_fin_arbre(node_t node);

#endif
