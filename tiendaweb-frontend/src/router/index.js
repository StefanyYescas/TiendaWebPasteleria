import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'
import NosotrosView from '@/views/NosotrosView.vue'
import BlogView from '@/views/BlogView.vue'
import OrdenaAquiView from '../views/OrdenaAquiView.vue'
import CarritoView from '../views/CarritoView.vue'
import RegistrateView from '@/views/RegistrateView.vue'
import InformacionView from '@/views/InformacionView.vue'
import CrearCuentaView from '@/views/CrearCuentaView.vue'
import TicketView from '@/views/TicketView.vue'


const routes = [
  
  { path: '/', name: 'home', component: HomeView },
  { path: '/ordenaaqui', name: 'ordenaaqui', component: OrdenaAquiView },
  { path: '/nosotros', name: 'nosotros', component: NosotrosView },
  { path: '/blog', name: 'blog', component: BlogView },
  { path: '/carrito', name: 'carrito', component: CarritoView },
  { path: '/registrate', name: 'registrate', component: RegistrateView },
  { path: '/informacion', name: 'informacion', component: InformacionView },
  { path: '/crear-cuenta', name: 'crear-cuenta', component: CrearCuentaView },
  { path: '/ticket', name: 'ticket', component: TicketView },
  { path: '/admin', name: 'admin', component: () => import('@/views/admin/AdminView.vue'), meta: { requiereAdmin: true } },
  { path: '/categorias', name: 'categoria', component: () => import('@/views/admin/CategoriasView.vue'), meta: { requiereAdmin: true } },
  { path: '/productos', name: 'productos', component: () => import('@/views/admin/ProductosView.vue'), meta: { requiereAdmin: true } },
  { path: '/clientes', name: 'clientes', component: () => import('@/views/admin/ClientesView.vue'), meta: { requiereAdmin: true } },
  { path: '/proveedores', name: 'proveedores', component: () => import('@/views/admin/ProveedoresView.vue'), meta: { requiereAdmin: true } },
  { path: '/pedidos', name: 'pedidos', component: () => import('@/views/admin/PedidosView.vue'), meta: { requiereAdmin: true } },
  { path: '/productos/existencia', name: 'existencia', component: () => import('@/views/admin/ExistenciaView.vue'), meta: { requiereAdmin: true } },
  { path: '/compras', name: 'ventas', component: () => import('@/views/admin/ComprasView.vue'), meta: { requiereAdmin: true } },
  { path: '/historial-proveedor', name: 'historial-proveedor', component: () => import('@/views/admin/HistorialProveedorView.vue'), meta: { requiereAdmin: true } },
  { path: '/historial-pedidos', name: 'historial-pedidos', component: () => import('@/views/admin/HistorialPedidosView.vue'), meta: { requiereAdmin: true } },  
  { path: '/reportes', name: 'reportes', component: () => import('@/views/admin/ReportesView.vue'), meta: { requiereAdmin: true } }, 
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

import { useUsuarioStore } from '@/stores/usuario'

router.beforeEach((to, from, next) => {
  const usuarioStore = useUsuarioStore()
  usuarioStore.cargarDesdeLocalStorage()

  if (to.meta.requiereAdmin) {
    if (!usuarioStore.usuario || usuarioStore.usuario.rol !== 'admin') {
      return next('/') // Redirige si no tiene permiso
    }
  }

  next() // Continua si todo bien
})

// Navigation guard to check for admin access   
export default router

