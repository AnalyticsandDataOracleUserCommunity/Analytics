CREATE OR REPLACE FORCE EDITIONABLE VIEW SaaS_EMP_VIEW AS 
SELECT /*+ dynamic_sampling(6)  */  distinct
      emp_uri 
    , emp_id
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
    SELECT ?emp_uri ?emp_id ?empno ?ename ?job ?mgr_uri ?hiredate ?sal ?comm ?training ?dept_uri ?dname ?loc ?award #VIEW_SELECT_TEMPLATE_2
    WHERE 
      {
            ?emp_uri a saas:Emp .
            ?emp_uri saas:empno ?empno .
            OPTIONAL { ?emp_uri saas:emp_id ?emp_id . }
            ?emp_uri saas:ename ?ename .
            OPTIONAL { ?emp_uri saas:job ?job . } 
            OPTIONAL { ?emp_uri saas:empMgrEVA ?mgr_uri . }
            OPTIONAL { ?emp_uri saas:hiredate ?hiredate . } 
            OPTIONAL { ?emp_uri saas:sal ?sal . } 
            OPTIONAL { ?emp_uri saas:comm ?comm . } 
            OPTIONAL { ?emp_uri saas:training ?training . } 
            OPTIONAL { ?emp_uri saas:empDeptEVA ?dept_uri . }
            OPTIONAL { ?emp_uri saas:empDeptEVA ?dept_uri . 
                          ?dept_uri saas:dname ?dname . }
            OPTIONAL { ?emp_uri saas:empDeptEVA ?dept_uri . 
                          ?dept_uri saas:loc ?loc . }
            OPTIONAL { ?emp_uri saas:empDeptEVA ?dept_uri . 
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
BEGIN
        dbms_output.put_line('Starting to process the constraint checking block(s) for Emp inserts.');--VIEW_INSERT_TEMPLATE_1
    DECLARE
        s_emp_uri varchar2(4000);
        v_emp_uri varchar2(4000); 
        v_emp_id varchar2(4000);
        v_dummy varchar2(4000); 
        v_ename varchar2(4000);
        v_job varchar2(4000);
        v_hiredate varchar2(4000);
        v_salary varchar2(4000);
        v_comm varchar2(4000);
        v_training varchar2(4000);
        --VIEW_INSERT_TEMPLATE_2
        BEGIN
        dbms_output.put_line('Starting to process the main block for Emp inserts.');
        --VIEW_INSERT_TEMPLATE_3
        select distinct emp_uri into s_emp_uri 
        from saas_emp_view where empno = :new.empno;
     -- From the above query, if the emp doesn't exist, an exception is thrown, which means this is a new emp. The new emp is inserted using the exception code at the bottom of this block.
     -- If no exception is thrown, do a query to get the attribute values that might need to be updated.
        select distinct '', ename, job, hiredate, salary, comm, training--VIEW_INSERT_TEMPLATE_5 
        into v_dummy, v_ename, v_job, v_hiredate, v_salary, v_comm, v_training--VIEW_INSERT_TEMPLATE_6
        from saas_emp_view where empno = :new.empno;
        --VIEW_INSERT_TEMPLATE_4
        -- Update ename
        IF (v_ename is null and :new.ename is not null) or (:new.ename is null and v_ename is not null) or v_ename != :new.ename then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'ename', v_ename, :new.ename, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:ename  "' || v_ename || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:ename  "' || nvl(:new.ename, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update job
        IF (v_job is null and :new.job is not null) or (:new.job is null and v_job is not null) or v_job != :new.job then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'job', v_job, :new.job, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:job  "' || v_job || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:job  "' || nvl(:new.job, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update hiredate
        IF (v_hiredate is null and :new.hiredate is not null) or (:new.hiredate is null and v_hiredate is not null) or v_hiredate != :new.hiredate then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'hiredate', v_hiredate, :new.hiredate, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:hiredate  "' || v_hiredate || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:hiredate  "' || nvl(:new.hiredate, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update salary
        IF (v_salary is null and :new.salary is not null) or (:new.salary is null and v_salary is not null) or v_salary != :new.salary then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'salary', v_salary, :new.salary, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:salary  "' || v_salary || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:salary  "' || nvl(:new.salary, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update comm
        IF (v_comm is null and :new.comm is not null) or (:new.comm is null and v_comm is not null) or v_comm != :new.comm then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'comm', v_comm, :new.comm, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:comm  "' || v_comm || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:comm  "' || nvl(:new.comm, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        -- Update training
        IF (v_training is null and :new.training is not null) or (:new.training is null and v_training is not null) or v_training != :new.training then
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) values (audit_id_seq.nextval, 'Emp', 'training', v_training, :new.training, SYSTIMESTAMP, user);
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            DELETE DATA { 
                <' || s_emp_uri || '> saas:training  "' || v_training || '".
            };
            INSERT DATA { 
                <' || s_emp_uri || '> saas:training  "' || nvl(:new.training, '') || '".
            }
            ', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
        END IF;
        --VIEW_INSERT_TEMPLATE_7
          EXCEPTION
          WHEN NO_DATA_FOUND THEN
            v_emp_uri := 'saas:Emp' || '_' || :new.empno;
            insert into audit_table(id, type, attribute, old_value, new_value, update_time, updating_user_id) 
                          values (audit_id_seq.nextval, 'Emp', 'insert', '', v_emp_uri, SYSTIMESTAMP, user);
         -- Add new emp.
            sem_apis.update_model(model_param_handler.get_model_name, 
           'PREFIX saas: <http://SaaS.org/>
            INSERT DATA { 
                ' || v_emp_uri || ' a saas:Emp .
                ' || v_emp_uri || ' saas:emp_id "' || v_emp_id || '" .
                ' || v_emp_uri || ' saas:empno "' || :new.empno || '" .
                ' || v_emp_uri || ' saas:ename "' || :new.ename || '" .
                ' || v_emp_uri || ' saas:job "' || :new.job || '" .
                ' || v_emp_uri || ' saas:hiredate "' || :new.hiredate || '" .
                ' || v_emp_uri || ' saas:salary "' || :new.salary || '" .
                ' || v_emp_uri || ' saas:comm "' || :new.comm || '" .
                ' || v_emp_uri || ' saas:training "' || :new.training || '" .
                #VIEW_INSERT_TEMPLATE_9
            }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork');
    END;
--Insert more here
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
