import { LightningElement, track, wire } from 'lwc';
import saveEmployee   from '@salesforce/apex/EmployeeLWCController.saveEmployee';
import getEmployees   from '@salesforce/apex/EmployeeLWCController.getEmployees';
import isEmpIdUnique  from '@salesforce/apex/EmployeeLWCController.isEmpIdUnique';

export default class EmployeeManager extends LightningElement {

    // ── Form fields ──
    @track newEmp = {
        empName    : '',
        empId      : '',
        salary     : '',
        email      : '',
        department : '',
        joiningDate: ''
    };

    // ── Validation errors ──
    @track errors = {};

    // ── Employee list ──
    @track employees = [];

    // ── Success message ──
    @track successMessage = '';

    // ── Department dropdown options ──
    get departmentOptions() {
        return [
            { label: 'Engineering',    value: 'Engineering'    },
            { label: 'Marketing',      value: 'Marketing'      },
            { label: 'Human Resources',value: 'Human Resources'},
            { label: 'Finance',        value: 'Finance'        },
            { label: 'Sales',          value: 'Sales'          },
            { label: 'Operations',     value: 'Operations'     },
            { label: 'IT Support',     value: 'IT Support'     }
        ];
    }

    // ── Load employees on component load ──
    connectedCallback() {
        this.loadEmployees();
    }

    loadEmployees() {
        getEmployees()
            .then(result => { this.employees = result; })
            .catch(error => { console.error('Error loading employees:', error); });
    }

    // ── Handle input changes ──
    handleChange(event) {
        const field = event.target.dataset.field;
        this.newEmp = { ...this.newEmp, [field]: event.target.value };

        // Clear error for that field as user types
        if (this.errors[field]) {
            this.errors = { ...this.errors, [field]: null };
        }
    }

    // ════════════════════════════════════════
    //   VALIDATION LOGIC
    // ════════════════════════════════════════
    validate() {
        let errs   = {};
        let isValid = true;

        // 1. Employee Name — not empty, min 3 chars
        if (!this.newEmp.empName || this.newEmp.empName.trim() === '') {
            errs.empName = 'Employee Name cannot be empty.';
            isValid = false;
        } else if (this.newEmp.empName.trim().length < 3) {
            errs.empName = 'Employee Name must contain at least 3 characters.';
            isValid = false;
        }

        // 2. Employee ID — must be > 0
        const empIdNum = Number(this.newEmp.empId);
        if (!this.newEmp.empId || isNaN(empIdNum)) {
            errs.empId = 'Employee ID is required.';
            isValid = false;
        } else if (empIdNum <= 0) {
            errs.empId = 'Employee ID must be greater than 0.';
            isValid = false;
        }

        // 3. Salary — between 10,000 and 5,00,000
        const salaryNum = Number(this.newEmp.salary);
        if (!this.newEmp.salary || isNaN(salaryNum)) {
            errs.salary = 'Salary is required.';
            isValid = false;
        } else if (salaryNum <= 10000) {
            errs.salary = 'Salary must be greater than ₹10,000.';
            isValid = false;
        } else if (salaryNum >= 500000) {
            errs.salary = 'Salary must be less than ₹5,00,000.';
            isValid = false;
        }

        // 4. Email — valid format (must contain @ and .)
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!this.newEmp.email || this.newEmp.email.trim() === '') {
            errs.email = 'Email address is required.';
            isValid = false;
        } else if (!emailRegex.test(this.newEmp.email)) {
            errs.email = 'Please enter a valid email address (e.g. name@company.com).';
            isValid = false;
        }

        // 5. Department — must be selected
        if (!this.newEmp.department || this.newEmp.department === '') {
            errs.department = 'Please select a department.';
            isValid = false;
        }

        // 6. Joining Date — cannot be a future date
        if (!this.newEmp.joiningDate) {
            errs.joiningDate = 'Joining Date is required.';
            isValid = false;
        } else {
            const today      = new Date();
            today.setHours(0, 0, 0, 0);
            const joiningDate = new Date(this.newEmp.joiningDate);
            if (joiningDate > today) {
                errs.joiningDate = 'Joining Date cannot be a future date.';
                isValid = false;
            }
        }

        this.errors = errs;
        return isValid;
    }

    // ════════════════════════════════════════
    //   SAVE — called on button click
    // ════════════════════════════════════════
    handleSave() {
        this.successMessage = '';

        // Step 1: Client-side validation
        if (!this.validate()) return;

        // Step 2: Check Employee ID uniqueness via Apex
        isEmpIdUnique({ empId: Number(this.newEmp.empId) })
            .then(isUnique => {
                if (!isUnique) {
                    this.errors = {
                        ...this.errors,
                        empId: 'Employee ID ' + this.newEmp.empId + ' already exists. Please use a unique ID.'
                    };
                    return;
                }

                // Step 3: Save to Salesforce
                return saveEmployee({
                    empName    : this.newEmp.empName.trim(),
                    empId      : Number(this.newEmp.empId),
                    salary     : Number(this.newEmp.salary),
                    email      : this.newEmp.email.trim(),
                    department : this.newEmp.department,
                    joiningDate: this.newEmp.joiningDate
                });
            })
            .then(result => {
                if (result) {
                    this.successMessage = '✅ Employee "' + this.newEmp.empName + '" saved successfully!';
                    this.handleReset();
                    this.loadEmployees();
                }
            })
            .catch(error => {
                console.error('Save error:', error);
                this.errors = { ...this.errors, general: error.body?.message || 'An error occurred.' };
            });
    }

    // ── Reset form ──
    handleReset() {
        this.newEmp = { empName:'', empId:'', salary:'', email:'', department:'', joiningDate:'' };
        this.errors = {};
    }
}
