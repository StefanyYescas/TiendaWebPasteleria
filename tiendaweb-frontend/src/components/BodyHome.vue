<template>
  <section class="popular-section">
    <div class="content">
      <h2 class="section-title-animate">NUESTROS POSTRES MAS VENDIDOS</h2>
      <div class="product-grid">
        <div
          v-for="(producto, index) in productosMasVendidos"
          :key="producto.producto_ID"
          class="product-card product-animate"
          :style="`animation-delay: ${index * 0.1}s`"
        >
          <img
            :src="producto.imagen_url"
            :alt="producto.nombre_producto"
            class="product-img"
          />
          <h3 class="product-name">{{ producto.nombre_producto }}</h3>
          <p class="product-description">{{ producto.descripcion }}</p>
          <p class="product-price">${{ producto.precio }}</p>

          <!-- Selector de cantidad -->
          <div class="cantidad-selector">
            <button @click="disminuirCantidad(producto.producto_ID)">−</button>
            <span>{{ cantidades[producto.producto_ID] || 1 }}</span>
            <button @click="incrementarCantidad(producto.producto_ID)">+</button>
          </div>

          <button class="btn-add-to-cart" @click="agregarAlCarrito(producto)">
            Agregar 🛒
          </button>
        </div>
      </div>

      <!-- Botón "Ordenar en línea" -->
      <div class="order-online">
       <router-link to="/ordenaaqui"> <button class="btn-order-online btn-animate">
          ORDENAR EN LÍNEA</button></router-link>
      </div>
      <div class="divider divider-animate"></div>

      <!-- Sección Historia de Fogo -->
      <div class="history-section">
        <div class="history-background"></div>
        <div class="history-content">
          <div class="text-column text-animate">
            <h2>La Historia de Fogo</h2>
            <p>
              Fundada el 29 de abril de 2023, la idea surgió con el propósito de apoyar a reposteros locales y acercar sabores artesanales a más familias veracruzanas. <br>
              Sus primeros pasos fueron a través de redes sociales, plataformas que que le permitieron conectar rápidamente con clientes que buscaban postres auténticos y frescos.
            </p>
          </div>
          <div class="images-column image-animate">
            <img src="@/assets/assetsbody/brownie_tec.png" alt="Brownies Fogo" class="history-img" />
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
<script setup>
import { ref, onMounted } from 'vue';
import api from '../services/api';
import { useCarritoStore } from '@/stores/carrito';

const carrito = useCarritoStore();
const productosMasVendidos = ref([]);
const cantidades = ref({});

onMounted(async () => {
  try {
    const response = await api.get('/mas-vendidos');
    productosMasVendidos.value = response.data;
    console.log(response.data.mensaje); 
    response.data.forEach(p => {
      cantidades.value[p.producto_ID] = 1;
    });
  } catch (error) {
    console.error('Error al obtener productos más vendidos:', error);
  }
});

function incrementarCantidad(productoID) {
  cantidades.value[productoID]++;
}

function disminuirCantidad(productoID) {
  if (cantidades.value[productoID] > 1) {
    cantidades.value[productoID]--;
  }
}

function agregarAlCarrito(producto) {
  const cantidad = cantidades.value[producto.producto_ID] || 1;
  carrito.agregarProducto({ ...producto, cantidad });
  carrito.guardarEnLocalStorage();
  alert(`Agregaste ${cantidad} ${producto.nombre_producto} al carrito`);
}
</script>
<style scoped>
.cantidad-selector {
  display: flex;
  align-items: center;
  gap: 10px;
  margin: 10px 0;
}

.cantidad-selector button {
  background: transparent;
  border: 2px solid #6c5c05;
  color: #6c5c05;
  font-size: 1.2rem;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
  font-weight: bold;
  transition: 0.2s;
}

.cantidad-selector button:hover {
  background-color: #6c5c05;
  color: white;
} 
.popular-section {
  background-color: #f5f5f5;
  padding: 60px 20px;
  text-align: center;
}

.content {
  max-width: 1200px;
  margin: 0 auto;
}

/* Animaciones */
.section-title-animate {
  animation: fadeInUp 0.8s ease-out forwards;
  opacity: 0;
  transform: translateY(20px);
}

.product-animate {
  animation: fadeInUp 0.8s ease-out forwards;
  opacity: 0;
  transform: translateY(20px);
}

.divider-animate {
  animation: fadeIn 1s ease-out 0.5s forwards;
  opacity: 0;
}

