package oracle.apps.empdept.protectedModel.applicationModule;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import oracle.apps.empdept.view.EmpDeptVOImpl;
import oracle.apps.empdept.view.EmpDeptVORowImpl;
import oracle.apps.empdept.domain.Department;
import oracle.apps.empdept.domain.Employee;


/**
 *  A mapper to domain objects, backed by a cache of ids (nums) to object
 */
public class CachedMapper {

    // map empNo to Employee
    private Map<Integer, Employee> mapEmpNoToEmployee = new HashMap<Integer, Employee>();
    // map deptNo to Department
    private Map<Integer, Department> mapDeptNoToDepartment = new HashMap();
    // map empNo to deptNo of the employees department
    private Map<Integer, Integer> mapEmpNoToDeptNo = new HashMap();

    /**
     * Put row data into cache
     *
     * @param row
     * @return
     */
    void readRowDataIntoCache(EmpDeptVOImpl vo) {
        while (vo.hasNext()) {
            EmpDeptVORowImpl row = (EmpDeptVORowImpl) vo.next();
            Integer empNo = row.getEmpno();
            Employee emp = pullEmpDataThroughCache(row, empNo);
            Department dept = pullDeptDataThroughCache(row, empNo);
        }
    }

    /**
     * Pull just employee data through cache
     *
     * @param row
     * @return
     */
    private Employee pullEmpDataThroughCache(EmpDeptVORowImpl row, Integer empNo) {
        // pull employee from cache
        Employee emp = mapEmpNoToEmployee.get(empNo);
        // if not in cache, map and put in
        if (emp == null) {
            // map to domain object
            emp = mapToEmployee(row);
            // put in cache
            mapEmpNoToEmployee.put(empNo, emp);
        }
        return emp;
    }

    /**
     * Pull just department data through cache
     *
     * @param row
     * @return
     */
    private Department pullDeptDataThroughCache(EmpDeptVORowImpl row, Integer deptNo) {
        // pull department from cache
        Department dept = mapDeptNoToDepartment.get(deptNo);
        // if not in cache, map and put in
        if (dept == null) {
            // map to domain object
            dept = mapToDepartment(row);
            // put in cache
            mapDeptNoToDepartment.put(deptNo, dept);
        }
        return dept;
    }

    /**
     * Map to employee domain object
     * @return
     */
    private Employee mapToEmployee(EmpDeptVORowImpl row) {

        Employee employee = new Employee();
        employee.setEmployeeNo(row.getEmpno());
        employee.setName(row.getEname());
        employee.setJob(row.getJob());
        employee.setManager(row.getMgr());
        employee.setHireDate(row.getHiredate());
        employee.setSalary(row.getSal());
        employee.setComm(row.getComm());
        employee.setTraining(row.getTraining() != null && row.getTraining() == 1);
        // cache deptNo for employee
        mapEmpNoToDeptNo.put(employee.getEmployeeNo(), row.getDeptno());
        return employee;

    }

    /**
     * Map to department domain object
     * @param row
     * @return
     */
    private Department mapToDepartment(EmpDeptVORowImpl row) {
        Department dept = new Department();
        dept.setDepartmentNo(row.getDeptno());
        dept.setName(row.getDname());
        dept.setLocation(row.getLoc());
        return dept;
    }

    /**
     * Get employee from the cache
     * @param empNo
     * @return
     */
    Employee getEmployee(Integer empNo) {
        return mapEmpNoToEmployee.get(empNo);
    }

    /**
     * Get department from the cache
     * @param deptNo
     * @return
     */
    Department getDepartment(Integer deptNo) {
        return mapDeptNoToDepartment.get(deptNo);
    }

    /**
     * Finalize the mapper, by performing any business logic over the
     * cached domain objects
     */
    public void finalize() {

        // materialize the object links:  iterate over employees, and for each employee,
        // set the department link to the cached department object
        for (Integer empNo : mapEmpNoToEmployee.keySet()) {
            Integer deptNo = mapEmpNoToDeptNo.get(empNo);
            Employee emp = mapEmpNoToEmployee.get(empNo);
            Department dept = mapDeptNoToDepartment.get(deptNo);
            emp.setDepartment(dept);
        }

        // For given employee and her department, calculate the department award
        //   based on the employees training and the departments existing award value
        for (Employee emp : mapEmpNoToEmployee.values()) {
            Department dept = emp.getDepartment();
            boolean training = emp.hasTraining();
            // dept has award until at least one employee without training
            boolean award = (dept.hasAward() == null) || dept.hasAward();
            dept.setAward(award && training);
        }

    }

    /**
     * Get the department number for this employee number
     * @param empNo
     * @return
     */
    public Integer getDeptNo(Integer empNo) {
        return mapEmpNoToDeptNo.get(empNo);
    }

    /**
     * Get all the employees loaded
     * @return
     */
    public Collection<Employee> getEmployees() {
        return mapEmpNoToEmployee.values();
    }

    /**
     * Get all the deparments loaded
     * @return
     */
    public Collection<Department> getDepartments() {
        return mapDeptNoToDepartment.values();
    }
}

