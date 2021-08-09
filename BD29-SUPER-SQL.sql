-- remover tabelas e sequencias que definem a PK nas tabelas das entidades
drop sequence nrCompra_seq;
drop sequence idInstalacao_seq;
drop sequence idProduto_seq;
drop sequence idFornecedor_seq;

drop table fornecedores cascade constraints;
drop table trabalhamEm cascade constraints;
drop table transportaram cascade constraints;
drop table abastecem cascade constraints;
drop table vendas cascade constraints;
drop table guardadosEm cascade constraints;
drop table fornecidosPor cascade constraints;
drop table efectuam cascade constraints;
drop table feitasEm cascade constraints;
drop table pertencem cascade constraints;
drop table compras cascade constraints;
drop table clientes cascade constraints;
drop table empregados cascade constraints;
drop table pessoas cascade constraints;
drop table supermercados cascade constraints;
drop table armazens cascade constraints;
drop table instalacoes cascade constraints;
drop table tipoInstalacao cascade constraints;
drop table viaturas cascade constraints;
drop table produtos cascade constraints;

-- criar tabelas de entidades e relacoes e sequencias para criar PKs

create table pessoas(

  nif int, 
  constraint check_nif check(nif between 1 and 999999999),
  
  nome varchar2(50) not null,
  
  nrTelefone int,
  constraint check_num check(nrTelefone between 100000000 and 999999999),

  moradaPessoa varchar2(50) not null,

  primary key(nif)
);

create table clientes(

  nif int primary key references pessoas(nif),

  email varchar2(50)
);

create table compras(

  nrCompra int,

  data date not null,

  hora date not null,

  primary key(nrCompra)
);

CREATE SEQUENCE nrCompra_seq START WITH 100 INCREMENT BY 1;


create table empregados(

  nif int primary key references pessoas(nif),

  cargo varchar2(50) not null,

  salario number(11,2) not null CHECK (salario > 0)
);

create table tipoInstalacao (

    tipoInstalacaoID int primary key, 

    tipoInstalacao varchar(12)
);

insert into tipoInstalacao
    (tipoInstalacaoID, tipoInstalacao)
    values(1,'Supermercado');    

insert into tipoInstalacao
    (tipoInstalacaoID, tipoInstalacao)
    values(2,'Armazem');    

create table instalacoes(

    idInstalacao int primary key,

    tipoInstalacaoID int not null references tipoInstalacao(tipoInstalacaoID), 

    moradaInstalacao varchar2(50) not null,

    capacidadeInstalacao int CHECK (capacidadeInstalacao > 0),

    constraint Instalacoes_AltPK unique (idInstalacao,tipoInstalacaoID)

);



CREATE SEQUENCE idInstalacao_seq START WITH 200 INCREMENT BY 1;



create table supermercados(

  idInstalacao int primary key,

  tipoInstalacaoID int not null check (tipoInstalacaoID = 1), -- tipo de instalacao supermercado

  nomeSupermercado varchar2(50) not null,

  foreign key(idInstalacao, tipoInstalacaoID) references instalacoes(idInstalacao, tipoInstalacaoID)

);



create table armazens(

  idInstalacao int primary key,

  tipoInstalacaoID int not null check (tipoInstalacaoID = 2), -- tipo de instalacao armazem

  precoAluguer number(11,2) not null CHECK (precoAluguer > 0),

  foreign key(idInstalacao, tipoInstalacaoID) references instalacoes(idInstalacao, tipoInstalacaoID)

);



create table viaturas(

  matricula varchar2(8),

  capacidadeViatura number(11,0) CHECK (capacidadeViatura > 0),

  autonomia number(11,0) CHECK (autonomia > 0),

  primary key(matricula)

);



create table produtos(

  idProduto int,

  precoVenda number(11,2) not null CHECK (precoVenda > 0),

  capacidadeOcupada int not null CHECK (capacidadeOcupada > 0),

  nomeProduto varchar2(50) not null,

  primary key(idProduto)

);



CREATE SEQUENCE idProduto_seq START WITH 300 INCREMENT BY 1;



create table fornecedores(

  idFornecedor int,

  nomeFornecedor varchar2(50) not null,

  moradaFornecedor varchar2(50) not null,

  primary key(idFornecedor)

);



CREATE SEQUENCE idFornecedor_seq START WITH 400 INCREMENT BY 1;



create table trabalhamEm(

   nif int,

   idInstalacao int,

   primary key(nif, idInstalacao),

   foreign key(nif) references empregados(nif),

   foreign key(idInstalacao) references instalacoes(idInstalacao)

);



create table transportaram(

   matricula varchar2(8),

   idProduto int,

   custoTransporte number(11,2) not null CHECK (custoTransporte > 0),

   primary key(matricula, idProduto),

   foreign key(matricula) references viaturas(matricula),

   foreign key(idProduto) references produtos(idProduto) on delete cascade

);



