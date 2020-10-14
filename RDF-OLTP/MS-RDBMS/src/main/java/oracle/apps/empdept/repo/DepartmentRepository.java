package oracle.apps.empdept.repo;

import java.util.Collection;

import oracle.apps.empdept.domain.Department;
import oracle.apps.empdept.protectedModel.applicationModule.EmpDeptAMImpl;
import oracle.jbo.client.Configuration;

public class DepartmentRepository {

    public static final String AM_NAME = "oracle.apps.empdept.protectedModel.applicationModule.EmpDeptAM";
    public static final String CONFIG_NAME = "EmpDeptAMLocal";

    public static final DepartmentRepository INSTANCE = new DepartmentRepository();

    /**
     * Get ADF application manager
     * @return
     */
    public EmpDeptAMImpl getAM() {
        return (EmpDeptAMImpl) Configuration.createRootApplicationModule(AM_NAME, CONFIG_NAME);
    }

    /**
     * Find department by number
     *
     * @param departmentNumber
     * @return
     */
    public Department find(Integer departmentNumber) {
        return getAM().findDepartment(departmentNumber);
    }

    /**
     * Load all departments
     * @return
     */
    public Collection<Department> loadAllDepartments() {
        return getAM().loadAllDepartments();
    }

    /**
     * Save department to db
     * @param department
     */
    public void save(Department department) {
        getAM().saveDepartment(department);
    }

}
