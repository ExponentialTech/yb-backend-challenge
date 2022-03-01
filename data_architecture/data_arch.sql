CREATE SCHEMA yves_blue;

CREATE TABLE yves_blue.asset_class (
	id                   int  NOT NULL    PRIMARY KEY,
	class                enum('Equities','Fixed Incomes','Cash Equivalents','Commodities','Real Estate')  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.company (
	id                   int  NOT NULL    PRIMARY KEY,
	name                 varchar(100)  NOT NULL    ,
	description          varchar(100)  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.company_esg (
	id                   int  NOT NULL    PRIMARY KEY,
	company_id           int  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.instrument (
	id                   int  NOT NULL    PRIMARY KEY,
	isin                 varchar(30)  NOT NULL    ,
	company_id           int      ,
	asset_class_id       int  NOT NULL    ,
	name                 varchar(100)  NOT NULL    ,
	`type`               enum('Cash', 'Certificate of Deposit', 'ETF', 'Futures Contract', 'Loan', 'Mortgage', 'Muni Bond', 'Mutual Fund', 'REITs', 'Stock', 'Treasuries')  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.instrument_esg (
	id                   int  NOT NULL    PRIMARY KEY,
	instrument_id        int  NOT NULL
 );

CREATE TABLE yves_blue.instrument_holding (
	id                   int  NOT NULL    PRIMARY KEY,
	instrument_id        int  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.portfolio (
	id                   int  NOT NULL    PRIMARY KEY
 ) engine=InnoDB;

CREATE TABLE yves_blue.portfolio_esg (
	id                   int  NOT NULL    PRIMARY KEY,
	portfolio_id         int  NOT NULL
 );

CREATE TABLE yves_blue.portfolio_holding (
	id                   int  NOT NULL    PRIMARY KEY,
	portfolio_id         int  NOT NULL
 );

CREATE TABLE yves_blue.esg_score (
	id                   int  NOT NULL    PRIMARY KEY,
	e                    double  NOT NULL    ,
	s                    double  NOT NULL    ,
	g                    double  NOT NULL    ,
	aggregate            double  NOT NULL
 ) engine=InnoDB;

CREATE TABLE yves_blue.holding (
	id                   int  NOT NULL    PRIMARY KEY,
	instrument_id        int  NOT NULL    ,
	weight               double  NOT NULL
 );

CREATE INDEX fk_holding_instrument ON yves_blue.instrument_holding ( instrument_id );

CREATE INDEX fk_holding_instrument_0 ON yves_blue.portfolio_holding ( portfolio_id );

ALTER TABLE yves_blue.company_esg ADD CONSTRAINT fk_company_esg_company FOREIGN KEY ( company_id ) REFERENCES yves_blue.company( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.esg_score ADD CONSTRAINT fk_esg_score_company_esg FOREIGN KEY ( id ) REFERENCES yves_blue.company_esg( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.esg_score ADD CONSTRAINT fk_esg_score_instrument_esg FOREIGN KEY ( id ) REFERENCES yves_blue.instrument_esg( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.esg_score ADD CONSTRAINT fk_esg_score_portfolio_esg FOREIGN KEY ( id ) REFERENCES yves_blue.portfolio_esg( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.holding ADD CONSTRAINT fk_holding_portfolio_holding FOREIGN KEY ( id ) REFERENCES yves_blue.portfolio_holding( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.holding ADD CONSTRAINT fk_holding_instrument_holding FOREIGN KEY ( id ) REFERENCES yves_blue.instrument_holding( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.holding ADD CONSTRAINT fk_holding_instrument_1 FOREIGN KEY ( instrument_id ) REFERENCES yves_blue.instrument( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE yves_blue.instrument ADD CONSTRAINT fk_instrument_company FOREIGN KEY ( company_id ) REFERENCES yves_blue.company( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE yves_blue.instrument ADD CONSTRAINT fk_instrument_asset_class FOREIGN KEY ( asset_class_id ) REFERENCES yves_blue.asset_class( id ) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE yves_blue.instrument_esg ADD CONSTRAINT fk_instrument_esg_instrument FOREIGN KEY ( instrument_id ) REFERENCES yves_blue.instrument( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.instrument_holding ADD CONSTRAINT fk_instrument_holding_instrument FOREIGN KEY ( instrument_id ) REFERENCES yves_blue.instrument( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.portfolio_esg ADD CONSTRAINT fk_portfolio_esg_portfolio FOREIGN KEY ( portfolio_id ) REFERENCES yves_blue.portfolio( id ) ON DELETE CASCADE ON UPDATE NO ACTION;

ALTER TABLE yves_blue.portfolio_holding ADD CONSTRAINT fk_portfolio_holding_portfolio FOREIGN KEY ( portfolio_id ) REFERENCES yves_blue.portfolio( id ) ON DELETE CASCADE ON UPDATE NO ACTION;