create table abastecem(

   matricula varchar2(8),

   idProduto int,

   idInstalacao int,

   primary key(matricula, idProduto, idInstalacao),

   foreign key(matricula) references viaturas(matricula),

   foreign key(idProduto) references produtos(idProduto) on delete cascade,

   foreign key(idInstalacao) references supermercados(idInstalacao)

);



create table vendas(

   nif int,

   idProduto int,

   idInstalacao int,

   nrCompra int,

   quantidadeVendida int not null CHECK (quantidadeVendida > 0),

   primary key(nif, idProduto, idInstalacao, nrCompra),

   foreign key(idProduto) references produtos(idProduto) on delete cascade,

   foreign key(idInstalacao) references supermercados(idInstalacao),

   foreign key(nrCompra) references compras(nrCompra),
   
   foreign key(nif) references clientes(nif)

);



create table guardadosEm(

   idProduto int,

   idInstalacao int,

   stockArmazem int not null,

   primary key(idProduto, idInstalacao),

   foreign key(idProduto) references produtos(idProduto) on delete cascade,

   foreign key(idInstalacao) references armazens(idInstalacao)
);



create table fornecidosPor(

   IdFornecedor int not null,

   idProduto int not null,

   precoFornecedor number(11, 2) not null CHECK (precoFornecedor > 0),
   
   foreign key(idProduto) references produtos(idProduto) on delete cascade,

   foreign key(idFornecedor) references fornecedores(idFornecedor)

);



create table efectuam(

   nif int,

   nrCompra int,

   primary key(nif, nrCompra),

   foreign key(nif) references clientes(nif),

   foreign key(nrCompra) references compras(nrCompra)

);



create table feitasEm(

   nrCompra int,

   idInstalacao int,

   primary key(nrCompra, idInstalacao),

   foreign key(nrCompra) references compras(nrCompra),

   foreign key(idInstalacao) references supermercados(idInstalacao)

);



create table pertencem(

   matricula varchar2(8),

   idInstalacao int,

   primary key(idInstalacao, matricula),

   foreign key(matricula) references viaturas(matricula),

   foreign key(idInstalacao) references armazens(idInstalacao)

);

-- criacao views para visualizar lucro cadeia de supermercados

drop view gastosSalariais;

create view gastosSalariais as
select sum(salario) as salarios from empregados;

drop view gastosAluguer;

create view gastosAluguer as
select sum(precoAluguer) as gastosAluguer from armazens;

drop view gastosProduto;

create view gastosProduto as
select precoFornecedor, idProduto from fornecidosPor;

drop view precoProduto;

create view precoProduto as 
select idProduto, precoVenda from produtos;

drop view vendasProduto;

create view vendasProduto as 
select p.idProduto, (p.precoVenda * v.quantidadeVendida) as vendasProd from vendas v, precoProduto p
where p.idProduto = v.idProduto;

drop view ganhosProduto;

create view ganhosProduto as
select g.idProduto, (v.vendasProd - g.precoFornecedor) as ganhos
FROM vendasProduto v, gastosProduto g
WHERE v.idProduto = g.idProduto; 


drop view ganhosVendas;

create view ganhosVendas as 
select sum(ganhos) as ganhosVendas
from ganhosProduto;




-- criacao dos triggers



-- Triggers de sequencia


/* Trigger para inserir um valor na tabela compras */



CREATE OR REPLACE trigger BI_compras  

  before insert on compras              

  for each row 

begin  

  if :NEW.nrCompra is null then

    select nrCompra_seq.nextval into :NEW.nrCompra from dual;

  end if;

end;

/



/* Trigger para inserir um valor na tabela instalacoes */



CREATE OR REPLACE trigger BI_instalacoes  

  before insert on instalacoes              

  for each row 

begin  

  if :NEW.idInstalacao is null then

    select idInstalacao_seq.nextval into :NEW.idInstalacao from dual;

  end if;

end;

/

/* Trigger para inserir um valor na tabela produtos */



CREATE OR REPLACE trigger BI_produtos  

  before insert on produtos              

  for each row 

begin  

  if :NEW.idProduto is null then

    select idProduto_seq.nextval into :NEW.idProduto from dual;

  end if;

end;

/


/* Trigger para inserir um valor na tabela fornecedores */


CREATE OR REPLACE trigger BI_fornecedores  

  before insert on fornecedores              

  for each row 

begin  

  if :NEW.idFornecedor is null then

    select idFornecedor_seq.nextval into :NEW.idFornecedor from dual;

  end if;

end;

/

CREATE OR REPLACE trigger existeCliente  

  before insert on clientes              
  for each row
  declare
  p int;
  
