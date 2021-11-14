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

/*ADICIONAR INDUSTRICCIONES --> OBJETIVO NIVEL: ACUMULAR TODAS LAS CAJAS Y LLAVES EN EL DEPOSITO */
object nivelBloques {

	method configurate() {
		// FONDO - es importante que sea el primer visual que se agregue
		game.addVisual(new Fondo(image="background_2.jpg"))
		
		//MARCADORES
		const elementos = [salud, energia, dinero, municion]
		elementos.forEach{ elem => game.addVisual(elem)}
		
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
		const cajas = []
		3.times({ i => cajas.add(new Cajas(position = utilidades.posRand(), llegadas = celdasDeposito, image ="caja.png")) })		
		3.times({ i=> cajas.add(new Cajas(position = utilidades.posRand(), llegadas = celdasDeposito, image ="coso.png")) })	
		cajas.forEach{ c => game.addVisual(c) }
		
		// CONSUMIBLES - NIVEL 1	
		const consumibles = []
		6.times({ i => consumibles.add(new Energia(position = utilidades.posRand(), aporta = utilidades.randNumX(), image= "hamburger.png"))})
		consumibles.forEach{ c => game.addVisual(c)}
		
		// CELDA SORPRESA
		const celdasSorpresas = [(new CeldaSuma(image = "almacenaje.png", puntos = 10)), 
			(new CeldaResta(image = "almacenaje.png", puntos = 10)), 
			(new CeldaTeleport(image = "almacenaje.png")),
			(new CeldaRandom(image = "almacenaje.png"))]
		celdasSorpresas.forEach{ c => game.addVisual(c)}
		
		// PJ, es importante que sea el último visual que se agregue
		game.addVisual(player)

		
		// TECLADO-MOVIMIENTOS
		keyboard.up().onPressDo({ player.direccion(arriba) player.avanzar() })
		keyboard.down().onPressDo({ player.direccion(abajo) player.avanzar() })
		keyboard.left().onPressDo({ player.direccion(izquierda) player.avanzar() })
		keyboard.right().onPressDo({ player.direccion(derecha) player.avanzar() })
		keyboard.space().onPressDo({ player.comer()})		
		
		// FINALES DEL NIVEL - SE PODRIA AGREGAR COMO INSTRUCCIONES (R = RESTART , Q = QUIT)
		keyboard.q().onPressDo({ self.perder() })
		keyboard.r().onPressDo{ self.restart() }
		keyboard.any().onPressDo{ self.pasarNivel(cajas) }
		
		// COLISIONES
		game.whenCollideDo(player, { elemento =>
			if(!elemento.puedePisarse()){ player.empujar(elemento) }
			else{
				if(elemento.puedeConsumirse()){ elemento.serConsumido(player) }	
			}
		})
		celdasSorpresas.forEach{ e => game.whenCollideDo(e,{ jugador => if(jugador.puedeRecibirDanio()){
			e.afectar(jugador)
		}})}
	}
	
	
	method restart() {
		player.reset()
		game.clear()
		self.configurate()
	}
	
	method pasarNivel(cajas) {
		if (cajas.all{ c => c.estaEnDeposito() }) {
			game.say(player, "LEVEL 1 COMPLETE!") 
			self.terminar()
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
			game.addVisual(new Fondo(image="finNivel1.png"))
			// después de un ratito ...
			game.schedule(3000, {
				// ... limpio todo de nuevo
				game.clear()
			})
		})
	}
	
	method dibujar(dibujo) {
			game.addVisual(dibujo)
			return dibujo
	}
}



