import wollok.game.*
import consumibles.*
import deposito.*
import direcciones.*
import elementos.*
import enemigos.*
import fondo.*
import marcador.*
import nivel3.*
import personajes.*
import utilidades.*


/*ADICIONAR INSTRUCCIONES --> OBJETIVO NIVEL: JUNTAR X CANTIDAD DE DINERO Y ESCAPAR POR LA PUERTA AL LOGRARLO */
//PIERDE 5 DE ENERGIA POR CADA PIEZA DE DINERO QUE JUNTA
object nivelLlaves {
	method configurate() {
		// FONDO - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="background_3.jpg"))
		
		//MARCADORES
		const elementos = [salud, energia, dinero, municion]
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
		
		// 4. ENEMIGOS
		const enemigos = [new EnemigoNormal(position = utilidades.posRand(), image="among1.png", nivelDanio = 3, direccion = izquierda),
			new EnemigoRandom(position = utilidades.posRand(), image="among2.png", nivelDanio = 10, direccion = izquierda),
			new EnemigoAlAcecho(position = game.at(9,10), image="among3.png",nivelDanio = 15, direccion = izquierda)
		]
		enemigos.forEach{ e => game.addVisual(e)}
		
		// 5. PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)
				 
				 
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar() })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar() })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar() })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar() })
		keyboard.space().onPressDo({ player.comer()})		
		
		// FINALES DEL NIVEL
		keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo{ self.restart() }
		
		// COLISIONES
		game.whenCollideDo(player, {elemento => player.recolectar(elemento) self.verificar(objetivoDinero)})
		game.whenCollideDo(player, {elemento => if (elemento.esPortal()) self.terminar()})
		enemigos.forEach{ e => 
			game.whenCollideDo(e, {jugador => 
				if(jugador.puedeRecibirDanio() and !jugador.haceDanio()){ e.hacerDanio(player) }
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
	method verificar(objetivoDinero) {
		if (objetivoDinero == player.dinero() and player.energia()> 0) {
				game.addVisual(new Portal(image="smallPortal.png"))
		}
	}
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.schedule(1500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="finNivel1.jpg"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
				// y arranco el siguiente nivel
				nivelEnemigos.configurate()
			})
		})
	}
	method perder(){
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.clear()
		// después puedo volver a agregar el fondo, y algún visual para que no quede tan pelado
		game.addVisual(new Fondo(position = game.at(0,0),image="gameover.png"))
		// después de un ratito ...
		game.schedule(2500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="finNivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
			})
		})
	}
}
