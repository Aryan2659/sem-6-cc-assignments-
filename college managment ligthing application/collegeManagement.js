import { LightningElement, track } from 'lwc';
import saveStudent      from '@salesforce/apex/CollegeManagementController.saveStudent';
import getStudents      from '@salesforce/apex/CollegeManagementController.getStudents';
import saveFaculty      from '@salesforce/apex/CollegeManagementController.saveFaculty';
import getFaculty       from '@salesforce/apex/CollegeManagementController.getFaculty';
import isFacultyIdUnique from '@salesforce/apex/CollegeManagementController.isFacultyIdUnique';

export default class CollegeManagement extends LightningElement {

    // ── Student form ──
    @track newStudent = { name: '', rollNo: '', marks: '', email: '' };
    @track studentErrors = {};
    @track students = [];

    // ── Faculty form ──
    @track newFaculty = { name: '', facultyId: '', salary: '', department: '', joiningDate: '' };
    @track facultyErrors = {};
    @track facultyList = [];

    // ── Shared ──
    @track successMessage = '';

    // ── Department options ──
    get departmentOptions() {
        return [
            { label: 'Computer Science',  value: 'Computer Science'  },
            { label: 'Information Tech',  value: 'Information Tech'  },
            { label: 'Electronics',       value: 'Electronics'       },
            { label: 'Mechanical',        value: 'Mechanical'        },
            { label: 'Civil',             value: 'Civil'             },
            { label: 'Mathematics',       value: 'Mathematics'       },
            { label: 'Physics',           value: 'Physics'           }
        ];
    }

    connectedCallback() {
        this.loadStudents();
        this.loadFaculty();
    }

    loadStudents() {
        getStudents()
            .then(result => { this.students = result; })
            .catch(error => console.error('Error:', error));
    }

    loadFaculty() {
        getFaculty()
            .then(result => { this.facultyList = result; })
            .catch(error => console.error('Error:', error));
    }

    // ════════════════════════════════════════
    //   STUDENT HANDLERS
    // ════════════════════════════════════════
    handleStudentChange(event) {
        const field = event.target.dataset.field;
        this.newStudent = { ...this.newStudent, [field]: event.target.value };
        if (this.studentErrors[field]) {
            this.studentErrors = { ...this.studentErrors, [field]: null };
        }
    }

    validateStudent() {
        let errs = {};
        let isValid = true;

        // 1. Name — cannot be blank
        if (!this.newStudent.name || this.newStudent.name.trim() === '') {
            errs.name = 'Student name cannot be blank.';
            isValid = false;
        }

        // 2. Roll Number — must be > 0
        const rollNo = Number(this.newStudent.rollNo);
        if (!this.newStudent.rollNo || isNaN(rollNo)) {
            errs.rollNo = 'Roll number is required.';
            isValid = false;
        } else if (rollNo <= 0) {
            errs.rollNo = 'Roll number must be greater than 0.';
            isValid = false;
        }

        // 3. Marks — between 0 and 100
        const marks = Number(this.newStudent.marks);
        if (this.newStudent.marks === '' || isNaN(marks)) {
            errs.marks = 'Marks are required.';
            isValid = false;
        } else if (marks < 0 || marks > 100) {
            errs.marks = 'Marks must be between 0 and 100.';
            isValid = false;
        }

        // 4. Email — must contain @ symbol
        if (!this.newStudent.email || this.newStudent.email.trim() === '') {
            errs.email = 'Email address is required.';
            isValid = false;
        } else if (!this.newStudent.email.includes('@')) {
            errs.email = 'Email must contain the @ symbol.';
            isValid = false;
        }

        this.studentErrors = errs;
        return isValid;
    }

    handleSaveStudent() {
        this.successMessage = '';
        if (!this.validateStudent()) return;

        saveStudent({
            studentName : this.newStudent.name.trim(),
            rollNo      : Number(this.newStudent.rollNo),
            marks       : Number(this.newStudent.marks),
            email       : this.newStudent.email.trim()
        })
        .then(() => {
            this.successMessage = '✅ Student "' + this.newStudent.name + '" saved successfully!';
            this.handleResetStudent();
            this.loadStudents();
        })
        .catch(error => {
            this.studentErrors = { ...this.studentErrors, general: error.body?.message || 'Save failed.' };
        });
    }

