import wollok.game.*
import celdaSorpresa.*
import consumibles.*
import deposito.*
import direcciones.*
import elementos.*
import fondo.*
import marcador.*
import nivel2.*
import personajes.*
import utilidades.*
import enemigos.*
import inicio.*

/*ADICIONAR INDUSTRICCIONES --> OBJETIVO NIVEL: ACUMULAR TODAS LAS CAJAS Y LLAVES EN EL DEPOSITO */
object nivelBloques {
	
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
		
		
		// DEPOSITO
		const randX = utilidades.randNumX()
		const randY = utilidades.randNumY()
		const celdasDeposito = [new Position(x=randX, y=randY), 
			new Position(x=randX, y=randY-1), new Position(x=randX, y=randY-2),
			new Position(x=randX+1, y=randY), new Position(x=randX+1, y=randY-1
			), new Position(x=randX+1, y=randY-2)
		]
		celdasDeposito.map{ p => self.dibujar(new Deposito(position = p)) }
		
		//	CAJAS y LLAVES *cada sentencia times genera n objetos con una misma imagen
		const elementos = []
		3.times({ i => elementos.add(new Cajas(position = utilidades.posRand(), llegadas = celdasDeposito, image ="estrella.png")) })		
		3.times({ i=> elementos.add(new Cajas(position = utilidades.posRand(), llegadas = celdasDeposito, image ="llave1.png")) })	
		elementos.forEach{ c => game.addVisual(c) }
		
		//ENEMIGOS
		
		const enem1= new EnemigoNormal(position = game.at(0,2), image="meteorito.png", nivelDanio = 3, direccion = izquierda)
		const enem2= new EnemigoNormal(position = game.at(2,2), image="meteorito.png", nivelDanio = 3, direccion = arriba)
		const enem3= new EnemigoNormal(position = game.at(7,5), image="meteorito.png", nivelDanio = 3, direccion = derecha)
		const enemigos = [enem1,enem2,enem3]
		enemigos.forEach{ e => game.addVisual(e)}
		
		
		// CONSUMIBLES - NIVEL 1	
		const consumibles = []
		12.times({ i => consumibles.add(new Energia(position = utilidades.posRandVacia(utilidades.posRand()), aporta = 10, image= "hamburger.png"))})
		consumibles.forEach{ c => game.addVisual(c)}
		//6.times({ i => consumibles.add(new Energia(position = utilidades.posRandVacia(utilidades.posRand()), aporta = 5, image= "botiquin.png"))})
		//consumibles.forEach{ c => game.addVisual(c)}
		
		//CELDA SORPRESA
		const celdasSorpresas = [(new CeldaSuma(image = "pregunta.png", puntos = 10)), 
			(new CeldaResta(image = "pregunta.png", puntos = 10)), 
			(new CeldaTeleport(image = "pregunta.png")),
			(new CeldaRandom(image = "pregunta.png"))]
		celdasSorpresas.forEach{ c => game.addVisual(c)}
		
		// PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)
		
		
		
		
		
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar(self) })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar(self) })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar(self) })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar(self) })
		keyboard.space().onPressDo({ player.comer()})		
		
		// FINALES DEL NIVEL - SE PODRIA AGREGAR COMO INSTRUCCIONES (R = RESTART , Q = QUIT)
		keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo{ self.restart() }
		keyboard.any().onPressDo{ self.pasarNivel(elementos) }
		
		// COLISIONES
		game.whenCollideDo(player, { elemento =>
			if(!elemento.puedePisarse()){ player.empujar(elemento) }
			else{
				if(elemento.puedeConsumirse()){ elemento.serConsumido(player) }	
			}
		})
		celdasSorpresas.forEach{ e => game.whenCollideDo(e,{ jugador => if(jugador.puedeRecibirDanio() and !jugador.haceDanio()){
			e.afectar(jugador)
		}})}
		
		
		enemigos.forEach{ e => 
			game.whenCollideDo(e, {jugador => 
				if(jugador.puedeRecibirDanio()){ 
					e.hacerDanio(player) 
					game.removeVisual(e)
				}
			})
		}
		
		//MOVIMIENTOS
		
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
	
	method pasarNivel(cajas) {
		if (cajas.all{ c => c.estaEnDeposito() }) {
			game.addVisual(new Fondo(position = game.at(0,0),image="ganador.png"))
			self.terminar()
			
		}
	}
	
	method terminar() {
		// game.clear() limpia visuals, teclado, colisiones y acciones
		game.schedule(1500, {
			game.clear()
			// cambio de fondo
			game.addVisual(new Fondo(image="nivel2.png"))
			game.addVisual(new Fondo(image="instricciones2.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				
				game.clear()
				player.reset()
				// y arranco el siguiente nivel
				nivelLlaves.configurate()
				
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
			game.addVisual(new Fondo(image="nivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				player.reset()
				niveles.configurate()
			})
		})
	}
	
	method dibujar(dibujo) {
			game.addVisual(dibujo)
			return dibujo
	}
}



