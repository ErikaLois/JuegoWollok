import wollok.game.*
import elementos.*

class Consumibles inherits Elementos{
	var property aporta 
	override method puedePisarse() = false
	override method puedeConsumirse() = true
	override method haceDanio()= false
	override method moverse(dir) {}
	
	//Abstract
	method serConsumido(player)	
}
class Energia inherits Consumibles{
	override method image() = "hamburger.png"
	override method serConsumido(player){
		game.removeVisual(self)
		player.energia(player.energia() + aporta)	
	}
}
class Salud inherits Consumibles{
	override method image() = "botiquin.png"
	override method serConsumido(player){
		game.removeVisual(self)
		player.salud(player.salud() + aporta)
	}
}
class Municion inherits Consumibles{
	override method serConsumido(player){
		game.removeVisual(self)
		player.municiones(player.municiones() + aporta)
	}
}
class Dinero inherits Consumibles{
	override method image() = "coin.png"
	override method haceDanio()= true
	override method serConsumido(player){
		game.removeVisual(self)
		player.dinero(player.dinero() + aporta)		
		player.salud(player.salud() - aporta)
	}
}