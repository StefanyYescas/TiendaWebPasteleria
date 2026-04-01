<template>
  <div class="categories-section">
    <div class="content-wrapper">
      <CheckoutSteps :paso="3" />
      <div class="ticket-container">
        <h1>¡Gracias por tu compra!</h1>
        <br>
        <p>Estamos preparando tu pedido con mucho cariño. Muestra el ticket en mostrador o al repartidor.</p>
        <br>
        <router-link class="home-link" to="/">Volver al inicio</router-link>
      </div>
    </div>
  </div>
</template>


<script setup>
import CheckoutSteps from './CheckoutSteps.vue'
</script>
<style scoped>
.categories-section {
  background-image: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.3)), url('@/assets/fueguito.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  padding: 0px 15px;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: start;
}

.content-wrapper {
  width: 100%;
  max-width: 500px;
  
}

.ticket-container {
  margin-top:150px;
  background-color: rgba(255, 255, 255, 0.95);
  border-radius: 2rem;
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.2);
  padding: 3rem 2rem;
  text-align: center;
  animation: fadeInUp 0.8s ease;
  width: 100%;
}

.ticket-container h1 {
  font-size: 2rem;
  color: #696d15; /* Color de tu paleta */
 
}

.ticket-container p {
  font-size: 1.1rem;
  color: #000000;
 
}

.home-link {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background-color: #706725; /* Rosa brillante de tu paleta */
  color: white;
  border-radius: 999px;
  text-decoration: none;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

.home-link:hover {
  background-color: #572217;
}


</style>