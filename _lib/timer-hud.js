<script>
(function () {
  if (document.getElementById('hud-timer-iframe')) return;

  var URL_RAW = "https://raw.githubusercontent.com/AGSCL/shiny_vis/main/_lib/timer.html";

  var hud = document.createElement('iframe');
  hud.id = 'hud-timer-iframe';
  hud.style.position = 'fixed';
  hud.style.top = '.5%';
  hud.style.right = '.5%';
  hud.style.width = '90px';
  hud.style.height = '55px';
  hud.style.border = '0';
  hud.style.zIndex = '9999';
  // primero insertamos el iframe vacío
  document.addEventListener('DOMContentLoaded', function () {
    (document.querySelector('.reveal') || document.body).appendChild(hud);
  });

  // luego traemos el HTML y lo inyectamos como srcdoc
  fetch(URL_RAW, { cache: 'no-store' })
    .then(function (r) { return r.text(); })
    .then(function (txt) {
      hud.srcdoc = txt;  // evita problemas de cross-origin/headers
    })
    .catch(function (e) {
      console.error('No se pudo cargar el timer:', e);
    });
})();
</script>
