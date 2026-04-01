<template>
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="categoria-container">
      <h2 class="titulo">Reporte de Ventas por Día(Filtro por listo)</h2>

      <!-- Filtros -->
      <div class="formulario">
        <select v-model="filtroEntrega" class="campo">
          <option value="">Todos los tipos de entrega</option>
          <option value="domicilio">Domicilio</option>
          <option value="local">Local</option>
        </select>

        <input type="date" v-model="fechaInicio" class="campo" placeholder="Fecha inicio" />
        <input type="date" v-model="fechaFin" class="campo" placeholder="Fecha fin" />
      </div>

      <!-- Tabla de reporte -->
      <table class="tabla">
        <thead>
          <tr>
            <th>Fecha</th>
            <th>Tipo Entrega</th>
            <th>Pedidos</th>
            <th>Productos Vendidos</th>
            <th>Total Ventas</th>
            <th>Promedio por Pedido</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="venta in ventas" :key="venta.fecha_venta + venta.tipo_entrega">
            <td>{{ venta.fecha_venta }}</td>
            <td>{{ venta.tipo_entrega }}</td>
            <td>{{ venta.total_pedidos }}</td>
            <td>{{ venta.total_productos_vendidos }}</td>
            <td>${{ Number(venta.total_ventas || 0).toFixed(2) }}</td>
            <td>${{ Number(venta.promedio_venta_por_pedido || 0).toFixed(2) }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, watch, onMounted } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

const ventas = ref([])
const filtroEntrega = ref('')
const fechaInicio = ref('')
const fechaFin = ref('')

const obtenerVentas = async () => {
  try {
    const params = {}

    if (filtroEntrega.value) params.tipo_entrega = filtroEntrega.value
    if (fechaInicio.value) params.fecha_inicio = fechaInicio.value
    if (fechaFin.value) params.fecha_fin = fechaFin.value

    const res = await api.get('/ventas-dia', { params })
    console.log('Datos recibidos:', res.data.reporte) // Para debug
    ventas.value = res.data.reporte || []
  } catch (err) {
    console.error('Error al obtener el reporte:', err)
  }
}

// Recargar datos cada vez que cambien los filtros
watch([filtroEntrega, fechaInicio, fechaFin], obtenerVentas)
onMounted(obtenerVentas)
</script>

<style scoped>
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
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
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
</style>
