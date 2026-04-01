<template>
    <footer class="footer">
      <!-- Parte superior -->
      <div class="footer-top">
        <div class="footer-top-item">
          <Pickup />
          <p>Pick up en tienda</p>
        </div>
        <div class="footer-top-item">
          <Garantía/>
          <p>Garantía de satisfacción</p>
        </div>
        <div class="footer-top-item">
          <Service/>
          <p>Servicio al cliente</p>
        </div>
        <div class="footer-top-item">
          <Seguro/>
          <p>Pago seguro</p>
        </div>
      </div>
  
      <!-- Parte principal -->
      <div class="footer-main">
        <div class="footer-column">
          <h4>CONÓCENOS</h4>
          <p>¿Quíenes somos?</p>
            <p>Nosotros</p>
          <p>Contáctanos</p>
        </div>
  
        <div class="footer-column">
          <h4>ATENCIÓN AL CLIENTE</h4>
          <p>Mi Cuenta</p>
          <p>Ayuda y Soporte</p>
        </div>
  
        <div class="footer-column">
          <h4>LEGALES</h4>
          <p>Aviso de Privacidad</p>
          <p>Términos y Condiciones</p>
          <p>Uso de Cookies</p>
          
        </div>
  
        <div class="footer-column">
          <h4>SÍGUENOS</h4>
          <div class="social-icons">
          <Facebook/>
          <Instagram />
            
           
          </div>
        </div>
      </div>
  
      <!-- Parte inferior -->
      <div class="footer-bottom">
        <p>© 2025 Fogo. Todos los derechos reservados.</p>
        <button @click="scrollToTop" class="scroll-top">↑</button>
      </div>
    </footer>
  </template>
  
  <script setup>
  import Pickup from './icons/svgfooter/Pickup.vue';
  import Garantía from './icons/svgfooter/Garantía.vue';
  import Service from './icons/svgfooter/Service.vue';
  import Seguro from './icons/svgfooter/Seguro.vue';

  import Facebook from './icons/svgfooter/Facebook.vue'
  import Instagram from './icons/svgfooter/Instagram.vue'

  const scrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };
  </script>
  
  <style scoped>
  .footer {
    background-color: #4b262c;
    color: white;
    padding: 40px 20px 20px;
    font-family: Arial, sans-serif;
  }
  
  /* Parte superior */
  .footer-top {
    background-color: #4b262c; /* Cambiado al color que pediste */
    display: flex;
    justify-content: space-around;
    text-align: center;
    padding: 20px 0;
    flex-wrap: wrap;
  }
  
  .footer-top-item img {
    height: 40px;
  }
  
  .footer-top-item p {
    margin-top: 10px;
    font-weight: bold;
  }
  
  /* Parte principal */
  .footer-main {
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    margin-top: 40px;
  }
  
  .footer-column {
    flex: 1;
    min-width: 200px;
    margin-bottom: 20px;
  }
  
  .footer-column h4 {
    font-weight: bold;
    margin-bottom: 10px;
  }
  
  .footer-column p {
    margin: 8px 0;
    cursor: pointer;
  }
  
  .footer-column p:hover {
    text-decoration: underline;
  }
  
  /* Redes sociales */
  .social-icons {
    display: flex;
    gap: 10px;
    margin-top: 10px;
  }
  
  .social-icons img {
    height: 24px;
    cursor: pointer;
  }
  
  /* Parte inferior */
  .footer-bottom {
    text-align: center;
    margin-top: 40px;
    font-size: 12px;
  }
  
  .scroll-top {
    margin-top: 10px;
    background: none;
    border: 1px solid white;
    border-radius: 50%;
    width: 40px;
    height: 40px;
    color: white;
    font-size: 20px;
    cursor: pointer;
  }
  </style>
  