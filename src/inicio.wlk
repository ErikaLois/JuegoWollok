import wollok.game.*
import fondo.*
import personajes.*
import marcador.*
import direcciones.*
import nivel1.*


object niveles {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image= "niveles1.png"))

		game.addVisualIn( player,game.at(3,6))
		
		// Movimientos
		keyboard.s().onPressDo({self.irAJuego() })
		
		game.addVisual(salud)
		game.addVisual(saludNum)
		game.addVisual(energia)
		game.addVisual(energiaNum)
		game.addVisual(dinero)
		game.addVisual(dineroNum)
		game.addVisual(municion)
		game.addVisual(municionNum)
		
		}
		
	method irAJuego() {
		
		game.schedule(2000, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="INSTRUCCIONES.png"))
			// después de un ratito ...
			game.schedule(5000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelBloques.configurate()	
			})
		})
	}
		
}
