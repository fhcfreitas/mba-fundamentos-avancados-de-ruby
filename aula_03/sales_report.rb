class SalesReport
  include Enumerable

  def initialize(sales)
    @sales = sales
  end

  def each(&block)
    @sales.each(&block)
  end

  def total_by_category
    @sales.group_by { |sale| sale[:category] }
          .transform_values { |sales| sales.sum { |sale| sale[:amount] } }
  end

  def top_sales(n)
    @sales.max_by(n) { |sale| sale[:amount] }
  end

  def grouped_by_category
    @sales.group_by { |sale| sale[:category] }
  end

  def above_average_sales
    average = @sales.sum { |sale| sale[:amount] } / @sales.size.to_f
    @sales.select { |sale| sale[:amount] > average }
  end

end

sales = [
  { product: "Notebook", category: "Eletrônicos", amount: 3000 },
  { product: "Celular", category: "Eletrônicos", amount: 1500 },
  { product: "Cadeira", category: "Móveis", amount: 500 },
  { product: "Mesa", category: "Móveis", amount: 1200 },
  { product: "Headphone", category: "Eletrônicos", amount: 300 },
  { product: "Armário", category: "Móveis", amount: 800 }
]

report = SalesReport.new(sales)

puts "Relatório de Vendas:"
report.each do |sale|
  puts "Produto: #{sale[:product]} - Categoria: #{sale[:category]} - Vendas(unidade): #{sale[:amount]}"
end

puts "Total por categoria:"
puts report.total_by_category

puts "Top 3 vendas:"
puts report.top_sales(3)

puts "Vendas agrupadas por categoria:"
report.grouped_by_category.each do |category, sales|
  puts "#{category}:"
  sales.each do |sale|
    puts "  Produto: #{sale[:product]} - Vendas(unidade): #{sale[:amount]}"
  end
end

puts "Produtos com vendas acima da média:"
report.above_average_sales.each do |sale|
  puts "Produto: #{sale[:product]} - Vendas(unidade): #{sale[:amount]}"
end
