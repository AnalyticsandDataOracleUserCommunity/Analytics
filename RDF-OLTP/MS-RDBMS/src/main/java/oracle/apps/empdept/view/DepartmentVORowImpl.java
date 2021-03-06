package oracle.apps.empdept.view;

import oracle.apps.fnd.applcore.oaext.model.OAViewRowImpl;

// ---------------------------------------------------------------------
// ---    File generated by Oracle ADF Business Components Design Time.
// ---    2020-09-21T18:46:08.508
// ---    Custom code may be added to this class.
// ---    Warning: Do not modify method signatures of generated methods.
// ---------------------------------------------------------------------

public class DepartmentVORowImpl extends OAViewRowImpl {

    public enum AttributesEnum {
        Deptno,
        Dname,
        Loc;

        private static AttributesEnum[] vals = null;
        private static final int firstIndex = 0;

        public int index() {
            return AttributesEnum.firstIndex() + ordinal();
        }

        public static final int firstIndex() {
            return firstIndex;
        }

        public static int count() {
            return AttributesEnum.firstIndex() + AttributesEnum.staticValues().length;
        }

        public static final AttributesEnum[] staticValues() {
            if (vals == null) {
                vals = AttributesEnum.values();
            }
            return vals;
        }
    }

    public static final int DEPTNO = AttributesEnum.Deptno.index();
    public static final int DNAME = AttributesEnum.Dname.index();
    public static final int LOC = AttributesEnum.Loc.index();

    public static final String VC_FindByDeptnoVC = "FindByDeptnoVC";

    public static final String VAR_Deptno = "Deptno";

    /**
     * This is the default constructor (do not remove).
     */
    public DepartmentVORowImpl() {
    }

    /**
     * Gets the attribute value for DEPTNO using the alias name Deptno.
     * @return the DEPTNO
     */
    public Integer getDeptno() {
        return (Integer) getAttributeInternal(DEPTNO);
    }

    /**
     * Sets <code>value</code> as attribute value for DEPTNO using the alias name Deptno.
     * @param value value to set the DEPTNO
     */
    public void setDeptno(Integer value) {
        setAttributeInternal(DEPTNO, value);
    }

    /**
     * Gets the attribute value for DNAME using the alias name Dname.
     * @return the DNAME
     */
    public String getDname() {
        return (String) getAttributeInternal(DNAME);
    }

    /**
     * Sets <code>value</code> as attribute value for DNAME using the alias name Dname.
     * @param value value to set the DNAME
     */
    public void setDname(String value) {
        setAttributeInternal(DNAME, value);
    }

    /**
     * Gets the attribute value for LOC using the alias name Loc.
     * @return the LOC
     */
    public String getLoc() {
        return (String) getAttributeInternal(LOC);
    }

    /**
     * Sets <code>value</code> as attribute value for LOC using the alias name Loc.
     * @param value value to set the LOC
     */
    public void setLoc(String value) {
        setAttributeInternal(LOC, value);
    }


}
