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
Test Setup    Ensure At Login Page
Suite Teardown    Close Browser


*** Variables ***
${ERROR_MESSAGE}    xpath=//span[contains(@class, 'oxd-input-field-error-message')]
# ใช้เป็น "คำค้น" ของ autocomplete เพื่อหยิบพนักงานจริงตัวแรกที่เจอ
# (ไม่ผูกชื่อตายตัว เพราะ demo รีเซ็ตข้อมูลเป็นระยะ ชื่ออาจเปลี่ยน)
${EMPLOYEE_DATA}    a
${PASSWORD_DATA}    Komahss123


*** Keywords ***
Generate Unique Test Data
    # สุ่ม username ใหม่ทุกรอบ กันมัน error ว่ามีชื่อนี้แล้วตอนรันซ้ำ
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

    # ใช้ Page Contains กันเคสมี error message หลายตัวบนหน้า (จับผิดตัว)
    Wait Until Page Contains    Passwords do not match    15s

    [Teardown]    Run Keyword If Test Passed   Logout To Login Page

TC-6 Search User
    [Documentation]    เมื่อเพิ่มสำเร็จ ต้องสามารถ Search หาชื่อ User ที่เพิ่งเพิ่มไปเจอในตาราง
    [Tags]    Smoke    Positive    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page
    # search หาคนที่เพิ่ง add ไปใน TC-4 (ค้นด้วย username พอ)
    Search Information    ${TEST_USERNAME}