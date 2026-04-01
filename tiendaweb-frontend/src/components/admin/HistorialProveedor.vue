<template>
  <div class="dashboard-container">
    <DashbordAdmin />

    <div class="categoria-container">
      <h2 class="titulo">Historial de Compras por Proveedor</h2>

      <form @submit.prevent="consultarHistorial" class="formulario-compra">
        <fieldset>
          <label for="proveedorID">ID =</label>
          <input
            id="proveedorID"
            type="number"
            v-model.number="proveedorID"
            placeholder=" ID del proveedor"
            class="campo"
            min="1"
          />
        </fieldset>

        <fieldset>
          <label for="nombreProveedor">Nombre = </label>
          <input
            id="nombreProveedor"
            type="text"
            v-model.trim="nombreProveedor"
            placeholder="Nombre del proveedor"
            class="campo"
          />
        </fieldset>

        <button type="submit" class="btn-guardar">Consultar</button>
      </form>

      <div class="resultados-container">
        <div v-if="comprasAgrupadas.length">
          <div
            v-for="compra in comprasAgrupadas"
            :key="compra.compra_ID"
            class="compra-bloque"
          >
            <div class="resumen-compra">
              <p><strong>Compra ID:</strong> {{ compra.compra_ID }}</p>
              <p><strong>Proveedor:</strong> {{ compra.nombre_proveedor }} {{ compra.apellido_proveedor }}</p>
              <p><strong>Método de Pago:</strong> {{ compra.metodo_pago }}</p>
              <p><strong>Total Compra:</strong> {{ formatMoneda(compra.total_compra) }}</p>
              <p><strong>Fecha:</strong> {{ formatFecha(compra.fecha) }}</p>
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
                  v-for="detalle in compra.detalles"
                  :key="detalle.nombre_producto + detalle.cantidad"
                >
                  <td>{{ detalle.nombre_producto }}</td>
                  <td>{{ detalle.cantidad }}</td>
                  <td>{{ formatMoneda(detalle.precio_prove) }}</td>
                  <td>{{ formatMoneda(detalle.subtotal) }}</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>

        <p v-else class="error">
          No se encontraron compras para este proveedor.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import DashbordAdmin from './DashbordAdmin.vue'
import api from '@/services/api'

const proveedorID = ref(null)
const nombreProveedor = ref('')
const historial = ref([])
const comprasAgrupadas = ref([])

const consultarHistorial = async () => {
  try {
    const { data } = await api.get('/historial-proveedores', {
      params: {
        proveedor_ID: proveedorID.value || null,
        nombre: nombreProveedor.value || null
      }
    })
    historial.value = data.historial || []

    const agrupadas = {}
    for (const item of historial.value) {
      if (!agrupadas[item.compra_ID]) {
        agrupadas[item.compra_ID] = {
          compra_ID: item.compra_ID,
          nombre_proveedor: item.nombre_proveedor,
          apellido_proveedor: item.apellido_proveedor,
          metodo_pago: item.metodo_pago,
          fecha: item.fecha,
          total_compra: item.total_compra,
          detalles: []
        }
      }
      agrupadas[item.compra_ID].detalles.push({
        nombre_producto: item.nombre_producto,
        cantidad: item.cantidad,
        precio_prove: item.precio_prove,
        subtotal: item.subtotal
      })
    }

    comprasAgrupadas.value = Object.values(agrupadas)
  } catch (error) {
    console.error('Error al obtener historial:', error)
    historial.value = []
    comprasAgrupadas.value = []
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
