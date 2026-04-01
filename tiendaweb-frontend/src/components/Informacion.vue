
<template>
  <CheckoutSteps :paso="2" />
  <div class="contenedor-principal">
    <!-- Formulario del cliente -->
    <div class="formulario-cliente">
      <h2>Datos del Cliente</h2>
      <form @submit.prevent="registrarCliente" class="formulario">
        <input v-model="nombre" type="text" placeholder="Nombres" required />
        <input v-model="apellido" type="text" placeholder="Apellidos" required />
        <input v-model="telefono" type="tel" placeholder="Teléfono" required />
        <input v-model="direccion" type="text" placeholder="Dirección" required />

        <label>
            <span>Tipo de entrega:</span>
              <select v-model="tipo_entrega" required>
              <option disabled value="">Selecciona tipo de entrega</option>
              <option value="local">Recoger en tienda</option>
              <option value="domicilio">Envío a domicilio</option>
            </select>
         </label>
         <input
          v-if="tipo_entrega === 'domicilio'"
          v-model="direccion_entrega"
          type="text"
          placeholder="Dirección de entrega"
          required
        />
         <div v-if="tipo_entrega === 'local'" class="info-recoleccion">
             <h4>SUCURSAL DE RECOLECCIÓN</h4>
               <p><strong>Sucursal Veracruz</strong> – Ruiz Cortínez número 7, Fracc. Costa Verde Boca del Río, Veracruz CP 94294</p>
               <p><strong>Horario:</strong> Lun a Dom de 07:00 a 21:30 hrs</p>
               <p><strong>Tel:</strong> 229 100 2340</p>
          </div>
         <label>
            <span>Tipo de pago:</span>
               <select v-model="tipo_pago" required>
               <option disabled value="">Selecciona tipo de pago</option>
               <option value="efectivo">Efectivo</option>
               <option value="transferencia">Transferencia</option>
            </select>
          </label>
        
        <button type="submit">Pagar</button>
        <p v-if="mensaje" :class="mensajeClass">{{ mensaje }}</p>
      </form>
    </div>

    <!-- Resumen del pedido -->
    <div class="resumen-container">
      <div class="resumen-header" @click="toggleResumen">
        <h2>Resumen del pedido</h2>
        <span class="subtotal-text">Total: ${{ subtotal }}</span>
        <svg
          class="flecha"
          :class="{ abierto: mostrarResumen }"
          width="20"
          height="20"
          viewBox="0 0 24 24"
        >
          <path
            d="M6 9l6 6 6-6"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            stroke-linecap="round"
            stroke-linejoin="round"
          />
        </svg>
      </div>

      <transition name="fade">
        <div v-if="mostrarResumen || isDesktop" class="resumen-pedido">
          <div class="producto" v-for="item in carrito.productos" :key="item.producto_ID">
            <div class="imagen-container">
              <img :src="item.imagen_url" alt="producto" class="resumen-img" />
              <span class="cantidad-circulo">{{ item.cantidad }}</span>
            </div>
            <div class="info">
              <div class="info-row">
                <p class="nombre">{{ item.nombre_producto }}</p>
                <p class="total"> ⇾ ${{ (item.precio * item.cantidad).toFixed(2) }}</p>
              </div>
            </div>
              </div>

          <hr />
          <p class="subtotal">Subtotal: ${{ subtotal }}</p>

          <div class="info-preparacion">
            <strong>⏱ Tiempo de preparación: 30 minutos</strong>
            <p>Se te solicitará mostrar una identificación oficial</p>
          </div>
        </div>
      </transition>
    </div>  
  </div>
</template>
<script setup>
import CheckoutSteps from '@/components/CheckoutSteps.vue'
import { ref, computed, onMounted, onBeforeUnmount } from 'vue'
import { useCarritoStore } from '@/stores/carrito'
import { useUsuarioStore } from '@/stores/usuario'
import { useRouter } from 'vue-router'
import api from '@/services/api'

const carrito = useCarritoStore()
const usuarioStore = useUsuarioStore()
const router = useRouter()

