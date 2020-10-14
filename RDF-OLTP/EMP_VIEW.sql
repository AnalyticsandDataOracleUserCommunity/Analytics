CREATE OR REPLACE FORCE EDITIONABLE VIEW SaaS_EMP_VIEW AS 
SELECT /*+ dynamic_sampling(6)  */  distinct
      emp_uri 
    , empno
    , ename 
    , job 
    , mgr_uri 
    , hiredate 
    , sal salary
    , comm 
    , training 
    , dept_uri 
    , dname 
    , loc location
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
    SELECT ?emp_uri ?empno ?ename ?job ?mgr_uri ?hiredate ?sal ?comm ?training ?dept_uri ?dname ?loc ?award #VIEW_SELECT_TEMPLATE_2
    WHERE 
      {
            ?emp_uri a saas:Emp .
            ?emp_uri saas:empno ?empno .
            ?emp_uri saas:ename ?ename .
            OPTIONAL{ ?emp_uri saas:job ?job . } 
            OPTIONAL{ ?emp_uri saas:empMgrEVA ?mgr_uri . }
            OPTIONAL{ ?emp_uri saas:hiredate ?hiredate . } 
            OPTIONAL{ ?emp_uri saas:sal ?sal . } 
            OPTIONAL{ ?emp_uri saas:comm ?comm . } 
            OPTIONAL{ ?emp_uri saas:training ?training . } 
            OPTIONAL{ ?emp_uri saas:empDeptEVA ?dept_uri . }
            OPTIONAL{ ?emp_uri saas:empDeptEVA ?dept_uri . 
                      ?dept_uri saas:dname ?dname . }
            OPTIONAL{ ?emp_uri saas:empDeptEVA ?dept_uri . 
                      ?dept_uri saas:loc ?loc . }
            OPTIONAL{ ?emp_uri saas:empDeptEVA ?dept_uri . 
                      ?dept_uri saas:award ?award . }
            #VIEW_SELECT_TEMPLATE_3
      }',
    SEM_MODELS(model_param_handler.get_model_name),
    null, 
    null,
    null,
    null,
    ' PLUS_RDFT=VC DO_UNESCAPE=T ALLOW_DUP=T ', null, null, 'rdfuser', 'mynetwork'));
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_EMP_VIEW_TRIGGER_INSERT 
     INSTEAD OF insert ON SaaS_EMP_VIEW
     FOR EACH ROW
DECLARE 
    v_emp_uri varchar2(4000); 
    v_empno varchar2(4000);
    --VIEW_INSERT_TEMPLATE_1
