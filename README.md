# NextPlay - Game Catalog App

**NextPlay** é um aplicativo mobile desenvolvido com **Flutter** para visualização e avaliação de um catálogo de jogos. O app consome uma API FastAPI e oferece uma interface moderna para explorar jogos, ver detalhes, avaliações e comentários.

## 🚀 Funcionalidades

- **Exploração de Jogos**: Lista completa de jogos com paginação.
- **Busca e Filtros**: Pesquise por título e filtre por gênero.
- **Detalhes do Jogo**: Informações detalhadas, desenvolvedora, preço e nota.
- **Avaliações e Comentários**: Veja o que outros jogadores estão dizendo sobre seus jogos favoritos.
- **Design Moderno**: Interface limpa e responsiva seguindo as melhores práticas de UI/UX.

## 🛠️ Tecnologias Utilizadas

- **Flutter**: Framework UI para desenvolvimento mobile.
- **Riverpod**: Gerenciamento de estado reativo e injeção de dependências.
- **Dio**: Cliente HTTP para consumo da API.
- **Google Fonts**: Tipografia moderna (Inter/Roboto).
- **Clean Architecture (Feature-based)**: Organização do código focada em escalabilidade e facilidade de manutenção.

## 📁 Estrutura do Projeto

```
lib/
├── core/               # Componentes compartilhados (temas, constantes, utils)
├── features/           # Funcionalidades do app
│   └── games/          # Módulo de jogos
│       ├── data/       # Modelos e repositórios
│       ├── presentation/ # Telas (pages) e widgets
│       └── providers/  # Lógica de estado (Riverpod)
└── main.dart           # Ponto de entrada do aplicativo
```

## ⚙️ Configuração e Execução

### Pré-requisitos
- Flutter SDK instalado
- Emulador Android/iOS ou dispositivo físico conectado
- **Game Catalog API** rodando (preferencialmente via Docker)

### Passos para rodar
1. **Clonar o repositório**
2. **Instalar dependências**
   ```bash
   flutter pub get
   ```
3. **Configurar a URL da API**
   Verifique o arquivo `lib/core/constants/constants.dart` (ou similar) para garantir que a `baseUrl` aponta para o endereço correto da sua API (ex: `http://10.0.2.2:8000` para o emulador Android).
4. **Executar o app**
   ```bash
   flutter run
   ```

## 🐳 Integração com Docker
Este aplicativo faz parte do ecossistema NextPlay, que inclui uma API totalmente dockerizada. Para uma experiência completa, certifique-se de que a API esteja rodando no Docker Hub ou localmente via `docker-compose`.

---

Desenvolvido com ❤️ por Shyader.
