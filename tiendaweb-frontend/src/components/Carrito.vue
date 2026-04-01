<template> 
  <section class="carrito-section">
    <div class="carrito-container">
      <CheckoutSteps :paso="1" />

      <!-- Encabezados -->
      <div class="carrito-header" v-if="carrito.productos.length > 0">
        <span class="header-producto">Producto</span>
        <span class="header-vacio"></span>
        <span class="header-cantidad">Cantidad</span>
        <span class="header-total">Total</span>
      </div>

      <!-- Lista de productos o mensaje si está vacío -->
      <div class="carrito-tabla">
        <div v-if="carrito.productos.length === 0" class="carrito-vacio">
          <p>¡Tu carrito está vacío!</p>
          <router-link to="/ordenaaqui" class="seguir-comprando">Ir a comprar</router-link>
        </div>

        <div
          v-else
          v-for="item in carrito.productos"
          :key="item.producto_ID"
          class="carrito-fila"
        >
          <div class="col-img">
            <img :src="item.imagen_url" alt="Producto" class="carrito-img" />
          </div>

          <div class="col-info">
            <h3>{{ item.nombre_producto }}</h3>
            <p class="precio-unitario">$ {{ item.precio }}</p>
          </div>

          <div class="col-controles">
            <div class="cantidad-control">
              <button @click="disminuirCantidad(item)">−</button>
              <span>{{ item.cantidad }}</span>
              <button @click="aumentarCantidad(item)">+</button>
            </div>
            <p class="quitar" @click="quitarProducto(item.producto_ID)">Quitar</p>
          </div>

          <div class="col-total">
            <p>$ {{ (item.precio * item.cantidad).toFixed(2) }}</p>
          </div>
        </div>
      </div>

      <!-- Resumen Subtotal/Total -->
      <div class="carrito-resumen" v-if="carrito.productos.length > 0">
        <span class="resumen-subtotal">Subtotal</span>
        <span class="resumen-total">
          $ {{
            carrito.productos.reduce(
              (acc, item) => acc + item.precio * item.cantidad,
              0
            ).toFixed(2)
          }}
        </span>
      </div>

      <!-- Botones de acción -->
      <div class="acciones" v-if="carrito.productos.length > 0">
        <router-link to="/ordenaaqui" class="seguir-comprando">SEGUIR COMPRANDO</router-link>
        <router-link to="/informacion" class="ir-a-pagar">IR A PAGAR</router-link>
      </div>
            <!-- Texto adicional debajo de botones -->
      <div class="texto-extra" v-if="carrito.productos.length > 0">
          <p>
          Si aún no eres invitado consentido.
          <router-link to="/registrate" class="subrayado">Regístrate aquí</router-link>
        </p>
      </div>
    </div>
  </section>
  
</template>

<script setup>
import { onMounted } from 'vue'
import CheckoutSteps from '@/components/CheckoutSteps.vue'
import { useCarritoStore } from '@/stores/carrito'
import { useUsuarioStore } from '@/stores/usuario'

const carrito = useCarritoStore()
const usuarioStore = useUsuarioStore()


onMounted(() => {
  // Cargar el usuario desde localStorage
  usuarioStore.cargarDesdeLocalStorage()  // Asegurarse de que el usuario esté cargado

  // Cargar el carrito solo si el usuario está logueado
  if (usuarioStore.usuario) {
    carrito.cargarCarrito() // Cargar el carrito guardado en localStorage
  }
})

function aumentarCantidad(item) {
  if (usuarioStore.usuario) {
    item.cantidad++
    carrito.guardarEnLocalStorage()
  } else {
    alert('Debes iniciar sesión para agregar productos al carrito.')
  }
}

function disminuirCantidad(item) {
  if (item.cantidad > 1) {
    item.cantidad--
    carrito.guardarEnLocalStorage()
  }
}

function quitarProducto(id) {
  carrito.eliminarProducto(id)
}
</script>


<style scoped>
 .texto-extra {
  padding: 30px;
  text-align: center;
  font-size: 14px;
  color: #6C5C05;
}

