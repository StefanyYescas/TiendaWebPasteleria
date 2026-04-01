<template>
  <!-- Navbar Principal -->
  <div class="top-bar" :class="{ 'scrolled': isScrolled }">
    <router-link to="/" ><Icono /></router-link>
    
    <nav class="navbar">
      <ul class="nav-links">
        <li><router-link to="/nosotros">Nosotros</router-link></li> 
        <li><router-link to="/ordenaaqui">Ordena Aquí</router-link></li>
        <li><router-link to="/blog">Blog</router-link></li>
      </ul>
    </nav>
    
    <div class="iconos-header">
      <!-- Mostrar nombre solo si hay usuario y NO es admin -->
      <p class="usuario" v-if="usuarioStore.usuario && usuarioStore.usuario.rol !== 'admin'">
        {{ usuarioStore.usuario.nombre }}
      </p>
      <router-link to="/carrito" class="carrito-icono-con-contador">
        <Carrito class="icono" />
        <span v-if="totalProductos > 0" class="contador-carrito">{{ totalProductos }}</span>
      </router-link>
      <router-link to="/registrate">
        <Contacto class="icono" />
      </router-link>
    </div>
    
    <button class="menu-toggle" :class="{ 'active': menuAbierto }" @click="toggleMenu">
      <span></span>
      <span></span>
      <span></span>
    </button>
  </div>

  <!-- Menú Móvil Lateral -->
  <div class="mobile-sidebar" :class="{ 'active': menuAbierto }">
    <button class="close-btn" @click="toggleMenu">×</button>
    <ul>
      <!-- Mostrar saludo solo si hay usuario y NO es admin -->
      <p class="usuario2" v-if="usuarioStore.usuario && usuarioStore.usuario.rol !== 'admin'">
        ¡Bienvenido/a {{ usuarioStore.usuario.nombre }}!
      </p>
      <li><router-link to="/nosotros" @click="toggleMenu">Nosotros</router-link></li> 
      <li><router-link to="/ordenaaqui" @click="toggleMenu">Ordena Aquí</router-link></li>
      <li><router-link to="/blog" @click="toggleMenu">Blog</router-link></li>
    </ul>
    <div class="mobile-icons">
      <router-link to="/carrito" class="carrito-icono-con-contador">
        <Carrito class="icono" />
        <span v-if="totalProductos > 0" class="contador-carrito">{{ totalProductos }}</span>
      </router-link>
      <router-link to="/registrate">
        <Contacto class="icono" />
      </router-link>
    </div>
    <!-- Botón cerrar sesión solo si usuario existe y NO es admin -->
    <button class="cerrar" v-if="usuarioStore.usuario && usuarioStore.usuario.rol !== 'admin'" @click="cerrarSesion">
      Cerrar sesión
    </button>
  </div>

  <!-- Overlay -->
  <div class="sidebar-overlay" :class="{ 'active': menuAbierto }" @click="toggleMenu"></div>
</template>
<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue'
import Icono from './Icono.vue'
import Carrito from './icons/svgheader/Carrito.vue'
import Contacto from './icons/svgheader/Contacto.vue'
import { useCarritoStore } from '@/stores/carrito'
import { useUsuarioStore } from '@/stores/usuario' // Importa el store de usuario
import { useRouter } from 'vue-router'


const carrito = useCarritoStore()
const usuarioStore = useUsuarioStore()  // Usa el store de usuario

const totalProductos = computed(() => carrito.totalProductos)
const menuAbierto = ref(false)
const isScrolled = ref(false)

const toggleMenu = () => {
  menuAbierto.value = !menuAbierto.value
  document.body.style.overflow = menuAbierto.value ? 'hidden' : 'auto'
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 10
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
  document.body.style.overflow = 'auto'
})

// Función para cerrar sesión
const cerrarSesion = () => {
  const usuarioStore = useUsuarioStore()
  const carrito = useCarritoStore()
  const router = useRouter()

  // Primero, cierra la sesión eliminando los datos del usuario
  usuarioStore.cerrarSesion()

  // Luego, elimina el carrito del localStorage para ese usuario
  const key = `carrito_${usuarioStore.usuario?.id}` // Esto podría ser null si el usuario ya cerró sesión
  localStorage.removeItem(key)

  // Vacía el carrito en el store
  carrito.vaciarCarrito()

  // Redirige al login después de cerrar sesión
  router.push('/registrate') // O la ruta que desees
}

</script>

<style>
.usuario2 {
  color: #ffffff;
  font-weight: bolder;
  padding: 0.5rem 0;
  font-size: 1.3rem;
}
/* Estilo para el nombre del usuario */
.usuario {
  color: #ffffff;
  font-weight: bold;
  margin-right: 10px;
  font-size: 1rem;
}

