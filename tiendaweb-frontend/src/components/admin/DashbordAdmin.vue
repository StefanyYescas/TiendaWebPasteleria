<template>
  <div class="admin-layout">
  
    <!-- Sidebar lateral izquierdo -->
    <aside class="sidebar">
      <Icono class="logo-container" />
      <nav>
        <ul>
          <li><router-link to="/admin">Dashboard</router-link></li>
          <li><router-link to="/clientes">Clientes</router-link></li>
          <li><router-link to="/proveedores">Proveedores</router-link></li>
        
          
             <!-- Submenú: ProduCate -->
             <li>
            <div @click="toggleProduCate" class="submenu-title">
            Productos y Categoria <span class="arrow" :class="{ open: produCateAbierto }">▼</span>
            </div>
            <ul v-if="produCateAbierto" class="submenu">
            <li><router-link to="/categorias">Categorías</router-link></li>
            <li><router-link to="/productos">Productos</router-link></li>
                      <li><router-link to="/productos/existencia">Control de Inventario</router-link></li>
            </ul>
          </li>

          <!-- Submenú: Pedidos -->
          <li>
            <div @click="togglePedidos" class="submenu-title">
              Pedidos <span class="arrow" :class="{ open: pedidosAbierto }">▼</span>
            </div>
            <ul v-if="pedidosAbierto" class="submenu">
              <li><router-link to="/pedidos">Activos</router-link></li>
              <li><router-link to="/historial-pedidos">Historial</router-link></li>
            </ul>
          </li>

          <!-- Submenú: Compras -->
          <li>
            <div @click="toggleCompras" class="submenu-title">
              Compras <span class="arrow" :class="{ open: comprasAbierto }">▼</span>
            </div>
            <ul v-if="comprasAbierto" class="submenu">
              <li><router-link to="/compras">Nueva compra</router-link></li>
              <li><router-link to="/historial-proveedor">Historial</router-link></li>
            </ul>
          </li>

          <!-- Submenú: Reportes -->
          <li>
            <div @click="toggleReportes" class="submenu-title">
              Reportes <span class="arrow" :class="{ open: reportesAbierto }">▼</span>
            </div>
            <ul v-if="reportesAbierto" class="submenu">
              <li><router-link to="/reportes">Ventas</router-link></li>
            </ul>
          </li>
        </ul>
        <button class="btn-logout" @click="cerrarSesion">Cerrar sesión</button>
      </nav>
    </aside>

    <!-- Contenido principal -->
    <main class="main-content">
      <router-view />
    </main>
  </div>
</template>

<script setup>

import Icono from '@/components/Icono.vue'
import { useRouter } from 'vue-router'
import { ref } from 'vue'

const router = useRouter()

function cerrarSesion() {
  localStorage.clear()
  router.push('/registrate')
}
const produCateAbierto = ref(false)
const pedidosAbierto = ref(false)
const comprasAbierto = ref(false)
const reportesAbierto = ref(false)

const toggleProduCate = () => {
  produCateAbierto.value = !produCateAbierto.value
}

const togglePedidos = () => {
  pedidosAbierto.value = !pedidosAbierto.value
}
const toggleCompras = () => {
  comprasAbierto.value = !comprasAbierto.value
}
const toggleReportes = () => {
  reportesAbierto.value = !reportesAbierto.value
}
</script>

<style scoped>
.admin-layout {
  display: flex;
  height: 100vh;
  font-family: 'Cony', cursive;
  overflow: hidden;
  /* Oculta la barra de desplazamiento en Firefox */
}

.sidebar {
  width: 230px;
  background-color: #514829;
  color: #eaeaea;
  padding: 10px 20px;
  display: flex;
  flex-direction: column;
  height: 100vh;
  position: fixed;
  top: 0;
  left: 0;
  z-index: 10;
  overflow-y: auto;
}

.main-content {
  margin-left: 230px; /* Igual al ancho del sidebar */
  flex: 1;
 
  background-color: #ffffff;
  height: 100vh;
  overflow-y: auto;
}

.sidebar ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.sidebar li {
  margin-bottom: 14px;
}

.sidebar a {
  color: #dcdcdc;
  text-decoration: none;
  font-weight: 500;
  display: block;
  padding: 10px 15px;
  border-radius: 6px;
  transition: background 0.2s, padding-left 0.2s;
}

.sidebar a:hover,
.sidebar a.router-link-exact-active {
  background-color: #808a5263;
  padding-left: 20px;
  color: #ffffff;
}

.logo-container {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-bottom: 10px;
}

.logo-container svg {
  width: 80px;
  height: auto;
}

.btn-logout {
  margin-top: auto;
  padding: 12px 15px;
  width: 100%;
  background-color: #c9caa868;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s;
}

.btn-logout:hover {
  background-color: #c7cbb25b;
}

/* Submenús */
.submenu-title {
  cursor: pointer;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 15px;
  border-radius: 6px;
  transition: background-color 0.2s;
  color: #dcdcdc;
}

.submenu-title:hover {
  background-color: #808a5263;
}

.submenu {
  margin-left: 10px;
  margin-top: 5px;
}

.submenu li {
  margin-bottom: 8px;
}

.arrow {
  transition: transform 0.3s ease;
}

.arrow.open {
  transform: rotate(180deg);
}
</style>
