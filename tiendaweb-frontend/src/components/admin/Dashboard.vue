<template>
  <div class="dashboard-container">
    <DashbordAdmin />
    <div class="stats-container">
      <h2 class="titulo">Estadísticas de Ventas</h2>
      
      <div class="stats-grid">
        <!-- Tarjeta de Total Vendido -->
        <div class="stat-card">
          <div class="stat-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <line x1="12" y1="1" x2="12" y2="23"></line>
              <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
            </svg>
          </div>
          <div class="stat-content">
            <h3>Total Vendido</h3>
            <p>${{ datos.totalVendido }}</p>
          </div>
        </div>
        
        <!-- Tarjeta de Pedidos Listos -->
        <div class="stat-card">
          <div class="stat-icon">
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
              <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07 19.5 19.5 0 0 1-6-6 19.79 19.79 0 0 1-3.07-8.67A2 2 0 0 1 4.11 2h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L8.09 9.91a16 16 0 0 0 6 6l1.27-1.27a2 2 0 0 1 2.11-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"></path>
              <polyline points="14.05 2 14.05 8 20.05 8"></polyline>
            </svg>
          </div>
          <div class="stat-content">
            <h3>Pedidos Listos</h3>
            <p>{{ datos.totalPedidosListos }}</p>
          </div>
        </div>
      </div>
      
      <!-- Gráfico de Productos Más Vendidos -->
      <div class="chart-section">
        <h3>Productos Más Vendidos</h3>
        <div class="chart-container">
          <div v-for="(producto, index) in datos.productosMasVendidos" :key="index" class="bar-item">
            <div class="bar-label">{{ producto.nombre_producto }}</div>
            <div class="bar-container">
              <div 
                class="bar-fill" 
                :style="{ width: calcularPorcentaje(producto.total_vendido) + '%' }"
              ></div>
              <span class="bar-value">{{ producto.total_vendido }}</span>
            </div>
          </div>
        </div>
      </div>
      
      <!-- Gráfico de Comparación de Entregas - Versión Mejorada -->
      <div class="chart-section">
        <h3>Distribución de Tipos de Entrega</h3>
        <div class="delivery-chart-container">
          <!-- Gráfico de barras horizontales mejorado -->
          <div class="delivery-bars">
            <div 
              v-for="(entrega, index) in datos.comparacionEntrega" 
              :key="index"
              class="delivery-bar-item"
            >
              <div class="delivery-label">
                <span class="delivery-type">{{ entrega.tipo_entrega }}</span>
                <span class="delivery-count">{{ entrega.cantidad }} ({{ Math.round(calcularPorcentajeEntrega(entrega.cantidad)) }}%)</span>
              </div>
              <div class="delivery-bar-container">
                <div 
                  class="delivery-bar-fill"
                  :style="{ 
                    width: calcularPorcentajeEntrega(entrega.cantidad) + '%',
                    backgroundColor: getDeliveryColor(index)
                  }"
                >
                  <span class="delivery-value">{{ entrega.cantidad }}</span>
                </div>
              </div>
            </div>
          </div>
          
          <!-- Resumen estadístico -->
          <div class="delivery-summary">
            <div class="summary-card">
              <div class="summary-title">Total Entregas</div>
              <div class="summary-value">
                {{ getTotalDeliveries() }}
              </div>
            </div>
            <div class="summary-card">
              <div class="summary-title">Tipo más usado</div>
              <div class="summary-value">
                {{ getMostUsedDeliveryType().type }}
                <span class="summary-percent">
                  ({{ Math.round(getMostUsedDeliveryType().percent) }}%)
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

const datos = ref({
  totalVendido: "0.00",
  totalPedidosListos: 0,
  productosMasVendidos: [],
  comparacionEntrega: []
})

// Obtener datos del dashboard
const obtenerDatosDashboard = async () => {
  try {
    const res = await api.get('/dashboard')
    datos.value = res.data
  } catch (err) {
    console.error('Error al obtener datos del dashboard:', err)
  }
}

// Calcular porcentaje para las barras
const calcularPorcentaje = (valor) => {
  const max = Math.max(...datos.value.productosMasVendidos.map(p => parseInt(p.total_vendido)))
  return (parseInt(valor) / max) * 100
}

// Calcular porcentaje para el gráfico de entregas
const calcularPorcentajeEntrega = (valor) => {
  const total = getTotalDeliveries()
  return total > 0 ? (valor / total) * 100 : 0
}

// Obtener color según el tipo de entrega
const getDeliveryColor = (index) => {
  const colors = ['#6b8f71', '#5c7b9d', '#f4a261', '#2a9d8f', '#e76f51']
  return colors[index % colors.length]
}