.top-bar.scrolled .usuario {
  color: #6c5c05;
}

/* Estilo para el botón de cerrar sesión */
.cerrar {
  margin-top: 2rem;
  background-color: #ffffff;
  color: #6c5c05;
  font-weight: bold;
  border: none;
  padding: 10px 15px;
  border-radius: 8px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.cerrar:hover {
  background-color: #ffffff76;
}

@media (max-width: 900px) {
  .usuario {
    display: none;
  }
}
.carrito-icono-con-contador {
  position: relative;
  display: inline-block;
}

.contador-carrito {
  position: absolute;
  top: -6px;
  right: -11px;
  background-color: #d5b813;
  color: white;
  font-size: 11px;
  padding: 3px 7px;
  border-radius: 50%;
  font-weight: bold;
}

/* Barra superior fija con efecto scroll */
.top-bar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 3rem;
  height: 90px;
  z-index: 1000;
  transition: all 0.3s ease;
}

.top-bar.scrolled {
  background-color: rgba(246, 243, 237, 0.977);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.5);
}

/* Elementos del navbar */
.logotipo {
  width: 40px;
  height: 40px;
  transition: all 0.3s ease;
}

.navbar ul {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 3rem;
  list-style: none;
  margin: 0;
  padding: 0;
}

.navbar a  {
  color: rgb(254, 254, 254);
  font-weight: 50;
  text-decoration: none;
  transition: all 0.3s ease;
}

.top-bar.scrolled .navbar a {
  color: #474203;
}

.navbar a:hover {
  opacity: 0.8;
}

.iconos-header {
  display: flex;
  gap: 20px;
}

.icono {
  width: 25px;
  height: 25px;
  color: rgb(252, 252, 252);
  transition: all 0.3s ease;
  cursor: pointer;
}

.top-bar.scrolled .icono {
  color: #6C5C05;
}

.icono:hover {
  transform: scale(1.1);
  color: #8B0000;
}

/* Botón Menú Hamburguesa */
.menu-toggle {
  display: none;
  background: none;
  border: none;
  cursor: pointer;
  padding: 5px;
  z-index: 1003;
  width: 30px;
  height: 30px;
}

.menu-toggle span {
  display: block;
  width: 22px;
  height: 2px;
  background-color: rgb(252, 245, 245);
  margin: 4px 0;
  transition: all 0.3s ease;
  transform-origin: center;
}

.top-bar.scrolled .menu-toggle span {
  background-color: #6E6A3B;
}

/* Animación cuando el menú está abierto */
.menu-toggle.active span:nth-child(1) {
  transform: translateY(6px) rotate(45deg);
}

.menu-toggle.active span:nth-child(2) {
  opacity: 0;
}

.menu-toggle.active span:nth-child(3) {
  transform: translateY(-6px) rotate(-45deg);
}

.top-bar.scrolled .menu-toggle.active span {
  background-color: #fdfafab5;
}

/* Menú Lateral Móvil */
.mobile-sidebar {
  position: fixed;
  top: 0;
  right: -300px;
  width: 250px;
  height: 100vh;
  background-color: #6c5c05;
  padding: 2rem;
  z-index: 1002;
  transition: right 0.3s ease-in-out;
  display: flex;
  flex-direction: column;
}

.mobile-sidebar.active {
  right: 0;
}

.close-btn {
  position: absolute;
  top: 15px;
  right: 15px;
  background: none;
  border: none;
  color: rgb(255, 255, 255);
  font-size: 2rem;
  cursor: pointer;
  line-height: 1;
  padding: 0;
}

.mobile-sidebar ul {
  list-style: none;
  padding: 0;
  margin-top: 2rem;
}

.mobile-sidebar li {
  margin: 1.5rem 0;
}

.mobile-sidebar a {
  color: rgb(255, 255, 255);
  text-decoration: none;
  font-size: 1.2rem;
  transition: color 0.3s;
}

.mobile-sidebar a:hover {
  color: #ffffff58;
}

.mobile-icons {
  display: flex;
  justify-content: center;
  gap: 20px;
  margin-top: auto;
  padding-bottom: 2rem;
}

/* Overlay */
.sidebar-overlay {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 1001;
  opacity: 0;
  visibility: hidden;
  transition: all 0.3s ease;
}

.sidebar-overlay.active {
  opacity: 1;
  visibility: visible;
}

/* Estilos para el botón de cerrar sesión */
  /* Estilo para el texto de usuario */
  

/* Responsive Design */
@media (max-width: 768px) {
  .navbar, .iconos-header {
    display: none;
  }
  
  .menu-toggle {
    display: block;
  }
  
  .top-bar {
    padding: 10px 1.5rem;
  }
}

@media (min-width: 769px) {
  .mobile-sidebar, .sidebar-overlay {
    display: none !important;
  }
}


</style>