<template>
  <div class="login-container">
    <h2>CREAR CUENTA</h2>
    <h1>¡Bienvenidos a tu pastelería favorita!</h1>
  <div class="register-form">
    
    <form @submit.prevent="crearCuenta">
      <input v-model="nombre_usuario" type="text" placeholder="Nombre de usuario" required />
      <input v-model="correo" type="email" placeholder="Correo" required />
      <input v-model="contraseña" type="password" placeholder="Contraseña" required />
      <button type="submit">Registrarse</button>
    </form>
    <div class="enlaces">
        <p>
          ¿Ya tienes cuenta?
          <router-link to="/registrate">Iniciar Sesión</router-link>
        </p>
        
      </div>
    <p v-if="mensaje" :class="mensajeClass">{{ mensaje }}</p>
  </div>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import api from '@/services/api';  // Asegúrate que esté configurado correctamente
import { useRouter } from 'vue-router';  // Para redirigir después de un registro exitoso

const router = useRouter();

const nombre_usuario = ref('');
const correo = ref('');
const contraseña = ref('');
const mensaje = ref('');
const mensajeClass = ref('');  // Para controlar el estilo del mensaje

const crearCuenta = async () => {
  try {
    const res = await api.post('/crear-cuenta', {
      nombre_usuario: nombre_usuario.value,
      correo: correo.value,
      contraseña: contraseña.value,
      rol: 'cliente' // Asignar rol por defecto
    });
    mensaje.value = res.data.mensaje;
    mensajeClass.value = 'success'; // Estilo para mensaje de éxito

    // Redirigir a login o otra página
    router.push('/registrate');
  } catch (err) {
    if (err.response) {
      mensaje.value = err.response.data.error || 'Error al crear cuenta';
      mensajeClass.value = 'error'; // Estilo para mensaje de error
    } else {
      mensaje.value = 'Error de conexión con el servidor';
      mensajeClass.value = 'error'; // Estilo para mensaje de error
    }
  }
};
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