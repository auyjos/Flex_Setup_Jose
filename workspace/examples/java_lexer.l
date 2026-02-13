/*
 * java_lexer.l
 * Lexer de Flex que reconoce:
 *   1. Identificadores válidos de Java
 *   2. Literales numéricos (enteros, flotantes, notación científica, hexadecimales)
 *   3. Operadores aritméticos, relacionales y lógicos
 *   4. Comentarios de una linea (//) y multilinea (slash-star ... star-slash)
 *   5. Cadenas literales con secuencias de escape
 */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int line = 1;
int col  = 1;

/* Macro para imprimir tokens con ubicación */
#define PRINT_TOKEN(type, value) \
    printf("Token(%-20s, '%s', line=%d, col=%d)\n", type, value, line, col)

/* Actualizar posición de columna */
#define ADV_COL() col += yyleng

%}

/* ============================================================
   Opciones de Flex
   ============================================================ */
%option noyywrap

/* ============================================================
   Definiciones con nombre (macros de patrones)
   ============================================================ */

DIGIT       [0-9]
HEX_DIGIT   [0-9a-fA-F]
LETTER      [a-zA-Z]
ID_START    ({LETTER}|_)
ID_CHAR     ({LETTER}|{DIGIT}|_)

/* ============================================================
   Sección de reglas
   ============================================================ */
%%

 /* ----- 4. Comentarios (se descartan, no generan tokens) ----- */

"//"[^\n]*              { /* Comentario de una línea: ignorar */
                          printf("  [COMMENT_SINGLE_LINE descartado] line=%d\n", line);
                          ADV_COL();
                        }

"/*"([^*]|\*+[^*/])*\*+"/"  { /* Comentario multilínea: contar saltos de línea internos */
                              char *p = yytext;
                              int len = yyleng;
                              printf("  [COMMENT_MULTI_LINE descartado] line=%d\n", line);
                              for (int i = 0; i < len; i++) {
                                  if (p[i] == '\n') { line++; col = 1; }
                                  else { col++; }
                              }
                            }

 /* ----- 5. Cadenas literales con secuencias de escape ----- */

\"([^"\\]|\\.)*\"       { PRINT_TOKEN("STRING_LITERAL", yytext); ADV_COL(); }

 /* ----- 2. Literales numéricos ----- */

0[xX]{HEX_DIGIT}+      { PRINT_TOKEN("HEX_INTEGER", yytext);          ADV_COL(); }

{DIGIT}+"."{DIGIT}*[eE][+-]?{DIGIT}+   { PRINT_TOKEN("SCIENTIFIC_FLOAT", yytext); ADV_COL(); }
{DIGIT}+[eE][+-]?{DIGIT}+              { PRINT_TOKEN("SCIENTIFIC_INT", yytext);   ADV_COL(); }

{DIGIT}+"."{DIGIT}*     { PRINT_TOKEN("FLOAT_LITERAL", yytext);       ADV_COL(); }
"."{DIGIT}+              { PRINT_TOKEN("FLOAT_LITERAL", yytext);       ADV_COL(); }

{DIGIT}+                 { PRINT_TOKEN("INTEGER_LITERAL", yytext);     ADV_COL(); }

 /* ----- 3. Operadores ----- */

 /* Relacionales (poner los de 2 caracteres antes que los de 1) */
"=="                    { PRINT_TOKEN("OP_EQUAL", yytext);             ADV_COL(); }
"!="                    { PRINT_TOKEN("OP_NOT_EQUAL", yytext);         ADV_COL(); }
"<="                    { PRINT_TOKEN("OP_LESS_EQUAL", yytext);        ADV_COL(); }
">="                    { PRINT_TOKEN("OP_GREATER_EQUAL", yytext);     ADV_COL(); }
"<"                     { PRINT_TOKEN("OP_LESS", yytext);              ADV_COL(); }
">"                     { PRINT_TOKEN("OP_GREATER", yytext);           ADV_COL(); }

 /* Lógicos */
"&&"                    { PRINT_TOKEN("OP_AND", yytext);               ADV_COL(); }
"||"                    { PRINT_TOKEN("OP_OR", yytext);                ADV_COL(); }
"!"                     { PRINT_TOKEN("OP_NOT", yytext);               ADV_COL(); }

 /* Aritméticos */
"+"                     { PRINT_TOKEN("OP_PLUS", yytext);              ADV_COL(); }
"-"                     { PRINT_TOKEN("OP_MINUS", yytext);             ADV_COL(); }
"*"                     { PRINT_TOKEN("OP_MULT", yytext);              ADV_COL(); }
"/"                     { PRINT_TOKEN("OP_DIV", yytext);               ADV_COL(); }

 /* Delimitadores comunes */
"("                     { PRINT_TOKEN("LPAREN", yytext);               ADV_COL(); }
")"                     { PRINT_TOKEN("RPAREN", yytext);               ADV_COL(); }
"{"                     { PRINT_TOKEN("LBRACE", yytext);               ADV_COL(); }
"}"                     { PRINT_TOKEN("RBRACE", yytext);               ADV_COL(); }
"["                     { PRINT_TOKEN("LBRACKET", yytext);             ADV_COL(); }
"]"                     { PRINT_TOKEN("RBRACKET", yytext);             ADV_COL(); }
";"                     { PRINT_TOKEN("SEMICOLON", yytext);            ADV_COL(); }
","                     { PRINT_TOKEN("COMMA", yytext);                ADV_COL(); }
"="                     { PRINT_TOKEN("ASSIGN", yytext);               ADV_COL(); }
"."                     { PRINT_TOKEN("DOT", yytext);                  ADV_COL(); }

 /* ----- 1. Identificadores válidos de Java ----- */
 /* Comienzan con letra o guion bajo, seguidos de letras, dígitos o guiones bajos */

{ID_START}{ID_CHAR}*    { PRINT_TOKEN("IDENTIFIER", yytext);           ADV_COL(); }

 /* ----- Espacios en blanco ----- */
\n                      { line++; col = 1; }
[ \t\r]+                { ADV_COL(); }

 /* Cualquier otro carácter no reconocido */
.                       { printf("  [UNKNOWN CHAR '%s'] line=%d, col=%d\n", yytext, line, col);
                          ADV_COL();
                        }

%%

/* ============================================================
   Sección de código de usuario
   ============================================================ */

int main(int argc, char **argv) {
    printf("==============================================\n");
    printf("  Lexer de Java — Análisis Léxico con Flex\n");
    printf("==============================================\n\n");

    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror(argv[1]);
            return 1;
        }
        yyin = f;
        printf("Archivo: %s\n\n", argv[1]);
    } else {
        printf("Leyendo de stdin (Ctrl+D para terminar):\n\n");
    }

    yylex();

    printf("\n==============================================\n");
    printf("  Análisis completado. Líneas procesadas: %d\n", line);
    printf("==============================================\n");

    return 0;
}
