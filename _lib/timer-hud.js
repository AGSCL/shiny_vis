<script>
  (function () {
    // Evita duplicarlo si recargas dinámicamente
    if (document.getElementById('hud-timer-iframe')) return;
    
    // Crea el iframe una única vez, fuera del flujo de slides
    var hud = document.createElement('iframe');
    hud.id = 'hud-timer-iframe';
    hud.src = 'https://raw.githubusercontent.com/AGSCL/shiny_vis/main/_lib/timer.html';      // ← tu timer "completo" tal cual
    hud.style.position = 'fixed';
    hud.style.top = '.5%';
    hud.style.right = '1.2%';
    hud.style.width = '90px';
    hud.style.height = '52px';
    hud.style.border = '0';
    hud.style.zIndex = '9999';
    hud.style.pointerEvents = 'auto';  // si quieres poder clicarlo
    hud.setAttribute('loading', 'lazy');
    hud.setAttribute('title', 'Timer');
    
    // Anclar al body (o document.querySelector('.reveal'))
    document.addEventListener('DOMContentLoaded', function () {
      document.body.appendChild(hud);
    });
    
    // (Opcional) Reiniciar/arrancar al cambiar de slide via postMessage
    // Solo si editas timer.html para escuchar mensajes (ver Paso 3).
    if (window.Reveal) {
      var startOrReset = function () {
        try {
          hud.contentWindow.postMessage({type:'countdown:start'}, '*');
        } catch(e) {}
      };
      Reveal.on('ready', startOrReset);
      Reveal.on('slidechanged', startOrReset);
    }
  })();
</script>
  