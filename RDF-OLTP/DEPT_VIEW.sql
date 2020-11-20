CREATE OR REPLACE FORCE EDITIONABLE VIEW SaaS_DEPT_VIEW AS 
SELECT /*+ dynamic_sampling(6)  */  distinct
      dept_uri 
    , dept_id
    , deptno
    , dname 
    , loc 
    , award 
    --VIEW_SELECT_TEMPLATE_1
FROM TABLE(SEM_MATCH(
   'PREFIX  rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX  owl: <http://www.w3.org/2002/07/owl#>
    PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX   dc: <http://purl.org/dc/elements/1.1/>
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX saas: <http://SaaS.org/>
    SELECT ?dept_uri ?dept_id ?deptno ?dname ?loc ?award #VIEW_SELECT_TEMPLATE_2
    WHERE 
      {
            ?dept_uri a saas:Dept .
            ?dept_uri saas:deptno ?deptno .
            OPTIONAL { ?dept_uri saas:dept_id ?dept_id . }
            ?dept_uri saas:dname ?dname .
            OPTIONAL { ?dept_uri saas:loc ?loc . } 
            OPTIONAL { ?dept_uri saas:award ?award . } 
            #VIEW_SELECT_TEMPLATE_3
      }',
    SEM_MODELS(model_param_handler.get_model_name),
    null, 
    null,
    null,
    null,
    ' PLUS_RDFT=VC DO_UNESCAPE=T ALLOW_DUP=T ', null, null, 'rdfuser', 'mynetwork'));
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_DEPT_VIEW_TRIGGER_INSERT 
INSTEAD OF insert ON SaaS_DEPT_VIEW
FOR EACH ROW
BEGIN
        dbms_output.put_line('Starting to process the constraint checking block(s) for Dept inserts.');--VIEW_INSERT_TEMPLATE_1
    DECLARE
        s_dept_uri varchar2(4000);
        v_dept_uri varchar2(4000); 
        v_dept_id varchar2(4000);
        v_dummy varchar2(4000); 
        v_dname varchar2(4000);
        v_loc varchar2(4000);
        v_award varchar2(4000);
        --VIEW_INSERT_TEMPLATE_2
        BEGIN
        dbms_output.put_line('Starting to process the main block for Dept inserts.');
        --VIEW_INSERT_TEMPLATE_3
        select distinct dept_uri into s_dept_uri 
        from saas_dept_view where deptno = :new.deptno;
     -- From the above query, if the dept doesn't exist, an exception is thrown, which means this is a new dept. The new dept is inserted using the exception code at the bottom of this block.
     -- If no exception is thrown, do a query to get the attribute values that might need to be updated.
        select distinct '', dname, loc, award--VIEW_INSERT_TEMPLATE_5 
        into v_dummy, v_dname, v_loc, v_award--VIEW_INSERT_TEMPLATE_6
        from saas_dept_view where deptno = :new.deptno;
        --VIEW_INSERT_TEMPLATE_4
        -- Update dname
        IF (v_dname is null and :new.dname is not null) or (:new.dname is null and v_dname is not null) or v_dname != :new.dname then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Dept', 'dname', v_dname, :new.dname, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_dept_uri || '> saas:dname  "' || v_dname || '".
            };
            INSERT DATA { 
                <' || s_dept_uri || '> saas:dname  "' || nvl(:new.dname, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update loc
        IF (v_loc is null and :new.loc is not null) or (:new.loc is null and v_loc is not null) or v_loc != :new.loc then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Dept', 'loc', v_loc, :new.loc, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_dept_uri || '> saas:loc  "' || v_loc || '".
            };
            INSERT DATA { 
                <' || s_dept_uri || '> saas:loc  "' || nvl(:new.loc, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update award
        IF (v_award is null and :new.award is not null) or (:new.award is null and v_award is not null) or v_award != :new.award then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Dept', 'award', v_award, :new.award, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_dept_uri || '> saas:award  "' || v_award || '".
            };
            INSERT DATA { 
                <' || s_dept_uri || '> saas:award  "' || nvl(:new.award, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        --VIEW_INSERT_TEMPLATE_7
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_dept_uri := 'saas:Dept' || '_' || :new.deptno;
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) 
                          values (audit_id_seq.nextval, 'Dept', 'insert', '', v_dept_uri, SYSTIMESTAMP, user);
         -- Add new dept.
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            INSERT DATA { 
                ' || v_dept_uri || ' a saas:Dept .
                ' || v_dept_uri || ' saas:dept_id "' || v_dept_id || '" .
                ' || v_dept_uri || ' saas:deptno "' || :new.deptno || '" .
                ' || v_dept_uri || ' saas:dname "' || :new.dname || '" .
                ' || v_dept_uri || ' saas:loc "' || :new.loc || '" .
                ' || v_dept_uri || ' saas:award "' || :new.award || '" .
                #VIEW_INSERT_TEMPLATE_9
            }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END;
--Insert more here
END; 
/
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_DEPT_VIEW_TRIGGER_UPDATE 
     INSTEAD OF update ON SaaS_DEPT_VIEW
     FOR EACH ROW
DECLARE 
    v_dept_uri varchar2(4000) ; 
    v_eva_uri varchar2(4000) ;
    --VIEW_UPDATE _TEMPLATE_1 
BEGIN
    v_dept_uri                := REGEXP_REPLACE(:old.dept_uri, 'http://SaaS.org/', 'saas:');
    --Update dname Attribute in dept
    IF :new.dname is not null and (:old.dname is null or (:new.dname != :old.dname)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:dname "' || :old.dname || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_dept_uri || ' saas:dname "' || :new.dname || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.dname is null and:old.dname is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:dname "' || :old.dname || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update loc Attribute in dept
    IF :new.loc is not null and (:old.loc is null or (:new.loc != :old.loc)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:loc "' || :old.loc || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_dept_uri || ' saas:loc "' || :new.loc || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.loc is null and:old.loc is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:loc "' || :old.loc || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update award Attribute in dept
    IF :new.award is not null and (:old.award is null or (:new.award != :old.award)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:award "' || :old.award || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_dept_uri || ' saas:award "' || :new.award || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.award is null and:old.award is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_dept_uri || ' saas:award "' || :old.award || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --VIEW_UPDATE_TEMPLATE_2
END;
/   
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_DEPT_VIEW_TRIGGER_DELETE
     INSTEAD OF delete ON SaaS_DEPT_VIEW
     FOR EACH ROW
DECLARE  
    v_dept_uri varchar2(4000) ;
    --VIEW_DELETE_TEMPLATE_1
BEGIN
    v_dept_uri  := REGEXP_REPLACE(:old.dept_uri, 'http://SaaS.org/', 'saas:');
    sem_apis.update_model(model_param_handler.get_model_name, 
       'PREFIX saas: <http://SaaS.org/> 
    DELETE {' || v_dept_uri || ' ?a ?v .
        #VIEW_DELETE_TEMPLATE_2
    } 
    WHERE { ' || v_dept_uri || ' ?a ?v .
    #VIEW_DELETE_TEMPLATE_3
    }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
END;
/ 
/*
select * from SaaS_DEPT_VIEW;
*/
