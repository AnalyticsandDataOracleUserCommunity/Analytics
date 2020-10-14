package oracle.apps.empdept.domain;

import java.util.Date;

public class Employee {

    /**
     *         EmpNo,
     *         EName,
     *         Job,
     *         Mgr,
     *         HireDate,
     *         Sal,
     *         Comm,
     *         DeptNo,
     *         Training;
     */
    private Integer employeeNo;
    private String name;
    private String job;
    private String manager;
    private Date hireDate;
    private Float salary;
    private Float comm;
    private Department department;
    private boolean training;

    public boolean hasTraining() {
        return training;
    }

    public void setTraining(boolean training) {
        this.training = training;
    }

    public Integer getEmployeeNo() {
        return employeeNo;
    }

    public void setEmployeeNo(Integer employeeNo) {
        this.employeeNo = employeeNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getJob() {
        return job;
    }

    public void setJob(String job) {
        this.job = job;
    }

    public String getManager() {
        return manager;
    }

    public void setManager(String manager) {
        this.manager = manager;
    }

    public Date getHireDate() {
        return hireDate;
    }

    public void setHireDate(Date hireDate) {
        this.hireDate = hireDate;
    }

    public Float getSalary() {
        return salary;
    }

    public void setSalary(Float salary) {
        this.salary = salary;
    }

    public Float getComm() {
        return comm;
    }

    public void setComm(Float comm) {
        this.comm = comm;
    }

    public Department getDepartment() {
        return department;
    }

    public void setDepartment(Department department) {
        this.department = department;
    }
}
