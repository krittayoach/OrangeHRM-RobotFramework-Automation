*** Settings ***
Documentation    User Management (Admin Module)
Library    SeleniumLibrary
#Resource    keywords.resource
Resource    ../Keywords/Common.resource
Resource    ../Keywords/Page/Login_Page.resource
Resource    ../Keywords/Page/Admin_Page.resource
Variables    ../config.py
Suite Setup    Run Keywords
...    Set Selenium Timeout    15s
...    AND    Open Browser To Login Page
Suite Teardown    Close Browser


*** Variables ***
${ERROR_MESSAGE}    xpath=//span[contains(@class, 'oxd-input-field-error-message')]


*** Test Cases ***
TC-4 Add New User {Select Role User And Status}
    [Documentation]    เพิ่ม User ใหม่เข้าระบบได้ โดยมีการเลือก User Role (Admin/ESS) และ Status (Enabled/Disabled) จาก Dropdown
    [Tags]    Smoke    Positive    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page

    Add User    ESS    Ranga Akunuri    Enabled    Krama1    Komahss123    Komahss123

    [Teardown]    Logout To Login Page

TC-5 Add New User {Password Matching}
    [Documentation]    ตรวจสอบ Password Matching (รหัสผ่านยืนยันต้องตรงกัน)
    [Tags]    Smoke    Negative    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page
    Add User    ESS    Ranga Akunuri    Enabled    Krama1    Komahss123    WrongPass123

    Wait Until Element Contains    ${ERROR_MESSAGE}    Passwords do not match

    [Teardown]    Run Keyword If Test Passed   Logout To Login Page

TC-6 Search User
    [Documentation]    เมื่อเพิ่มสำเร็จ ต้องสามารถ Search หาชื่อ User ที่เพิ่งเพิ่มไปเจอในตาราง
    [Tags]    Smoke    Positive    Regression    Admin/User Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Go To Admin Page
    Search Information    Krama1    ESS    Paul Collings    Enabled