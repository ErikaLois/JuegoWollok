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
		const elementos = [salud, energia, dinero, municion]
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
		2.times({ i=> enemigos.add(new EnemigoNormal(position = utilidades.posRand(), image="among1.png", nivelDanio = 3, direccion = izquierda))})
		//4.times({ i=> enemigos.add(new EnemigoRandom(position = utilidades.posRand(), image="among2.png", nivelDanio = 10, direccion = izquierda))})
		//2.times({ i=> enemigos.add(new EnemigoAlAcecho(position = game.at(9,10), image="among3.png",nivelDanio = 15, direccion = izquierda))})
		const objetivoEnemigos = enemigos.size()
		enemigos.forEach{ e => game.addVisual(e)}
		
		// 4.MUNICIONES
		const municiones = []
		5.times({ i=> municiones.add(new Municion (aporta = 4, position = utilidades.posRand(), image = 'laserGun.png'))})
		municiones.forEach{ m => game.addVisual(m)}
		
		// PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)
				 
				 
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar() })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar() })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar() })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar() })
		keyboard.space().onPressDo({ player.comer()})			
		keyboard.s().onPressDo({ self.disparar(objetivoEnemigos) })
		
		// FINALES DEL NIVEL
		keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo({ self.restart() })
		keyboard.any().onPressDo ({ if (objetivoEnemigos == player.disparosAcertados()){ self.ganar() } })
		
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
		municiones.forEach{ m =>
			game.whenCollideDo(m, {elemento =>
 				if (elemento.puedeRecibirDanio() and !elemento.haceDanio()) { m.serConsumido(player)}
			})
		}
		//las municiones de esta manera NO SE RECOLECTAN CON BARRA ESPACIADORA
	}
	
	//Este metodo hace basicamente todo lo del nivel 3
	method disparar(objetivoEnemigos){
		if (player.municiones()>0){
			const direccion = player.direccion()
			const posicion = direccion.moverSiguiente(player.position(), player)
			const bala = new Municion(aporta = 4, position = posicion, image = "coso.png")
			game.addVisual(bala)
			player.municiones(player.municiones() - 1)
			game.whenCollideDo(bala, {elemento =>
 				if (elemento.puedeRecibirDanio() and elemento.haceDanio()) 
 				{ game.removeVisual(elemento) game.removeVisual(bala) player.disparosAcertados(player.disparosAcertados()+1 )}
			})
			game.schedule(1000, { => bala.avanzar(direccion) })
			game.schedule(2000, { => bala.avanzar(direccion) })
			game.schedule(3000, { => bala.avanzar(direccion) })
			game.schedule(4000, { => if(game.hasVisual(bala)) game.removeVisual(bala) })
			game.say(player, "mis disparos son: " + player.disparosAcertados())
		}
		else { game.say(player, "No tengo municiones!") }
	}
	
	method restart() {
		player.reset()
		game.clear()
		self.configurate()
	}
	
	method ganar(){ 
		game.say(player, "ganamos, poneme imagenes y coso")
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
