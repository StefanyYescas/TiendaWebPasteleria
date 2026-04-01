// carritoStore.js
import { defineStore } from 'pinia'
import { useUsuarioStore } from './usuario'

export const useCarritoStore = defineStore('carrito', {
  state: () => ({
    productos: [] // Carrito vacío al inicio
  }),
  getters: {
    totalProductos(state) {
      return state.productos.reduce((total, producto) => total + producto.cantidad, 0)
    }
  },
  actions: {
    agregarProducto(producto) {
      const existente = this.productos.find(p => p.producto_ID === producto.producto_ID)
      if (existente) {
        existente.cantidad += producto.cantidad
      } else {
        this.productos.push(producto)
      }
      this.guardarEnLocalStorage()
    },
    eliminarProducto(id) {
      this.productos = this.productos.filter(p => p.producto_ID !== id)
      this.guardarEnLocalStorage()
    },
    vaciarCarrito() {
      this.productos = []
      this.guardarEnLocalStorage() // También guardar la eliminación en localStorage
    },
    guardarEnLocalStorage() {
      const usuarioStore = useUsuarioStore()
      const usuarioID = usuarioStore.usuario?.id
      if (usuarioID) {
        localStorage.setItem(`carrito_${usuarioID}`, JSON.stringify(this.productos)) // Guardar en localStorage bajo el ID del usuario
      }
    },
    cargarCarrito() {
      const usuarioStore = useUsuarioStore()
      const usuarioID = usuarioStore.usuario?.id

      // Solo cargar el carrito si el usuario está logueado
      if (usuarioID) {
        const data = localStorage.getItem(`carrito_${usuarioID}`)
        if (data) {
          this.productos = JSON.parse(data) // Cargar carrito desde localStorage
        } else {
          this.productos = [] // Si no existe, mantener el carrito vacío
        }
      } else {
        this.productos = [] // Si no hay usuario, vaciar el carrito
      }
    }
  }
})
