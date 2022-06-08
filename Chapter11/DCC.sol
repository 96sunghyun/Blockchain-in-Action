pragma solidity ^0.5.8;

contract DICCertification {
  // 최소로 요구하는 수료성적의 평균
  uint256 private constant MINIMUM_GPA_REQUIRED = 250;

  struct Student {
    uint256 personNumber;
    uint256 prereq115;
    uint256 prereq116;
    uint256 core250;
    uint256 core486;
    uint256 core487;
    uint256 domainSpecificCourse;
    uint256 domainSpecificGrade;
    uint256 capstoneCourse;
    uint256 capstoneGrade;
  }

  address public chairPerson;
  mapping(address => Student) public registeredStudents;

  event preRequisiteSatisfied(uint256 personNumber);
  event coreCoursesSatisfied(uint256 personNumber);
  event GPArequirementSatisfied(uint256 personNumber);
  event projectRequirementSatisfied(uint256 personNumber);
  event domainRequirementSatisfied(uint256 personNumber);
  event GPA(uint256 result);

  //----------------------------------------------------------------------------------------------
  // Modifiers
  //----------------------------------------------------------------------------------------------

  modifier checkStudent(uint256 personNumber) {
    require(
      registeredStudents[msg.sender].personNumber == 0,
      "Student has already registered"
    );
    _;
  }

  modifier validStudent() {
    require(registeredStudents[msg.sender].personNumber > 0, "Invalid student");
    _;
  }

  modifier isChairPerson() {
    require(chairPerson == msg.sender, "Not a chairperson");
    _;
  }

  //----------------------------------------------------------------------------------------------
  // Functions
  //----------------------------------------------------------------------------------------------
  constructor() public {
    chairPerson = msg.sender;
  }

  // 학생이 자가등록하는 함수
  function registerStudent(uint256 personNumber)
    public
    checkStudent(personNumber)
  {
    registeredStudents[msg.sender].personNumber = personNumber;
  }

  function loginStudent(uint256 personNumber) public view returns (bool) {
    if (registeredStudents[msg.sender].personNumber == personNumber) {
      return true;
    } else {
      return false;
    }
  }

  function addPreRequisiteCourse(uint256 courseNumber, uint256 grade)
    public
    validStudent
  {
    if (courseNumber == 115) {
      registeredStudents[msg.sender].prereq115 = grade;
    } else if (courseNumber == 116) {
      registeredStudents[msg.sender].prereq116 = grade;
    } else {
      revert("Invalid course information provided");
    }
  }

  function addCoreCourse(uint256 courseNumber, uint256 grade)
    public
    validStudent
  {
    if (courseNumber == 250) {
      registeredStudents[msg.sender].core250 = grade;
    } else if (courseNumber == 486) {
      registeredStudents[msg.sender].core486 = grade;
    } else if (courseNumber == 487) {
      registeredStudents[msg.sender].core487 = grade;
    } else {
      revert("Invalid course information provided");
    }
  }

  function addDomainSpecificCourse(uint256 courseNumber, uint256 grade)
    public
    validStudent
  {
    require(courseNumber < 1000, "Invalid course information provided");
    registeredStudents[msg.sender].domainSpecificCourse = courseNumber;
    registeredStudents[msg.sender].domainSpecificGrade = grade;
  }

  function addCapstoneCourse(uint256 courseNumber, uint256 grade)
    public
    validStudent
  {
    require(courseNumber < 1000, "Invalid course information provided");
    registeredStudents[msg.sender].capstoneCourse = courseNumber;
    registeredStudents[msg.sender].capstoneGrade = grade;
  }

  // 모든 과목을 수강했는지 확인하고 => GPA를 계산하여 => GPA가 요구조건 이상이면 event로 true를 기록한다.
  function checkEligibility(uint256 personNumber)
    public
    validStudent
    returns (bool)
  {
    bool preRequisitesSatisfied = false;
    bool coreSatisfied = false;
    bool domainSpecificSatisfied = false;
    bool capstoneSatisfied = false;
    bool gradeSatisfied = false;
    uint256 totalGPA = 0;

    if (
      registeredStudents[msg.sender].prereq115 > 0 &&
      registeredStudents[msg.sender].prereq116 > 0
    ) {
      preRequisitesSatisfied = true;
      emit preRequisiteSatisfied(personNumber);
      totalGPA +=
        registeredStudents[msg.sender].prereq115 +
        registeredStudents[msg.sender].prereq116;
    }

    if (
      registeredStudents[msg.sender].core250 > 0 &&
      registeredStudents[msg.sender].core486 > 0 &&
      registeredStudents[msg.sender].core487 > 0
    ) {
      coreSatisfied = true;
      emit coreCoursesSatisfied(personNumber);

      totalGPA +=
        registeredStudents[msg.sender].core250 +
        registeredStudents[msg.sender].core486 +
        registeredStudents[msg.sender].core487;
    }

    if (registeredStudents[msg.sender].domainSpecificGrade > 0) {
      domainSpecificSatisfied = true;
      emit domainRequirementSatisfied(personNumber);
      totalGPA += registeredStudents[msg.sender].domainSpecificGrade;
    }

    if (registeredStudents[msg.sender].capstoneGrade > 0) {
      capstoneSatisfied = true;
      emit projectRequirementSatisfied(personNumber);
      totalGPA += registeredStudents[msg.sender].capstoneGrade;
    }

    if (
      preRequisitesSatisfied &&
      coreSatisfied &&
      domainSpecificSatisfied &&
      capstoneSatisfied
    ) {
      totalGPA /= 7;
      emit GPA(totalGPA);

      if (totalGPA >= MINIMUM_GPA_REQUIRED) {
        gradeSatisfied = true;
        emit GPArequirementSatisfied(personNumber);
      }
    }
    return gradeSatisfied;
  }

  function destroy() public isChairPerson {
    selfdestruct(msg.sender);
  }
}
