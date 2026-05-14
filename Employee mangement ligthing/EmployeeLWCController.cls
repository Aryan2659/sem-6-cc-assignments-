public with sharing class EmployeeLWCController {

    // ─── Save a new employee record ───
    @AuraEnabled
    public static Boolean saveEmployee(
        String empName,
        Integer empId,
        Decimal salary,
        String email,
        String department,
        String joiningDate
    ) {
        try {
            Employee_LWC__c emp = new Employee_LWC__c();
            emp.Name            = empName;
            emp.Employee_ID__c  = empId;
            emp.Salary__c       = salary;
            emp.Email__c        = email;
            emp.Department__c   = department;
            emp.Joining_Date__c = Date.valueOf(joiningDate);

            insert emp;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Save failed: ' + e.getMessage());
        }
    }

    // ─── Get all employee records ───
    @AuraEnabled(cacheable=true)
    public static List<Employee_LWC__c> getEmployees() {
        return [
            SELECT Id, Name, Employee_ID__c, Salary__c,
                   Email__c, Department__c, Joining_Date__c
            FROM Employee_LWC__c
            ORDER BY Employee_ID__c ASC
        ];
    }

    // ─── Check if Employee ID is unique ───
    @AuraEnabled
    public static Boolean isEmpIdUnique(Integer empId) {
        List<Employee_LWC__c> existing = [
            SELECT Id FROM Employee_LWC__c
            WHERE Employee_ID__c = :empId
            LIMIT 1
        ];
        return existing.isEmpty(); // true = unique, false = already exists
    }
}
