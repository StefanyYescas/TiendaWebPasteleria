<template> 
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Listado de Productos en Existencia (Filtrado y Ordenado)</h2>

      <!-- Filtro con botón para limpiar -->
      <div style="display: flex; gap: 0.5rem; margin-bottom: 1rem;">
        <input
          v-model="filtro"
          type="text"
          placeholder="Buscar producto, proveedor o categoría..."
          class="campo"
          style="width: 100%;"
        />
        <button @click="filtro = ''" v-if="filtro" class="btn-cancelar">❌</button>
      </div>

      <!-- Selector para ordenar -->
      <div style="margin-bottom: 1rem;">
        <label for="ordenar">Ordenar por:</label>
        <select id="ordenar" v-model="orden" class="campo" style="width: 250px; margin-left: 0.5rem;">
          <option value="nombreAsc">Nombre A-Z</option>
          <option value="nombreDesc">Nombre Z-A</option>
          <option value="stockAsc">Stock Ascendente</option>
          <option value="stockDesc">Stock Descendente</option>
          <option value="categoriaAsc">Categoría A-Z</option>
          <option value="categoriaDesc">Categoría Z-A</option>
          <option value="totalCompradoAsc">Total comprado Ascendente</option>
          <option value="totalCompradoDesc">Total comprado Descendente</option>
        </select>
      </div>

      <!-- Tabla de productos -->
      <table class="tabla">
        <thead>
          <tr>
            <th>Nombre del Producto</th>
            <th>Existencia</th>
            <th>Categoría</th>
            <th>Proveedor</th>
            <th>Total comprado</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="producto in productosFiltradosOrdenados" :key="producto.nombre_producto + producto.nombre_proveedor">
            <td>{{ producto.nombre_producto }}</td>
            <td>{{ producto.stock }}</td>
            <td>{{ producto.nombre_categoria }}</td>
            <td>{{ producto.nombre_proveedor }}</td>
            <td>{{ producto.total_comprado_al_proveedor }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

// Refs reactivas
const productos = ref([])
const filtro = ref('')
const orden = ref('nombreAsc')

// Obtener productos del backend
const obtenerProductos = async () => {
  try {
    const response = await api.get("/filtrados")
    console.log("Respuesta API:", response.data) // Debug
    if(response.data.success) {
      productos.value = response.data.data || []
    } else {
      productos.value = []
      console.warn("API respondió sin éxito", response.data)
    }
  } catch (error) {
    console.error("Error al obtener productos:", error)
    productos.value = []
  }
}

// Filtrado por texto (incluye nombre, proveedor y categoría)
const productosFiltrados = computed(() => {
  const texto = filtro.value.trim().toLowerCase()
  if (!texto) return productos.value
  return productos.value.filter(p =>
    p.nombre_producto?.toLowerCase().includes(texto) ||
    p.nombre_proveedor?.toLowerCase().includes(texto) ||
    p.nombre_categoria?.toLowerCase().includes(texto)
  )
})

// Ordenamiento dinámico
const productosFiltradosOrdenados = computed(() => {
  const copia = [...productosFiltrados.value]
  switch (orden.value) {
    case 'nombreAsc':
      return copia.sort((a, b) => a.nombre_producto.localeCompare(b.nombre_producto))
    case 'nombreDesc':
      return copia.sort((a, b) => b.nombre_producto.localeCompare(a.nombre_producto))
    case 'stockAsc':
      return copia.sort((a, b) => a.stock - b.stock)
    case 'stockDesc':
      return copia.sort((a, b) => b.stock - a.stock)
    case 'categoriaAsc':
      return copia.sort((a, b) => a.nombre_categoria.localeCompare(b.nombre_categoria))
    case 'categoriaDesc':
      return copia.sort((a, b) => b.nombre_categoria.localeCompare(a.nombre_categoria))
    case 'totalCompradoAsc':
      return copia.sort((a, b) => a.total_comprado_al_proveedor - b.total_comprado_al_proveedor)
    case 'totalCompradoDesc':
      return copia.sort((a, b) => b.total_comprado_al_proveedor - a.total_comprado_al_proveedor)
    default:
      return copia
  }
})

// Cargar al montar
onMounted(() => {
  console.log("Componente montado") 
  obtenerProductos()
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