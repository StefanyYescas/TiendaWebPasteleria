<template>
  <div class="checkout-steps">
    <!-- Banner superior con color vino -->
    <div class="logo-banner">
       <router-link to="/"><Icono /></router-link>
    </div>

    <!-- Breadcrumb estilo pasos -->
    <nav class="breadcrumb-steps">
      <span :class="{ activo: paso === 1 }">CARRITO</span>
      <span class="separador">›</span>
      <span :class="{ activo: paso === 2 }">INFORMACIÓN</span>
      <span class="separador">›</span>
      <span :class="{ activo: paso === 3 }">TICKET</span>
    </nav>
  </div>
</template>

<script setup>
import Icono from './Icono.vue'
defineProps({
  paso: Number
})
</script>

<style scoped>
.checkout-steps {
  margin-top: 0px;
  margin-bottom: 30px;
  font-family: 'Montserrat', sans-serif;
}

/* Banner vino con título */
.logo-banner {
  background-color: #6C5C05;
  text-align: center;
  width: 99vw;
  position: relative;
  left: 50%;
  transform: translateX(-50%);
}


/* Breadcrumb estilo pasos */
.breadcrumb-steps {
  background-color: #f1f2f4;
  padding: 12px 24px;
  width: 99vw;
  position: relative;
  left: 50%;
  transform: translateX(-50%);
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 12px;
  font-size: 14px;
  font-weight: bold;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.breadcrumb-steps span {
  color: #999;
  transition: color 0.3s ease;
}

.breadcrumb-steps .separador {
  color: #444;
  font-weight: normal;
}

.breadcrumb-steps .activo {
  color: #8B0000;
}
</style>
