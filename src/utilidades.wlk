import wollok.game.*

object utilidades {
	method posRand() {
		return game.at(
			0.randomUpTo(game.width()).truncate(0), 0.randomUpTo(game.height()-1).truncate(0)
		)
	}
	method randNumX() {
		return 1.randomUpTo(game.width()-1).truncate(0)
	}
	method randNumY() {
		return 2.randomUpTo(game.height()-1).truncate(0)
	}	
}


