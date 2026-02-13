// ========================================
// test_go.go
// Archivo de prueba en Go (ni Python ni Java)
// para verificar el lexer con otro lenguaje
// ========================================

package main

import (
	"fmt"
)

// Constantes con diferentes tipos numéricos
const PI = 3.14159265
const MAX_SIZE = 1000
const HEX_COLOR = 0xFF00AB
const AVOGADRO = 6.022e23

/*
Función que calcula el área de un círculo

	usando la constante PI
*/
func calcularArea(radio float64) float64 {
	return PI * radio * radio
}

// Estructura con identificadores válidos estilo Java
type _Punto struct {
	coordX  float64
	coordY  float64
	_nombre string
	activo  bool
}

func main() {
	// Variables con diferentes identificadores
	var miVariable int = 42
	var _temp float64 = .5
	resultado := 0.0
	hex_val := 0xDEAD

	// Operadores aritméticos
	suma := miVariable + 10
	resta := miVariable - 5
	mult := suma * resta
	div := mult / 2

	// Operadores relacionales y lógicos
	if suma >= 50 && resta != 0 {
		fmt.Println("Condición verdadera")
	}

	if div <= 100 || _temp > 0.25 {
		fmt.Println("Segunda condición")
	}

	if !(suma == resta) {
		fmt.Println("No son iguales")
	}

	// Cadenas con secuencias de escape
	msg1 := "Hola\tMundo\n"
	msg2 := "Ruta: C:\\Users\\archivo"
	msg3 := "Dijo: \"hola\""
	msg4 := ""

	// Notación científica
	nano := 1.5e-9
	giga := 2.0e+9
	sci := 3e4

	// Uso combinado
	punto := _Punto{
		coordX:  1.5e2,
		coordY:  0xFF,
		_nombre: "Origen\n",
		activo:  true,
	}

	resultado = calcularArea(5.0) + float64(hex_val)*1e-3
	fmt.Println(resultado, punto, msg1, msg2, msg3, msg4, nano, giga, sci)
	fmt.Println(suma, resta, mult, div)

	// Más operadores
	a := 10
	b := 3
	fmt.Println(a + b)
	fmt.Println(a - b)
	fmt.Println(a * b)
	fmt.Println(a / b)
	fmt.Println(a < b)
	fmt.Println(a > b)
	fmt.Println(a <= b)
	fmt.Println(a >= b)
	fmt.Println(a == b)
	fmt.Println(a != b)
}
