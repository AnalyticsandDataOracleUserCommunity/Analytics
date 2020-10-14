CREATE OR REPLACE FORCE EDITIONABLE VIEW SaaS_EMP_RULE AS 
SELECT /*+ dynamic_sampling(6)  */  distinct
      emp_uri 
    --VIEW_SELECT_TEMPLATE_1
FROM TABLE(SEM_MATCH(
   'PREFIX  rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
    PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
    PREFIX  owl: <http://www.w3.org/2002/07/owl#>
    PREFIX  xsd: <http://www.w3.org/2001/XMLSchema#>
    PREFIX   dc: <http://purl.org/dc/elements/1.1/>
    PREFIX foaf: <http://xmlns.com/foaf/0.1/>
    PREFIX saas: <http://SaaS.org/>
        
    SELECT ?emp_uri  #VIEW_SELECT_TEMPLATE_2
    WHERE 
      {
            BIND(CONCAT("Rules", "") AS ?emp_uri)
            #VIEW_SELECT_TEMPLATE_3
      }',
    SEM_MODELS(model_param_handler.get_model_name),
    null, 
    null,
    null,
    null,
    ' PLUS_RDFT=VC DO_UNESCAPE=T ALLOW_DUP=T ', null, null, 'rdfuser', 'mynetwork'));
                     
CREATE OR REPLACE EDITIONABLE TRIGGER SaaS_EMP_RULE_TRIGGER_UPDATE 
     INSTEAD OF update ON SaaS_EMP_RULE
     FOR EACH ROW
BEGIN
    sem_apis.update_model(model_param_handler.get_model_name, 
       'PREFIX saas: <http://SaaS.org/>
        DELETE { ?dept_uri saas:award ?award . }
        INSERT { ?dept_uri saas:award ?eligable . }
        WHERE 
        {   { select distinct ?dept_uri ?award ?eligable WHERE {
            # Get the dept for each emp.
            ?emp_uri  a               saas:Emp .
            ?emp_uri  saas:empDeptEVA ?dept_uri .
            ?dept_uri saas:deptno     ?deptno .
            ?dept_uri saas:award      ?award .
            MINUS # Remove depts that have at lease one emp who is not trained. 
            { SELECT ?dept_uri 
              WHERE 
              {    
                    ?emp_uri a               saas:Emp .
                    ?emp_uri saas:empDeptEVA ?dept_uri .
                    OPTIONAL { ?emp_uri saas:training ?training. } 
                    FILTER(?training = "")
              }
            }
            BIND(CONCAT("Department ", ?deptno, " is eligable for     an award") AS ?eligable)
            } }
        }', options=>' AUTOCOMMIT=F ', network_owner=>'rdfuser', network_name=>'mynetwork') ;
END;
/
/*
select * from SaaS_EMP_RULE;
*/
