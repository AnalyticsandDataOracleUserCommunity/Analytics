package oracle.apps.empdept.repo;

import java.util.Collection;

import oracle.apps.empdept.domain.Employee;
import oracle.apps.empdept.protectedModel.applicationModule.EmpDeptAMImpl;
import oracle.jbo.client.Configuration;

public class EmployeeRepository {

    public static final EmployeeRepository INSTANCE = new EmployeeRepository();

    public static final String AM_NAME = "oracle.apps.empdept.protectedModel.applicationModule.EmpDeptAM";
    public static final String CONFIG_NAME = "EmpDeptAMLocal";

    /**
     * Get ADF application manager
     * @return
     */
    public EmpDeptAMImpl getAM() {
        return (EmpDeptAMImpl) Configuration.createRootApplicationModule(AM_NAME, CONFIG_NAME);
    }

    /**
     * Find employee by number
     * @param employeeNumber
     * @return
     */
    public Employee find(Integer employeeNumber) {
        return getAM().findEmployee(employeeNumber);
    }

    /**
     * load all employees
     * @return
     */
    public Collection<Employee> loadAllEmployees() {
        return getAM().loadAllEmployees();
    }

    /**
     * Save employee to db:  creates if not present, or updates if present
     * @param employee
     */
    public void save(Employee employee) {
        getAM().saveEmployee(employee);
    }

}
