// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PayrollEscrow {
    address public employer;
    address[] public employees;
    mapping(address => uint) public salaries;

    constructor() {
        employer = msg.sender;
    }

    function addEmployee(address employee, uint salary) public {
        require(msg.sender == employer, "Only employer");
        employees.push(employee);
        salaries[employee] = salary;
    }

    function fund() public payable {}

    function distributePayroll() public {
        require(msg.sender == employer, "Only employer");
        for (uint i = 0; i < employees.length; i++) {
            address emp = employees[i];
            uint salary = salaries[emp];
            require(address(this).balance >= salary, "Insufficient balance");
            payable(emp).transfer(salary);
        }
    }
}
