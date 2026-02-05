# NextPlay - Game Catalog App

**NextPlay** é um aplicativo mobile desenvolvido com **Flutter** para visualização e avaliação de um catálogo de jogos. O app consome uma API FastAPI e oferece uma interface moderna para explorar jogos, ver detalhes, avaliações e comentários.

## Funcionalidades

- **Exploração de Jogos**: Lista completa de jogos com paginação e carregamento eficiente.
- **Busca Avançada com Filtros**: 
    - **Pesquisa por Nome**: Encontre jogos instantaneamente digitando o título.
    - **Filtros por Gênero**: Seleção dinâmica de gêneros carregados diretamente da API.
    - **Filtro de Preço**: Slider intuitivo para filtrar jogos por faixa de preço.
- **Detalhes do Jogo**: Informações detalhadas, desenvolvedora, plataforma, preço e notas médias.
- **Avaliações e Comentários**: Sistema completo para visualizar reviews e feedbacks de outros usuários.
- **Design Moderno (Dark Mode)**: Interface premium com tema escuro, tipografia Poppins e micro-animações.

## Tecnologias Utilizadas

- **Flutter**: Framework UI para desenvolvimento nativo multiplataforma.
- **Riverpod**: Gerenciamento de estado reativo de alto desempenho (usado para filtros em tempo real).
- **Dio**: Cliente HTTP robusto para consumo de API com interceptores e tratamento de erros.
- **Google Fonts (Poppins)**: Tipografia moderna e elegante.
- **Clean Architecture (Feature-based)**: Arquitetura focada em separação de responsabilidades (Data, Presentation, Providers).

## Estrutura do Projeto

```
lib/
├── core/               # Componentes globais (temas, constantes da API)
├── features/           # Módulos isolados por funcionalidade
│   └── games/          # Core do catálogo de jogos
│       ├── data/       # Modelos (Game, Genre, Review) e Repositórios
│       ├── presentation/ # UI (Pages como SearchGamesPage e Widgets)
│       └── providers/  # Estado com Riverpod (filtros, lista de jogos)
└── main.dart           # Inicialização e configuração do tema
```

## Configuração e Execução

### Pré-requisitos
- Flutter SDK (^3.10.4)
- Um dispositivo Android/iOS ou Emulador
- **API Game Catalog** ativa (Docker Hub: `shayderfaustino/game-catalog-api:latest`)

### Passos para rodar
1. **Instalar dependências**
   ```bash
   flutter pub get
   ```
2. **Configurar a API**
   O app se comunica com a API. Certifique-se de configurar a `baseUrl` no arquivo de constantes para o IP do seu servidor ou `10.0.2.2` para emulador Android.
3. **Executar o app**
   ```bash
   flutter run
   ```

## 🐳 Integração com o Backend
Este app foi projetado para trabalhar em conjunto com a **Game Catalog API**. A API suporta persistência via SQLite em volumes Docker, garantindo que suas avaliações e novos jogos sejam salvos permanentemente.

---

Desenvolvido por Shayder.
