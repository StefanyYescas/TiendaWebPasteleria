<template>
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Gestión de Clientes</h2>

      <!-- Filtro con botón para limpiar -->
      <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
        <input
          v-model="filtro"
          type="text"
          placeholder="Buscar cliente..."
          class="campo"
          style="width: 100%;"
        />
        <button @click="filtro = ''" v-if="filtro" class="btn-cancelar">❌</button>
      </div>

      <!-- Selector para ordenar -->
      <div style="margin-bottom: 1rem;">
        <label for="ordenar">Ordenar por:</label>
        <select id="ordenar" v-model="orden" class="campo" style="width: 200px; margin-left: 0.5rem;">
          <option value="idAsc">ID Ascendente</option>
          <option value="idDesc">ID Descendente</option>
          <option value="nombreAsc">Nombre A-Z</option>
          <option value="nombreDesc">Nombre Z-A</option>
        </select>
      </div>

      <!-- Tabla de clientes -->
      <table class="tabla">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Teléfono</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="cliente in clientesOrdenados" :key="cliente.cliente_ID">
            <td>{{ cliente.cliente_ID }}</td>
            <td>{{ cliente.nombre_cliente }}</td>
            <td>{{ cliente.apellido_cliente }}</td>
            <td>{{ cliente.telefono }}</td>
            <td>
              <button @click="confirmarEliminar(cliente)" class="btn-eliminar">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Modal de confirmación -->
      <div v-if="mostrarModal" class="modal-overlay">
        <div class="modal">
          <p>{{ textoModal }}</p>
          <div class="modal-acciones">
            <button @click="confirmarAccion" class="btn-guardar">Sí</button>
            <button @click="cancelarAccion" class="btn-cancelar">Cancelar</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

// Estado
const clientes = ref([])
const filtro = ref('')
const orden = ref('idAsc')

const mensaje = ref('')
const mensajeClase = ref('')
const mostrarModal = ref(false)
const textoModal = ref('')
let accionPendiente = null

// Confirmación por modal
const confirmarAccion = async () => {
  mostrarModal.value = false
  if (accionPendiente) await accionPendiente()
  accionPendiente = null
}

const cancelarAccion = () => {
  mostrarModal.value = false
  accionPendiente = null
}

const confirmarConModal = (mensaje, accion) => {
  textoModal.value = mensaje
  accionPendiente = accion
  mostrarModal.value = true
}

// Obtener clientes desde la API
const obtenerClientes = async () => {
  try {
    const res = await api.get('/crud-clientes')
    clientes.value = res.data
  } catch (error) {
    mostrarMensaje('Error al obtener clientes', 'error')
  }
}

// Eliminar cliente
const confirmarEliminar = (cliente) => {
  confirmarConModal(`¿Seguro que deseas eliminar al cliente "${cliente.nombre_cliente}"?`, async () => {
    try {
      await api.delete(`/crud-clientes/${cliente.cliente_ID}`)
      obtenerClientes()
      mostrarMensaje('Cliente eliminado con éxito.', 'success')
    } catch (err) {
      mostrarMensaje('Error al eliminar el cliente.', 'error')
    }
  })
}

// Filtrado
const clientesFiltrados = computed(() => {
  const texto = filtro.value.toLowerCase()
  return clientes.value.filter(c =>
    c.nombre_cliente.toLowerCase().includes(texto) ||
    (c.apellido_cliente && c.apellido_cliente.toLowerCase().includes(texto)) ||
    (c.telefono && c.telefono.includes(texto))
  )
})

// Ordenamiento
const clientesOrdenados = computed(() => {
  const lista = [...clientesFiltrados.value]
  switch (orden.value) {
    case 'idAsc':
      return lista.sort((a, b) => a.cliente_ID - b.cliente_ID)
    case 'idDesc':
      return lista.sort((a, b) => b.cliente_ID - a.cliente_ID)
    case 'nombreAsc':
      return lista.sort((a, b) => a.nombre_cliente.localeCompare(b.nombre_cliente))
    case 'nombreDesc':
      return lista.sort((a, b) => b.nombre_cliente.localeCompare(a.nombre_cliente))
    default:
      return lista
  }
})

