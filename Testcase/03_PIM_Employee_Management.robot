*** Settings ***
Documentation    Employee Management (PIM Module)
Library    SeleniumLibrary
Library    String
Resource    ../Keywords/Common.resource
Resource    ../Keywords/Page/Login_Page.resource
Resource    ../Keywords/Page/PIM_Page.resource
Variables    ../config.py
Suite Setup    Run Keywords
...    Set Selenium Timeout    15s
...    AND    Open Browser To Login Page
...    AND    Generate Unique Employee Data
Suite Teardown    Close Browser


*** Keywords ***
Generate Unique Employee Data
    # สร้างชื่อ + Employee Id แบบสุ่มต่อรอบรัน เพื่อให้ test รันซ้ำได้โดยไม่ชนข้อมูลเดิม
    ${rand}=    Generate Random String    4    [NUMBERS]
    Set Suite Variable    ${EMP_FIRST_NAME}    Krittayoach${rand}
    Set Suite Variable    ${EMP_ID}    ${rand}


*** Test Cases ***
TC-7 Input New Employee
    [Documentation]    สามารถเพิ่มพนักงานใหม่ (Add Employee) โดยต้องมีการ Upload รูปภาพโปรไฟล์ (.jpg หรือ .png) เข้าไปในระบบด้วย
    [Tags]    Smoke    Positive    Regression    PIM Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${HEADER}    15s
    Element Should Contain    ${HEADER}    Dashboard
    
    Go To PIM Page

    Input New Employee    ${EMP_FIRST_NAME}    N    Thongnoo    ${EMP_ID}

    [Teardown]    Run Keyword If Test Passed    Logout To Login Page

TC-8 Search Employee
    [Documentation]    ตรวจสอบว่าชื่อ-นามสกุลพนักงานที่เพิ่มไป ปรากฏถูกต้องในหน้า Personal Details
    [Tags]    Smoke    Positive    Regression    PIM Management

    Login To OrangeHRM    ${VALID_USER}[USERNAME]    ${VALID_USER}[PASSWORD]
    Wait Until Element Is Visible    ${HEADER}    15s
    Element Should Contain    ${HEADER}    Dashboard

    Go To PIM Page

    # ค้นหาพนักงานเดียวกับที่ TC-7 เพิ่งสร้าง (ใช้ค่า ${EMP_FIRST_NAME} ร่วมกันทั้ง suite)
    Search Employee    ${EMP_FIRST_NAME}
    
    [Teardown]    Run Keyword If Test Passed    Logout To Login Page






         