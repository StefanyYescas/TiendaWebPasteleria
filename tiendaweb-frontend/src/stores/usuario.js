// src/stores/usuarioStore.js
import { defineStore } from 'pinia'


export const useUsuarioStore = defineStore('usuario', {
  state: () => ({
    usuario: null, // { id, nombre }
  }),
  actions: {
    setUsuario(data) {
      this.usuario = data;
      localStorage.setItem('usuario', JSON.stringify(data));
    },
    cargarDesdeLocalStorage() {
      const data = localStorage.getItem('usuario');
      if (data) {
        this.usuario = JSON.parse(data);
      }
    },
    cerrarSesion() {
      this.usuario = null;
      localStorage.removeItem('usuario');
    }
  }
});
