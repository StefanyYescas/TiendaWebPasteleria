<template>
  <router-view />
</template>
<script setup>
import { watch, onMounted } from 'vue';
import { useCarritoStore } from '@/stores/carrito';
import { useUsuarioStore } from '@/stores/usuario';

const carrito = useCarritoStore();
const usuarioStore = useUsuarioStore();

// Cuando el componente monta, carga el usuario desde localStorage
onMounted(() => {
  usuarioStore.cargarDesdeLocalStorage();
});

// Observa cuando el usuario cambia (incluyendo al cargarlo)
watch(
  () => usuarioStore.usuario,
  (nuevoUsuario) => {
    if (nuevoUsuario) {
      carrito.cargarCarrito();  // Carga carrito para el usuario que acaba de "llegar"
    } else {
      carrito.vaciarCarrito();  // Si no hay usuario, limpia carrito
    }
  },
  { immediate: true }  // Ejecuta esta función inmediatamente al crear el watcher
);

/*import { onMounted } from 'vue';
import { useCarritoStore } from '@/stores/carrito';
import { useUsuarioStore } from '@/stores/usuario';

const carrito = useCarritoStore();
const usuarioStore = useUsuarioStore();


onMounted(() => {
  if (usuarioStore.usuario) {
    // Recuperar el carrito del localStorage si existe para este usuario
    const key = `carrito_${usuarioStore.usuario.id}`;
    const carritoGuardado = localStorage.getItem(key);

    if (carritoGuardado) {
      carrito.items = JSON.parse(carritoGuardado); // Cargar el carrito del usuario
    }
  }
});
*/
</script>


