import wollok.game.*
import fondo.*
import personajes.*
import marcador.*
import direcciones.*
import nivel2.*


object niveles2 {

	method configurate() {
		// fondo - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image= "niveles2.png"))

		game.addVisualIn( player,game.at(9,6))
		
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
			game.addVisual(new Fondo(image="instrucciones2.png"))
			// después de un ratito ...
			game.schedule(5000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelLlaves.configurate()	
			})
		})
	}
		
}