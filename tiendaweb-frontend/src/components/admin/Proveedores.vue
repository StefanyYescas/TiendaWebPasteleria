<template>
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Gestión de Proveedores</h2>

      <!-- Filtro con botón para limpiar -->
      <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
        <input
          v-model="filtro"
          type="text"
          placeholder="Buscar proveedor..."
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

      <form @submit.prevent="guardarProveedor" class="formulario">
        <input
          v-model="proveedor.nombre_proveedor"
          type="text"
          placeholder="Nombre"
          class="campo"
          :class="{ error: mostrarError && !proveedor.nombre_proveedor }"
          required
        />
        <input
          v-model="proveedor.apellido_proveedor"
          type="text"
          placeholder="Apellido"
          class="campo"
        />
        <input
          v-model="proveedor.correo"
          type="email"
          placeholder="Correo"
          class="campo"
        />
        <input
          v-model="proveedor.telefono"
          type="text"
          placeholder="Teléfono"
          class="campo"
        />
        <input
          v-model="proveedor.direccion"
          type="text"
          placeholder="Dirección"
          class="campo"
        />
        <div class="acciones-formulario">
          <button type="submit" class="btn-guardar" :disabled="cargando">
            {{ editando ? 'Actualizar' : 'Agregar' }}
          </button>
          <button
            type="button"
            v-if="editando"
            @click="cancelarEdicion"
            class="btn-cancelar"
          >
            Cancelar
          </button>
        </div>
      </form>

      <p v-if="mensaje" :class="mensajeClase">{{ mensaje }}</p>

      <table class="tabla">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Apellido</th>
            <th>Correo</th>
            <th>Teléfono</th>
            <th>Dirección</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="prov in proveedoresOrdenados" :key="prov.proveedor_ID">
            <td>{{ prov.proveedor_ID }}</td>
            <td>{{ prov.nombre_proveedor }}</td>
            <td>{{ prov.apellido_proveedor }}</td>
            <td>{{ prov.correo }}</td>
            <td>{{ prov.telefono }}</td>
            <td>{{ prov.direccion }}</td>
            <td>
              <button @click="editar(prov)" class="btn-editar">Editar</button>
              <button @click="eliminar(prov.proveedor_ID)" class="btn-eliminar">Eliminar</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

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
</template>
<script setup> 
import { ref, reactive, onMounted, computed } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

const proveedores = ref([])
const proveedor = reactive({
  nombre_proveedor: '',
  apellido_proveedor: '',
  correo: '',
  telefono: '',
  direccion: ''
})
const editando = ref(false)
const idEditando = ref(null)
const mensaje = ref('')
const mensajeClase = ref('')
const mostrarError = ref(false)
const cargando = ref(false)
const filtro = ref('')
const orden = ref('idAsc')

const mostrarModal = ref(false)
const textoModal = ref('')
let accionPendiente = null

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

// Filtrado
const proveedoresFiltrados = computed(() => {
  const texto = filtro.value.toLowerCase()
  return proveedores.value.filter(p =>
    p.nombre_proveedor.toLowerCase().includes(texto) ||
    (p.apellido_proveedor && p.apellido_proveedor.toLowerCase().includes(texto)) ||
    (p.correo && p.correo.toLowerCase().includes(texto)) ||
    (p.telefono && p.telefono.toLowerCase().includes(texto)) ||
    (p.direccion && p.direccion.toLowerCase().includes(texto))
  )
})

// Ordenamiento
const proveedoresOrdenados = computed(() => {
  const lista = [...proveedoresFiltrados.value]
  switch (orden.value) {
    case 'idAsc':
      return lista.sort((a, b) => a.proveedor_ID - b.proveedor_ID)
    case 'idDesc':
      return lista.sort((a, b) => b.proveedor_ID - a.proveedor_ID)
    case 'nombreAsc':
      return lista.sort((a, b) => a.nombre_proveedor.localeCompare(b.nombre_proveedor))
    case 'nombreDesc':
      return lista.sort((a, b) => b.nombre_proveedor.localeCompare(a.nombre_proveedor))
    default:
      return lista
  }
})

const obtenerProveedores = async () => {
  try {
    const res = await api.get('/crud-proveedores')
    proveedores.value = res.data
  } catch (err) {
    mostrarMensaje('Error al obtener proveedores', 'error')
  }
}

const guardarProveedor = async () => {
  if (!proveedor.nombre_proveedor.trim()) {
    mostrarError.value = true
    mostrarMensaje('El nombre del proveedor es obligatorio.', 'error')
    return
  }

  cargando.value = true
  try {
    if (editando.value) {
      await api.put(`/crud-proveedores/${idEditando.value}`, proveedor)
      mostrarMensaje('Proveedor actualizado con éxito.', 'success')
    } else {
      await api.post('/crud-proveedores', proveedor)
      mostrarMensaje('Proveedor agregado con éxito.', 'success')
    }
    resetFormulario()
    obtenerProveedores()
  } catch (err) {
    mostrarMensaje('Error al guardar el proveedor.', 'error')
  } finally {
    cargando.value = false
  }
}

const editar = (p) => {
  confirmarConModal(
    `¿Seguro que deseas editar al proveedor "${p.nombre_proveedor}"?`,
    () => {
      proveedor.nombre_proveedor = p.nombre_proveedor
      proveedor.apellido_proveedor = p.apellido_proveedor
      proveedor.correo = p.correo
      proveedor.telefono = p.telefono
      proveedor.direccion = p.direccion
      idEditando.value = p.proveedor_ID
      editando.value = true
    }
  )
}

const cancelarEdicion = () => {
  resetFormulario()
  mostrarMensaje('Edición cancelada.', 'info')
}

const eliminar = (id) => {
  const p = proveedores.value.find(p => p.proveedor_ID === id)
  confirmarConModal(
    `¿Seguro que deseas eliminar al proveedor "${p?.nombre_proveedor}"?`,
    async () => {
      try {
        await api.delete(`/crud-proveedores/${id}`)
        obtenerProveedores()
        mostrarMensaje('Proveedor eliminado.', 'success')
      } catch (err) {
        mostrarMensaje('Error al eliminar el proveedor.', 'error')
      }
    }
  )
}

const resetFormulario = () => {
  proveedor.nombre_proveedor = ''
  proveedor.apellido_proveedor = ''
  proveedor.correo = ''
  proveedor.telefono = ''
  proveedor.direccion = ''
  idEditando.value = null
  editando.value = false
  mostrarError.value = false
}

const mostrarMensaje = (msg, tipo) => {
  mensaje.value = msg
  mensajeClase.value = tipo
  setTimeout(() => (mensaje.value = ''), 3000)
}

onMounted(() => {
  obtenerProveedores()
})
</script>
<style scoped>
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