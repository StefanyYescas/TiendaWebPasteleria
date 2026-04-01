<template>
  <div class="nosotros-container">
    <NavBar />
    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-text">
        <h1 class="title-animate">Nuestra Dulce Historia</h1>
        <p class="subtitle subtitle-animate">Consintiéndote desde el 2021</p>
      </div>
    </section>

    <main class="nosotros-content">
      <!-- Sección Quiénes Somos -->
      <section class="about-section">
        <div class="section-content">
          <h2 class="section-title-animate">¿QUIÉNES SOMOS?</h2>
          <div class="divider divider-animate"></div>
          
          <div class="about-grid">
            <div class="about-card about-card-animate">
              <img src="@/assets/pastelería.jpg" alt="Hermanas reposteras" class="about-img">
            </div>
            
            <div class="about-card about-card-animate" style="animation-delay: 0.2s;">
              <p class="text-animate">Somos dos hermanas apasionadas por la repostería. Cada producto realizado con los ingredientes de la más alta calidad y mucho amor.</p>
              
              <div class="mv-block block-animate" style="animation-delay: 0.3s;">
                <h3>NUESTRA MISIÓN</h3>
                <p>Endulzar la vida de nuestros clientes con productos artesanales que combinan tradición e innovación.</p>
              </div>
              
              <div class="mv-block block-animate" style="animation-delay: 0.4s;">
                <h3>NUESTRA VISIÓN</h3>
                <p>Ser el referente en repostería artesanal, manteniendo la esencia familiar y la calidad en cada creación.</p>
              </div>
            </div>
          </div>
        </div>
      </section>
      <!-- Sección Valores -->
      <section class="values-section">
        <div class="section-content">
          <h2 class="section-title-animate">NUESTROS VALORES</h2>
          <div class="divider divider-animate"></div>
          
          <div class="values-grid">
            <div class="value-card value-animate">
              <div class="value-icon">★</div>
              <h3>Calidad Premium</h3>
              <p>Ingredientes seleccionados y procesos artesanales</p>
            </div>
            
            <div class="value-card value-animate" style="animation-delay: 0.2s;">
              <div class="value-icon">✧</div>
              <h3>Creatividad</h3>
              <p>Diseños innovadores que deleitan los sentidos</p>
            </div>
            
            <div class="value-card value-animate" style="animation-delay: 0.4s;">
              <div class="value-icon">❤</div>
              <h3>Pasión</h3>
              <p>Amor por el arte de la repostería</p>
            </div>
          </div>
        </div>
      </section>
    </main>
    <Footer />
  </div>
</template>
<script setup>
import Footer from '@/components/Footer.vue'
import NavBar from '../components/NavBar.vue'

</script>
<style scoped>
/* Estilos base con Times New Roman */
.nosotros-container {
  display: flex;
  flex-direction: column;
  min-height: 80vh;
  background-color: #fffaf7;
  font-family: "Times New Roman", Times, serif;
}

/* Hero Section */
.hero-section {
  background: linear-gradient(rgba(0, 0, 0, 0.1), rgba(0, 0, 0, 0.7)), 
              url('@/assets/foto_antigua.jpg');
  background-size: cover;
  background-position: center;
  height: 70vh;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  color: white;
}

/* Animaciones */
.title-animate {
  animation: riseUp 1s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

.subtitle-animate {
  animation: riseUp 1s ease-out 0.3s forwards;
  opacity: 0;
  transform: translateY(30px);
}

.section-title-animate {
  animation: riseUp 1s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

.divider-animate {
  animation: riseUp 1s ease-out 0.3s forwards;
  opacity: 0;
  transform: translateY(30px);
}

.about-card-animate {
  animation: riseUp 1s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

.text-animate {
  animation: fadeIn 1s ease-out 0.2s forwards;
  opacity: 0;
}

.block-animate {
  animation: fadeIn 1s ease-out forwards;
  opacity: 0;
}

.value-animate {
  animation: riseUp 1s ease-out forwards;
  opacity: 0;
  transform: translateY(30px);
}

@keyframes riseUp {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  to {
    opacity: 1;
  }
}

.hero-text h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
}

.subtitle {
  font-size: 1.5rem;
  text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
}

/* Contenido principal */
.section-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 5rem 2rem;
}

h2 {
  font-size: 2.5rem;
  text-align: center;
  color: #050100;
  margin-bottom: 1rem;
}

.divider {
  width: 100px;
  height: 2px;
  background: #8B0000;
  margin: 0 auto 3rem;
}

/* Sección Quiénes Somos */
.about-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}

.about-img {
  width: 100%;
  height: 500px;
  object-fit: cover;
  border-radius: 15px;
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
  transition: transform 0.5s ease;
}

.about-card:hover .about-img {
  transform: scale(1.02);
}

.about-card p {
  font-size: 1rem;
  line-height: 1.8;
  color: #333;
  margin-bottom: 2rem;
}

.mv-block {
  margin-bottom: 2.5rem;
}

.mv-block h3 {
  font-size: 1.3rem;
  color: #5D2B1F;
  margin-bottom: 0.8rem;
}

.mv-block p {
  line-height: 1.7;
  color: #000000;
}

/* Sección Valores */
.values-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.value-card {
  text-align: center;
  padding: 2rem;
  background: white;
  border-radius: 130px;
  box-shadow: 0 3px 10px rgba(0,0,0,0.05);
  transition: all 0.3s ease;
}

.value-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.value-icon {
  font-size: 2.5rem;
  color: #6E6A3B;
  margin-bottom: 1rem;
  transition: transform 0.3s ease;
}

.value-card:hover .value-icon {
  transform: scale(1.2);
}

.value-card h3 {
  color: #6C5C05;
  margin-bottom: 0.8rem;
  font-size: 1.3rem;
}

.value-card p {
  color: #000000;
  line-height: 1.6;
  font-size: 0.95rem;
}

/* Responsive */
@media (max-width: 900px) {
  .about-grid {
    grid-template-columns: 1fr;
  }
  
  .about-img {
    height: 400px;
  }
}

@media (max-width: 600px) {
  .hero-text h1 {
    font-size: 2.2rem;
  }
  
  .subtitle {
    font-size: 1.2rem;
  }
  
  h2 {
    font-size: 1.8rem;
  }
  
  .section-content {
    padding: 3rem 1.5rem;
  }
  
  .value-card {
    border-radius: 80px;
    padding: 1.5rem;
  }
}
</style>