import wollok.game.*
import consumibles.*
import deposito.*
import direcciones.*
import elementos.*
import fondo.*
import marcador.*
import nivel1.*
import personajes.*
import portal.*
import utilidades.*

/*ADICIONAR INDUSTRICCIONES --> OBJETIVO NIVEL: JUNTAR X CANTIDAD DE DINERO Y ESCAPAR POR LA PUERTA AL LOGRARLO */
//PIERDE 5 DE ENERGIA POR CADA PIEZA DE DINERO QUE JUNTA
object nivelLlaves {
	
	method configurate() {
		// FONDO - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="background_3.jpg"))
		
		//MARCADORES
		const elementos = [salud, energia, dinero]
		elementos.forEach{ elem => game.addVisual(elem)}
		
		// CONSUMIBLES - NIVEL 2
		const consumibles = []
		
		// 1. DINERO
		5.times({ i=> consumibles.add(new Dinero(position= utilidades.posRand(), aporta = 5, image = "coin.png")) })
		const objetivoDinero = consumibles.sum({d => d.aporta()})
		
		// 2. SALUD
		5.times({ i=> consumibles.add(new Salud(position= utilidades.posRand(), aporta = 15, image = "botiquin.png")) })
		
		// 3. ENERGIA
		5.times({ i=> consumibles.add(new Energia(position= utilidades.posRand(), aporta = utilidades.randNumX(), image = "hamburger.png")) })
		
		consumibles.forEach({ c => game.addVisual(c)})
		
		// PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)
				 
				 
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar() })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar() })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar() })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar() })
		keyboard.space().onPressDo({ player.comer()})		
		
		// FINALES DEL NIVEL
		//keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo{ self.restart() }
		keyboard.any().onPressDo{ self.verificar(objetivoDinero)}
		//self.ganar()
		
		// COLISIONES
		game.whenCollideDo(player, {elemento => player.recolectar(elemento)})

	}
	
	method verificar(objetivoDinero) {
		if (objetivoDinero == player.dinero() and player.energia()> 0) {
				//game.say(player, "LEVEL 2 COMPLETE!") 
				game.addVisual(portal)
		}
	}
	
	method restart() {
		game.clear()
		self.configurate()
	}	
}
