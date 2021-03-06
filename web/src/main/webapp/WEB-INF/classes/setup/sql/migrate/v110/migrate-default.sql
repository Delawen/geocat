CREATE TABLE MetadataNotifications
  (
    metadataId         int,
    notifierId         int,
    notified           char(1)        default 'n' not null,
    metadataUuid       varchar(250)   not null,
    action             char(1)        not null,
    errormsg           text,

    primary key(metadataId,notifierId),

    foreign key(notifierId) references MetadataNotifiers(id)
  );
  
UPDATE Settings SET value='1.1.0' WHERE name='version';
UPDATE Settings SET value='geocat' WHERE name='subVersion';
UPDATE Settings SET value='prefer_locale' where name='only';

INSERT INTO Settings VALUES (956,1,'hidewithheldelements',NULL);
INSERT INTO Settings VALUES (957,956,'enable','false');
INSERT INTO Settings VALUES (958,956,'keepMarkedElement','true');

INSERT INTO settings VALUES ( 3, 1, 'wmtTimestamp', '20120809');

UPDATE settings SET value='0 0 1 * * ?' where name = 'every';
INSERT INTO Settings VALUES (24,20,'securePort','443');

DROP VIEW sharedusers;
ALTER TABLE users ALTER "password" TYPE character varying(120);
ALTER TABLE users ADD security varchar(128);
ALTER TABLE users ADD authtype varchar(32);
ALTER TABLE harvesthistory ADD elapsedtime integer;
UPDATE harvesthistory SET elapsedtime=0;

ALTER TABLE UserGroups ADD profile varchar(32);


UPDATE usergroups SET profile = (SELECT profile from users WHERE id = userid);

ALTER TABLE usergroups DROP CONSTRAINT usergroups_pkey;
ALTER TABLE usergroups ADD PRIMARY KEY (userid, profile, groupid);


update users SET security = 'update_hash_required';

DELETE FROM StatusValuesDes where langid='fra' or langid='deu';
DELETE FROM categoriesdes where langid='fra' or langid='deu';
DELETE FROM CswServerCapabilitiesInfo where langid='fra' or langid='deu';

INSERT INTO CswServerCapabilitiesInfo VALUES ( 5, 'fre', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 6, 'fre', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 7, 'fre', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 8, 'fre', 'accessConstraints', '');

INSERT INTO CswServerCapabilitiesInfo VALUES ( 9, 'ita', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 10, 'ita', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 11, 'ita', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 12, 'ita', 'accessConstraints', '');

INSERT INTO CswServerCapabilitiesInfo VALUES ( 13, 'ger', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 14, 'ger', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 15, 'ger', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 16, 'ger', 'accessConstraints', '');

INSERT INTO CswServerCapabilitiesInfo VALUES ( 17, 'roh', 'title', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 18, 'roh', 'abstract', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 19, 'roh', 'fees', '');
INSERT INTO CswServerCapabilitiesInfo VALUES ( 20, 'roh', 'accessConstraints', '');

DELETE FROM isolanguagesdes where langid='fra' or langid='deu' or iddes='500' or iddes='501';
DELETE FROM isolanguages where code='fra' or code='deu';
DELETE FROM groupsdes where langid='fra' or langid='deu';

UPDATE operationsdes SET langid='ger' where langid='deu';
UPDATE operationsdes SET langid='fre' where langid='fra';

UPDATE statusvaluesdes SET langid='ger' where langid='deu';
UPDATE statusvaluesdes SET langid='fre' where langid='fra';

UPDATE regionsdes SET langid='ger' where langid='deu';
UPDATE regionsdes SET langid='fre' where langid='fra';

UPDATE categoriesdes SET langid='ger' where langid='deu';
UPDATE categoriesdes SET langid='fre' where langid='fra';


DELETE FROM Languages where id='fra' or id='deu';

