<template>
  <div class="dashboard-container">
    <DashbordAdmin />

    <div class="categoria-container">
      <h2 class="titulo">Historial de Pedidos Listos</h2>

      <form @submit.prevent="consultarHistorial" class="formulario-compra">
        <fieldset>
          <label for="pedidoID">ID del Pedido =</label>
          <input
            id="pedidoID"
            type="number"
            v-model.number="pedidoID"
            placeholder="ID del pedido"
            class="campo"
            min="1"
          />
        </fieldset>

        <fieldset>
          <label for="nombreCliente">Nombre = </label>
          <input
            id="nombreCliente"
            type="text"
            v-model.trim="nombreCliente"
            placeholder="Nombre del cliente"
            class="campo"
          />
        </fieldset>

        <button type="submit" class="btn-guardar">Consultar</button>
      </form>

      <div class="resultados-container">
        <div v-if="pedidosAgrupados.length">
          <div
            v-for="pedido in pedidosAgrupados"
            :key="pedido.pedido_ID"
            class="compra-bloque"
          >
            <div class="resumen-compra">
              <p><strong>Pedido ID:</strong> {{ pedido.pedido_ID }}</p>
              <p><strong>Cliente:</strong> {{ pedido.nombre_cliente }} {{ pedido.apellido_cliente }}</p>
              <p><strong>Total:</strong> {{ formatMoneda(pedido.total) }}</p>
              <p><strong>Fecha:</strong> {{ formatFecha(pedido.fecha) }}</p>
            </div>

            <table class="tabla-productos">
              <thead>
                <tr>
                  <th>Producto</th>
                  <th>Cantidad</th>
                  <th>Precio</th>
                  <th>Subtotal</th>
                </tr>
              </thead>
              <tbody>
                <tr
                  v-for="detalle in pedido.detalles"
                  :key="detalle.nombre_producto + detalle.cantidad"
                >
                  <td>{{ detalle.nombre_producto }}</td>
                  <td>{{ detalle.cantidad }}</td>
                  <td>{{ formatMoneda(detalle.precio_unitario) }}</td>
                  <td>{{ formatMoneda(detalle.subtotal) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <p v-else class="error">No se encontraron pedidos listos con esos datos.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import DashbordAdmin from './DashbordAdmin.vue'
import api from '@/services/api'

const pedidoID = ref(null)
const nombreCliente = ref('')
const historial = ref([])
const pedidosAgrupados = ref([])

const consultarHistorial = async () => {
  try {
    const { data } = await api.get('/historial-pedidos', {
      params: {
        pedido_ID: pedidoID.value || null,
        nombre_cliente: nombreCliente.value || null
      }
    })

    historial.value = data.historial || []

    const agrupados = {}
    for (const item of historial.value) {
      if (!agrupados[item.pedido_ID]) {
        agrupados[item.pedido_ID] = {
          pedido_ID: item.pedido_ID,
          fecha: item.fecha,
          total: item.total_pedido,
          nombre_cliente: item.nombre_cliente,
          apellido_cliente: item.apellido_cliente,
          detalles: []
        }
      }

      agrupados[item.pedido_ID].detalles.push({
        nombre_producto: item.nombre_producto,
        cantidad: item.cantidad,
        precio_unitario: item.precio_unitario,
        subtotal: item.subtotal
      })
    }

    pedidosAgrupados.value = Object.values(agrupados)
  } catch (error) {
    console.error('Error al consultar historial:', error)
    historial.value = []
    pedidosAgrupados.value = []
  }
}

const formatFecha = (fecha) => {
  return new Date(fecha).toLocaleDateString('es-ES', {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}

const formatMoneda = (valor) => {
  return new Intl.NumberFormat('es-MX', {
    style: 'currency',
    currency: 'MXN'
  }).format(valor)
}
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
  background: #fff;
  border-radius: 10px;
  margin: 1rem;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}
.titulo {
  font-size: 1.4rem;
  font-weight: 600;
  margin-bottom: 1rem;
  color: #2f3e44;
  border-bottom: 2px solid #6b8f71;
  padding-bottom: 0.5rem;
}

.formulario-compra {
  max-width: 600px;
  margin-bottom: 2rem;
}
.formulario-compra fieldset {
  margin-bottom: 1rem;
  border: 1px solid #ccc;
  padding: 1rem;
}
.campo {
  flex: 1;
  padding: 8px 14px;
  min-width: 150px;
  border: 1.5px solid #ccc;
  border-radius: 6px;
  font-size: 0.80rem;
  margin: 0.1rem;
}
.campo:focus {
  border-color: #6b8f71;
  outline: none;
  box-shadow: 0 0 6px rgba(107, 143, 113, 0.3);
}

.btn-guardar {
  background: #6b8f71;
  color: #fff;
  border: none;
  border-radius: 6px;
  padding: 8px 16px;
  cursor: pointer;
}
.btn-guardar:hover {
  background: #58785e;
}

.resultados-container {
  margin-top: 2rem;
}
.compra-bloque {
  margin-bottom: 2rem;
  padding: 1rem;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: #fafafa;
}
.resumen-compra p {
  margin: 0.2rem 0;
}
.tabla-productos {
  width: 100%;
  margin-top: 1rem;
  border-collapse: collapse;
}
.tabla-productos th,
.tabla-productos td {
  border: 1px solid #ccc;
  padding: 6px 10px;
  text-align: left;
}
.tabla-productos th {
  background-color: #f0f0f0;
}

.error {
  color: #b04a3a;
  font-weight: 500;
  margin-top: 1rem;
}
</style>
