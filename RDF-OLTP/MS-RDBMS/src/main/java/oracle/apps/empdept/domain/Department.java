package oracle.apps.empdept.domain;

public class Department {

    private Integer departmentNo;
    private String name;
    private String location;
    private Boolean award;

    public Integer getDepartmentNo() {
        return departmentNo;
    }

    public void setDepartmentNo(Integer departmentNo) {
        this.departmentNo = departmentNo;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public Boolean hasAward() { return award; }

    public void setAward(Boolean award) { this.award = award; }

}
