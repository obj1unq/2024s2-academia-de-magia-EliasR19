object academia{
	var property muebles = []

    //PUNTO 1.1
	method estaGuardado(cosa){
		return muebles.any({ mueble => mueble.estaDentro(cosa)})
	}

    //PUNTO 1.2
	method estaEnMueble(cosa){	// intentar con find
		return muebles.find({ mueble => mueble.estaDentro(cosa)})
	}

    //PUNTO 1.3
	method sePuedeGuardar(cosa) {
		return muebles.any({ mueble => mueble.sePuedeGuardar(cosa)}) && !self.estaGuardado(cosa)
	}

    //PUNTO 1.4
	method enDondeSePuedeGuardar(cosa){
		return muebles.find( { mueble => mueble.sePuedeGuardar(cosa)})
	}

    //PUNTO 1.5
	method guardarEnAcademia(cosa){
		self.valiadrGuardarEnAcademina(cosa)
		self.enDondeSePuedeGuardar(cosa).guardar(cosa)
	}


	method valiadrGuardarEnAcademina(cosa){
		if(!self.sePuedeGuardar(cosa)){
		    self.error("No entra en la academia.")
		}
	}

    //PUNTO 2.2
	method cosasMenosUtilides(){
		return muebles.map({ mueble => mueble.cosaMenosUtilDentro()}).asSet()
	}
    
    //PUNTO 2.3
	method marcaCosaMenosUtil(){
		return self.laCosaMenosUtil().marca()
	}

    method laCosaMenosUtil(){
        return self.cosasMenosUtilides().min({cosa => cosa.utilidad()})
    }

    //PUNTO 2.4
	method tirarCosasMenosUtilesNoMagicas(){
        self.validarTirar()
		self.cosasNoMagicasDeMenosUtiles().forEach({cosa => self.tirar(cosa)})
	}

    method cosasNoMagicasDeMenosUtiles(){
        return self.cosasMenosUtilides().filter({ cosa => !cosa.esMagico()})
    }

	method tirar(cosa){
		self.estaEnMueble(cosa).tirar(cosa)
	}

	method validarTirar(){
		if(muebles.size() < 3){
			self.error("No se puede tirar, no hay al menos 3 muebles")
		}
	}

}

class Cosa {
	const property marca
	const property volumen
	const property esMagico
	const property esReliquia

	method utilidad(){
		return volumen + self.utilidadMagico() + self.utilidadRelquia() + self.utilidadMarca()
	}

	method utilidadMagico(){
		return if(esMagico) 3 else 0
	}

	method utilidadRelquia(){
		return if(esReliquia) 5 else 0
	}

	method utilidadMarca(){
		return marca.utilidadQueAportaA(self)
	}
}

//COSAS MARCAS
object acme {
	method utilidadQueAportaA(cosa){
		return cosa.volumen() / 2
	}
}

object fenix{
	method utilidadQueAportaA(cosa){
		return if(cosa.esReliquia()) 3 else 0
	}
}

object cuchuflito {
	method utilidadQueAportaA(cosa){
		return 0
	}
}



// MUEBLES
class Mueble {

	const property cosasDentro = []

	method guardar(cosa){
		self.validarGuardar(cosa)
		cosasDentro.add(cosa)
	}

	method tirar(cosa){
			cosasDentro.remove(cosa)
	}

	
	method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("A")
		}
	}
	method estaDentro(cosa){
		return cosasDentro.contains(cosa)
	}

	method utilidad(){
		return  ( self.utilidadCosas() / self.precio() )
	}


	method utilidadCosas(){
		return cosasDentro.sum({cosa => cosa.utilidad()})
	}

	method cosaMenosUtilDentro(){
		return cosasDentro.min({ cosa => cosa.utilidad()})
	}

	method sePuedeGuardar(cosa)
	//method validarGuardar(cosa)
	method precio()

}

class Baul inherits Mueble {
	var property volumenMax

/* 	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("No se puede guardar " + cosa + " en este baul.")
		}
	} */

	method volumenUsado(){
		return cosasDentro.sum({ cosa => cosa.volumen()})
	}

	override method sePuedeGuardar(cosa){
		return cosa.volumen() + self.volumenUsado() <= volumenMax && !self.estaDentro(cosa)
	}

	override method precio(){
		return volumenMax + 2
	}

	override method utilidad(){
		return super() + self.utilidadReliquias() 
	}

	method utilidadReliquias(){
		return if(cosasDentro.all({cosa => cosa.esReliquia()})){
				2 
			} else {
				0
			}
	}
}
class BaulMagico inherits Baul {
	override method utilidad(){
		return super() + self.cantMagicos()
	}

	override method precio(){	//de donde sale el x2?
		return super() * 2
	}

	method cantMagicos(){
		return cosasDentro.count({cosa => cosa.esMagico()})
	}
}

class Gabinete inherits Mueble {
	var precio = 0

/* 	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("Solo se pueden guardar cosas magicas.")
			}
		} */

		override method sePuedeGuardar(cosa){
			return cosa.esMagico()  && !self.estaDentro(cosa)
		}

		method precio(_precio){
			precio = _precio
		}

		override method precio(){
			return precio
		}
}


class Armario inherits Mueble {
	var property cantMaxima
/* 
	override method validarGuardar(cosa){
		if(!self.sePuedeGuardar(cosa)){
			self.error("No hay lugar en el armario")
		}
	} */

	override method sePuedeGuardar(cosa){
		return cosasDentro.size() < cantMaxima && !self.estaDentro(cosa)
	}

	override method precio(){
		return 5 * cantMaxima
	}


}