begin
	SELECT count(nif) into p
	FROM Pessoas p
	WHERE p.nif = :new.nif;

  IF p = 0 then
	Raise_Application_Error(-20001, 'A pessoa não existe! Insira primeiro em pessoas.');
  end if;

end;


/

CREATE OR REPLACE trigger existeEmpregado  

  before insert on empregados              
  for each row
  declare 
  p int; 
  
  
begin
	SELECT count(nif) into p
	FROM Pessoas p
	WHERE p.nif = :new.nif;

  IF p = 0 then
	Raise_Application_Error(-20001, 'A pessoa não existe! Insira primeiro em pessoas.');
  end if;

end;

/

/* ********************* */

--Triggers da aplicacao

CREATE OR REPLACE trigger adicionarStock  

	before insert on guardadosEm
	for each row 
declare 
	capacidade number;
	ocupado number;
BEGIN
	SELECT i.capacidadeInstalacao into capacidade
	FROM Instalacoes i
	WHERE i.idInstalacao = :new.idInstalacao;
	SELECT sum(stockArmazem) INTO ocupado
    FROM guardadosEm;

if :new.stockArmazem > capacidade + ocupado  then
		Raise_Application_Error(-20001, 'Nao ha espaco para guardar todos os produtos!');
	end if;
END;
/

CREATE OR REPLACE TRIGGER temProdutoParaVender
    before INSERT ON vendas
    FOR EACH ROW
DECLARE
    quantidade number;
BEGIN
    SELECT sum(stockArmazem) INTO quantidade
    FROM guardadosEm
    WHERE idProduto = :new.idProduto;
	
	if :new.quantidadeVendida > quantidade then
		Raise_Application_Error(-20000, 'Não temos essa quantidade!');
	END if;
END;
/

-- insercoes de dados - realizar depois de criar as tabelas e os triggers



-- instalacoes

/*  

Insere dados nas tabelas instalacoes, supermercados e armazens.

idInstalacao ainda nao tem valor, e populado atraves dos triggers de sequencia 

*/



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua Joaquim Pereira, Corroios', 1, 10000); 

    

insert into supermercados 
	(nomeSupermercado, tipoInstalacaoID, idInstalacao)
	values('Jumbo', 1, idInstalacao_seq.currval);     



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Avenida Brasil, Cascais', 1, 11000); 

    

insert into supermercados 
	(nomeSupermercado, tipoInstalacaoID, idInstalacao)
	values('Pingo Doce', 1, idInstalacao_seq.currval); 



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua do Salitre, Lisboa', 1, 10500); 

    

insert into supermercados 
	(nomeSupermercado, tipoInstalacaoID, idInstalacao)	
	values('Modelo', 1, idInstalacao_seq.currval); 



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua da Fonte Santa, Faro', 1, 10400); 

    

insert into supermercados 
	(nomeSupermercado, tipoInstalacaoID, idInstalacao)
	values('Continente', 1, idInstalacao_seq.currval); 



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua da Sobreira, Porto', 1, 10000); 

    

insert into supermercados 
	(nomeSupermercado, tipoInstalacaoID, idInstalacao)
	values('Apolonia', 1, idInstalacao_seq.currval); 



insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua do Vale do Lobo, Evora', 2, 5000); 

    

insert into armazens 
	(precoAluguer, tipoInstalacaoID, idInstalacao)
	values(320.10, 2, idInstalacao_seq.currval); 

    

insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua Dom Dinis, Beja', 2, 4000); 

    

insert into armazens 
	(precoAluguer, tipoInstalacaoID, idInstalacao)
	values(530.90, 2, idInstalacao_seq.currval); 

    

insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua Santa Isabel, Portalegre', 2, 6000);

    

insert into armazens 
	(precoAluguer, tipoInstalacaoID, idInstalacao)
	values(600.30, 2, idInstalacao_seq.currval); 

    

insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Avenida Humberto Delgado, Lagos', 2, 7000); 



insert into armazens 
	(precoAluguer, tipoInstalacaoID, idInstalacao)
	values(550.20, 2, idInstalacao_seq.currval); 

    

insert into instalacoes 

    (moradaInstalacao, tipoInstalacaoID, capacidadeInstalacao)

    values('Rua Diana Spencer, Santarem', 2, 1000); 



insert into armazens 
	(precoAluguer, tipoInstalacaoID, idInstalacao)
	values(500.50, 2, idInstalacao_seq.currval); 



-- produtos

/*  

Insere dados na tabela produtos.

idProduto ainda nao tem valor, e populado atraves dos triggers de sequencia 

*/



insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(1.00, 12, 'agua');

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(3.99, 10, 'laranja'); 

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(4.99, 14, 'gelado');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(20.99, 70, 'bacalhau');  

    

