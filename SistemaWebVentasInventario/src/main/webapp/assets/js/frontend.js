/* Frontend V2: interacciones visuales; datos y permisos siguen siendo del backend. */
document.documentElement.classList.add('js');

document.addEventListener('DOMContentLoaded', () => {
  // Menú adaptable sin dependencia de Bootstrap.
  const navToggle = document.querySelector('[data-nav-toggle]');
  const navLinks = document.querySelector('[data-nav-links]');
  if (navToggle && navLinks) {
    navToggle.addEventListener('click', () => {
      const expanded = navToggle.getAttribute('aria-expanded') === 'true';
      navToggle.setAttribute('aria-expanded', String(!expanded));
      navToggle.setAttribute('aria-label', expanded ? 'Abrir menú' : 'Cerrar menú');
      navLinks.classList.toggle('is-open', !expanded);
    });
  }

  // Confirmaciones. Un formulario de eliminación solo se envía después de aceptar.
  document.querySelectorAll('form[data-confirm]').forEach((form) => {
    form.addEventListener('submit', (event) => {
      const message = form.dataset.confirm || '¿Deseas continuar?';
      if (!window.confirm(message)) event.preventDefault();
    });
  });

  // Validación de números. El servidor sigue aplicando sus propias reglas.
  document.querySelectorAll('input[type="number"][min]').forEach((input) => {
    input.addEventListener('input', () => {
      if (input.validity.badInput || input.validity.rangeUnderflow || input.validity.stepMismatch) {
        input.setCustomValidity('Revisa el valor ingresado.');
      } else {
        input.setCustomValidity('');
      }
    });
  });

  // Búsqueda local y filtros sobre los productos que envía ProductoServlet.
  // No hacemos cambios en BD ni llamamos a rutas nuevas.
  const tableBody = document.getElementById('productos-body');
  const search = document.getElementById('buscar');
  const stockFilter = document.getElementById('filtro-stock');
  const counter = document.getElementById('contador');
  const emptyState = document.getElementById('sin-resultados');
  const reset = document.getElementById('limpiar-filtros');
  if (tableBody && search && stockFilter && counter && emptyState) {
    const rows = Array.from(tableBody.querySelectorAll('tr[data-product-row]'));
    const normalize = (value) => String(value || '').normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '').toLocaleLowerCase('es').trim();

    function applyFilters() {
      const term = normalize(search.value);
      const selected = stockFilter.value;
      let visible = 0;
      rows.forEach((row) => {
        const code = normalize(row.dataset.code);
        const id = normalize(row.dataset.id);
        const name = normalize(row.dataset.name);
        const stock = Number(row.dataset.stock);
        const matchesText = !term || code.includes(term) || id.includes(term) || name.includes(term);
        const matchesStock = selected === 'todos' ||
          (selected === 'disponible' && stock > 0) ||
          (selected === 'bajo' && stock > 0 && stock < 10) ||
          (selected === 'agotado' && stock <= 0);
        const match = matchesText && matchesStock;
        row.hidden = !match;
        if (match) visible++;
      });
      counter.textContent = `${visible} ${visible === 1 ? 'producto' : 'productos'}`;
      emptyState.hidden = visible !== 0;
      emptyState.textContent = rows.length === 0
        ? 'Todavía no hay productos registrados.'
        : 'No se encontraron productos con esos filtros.';
    }
    search.addEventListener('input', applyFilters);
    stockFilter.addEventListener('change', applyFilters);
    if (reset) reset.addEventListener('click', () => {
      search.value = '';
      stockFilter.value = 'todos';
      applyFilters();
      search.focus();
    });
    applyFilters();
  }
});
