import wollok.game.*
import personajes.*

object energia{
	var property position = game.at(2,game.height()-1)
	method text() = "Energia: " + player.energia()
}
object salud{
	var property position = game.at(4,game.height()-1)
	method text() = "Salud: " + player.salud()
}
object dinero{
	var property position = game.at(6,game.height()-1)
	method text() = "Dinero: " + player.dinero()
}
object municion{
	var property position = game.at(8,game.height()-1)
	method text() = "Municiones: " + player.municiones()
}