create table Customer (Id_Customer numeric(10) , 
                       Name varchar(40) , 
                       Adresse_Customer varchar(100),
                       Code_Postal numeric(4),
                       Sector numeric(4),
                       Lib_Sector varchar(40),
                       constraint  PkId_Cutomer primary key (Id_Customer)) ;
alter table Customer add constraint Check_Customer check( length(cast(Id_Customer as varchar))=10 );
                      
create table Account (Id_Account  numeric(10) primary key ,
                      Id_Customer numeric(10),
                      Type_Compte numeric(4),
                      Adresse_Account varchar(100),
                      Code_Postal numeric(4),
                      Solde_Compte decimal(16,3),
                      constraint FkId_Customer foreign key (Id_Customer)
                      references Customer(Id_Customer)) ;
alter table Account add constraint Check_Account check( length(cast(Id_Account as varchar))=10 );
                      
create table Mouvement (Id_Mvt numeric(10) primary key,
                        Id_Account numeric(10),
                        Date_Mvt Date,
                        Mnt_Mvt decimal (16,3),
                        constraint FkId_Account foreign key (Id_Account)
                        references Account(Id_Account));
alter table Mouvement add constraint Check_Mvt check( length(cast(Id_Mvt as varchar))=10 );


update Account set Solde_Compte = 
(select sum(Mnt_Mvt) from Mouvement m group by m.Id_Account 
having (Account.Id_Account = m.Id_Account)) ;

select a.Id_Customer,c.name,adresse_customer, sum(a.Solde_Compte) as SoldeGlobaux 
from account a inner join customer c on c.id_customer=a.id_customer 
group by a.Id_Customer,adresse_customer,c.name ;

select * from Account where Solde_Compte=(select max(Solde_Compte) from Account) ;

select count(Id_Account)as nombre_de_compte, a.Id_Customer,name  from Account a inner join customer c on c.id_customer=a.id_customer group by a.Id_Customer,name order by count(Id_Account) desc limit 100;

select name, count(distinct a.Type_Compte) as Nombre_de_Type_de_compte, a.Id_Customer from Account a inner join customer c on c.Id_customer=a.id_customer group by a.Id_Customer,name order by count(distinct Type_Compte) desc limit 100;


select a.Code_Postal, count(a.Code_Postal) as Nombre_de_fois_utiliser from Account a group by a.Code_Postal order by count(a.Code_Postal) desc limit 5; 

select code_postal, count(code_postal) as Nombre_de_fois_utiliser from (select code_postal from Customer union all select code_postal from Account) as code_postal group by code_postal order by Nombre_de_fois_utiliser desc ;

select name,m.id_account , count(id_mvt) as Nombre_de_mouvement from mouvement m inner join account a on m.id_account=a.id_account inner join customer c on c.id_customer=a.id_customer group by m.id_account,name order by count(id_mvt) desc; 

select name, a.id_customer,sum(solde_compte) as solde_du_compte from account a inner join customer c on c.id_customer=a.id_customer where (solde_compte < 0) group by a.id_customer,name order by solde_du_compte asc ;


create table table_essemble as select  c.id_customer, c.name, c.adresse_customer, c.code_postal as customer_code_postal, c.sector, c.lib_sector, a.id_account, a.type_compte, a.adresse_account, a.code_postal as account_code_postal, a.solde_compte, m.id_mvt, m.date_mvt, m.mnt_mvt from customer c full outer join account a on c.id_customer=a.id_customer full outer join mouvement m on a.id_account=m.id_account  

create view vue_enssemble as select * from table_essemble ;
alter table table_essemble rename to table_ensemble ;
alter view  vue_enssemble rename to vue_ensemble ;


