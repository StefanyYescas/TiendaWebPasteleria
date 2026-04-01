<!-- src/components/icons/IconoCorazon.vue -->
<template>
    <svg
      xmlns="http://www.w3.org/2000/svg"
      width="24"
      height="24"
      viewBox="0 0 512 512"
      preserveAspectRatio="xMidYMid meet"
      class="icono-corazon"
    >
      <g transform="translate(0,512) scale(0.1,-0.1)" fill="currentColor" stroke="none">
        <path d="M1835 3872 c-164 -57 -272 -185 -326 -387 -31 -113 -31 -337 -1 -481
        42 -198 125 -400 250 -612 87 -146 187 -285 407 -567 209 -268 293 -381 373
        -503 l61 -92 27 47 c15 27 47 84 72 128 64 112 243 385 412 625 406 578 505
        765 526 995 23 259 -148 507 -386 556 -135 28 -267 -12 -369 -113 -90 -89
        -139 -173 -306 -533 l-37 -80 -19 123 c-34 230 -92 418 -190 620 -102 210
        -207 292 -372 292 -42 -1 -93 -8 -122 -18z"/>
      </g>
    </svg>
  </template>
  
  <script setup>
  // Sin lógica por ahora, a menos que quieras props personalizadas
  </script>
  
  <style scoped>
  .icono-corazon {
    cursor: pointer;
    transition: fill 0.3s ease;
    
  }
  
  .icono-corazon:hover {
    fill: #a80606;
  }
  </style>
  