.texto-extra .subrayado {
  text-decoration: underline;
  color: #6C5C05;
  font-weight: bold;
}

.carrito-section {
  background-image: linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.1)), url('@/assets/fueguito.jpg');
  background-size: cover;
  background-position: center;
  background-repeat: no-repeat;
  background-attachment: fixed;
  padding: 0;
  color: #6C5C05;
  text-align: center;
  font-family: "Times New Roman", Times, serif;
}

.carrito-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 0px 30px;
}

.titulo-carrito {
  font-size: 36px;
  font-weight: 900;
  color: #6C5C05;
  text-shadow: 2px 2px 4px rgba(255, 255, 255, 0.6);
  margin-bottom: 40px;
  letter-spacing: 1px;
}

.carrito-header {
  display: grid;
  grid-template-columns: 100px 2fr 2fr 1fr;
  padding: 8px 16px;
  background-color: rgba(255, 255, 255, 0.8);
  border: 1px solid #6C5C05;
  border-radius: 12px;
  font-weight: bold;
  color: #6C5C05;
  margin-bottom: 20px;
  
}

.carrito-header span {
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-producto {
  justify-content: flex-start;
  padding-left: 8px;
}

.header-vacio {
  display: none;
}

.carrito-tabla {
  display: flex;
  flex-direction: column;
  gap: 10px;
  padding: 15px;
  
}

.carrito-fila {
  display: grid;
  grid-template-columns: 100px 2fr 2fr 1fr;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.5);
  border: 1px solid #6C5C05;
  border-radius: 12px;
  padding: 16px;
  gap: 16px;
}

.carrito-img {
  width: 80px;
  height: 80px;
  object-fit: cover;
  border-radius: 8px;
}

.col-info {
  text-align: left;
}

.precio-unitario {
  color: #6C5C05;
  font-weight: bold;
  margin-top: 8px;
}

.col-controles {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 6px;
}

.cantidad-control {
  display: flex;
  align-items: center;
  gap: 6px;
}

.cantidad-control button {
  background: none;
  border: 2px solid #6C5C05;
  color: #6C5C05;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cantidad-control span {
  font-weight: bold;
  min-width: 24px;
  text-align: center;
}

.quitar {
  font-size: 12px;
  color: #6C5C05;
  cursor: pointer;
  text-decoration: underline;
}

.col-total {
  font-size: 18px;
  font-weight: bold;
  color: #6C5C05;
}

.acciones {
  margin-top: 40px;
}

.seguir-comprando {
  padding: 10px 24px;
  border: 2px solid #6C5C05;
  border-radius: 8px;
  color: #6C5C05;
  background-color: transparent;
  text-decoration: none;
  font-weight: bold;
  transition: 0.3s;
}

.seguir-comprando:hover {
  background-color: #6C5C05;
  color: white;
}
.carrito-vacio {
  margin: 100px auto;
  max-width: 800px;
  padding: 110px 110px;
  background-color: rgba(255, 255, 255, 0.75);
  border-radius: 16px;
  font-size: 22px;
  font-weight: bold;
  color: #6C5C05;
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 12px rgba(108, 92, 5, 0.2);
}


.carrito-resumen {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background-color: rgba(255, 255, 255, 0.8);
  border: 2px solid #6C5C05;
  border-radius: 12px;
  padding: 20px;
  margin-top: 30px;
  font-size: 20px;
  font-weight: bold;
  color: #6C5C05;
}

.resumen-subtotal {
  text-align: left;
}

.resumen-total {
  text-align: right;
}

.ir-a-pagar {
  padding: 10px 24px;
  border: 2px solid #6C5C05;
  border-radius: 8px;
  color: white;
  background-color: #6C5C05;
  text-decoration: none;
  font-weight: bold;
  margin-left: 20px;
  transition: 0.3s;
}

.ir-a-pagar:hover {
  background-color: #7a6b05;
  border-color: #7a6b05;
}
</style>
