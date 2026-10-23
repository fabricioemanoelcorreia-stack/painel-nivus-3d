// Catálogo do briefing. Para novos cômodos, copie um bloco de `comodos`.
// Fotos: coloque os arquivos em briefing/fotos/ e preencha o campo `foto` (cômodo) ou `foto` (opção).
const CATALOGO = {
  titulo: 'Briefing de Acabamentos',
  comodos: [
    {
      id: 'banheiro',
      nome: 'Banheiro',
      descricao: 'Acabamentos de marcenaria, marmoraria, esquadrias e instalações.',
      foto: null,
      sessoes: [
        {
          id: 'dados',
          nome: 'Dados gerais',
          campos: [
            { id: 'cliente', tipo: 'texto', rotulo: 'Cliente' },
            { id: 'data', tipo: 'data', rotulo: 'Data' },
            { id: 'ambiente', tipo: 'texto', rotulo: 'Nome do ambiente' },
            { id: 'vendedor', tipo: 'texto', rotulo: 'Vendedor' },
            { id: 'pd_laje', tipo: 'texto', rotulo: 'P.D. na laje' },
            { id: 'pd_rebaixo', tipo: 'texto', rotulo: 'P.D. rebaixo de gesso' }
          ]
        },
        {
          id: 'instalacoes',
          nome: 'Pontos elétricos e hidráulicos',
          campos: [
            {
              id: 'alt_eletricos', tipo: 'opcoes', rotulo: 'Alteração de pontos elétricos',
              opcoes: [
                { valor: 'todos', rotulo: 'Todos' },
                { valor: 'nenhum', rotulo: 'Nenhum' },
                { valor: 'necessario', rotulo: 'Somente o necessário' }
              ]
            },
            {
              id: 'alt_hidraulicos', tipo: 'opcoes', rotulo: 'Alteração de pontos hidráulicos',
              opcoes: [
                { valor: 'todos', rotulo: 'Todos' },
                { valor: 'nenhum', rotulo: 'Nenhum' },
                { valor: 'necessario', rotulo: 'Somente o necessário' }
              ]
            }
          ]
        },
        {
          id: 'marmoraria',
          nome: 'Marmoraria',
          campos: [
            {
              id: 'tampo_existente', tipo: 'opcoes', rotulo: 'Tampo existente',
              opcoes: [{ valor: 'sim', rotulo: 'Sim' }, { valor: 'nao', rotulo: 'Não' }]
            },
            {
              id: 'tampo_material', tipo: 'opcoes', rotulo: 'Material do tampo',
              opcoes: [{ valor: 'granito', rotulo: 'Granito' }, { valor: 'corian', rotulo: 'Corian' }]
            },
            { id: 'tampo_espessura', tipo: 'texto', rotulo: 'Espessura do tampo' },
            { id: 'roda_pia', tipo: 'texto', rotulo: 'Roda pia' },
            {
              id: 'cuba', tipo: 'opcoes', rotulo: 'Tipo de cuba',
              opcoes: [
                { valor: 'embutir', rotulo: 'Embutir' },
                { valor: 'sobrepor', rotulo: 'Sobrepor' },
                { valor: 'semi_encaixe', rotulo: 'Semi encaixe' }
              ]
            }
          ]
        },
        {
          id: 'esquadrias',
          nome: 'Esquadrias',
          campos: [
            {
              id: 'modelo_porta', tipo: 'opcoes', rotulo: 'Modelo de porta',
              opcoes: [
                { valor: 'reta', rotulo: 'Reta' },
                { valor: 'lam_madeira', rotulo: 'Lâm. de madeira' },
                { valor: 'ripada', rotulo: 'Ripada' },
                { valor: 'provencal', rotulo: 'Provençal' },
                { valor: 'cinex', rotulo: 'Cinex' }
              ]
            },
            { id: 'cor_portas', tipo: 'texto', rotulo: 'Cor das portas' },
            { id: 'perfil_cinex_cor', tipo: 'texto', rotulo: 'Perfil Cinex: cor' },
            { id: 'perfil_cinex_vidro', tipo: 'texto', rotulo: 'Perfil Cinex: vidro' }
          ]
        },
        {
          id: 'marcenaria',
          nome: 'Marcenaria',
          campos: [
            {
              id: 'armario_superior', tipo: 'opcoes', rotulo: 'Armário superior',
              opcoes: [
                { valor: 'melaminico', rotulo: 'Melamínico' },
                { valor: 'cinex', rotulo: 'Cinex' },
                { valor: 'espelho_colado', rotulo: 'Espelho colado' }
              ]
            },
            {
              id: 'tamponamento', tipo: 'opcoes', rotulo: 'Espessura do tamponamento',
              opcoes: [{ valor: '18,5', rotulo: '18,5' }, { valor: '25,5', rotulo: '25,5' }]
            },
            { id: 'tamponamento_cor', tipo: 'texto', rotulo: 'Cor do tamponamento' },
            {
              id: 'prateleiras', tipo: 'opcoes', rotulo: 'Prateleiras internas',
              opcoes: [
                { valor: '18,5', rotulo: '18,5' },
                { valor: '25,5', rotulo: '25,5' },
                { valor: 'vidro', rotulo: 'Vidro' }
              ]
            },
            {
              id: 'tulha', tipo: 'opcoes', rotulo: 'Tulha',
              opcoes: [{ valor: 'tandem', rotulo: 'Tandem' }, { valor: 'tulha_piva', rotulo: 'Tulha Piva' }]
            },
            {
              id: 'gaveta', tipo: 'opcoes', rotulo: 'Modelo de gaveta',
              opcoes: [
                { valor: 'legrabox', rotulo: 'Legrabox' },
                { valor: 'antaro', rotulo: 'Antaro' },
                { valor: 'tandem', rotulo: 'Tandem' }
              ]
            },
            {
              id: 'antaro_acabamento', tipo: 'opcoes', rotulo: 'Antaro: acabamento',
              visivelSe: { campo: 'gaveta', valor: 'antaro' },
              opcoes: [{ valor: 'cinza', rotulo: 'Cinza' }, { valor: 'inox', rotulo: 'Inox' }]
            },
            {
              id: 'tandem_extracao', tipo: 'opcoes', rotulo: 'Tandem: extração',
              visivelSe: { campo: 'gaveta', valor: 'tandem' },
              opcoes: [{ valor: 'total', rotulo: 'Extração total' }, { valor: 'parcial', rotulo: 'Extração parcial' }]
            }
          ]
        },
        {
          id: 'cores',
          nome: 'Cores',
          campos: [
            { id: 'cores_internas', tipo: 'cores', rotulo: 'Cores internas', quantidade: 4 },
            { id: 'cores_externas', tipo: 'cores', rotulo: 'Cores externas', quantidade: 4 }
          ]
        },
        {
          id: 'acessorios',
          nome: 'Iluminação e acessórios',
          campos: [
            {
              id: 'iluminacao', tipo: 'opcoes', rotulo: 'Iluminação',
              opcoes: [{ valor: '2700K', rotulo: '2700K' }, { valor: '3000K', rotulo: '3000K' }, { valor: '4000K', rotulo: '4000K' }]
            },
            {
              id: 'acionamento', tipo: 'opcoes', rotulo: 'Acionamento',
              opcoes: [
                { valor: 'botao', rotulo: 'Botão' },
                { valor: 'presenca', rotulo: 'Sensor de presença' },
                { valor: 'gesto', rotulo: 'Sensor de gesto' },
                { valor: 'porta', rotulo: 'Sensor de porta' }
              ]
            },
            { id: 'acessorios', tipo: 'texto', rotulo: 'Acessórios' },
            {
              id: 'puxador_tipo', tipo: 'opcoes', rotulo: 'Puxador: orientação',
              opcoes: [{ valor: 'horizontal', rotulo: 'Horizontal' }, { valor: 'vertical', rotulo: 'Vertical' }]
            },
            { id: 'puxador_cor', tipo: 'texto', rotulo: 'Puxador: cor' }
          ]
        },
        {
          id: 'observacoes',
          nome: 'Observações e desenho',
          campos: [
            { id: 'observacoes', tipo: 'area', rotulo: 'Observações' },
            { id: 'divisoes', tipo: 'area', rotulo: 'Divisões internas ou nichos (desenho no verso da ficha)' }
          ]
        }
      ]
    }
  ]
};
