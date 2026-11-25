# Lab Rats

Puzzle 2D em que um rato desliza pelo labirinto. Escolha a direção de partida e use as paredes, os pisos de parada e os redirecionadores para alcançar a saída. Nas fases com portas coloridas, colete todas as chaves da cor correspondente para abri-las. Os espinhos são letais ao serem atingidos de frente.

O jogo tem cinco fases, acessíveis pelo menu **Levels**. **Play** abre a fase mais recente da sessão. Após a quinta fase, use o botão de saída da tela de vitória ou pressione **Enter** para voltar ao início.

## Controles

| Entrada | Ação |
| --- | --- |
| Setas ou **WASD** | Escolher a direção quando o rato está parado |
| **P** ou **Esc** | Pausar ou retomar a fase |
| **R** | Reiniciar a fase, inclusive a partir da pausa |
| **Enter** na tela de vitória | Avançar ou voltar ao menu após a última fase |
| **F** no navegador | Alternar tela cheia com o jogo em foco |
| Mouse | Usar os botões dos menus de seleção, pausa e vitória |

## Código e eventos

O projeto declara Godot **4.7** e usa **GDScript**, **TileMapLayer**, o renderer **GL Compatibility**, sprites 2D, fontes TTF e áudio MP3. O editor e os templates usados para validação e exportação são os oficiais da versão **4.7.2 stable**.

- `scenes/levels/` contém as cinco fases e os três modelos reutilizáveis. `scripts/s_levels/level_template.gd` registra a fase ativa e reinicializa os contadores de chaves toda vez que uma fase é instanciada.
- `scenes/objects/` e `scripts/s_objects/` contêm o rato e os objetos interativos. Os sinais `body_entered` e `body_exited` de `Area2D` ligam a colisão aos efeitos sobre o jogador. O portal e o inimigo patrulheiro existem como objetos reutilizáveis e ficam fora das cinco fases atuais.
- `scenes/management/` e `scripts/s_managment/` contêm os menus, a câmera e os serviços globais. Os botões emitem `pressed` para acionar as transições.

| Autoload | Responsabilidade |
| --- | --- |
| `GameManager` | Catálogo ordenado, número da fase ativa e totais de chaves por cor. |
| `Events` | `key_collected` avisa as portas quando a contagem muda. `camera_shake` transmite a intensidade e a duração do impacto à câmera. |
| `PauseMenu` e `VictoryMenu` | Controlam as sobreposições, o estado de pausa da `SceneTree` e as transições a partir dos menus. |
| `SoundPlayer` | Reproduz música e efeitos. Cada efeito libera seu player pelo sinal `finished`. Na Web, a música começa após uma interação. |

## Executar no Linux

Baixe o editor oficial em [Godot 4.7.2 stable](https://github.com/godotengine/godot-builds/releases/tag/4.7.2-stable), importe `project.godot` pelo gerenciador de projetos e pressione **F5**. Com o executável no PATH, também é possível abrir o jogo pelo terminal.

```bash
godot --path .
```

## Exportar e incorporar no portfólio

Instale os templates **4.7.2 stable** pelo menu **Editor → Manage Export Templates**. Na janela **Project → Export**, escolha **Web** e exporte em modo Release para `builds/web/index.html`. Para fazer o mesmo pelo terminal, a partir da raiz:

```bash
godot --headless --editor --import
mkdir -p builds/web
godot --headless --export-release Web builds/web/index.html
python3 -m http.server 8000 --bind 127.0.0.1 --directory builds/web
```

Abra `http://127.0.0.1:8000/`. Para publicar em GitHub Pages, coloque **todo** o conteúdo de `builds/web/` no diretório publicado. O HTML, o JavaScript, o WebAssembly, o pacote de recursos e os scripts de áudio usam caminhos relativos. O preset usa Compatibility, execução sem threads e redimensionamento automático do canvas. O jogo mantém a proporção 16:9 e roda sem cabeçalhos COOP/COEP.

```html
<iframe
  src="./lab-rats/index.html"
  title="Lab Rats"
  allow="autoplay; fullscreen"
  allowfullscreen
  style="display: block; width: 100%; aspect-ratio: 16 / 9; border: 0">
</iframe>
```

Clique no jogo para dar foco ao teclado e desbloquear o áudio. O navegador precisa oferecer WebAssembly e WebGL 2. A exportação deve ser servida via HTTP local ou HTTPS. A movimentação usa teclado, e o progresso dura apenas durante a sessão. Em um iframe, o site hospedeiro precisa permitir tela cheia.

## Validação

O GitHub Actions importa o projeto, verifica a inicialização e as cenas, roda o teste de fluxo headless e publica o artefato **lab-rats-web**. O workflow roda em pushes fora de `main` e em Pull Requests para `main`.

```bash
godot --headless --editor --import
godot --headless --fixed-fps 60 --quit-after 10000 res://tests/smoke.tscn
```
