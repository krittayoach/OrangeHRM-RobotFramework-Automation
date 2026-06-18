*** Settings ***
Documentation    การทดสอบระบบจัดการทรัพยากรบุคคล (HR Management System) โดยใช้เว็บไซต์ OrangeHRM Demo [Authentication & Security (Login/Logout)]
Library    SeleniumLibrary
Variables    ../config.py
Resource    ../Keywords/Common.resource
Resource    ../Keywords/Page/Login_Page.resource
Suite Setup    Run Keywords
...    Set Selenium Timeout    15s
...    AND    Open Browser To Login Page
Test Setup    Ensure At Login Page
Suite Teardown    Close Browser

*** Variables ***
${USER_BTN}    class:oxd-userdropdown-tab
${HEADER}    xpath=//h6[contains(@class,'oxd-topbar-header-breadcrumb-module')]

*** Test Cases ***
TC-1 Login To Page Successful
    [Documentation]    กรณีผู้ใช้งานต้องสามารถเข้าสู่ระบบได้ด้วย Username/Password ที่ถูกต้อง (Admin / admin123)
    [Tags]    Smoke    Regression    Positive    Login    ValidCredentials

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${HEADER}    10s
    Element Should Contain    ${HEADER}    Dashboard

    [Teardown]    Run Keyword If Test Passed    Logout To Login Page

TC-2 Login To Page Failed
    [Documentation]    กรณีกรอก Username หรือ Password ผิด ระบบต้องแสดงข้อความ "Invalid credentials"
    [Tags]    Smoke    Regression    Negative    Login    Authentication    InvalidCredentials

    Login To OrangeHRM    ${INVALID_USER}[USERNAME]    ${INVALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${ERROR_MSG_ALERT}    10s
    Element Should Contain    ${ERROR_MSG_ALERT}    Invalid credentials

TC-3 Login To Page Multiple Users
    [Documentation]    กรณีการทดสอบ Login หลาย User พร้อมกัน (Data-Driven Testing)
    [Tags]    Regression    Login    DataDriven
    [Template]    Login With Credentials

    Admin    admin123        Dashboard
    Admin    wrongpass       Invalid credentials
    wronguser    admin123    Invalid credentials






           