BEGIN
    v_empno := :new.empno;
    v_emp_uri := 'saas:' || 'Emp_' || v_empno;
    --VIEW_INSERT_TEMPLATE_2
    sem_apis.update_model(model_param_handler.get_model_name, 
      'PREFIX saas: <http://SaaS.org/>
        DELETE { 
            ?z saas:ename ?ename .
            ?z saas:job ?job .
            ?z saas:hiredate ?hiredate .
            ?z saas:sal ?salary .
            ?z saas:comm ?comm .
            ?z saas:training ?training .
            #VIEW_INSERT_TEMPLATE_3
        }
        WHERE {
            OPTIONAL { { select ?x where {
                         ?x a saas:Emp .
                         ?x saas:empno "' || :new.empno || '" .
           #VIEW_INSERT_TEMPLATE_4
            } } }
        FILTER( BOUND(?x))
        OPTIONAL { { select ?y where {
                     ?y a saas:Emp .
                     ?y saas:empno "' || :new.empno || '" .
                     ?y saas:ename "' || :new.ename || '" .
                     ?y saas:job "' || :new.job || '" .
                     ?y saas:hiredate "' || :new.hiredate || '" .
                     ?y saas:sal "' || :new.salary || '" .
                     ?y saas:comm "' || :new.comm || '" .
                     ?y saas:training "' || :new.training || '" .
           #VIEW_INSERT_TEMPLATE_5
        } } }
        FILTER( ! BOUND(?y))
           ?z a saas:Emp .
           ?z saas:empno "' || :new.empno || '" .
           ?z saas:ename ?ename .
           ?z saas:job ?job .
           ?z saas:hiredate ?hiredate .
           ?z saas:sal ?salary .
           ?z saas:comm ?comm .
           ?z saas:training ?training .
           #VIEW_INSERT_TEMPLATE_6
        };
        INSERT { 
            ' || v_emp_uri || ' a saas:Emp .
            ' || v_emp_uri || ' saas:empno "' || :new.empno || '" .
            ' || v_emp_uri || ' saas:ename "' || :new.ename || '" .
            ' || v_emp_uri || ' saas:job "' || :new.job || '" .
            ' || v_emp_uri || ' saas:hiredate "' || :new.hiredate || '" .
            ' || v_emp_uri || ' saas:sal "' || :new.salary || '" .
            ' || v_emp_uri || ' saas:comm "' || :new.comm || '" .
            ' || v_emp_uri || ' saas:training "' || :new.training || '" .
            #VIEW_INSERT_TEMPLATE_7
        }
        WHERE {
        OPTIONAL { { select ?y where {
                     ?y a saas:Emp .
                     ?y saas:empno "' || :new.empno || '" .
                     ?y saas:ename "' || :new.ename || '" .
                     ?y saas:job "' || :new.job || '" .
                     ?y saas:hiredate "' || :new.hiredate || '" .
                     ?y saas:sal "' || :new.salary || '" .
                     ?y saas:comm "' || :new.comm || '" .
                     ?y saas:training "' || :new.training || '" .
           #VIEW_INSERT_TEMPLATE_8
        } } }
        FILTER( ! BOUND(?y))
        } ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
END;
/  
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_EMP_VIEW_TRIGGER_UPDATE 
     INSTEAD OF update ON SaaS_EMP_VIEW
     FOR EACH ROW
DECLARE 
    v_emp_uri varchar2(4000) ; 
    v_eva_uri varchar2(4000) ;
    --VIEW_UPDATE _TEMPLATE_1 
BEGIN
    v_emp_uri                := REGEXP_REPLACE(:old.emp_uri, 'http://SaaS.org/', 'saas:');
    --Update ename Attribute in emp
    IF :new.ename is not null and (:old.ename is null or (:new.ename != :old.ename)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:ename "' || :old.ename || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:ename "' || :new.ename || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.ename is null and:old.ename is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:ename "' || :old.ename || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update job Attribute in emp
    IF :new.job is not null and (:old.job is null or (:new.job != :old.job)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:job "' || :old.job || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:job "' || :new.job || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.job is null and:old.job is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:job "' || :old.job || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update mgr_uri Attribute in emp
    IF :new.mgr_uri is not null and (:old.mgr_uri is null or (:new.mgr_uri != :old.mgr_uri)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> 
           INSERT DATA { ' || v_emp_uri || ' saas:empMgrEVA ' || :new.mgr_uri || ' .
                         ' || :new.mgr_uri || ' saas:mgrEmpEVA ' || v_emp_uri || ' .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.mgr_uri is null and:old.mgr_uri is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:mgr_uri "' || :old.mgr_uri || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update hiredate Attribute in emp
    IF :new.hiredate is not null and (:old.hiredate is null or (:new.hiredate != :old.hiredate)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:hiredate "' || :old.hiredate || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:hiredate "' || :new.hiredate || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.hiredate is null and:old.hiredate is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:hiredate "' || :old.hiredate || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update salary Attribute in emp
    IF :new.salary is not null and (:old.salary is null or (:new.salary != :old.salary)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:sal "' || :old.salary || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:sal "' || :new.salary || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.sal is null and:old.sal is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:sal "' || :old.sal || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update comm Attribute in emp
    IF :new.comm is not null and (:old.comm is null or (:new.comm != :old.comm)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:comm "' || :old.comm || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:comm "' || :new.comm || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.comm is null and:old.comm is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:comm "' || :old.comm || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update training Attribute in emp
    IF :new.training is not null and (:old.training is null or (:new.training != :old.training)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:training "' || :old.training || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { ' || v_emp_uri || ' saas:training "' || :new.training || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.training is null and:old.training is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:training "' || :old.training || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update dept_uri Attribute in emp
    IF :new.dept_uri is not null and (:old.dept_uri is null or (:new.dept_uri != :old.dept_uri)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> 
           INSERT DATA { ' || v_emp_uri || ' saas:empDeptEVA ' || :new.dept_uri || ' .
                         ' || :new.dept_uri || ' saas:deptEmpEVA ' || v_emp_uri || ' .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.dept_uri is null and:old.dept_uri is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:dept_uri "' || :old.dept_uri || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update dname Attribute in dept
    IF :new.dname is not null and (:old.dname is null or (:new.dname != :old.dname)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { <' || :old.dept_uri || '> saas:dname "' || :old.dname || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { <' || :old.dept_uri || '> saas:dname "' || :new.dname || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.dname is null and:old.dname is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:dname "' || :old.dname || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update location Attribute in dept
    IF :new.location is not null and (:old.location is null or (:new.location != :old.location)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { <' || :old.dept_uri || '> saas:loc "' || :old.location || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { <' || :old.dept_uri || '> saas:loc "' || :new.location || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.loc is null and:old.loc is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:loc "' || :old.loc || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --Update award Attribute in dept
    IF :new.award is not null and (:old.award is null or (:new.award != :old.award)) THEN
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> DELETE DATA { <' || :old.dept_uri || '> saas:award "' || :old.award || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
        sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas:  <http://SaaS.org/> INSERT DATA { <' || :old.dept_uri || '> saas:award "' || :new.award || '" .
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END IF ;
    --IF :new.award is null and:old.award is not null THEN
    --    sem_apis.update_model(model_param_handler.get_model_name, 'PREFIX saas:  <http://SaaS.org/> DELETE DATA { ' || v_emp_uri || ' saas:award "' || :old.award || '"  }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
    --END IF ;
    --VIEW_UPDATE_TEMPLATE_2
END;
/   
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_EMP_VIEW_TRIGGER_DELETE
     INSTEAD OF delete ON SaaS_EMP_VIEW
     FOR EACH ROW
DECLARE  
    v_emp_uri varchar2(4000) ;
    --VIEW_DELETE_TEMPLATE_1
BEGIN
    v_emp_uri  := REGEXP_REPLACE(:old.emp_uri, 'http://SaaS.org/', 'saas:');
    sem_apis.update_model(model_param_handler.get_model_name, 
       'PREFIX saas: <http://SaaS.org/> 
    DELETE {' || v_emp_uri || ' ?a ?v .
        #VIEW_DELETE_TEMPLATE_2
    } 
    WHERE { ' || v_emp_uri || ' ?a ?v .
    };
    DELETE {
        ?eva_uri saas:mgrEmpEVA ' || v_emp_uri || ' .
    }
    WHERE {
        ?eva_uri saas:mgrEmpEVA ' || v_emp_uri || ' .
    };
    DELETE {
        ?eva_uri saas:deptEmpEVA ' || v_emp_uri || ' .
    }
    WHERE {
        ?eva_uri saas:deptEmpEVA ' || v_emp_uri || ' .
    #VIEW_DELETE_TEMPLATE_3
    }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
END;
/ 
/*
select * from SaaS_EMP_VIEW;
*/
