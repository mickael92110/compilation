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
void node_decl_type(node_t node);
void node_affect_type(node_t node);

#endif
