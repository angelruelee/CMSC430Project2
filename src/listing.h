/* CMSC 430: Compiler Theory and Design */
/* Name: Angel Lee */
/* Project 2* /
/* Date: Oct 31, 2021*/
// This file contains the function prototypes for the functions that produce the // compilation listing

enum ErrorCategories {LEXICAL, SYNTAX, GENERAL_SEMANTIC, DUPLICATE_IDENTIFIER,
	UNDECLARED};

void firstLine();
void nextLine();
int lastLine();
void appendError(ErrorCategories errorCategory, string message);

