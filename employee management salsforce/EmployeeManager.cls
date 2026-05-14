/**
 * EmployeeManager.cls
 * Menu-driven Employee Management System
 * Manages: Emp ID, Emp Name, Email, Birth Date, Department
 * Run via: Developer Console → Execute Anonymous
 */
public class EmployeeManager {

    // ─────────────────────────────────────────
    //  CREATE — Add a new employee
    // ─────────────────────────────────────────
    public static void addEmployee(
        String empName,
        String email,
        Date birthDate,
        String department
    ) {
        try {
            Employee__c emp = new Employee__c();
            emp.Name        = empName;
            emp.Email__c    = email;
            emp.Birth_Date__c  = birthDate;
            emp.Department__c  = department;

            insert emp;
            System.debug('✅ Employee Added Successfully!');
            System.debug('   Name       : ' + emp.Name);
            System.debug('   Email      : ' + emp.Email__c);
            System.debug('   Birth Date : ' + emp.Birth_Date__c);
            System.debug('   Department : ' + emp.Department__c);
            System.debug('   Record ID  : ' + emp.Id);
        } catch (Exception e) {
            System.debug('❌ Error adding employee: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────
    //  READ — View all employees
    // ─────────────────────────────────────────
    public static void viewAllEmployees() {
        List<Employee__c> empList = [
            SELECT Id, Name, Email__c, Birth_Date__c, Department__c
            FROM Employee__c
            ORDER BY Name ASC
        ];

        if (empList.isEmpty()) {
            System.debug('⚠️  No employee records found.');
            return;
        }

        System.debug('========================================================');
        System.debug('               EMPLOYEE RECORDS                        ');
        System.debug('========================================================');

        for (Employee__c e : empList) {
            System.debug('----------------------------');
            System.debug('ID         : ' + e.Id);
            System.debug('Name       : ' + e.Name);
            System.debug('Email      : ' + e.Email__c);
            System.debug('Birth Date : ' + e.Birth_Date__c);
            System.debug('Department : ' + e.Department__c);
        }

        System.debug('========================================================');
        System.debug('Total Records: ' + empList.size());
    }

    // ─────────────────────────────────────────
    //  READ — Search employee by name
    // ─────────────────────────────────────────
    public static void searchEmployee(String searchName) {
        List<Employee__c> results = [
            SELECT Id, Name, Email__c, Birth_Date__c, Department__c
            FROM Employee__c
            WHERE Name LIKE :('%' + searchName + '%')
        ];

        if (results.isEmpty()) {
            System.debug('⚠️  No employee found with name: ' + searchName);
            return;
        }

        System.debug('🔍 Search Results for "' + searchName + '":');
        for (Employee__c e : results) {
            System.debug('----------------------------');
            System.debug('ID         : ' + e.Id);
            System.debug('Name       : ' + e.Name);
            System.debug('Email      : ' + e.Email__c);
            System.debug('Birth Date : ' + e.Birth_Date__c);
            System.debug('Department : ' + e.Department__c);
        }
    }

    // ─────────────────────────────────────────
    //  UPDATE — Update employee by Record ID
    // ─────────────────────────────────────────
    public static void updateEmployee(
        String recordId,
        String newName,
        String newEmail,
        String newDepartment
    ) {
        try {
            Employee__c emp = [
                SELECT Id, Name, Email__c, Department__c
                FROM Employee__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            emp.Name          = newName;
            emp.Email__c      = newEmail;
            emp.Department__c = newDepartment;

            update emp;
            System.debug('✅ Employee Updated Successfully!');
            System.debug('   New Name       : ' + emp.Name);
            System.debug('   New Email      : ' + emp.Email__c);
            System.debug('   New Department : ' + emp.Department__c);
        } catch (Exception e) {
            System.debug('❌ Error updating employee: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────
    //  DELETE — Delete employee by Record ID
    // ─────────────────────────────────────────
    public static void deleteEmployee(String recordId) {
        try {
            Employee__c emp = [
                SELECT Id, Name
                FROM Employee__c
                WHERE Id = :recordId
                LIMIT 1
            ];

            String empName = emp.Name;
            delete emp;
            System.debug('✅ Employee "' + empName + '" deleted successfully.');
        } catch (Exception e) {
            System.debug('❌ Error deleting employee: ' + e.getMessage());
        }
    }

    // ─────────────────────────────────────────
    //  DEMO — Run all operations (for viva demo)
    // ─────────────────────────────────────────
    public static void runDemo() {
        System.debug('');
        System.debug('╔══════════════════════════════════════════╗');
        System.debug('║   EMPLOYEE MANAGEMENT SYSTEM - DEMO      ║');
        System.debug('╚══════════════════════════════════════════╝');

        System.debug('');
        System.debug('── MENU ──────────────────────────────────');
        System.debug('1. Add Employee');
        System.debug('2. View All Employees');
        System.debug('3. Search Employee');
        System.debug('4. Update Employee');
        System.debug('5. Delete Employee');
        System.debug('─────────────────────────────────────────');

        // 1. Add employees
        System.debug('');
        System.debug('[ OPTION 1 ] Adding Employees...');
        addEmployee('Alice Johnson',  'alice@company.com',  Date.newInstance(1995, 3, 15),  'Engineering');
        addEmployee('Bob Smith',      'bob@company.com',    Date.newInstance(1990, 7, 22),  'Marketing');
        addEmployee('Carol Williams', 'carol@company.com',  Date.newInstance(1998, 11, 5),  'HR');

        // 2. View all
        System.debug('');
        System.debug('[ OPTION 2 ] Viewing All Employees...');
        viewAllEmployees();

        // 3. Search
        System.debug('');
        System.debug('[ OPTION 3 ] Searching for "Alice"...');
        searchEmployee('Alice');

        System.debug('');
        System.debug('✅ Demo Complete! Use individual methods for specific operations.');
    }
}
