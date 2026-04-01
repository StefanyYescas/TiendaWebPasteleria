<template>
    <header class="header">
      <!-- Componente Navbar importado -->
      <NavBar />
     
    </header>
  </template>
  
  <script setup>
  import NavBar from './NavBar.vue'
  </script>
  
  <style scoped>
  .header {
    background-image: linear-gradient(rgba(0, 0, 0, 0.0), rgba(0, 0, 0, 0.3)), url('@/assets/ordenaraqui.jpg.png');
    background-position: center center;
    background-repeat: no-repeat;
    background-size: cover;
    height: 50vh;
    display: flex;
     /* Alinea el contenido hacia abajo */
    justify-content: center;
    padding-top: 12rem; /* Espacio desde abajo */
    position: relative;
  }
  
  .header-content {
    text-align: center;
    color: white;
    width: 100%;
    max-width: 800px;
    padding: 8vh;
    animation: fadeIn 1.5s ease-in-out;
    margin-bottom: 2rem; /* Ajuste adicional para bajar más */
  }
  
  h1 {
    font-size: 2em;
    margin-bottom: 1rem;
    text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
  }
  
  .slogan {
    font-size: 1.5rem;
    line-height: 1.0;
    text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.5);
  }
  
  @keyframes fadeIn {
    from { opacity: 0; transform: translateY(20px); }
    to { opacity: 1; transform: translateY(0); }
  }
  
  /* Responsive */
  @media (max-width: 768px) {
    .header {
      padding-bottom: 10vh;
      align-items: center;
    }
    
    .header-content {
      max-width: 90%;
      margin-bottom: 3rem;
    }
    
    h1 {
      font-size: 2rem;
    }
    
    .slogan {
      font-size: 1.1rem;
    }
  }
  </style>