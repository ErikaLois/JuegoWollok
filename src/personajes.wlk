import wollok.game.*
import direcciones.*
import nivel1.*

object player {
	var property position = game.origin()
	var property image = "spaceship.png"	
	var property energia = 300
	var property salud =  50
	var property dinero = 0
	var property municiones = 0
	var property direccion = izquierda
	var property disparosAcertados = 0
	
	method puedeRecibirDanio() = true
	method haceDanio() = false

	//COMER
	method comer(){
		const consumiblesArriba = self.objectoEnCeldaA(arriba).filter{ obj => obj.puedeConsumirse() and !obj.haceDanio()}
		const consumiblesAbajo = self.objectoEnCeldaA(abajo).filter{ obj => obj.puedeConsumirse() and !obj.haceDanio()}
		const consumiblesderecha = self.objectoEnCeldaA(derecha).filter{ obj => obj.puedeConsumirse() and !obj.haceDanio()}
		const consumiblesizquierda = self.objectoEnCeldaA(izquierda).filter{ obj => obj.puedeConsumirse() and !obj.haceDanio()}
		
		const todosLosConsumibles = [consumiblesArriba,consumiblesderecha,consumiblesAbajo,consumiblesizquierda].flatten()
		todosLosConsumibles.forEach{ consumible =>
			consumible.serConsumido(self)
			game.say(self, "+" + consumible.aporta() + "Up!")
		}
	}
	//RECOLECTAR DINERO
	method recolectar(elemento){
		if (elemento.puedeConsumirse() and elemento.haceDanio()){
			if (salud>5) {
				game.say(self, "Ouch!")
				elemento.serConsumido(self)
			}
			else { self.morir()}
		}
	}
	
	//EMPUJAR CAJAS
	method empujar(elemento){
		try{
			elemento.moverse(direccion)
		}catch e{
			self.retroceder()
			game.say(self,"Esta Atascada")
		}
	}
	method objectoEnCeldaA(dir){
		return game.getObjectsIn(dir.moverSiguiente(position,self))
	}
	method retroceder(){
		position = direccion.opuesto().moverSiguiente(position,self)
		energia += 1
	}
	method morir(){
		//Falta implementar imagen al morir 
		image = "market.png"
		game.schedule(1500,{
			nivelBloques.perder()
			}
		)
	}
	//MOVIMIENTOS
	method avanzar(){
		if(energia > 0 and salud>0){
			position = direccion.moverSiguiente(position,self)
			energia-=1
		}else{
			self.morir()
		}		
	}
	//RESET
	method reset(){ //lo que sean los valores default
		self.energia(300)
		self.salud(10)
		self.dinero(0)
		self.municiones(0)
	}
}