// Mensajes
const mostrarMensaje = (msg, tipo) => {
  mensaje.value = msg
  mensajeClase.value = tipo
  setTimeout(() => (mensaje.value = ''), 3000)
}

// Cargar al iniciar
onMounted(() => {
  obtenerClientes()
})
</script>
<style scoped>
.imagen-tabla {
  width: 50px;
  height: auto;
  object-fit: cover;
  border-radius: 4px;
}

.modal-overlay { 
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 9999;
  backdrop-filter: blur(3px);
  -webkit-backdrop-filter: blur(3px);
}

.modal {
  background: #fefefe;
  padding: 1.5rem 2rem;
  border-radius: 10px;
  max-width: 400px;
  width: 90%;
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
  text-align: center;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  font-size: 0.85rem;
  color: #3c3c3c;
  transition: transform 0.3s ease;
}

.modal:hover {
  transform: translateY(-3px);
}

.modal-acciones {
  display: flex;
  justify-content: center;
  gap: 1rem;
  margin-top: 1.2rem;
}

.btn-guardar,
.btn-cancelar {
  padding: 8px 20px;
  border: none;
  cursor: pointer;
  font-weight: 500;
  border-radius: 6px;
  font-size: 0.8rem;
  box-shadow: 0 3px 6px rgba(0,0,0,0.08);
  user-select: none;
}

.btn-guardar {
  background-color: #6b8f71;
  color: #fdfdfd;
}

.btn-guardar:hover {
  background-color: #58785e;
}

.btn-cancelar {
  background-color: #dcdcdc;
  color: #555;
}

.btn-cancelar:hover {
  background-color: #c5c5c5;
}

.dashboard-container {
  display: flex;
  min-height: 100vh;
  background: #f2f2f0;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  font-size: 0.85rem;
  color: #444;
}

.categoria-container {
  flex: 1;
  padding: 2rem;
  background-color: #fff;
  border-radius: 10px;
  margin: 1.5rem;
  box-shadow: 0 4px 12px rgba(0,0,0,0.05);
}

.titulo {
  font-size: 1.4rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #2f3e44;
  border-bottom: 2px solid #6b8f71;
  padding-bottom: 0.4rem;
}

.formulario {
  display: flex;
  gap: 0.8rem;
  flex-wrap: wrap;
  margin-bottom: 1.5rem;
}

.campo {
  flex: 1;
  padding: 10px 14px;
  min-width: 200px;
  border: 1.5px solid #ccc;
  border-radius: 6px;
  font-size: 0.85rem;
  transition: border-color 0.3s ease;
  font-family: inherit;
}

.campo:focus {
  border-color: #6b8f71;
  outline: none;
  box-shadow: 0 0 6px rgba(107, 143, 113, 0.3);
}

.campo.error {
  border-color: #b04a3a;
  animation: shake 0.3s ease;
}

@keyframes shake {
  0%, 100% { transform: translateX(0) }
  20%, 60% { transform: translateX(-4px) }
  40%, 80% { transform: translateX(4px) }
}

.acciones-formulario {
  display: flex;
  gap: 0.8rem;
  align-items: center;
}

.tabla {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.85rem;
}

.tabla th,
.tabla td {
  border: 1px solid #ddd;
  padding: 10px 12px;
  text-align: left;
  vertical-align: middle;
}

.tabla th {
  background-color: #f2f4f3;
  font-weight: 600;
  color: #3a4a4f;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.tabla tbody tr:hover {
  background-color: #eef3ee;
  transition: background-color 0.3s ease;
}

.btn-editar,
.btn-eliminar {
  border: none;
  padding: 6px 10px;
  border-radius: 5px;
  font-size: 0.8rem;
  color: white;
  font-weight: 500;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.3s ease;
  margin-right: 5px;
}

.btn-editar {
  background-color: #5c7b9d;
}

.btn-editar:hover {
  background-color: #46617f;
}

.btn-eliminar {
  background-color: #a8534c;
}

.btn-eliminar:hover {
  background-color: #843e37;
}

.success {
  color: #5d9262;
  font-weight: 500;
}

.error {
  color: #b04a3a;
  font-weight: 500;
}

.info {
  color: #7d8b8c;
  font-weight: 500;
}
</style>