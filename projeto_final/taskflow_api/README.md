# TaskFlow API 🚀

TaskFlow é um gerenciador de pipelines e tarefas desenvolvido em Ruby on Rails. O projeto permite criar, organizar e executar fluxos de trabalho (workflows) com suporte a dependências entre tarefas, execução paralela e processamento eficiente de resultados.

Este projeto foi desenvolvido como trabalho final da disciplina de **Fundamentos Avançados de Ruby** e demonstra a aplicação prática de conceitos, incluindo:

- **DSL (Domain-Specific Language)**: Sintaxe para criação de pipelines e tasks
- **Enumerable e Lazy Evaluation**: Processamento eficiente de resultados
- **Concorrência e Paralelismo**: Execução simultânea de tarefas independentes

## 📦 Pré Requisitos

- [Ruby](https://www.ruby-lang.org/pt/) 3.2.2
- [Ruby on Rails](https://rubyonrails.org/) 8.0.2
- [PostgreSQL](https://www.postgresql.org/) 15.13

## 🚀 Como rodar o projeto localmente
```bash
# Clone o repositório:
git clone <url-do-repositorio>
cd taskflow_api

# Instale as dependências:
bundle install

# Configure o banco de dados:
rails db:create # Cria o banco de dados
rails db:migrate # Executa as migrations
rails db:seed # Popula o banco com dados iniciais (seeds)

# Inicie o servidor:
rails server

# Acesse: http://localhost:3000
```

## 🏗️ Arquitetura do Projeto
### Modelos de Dados

#### Pipeline
Representa um fluxo de trabalho completo contendo múltiplas tarefas.

#### Task
Representa uma tarefa individual dentro do pipeline (ex: requisição HTTP, processamento de dados, envio de e-mail).

### Componentes Principais

#### 1. DSL (Domain-Specific Language)
**Localização:** `app/dsl/`
**Componentes:**
- `PipelineBuilder`: Constrói o pipeline e suas tarefas
- `TaskDefinition`: Define tarefas individuais com seus parâmetros e dependências

A DSL permite criar pipelines usando uma sintaxe Ruby expressiva e fluente:

```ruby
Pipeline.build do
  pipeline "Meu Pipeline", description: "Processamento de dados" do

    task :buscar_dados, :http_request do
      param :url, "https://api.example.com/data"
    end

    task :processar, :data_processing do
      depends_on :buscar_dados
      param :operation, "transform"
    end

    task :notificar, :email_sending do
      depends_on :processar
      param :to, "admin@example.com"
      param :subject, "Processamento concluído"
    end
  end
end
```

#### 2. Enumerable e Lazy Evaluation

**Localização:** `app/services/results_processor.rb`

O `ResultsProcessor` implementa o módulo `Enumerable` e usa avaliação preguiçosa para processar resultados de forma eficiente:

```ruby
lazy_results = @results.lazy
  .select { |r| r[:status] == "success" }    # Filtra apenas tarefas bem-sucedidas
  .map { |r| enrich_result(r) }              # Enriquece com metadados
  .take_while { |r| r[:duration] < 10 }      # Para quando encontrar tarefa lenta
```

**Benefícios:**
- Processamento sob demanda (não carrega tudo na memória)
- Pipeline de transformações encadeadas
- Interrupção antecipada quando necessário

#### 3. Concorrência e Paralelismo

**Localização:** `app/services/pipeline_executor.rb`

O executor processa tarefas de forma inteligente:

**Tarefas Independentes:**
- Executadas em **paralelo** usando Threads
- Cada tarefa roda em sua própria thread
- Uso de `Mutex` para sincronização segura de resultados

```ruby
threads = tasks.map do |task|
  Thread.new do
    result = execute_task(task)
    @mutex.synchronize { @results << result }
  end
end
threads.each(&:join)  # Aguarda todas as threads terminarem
```

**Tarefas Dependentes:**
- Executadas **sequencialmente**
- Respeitam dependências definidas
- Tarefas são puladas se dependências falharem


## 📚 Uso da API

### Endpoints Disponíveis

#### 1. Listar Pipelines Ativos
```http
GET /api/v1/pipelines
```

#### 2. Visualizar Pipeline Específico
```http
GET /api/v1/pipelines/:id
```

#### 3. Criar Novo Pipeline
```http
POST /api/v1/pipelines
Content-Type: application/json

{
  "pipeline": {
    "name": "Meu Pipeline",
    "description": "Descrição do pipeline"
  }
}
```

### Via Console Rails

```ruby
# Inicie o console
rails console

# Carregue um pipeline
pipeline = Pipeline.find_by(name: "Data Processing Pipeline")

# Crie o executor
executor = PipelineExecutor.new(pipeline)

# Execute o pipeline
result = executor.run

# Visualize os resultados
puts JSON.pretty_generate(result)
```

### Exemplo de Resultado

```json
{
  "summary": {
    "total": 3,
    "successful": 3,
    "failed": 0,
    "skipped": 0
  },
  "successful_tasks": [
    {
      "task_id": 1,
      "task_name": "fetch_data",
      "task_type": "http_request",
      "status": "success",
      "output": {
        "url": "https://api.example.com/data",
        "code": 200,
        "body": {
          "data": "simulated response",
          "size": 1024
        },
        "timestamp": "2025-11-14 16:58:23 UTC"
      },
      "duration": 0.406,
      "executed_at": "2025-11-14 16:58:23 UTC",
      "thread_id": 77080,
      "performance_level": "excellent",
      "timestamp_formatted": "2025-11-14 16:58:23"
    }
  ],
  "statistics": {
    "avg_duration": 0.309,
    "min_duration": 0.234,
    "max_duration": 0.406,
    "total_duration": 0.927
  }
}
```

### Criar Pipeline com DSL

```ruby
# Crie um pipeline de relatórios diários
Pipeline.build do
  pipeline "Daily Reports", description: "Gera relatórios diários" do

    # Tarefas paralelas (não têm dependências)
    task :fetch_sales, :http_request do
      param :url, "https://api.example.com/sales"
    end

    task :fetch_inventory, :http_request do
      param :url, "https://api.example.com/inventory"
    end

    # Tarefa dependente (aguarda as anteriores)
    task :generate_report, :data_processing do
      depends_on :fetch_sales, :fetch_inventory
      param :operation, "merge"
    end

    # Notificação final
    task :send_report, :email_sending do
      depends_on :generate_report
      param :to, "ceo@company.com"
      param :subject, "Daily Report"
    end
  end
end
```

## 📊 Tipos de Tarefas Suportados

### 1. `http_request`
Simula requisições HTTP (GET, POST, etc.)

**Parâmetros:**
- `url` (string): URL do endpoint
- `method` (string): Método HTTP
- `timeout` (integer): Timeout em segundos

### 2. `data_processing`
Processa dados com diversas operações

**Parâmetros:**
- `operation` (string): Tipo de operação (reverse, transform, merge, etc.)
- `data` (string): Dados a serem processados

### 3. `email_sending`
Simula envio de e-mails

**Parâmetros:**
- `to` (string): Destinatário
- `subject` (string): Assunto do e-mail
