(() => {
  const app = document.getElementById('app');
  const impressao = document.getElementById('impressao');
  const topoCliente = document.getElementById('cliente-topo');

  // Um briefing por link: ?b=nome-do-cliente. Sem parâmetro, usa "padrao".
  const chave = 'briefing:' + (new URLSearchParams(location.search).get('b') || 'padrao');
  let estado = carregar();

  function carregar() {
    try { return JSON.parse(localStorage.getItem(chave)) || {}; } catch (e) { return {}; }
  }

  function salvar() {
    try { localStorage.setItem(chave, JSON.stringify(estado)); } catch (e) { /* armazenamento indisponível */ }
  }

  const esc = s => String(s ?? '').replace(/[&<>"']/g, c => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c]));

  const vazio = v => v === undefined || v === null || v === '' || (Array.isArray(v) && v.every(x => !x));

  const acharComodo = id => CATALOGO.comodos.find(c => c.id === id);
  const acharSessao = (c, id) => c.sessoes.find(s => s.id === id);

  // Campos que aparecem conforme outras respostas (ex.: Antaro só mostra acabamento se for a gaveta escolhida)
  const camposDe = sessao => sessao.campos.filter(f => !f.visivelSe || estado[f.visivelSe.campo] === f.visivelSe.valor);

  const progresso = sessao => {
    const campos = camposDe(sessao);
    return { feitos: campos.filter(f => !vazio(estado[f.id])).length, total: campos.length };
  };

  const fotoHTML = (src, alt) => src
    ? `<img src="${esc(src)}" alt="${esc(alt)}" loading="lazy">`
    : `<div class="foto-vazia" aria-hidden="true">foto</div>`;

  const rotaAtual = () => location.hash.replace(/^#\/?/, '').split('/').filter(Boolean);

  // ---------- Telas ----------

  function telaInicio() {
    return `
      <section class="intro">
        <h1>${esc(CATALOGO.titulo)}</h1>
        <p>Escolha o cômodo para preencher o briefing.</p>
      </section>
      <div class="cards">
        ${CATALOGO.comodos.map(c => `
          <a class="card" href="#/${c.id}">
            ${fotoHTML(c.foto, c.nome)}
            <div class="card-texto">
              <h2>${esc(c.nome)}</h2>
              <p>${esc(c.descricao)}</p>
            </div>
          </a>`).join('')}
      </div>`;
  }

  function telaComodo(c) {
    return `
      <nav class="migalhas"><a href="#/">Início</a> / ${esc(c.nome)}</nav>
      <h1>${esc(c.nome)}</h1>
      <div class="lista">
        ${c.sessoes.map(s => {
          const p = progresso(s);
          return `
            <a class="linha ${p.feitos === p.total ? 'ok' : ''}" href="#/${c.id}/${s.id}">
              <span>${esc(s.nome)}</span>
              <span class="contagem">${p.feitos}/${p.total}</span>
            </a>`;
        }).join('')}
      </div>
      <div class="acoes">
        <button id="gerar" class="primario" data-comodo="${c.id}">Gerar briefing (PDF)</button>
      </div>`;
  }

  function telaSessao(c, s) {
    const idx = c.sessoes.indexOf(s);
    const proxima = c.sessoes[idx + 1];
    return `
      <nav class="migalhas"><a href="#/">Início</a> / <a href="#/${c.id}">${esc(c.nome)}</a> / ${esc(s.nome)}</nav>
      <h1>${esc(s.nome)}</h1>
      <div class="campos">
        ${camposDe(s).map(renderCampo).join('')}
      </div>
      <div class="acoes acoes-duas">
        <a class="secundario" href="#/${c.id}">Voltar ao ${esc(c.nome)}</a>
        ${proxima ? `<a class="primario" href="#/${c.id}/${proxima.id}">Próximo: ${esc(proxima.nome)}</a>` : ''}
      </div>`;
  }

  function telaNaoEncontrada() {
    return `<section class="intro"><h1>Página não encontrada</h1><p><a href="#/">Voltar ao início</a></p></section>`;
  }

  // ---------- Campos ----------

  function renderCampo(f) {
    const v = estado[f.id];
    const rotulo = `<span class="rotulo">${esc(f.rotulo)}</span>`;

    switch (f.tipo) {
      case 'texto':
        return `<label class="campo">${rotulo}<input data-id="${f.id}" value="${esc(v)}"></label>`;

      case 'data':
        return `<label class="campo">${rotulo}<input type="date" data-id="${f.id}" value="${esc(v)}"></label>`;

      case 'area':
        return `<label class="campo">${rotulo}<textarea rows="4" data-id="${f.id}">${esc(v)}</textarea></label>`;

      case 'cores': {
        const lista = Array.isArray(v) ? v : [];
        return `
          <fieldset class="campo">
            <legend class="rotulo">${esc(f.rotulo)}</legend>
            <div class="cores">
              ${Array.from({ length: f.quantidade }, (_, i) => `
                <label>Cor ${i + 1}
                  <input data-id="${f.id}" data-cor="${i}" value="${esc(lista[i])}">
                </label>`).join('')}
            </div>
          </fieldset>`;
      }

      case 'opcoes':
        return `
          <fieldset class="campo">
            <legend class="rotulo">${esc(f.rotulo)}</legend>
            <div class="opcoes">
              ${f.opcoes.map(o => {
                const sel = v === o.valor;
                return `
                  <button type="button" class="opcao ${sel ? 'sel' : ''}" aria-pressed="${sel}"
                          data-id="${f.id}" data-valor="${esc(o.valor)}">
                    ${fotoHTML(o.foto, o.rotulo)}
                    <span class="op-rotulo">${esc(o.rotulo)}</span>
                    ${o.descricao ? `<small>${esc(o.descricao)}</small>` : ''}
                  </button>`;
              }).join('')}
            </div>
          </fieldset>`;

      default:
        return '';
    }
  }

  // ---------- Render ----------

  function rota() {
    const [comodoId, sessaoId] = rotaAtual();
    const c = acharComodo(comodoId);
    let html;

    if (!comodoId) html = telaInicio();
    else if (!c) html = telaNaoEncontrada();
    else if (!sessaoId) html = telaComodo(c);
    else {
      const s = acharSessao(c, sessaoId);
      html = s ? telaSessao(c, s) : telaNaoEncontrada();
    }

    app.innerHTML = html;
    atualizarTopo();
  }

  function atualizarTopo() {
    topoCliente.textContent = estado.cliente || '';
  }

  // ---------- Briefing para impressão / PDF ----------

  const formatar = (f, v) => {
    if (vazio(v)) return '—';
    if (f.tipo === 'opcoes') {
      const o = f.opcoes.find(op => op.valor === v);
      return esc(o ? o.rotulo : v);
    }
    if (f.tipo === 'cores') return v.map((x, i) => x ? `${i + 1}. ${esc(x)}` : '').filter(Boolean).join('<br>') || '—';
    return esc(v).replace(/\n/g, '<br>');
  };

  function montarImpressao(c) {
    impressao.innerHTML = `
      <article class="folha">
        <header class="folha-topo">
          <h1>Briefing de Acabamentos: ${esc(c.nome)}</h1>
          <dl>
            <div><dt>Cliente</dt><dd>${esc(estado.cliente) || '—'}</dd></div>
            <div><dt>Ambiente</dt><dd>${esc(estado.ambiente) || '—'}</dd></div>
            <div><dt>Data</dt><dd>${esc(estado.data) || '—'}</dd></div>
            <div><dt>Vendedor</dt><dd>${esc(estado.vendedor) || '—'}</dd></div>
          </dl>
        </header>
        ${c.sessoes.map(s => `
          <section class="folha-secao">
            <h2>${esc(s.nome)}</h2>
            <table>
              ${camposDe(s).map(f => `<tr><th>${esc(f.rotulo)}</th><td>${formatar(f, estado[f.id])}</td></tr>`).join('')}
            </table>
          </section>`).join('')}
      </article>`;
    window.print();
  }

  // ---------- Eventos ----------

  window.addEventListener('hashchange', () => { window.scrollTo(0, 0); rota(); });

  app.addEventListener('click', e => {
    const opcao = e.target.closest('.opcao');
    if (opcao) {
      const { id, valor } = opcao.dataset;
      estado[id] = estado[id] === valor ? '' : valor;
      salvar();
      rota();
      return;
    }

    if (e.target.id === 'gerar') {
      const c = acharComodo(e.target.dataset.comodo);
      if (c) montarImpressao(c);
    }
  });

  app.addEventListener('input', e => {
    const el = e.target;
    if (!el.dataset.id) return;

    if (el.dataset.cor !== undefined) {
      const lista = Array.isArray(estado[el.dataset.id]) ? estado[el.dataset.id] : ['', '', '', ''];
      lista[Number(el.dataset.cor)] = el.value;
      estado[el.dataset.id] = lista;
    } else {
      estado[el.dataset.id] = el.value;
    }

    if (el.dataset.id === 'cliente') atualizarTopo();
    salvar();
  });

  rota();
})();
