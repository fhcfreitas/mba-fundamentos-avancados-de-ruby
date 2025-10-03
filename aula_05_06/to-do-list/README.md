# Exercicio Aula 5 e 6 - To Do List API

### Tecnologias Utilizadas
- Ruby 3.2.2
- Rails 8.0.2
- PostgreSQL 15.13
- SolidQueue
- Ransack

### Setup

```bash
# Clone o repositório
  git clone git@github.com:fhcfreitas/mba-fundamentos-avancados-de-ruby.git

# Entre na pasta da aplicação
  cd aula_05_06/to-do-list

# Instale as dependências
  bundle install

# Configure o banco de dados
  rails db:create     # Cria o banco de dados
  rails db:migrate    # Executa as migrações
  rails db:seed       # Popula o banco com dados iniciais (seeds)

# Inicie o servidor
  rails server
```

## Funcionalidades da API

### Listar Tarefas
```bash
curl -X GET localhost:3000 \

ou
curl -X GET localhost:3000/tasks \
```

### Listar tarefas filtradas por critério

Filtrar o campo desejado (`title`, `description`, `status`, `created_at`, `due_date`) utilizando os [search matchers do Ransack](https://activerecord-hackery.github.io/ransack/getting-started/search-matches/)

```bash
curl -X GET localhost:3000/tasks -d 'q[title_cont]=testes'
curl -X GET localhost:3000/tasks -d 'q[status_eq]=ongoing'
curl -X GET localhost:3000/tasks -d 'q[due_date_gteq]=2025-10-01'
```

### Criar uma tarefa
```bash
curl -X POST localhost:3000/tasks \
-H "Content-Type: application/json" \
-d '{ "task": {"title": "Nova Tarefa", "description": "Descrição da tarefa a ser executada", "due_date": "2025-10-31"}}'
```

### Visualizar uma tarefa
 ```bash
curl -X GET localhost:3000/tasks/:id \
-H "Content-Type: application/json"
```

### Atualizar uma tarefa
```bash
curl -X PUT localhost:3000/tasks/:id \
-H "Content-Type: application/json" \
-d '{ "task": {"status": "completed"}}'
```

### Deletar Tarefa - Atualiza o status para cancelled e preenche o campo delete_at com a data da exclusão (soft delete)
 ```bash
curl -X DELETE localhost:3000/tasks/:id \
-H "Content-Type: application/json"
```

### CheckTaskOverdueDateJob

Job que verifica tarefas com `status` == ongoing e se `due_date` (data de entrega) já passou. O job foi programado para rodar a cada minuto. Para vê-lo funcionando automaticamente, execute no terminal:
```bash
bin/jobs start
```
