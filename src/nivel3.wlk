import wollok.game.*
import consumibles.*
import deposito.*
import direcciones.*
import elementos.*
import enemigos.*
import fondo.*
import marcador.*
import personajes.*
import utilidades.*

/*ADICIONAR INDUSTRICCIONES --> OBJETIVO NIVEL: JUNTAR MUNICIONES Y ELIMINAR TODOS LOS ENEMIGOS */
object nivelEnemigos {
	method configurate() {
		// FONDO - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="background_3.jpg"))
		
		//MARCADORES
		const elementos = [salud, energia, dinero]
		elementos.forEach{ elem => game.addVisual(elem)}
		
		// CONSUMIBLES - NIVEL 3
		const consumibles = []
		
		// 1. SALUD
		5.times({ i=> consumibles.add(new Salud(position= utilidades.posRand(), aporta = 15, image = "botiquin.png")) })
		
		// 2. ENERGIA
		5.times({ i=> consumibles.add(new Energia(position= utilidades.posRand(), aporta = utilidades.randNumX(), image = "hamburger.png")) })		
		consumibles.forEach({ c => game.addVisual(c)})
		
		// 3.ENEMIGOS
		const enemigos = []
		4.times({ i=> enemigos.add(new EnemigoNormal(position = utilidades.posRand(), image="among1.png", nivelDanio = 3, direccion = izquierda))})
		3.times({ i=> enemigos.add(new EnemigoRandom(position = utilidades.posRand(), image="among2.png", nivelDanio = 10, direccion = izquierda))})
		2.times({ i=> enemigos.add(new EnemigoAlAcecho(position = game.at(9,10), image="among3.png",nivelDanio = 15, direccion = izquierda))})
		enemigos.forEach{ e => game.addVisual(e)}
		
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
		
		// COLISIONES
		enemigos.forEach{ e => 
			game.whenCollideDo(e, {jugador => 
				if(jugador.puedeRecibirDanio()){ e.hacerDanio(player) }
			})
		}
		enemigos.forEach{ e => 
			game.onTick(1000,"movimientoEnemigo",{
			if (e.seDesplazaNormal()){ e.desplazarse() }
			else{ e.desplazarseHacia(player) }
			})
		}
	}
	
	method restart() {
		player.reset()
		game.clear()
		self.configurate()
	}	
}
