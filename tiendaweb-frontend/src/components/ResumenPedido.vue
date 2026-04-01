<template>
  <div class="resumen-container" v-if="carrito.productos.length > 0">
    <div class="resumen-header" @click="toggleResumen">
      <span class="titulo">Resumen del pedido</span>
      <span class="subtotal">Total: ${{ subtotal }}</span>
      <span class="flecha" :class="{ abierta: isAbierto }">&lt;</span>
    </div>

    <transition name="desplegar">
      <div v-if="isAbierto" class="resumen-pedido">
        <div class="producto" v-for="item in carrito.productos" :key="item.producto_ID">
          <div class="imagen-container">
            <img :src="item.imagen_url" alt="producto" class="resumen-img" />
            <span class="cantidad-circulo">{{ item.cantidad }}</span>
          </div>
          <div class="info">
            <div class="info-row">
              <p class="nombre">{{ item.nombre_producto }}</p>
              <p class="total">${{ (item.precio * item.cantidad).toFixed(2) }}</p>
            </div>
          </div>
        </div>

        <hr />
        <p class="subtotal-detalle">Subtotal: ${{ subtotal }}</p>

        <div class="info-preparacion">
          <strong>Tiempo de preparación: 30 minutos</strong>
          <p>Se te solicitará mostrar una identificación oficial.</p>
        </div>
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useCarritoStore } from '@/stores/carrito'

const carrito = useCarritoStore()
const isAbierto = ref(false)

function toggleResumen() {
  isAbierto.value = !isAbierto.value
}

const subtotal = computed(() =>
  carrito.productos.reduce((acc, item) => acc + item.precio * item.cantidad, 0).toFixed(2)
)
</script>

<style scoped>
.resumen-container {
  max-width: 600px;
  margin: 2rem auto;
  border-radius: 10px;
  background: #f5f5f5; /* fondo claro neutro */
  border: 1px solid #ccc;
  color: #333;
  font-family: Arial, sans-serif;
  box-shadow: 0 2px 6px rgba(0,0,0,0.1);
}

.resumen-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  padding: 1rem 1.5rem;
  font-weight: 600;
  font-size: 1.1rem;
  user-select: none;
  color: #444;
  border-bottom: 1px solid #ccc;
}

.titulo {
  flex-grow: 1;
}

.subtotal {
  font-weight: 700;
  margin-right: 1rem;
  color: #555;
}

.flecha {
  font-weight: 700;
  font-size: 1.2rem;
  transition: transform 0.3s ease;
  color: #555;
  user-select: none;
}

.flecha.abierta {
  transform: rotate(-90deg);
}

.resumen-pedido {
  padding: 1rem 1.5rem 1.5rem 1.5rem;
}

.producto {
  display: flex;
  gap: 12px;
  margin-bottom: 1rem;
  align-items: center;
  background: #fff;
  padding: 0.6rem;
  border-radius: 6px;
  border: 1px solid #ddd;
}

.imagen-container {
  position: relative;
  width: 60px;
  height: 60px;
  flex-shrink: 0;
}

.resumen-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 6px;
  border: 1px solid #bbb;
}

.cantidad-circulo {
  position: absolute;
  top: -6px;
  right: -6px;
  background-color: #777;
  color: white;
  font-size: 0.7rem;
  padding: 3px 6px;
  border-radius: 50%;
  font-weight: bold;
}

.info {
  flex-grow: 1;
}

.info-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.nombre {
  font-weight: 600;
  font-size: 1rem;
  color: #333;
  margin: 0;
}

.total {
  font-weight: 600;
  font-size: 1rem;
  color: #666;
  margin: 0;
}

.subtotal-detalle {
  font-weight: 700;
  font-size: 1.1rem;
  text-align: right;
  margin-top: 1rem;
  color: #444;
  border-top: 1px solid #ccc;
  padding-top: 0.5rem;
}

.info-preparacion {
  margin-top: 1.5rem;
  padding: 1rem 1.5rem;
  background: #eee;
  border-left: 4px solid #999;
  border-radius: 8px;
  color: #555;
  font-size: 0.95rem;
}

.info-preparacion strong {
  color: #333;
  display: block;
  margin-bottom: 0.3rem;
}

.info-preparacion p {
  margin: 0;
}

/* Animación para el despliegue */
.desplegar-enter-active,
.desplegar-leave-active {
  transition: all 0.3s ease;
}
.desplegar-enter-from,
.desplegar-leave-to {
  max-height: 0;
  opacity: 0;
  padding: 0 1.5rem;
}
.desplegar-enter-to,
.desplegar-leave-from {
  max-height: 1000px;
  opacity: 1;
  padding: 1rem 1.5rem 1.5rem 1.5rem;
}
</style>