// Obtener total de entregas
const getTotalDeliveries = () => {
  return datos.value.comparacionEntrega.reduce((sum, item) => sum + item.cantidad, 0)
}

// Obtener el tipo de entrega más usado
const getMostUsedDeliveryType = () => {
  if (datos.value.comparacionEntrega.length === 0) {
    return { type: 'N/A', percent: 0 }
  }
  
  const max = Math.max(...datos.value.comparacionEntrega.map(e => e.cantidad))
  const mostUsed = datos.value.comparacionEntrega.find(e => e.cantidad === max)
  const percent = (max / getTotalDeliveries()) * 100
  
  return { type: mostUsed.tipo_entrega, percent }
}

onMounted(() => {
  obtenerDatosDashboard()
})
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

.stats-container {
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
  margin-bottom: 1.5rem;
  color: #2f3e44;
  border-bottom: 2px solid #6b8f71;
  padding-bottom: 0.4rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  display: flex;
  align-items: center;
  background: #f8f9fa;
  border-radius: 10px;
  padding: 1.5rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.stat-icon {
  background: #6b8f71;
  width: 50px;
  height: 50px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-right: 1rem;
  color: white;
}

.stat-icon svg {
  width: 24px;
  height: 24px;
}

.stat-content h3 {
  font-size: 0.9rem;
  font-weight: 500;
  color: #6c757d;
  margin-bottom: 0.3rem;
}

.stat-content p {
  font-size: 1.5rem;
  font-weight: 600;
  color: #2f3e44;
  margin: 0;
}

.chart-section {
  margin-bottom: 2.5rem;
  background: #f8f9fa;
  padding: 1.5rem;
  border-radius: 10px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.chart-section h3 {
  font-size: 1.1rem;
  font-weight: 600;
  color: #2f3e44;
  margin-bottom: 1rem;
}

.chart-container {
  margin-top: 1rem;
}

.bar-item {
  margin-bottom: 1rem;
}

.bar-label {
  font-size: 0.85rem;
  margin-bottom: 0.3rem;
  color: #495057;
}

.bar-container {
  display: flex;
  align-items: center;
  width: 100%;
}

.bar-fill {
  height: 20px;
  background: #6b8f71;
  border-radius: 4px;
  transition: width 1s ease;
}

.bar-value {
  margin-left: 10px;
  font-size: 0.8rem;
  color: #6c757d;
}

/* Estilos para el nuevo gráfico de entregas */
.delivery-chart-container {
  display: flex;
  flex-wrap: wrap;
  gap: 2rem;
  margin-top: 1.5rem;
}

.delivery-bars {
  flex: 1;
  min-width: 300px;
}

.delivery-bar-item {
  margin-bottom: 1.5rem;
}

.delivery-label {
  display: flex;
  justify-content: space-between;
  margin-bottom: 0.5rem;
  font-size: 0.9rem;
}

.delivery-type {
  font-weight: 600;
  color: #2f3e44;
}

.delivery-count {
  color: #6c757d;
  font-weight: 500;
}

.delivery-bar-container {
  height: 28px;
  background-color: #e9ecef;
  border-radius: 14px;
  overflow: hidden;
  position: relative;
  box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);
}

.delivery-bar-fill {
  height: 100%;
  border-radius: 14px;
  transition: width 1s ease;
  display: flex;
  align-items: center;
  justify-content: flex-end;
  padding-right: 12px;
  min-width: 50px;
  position: relative;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.delivery-value {
  color: white;
  font-size: 0.8rem;
  font-weight: 600;
  text-shadow: 0 1px 2px rgba(0,0,0,0.3);
}

.delivery-summary {
  flex: 0 0 250px;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.summary-card {
  background: white;
  border-radius: 10px;
  padding: 1.2rem;
  box-shadow: 0 2px 8px rgba(0,0,0,0.08);
}

.summary-title {
  font-size: 0.85rem;
  color: #6c757d;
  margin-bottom: 0.5rem;
}

.summary-value {
  font-size: 1.3rem;
  font-weight: 600;
  color: #2f3e44;
}

.summary-percent {
  font-size: 0.9rem;
  color: #6b8f71;
  font-weight: 500;
  margin-left: 0.3rem;
}

@media (max-width: 768px) {
  .stats-grid {
    grid-template-columns: 1fr;
  }
  
  .delivery-chart-container {
    flex-direction: column;
  }
  
  .delivery-bars {
    width: 100%;
  }
  
  .delivery-summary {
    flex-direction: row;
    flex-wrap: wrap;
    width: 100%;
  }
  
  .summary-card {
    flex: 1 1 calc(50% - 0.5rem);
    min-width: 0;
  }
}

</style>