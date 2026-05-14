public class StudentController {

    // Holds the new student data entered in the form
    public Student__c newStudent { get; set; }

    // Holds the student being edited
    public Student__c editStudent { get; set; }

    // Flag to show/hide edit form
    public Boolean isEditing { get; set; }

    // Constructor — runs when page loads
    public StudentController() {
        newStudent = new Student__c();
        editStudent = new Student__c();
        isEditing = false;
    }

    // ─── READ: Fetch all student records from database ───
    public List<Student__c> getStudents() {
        return [
            SELECT Id, Name, Roll_No__c, Class__c, Mobile_No__c
            FROM Student__c
            ORDER BY Roll_No__c ASC
        ];
    }

    // ─── CREATE: Save new student to database ───
    public PageReference saveStudent() {
        try {
            insert newStudent;
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Student "' + newStudent.Name + '" added successfully!'
            ));
            newStudent = new Student__c(); // Reset form
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Error: ' + e.getMessage()
            ));
        }
        return null;
    }

    // ─── EDIT: Load selected student into edit form ───
    public PageReference loadEdit() {
        String studentId = ApexPages.currentPage().getParameters().get('editId');
        editStudent = [
            SELECT Id, Name, Roll_No__c, Class__c, Mobile_No__c
            FROM Student__c
            WHERE Id = :studentId
            LIMIT 1
        ];
        isEditing = true;
        return null;
    }

    // ─── UPDATE: Save edited student record ───
    public PageReference updateStudent() {
        try {
            update editStudent;
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Student updated successfully!'
            ));
            isEditing = false;
            editStudent = new Student__c();
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Error: ' + e.getMessage()
            ));
        }
        return null;
    }

    // ─── DELETE: Remove student record from database ───
    public PageReference deleteStudent() {
        String studentId = ApexPages.currentPage().getParameters().get('deleteId');
        try {
            Student__c toDelete = [SELECT Id FROM Student__c WHERE Id = :studentId LIMIT 1];
            delete toDelete;
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.CONFIRM,
                'Student deleted successfully!'
            ));
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(
                ApexPages.Severity.ERROR,
                'Error: ' + e.getMessage()
            ));
        }
        return null;
    }

    // ─── Cancel edit mode ───
    public PageReference cancelEdit() {
        isEditing = false;
        editStudent = new Student__c();
        return null;
    }
}