insert into produtos

     (precoVenda, capacidadeOcupada, nomeProduto) 

    values(100.99, 13, 'presunto');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(5.99, 20, 'batata');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(1.99, 26, 'iogurte');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(0.99, 58, 'manteiga');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(3.99, 36, 'cenoura');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(7.99, 15, 'limao');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(4.99, 85, 'bife de frango');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(50.99, 23, 'bife de vitela');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(12.99, 23, 'queijo');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(4.99, 45, 'atum');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(2.99, 10, 'sal');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(2.99, 45, 'vinagre');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(1.99, 15, 'azeite');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(15.99, 23, 'couve');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(67.99, 12, 'bolachas');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(23.99, 23, 'cereais');  

    

insert into produtos 

    (precoVenda, capacidadeOcupada, nomeProduto)

    values(4.99, 42, 'farinha');  

 

-- compras

/*  

Insere dados na tabela compras.

nrCompra ainda nao tem valor, populado atraves dos triggers de sequencia 

*/



insert into compras 

    (data, hora)

    values(to_date('2017-09-23', 'yyyy-mm-dd'), to_date('10:00', 'hh24:mi')); 

    

insert into compras 

    (data, hora)

    values(to_date('2017-09-23', 'yyyy-mm-dd'), to_date('11:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2017-10-05', 'yyyy-mm-dd'), to_date('13:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2017-11-26', 'yyyy-mm-dd'), to_date('19:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2017-12-12', 'yyyy-mm-dd'), to_date('09:30', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2017-12-25', 'yyyy-mm-dd'), to_date('15:15', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-01-12', 'yyyy-mm-dd'), to_date('15:52', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-01-18', 'yyyy-mm-dd'), to_date('17:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-01-27', 'yyyy-mm-dd'), to_date('18:09', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-01', 'yyyy-mm-dd'), to_date('19:25', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-04', 'yyyy-mm-dd'), to_date('16:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-11', 'yyyy-mm-dd'), to_date('11:34', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-19', 'yyyy-mm-dd'), to_date('15:54', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-24', 'yyyy-mm-dd'), to_date('10:29', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-02-25', 'yyyy-mm-dd'), to_date('22:19', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-03-02', 'yyyy-mm-dd'), to_date('13:22', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-03-02', 'yyyy-mm-dd'), to_date('21:34', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-03-02', 'yyyy-mm-dd'), to_date('09:00', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-03-12', 'yyyy-mm-dd'), to_date('11:33', 'hh24:mi'));  

    

insert into compras 

    (data, hora)

    values(to_date('2018-03-24', 'yyyy-mm-dd'), to_date('08:01', 'hh24:mi')); 



--pessoas



insert into pessoas values(123456789, 'Claudia Perestrelo', 967771259, 'Rua das Rosas, n6, Herdade da Aroeira'); 

insert into pessoas values(123578799, 'Tomas Rapaz', 960237643, 'Avenida da Liberdade, n120, 3A, Lisboa');

insert into pessoas values(423565453, 'Joao Silva', 912764634, 'Praceta Almeida Garret, n2, 4Esq, Miratejo');

insert into pessoas values(154366544, 'Mariana Pereira', 912346785, 'Rua Miguel Bombarda, n13, Sobreda');

insert into pessoas values(167812345, 'Nuno Miguel', 932458494, 'Largo da Saudade, n10, Verdizela');

insert into pessoas values(232456869, 'Alexandre Guerreiro', 923451232, 'Rua Santiago Kastner, n40, Corroios');

insert into pessoas values(239557934, 'Rita Mira', 923423852, 'Praca de Portugal, n20, 2Dir, Aroeira');

insert into pessoas values(123552122, 'Fernando Banha', 923104232, 'Rua do Sol, n4, 1B, Quinta do Serrado');

insert into pessoas values(211434434, 'Ricardo Matos', 912385233, 'Rua da Campa, n3, Vale de Milhacos');

insert into pessoas values(234321354, 'Marco Mateus', 923404752, 'Rua Alexandra Lencastre, n103, Lisboa');

insert into pessoas values(523481034, 'Bruno Antonio', 297854023, 'Avenida Luis Camoes, n123, Lisboa');

insert into pessoas values(123659576, 'Joana Silveira', 922222222, 'Rua das Orquideas, n7, Pinhal Vidal');

insert into pessoas values(234976585, 'Beltrano Sicrano', 138012322, 'Debaixo da Ponte 25 de Abril');

insert into pessoas values(165830943, 'Pedro Parker', 658234022, 'Uma teia em Nova Iorque');

insert into pessoas values(123754232, 'Clark Quente', 435352023, 'Todo o lado menos Krypton');

insert into pessoas values(236423465, 'Donald Trump', 232323232, 'Trump Tower');

