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
import inicio3.*
import inicio2.*


/*ADICIONAR INSTRUCCIONES --> OBJETIVO NIVEL: JUNTAR X CANTIDAD DE DINERO Y ESCAPAR POR LA PUERTA AL LOGRARLO */
//PIERDE 5 DE ENERGIA POR CADA PIEZA DE DINERO QUE JUNTA
object nivelLlaves {
	method configurate() {
		// FONDO - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="fondo.png"))
		
		//MARCADORES
		game.addVisual(salud)
		game.addVisual(saludNum)
		game.addVisual(energia)
		game.addVisual(energiaNum)
		game.addVisual(dinero)
		game.addVisual(dineroNum)
		game.addVisual(municion)
		game.addVisual(municionNum)
		
		
		// CONSUMIBLES - NIVEL 2
		//const consumibles = []
		
		// 1. DINERO
		const dinero1 = []
		5.times({ i=> dinero1.add(new Dinero(position= utilidades.posRandVacia(utilidades.posRand()), aporta = 5, image = "dinero.png")) })
		const objetivoDinero = dinero1.sum({d => d.aporta()})
		
		dinero1.forEach({ c => game.addVisual(c)})

		// 2. SALUD
		const salud1 = []
		5.times({ i=> salud1.add(new Salud(position= utilidades.posRandVacia(utilidades.posRand()), aporta = 15, image = "botiquin.png")) })
		salud1.forEach({ c => game.addVisual(c)})
	
		// 3. ENERGIA
		const energia1 = []
		5.times({ i=> energia1.add(new Energia(position= utilidades.posRandVacia(utilidades.posRand()), aporta = utilidades.randNumX(), image = "hamburger.png")) })
		energia1.forEach({ c => game.addVisual(c)})
		
		// 4. ENEMIGOS
		const enemigos = [new EnemigoNormal(position = utilidades.posRand(), image="alien.png", nivelDanio = 3, direccion = izquierda),
			new EnemigoRandom(position = utilidades.posRand(), image="meteorito.png", nivelDanio = 10, direccion = izquierda),
			new EnemigoAlAcecho(position = game.at(9,10), image="meteorito.png",nivelDanio = 15, direccion = izquierda)
		]
		enemigos.forEach{ e => game.addVisual(e)}
		
		// 5. PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)
				 
				 
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar(self) })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar(self) })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar(self) })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar(self) })
		keyboard.space().onPressDo({ player.comer()})		
		
		// FINALES DEL NIVEL
		keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo{ self.restart() }
		
		// COLISIONES
		game.whenCollideDo(player, {elemento => player.recolectar(elemento,self) self.verificar(objetivoDinero)})
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
				game.addVisual(new Portal(image="portal.png"))
		}
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.schedule(1500, {
			game.clear()
			game.addVisual(new Fondo(image="ganador.png"))
			// cambio de fondo
			game.addVisual(new Fondo(image="nivel3.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.addVisual(new Fondo(image="instrucciones3.png"))
				game.clear()
				player.reset()
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
			game.addVisual(new Fondo(image="nivel2.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				player.reset()
				niveles2.configurate()
			})
		})
	}
}