// Datos del formulario
const nombre = ref('')
const apellido = ref('')
const telefono = ref('')
const direccion = ref('')
const tipo_entrega = ref('') // Valor por defecto
const direccion_entrega = ref('')
const tipo_pago = ref('')
const mensaje = ref('')
const mensajeClass = ref('')
const isLoading = ref(false)

// Control del resumen
const mostrarResumen = ref(true)
const isDesktop = ref(window.innerWidth >= 768)

// Calcula el subtotal
const subtotal = computed(() => 
  carrito.productos.reduce((acc, item) => acc + (item.precio * item.cantidad), 0).toFixed(2)
)

// Función para descargar el ticket
const descargarTicket = async (pedido_ID) => {
  try {
    const response = await api.get(`/ticket/${pedido_ID}`, {
      responseType: 'blob'
    })
    
    const blob = new Blob([response.data], { type: 'application/pdf' })
    const url = window.URL.createObjectURL(blob)
    const link = document.createElement('a')
    link.href = url
    link.download = `ticket_pedido_${pedido_ID}.pdf`
    link.click()
    window.URL.revokeObjectURL(url)
    
    return true
  } catch (error) {
    console.error('Error al descargar ticket:', error)
    return false
  }
}

// Función principal para registrar el cliente
const registrarCliente = async () => {
  mensaje.value = ''
  mensajeClass.value = ''
  isLoading.value = true

  // Validaciones básicas
  if (!usuarioStore.usuario?.id) {
    mensaje.value = 'Debes iniciar sesión para finalizar la compra.'
    mensajeClass.value = 'error'
    isLoading.value = false
    return
  }

  if (!nombre.value || !apellido.value || !telefono.value || !tipo_pago.value) {
    mensaje.value = 'Por favor completa todos los campos obligatorios.'
    mensajeClass.value = 'error'
    isLoading.value = false
    return
  }

  try {
    // Datos para enviar al backend
    const pedidoData = {
      usuario_ID: usuarioStore.usuario.id,
      cliente: {
        nombre_cliente: nombre.value.trim(),
        apellido_cliente: apellido.value.trim(),
        telefono: telefono.value.trim(),
        direccion: direccion.value.trim()
      },
      pedido: {
        tipo_entrega: tipo_entrega.value,
        direccion_entrega: tipo_entrega.value === 'domicilio' ? direccion_entrega.value.trim() : null,
        tipo_pago: tipo_pago.value,
        estado: 'pendiente',
      },
      productos: carrito.productos.map(p => ({
        producto_ID: p.producto_ID,
        cantidad: p.cantidad
      }))
    }

    // Enviar pedido al backend
    const res = await api.post('/pedido-completo', pedidoData)
    
    // Procesar respuesta exitosa
    if (res.data?.pedido_ID) {
      // Descargar ticket automáticamente
      const descargaExitosa = await descargarTicket(res.data.pedido_ID)
      if (descargaExitosa) {
        mensaje.value = 'Pedido completado. El ticket se ha descargado automáticamente.'
        mensajeClass.value = 'success'
      } else {
        mensaje.value = 'Pedido completado, pero hubo un problema al descargar el ticket.'
        mensajeClass.value = 'warning'
      }
      
      // Vaciar carrito y redirigir (opcional)
      carrito.vaciarCarrito()
      router.push('/ticket')
    }

  } catch (err) {
    console.error('Error al registrar pedido:', err)
    mensaje.value = err.response?.data?.error || 'Error al procesar el pedido'
    mensajeClass.value = 'error'
  } finally {
    isLoading.value = false
  }
}

// Manejo del responsive
const toggleResumen = () => {
  if (!isDesktop.value) mostrarResumen.value = !mostrarResumen.value
}

const handleResize = () => {
  isDesktop.value = window.innerWidth >= 768
  if (isDesktop.value) mostrarResumen.value = true
}

onMounted(() => {
  usuarioStore.cargarDesdeLocalStorage()
  window.addEventListener('resize', handleResize)
})

onBeforeUnmount(() => {
  window.removeEventListener('resize', handleResize)
})

</script>
<style scoped>
/* Contenedor general */
.contenedor-principal {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  margin: 2rem;
}

