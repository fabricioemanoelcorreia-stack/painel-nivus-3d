# Cole isto em: sessão na nuvem → menu do ambiente → Edit → Setup script
git clone --depth 1 https://github.com/fabricioemanoelcorreia-stack/painel-nivus-3d /tmp/nivus-kit 2>/dev/null \
  && bash /tmp/nivus-kit/instalar/instalar.sh \
  || { claude plugin marketplace add fabricioemanoelcorreia-stack/painel-nivus-3d;
       for p in nivus-kit ponytail agent-skills; do claude plugin install "$p@nivus" --scope user; done; }