insert into pessoas values(323242312, 'Mickey Mouse', 454301230, 'Disneylandia');

insert into pessoas values(124232312, 'Kim Jong Un', 231247934, 'Bunker do Ditador, Coreia do Norte');

insert into pessoas values(423685233, 'Joao Ratao', 372349232, 'Caldeirao da Carochinha');

insert into pessoas values(237145533, 'Papa Francisco', 834712232, 'Palacio Papal, Vaticano');

insert into pessoas values(412452342, 'Tony Stark', 273145923, 'Stark Tower');

insert into pessoas values(232666666, 'Fernando Pessoa', 234784334, 'Mosteiro dos Jeronimos, Lisboa');



--empregados

insert into empregados values(123578799, 'Empregado de Limpeza', 599.99);

insert into empregados values(423565453, 'Caixa', 700.50);

insert into empregados values(154366544, 'Gerente de Loja', 1500.99);

insert into empregados values(167812345, 'Talhante', 999.60);

insert into empregados values(232456869, 'Peixeiro', 999.60);

insert into empregados values(239557934, 'Contabilista', 10000.00);

insert into empregados values(123552122, 'Advogado', 10000.00);

insert into empregados values(211434434, 'Repositor', 699.99);

insert into empregados values(234321354, 'Empregado de Armazem', 799.99);

insert into empregados values(523481034, 'Transportador de Mercadoria', 999.99);

insert into empregados values(123659576, 'Gerente de Armazem', 1450.50);



--clientes

insert into clientes values(165830943, 'friendly.spiderman@nyc.us');
insert into clientes values(123754232, 'sunlover@metropolis.us');
insert into clientes values(236423465, 'us_prez_45@whitehouse.gov');
insert into clientes values(323242312, 'mickey@disney.us');
insert into clientes values(124232312, 'dictator@drnk.gov');
insert into clientes values(423685233, 'joao_ratao@caldeirao.pt');
insert into clientes values(237145533, 'god_loves_everyone@pope.vc');
insert into clientes values(412452342, 'stark@starkindustries.com');
insert into clientes values(232666666, 'um_heteronimo_qualquer@pessoa.pt');



-- clientes e empregados

insert into empregados values(234976585, 'Empregado de Limpeza', 599.99);

insert into clientes values(234976585, 'debaixodaponte@naohanet.pt');

insert into empregados values(123456789, 'CEO e Fundadora', 10000000.00);

insert into clientes values(123456789, 'superCEO@supermercado.pt');



--viaturas

insert into viaturas values('11-50-TT', 1000, 600);

insert into viaturas values('12-50-TT', 10000, 300);

insert into viaturas values('13-50-TT', 5000, 500);

insert into viaturas values('14-50-TT', 200, 6000);

insert into viaturas values('15-50-TT', 100000, 100);

insert into viaturas values('16-50-TT', 100, 100);

insert into viaturas values('17-50-TT', 100, 10000);

insert into viaturas values('18-50-TT', 2000, 650);

insert into viaturas values('19-50-TT', 3000, 600);

insert into viaturas values('20-50-TT', 4000, 550);



--fornecedores

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Talhos Silau', 'Rua da Cidade, n75, Loures');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Makro', 'Complexo Industrial de Santa Marta, n23, Corroios');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Peixaria Antonio', 'Rua dos Pescadores, n30, Costa da Caparica');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Frutaria de Sao Joao', 'Rua da Fruta, n99, Sao Joao da Caparica');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Nova Classe-Produtos Alimentares Lda', 'Travessa Castanheira 167, Vila Nova da Telha');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Vinhos do Alentejo', 'Avenida Fernando Pessoa, n42, Alentejo');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Veggie Life', 'Travessa do Sol, n30, Trafaria');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Vende-Tudo', 'Avenida dos Descobrimentos, n50, Lisboa');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Pepsico', 'Rua das Descobertas, n22, Pinhal de Frades');

insert into fornecedores 
	(nomeFornecedor, moradaFornecedor)
	values('Fornecedor', 'Rua do Fornecimento, n1, Almada');



--trabalham em

insert into trabalhamEm values(123456789, 200);

insert into trabalhamEm values(123659576, 200);

insert into trabalhamEm values(523481034, 200);

insert into trabalhamEm values(234321354, 200);

insert into trabalhamEm values(123456789, 201);

insert into trabalhamEm values(123659576, 201);

insert into trabalhamEm values(523481034, 201);

insert into trabalhamEm values(234321354, 201);

insert into trabalhamEm values(123456789, 202);

insert into trabalhamEm values(123659576, 202);

insert into trabalhamEm values(523481034, 202);

insert into trabalhamEm values(234321354, 202);

insert into trabalhamEm values(123456789, 203);