insert into groupsdes select distinct on (iddes) iddes, 'ita' as langid,label from groupsdes where not iddes in (select iddes from groupsdes where langid='ita' group by iddes);
insert into categoriesdes select distinct on (iddes) iddes, 'ita' as langid,label from categoriesdes where not iddes in (select iddes from categoriesdes where langid='ita' group by iddes);
insert into operationsdes select distinct on (iddes) iddes, 'ita' as langid,label from operationsdes where not iddes in (select iddes from operationsdes where langid='ita' group by iddes);
insert into regionsdes select distinct on (iddes) iddes, 'ita' as langid,label from regionsdes where not iddes in (select iddes from regionsdes where langid='ita' group by iddes);
insert into statusvaluesdes select distinct on (iddes) iddes, 'ita' as langid,label from statusvaluesdes where not iddes in (select iddes from statusvaluesdes where langid='ita' group by iddes);

insert into groupsdes select distinct on (iddes) iddes, 'roh' as langid,label from groupsdes where not iddes in (select iddes from groupsdes where langid='roh' group by iddes);
insert into categoriesdes select distinct on (iddes) iddes, 'roh' as langid,label from categoriesdes where not iddes in (select iddes from categoriesdes where langid='roh' group by iddes);
insert into operationsdes select distinct on (iddes) iddes, 'roh' as langid,label from operationsdes where not iddes in (select iddes from operationsdes where langid='roh' group by iddes);
insert into regionsdes select distinct on (iddes) iddes, 'roh' as langid,label from regionsdes where not iddes in (select iddes from regionsdes where langid='roh' group by iddes);
insert into statusvaluesdes select distinct on (iddes) iddes, 'roh' as langid,label from statusvaluesdes where not iddes in (select iddes from statusvaluesdes where langid='roh' group by iddes);

-- ======================================================================
-- Create a gt_pk_metadata table if it doesn't already exist so that geotools
-- won't abort the transaction and fail to get the primary key info from the 
-- database - this is very likely due to a bug in geotools - however as long 
-- as the table exists geotools will be happy (rows are not required).
-- ie. THIS TABLE IS MEANT TO BE EMPTY.
-- More info at http://trac.osgeo.org/geonetwork/ticket/1169
-- DO NOT UNWRAP THIS LINE INTO MULTIPLE LINES! OTHERWISE IT WILL NOT EXECUTE 
-- CORRECTLY AND GEONETWORK WILL NOT BUILD THE DATABASE CORRECTLY

CREATE OR REPLACE FUNCTION create_gt_pk_metadata () RETURNS void AS $$ BEGIN IF NOT EXISTS ( SELECT * FROM   pg_catalog.pg_tables WHERE tablename  = 'gt_pk_metadata' AND schemaname = current_schema()) THEN CREATE TABLE gt_pk_metadata ( table_schema VARCHAR(32) NOT NULL, table_name VARCHAR(256) NOT NULL, pk_column VARCHAR(32) NOT NULL, pk_column_idx INTEGER, pk_policy VARCHAR(32), pk_sequence VARCHAR(64), unique (table_schema, table_name, pk_column), check (pk_policy in ('sequence', 'assigned', 'autogenerated'))); END IF; END; $$ LANGUAGE 'plpgsql';

SELECT create_gt_pk_metadata ();


-- copy search columns to *_search spatial tables:
alter table kantone_search add column "SEARCH" varchar(254);
UPDATE kantone_search SET "SEARCH"="kantoneBB"."SEARCH" from "kantoneBB" WHERE kantone_search."KANTONSNR"="kantoneBB"."KANTONSNR";

alter table countries_search add column "SEARCH" varchar(254);
UPDATE countries_search SET "SEARCH"="countries"."SEARCH" from "countries" WHERE countries_search."ID"="countries"."ID";

alter table gemeinden_search add column "SEARCH" varchar(254);
UPDATE gemeinden_search SET "SEARCH"="gemeindenBB"."SEARCH" from "gemeindenBB" WHERE gemeinden_search."OBJECTVAL"="gemeindenBB"."OBJECTVAL";

-- propably not necessary but doesn't hurt
UPDATE geometry_columns SET srid=4326 where f_table_name='kantone_search' or f_table_name='gemeinden_search' or f_table_name='countries_search';