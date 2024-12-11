// Agregar animación de entrada al desplazarse
const productList = document.querySelectorAll('.product');

const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
        if (entry.isIntersecting) {
            entry.target.style.animationDelay = `${Math.random() * 0.5}s`;
            entry.target.classList.add('visible');
        }
    });
}, {
   

