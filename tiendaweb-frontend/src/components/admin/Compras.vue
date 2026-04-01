<template> 
  <div class="dashboard-container">
    <DashbordAdmin />

    <div class="categoria-container">
      <h2 class="titulo">Registrar nueva compra</h2>

      <form @submit.prevent="registrarCompra" class="formulario-compra">
        <fieldset>
          <legend>Datos del proveedor</legend>
          <input v-model="proveedor.nombre_proveedor" placeholder="Nombre" class="campo" />
          <input v-model="proveedor.apellido_proveedor" placeholder="Apellido" class="campo" />
          <input v-model="proveedor.correo" type="email" placeholder="Correo" class="campo" />
          <input v-model="proveedor.telefono" placeholder="Teléfono (10 dígitos)" class="campo" />
          <input v-model="proveedor.direccion" placeholder="Dirección" class="campo" maxlength="100" />
        </fieldset>

        <fieldset>
          <legend>Compra</legend>
          <select v-model="metodo_pago" class="campo">
            <option disabled value="">Método de pago</option>
            <option value="transferencia">Transferencia</option>
            <option value="efectivo">Efectivo</option>
          </select>
          <input v-model="fecha_compra" type="date" class="campo" />
        </fieldset>

        <fieldset>
          <legend>Productos</legend>
          <div v-for="(producto, index) in productos" :key="index" class="producto-item">
            <input v-model.number="producto.producto_ID" type="number" min="1" placeholder="ID producto" class="campo" />
            <input v-model.number="producto.cantidad" type="number" min="1" placeholder="Cantidad" class="campo" />
            <input v-model.number="producto.precio_prove" type="number" min="0.01" step="0.01" placeholder="Precio proveedor" class="campo" />
            <button type="button" class="btn-eliminar" @click="eliminarProducto(index)">Eliminar</button>
          </div>
          <button type="button" class="btn-guardar" @click="agregarProducto">Agregar producto</button>
        </fieldset>

        <button type="submit" class="btn-guardar">Registrar compra</button>
        <p v-if="mensaje" :class="tipoMensaje">{{ mensaje }}</p>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '@/services/api'
import DashbordAdmin from './DashbordAdmin.vue'

const proveedor = ref({
  nombre_proveedor: '',
  apellido_proveedor: '',
  correo: '',
  telefono: '',
  direccion: ''
})
const metodo_pago = ref('')
const fecha_compra = ref('')
const productos = ref([{ producto_ID: null, cantidad: 1, precio_prove: 0.01 }])

const mensaje = ref('')
const tipoMensaje = ref('')

const agregarProducto = () =>
  productos.value.push({ producto_ID: null, cantidad: 1, precio_prove: 0.01 })

const eliminarProducto = (i) => productos.value.splice(i, 1)

const mostrarMensaje = (texto, tipo) => {
  mensaje.value = texto
  tipoMensaje.value = tipo
  setTimeout(() => {
    mensaje.value = ''
    tipoMensaje.value = ''
  }, 3000)
}

const limpiarFormulario = () => {
  proveedor.value = {
    nombre_proveedor: '',
    apellido_proveedor: '',
    correo: '',
    telefono: '',
    direccion: ''
  }
  metodo_pago.value = ''
  fecha_compra.value = ''
  productos.value = [{ producto_ID: null, cantidad: 1, precio_prove: 0.01 }]
}

const registrarCompra = async () => {
  try {
    const payload = {
      proveedor: { ...proveedor.value },
      metodo_pago: metodo_pago.value,
      fecha_compra: fecha_compra.value,
      productos: productos.value
    }
    const res = await api.post('/compra-completa', payload)
    mostrarMensaje(res.data.mensaje, 'success')
    limpiarFormulario()
  } catch (err) {
    mostrarMensaje(err.response?.data?.error || 'Error al registrar la compra', 'error')
  }
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
.producto-item {
  display: flex;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}
.producto-item input {
  flex: 1;
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
.btn-eliminar {
  background: #a8534c;
  color: #fff;
  border: none;
  border-radius: 6px;
  padding: 6px 12px;
  cursor: pointer;
}
.btn-eliminar:hover {
  background: #843e37;
}
.success {
  color: #5d9262;
  font-weight: 500;
  margin-top: 1rem;
}
.error {
  color: #b04a3a;
  font-weight: 500;
  margin-top: 1rem;
}
</style>
