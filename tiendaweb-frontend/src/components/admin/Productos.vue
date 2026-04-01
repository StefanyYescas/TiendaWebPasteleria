<template>
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Gestión de Productos</h2>

      <!-- Filtro con botón para limpiar -->
      <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
        <input
          v-model="filtro"
          type="text"
          placeholder="Buscar producto..."
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

      <!-- Formulario de producto -->
      <form @submit.prevent="guardarProducto" class="formulario" enctype="multipart/form-data">
        <input
          v-model="producto.nombre"
          type="text"
          placeholder="Nombre del producto"
          class="campo"
          :class="{ error: mostrarError && !producto.nombre }"
          required
        />
        <input
          v-model="producto.descripcion"
          type="text"
          placeholder="Descripción"
          class="campo"
        />
        <input
          v-model.number="producto.precio"
          type="number"
          placeholder="Precio"
          class="campo"
          required
        />
        <input
          v-model.number="producto.stock"
          type="number"
          placeholder="Stock"
          class="campo"
          required
        />
        <input
          type="file"
          @change="handleFileChange"
          accept="image/*"
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

      <!-- Tabla de productos -->
      <table class="tabla">
        <thead>
          <tr>
            <th>ID</th>
            <th>Nombre</th>
            <th>Descripción</th>
            <th>Precio</th>
            <th>Stock</th>
            <th>Imagen</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="prod in productosOrdenados" :key="prod.producto_ID">
            <td>{{ prod.producto_ID }}</td>
            <td>{{ prod.nombre }}</td>
            <td>{{ prod.descripcion }}</td>
            <td>\${{ prod.precio.toFixed(2) }}</td>
            <td>{{ prod.stock }}</td>
            <td>
              <img
                v-if="prod.imagen_url"
                :src="`/img/${prod.imagen_url}`"
                alt="Producto"
                class="imagen-tabla"
              />
              <span v-else>-</span>
            </td>
            <td>
              <button @click="editar(prod)" class="btn-editar">Editar</button>
              <button @click="eliminar(prod.producto_ID)" class="btn-eliminar">Eliminar</button>
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

const productos = ref([])

// Definición del objeto producto con los campos correctos de la API
const producto = reactive({
  nombre: '',
  descripcion: '',
  precio: null,
  stock: null,
  imagen: null,  // Para cargar la imagen en el formulario
  imagen_url: '',  // Para almacenar la URL de la imagen (de la API)
  categoria_ID: 1 // Puedes ajustar si gestionas categorías
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

// Modal
const confirmarAccion = async () => {
  mostrarModal.value = false
  if (accionPendiente) await accionPendiente()
  accionPendiente = null
}

const cancelarAccion = () => {
  mostrarModal.value = false
  accionPendiente = null
}

const confirmarConModal = (msg, accion) => {
  textoModal.value = msg
  accionPendiente = accion
  mostrarModal.value = true
}

// Computed: filtrado de productos
const productosFiltrados = computed(() => {
  const texto = filtro.value.toLowerCase()
  return productos.value.filter(p =>
    p.nombre.toLowerCase().includes(texto) ||
    (p.descripcion && p.descripcion.toLowerCase().includes(texto))
  )
})

// Computed: ordenamiento de productos
const productosOrdenados = computed(() => {
  const lista = [...productosFiltrados.value]
  console.log('Productos filtrados:', lista); // Debug: Verificar filtrado de productos
  switch (orden.value) {
    case 'idAsc': return lista.sort((a, b) => a.producto_ID - b.producto_ID)
    case 'idDesc': return lista.sort((a, b) => b.producto_ID - a.producto_ID)
    case 'nombreAsc': return lista.sort((a, b) => a.nombre.localeCompare(b.nombre))
    case 'nombreDesc': return lista.sort((a, b) => b.nombre.localeCompare(a.nombre))
    default: return lista
  }
})

// Función para obtener los productos
const obtenerProductos = async () => {
  try {
    const res = await api.get('/crud-productos')
    console.log('Productos recibidos:', res.data); // Debug: Verificar respuesta de la API
    productos.value = res.data.map(prod => ({
      producto_ID: prod.producto_ID,
      categoria_ID: prod.categoria_ID,
      nombre: prod.nombre_producto,  // Cambiado a nombre_producto de la API
      descripcion: prod.descripcion,
      precio: parseFloat(prod.precio),  // Asegurarse de que el precio es un número
      stock: prod.stock,
      imagen_url: prod.imagen_url,  // Cambiado a imagen_url de la API
    }))
  } catch (err) {
    mostrarMensaje('Error al obtener productos', 'error')
    console.error('Error al obtener productos:', err) // Debug: Verificar errores
  }
}

// Guardar producto
const guardarProducto = async () => {
  if (!producto.nombre.trim() || producto.precio == null || producto.stock == null) {
    mostrarError.value = true
    mostrarMensaje('Faltan campos obligatorios.', 'error')
    return
  }

  cargando.value = true
  const formData = new FormData()
  formData.append('nombre_producto', producto.nombre)
  formData.append('descripcion', producto.descripcion || '')
  formData.append('precio', producto.precio)
  formData.append('stock', producto.stock)
  formData.append('categoria_ID', producto.categoria_ID)
  if (producto.imagen) formData.append('imagen', producto.imagen_url)
  if (editando.value && producto.imagen_url) {
    formData.append('imagen_url', producto.imagen_url)
  }

  try {
    if (editando.value) {
      await api.put(`/crud-productos/${idEditando.value}`, formData)
      mostrarMensaje('Producto actualizado correctamente.', 'success')
    } else {
      await api.post('/crud-productos', formData)
      mostrarMensaje('Producto agregado correctamente.', 'success')
    }
    resetFormulario()
    obtenerProductos()
  } catch (err) {
    mostrarMensaje('Error al guardar el producto.', 'error')
  } finally {
    cargando.value = false
  }
}

// Editar producto
const editar = (prod) => {
  confirmarConModal(
    `¿Deseas editar el producto "${prod.nombre}"?`,
    () => {
      producto.nombre = prod.nombre
      producto.descripcion = prod.descripcion
      producto.precio = prod.precio
      producto.stock = prod.stock
      producto.categoria_ID = prod.categoria_ID
      producto.imagen_url = prod.imagen_url || ''
      producto.imagen = null // Reseteamos el input file
      idEditando.value = prod.producto_ID
      editando.value = true
    }
  )
}

// Cancelar edición
const cancelarEdicion = () => {
  resetFormulario()
  mostrarMensaje('Edición cancelada.', 'info')
}

// Eliminar producto
const eliminar = (id) => {
  const prod = productos.value.find(p => p.producto_ID === id)
  confirmarConModal(
    `¿Deseas eliminar el producto "${prod?.nombre}"?`,
    async () => {
      try {
        await api.delete(`/crud-productos/${id}`)
        obtenerProductos()
        mostrarMensaje('Producto eliminado.', 'success')
      } catch (err) {
        mostrarMensaje('Error al eliminar el producto.', 'error')
      }
    }
  )
}

// Manejar imagen
const handleFileChange = (e) => {
  const file = e.target.files[0]
  if (file) {
    producto.imagen = file
  }
}

// Reset form
const resetFormulario = () => {
  producto.nombre = ''
  producto.descripcion = ''
  producto.precio = null
  producto.stock = null
  producto.imagen = null
  producto.imagen_url = ''
  idEditando.value = null
  editando.value = false
  filtro.value = ''
}

// Mostrar mensaje
const mostrarMensaje = (msg, clase) => {
  mensaje.value = msg
  mensajeClase.value = clase
}

onMounted(() => {
  obtenerProductos()
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