insert into trabalhamEm values(123659576, 203);

insert into trabalhamEm values(523481034, 203);

insert into trabalhamEm values(234321354, 203);

insert into trabalhamEm values(123456789, 204);

insert into trabalhamEm values(123659576, 204);

insert into trabalhamEm values(523481034, 204);

insert into trabalhamEm values(234321354, 204);



insert into trabalhamEm values(123456789, 205);

insert into trabalhamEm values(123578799, 205);

insert into trabalhamEm values(423565453, 205);

insert into trabalhamEm values(239557934, 205);

insert into trabalhamEm values(123456789, 206);

insert into trabalhamEm values(123578799, 206);

insert into trabalhamEm values(154366544, 206);

insert into trabalhamEm values(239557934, 206);

insert into trabalhamEm values(123456789, 207);

insert into trabalhamEm values(123578799, 207);

insert into trabalhamEm values(167812345, 207);

insert into trabalhamEm values(239557934, 207);

insert into trabalhamEm values(123456789, 208);

insert into trabalhamEm values(123578799, 208);

insert into trabalhamEm values(232456869, 208);

insert into trabalhamEm values(239557934, 208);

insert into trabalhamEm values(123456789, 209);

insert into trabalhamEm values(123578799, 209);

insert into trabalhamEm values(239557934, 209);

insert into trabalhamEm values(211434434, 209);

insert into trabalhamEm values(123552122, 209);



--transportaram

insert into transportaram values('11-50-TT', 300, 1200.56);

insert into transportaram values('12-50-TT', 301, 312.56);

insert into transportaram values('13-50-TT', 302, 15230.56);

insert into transportaram values('14-50-TT', 303, 50.56);

insert into transportaram values('15-50-TT', 304, 10.56);



insert into transportaram values('17-50-TT', 305, 140.85);

insert into transportaram values('18-50-TT', 306, 120.56);

insert into transportaram values('19-50-TT', 307, 8.56);

insert into transportaram values('20-50-TT', 308, 10.51);

insert into transportaram values('11-50-TT', 309, 30.12);



insert into transportaram values('12-50-TT', 310, 1.43);

insert into transportaram values('13-50-TT', 311, 213.75);

insert into transportaram values('14-50-TT', 312, 5123.54);

insert into transportaram values('15-50-TT', 313, 123.48);

insert into transportaram values('16-50-TT', 314, 153.65);



insert into transportaram values('17-50-TT', 315, 234.32);

insert into transportaram values('18-50-TT', 316, 742.78);

insert into transportaram values('19-50-TT', 317, 847.93);

insert into transportaram values('20-50-TT', 318, 213.31);

insert into transportaram values('16-50-TT', 319, 160.45);



--abastecem    matricula idProduto idInstalacao

insert into abastecem values('11-50-TT', 300, 200);

insert into abastecem values('12-50-TT', 301, 201);

insert into abastecem values('13-50-TT', 302, 202);

insert into abastecem values('14-50-TT', 303, 203);

insert into abastecem values('15-50-TT', 304, 204);



insert into abastecem values('16-50-TT', 304, 202);

insert into abastecem values('17-50-TT', 303, 203);

insert into abastecem values('18-50-TT', 302, 203);

insert into abastecem values('19-50-TT', 301, 204);

insert into abastecem values('20-50-TT', 300, 204);



insert into abastecem values('11-50-TT', 310, 200);

insert into abastecem values('12-50-TT', 311, 200);

insert into abastecem values('13-50-TT', 312, 201);

insert into abastecem values('14-50-TT', 313, 201);

insert into abastecem values('15-50-TT', 314, 202);



insert into abastecem values('16-50-TT', 315, 202);

insert into abastecem values('17-50-TT', 316, 203);

insert into abastecem values('18-50-TT', 317, 203);

insert into abastecem values('19-50-TT', 318, 204);

insert into abastecem values('20-50-TT', 319, 204);



--vendas nif idProduto(300) idInstalacao (200) nrCompra (100) quantidadeVendida

insert into vendas values(165830943, 300, 200, 100, 2);

insert into vendas values(165830943, 301, 200, 101, 6);

insert into vendas values(236423465, 302, 201, 102, 8);

insert into vendas values(236423465, 303, 201, 103, 1);

insert into vendas values(123754232, 304, 202, 104, 7);

insert into vendas values(123754232, 305, 202, 105, 9);

insert into vendas values(323242312, 306, 203, 106, 5);

insert into vendas values(323242312, 307, 203, 107, 4);

insert into vendas values(124232312, 308, 204, 108, 9);

insert into vendas values(423685233, 309, 204, 109, 9);

insert into vendas values(423685233, 310, 200, 110, 7);

insert into vendas values(237145533, 311, 200, 111, 5);

