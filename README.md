# Projeto de Análise de Vendas no Varejo em SQL

## Visão Geral

**Título**: Análise de Vendas no Varejo  
**Nível**: Iniciante      
**Base de dados**: `projeto_sql_p1`

Este projeto foi desenvolvido para demonstrar habilidades e técnicas de SQL normalmente utilizadas por analistas de dados para exploração, limpeza e análise de dados de vendas no varejo. O projeto envolve a construção de um banco de dados de vendas, a realização de análise exploratória de dados (EDA) e respostas a perguntas de negócio específicas por meio de consultas SQL. 

## Objetivos

1. **Criar um banco de dados de vendas no varejo**: Criar e popular um banco de dados de vendas no varejo com os dados fornecidos.
2. **Limpeza de dados (Data Cleaning)**:  Identificar e remover registros com valores ausentes ou nulos.
3. **Análise Exploratória de Dados (EDA)**:  Realizar análise exploratória básica para compreender o conjunto de dados.
4. **Análse de Negócios**: Utilizar SQL para responder a questões de negócio específicas e extrair insights dos dados de vendas.

## Estrutura do Projeto

### 1. Configuração do Banco de Dados

- **Criação do Banco de Dados**: O projeto inicia com a criação de um banco de dados, projeto_sql_p1.
- **Criação da Tabela**: Uma tabela `vendas_varejo` é criada para armazenar os dados de vendas. A estrutura da tabela inclui colunas para ID da transação (id_transacao), data da venda (data_venda), hora da venda(hora_venda), ID do cliente (id_cliente), gênero, idade, categoria do produto (categoria), Quantidade vendida (quantidade), preço por unidade (preco_unidade), custo da mercadoria vendida (custo_mercadoria), e  valor total da venda (total_venda).

```sql
CREATE DATABASE projeto_sql_p1;

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
```

### 2. Exploração e Limpeza de Dados

- **Contagem de Registros**: Determinar o número total de registros no conjunto de dados. 
- **Contagem de Clientes**: Identificar quantos clientes únicos existem no conjunto de dados. 
- **Contagem de Categorias**: Identificar todas as categorias de produtos únicas no conjunto de dados.    
- **Tradução de Dados**: Como a base de dados original é em inglês, decidi traduzir os termos para o português, mantendo apenas a estrutura das datas (YYYY-MM-DD).
- **Verificação de Valores Nulos**: Verificar a existência de valores nulos no conjunto de dados e excluir registros com dados ausentes.

```sql
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
```

### 3. Análise de Dados e Resultados 

As seguintes consultas SQL foram desenvolvidas para responder a questões de negócios específicas: 

1. **Escreva uma consulta SQL para recuperar todas as colunas de vendas realizadas em '2022-11-05'**:
```sql
SELECT *
FROM vendas_varejo
WHERE data_venda = '2022-11-05';
```

2. **Escreva uma consulta SQL para recuperar todas as transações onde a categoria é 'Vestimenta' e a quantidade vendida é maior que 4 no mês de novembro de 2022**:
```sql
SELECT 
  *
FROM vendas_varejo
WHERE 
    categoria = 'Vestimenta'
    AND 
    TO_CHAR(data_venda, 'YYYY-MM') = '2022-11'
    AND
    quantidade >= 4
```

3. **Escreva uma consulta SQL para calcular o total de vendas para cada categoria**:
```sql
SELECT 
    categoria,
    SUM(total_venda) as vendas,
    COUNT(*) as total_pedidos
FROM vendas_varejo
GROUP BY categoria 
```

4. **Escreva uma consulta SQL para encontrar a idade média dos clientes que compraram itens da categoria 'Beleza'**:
```sql
SELECT 
	ROUND(AVG(idade), 2) as media_idade
FROM vendas_varejo
WHERE categoria = 'Beleza' 
```

5. **Escreva uma consulta SQL para encontrar todas as transações onde a venda total é maior que 1000**:
```sql
SELECT * FROM vendas_varejo
WHERE total_vendas > 1000 
```

6. **Escreva uma consulta SQL para encontrar o número total de transações realizadas por cada gênero em cada categoria**:
```sql
SELECT 
	categoria,
	genero,
	COUNT(*) as total_trans
FROM vendas_varejo
GROUP BY 
	categoria,
	genero
ORDER BY 1 
```

7. **Escreva uma consulta SQL para calcular a venda média de cada mês. Encontre o mês com melhor desempenho de vendas em cada ano**:
```sql
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
```

8. **Escreva uma consulta SQL para encontrar os 5 principais clientes com base nos maiores totais de vendas**:
```sql
SELECT
	id_cliente,
	SUM(total_venda) as total_vendas
FROM vendas_varejo
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5 
```

9. **Escreva uma consulta SQL para encontrar o número de clientes únicos que compraram itens de cada categoria**:
```sql
SELECT 
	categoria,
	COUNT(DISTINCT id_cliente) as contagem_clientes
FROM vendas_varejo
GROUP BY categoria 
```

10. **Escreva uma consulta SQL para criar cada turno e número de pedidos (Exemplo: Manhã <=12, Tarde entre 12 e 17, Noite >17)**:
```sql
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
```

## Resultados e Insights

- **Perfil Demográfico dos Clientes**: O conjunto de dados inclui clientes de diversas faixas etárias, com vendas distribuídas entre diferentes categorias como Vestuário e Beleza.
- **Transações de Alto Valor**: Várias transações tiveram valor total superior a 1000, indicando compras premium.
- **Tendências de Vendas**: A análise mensal mostra variações nas vendas, ajudando a identificar períodos de pico.
- **Insights Sobre Clientes**: A análise identifica os clientes que mais gastam e as categorias de produtos mais populares.

## Relatórios

- **Resumo de Vendas**: Um relatório detalhado que resume o total de vendas, dados demográficos dos clientes e desempenho por categoria.
- **Análise de Tendências**: Insights sobre as tendências de vendas em diferentes meses e turnos. 
- **Insights Sobre Clientes**: Relatórios sobre os principais clientes e contagem de clientes únicos por categoria.

## Conclusão

Este projeto serve como uma introdução abrangente ao SQL para analistas de dados, cobrindo configuração de banco de dados, limpeza de dados, análise exploratória de dados e consultas SQL orientadas a negócios. Os resultados deste projeto podem ajudar a impulsionar decisões empresariais através da compreensão de padrões de vendas, comportamento do cliente e desempenho dos produtos.

## Como Usar

1. **Clone o Repositório**: Clone este repositório do projeto do GitHub..
2. **Configure o Banco de Dados**: Execute os scripts SQL fornecidos no arquivo `projeto_sql_p1` para criar e popular o banco de dados.
3. **Execute as Consultas**:  Use as consultas SQL fornecidas no arquivo `projeto_sql_p1` para realizar sua análise.
4. **Explore e Modifique**: Sinta-se à vontade para modificar as consultas para explorar diferentes aspectos do conjunto de dados ou responder a outras questões de negócio

## Autor – Luiz Eduardo Guedes Amaral