@media (min-width: 768px) {
  .contenedor-principal {
    flex-direction: row;
    align-items: flex-start;
  }
}

/* FORMULARIO CLIENTE */
.formulario-cliente {
  flex: 1;
  background: #ffffff;
  border: 1px solid #ddd;
  border-radius: 12px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
}

.formulario-cliente h2 {
  margin-bottom: 1rem;
  font-size: 1.4rem;
  color: #333;
}

.formulario input {
  width: 100%;
  padding: 0.45rem;
  margin-bottom: 0.9rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  transition: 0.2s ease;
}

.formulario input:focus {
  border-color: #888;
  outline: none;
}

.formulario button {
  background-color: #444;
  color: white;
  padding: 0.75rem 1.5rem;
  border: none;
  
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
}

/* RESUMEN */
.resumen-container {
  flex: 1;
  background: #f9f9f9;
  border: 1px solid #ddd;
  border-radius: 12px;
  padding: 1rem;
  position: relative;
}

.resumen-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  cursor: pointer;
  padding-bottom: 0.6rem;
  border-bottom: 1px solid #ccc;
}

.resumen-header h2 {
  margin: 0;
  font-size: 1.2rem;
  color: #333;
}

.subtotal-text {
  font-weight: bold;
  margin-left: auto;
  margin-right: 0.5rem;
  color: #222;
}

.flecha {
  transform: rotate(0deg);
  transition: transform 0.3s ease;
  color: #555;
}

.flecha.abierto {
  transform: rotate(180deg);
}

.resumen-pedido {
  margin-top: 1rem;
}

/* Producto */
.producto {
  display: flex;
  align-items: center;
  margin-bottom: 1rem;
  gap: 0.75rem;
}

.imagen-container {
  position: relative;
  width: 60px;
  height: 60px;
}

.resumen-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 6px;
}

.cantidad-circulo {
  position: absolute;
  top: -6px;
  right: -6px;
  background-color: #D5B813;
  color: white;
  font-size: 0.7rem;
  padding: 4px 7px;
  border-radius: 50%;
  font-weight: bold;
}

.info-row {
  flex-direction: flex-start;
  display: flex;
  justify-content: space-between;
}


.nombre {
  flex: 1;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-right: 0.5rem;
}

.total {
  display:flex;
  align-items: right;
  font-weight: bold;
  text-align: right;
}

/* Subtotal */
.subtotal {
  text-align: right;
  font-weight: bold;
  font-size: 1.2rem;
  margin-top: 1rem;
}

/* Info adicional */
.info-preparacion {
  background: #efefef;
  padding: 0.75rem;
  border-radius: 8px;
  margin-top: 1rem;
  font-size: 0.95rem;
  color: #444;
}

/* Transiciones */
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  max-height: 0;
  overflow: hidden;
}

.formulario label {
  display: block;
  margin-bottom: 0.9rem;
  font-weight: 500;
  color: #444;
}

.formulario select {
  width: 100%;
  padding: 0.55rem;
  border: 1px solid #ccc;
  border-radius: 8px;
  font-size: 1rem;
  margin-top: 0.4rem;
  transition: 0.2s ease;
}

.formulario select:focus {
  border-color: #b3aeae;
  outline: none;
}

.formulario button {
  width: 100%;
  background-color: #6C5C05; /* tu paleta */
  color: white;
  padding: 0.75rem 1rem;
  border: none;
  border-radius: 10px;
  font-size: 1.1rem;
  font-weight: bold;
  transition: background-color 0.3s ease;
  margin-top: 0.5rem;
}

.formulario button:hover {
  background-color: #6E2B1E;
}

/* Mensaje de estado */
.formulario p {
  margin-top: 0.8rem;
  font-size: 0.95rem;
  padding: 0.6rem 0.9rem;
  border-radius: 8px;
  font-weight: 500;
  text-align: center;
}

.success {
  background-color: #d4edda;
  color: #155724;
  border: 1px solid #c3e6cb;
}

.error {
  background-color: #f8d7da;
  color: #721c24;
  border: 1px solid #f5c6cb;
}

</style>