insert into vendas values(237145533, 312, 201, 112, 4);

insert into vendas values(412452342, 313, 201, 113, 4);

insert into vendas values(412452342, 314, 202, 114, 7);

insert into vendas values(232666666, 315, 202, 115, 5);

insert into vendas values(234976585 , 316, 203, 116, 3);

insert into vendas values(123456789, 317, 203, 117, 9);

insert into vendas values(123456789, 318, 204, 118, 7);

insert into vendas values(123456789, 319, 204, 119, 1);



--pertencem (matricula, id instal)

insert into pertencem values('11-50-TT', 205);

insert into pertencem values('12-50-TT', 206);

insert into pertencem values('13-50-TT', 207);

insert into pertencem values('14-50-TT', 208);

insert into pertencem values('15-50-TT', 209);

insert into pertencem values('16-50-TT', 205);

insert into pertencem values('17-50-TT', 206);

insert into pertencem values('18-50-TT', 207);

insert into pertencem values('19-50-TT', 208);

insert into pertencem values('20-50-TT', 209);



--feitas em (nr compra, id super)



insert into feitasEm values(100, 200);

insert into feitasEm values(101, 201);

insert into feitasEm values(102, 202);

insert into feitasEm values(103, 203);

insert into feitasEm values(104, 204);

insert into feitasEm values(105, 200);

insert into feitasEm values(106, 201);

insert into feitasEm values(107, 202);

insert into feitasEm values(108, 203);

insert into feitasEm values(109, 204);

insert into feitasEm values(110, 200);

insert into feitasEm values(111, 201);

insert into feitasEm values(112, 202);

insert into feitasEm values(113, 203);

insert into feitasEm values(114, 204);

insert into feitasEm values(115, 200);

insert into feitasEm values(116, 201);

insert into feitasEm values(117, 202);

insert into feitasEm values(118, 203);

insert into feitasEm values(119, 204);



--efectuam (nif, nr compra)



insert into efectuam values(234976585, 100);

insert into efectuam values(165830943, 101);

insert into efectuam values(123754232, 102);

insert into efectuam values(236423465, 103);

insert into efectuam values(323242312, 104);

insert into efectuam values(124232312, 105);

insert into efectuam values(423685233, 106);

insert into efectuam values(237145533, 107);

insert into efectuam values(412452342, 108);

insert into efectuam values(232666666, 109);

insert into efectuam values(234976585, 110);

insert into efectuam values(165830943, 111);

insert into efectuam values(123754232, 112);

insert into efectuam values(236423465, 113);

insert into efectuam values(323242312, 114);

insert into efectuam values(124232312, 115);

insert into efectuam values(423685233, 116);

insert into efectuam values(237145533, 117);

insert into efectuam values(412452342, 118);

insert into efectuam values(232666666, 119);



--fornecidos por (id forn 400 , id prod 300 , preco forn)



insert into fornecidosPor values(400, 300, 2.00);

insert into fornecidosPor values(401, 301, 3.50);

insert into fornecidosPor values(402, 302, 4.20);

insert into fornecidosPor values(403, 303, 10.00);

insert into fornecidosPor values(404, 304, 1.00);

insert into fornecidosPor values(405, 305, 0.50);

insert into fornecidosPor values(406, 306, 99.99);

insert into fornecidosPor values(407, 307, 2.00);

insert into fornecidosPor values(408, 308, 35.00);

insert into fornecidosPor values(409, 309, 10.00);

insert into fornecidosPor values(400, 301, 23.00);

insert into fornecidosPor values(401, 302, 2.69);

insert into fornecidosPor values(402, 303, 0.42);

insert into fornecidosPor values(403, 304, 12.00);

insert into fornecidosPor values(404, 305, 20.00);

insert into fornecidosPor values(405, 306, 2.00);

insert into fornecidosPor values(406, 307, 9.00);

insert into fornecidosPor values(407, 308, 9.99);

insert into fornecidosPor values(408, 309, 5.00);

insert into fornecidosPor values(409, 305, 15.49);



--guardados em (id prod 300, id inst 200, stock em armazem)

insert into guardadosEm values(300, 205, 1);

insert into guardadosEm values(301, 205, 4);

insert into guardadosEm values(302, 205, 10);

insert into guardadosEm values(303, 205, 12);

insert into guardadosEm values(304, 205, 5);

insert into guardadosEm values(305, 205, 6);

insert into guardadosEm values(306, 205, 7);

insert into guardadosEm values(307, 205, 9);

insert into guardadosEm values(308, 205, 20);

insert into guardadosEm values(309, 205, 5);

insert into guardadosEm values(310, 205, 6);

insert into guardadosEm values(311, 205, 51);

insert into guardadosEm values(312, 205, 3);

