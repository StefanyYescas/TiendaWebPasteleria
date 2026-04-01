<template> 
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Lista de pedidos ({{ estadoSeleccionado }})</h2>

      <div class="formulario">
        <select class="campo" v-model="estadoSeleccionado" @change="obtenerPedidos">
          <option value="pendiente">Pendientes</option>
          <option value="listo">Listos</option>
        </select>

        <input class="campo" type="text" placeholder="Buscar por cliente o estado" v-model="filtro" />

        <select class="campo" v-model="ordenSeleccionado">
          <option value="fecha">Ordenar por Fecha</option>
          <option value="pedido_ID">Ordenar por ID</option>
          <option value="cliente">Ordenar por Cliente</option>
        </select>
      </div>

      <table class="tabla">
        <thead>
          <tr>
            <th>ID</th>
            <th>Fecha</th>
            <th>Cliente</th>
            <th>Entrega</th>
            <th>Dirección</th>
            <th>Productos</th>
            <th>Total</th> <!-- ✅ Columna añadida -->
            <th>Estado</th>
            <th>Acciones</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="pedido in pedidosOrdenados" :key="pedido.pedido_ID">
            <td>{{ pedido.pedido_ID }}</td>
            <td>{{ formatoFecha(pedido.fecha) }}</td>
            <td>{{ pedido.nombre_cliente }} {{ pedido.apellido_cliente }}</td>
            <td>{{ pedido.tipo_entrega }}</td>
            <td>{{ pedido.direccion_entrega || '—' }}</td>
            <td>{{ pedido.productos }}</td>
            <td><strong>{{ pedido.total_pedido }}</strong></td> <!-- ✅ Total mostrado con formato -->
            <td>
              <span :class="pedido.estado === 'listo' ? 'success' : 'info'">
                {{ pedido.estado }}
              </span>
            </td>
            <td>
              <button
                v-if="pedido.estado === 'pendiente' && estadoSeleccionado === 'pendiente'"
                class="btn-editar"
                @click="cambiarEstado(pedido.pedido_ID)"
              >
                Marcar como listo
              </button>
              <span v-else>Entregado</span>
            </td>
          </tr>
        </tbody>
      </table>

      <p v-if="pedidosFiltrados.length === 0" class="info" style="margin-top: 1rem;">
        No hay pedidos con este filtro.
      </p>
    </div>
  </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

const pedidos = ref([])
const filtro = ref('')
const estadoSeleccionado = ref('pendiente')
const ordenSeleccionado = ref('fecha')

// Obtener pedidos desde la API
const obtenerPedidos = async () => {
  try {
    const res = await api.get(`/crud-pedidos/estado/${estadoSeleccionado.value}`)
    console.log('Pedidos recibidos:', res.data)
    
    pedidos.value = res.data.map(p => ({
      pedido_ID: p.pedido_ID,
      fecha: p.fecha,
      nombre_cliente: p.nombre_cliente || '',
      apellido_cliente: p.apellido_cliente || '',
      tipo_entrega: p.tipo_entrega || '',
      direccion_entrega: p.direccion_entrega || '',
      estado: p.estado || '',
      productos: p.productos || '',
      total_pedido: p.total_pedido || '—'
    }))
    
  } catch (err) {
    console.error('Error al obtener pedidos:', err)
  }
}

// Cambiar estado del pedido
const cambiarEstado = async (id) => {
  const pedido = pedidos.value.find(p => p.pedido_ID === id)
  if (!pedido) return

  const nuevoEstado = pedido.estado === 'pendiente' ? 'listo' : 'pendiente'

  try {
    await api.put(`/crud-pedidos/${id}/estado`, { nuevo_estado: nuevoEstado })
    pedido.estado = nuevoEstado // Actualiza localmente
  } catch (err) {
    console.error('Error al actualizar el estado del pedido:', err)
  }
}

// Filtrar los pedidos por texto
const pedidosFiltrados = computed(() => {
  const texto = filtro.value.toLowerCase()
  return pedidos.value.filter(p =>
    (p.nombre_cliente?.toLowerCase().includes(texto) || false) ||
    (p.apellido_cliente?.toLowerCase().includes(texto) || false) ||
    (p.estado?.toLowerCase().includes(texto) || false)
  )
})

// Ordenar los pedidos filtrados
const pedidosOrdenados = computed(() => {
  const copia = [...pedidosFiltrados.value]

  switch (ordenSeleccionado.value) {
    case 'fecha':
      return copia.sort((a, b) => new Date(b.fecha) - new Date(a.fecha))
    case 'pedido_ID':
      return copia.sort((a, b) => b.pedido_ID - a.pedido_ID)
    case 'cliente':
      return copia.sort((a, b) => {
        const nombreA = `${a.nombre_cliente} ${a.apellido_cliente}`.toLowerCase()
        const nombreB = `${b.nombre_cliente} ${b.apellido_cliente}`.toLowerCase()
        return nombreA.localeCompare(nombreB)
      })
    default:
      return copia
  }
})

// ✅ Formato de fecha con hora
const formatoFecha = (fecha) => {
  return new Date(fecha).toLocaleString('es-MX', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    hour12: true
  })
}

onMounted(() => {
  obtenerPedidos()
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