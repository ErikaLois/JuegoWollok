import wollok.game.*
import direcciones.*
import utilidades.*

class Enemigo{
	var property position
	var property image
	var property nivelDanio
	var property direccion
	method puedePisarse() = true
	method puedeRecibirDanio() = false
	method puedeConsumirse() = false
	method esPortal() = false
	method seDesplazaNormal() = true
	method movete(dir){}
	method desplazarse()
	method hacerDanio(player){
			player.salud(player.salud()-nivelDanio)
			game.removeVisual(self)
			game.say(player,"-"+nivelDanio)
 	}
}

class EnemigoNormal inherits Enemigo{
	override method desplazarse(){
		position = direccion.moverSiguiente(self.position(),self)
	}
}
class EnemigoRandom inherits Enemigo{
	override method desplazarse(){
		position = utilidades.posRand()
	}
	override method hacerDanio(player){
		super(player) 
		player.dinero(player.dinero() - nivelDanio)
	}
}
class EnemigoAlAcecho inherits Enemigo{
	override method desplazarse() {}
	override method seDesplazaNormal() = false
	method desplazarseHacia(player){
		position = new Position(x=self.asignarPosX(player),y =self.asignarPosY(player))
	}
	method asignarPosX(player){
		const posPlayerX = player.position().x()
		return if(posPlayerX > self.position().x()){ self.position().x()+1 }
		else{ self.position().x()-1 } 
	}
	method asignarPosY(player){
		const posPlayerY = player.position().y()
		return if(posPlayerY > self.position().y()){ self.position().y()+1 }
		else{ self.position().y()-1 } 
	}	
}