insert into guardadosEm values(313, 205, 2);

insert into guardadosEm values(314, 205, 6);

insert into guardadosEm values(315, 205, 8);

insert into guardadosEm values(316, 205, 12);

insert into guardadosEm values(317, 205, 11);

insert into guardadosEm values(318, 205, 41);

insert into guardadosEm values(319, 205, 21);

insert into guardadosEm values(300, 206, 11);

insert into guardadosEm values(301, 206, 3);

insert into guardadosEm values(302, 206, 3);

insert into guardadosEm values(303, 206, 7);

insert into guardadosEm values(304, 206, 6);

insert into guardadosEm values(305, 206, 3);

insert into guardadosEm values(306, 206, 1);

insert into guardadosEm values(307, 206, 9);

insert into guardadosEm values(308, 206, 12);

insert into guardadosEm values(309, 206, 11);

insert into guardadosEm values(310, 206, 2);

insert into guardadosEm values(311, 206, 9);

insert into guardadosEm values(312, 206, 10);

insert into guardadosEm values(313, 206, 10);

insert into guardadosEm values(314, 206, 13);

insert into guardadosEm values(315, 206, 2);

insert into guardadosEm values(316, 206, 1);

insert into guardadosEm values(317, 206, 6);

insert into guardadosEm values(318, 206, 7);

insert into guardadosEm values(319, 206, 4);

insert into guardadosEm values(300, 207, 5);

insert into guardadosEm values(301, 207, 15);

insert into guardadosEm values(302, 207, 1);

insert into guardadosEm values(303, 207, 9);

insert into guardadosEm values(304, 207, 10);

insert into guardadosEm values(305, 207, 1);

insert into guardadosEm values(306, 207, 5);

insert into guardadosEm values(307, 207, 7);

insert into guardadosEm values(308, 207, 4);

insert into guardadosEm values(309, 207, 6);

insert into guardadosEm values(310, 207, 6);

insert into guardadosEm values(311, 207, 2);

insert into guardadosEm values(312, 207, 6);

insert into guardadosEm values(313, 207, 8);

insert into guardadosEm values(314, 207, 9);

insert into guardadosEm values(315, 207, 10);

insert into guardadosEm values(316, 207, 1);

insert into guardadosEm values(317, 207, 1);

insert into guardadosEm values(318, 207, 12);

insert into guardadosEm values(319, 207, 4);

insert into guardadosEm values(300, 208, 20);

insert into guardadosEm values(301, 208, 10);

insert into guardadosEm values(302, 208, 31);

insert into guardadosEm values(303, 208, 5);

insert into guardadosEm values(304, 208, 2);

insert into guardadosEm values(305, 208, 19);

insert into guardadosEm values(306, 208, 3);

insert into guardadosEm values(307, 208, 19);

insert into guardadosEm values(308, 208, 1);

insert into guardadosEm values(309, 208, 4);

insert into guardadosEm values(310, 208, 10);

insert into guardadosEm values(311, 208, 21);

insert into guardadosEm values(312, 208, 31);

insert into guardadosEm values(313, 208, 11);

insert into guardadosEm values(314, 208, 1);

insert into guardadosEm values(315, 208, 1);

insert into guardadosEm values(316, 208, 10);

insert into guardadosEm values(317, 208, 1);

insert into guardadosEm values(318, 208, 9);

insert into guardadosEm values(319, 208, 6);

insert into guardadosEm values(300, 209, 4);

insert into guardadosEm values(301, 209, 2);

insert into guardadosEm values(302, 209, 7);

insert into guardadosEm values(303, 209, 5);

insert into guardadosEm values(304, 209, 5);

insert into guardadosEm values(305, 209, 4);

insert into guardadosEm values(306, 209, 2);

insert into guardadosEm values(307, 209, 3);

insert into guardadosEm values(308, 209, 11);

insert into guardadosEm values(309, 209, 10);

insert into guardadosEm values(310, 209, 3);

insert into guardadosEm values(311, 209, 7);

insert into guardadosEm values(312, 209, 6);

insert into guardadosEm values(313, 209, 5);

insert into guardadosEm values(314, 209, 4);

insert into guardadosEm values(315, 209, 9);

insert into guardadosEm values(316, 209, 1);

insert into guardadosEm values(317, 209, 13);

insert into guardadosEm values(318, 209, 10);

insert into guardadosEm values(319, 209, 2);

drop snapshot lucroTotal;

create snapshot lucroTotal as
select gs.salarios as gastosSalariais,
	   ga.gastosAluguer as gastosAluguer,
	   gv.ganhosVendas as ganhosVendas,
       (gv.ganhosVendas - gs.salarios - ga.gastosAluguer) as lucroFinal 
 from gastosSalariais gs, gastosAluguer ga, ganhosVendas gv;