--Elouaham Wiam--
--G2--


SET SERVEROUTPUT ON 
--1)
CREATE OR REPLACE TRIGGER Ex1 
	BEFORE INSERT OR DELETE OR UPDATE ON pilote 
	DECLARE 
		vh NUMBER;
		vc VARCHAR2(2);
	BEGIN
		SELECT TO_CHAR(sysdate,'HH24') INTO vc FROM dual;
		vh:=TO_NUMBER(vc);
		IF vh<=18 AND vh>=8 THEN
			IF UPDATING THEN
				RAISE_APPLICATION_ERROR(-20502,'Mise à jour impossible à cette heure.');
			ELSIF INSERTING THEN
				RAISE_APPLICATION_ERROR(-20501,'Insertion impossible à cette heure.');
			ELSE
				RAISE_APPLICATION_ERROR(-20503,'Suppression impossible à cette heure.');
			END IF;
		END IF;
	END;
	/

--2)
 -- create table Audit_Pilote_Table(
	-- 	ID 	varchar2(6) not null,
	--     USERNAME 	varchar2(30),
	--     timestamp date,
	--     old_last_name	varchar2(30),
	--     new_last_name	varchar2(30),
	--     old_comm number(8,2),
	--     new_comm number(8,2),
	--     old_salary number(8,2),
	--     new_salary number(8,2)
	-- );


	CREATE OR REPLACE TRIGGER Ex2 
	AFTER DELETE OR INSERT OR UPDATE ON pilote
	FOR EACH ROW
	--DECLARE
		--PRAGMA AUTONOMOUS_TRANSACTION;
	BEGIN
		IF INSERTING THEN
			INSERT INTO Audit_Pilote_Table VALUES(:new.NOPILOT,:new.nom,SYSDATE,NULL,:new.nom,NULL,:new.comm,NULL,:new.sal);
		ELSIF DELETING THEN
			INSERT INTO Audit_Pilote_Table VALUES(:old.NOPILOT,:old.nom,SYSDATE,:old.nom,NULL,:old.comm,NULL,:old.sal,NULL);
		ELSE
			INSERT INTO Audit_Pilote_Table VALUES(:new.NOPILOT,:new.nom,SYSDATE,:old.nom,:new.nom,:old.comm,:new.comm,:old.sal,:new.sal);
		END IF;
	END;
	/
--3)


    CREATE OR REPLACE TRIGGER compte BEFORE update 
    ON PILOTE FOR EACH ROW 
    DECLARE
    nbmodif number:=0 ;
	BEGIN 
     IF UPDATING THEN 
     nbmodif:= nbmodif+1 ;
	
     END IF ;
    DBMS_OUTPUT.PUT_LINE(nbmodif);
   END ;
 / 

--4)
CREATE OR REPLACE TRIGGER Ex4
	BEFORE UPDATE ON pilote
	FOR EACH ROW
	BEGIN
		IF UPDATING THEN 
			IF :new.sal>=:old.sal*1.1 THEN
				RAISE_APPLICATION_ERROR(-20504,'Plus de 10% d un coup!!');
			END IF;
		END IF;
	END;
	/
--5)
	CREATE OR REPLACE TRIGGER Ex5
	BEFORE INSERT ON pilote
	BEGIN
		IF INSERTING THEN
			IF USER='SYSTEM' THEN
				RAISE_APPLICATION_ERROR(-20505,'Utilisateur non autorise');
			END IF;
		END IF;
	END;
	/

--6)
CREATE OR REPLACE TRIGGER Ex6
	AFTER INSERT OR UPDATE ON AVION
	DECLARE
		Moy NUMBER:=0;
	BEGIN
		SELECT AVG(NBHVOL)
		INTO Moy
		FROM AVION;
		IF INSERTING OR UPDATING THEN
			IF Moy>200000 THEN
				RAISE_APPLICATION_ERROR(-20506,'le nombre moyen d heure de vol est trop eleve');
			END IF;
		END IF;
	END;
	/

--7)


--8)
        ALTER TRIGGER verif_nhvol DISABLE;
	ALTER TABLE pilote DISABLE ALL TRIGGERS;
