<template> 
  <section class="categories-section">
    <div class="content">
      <!-- Sección de categorías -->
      <div class="categories">
        <button @click="mostrarTodosLosProductos" class="categoria-btn" :class="{ seleccionado: categoriaSeleccionada === null }">Todos</button>
        <button
          v-for="categoria in categorias"
          :key="categoria.categoria_ID"
          class="categoria-btn"
          :class="{ seleccionado: categoriaSeleccionada === categoria.categoria_ID }"
          @click="filtrarPorCategoria(categoria.categoria_ID, categoria.descripcion)"
        >
          {{ categoria.nombre_categoria }}
        </button>
      </div>

      <!-- Descripción de la categoría -->
      <div class="category-description" v-if="categoriaDescripcion">
        <p>{{ categoriaDescripcion }}</p>
      </div>

      <!-- Ordenamiento -->
      <div class="ordenamiento">
        <label for="orden">Ordenar por:</label>
        <select id="orden" @change="ordenarProductos($event)">
          <option value="precio_asc">Precio ↑</option>
          <option value="precio_desc">Precio ↓</option>
          <option value="nombre_asc">Nombre A-Z</option>
          <option value="nombre_desc">Nombre Z-A</option>
        </select>
      </div>

      <!-- Productos -->
      <div class="products-grid">
        <div
          v-for="producto in productos"
          :key="producto.producto_ID"
          class="product-card product-animate"
        >
          <img :src="producto.imagen_url" alt="Imagen del producto" class="product-img" />
          <h3 class="product-name">{{ producto.nombre_producto }}</h3>
          <p class="product-description">{{ producto.descripcion_producto || producto.descripcion }}</p>
          <p class="product-price">${{ producto.precio }}</p>

          <!-- Selector de cantidad -->
          <div class="cantidad-selector">
            <button @click="disminuirCantidad(producto.producto_ID)">−</button>
            <span>{{ cantidadProductos[producto.producto_ID] || 1 }}</span>
            <button @click="incrementarCantidad(producto.producto_ID)">+</button>
          </div>

          <button class="btn-agregar" @click="agregarAlCarrito(producto)">
            Agregar 🛒
          </button>
        </div>
      </div>
    </div>
  </section>
</template>

<script>
import axios from 'axios'
import { useCarritoStore } from '@/stores/carrito'

export default {
  data() {
    return {
      productos: [],
      categorias: [],
      categoriaDescripcion: null,
      categoriaSeleccionada: null,
      criterioOrdenamiento: 'precio_asc',
      cantidadProductos: {},
      carrito: useCarritoStore(),
    }
  },
  created() {
    this.cargarProductos()
    this.cargarCategorias()
  },
  methods: {
    cargarProductos() {
      axios.get('http://localhost:3000/api/productos')
        .then(response => {
          this.productos = response.data
          response.data.forEach(p => {
            if (!this.cantidadProductos[p.producto_ID]) {
              this.cantidadProductos[p.producto_ID] = 1
            }
          })
        })
        .catch(error => {
          console.error('Error al cargar productos:', error)
        })
    },
    cargarCategorias() {
      axios.get('http://localhost:3000/api/categorias')
        .then(response => {
          this.categorias = response.data
        })
        .catch(error => {
          console.error('Error al cargar categorías:', error)
        })
    },
    filtrarPorCategoria(categoriaId, descripcion) {
      axios.get(`http://localhost:3000/api/productos/categoria/${categoriaId}`)
        .then(response => {
          this.productos = response.data
          this.categoriaDescripcion = descripcion
          this.categoriaSeleccionada = categoriaId
        })
        .catch(error => {
          console.error('Error al filtrar productos:', error)
        })
    },
    mostrarTodosLosProductos() {
      this.cargarProductos()
      this.categoriaDescripcion = null
      this.categoriaSeleccionada = null
    },
    ordenarProductos(event) {
      const criterio = event.target.value
      this.criterioOrdenamiento = criterio
      switch (criterio) {
        case 'precio_asc':
          this.productos.sort((a, b) => a.precio - b.precio)
          break
        case 'precio_desc':
          this.productos.sort((a, b) => b.precio - a.precio)
          break
        case 'nombre_asc':
          this.productos.sort((a, b) => a.nombre_producto.localeCompare(b.nombre_producto))
          break
        case 'nombre_desc':
          this.productos.sort((a, b) => b.nombre_producto.localeCompare(a.nombre_producto))
          break
      }
    },
    incrementarCantidad(productoID) {
      if (!this.cantidadProductos[productoID]) this.cantidadProductos[productoID] = 1
      this.cantidadProductos[productoID]++
    },
    disminuirCantidad(productoID) {
      if (this.cantidadProductos[productoID] > 1) {
        this.cantidadProductos[productoID]--
      }
    },
    agregarAlCarrito(producto) {
      const cantidad = this.cantidadProductos[producto.producto_ID] || 1
      this.carrito.agregarProducto({ ...producto, cantidad })
      alert(`Agregaste ${cantidad} ${producto.nombre_producto} al carrito`)
    }

  }
}
</script>

