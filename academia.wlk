object academia{
	var property muebles = []


	method estaGuardado(cosa){
		return muebles.any({ mueble => mueble.estaDentro(cosa)})
	}

	method estaEnMueble(cosa){
		return muebles.filter({ mueble => mueble.estaDentro(cosa)})
	}

	method sePuedeGuardar(cosa) {
		return muebles.any({ mueble => mueble.sePuedeGuardar(cosa)}) && !self.estaEnLaAcademia(cosa)
	}

	method estaEnLaAcademia(cosa){
		return self.totalCosas().contains(cosa)
	}

	method totalCosas(){
		return muebles.flatMap( { mueble => mueble.cosasDentro()})
	}

	method enDondeSePuedeGuardar(cosa){
		return muebles.filter( { mueble => mueble.sePuedeGuardar(cosa)})
	}

	method guardarEnAcademia(cosa){
		self.valiadrGuardarEnAcademina(cosa)
			self.enDondeSePuedeGuardar(cosa).head().guardar(cosa)
	}


	method valiadrGuardarEnAcademina(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("No entra en la academia.")
		}
	}

}

class Cosa {
	const property marca
	const property volumen
	const property esMagico
	const property esReliquia
}

class Mueble {

	const property cosasDentro = []

	method guardar(cosa){
		self.validarGuardar(cosa)
		cosasDentro.add(cosa)
	}
	
	method estaDentro(cosa){
		return cosasDentro.contains(cosa)
	}

	method sePuedeGuardar(cosa)
	method validarGuardar(cosa)

}

class Baul inherits Mueble {
	var property volumenMax

	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("No se puede guardar " + cosa + " en este baul.")
		}
	}

	method volumenUsado(){
		return cosasDentro.sum({ cosa => cosa.volumen()})
	}

	override method sePuedeGuardar(cosa){
		return cosa.volumen() + self.volumenUsado() <= volumenMax && !self.estaDentro(cosa)
	}
}

class Gabinete inherits Mueble {
	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("Solo se pueden guardar cosas magicas.")
			}
		}

		override method sePuedeGuardar(cosa){
			return cosa.esMagico()  && !self.estaDentro(cosa)
		}
}


class Armario inherits Mueble {
	var property cantMaxima

	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("No hay lugar en el armario")
		}
	}

	override method sePuedeGuardar(cosa){
		return cosasDentro.size() < cantMaxima && !self.estaDentro(cosa)
	}


}

