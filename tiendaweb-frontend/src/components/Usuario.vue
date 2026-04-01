<template>
  <div class="login-container">
    <h2>INICIAR SESIÓN</h2>
    <h1>¡Bienvenido de nuevo!</h1>
    <div class="register-form">
      <form @submit.prevent="iniciarSesion">
        <input v-model="correo" type="email" placeholder="Correo" required />
        <input v-model="contraseña" type="password" placeholder="Contraseña" required />
        <button type="submit">Iniciar Sesión</button>
      </form>
      <div class="enlaces">
        <p>
          ¿No tienes cuenta?
          <router-link to="/crear-cuenta">Regístrate</router-link>
        </p>
      </div>
      <p v-if="mensaje" :class="mensajeClass">{{ mensaje }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUsuarioStore } from '@/stores/usuario'
import { useCarritoStore } from '@/stores/carrito'
import api from '@/services/api' // axios configurado con baseURL

const router = useRouter()
const usuarioStore = useUsuarioStore()

const correo = ref('')
const contraseña = ref('')
const mensaje = ref('')
const mensajeClass = ref('')

const iniciarSesion = async () => {
  mensaje.value = ''
  try {
    const res = await api.post('/iniciar-sesion', {
      correo: correo.value,
      contraseña: contraseña.value
    })

    // Guardar en pinia + localStorage
    usuarioStore.setUsuario(res.data.usuario)
    
    const carritoStore = useCarritoStore()
    carritoStore.cargarCarrito()
    mensaje.value = res.data.mensaje
    mensajeClass.value = 'success'

    const rol = res.data.usuario.rol
    if (rol === 'admin') {
      router.push('/admin')
    } else {
      router.push('/') // o '/' si quieres que vaya al inicio
    }

    // Redirigir, por ejemplo, al home o dashboard
  } catch (err) {
    mensaje.value = err.response?.data?.error || 'Error al iniciar sesión'
    mensajeClass.value = 'error'
  }
}
</script>

<style scoped>
.login-container {
  background-image: linear-gradient(rgba(0, 0, 0, 0.6), rgba(0, 0, 0, 0.7)), url('@/assets/fondo_body.jpg');
  background-size: cover;
  background-attachment: fixed;
  background-position: center;
  background-repeat: no-repeat;

  display: flex;
  justify-content: center;
  align-items: center;
  flex-direction: column;
  padding: 60px;
  min-height: 100vh;
  
  color: #ffffff;
}

h2 {
  font-size: 2rem;
  font-weight: bold;
  margin-top: 20px;
}

h1 {
  font-size: 1.5rem;

  padding: 20px;
}
.subtexto {
  margin-bottom: 30px;
  font-size: 1.2rem;
  color: #ffffff;
}

.formulario {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 20px;
}

input, button {
   margin-bottom: 20px;
  width: 240px;
  padding: 15px;
  font-size: 15px;
  display: block;
  border-radius: 6px;
  border: 2px solid #928120;
}

button {
  background-color: #6C5C05;
  color: white;
  font-weight: bold;
  border: none;
  cursor: pointer;
}

button:hover {
  background-color: #4c1507;
}



.enlaces {
  margin-top: 20px;
  font-size: 0.9rem;
}

.enlaces a {
  color: #fcfafa;
  font-weight: bold;
  text-decoration: none;
  margin-left: 4px;
}

.enlaces a:hover {
  text-decoration: underline;
}

p.success {
  color: #4caf50;
  margin-top: 15px;
}

p.error {
  color: #f44336;
  margin-top: 15px;
}



</style>
