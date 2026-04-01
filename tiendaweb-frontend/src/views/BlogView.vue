<template>
  <div class="blog-container">
    <NavBar />
    
    <!-- Hero Section -->
    <section class="hero-section">
      <div class="hero-text">
        <h1 class="title-animate">Nuestro Blog Dulce</h1>
        <p class="subtitle subtitle-animate">Descubre nuestras últimas novedades</p>
      </div>
    </section>

    <main class="blog-content">
      <!-- Sección de Tarjetas del Blog -->
      <section class="blog-section">
        <div class="section-content">
          <h2 class="section-title-animate">ÚLTIMAS ENTRADAS</h2>
          <div class="divider divider-animate"></div>
          
          <div class="blog-grid">
            <!-- Tarjeta 1 -->
            <div class="blog-card card-animate">
              <div class="image-container">
                <img src='@/assets/arte.jpg' alt="Arte de la Repostería" class="card-image">  
              </div>
              <div class="card-content">
                <span class="card-date">15 Mayo 2023</span>
                <h3 class="card-title">El Arte de la Repostería Francesa</h3>
                <p class="card-excerpt">Exploramos las técnicas clásicas de la pastelería francesa y cómo las adaptamos a nuestro estilo.</p>
                <button class="card-button">Leer más</button>
              </div>
            </div>
            
            <!-- Tarjeta 2 -->
            <div class="blog-card card-animate" style="animation-delay: 0.2s;">
              <div class="image-container">
                <img src='@/assets/ingredientes.jpg' alt="Ingredientes locales" class="card-image"> 
              </div>
              <div class="card-content">
                <span class="card-date">28 Abril 2023</span>
                <h3 class="card-title">Ingredientes Locales, Sabores Globales</h3>
                <p class="card-excerpt">Cómo seleccionamos los mejores ingredientes locales para crear sabores que trascienden fronteras.</p>
                <button class="card-button">Leer más</button>
              </div>
            </div>
            
            <!-- Tarjeta 3 -->
            <div class="blog-card card-animate" style="animation-delay: 0.4s;">
              <div class="image-container">
                <img src='@/assets/decoración.jpg' alt="Decoración de pasteles" class="card-image"> 
              </div>
              <div class="card-content">
                <span class="card-date">10 Abril 2023</span>
                <h3 class="card-title">Tendencias en Decoración de Pasteles 2023</h3>
                <p class="card-excerpt">Las técnicas y estilos que están dominando el mundo de la decoración de pasteles este año.</p>
                <button class="card-button">Leer más</button>
              </div>
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
.blog-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #fffaf7;
  font-family: "Times New Roman", Times, serif;
}

/* Hero Section */
.hero-section {
  background: linear-gradient(rgba(0, 0, 0, 0.3), rgba(0, 0, 0, 0.7)), 
              url('@/assets/pastelería.jpg');
  background-size: cover;
  background-position: center;
  min-height: 70vh;
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
  animation: riseUp 1s ease-out 0.6s forwards;
  opacity: 0;
  transform: translateY(30px);
}

.divider-animate {
  animation: riseUp 1s ease-out 0.9s forwards;
  opacity: 0;
  transform: translateY(30px);
}

.card-animate {
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

.hero-text h1 {
  font-size: 2.5rem;
  margin-bottom: 1rem;
  text-shadow: 1px 1px 3px rgba(0,0,0,0.5);
}

.subtitle {
  font-size: 2rem;
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
  color: #000000;
  margin-bottom: 1rem;
}

.divider {
  width: 100px;
  height: 2px;
  background: #8B0000;
  margin: 0 auto 3rem;
}

/* Sección del Blog */
.blog-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 2rem;
  margin-top: 2rem;
}

.blog-card {
  background: white;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 4px 8px rgba(0,0,0,0.1);
  transition: all 0.3s ease;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.blog-card:hover {
  transform: translateY(-5px);
  box-shadow: 0 10px 20px rgba(0,0,0,0.15);
}

.image-container {
  width: 100%;
  height: 250px;
  overflow: hidden;
}

.card-image {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.blog-card:hover .card-image {
  transform: scale(1.05);
}

.card-content {
  padding: 1.5rem;
  flex-grow: 1;
  display: flex;
  flex-direction: column;
}

.card-date {
  font-size: 0.9rem;
  color: #8B0000;
  margin-bottom: 0.5rem;
}

.card-title {
  font-size: 1.3rem;
  color: #000000;
  margin-bottom: 1rem;
  line-height: 1.3;
}

.card-excerpt {
  color: #333;
  line-height: 1.6;
  margin-bottom: 1.5rem;
  flex-grow: 1;
}

.card-button {
  background: #6C5C05;
  color: white;
  border: none;
  padding: 0.7rem 1.5rem;
  border-radius: 4px;
  cursor: pointer;
  font-family: "Times New Roman", Times, serif;
  font-size: 1rem;
  align-self: flex-start;
  transition: all 0.3s ease;
}

.card-button:hover {
  background: #5D2B1F;
  transform: translateY(-2px);
}

/* Responsive */
@media (max-width: 900px) {
  .hero-section {
    height: 50vh;
  }
  
  .hero-text h1 {
    font-size: 2.2rem;
  }
  
  .subtitle {
    font-size: 1.5rem;
  }
  
  .image-container {
    height: 200px;
  }
}

@media (max-width: 600px) {
  .hero-text h1 {
    font-size: 2rem;
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
  
  .blog-grid {
    grid-template-columns: 1fr;
  }
  
  .image-container {
    height: 180px;
  }
}
</style>