    handleResetStudent() {
        this.newStudent = { name: '', rollNo: '', marks: '', email: '' };
        this.studentErrors = {};
    }

    // ════════════════════════════════════════
    //   FACULTY HANDLERS
    // ════════════════════════════════════════
    handleFacultyChange(event) {
        const field = event.target.dataset.field;
        this.newFaculty = { ...this.newFaculty, [field]: event.target.value };
        if (this.facultyErrors[field]) {
            this.facultyErrors = { ...this.facultyErrors, [field]: null };
        }
    }

    validateFaculty() {
        let errs = {};
        let isValid = true;

        // 1. Faculty Name — not empty, min 3 chars
        if (!this.newFaculty.name || this.newFaculty.name.trim() === '') {
            errs.name = 'Faculty name cannot be empty.';
            isValid = false;
        } else if (this.newFaculty.name.trim().length < 3) {
            errs.name = 'Faculty name must contain at least 3 characters.';
            isValid = false;
        }

        // 2. Faculty ID — must be > 0
        const fId = Number(this.newFaculty.facultyId);
        if (!this.newFaculty.facultyId || isNaN(fId)) {
            errs.facultyId = 'Faculty ID is required.';
            isValid = false;
        } else if (fId <= 0) {
            errs.facultyId = 'Faculty ID must be greater than 0.';
            isValid = false;
        }

        // 3. Salary — > 10,000 and < 5,00,000
        const salary = Number(this.newFaculty.salary);
        if (!this.newFaculty.salary || isNaN(salary)) {
            errs.salary = 'Salary is required.';
            isValid = false;
        } else if (salary <= 10000) {
            errs.salary = 'Salary must be greater than ₹10,000.';
            isValid = false;
        } else if (salary >= 500000) {
            errs.salary = 'Salary must be less than ₹5,00,000.';
            isValid = false;
        }

        // 4. Department — must be selected
        if (!this.newFaculty.department || this.newFaculty.department === '') {
            errs.department = 'Please select a department.';
            isValid = false;
        }

        // 5. Joining Date — cannot be future
        if (!this.newFaculty.joiningDate) {
            errs.joiningDate = 'Joining date is required.';
            isValid = false;
        } else {
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            if (new Date(this.newFaculty.joiningDate) > today) {
                errs.joiningDate = 'Joining date cannot be a future date.';
                isValid = false;
            }
        }

        this.facultyErrors = errs;
        return isValid;
    }

    handleSaveFaculty() {
        this.successMessage = '';
        if (!this.validateFaculty()) return;

        // Check Faculty ID uniqueness via Apex
        isFacultyIdUnique({ facultyId: Number(this.newFaculty.facultyId) })
            .then(isUnique => {
                if (!isUnique) {
                    this.facultyErrors = {
                        ...this.facultyErrors,
                        facultyId: 'Faculty ID ' + this.newFaculty.facultyId + ' already exists.'
                    };
                    return;
                }
                return saveFaculty({
                    facultyName  : this.newFaculty.name.trim(),
                    facultyId    : Number(this.newFaculty.facultyId),
                    salary       : Number(this.newFaculty.salary),
                    department   : this.newFaculty.department,
                    joiningDate  : this.newFaculty.joiningDate
                });
            })
            .then(result => {
                if (result) {
                    this.successMessage = '✅ Faculty "' + this.newFaculty.name + '" saved successfully!';
                    this.handleResetFaculty();
                    this.loadFaculty();
                }
            })
            .catch(error => {
                this.facultyErrors = { ...this.facultyErrors, general: error.body?.message || 'Save failed.' };
            });
    }

    handleResetFaculty() {
        this.newFaculty = { name: '', facultyId: '', salary: '', department: '', joiningDate: '' };
        this.facultyErrors = {};
    }
}
