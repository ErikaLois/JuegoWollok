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
	var nuevaPos 
	if(posPlayerX > self.position().x()){
		nuevaPos = self.position().x()+1 
	}else{
		nuevaPos = self.position().x()-1
		} 
	return nuevaPos	
	}
	method asignarPosY(player){
	const posPlayerY = player.position().y()
	var nuevaPos 
	if(posPlayerY > self.position().y()){
		nuevaPos = self.position().y()+1 
	}else{
		nuevaPos = self.position().y()-1
		} 
	return nuevaPos	
	}
	
}
