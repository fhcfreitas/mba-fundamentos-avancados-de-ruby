Task.destroy_all
Pipeline.destroy_all

# Pipeline 1: Processamento de Dados
pipeline1 = Pipeline.build do
  pipeline "Data Processing Pipeline",
    description: "Pipeline para processar e analisar dados",
    priority: "high",
    retry_policy: "exponential"

  task :fetch_data, :http_request do
    param :url, "https://api.example.com/data"
    param :method, "GET"
    param :timeout, 30
    position 0
  end

  task :transform_data, :data_processing do
    depends_on :fetch_data
    param :operation, "transform"
    param :data, "sample_data_string"
    position 1
  end

  task :notify_completion, :email_sending do
    depends_on :transform_data
    param :to, "admin@example.com"
    param :subject, "Data Processing Complete"
    position 2
  end
end

puts "✅ Pipeline criado: #{pipeline1.name} (#{pipeline1.tasks.count} tarefas)"

# Pipeline 2: API Integration
pipeline2 = Pipeline.build do
  pipeline "API Integration Pipeline",
    description: "Pipeline para integração com APIs externas",
    environment: "production"

  task :fetch_users, :http_request do
    param :url, "https://jsonplaceholder.typicode.com/users"
    param :method, "GET"
    position 0
  end

  task :fetch_posts, :http_request do
    param :url, "https://jsonplaceholder.typicode.com/posts"
    param :method, "GET"
    position 0
  end

  task :merge_data, :data_processing do
    depends_on :fetch_users, :fetch_posts
    param :operation, "merge"
    param :data, "users_and_posts"
    position 1
  end

  task :send_report, :email_sending do
    depends_on :merge_data
    param :to, "reports@example.com"
    param :subject, "Daily API Integration Report"
    position 2
  end
end

puts "✅ Pipeline criado: #{pipeline2.name} (#{pipeline2.tasks.count} tarefas)"

# Pipeline 3: Workflow Simples
pipeline3 = Pipeline.build do
  pipeline "Simple Workflow",
    description: "Workflow simples para testes",
    tags: [ "test", "simple" ]

  task :start, :data_processing do
    param :operation, "initialize"
    param :data, "workflow_started"
    position 0
  end

  task :process_step1, :data_processing do
    depends_on :start
    param :operation, "reverse"
    param :data, "step_one_data"
    position 1
  end

  task :process_step2, :data_processing do
    depends_on :start
    param :operation, "upcase"
    param :data, "step_two_data"
    position 1
  end

  task :finalize, :email_sending do
    depends_on :process_step1, :process_step2
    param :to, "workflow@example.com"
    param :subject, "Workflow Completed Successfully"
    position 2
  end
end

puts "✅ Pipeline criado: #{pipeline3.name} (#{pipeline3.tasks.count} tarefas)"

# Pipeline 4: Parallel Processing
pipeline4 = Pipeline.build do
  pipeline "Parallel Processing Demo",
    description: "Demonstração de processamento paralelo",
    max_threads: 5

  5.times do |i|
    task "parallel_task_#{i + 1}".to_sym, :http_request do
      param :url, "https://api.example.com/endpoint-#{i + 1}"
      param :method, "GET"
      position 0
    end
  end

  task :aggregate_results, :data_processing do
    depends_on :parallel_task_1, :parallel_task_2, :parallel_task_3,
               :parallel_task_4, :parallel_task_5
    param :operation, "aggregate"
    param :data, "all_parallel_results"
    position 1
  end
end

puts "✅ Pipeline criado: #{pipeline4.name} (#{pipeline4.tasks.count} tarefas)"

# Pipeline 5: Complex Dependencies
pipeline5 = Pipeline.create!(
  name: "Complex Dependencies Pipeline",
  description: "Pipeline com dependências complexas",
  configuration: { complexity_level: "advanced" },
  status: :active
)

# Criar tarefas manualmente para demonstrar flexibilidade
pipeline5.tasks.create!([
  {
    name: "init",
    task_type: "data_processing",
    params: { operation: "init" },
    position: 0,
    depends_on: []
  },
  {
    name: "branch_a",
    task_type: "http_request",
    params: { url: "https://api.example.com/branch-a" },
    position: 1,
    depends_on: [ "init" ]
  },
  {
    name: "branch_b",
    task_type: "http_request",
    params: { url: "https://api.example.com/branch-b" },
    position: 1,
    depends_on: [ "init" ]
  },
  {
    name: "merge",
    task_type: "data_processing",
    params: { operation: "merge", data: "branches_merged" },
    position: 2,
    depends_on: [ "branch_a", "branch_b" ]
  },
  {
    name: "final_notification",
    task_type: "email_sending",
    params: { to: "final@example.com", subject: "Complex Pipeline Done" },
    position: 3,
    depends_on: [ "merge" ]
  }
])

puts "✅ Pipeline criado: #{pipeline5.name} (#{pipeline5.tasks.count} tarefas)"

# Pipeline 6: Draft (não ativo)
pipeline6 = Pipeline.create!(
  name: "Future Pipeline",
  description: "Pipeline em desenvolvimento",
  configuration: { status: "under_construction" },
  status: :draft
)

pipeline6.tasks.create!([
  {
    name: "placeholder_task",
    task_type: "data_processing",
    params: { operation: "placeholder" },
    position: 0,
    depends_on: []
  }
])

puts "✅ Pipeline criado (draft): #{pipeline6.name}"