.btn-animate {
  animation: fadeIn 1s ease-out 0.3s forwards;
  opacity: 0;
}

.text-animate {
  animation: fadeInLeft 0.8s ease-out 0.2s forwards;
  opacity: 0;
  transform: translateX(-20px);
}

.image-animate {
  animation: fadeInRight 0.8s ease-out 0.4s forwards;
  opacity: 0;
  transform: translateX(20px);
}

@keyframes fadeInUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeInLeft {
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeInRight {
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

@keyframes fadeIn {
  to {
    opacity: 1;
  }
}

.content h2 {
  font-size: 2.5rem;
  margin-bottom: 40px;
  color: #333;
}

.product-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 24px;
}

.product-card {
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.08);
  padding: 24px;
  display: flex;
  flex-direction: column;
  align-items: center;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.product-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 20px rgba(0,0,0,0.12);
}

.product-img {
  width: 140px;
  height: 140px;
  object-fit: cover;
  border-radius: 50%;
  margin-bottom: 16px;
  transition: transform 0.3s ease;
}

.product-card:hover .product-img {
  transform: scale(1.05);
}

.product-name {
  font-size: 1.25rem;
  margin: 8px 0;
  color: #222;
  transition: color 0.3s ease;
}

.product-card:hover .product-name {
  color: #6c5c05;
}

.product-description {
  font-size: 1rem;
  color: #555;
  margin-bottom: 8px;
  min-height: 48px;
}

.product-price {
  font-size: 1.2rem;
  font-weight: bold;
  color: #6c5c05;
  margin-bottom: 16px;
}

.btn-add-to-cart {
  background-color: #6c5c05;
  border: none;
  border-radius: 8px;
  color: #fffffe;
  padding: 10px 24px;
  font-size: 0.95rem;
  cursor: pointer;
  margin-top: auto;
  transition: all 0.3s ease;
}

.btn-add-to-cart:hover {
  background-color: #6E2B1E;
  transform: translateY(-2px);
}

.order-online {
  margin-top: 40px;
}

.btn-order-online {
  background-color: transparent;
  color: #6c5c05;
  border: 2px solid #6c5c05;
  padding: 12px 36px;
  font-size: 1rem;
  border-radius: 10px;
  cursor: pointer;
  transition: all 0.3s ease;
}

.btn-order-online:hover {
  background-color: #6c5c05;
  color: #fff;
  transform: translateY(-2px);
}

.divider {
  width: 80px;
  height: 4px;
  background-color: #8B0000;
  margin: 60px auto 40px auto;
  border-radius: 4px;
}

/* Estilos de Historia de Fogo */
.history-section {
  position: relative;
  min-height: 100vh;
  overflow: visible;
  display: flex;
  align-items: center;
  justify-content: center;
}

.history-background {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: url('@/assets/assetsbody/fondo_body4.jpg') no-repeat center center;
  background-size: cover;
  background-attachment: fixed;
  z-index: 1;
}

.history-content {
  position: relative;
  z-index: 2;
  display: flex;
  flex-wrap: wrap;
  gap: 30px;
  align-items: center;
  justify-content: center;
  padding: 40px;
  background-color: rgba(255, 255, 255, 0.8);
  border-radius: 20px;
  margin: 20px;
  max-height: calc(100vh - 40px);
  overflow-y: auto;
}

.text-column {
  flex: 1 1 400px;
  text-align: left;
}

.text-column h2 {
  font-size: 2.2rem;
  color: #5d2b1f;
  margin-bottom: 20px;
  transition: color 0.3s ease;
}

.text-column:hover h2 {
  color: #8B0000;
}

.text-column p {
  font-size: 1.1rem;
  color: #000000;
  line-height: 1.6;
}

.images-column {
  flex: 1 1 400px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
}

.history-img {
  width: 100%;
  max-width: 350px;
  border-radius: 12px;
  object-fit: cover;
  box-shadow: 0 4px 10px rgba(0,0,0,0.1);
  transition: transform 0.5s ease, box-shadow 0.5s ease;
}

.history-img:hover {
  transform: scale(1.03);
  box-shadow: 0 8px 20px rgba(0,0,0,0.2);
}

/* Responsive */
@media (max-width: 768px) {
  .product-grid {
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  }
  
  .history-content {
    padding: 20px;
  }
  
  .text-column, .images-column {
    flex: 1 1 100%;
  }
}
</style>