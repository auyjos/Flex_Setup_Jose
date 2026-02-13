#!/bin/bash
# ==============================================
# run_tests.sh
# Script para compilar y ejecutar el lexer
# Ejecutar dentro del contenedor Docker
# ==============================================

set -e

echo "=============================================="
echo "  Compilando java_lexer.l con Flex"
echo "=============================================="
flex java_lexer.l
gcc lex.yy.c -o java_lexer -lfl
echo "  ✓ Compilación exitosa"
echo ""

echo "=============================================="
echo "  PRUEBA 1: Archivo Java (test_java.txt)"
echo "=============================================="
./java_lexer test_java.txt
echo ""

echo "=============================================="
echo "  PRUEBA 2: Archivo Go (test_go.go)"
echo "=============================================="
./java_lexer test_go.go
echo ""

echo "=============================================="
echo "  Todas las pruebas completadas"
echo "=============================================="