<style scoped>
.cantidad-selector {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}

.cantidad-selector button {
  background: transparent;
  border: 2px solid #6c5c05;
  color: #6c5c05;
  font-size: 1.2rem;
  border-radius: 50%;
  width: 28px;
  height: 28px;
  cursor: pointer;
  font-weight: bold;
  transition: 0.2s;
}

.cantidad-selector button:hover {
  background-color: #6c5c05;
  color: white;
}
.categories-section {
  background-image: linear-gradient(rgba(0, 0, 0, 0.2), rgba(0, 0, 0, 0.2)), url('@/assets/fueguito.jpg');
  background-size: cover;
  background-position: center;
  background-attachment: fixed;
  padding: 60px 20px;
  text-align: center;
}

.content {
  max-width: 1200px;
  margin: 0 auto;
  background-color: rgba(255, 255, 255, 0);
  padding: 40px;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  align-items: center;
 
}

.categories {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 20px;
  justify-content: center;
}

.categoria-btn {
  padding: 10px 15px;
  background-color: #6C5C05;
  color:#fff;
  border: none;
  border-radius: 8px;
  cursor: pointer;
  font-weight: bold;
  transition: background-color 0.3s ease;
}

.categoria-btn:hover {
  background-color: #5D2B1F;
}

.categoria-btn.seleccionado {
  background-color: #5D2B1F;
}

.category-description {
  margin-bottom: 20px;
  padding: 10px;
  border-left: 4px solid #6C5C05;
  font-style: italic;
}

.ordenamiento {
  margin-bottom: 20px;
}

.products-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 24px;
  max-width: 1000px;
  margin: 0 auto;
}

.product-card {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  align-items: center;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(8, 0, 0, 0.08);
  padding: 24px;
  box-sizing: border-box;
  height: 100%;
  min-height: 460px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.product-img {
  width: 140px;
  height: 140px;
  object-fit: cover;
  border-radius: 50%;
  margin-bottom: 16px;
  transition: transform 0.3s ease;
}

.product-name {
  font-size: 1.25rem;
  margin: 12px 0 8px;
  color: #010000;
  text-align: center;
  min-height: 40px;
}

.product-description {
  font-size: 1rem;
  color: #555;
  text-align: center;
  min-height: 60px;
  max-height: 60px;
  overflow: hidden;
  margin-bottom: 12px;
}

.product-price {
  font-size: 1.2rem;
  font-weight: bold;
  color: #6c5c05;
  margin-bottom: 16px;
}

.btn-agregar {
  background-color: #6c5c05;
  border: none;
  border-radius: 8px;
  color: #fffffe;
  padding: 10px 24px;
  font-size: 0.95rem;
  cursor: pointer;
  margin-top: auto;
  transition: all 0.3s ease;
}

.btn-agregar:hover {
  background-color: #6E2B1E;
  transform: translateY(-2px);
}

@media (max-width: 900px) {
  .products-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 600px) {
  .products-grid {
    grid-template-columns: repeat(1, 1fr);
  }
}
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.product-animate {
  animation: fadeInUp 0.9s ease forwards;
}
@keyframes fadeInButtons {
  from {
    opacity: 0;
    transform: translateY(-10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.categoria-btn {
  /* Estilos existentes... */
  animation: fadeInButtons 0.9s ease forwards;
  opacity: 0;
}

</style>





