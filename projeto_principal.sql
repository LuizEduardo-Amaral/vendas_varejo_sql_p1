-- Análise de Vendas no Varejo no SQL
CREATE DATABASE projeto_sql_p1;

-- Criar Tabela
CREATE TABLE vendas_varejo
(
    id_transacao INT PRIMARY KEY,
    data_venda DATE,	
    hora_venda TIME,
    id_cliente INT,	
    genero VARCHAR(10),
    idade INT,
    categoria VARCHAR(35),
    quantidade INT,
    preco_unidade FLOAT,	
    custo_mercadoria FLOAT,
    total_venda FLOAT
);

-- Exploração de Dados e tradução de termos
SELECT COUNT(*) FROM vendas_varejo;

SELECT COUNT(DISTINCT id_cliente) FROM vendas_varejo;

SELECT DISTINCT categoria FROM vendas_varejo;

UPDATE vendas_varejo
SET genero = CASE
WHEN genero = 'Male' then 'Masculino'
WHEN genero = 'Female' then 'Feminino'
ELSE genero
END;

UPDATE vendas_varejo
SET categoria = CASE
WHEN categoria = 'Beauty' then 'Beleza'
WHEN categoria = 'Clothing' then 'Vestimenta'
WHEN categoria = 'Electronics' then 'Eletronicos'
ELSE categoria
END;

-- Limpeza de Dados
SELECT * FROM vendas_varejo
WHERE 
    id_transacao IS NULL
    OR
    data_venda IS NULL
    OR 
    hora_venda IS NULL
    OR
    genero IS NULL
    OR
    categoria IS NULL
    OR
    quantidade IS NULL
    OR
    custo_mercadoria IS NULL
    OR
    total_venda IS NULL;

DELETE FROM vendas_varejo
WHERE 
    id_transacao IS NULL
    OR
    data_venda IS NULL
    OR 
    hora_venda IS NULL
    OR
    genero IS NULL
    OR
    categoria IS NULL
    OR
    quantidade IS NULL
    OR
    custo_mercadoria IS NULL
    OR
    total_venda IS NULL; 

-- Análise de Dados e Resultados

-- Q.1 Escreva uma consulta SQL para recuperar todas as colunas de vendas realizadas em '2022-11-05'
SELECT *
FROM vendas_varejo
WHERE data_venda = '2022-11-05';

-- Q.2 Escreva uma consulta SQL para recuperar todas as transações onde a categoria é 'Vestimenta' e a quantidade vendida é maior que 4 no mês de novembro de 2022
SELECT 
  *
FROM vendas_varejo
WHERE 
    categoria = 'Vestimenta'
    AND 
    TO_CHAR(data_venda, 'YYYY-MM') = '2022-11'
    AND
    quantidade >= 4

-- Q.3 Escreva uma consulta SQL para calcular o total de vendas para cada categoria
SELECT 
    categoria,
    SUM(total_venda) as vendas,
    COUNT(*) as total_pedidos
FROM vendas_varejo
GROUP BY categoria 

-- Q.4 Escreva uma consulta SQL para encontrar a idade média dos clientes que compraram itens da categoria 'Beleza'
SELECT 
	ROUND(AVG(idade), 2) as media_idade
FROM vendas_varejo
WHERE categoria = 'Beleza' 

-- Q.5 Escreva uma consulta SQL para encontrar todas as transações onde a venda total é maior que 1000
SELECT * FROM vendas_varejo
WHERE total_vendas > 1000 

-- Q.6 Escreva uma consulta SQL para encontrar o número total de transações realizadas por cada gênero em cada categoria
SELECT 
	categoria,
	genero,
	COUNT(*) as total_trans
FROM vendas_varejo
GROUP BY 
	categoria,
	genero
ORDER BY 1 

-- Q.7 Escreva uma consulta SQL para calcular a venda média de cada mês. Encontre o mês com melhor desempenho de vendas em cada ano
SELECT 
	ano,
	mes,
	media_venda
FROM 
(
SELECT 
	EXTRACT(YEAR FROM data_venda) as ano,
	EXTRACT(MONTH FROM data_venda) as mes,
	AVG(total_venda) as media_venda,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM data_venda)ORDER BY AVG(total_venda)DESC) as rank
FROM vendas_varejo
GROUP BY 1, 2
) AS t1
WHERE rank = 1 

-- Q.8 Escreva uma consulta SQL para encontrar os 5 principais clientes com base nos maiores totais de vendas
SELECT
	id_cliente,
	SUM(total_venda) as total_vendas
FROM vendas_varejo
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 

-- Q.9 Escreva uma consulta SQL para encontrar o número de clientes únicos que compraram itens de cada categoria
SELECT 
	categoria,
	COUNT(DISTINCT id_cliente) as contagem_clientes
FROM vendas_varejo
GROUP BY categoria 

-- Q.10 Escreva uma consulta SQL para criar cada turno e número de pedidos (Exemplo: Manhã <=12, Tarde entre 12 e 17, Noite >17)
WITH venda_por_hora
as
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM hora_venda) < 12 THEN 'Manha'
		WHEN EXTRACT(HOUR FROM hora_venda) BETWEEN 12 AND 17 THEN 'Tarde'
		ELSE 'Noite'
	END as turno
FROM vendas_varejo
)
SELECT
	turno,
	COUNT(*) as total_pedidos
FROM venda_por_hora
GROUP BY turno

-- Fim
