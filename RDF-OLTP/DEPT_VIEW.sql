CREATE OR REPLACE FORCE EDITIONABLE VIEW SaaS_DEPT_VIEW AS 
SELECT /*+ dynamic_sampling(6)  */  distinct
      dept_uri 
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
    SELECT ?dept_uri ?deptno ?dname ?loc ?award #VIEW_SELECT_TEMPLATE_2
    WHERE 
      {
            ?dept_uri a saas:Dept .
            ?dept_uri saas:deptno ?deptno .
            ?dept_uri saas:dname ?dname .
            OPTIONAL{ ?dept_uri saas:loc ?loc . } 
            OPTIONAL{ ?dept_uri saas:award ?award . } 
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
DECLARE 
    v_dept_uri varchar2(4000); 
    v_deptno varchar2(4000);
    --VIEW_INSERT_TEMPLATE_1
BEGIN
    v_deptno := :new.deptno;
    v_dept_uri := 'saas:' || 'Dept_' || v_deptno;
    --VIEW_INSERT_TEMPLATE_2
    sem_apis.update_model(model_param_handler.get_model_name, 
      'PREFIX saas: <http://SaaS.org/>
        DELETE { 
            ?z saas:dname ?dname .
            ?z saas:loc ?loc .
            ?z saas:award ?award .
            #VIEW_INSERT_TEMPLATE_3
        }
        WHERE {
            OPTIONAL { { select ?x where {
                         ?x a saas:Dept .
                         ?x saas:deptno "' || :new.deptno || '" .
           #VIEW_INSERT_TEMPLATE_4
            } } }
        FILTER( BOUND(?x))
        OPTIONAL { { select ?y where {
                     ?y a saas:Dept .
                     ?y saas:deptno "' || :new.deptno || '" .
                     ?y saas:dname "' || :new.dname || '" .
                     ?y saas:loc "' || :new.loc || '" .
                     ?y saas:award "' || :new.award || '" .
           #VIEW_INSERT_TEMPLATE_5
        } } }
        FILTER( ! BOUND(?y))
           ?z a saas:Dept .
           ?z saas:deptno "' || :new.deptno || '" .
           ?z saas:dname ?dname .
           ?z saas:loc ?loc .
           ?z saas:award ?award .
           #VIEW_INSERT_TEMPLATE_6
        };
        INSERT { 
            ' || v_dept_uri || ' a saas:Dept .
            ' || v_dept_uri || ' saas:deptno "' || :new.deptno || '" .
            ' || v_dept_uri || ' saas:dname "' || :new.dname || '" .
            ' || v_dept_uri || ' saas:loc "' || :new.loc || '" .
            ' || v_dept_uri || ' saas:award "' || :new.award || '" .
            #VIEW_INSERT_TEMPLATE_7
        }
        WHERE {
        OPTIONAL { { select ?y where {
                     ?y a saas:Dept .
                     ?y saas:deptno "' || :new.deptno || '" .
                     ?y saas:dname "' || :new.dname || '" .
                     ?y saas:loc "' || :new.loc || '" .
                     ?y saas:award "' || :new.award || '" .
           #VIEW_INSERT_TEMPLATE_8
        } } }
        FILTER( ! BOUND(?y))
        } ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
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
