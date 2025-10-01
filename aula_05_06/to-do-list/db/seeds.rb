# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Task.destroy_all

Task.create!([
  {
    title: "Implementar autenticação de usuários",
    description: "Adicionar sistema de login e registro com Devise",
    status: :ongoing,
    due_date: Date.today + 5.days
  },
  {
    title: "Corrigir bug no carrinho de compras",
    description: "Usuários relatam que itens duplicados aparecem no checkout",
    status: :completed,
    due_date: Date.today - 3.days
  },
  {
    title: "Atualizar documentação da API",
    description: "Documentar novos endpoints criados no último sprint",
    status: :overdue,
    due_date: Date.today - 7.days
  },
  {
    title: "Migrar banco de dados para PostgreSQL",
    description: "Realizar migração do MySQL para PostgreSQL em produção",
    status: :cancelled,
    due_date: Date.today + 2.days,
    deleted_at: Date.today - 1.day
  },
  {
    title: "Implementar testes unitários",
    description: "Aumentar cobertura de testes para pelo menos 80%",
    status: :ongoing,
    due_date: Date.today + 10.days
  },
  {
    title: "Redesign da página inicial",
    description: "Atualizar layout seguindo as novas diretrizes de UX",
    status: :ongoing,
    due_date: Date.today + 15.days
  },
  {
    title: "Otimizar queries do dashboard",
    description: "Reduzir tempo de carregamento do dashboard principal",
    status: :completed,
    due_date: Date.today - 2.days
  },
  {
    title: "Configurar CI/CD pipeline",
    description: "Implementar deploy automático com GitHub Actions",
    status: :overdue,
    due_date: Date.today - 5.days
  },
  {
    title: "Revisar política de privacidade",
    description: "Atualizar termos de acordo com LGPD",
    status: :cancelled,
    due_date: Date.today + 1.day,
    deleted_at: Date.today
  },
  {
    title: "Adicionar filtros avançados",
    description: "Permitir filtragem por múltiplos critérios na listagem de produtos",
    status: :ongoing,
    due_date: Date.today + 20.days
  }
])
