*** Settings ***
Documentation    User Management (Admin Module)
Library    SeleniumLibrary
Resource    ../Keywords/Common.resource
Resource    ../Keywords/Page/Login_Page.resource
Resource    ../Keywords/Page/PIM_Page.resource
Variables    ../config.py
Suite Setup    Run Keywords
...    Set Selenium Timeout    15s
...    AND    Open Browser To Login Page
Suite Teardown    Close Browser


*** Test Cases ***
TC-7 Input New Employee
    [Documentation]    สามารถเพิ่มพนักงานใหม่ (Add Employee) โดยต้องมีการ Upload รูปภาพโปรไฟล์ (.jpg หรือ .png) เข้าไปในระบบด้วย
    [Tags]    Smoke    Positive    Regression    PIM Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${HEADER}    15s
    Element Should Contain    ${HEADER}    Dashboard
    
    Go To PIM Page

    Input New Employee    Krittayoach3    N    Thongnoo    1245

    [Teardown]    Run Keyword If Test Passed    Logout To Login Page

TC-8 Search Employee
    [Documentation]    ตรวจสอบว่าชื่อ-นามสกุลพนักงานที่เพิ่มไป ปรากฏถูกต้องในหน้า Personal Details
    [Tags]    Smoke    Positive    Regression    PIM Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${HEADER}    15s
    Element Should Contain    ${HEADER}    Dashboard

    Go To PIM Page

    Search Employee    Krittayoach3
    
    [Teardown]    Run Keyword If Test Passed    Logout To Login Page






         