*** Settings ***
Documentation    User Management (Admin Module)
Library    SeleniumLibrary
Library    String
Resource    ../Keywords/Common.resource
Resource    ../Keywords/Page/Login_Page.resource
Resource    ../Keywords/Page/Admin_Page.resource
Variables    ../config.py
Suite Setup    Run Keywords
...    Set Selenium Timeout    15s
...    AND    Open Browser To Login Page
...    AND    Generate Unique Test Data
Suite Teardown    Close Browser


*** Variables ***
${ERROR_MESSAGE}    xpath=//span[contains(@class, 'oxd-input-field-error-message')]
# ข้อมูลทดสอบที่ใช้ร่วมกันทั้ง suite (employee ต้องเป็นชื่อที่มีอยู่จริงในระบบ demo)
${EMPLOYEE_DATA}    Paul Collings
${PASSWORD_DATA}    Komahss123


*** Keywords ***
Generate Unique Test Data
    # สร้าง username แบบสุ่มต่อรอบรัน เพื่อให้ test รันซ้ำได้โดยไม่ชน "Username already exists"
    ${rand}=    Generate Random String    5    [LETTERS]
    Set Suite Variable    ${TEST_USERNAME}    Auto${rand}


*** Test Cases ***
TC-4 Add New User {Select Role User And Status}
    [Documentation]    เพิ่ม User ใหม่เข้าระบบได้ โดยมีการเลือก User Role (Admin/ESS) และ Status (Enabled/Disabled) จาก Dropdown
    [Tags]    Smoke    Positive    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page

    Add User    ESS    ${EMPLOYEE_DATA}    Enabled    ${TEST_USERNAME}    ${PASSWORD_DATA}    ${PASSWORD_DATA}
    Verify User Added Successfully

    [Teardown]    Logout To Login Page

TC-5 Add New User {Password Matching}
    [Documentation]    ตรวจสอบ Password Matching (รหัสผ่านยืนยันต้องตรงกัน)
    [Tags]    Smoke    Negative    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page
    Add User    ESS    ${EMPLOYEE_DATA}    Enabled    ${TEST_USERNAME}    ${PASSWORD_DATA}    WrongPass123

    Wait Until Element Contains    ${ERROR_MESSAGE}    Passwords do not match

    [Teardown]    Run Keyword If Test Passed   Logout To Login Page

TC-6 Search User
    [Documentation]    เมื่อเพิ่มสำเร็จ ต้องสามารถ Search หาชื่อ User ที่เพิ่งเพิ่มไปเจอในตาราง
    [Tags]    Smoke    Positive    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page
    # ค้นหา user เดียวกับที่ TC-4 เพิ่งสร้าง (ใช้ค่า ${TEST_USERNAME} ร่วมกันทั้ง suite)
    Search Information    ${TEST_USERNAME}    ESS    ${EMPLOYEE_DATA}    Enabled