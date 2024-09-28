%{
#include <stdio.h>
#include "y.tab.h"

%}

%option
/* Token codes */
ASSIGN_OP "=="
EQU_OP "="
INEQU_OP "!="
GREATER_EX ">"
SMALLER_EX "<"
ADD_OP "$"
SUB_OP "#"
MULT_OP "*"
DIV_OP "/"
MOD_OP "/&"
EXP_OP "^"
LEFT_PAREN "("
RIGHT_PAREN ")"
LEFT_BRA "{"
RIGHT_BRA "}"
LEFT_SQBRA "["
RIGHT_SQBRA "]"
SC ";"
NL "\n"
QUO "\""
MLCO "<<"
MLCC ">>"
COMMA ","
EXC_MARK "!"
OR_OP   "|"
AND_OP  "&"
%%

"\""[^"\""]*"\""  { return STRING;}
"pint"                  { return INT_TYPE;}
"cint"                  { return CONSTANT_INTEGER;}
"pin"                   { return INPUT;}
"pout"                  { return OUTPUT;}
"wloop"                 { return WHILE_LOOP;}
"roll"                  { return FOR_LOOP;}
"fun"                   { return FUNCTION;}
"pro"                   { return IF;}
"pros"                  {return ELSE_IF;}
"con"                   { return ELSE;}
"return"                {return RETURN;}
{EQU_OP}         { return EQU_OP;}
{INEQU_OP}       { return INEQU_OP;}
{SMALLER_EX}     { return SMALLER_EX;}
{GREATER_EX}     { return GREATER_EX;}
{ADD_OP}        { return ADD_OP;}
{SUB_OP}        { return SUB_OP;}
{MULT_OP}       { return MULT_OP;}
{DIV_OP}        { return DIV_OP;}
{RIGHT_PAREN}   { return RIGHT_PAREN;}
{LEFT_PAREN}    { return LEFT_PAREN;}
{LEFT_BRA}      { return LEFT_BRA;}
{RIGHT_BRA}     { return RIGHT_BRA;}
{ASSIGN_OP}     { return ASSIGN_OP;}
{SC}            { return SC;}
{EXP_OP}        { return EXP_OP;}
{MOD_OP}        { return MOD_OP;}
{LEFT_SQBRA}    { return LEFT_SQBRA;}
{RIGHT_SQBRA}   {return RIGHT_SQBRA;}
{QUO}           {return QUO;}
{COMMA}         {return COMMA;}
{EXC_MARK}      {return EXC_MARK;}
{OR_OP}         {return OR_OP;}
{AND_OP}        {return AND_OP;}
\<\>.+?\n               {return COMMENT;}
{MLCO}[^>>]*{MLCC}      {return ML_COMMENT; }
1               { return TRUE;}
0               { return FALSE;}
[a-zA-Z_][a-zA-Z0-9_]*  { return IDENTIFIER;}
[-+]?[0-9]+             { return INTEGER;}
{NL}           { extern int lineno; lineno++;}
[ \n\t]                 ;
""                      {}
.                       {return(yytext[0]); /*printf("Warning: Unrecognized character '%c'\n", yytext[0]); */ }

%%
int yywrap(){return 1;}