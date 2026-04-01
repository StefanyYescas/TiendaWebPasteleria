import axios from 'axios'

const api = axios.create({
  baseURL: 'http://localhost:3000/api' // Asegúrate que tu backend esté corriendo ahí
})

export default api
