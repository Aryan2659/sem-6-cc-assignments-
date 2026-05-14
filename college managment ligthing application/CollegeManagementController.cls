public with sharing class CollegeManagementController {

    // ════════════════════════════════════
    //   STUDENT METHODS
    // ════════════════════════════════════

    @AuraEnabled
    public static Boolean saveStudent(
        String studentName,
        Integer rollNo,
        Decimal marks,
        String email
    ) {
        try {
            Student__c s  = new Student__c();
            s.Name        = studentName;
            s.Roll_No__c  = rollNo;
            s.Marks__c    = marks;
            s.Email__c    = email;
            insert s;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Student save failed: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Student__c> getStudents() {
        return [
            SELECT Id, Name, Roll_No__c, Marks__c, Email__c
            FROM Student__c
            ORDER BY Roll_No__c ASC
        ];
    }

    // ════════════════════════════════════
    //   FACULTY METHODS
    // ════════════════════════════════════

    @AuraEnabled
    public static Boolean saveFaculty(
        String facultyName,
        Integer facultyId,
        Decimal salary,
        String department,
        String joiningDate
    ) {
        try {
            Faculty__c f      = new Faculty__c();
            f.Name            = facultyName;
            f.Faculty_ID__c   = facultyId;
            f.Salary__c       = salary;
            f.Department__c   = department;
            f.Joining_Date__c = Date.valueOf(joiningDate);
            insert f;
            return true;
        } catch (Exception e) {
            throw new AuraHandledException('Faculty save failed: ' + e.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Faculty__c> getFaculty() {
        return [
            SELECT Id, Name, Faculty_ID__c, Salary__c, Department__c, Joining_Date__c
            FROM Faculty__c
            ORDER BY Faculty_ID__c ASC
        ];
    }

    @AuraEnabled
    public static Boolean isFacultyIdUnique(Integer facultyId) {
        List<Faculty__c> existing = [
            SELECT Id FROM Faculty__c
            WHERE Faculty_ID__c = :facultyId
            LIMIT 1
        ];
        return existing.isEmpty();
    }
}
