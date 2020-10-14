package oracle.apps.empdept.protectedModel.applicationModule;

import java.sql.Timestamp;
import java.util.Collection;

import oracle.apps.empdept.view.DepartmentVOImpl;
import oracle.apps.empdept.view.DepartmentVORowImpl;
import oracle.apps.empdept.view.EmpDeptVOImpl;
import oracle.apps.empdept.view.EmpDeptVORowImpl;
import oracle.apps.empdept.view.EmployeeVOImpl;
import oracle.apps.empdept.view.EmployeeVORowImpl;
import oracle.apps.empdept.domain.Department;
import oracle.apps.empdept.domain.Employee;
import oracle.apps.fnd.applcore.oaext.model.OAApplicationModuleImpl;
import oracle.jbo.RowSet;
import oracle.jbo.ViewCriteria;

/**
 * Employee-Department Application Module
 */
public class EmpDeptAMImpl extends OAApplicationModuleImpl {

    /**
     * Container's getter for EmptDeptVO.
     * @return EmployeeVO
     */
    public EmpDeptVOImpl getEmpDeptVO() {
        return (EmpDeptVOImpl) findViewObject("EmpDeptVO");
    }

    /**
     * Container's getter for EmployeeVO.
     * @return EmployeeVO
     */
    public EmployeeVOImpl getEmployeeVO() {
        return (EmployeeVOImpl) findViewObject("EmployeeVO");
    }

    /**
     * Container's getter for DepartmentVO.
     * @return EmployeeVO
     */
    public DepartmentVOImpl getDepartmentVO() {
        return (DepartmentVOImpl) findViewObject("DepartmentVO");
    }

    /**
     * Find a specific employee, by employee number
     */
    public Employee findEmployee(Integer empNo) {

        CachedMapper mapper = new CachedMapper();
        loadEmployeesIntoCache(empNo, mapper);
        Integer deptNo = mapper.getDeptNo(empNo);
        if (deptNo != null) {
            // if employee has a dept, load it's data
            loadDepartmentsIntoCache(deptNo, mapper);
        }
        mapper.finalize();  // apply business logic
        return mapper.getEmployee(empNo);

    }


    /**
     * Find a specific department, by department number
     */
    public Department findDepartment(Integer deptNo) {

        CachedMapper mapper = new CachedMapper();
        loadDepartmentsIntoCache(deptNo, mapper);
        mapper.finalize();  // apply business logic
        Department dept = mapper.getDepartment(deptNo);

        return dept;

    }

    /**
     * Load all employees
     */
    public Collection<Employee> loadAllEmployees() {

        CachedMapper mapper = new CachedMapper();
        loadEmployeesIntoCache(null, mapper);
        mapper.finalize();  // apply business logic
        return mapper.getEmployees();

    }

    /**
     * Load all departments
     */
    public Collection<Department> loadAllDepartments() {

        CachedMapper mapper = new CachedMapper();
        loadEmployeesIntoCache(null, mapper);
        mapper.finalize();  // apply business logic
        return mapper.getDepartments();

    }

    /**
     * Save department to db
     * @param dept
     */
    public void saveDepartment(Department dept) {
        DepartmentVORowImpl row = (DepartmentVORowImpl) getDepartmentVO().createRow();
        if (dept.getDepartmentNo() != null)
            row.setDeptno(dept.getDepartmentNo());
        if (dept.getName() != null)
            row.setDname(dept.getName());
        if (dept.getLocation() != null)
            row.setLoc(dept.getLocation());
        getDBTransaction().commit();
    }

    /**
     * Save eployee to db
     * @param emp
     */
    public void saveEmployee(Employee emp) {
        EmployeeVORowImpl row = (EmployeeVORowImpl) getEmployeeVO().createRow();
        if (emp.getEmployeeNo() != null)
            row.setEmpno(emp.getEmployeeNo());
        if (emp.getName() != null)
            row.setEname(emp.getName());
        if (emp.getDepartment() != null)
            row.setDeptno(emp.getDepartment().getDepartmentNo());
        if (emp.getComm() != null)
            row.setComm(emp.getComm());
        if (emp.getSalary() != null)
            row.setSal(emp.getSalary());
        if (emp.getHireDate() != null)
            row.setHiredate((Timestamp) emp.getHireDate());
        if (emp.getJob() != null)
            row.setJob(emp.getJob());
        if (emp.getManager() != null)
            row.setMgr(emp.getManager());
        getDBTransaction().commit();
    }

    /**
     * Load employee data into the mapper cache
     */
    private void loadDepartmentsIntoCache(Integer deptNo, CachedMapper mapper) {

        EmpDeptVOImpl vo = getEmpDeptVO();
        RowSet rs = vo.getDefaultRowSet();

        if (deptNo != null) {
            // apply 'DEPT_NO = deptNo' filter
            ViewCriteria vc = vo.getViewCriteria(EmpDeptVORowImpl.VC_SpecifyDeptVC);
            rs.ensureVariableManager().setVariableValue(EmpDeptVORowImpl.VAR_Deptno, deptNo);
            vo.appendViewCriteria(vc);
        }

        // execute query
        vo.executeQuery();
        // read row data from query into mapper
        mapper.readRowDataIntoCache(vo);

    }

    /**
     * Load employees from DB into mapper cache:
     *    single employee if empNo is provided
     */
    private void loadEmployeesIntoCache(Integer empNo, CachedMapper mapper) {

        EmpDeptVOImpl vo = getEmpDeptVO();
        RowSet rs = vo.getDefaultRowSet();

        if (empNo != null) {
            // apply 'EMP_NO = empNo' filter
            ViewCriteria vc = vo.getViewCriteria(EmpDeptVORowImpl.VC_SpecifyEmpVC);
            rs.ensureVariableManager().setVariableValue(EmpDeptVORowImpl.VAR_Empno, empNo);
            vo.appendViewCriteria(vc);
        }

        // execute query
        String q = vo.getQuery();
        vo.executeQuery();
        // read row data from query into mapper
        mapper.readRowDataIntoCache(vo);

    }

}
