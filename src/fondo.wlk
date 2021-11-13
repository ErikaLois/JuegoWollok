import wollok.game.*

class Fondo {
	const property position = game.at(0,0)
	var property image
	method puedePisarse() = true
	method puedeConsumirse() = false
	method puedeRecibirDanio() = false
	method haceDanio()= false
	method moverse(dir) {}
}


