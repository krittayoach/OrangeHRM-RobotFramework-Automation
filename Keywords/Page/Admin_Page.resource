*** Settings ***
Library     SeleniumLibrary

*** Variables ***
${ADMIN_MENU_BTN}           xpath=//span[normalize-space()='Admin']
${HEADER}                   xpath=//h6[contains(@class,'oxd-topbar-header-breadcrumb-module')]
${ADD_BTN}                  xpath=//button[contains(@class,'oxd-button--secondary') and normalize-space()='Add']
${SEARCH_BTN}               xpath=//button[normalize-space()='Search']
${SAVE_BTN}                 xpath=//button[normalize-space()='Save']

# Form Fields Locators
${USERROLE_SLT}             xpath=//label[normalize-space()='User Role']/following::div[contains(@class,'oxd-select-text')][1]
${SEARCH_USERNAME_INPUT}    xpath=//label[normalize-space()='Username']/ancestor::div[contains(@class,'oxd-input-group')]//input
${RESULTS_TABLE}            xpath=//div[contains(@class,'oxd-table-body')]
${SUCCESS_TOAST}           xpath=//div[contains(@class,'oxd-toast') and contains(.,'Success')]
${ADD_USERNAME_INPUT}        xpath=//label[normalize-space()='Username']/ancestor::div[contains(@class,'oxd-input-group')]//input
${STATUS_SLT}               xpath=//label[normalize-space()='Status']/ancestor::div[contains(@class,'oxd-input-group')]//div[contains(@class,'oxd-select-text')]
${EMPLOYEE_NAME_INPUT}      xpath=//label[normalize-space()='Employee Name']/ancestor::div[contains(@class,'oxd-input-group')]//input
${PASSWORD_FIELD}           xpath=//label[normalize-space()='Password']/ancestor::div[contains(@class,'oxd-input-group')]//input
${CONFIRM_PASSWORD_FIELD}   xpath=//label[normalize-space()='Confirm Password']/ancestor::div[contains(@class,'oxd-input-group')]//input

${DROPDOWN_OPTION}    xpath=//div[@role='option']//span[normalize-space()='{}']
*** Keywords ***
Go To Admin Page
    Wait Until Element Is Visible    ${ADMIN_MENU_BTN}    10s
    Click Element    ${ADMIN_MENU_BTN}
    Wait Until Element Contains      ${HEADER}    Admin    10s

Add User
    [Arguments]    ${role}    ${employee}    ${status}    ${username}    ${password}    ${confirm_password}
    Click Element    ${ADD_BTN}
    Wait Until Page Contains    Add User    10s

    # User Role
    Click Element    ${USERROLE_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${role}']

    # Employee Name
    Input Text    ${EMPLOYEE_NAME_INPUT}    ${employee}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    10s
    Wait Until Element Is Visible    xpath=(//div[@role='option'])[1]    10s
    Click Element    xpath=(//div[@role='option'])[1]
    
    # Status
    Click Element    ${STATUS_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    10s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${status}']

    # Username / Passwor
    Wait Until Element Is Visible    ${ADD_USERNAME_INPUT}    10s
    Clear Element Text               ${ADD_USERNAME_INPUT}
    Input Text                       ${ADD_USERNAME_INPUT}    ${username}

    Wait Until Element Is Visible    ${PASSWORD_FIELD}    10s
    Input Password                   ${PASSWORD_FIELD}    ${password}
    Input Password                   ${CONFIRM_PASSWORD_FIELD}    ${confirm_password}

    Click Element                    ${SAVE_BTN}
    # หมายเหตุ: keyword นี้ "เป็นกลาง" ต่อผลลัพธ์ (fill + save เท่านั้น)
    # เพื่อให้ใช้ซ้ำได้ทั้ง positive (TC-4) และ negative (TC-5)
    # การ assert ผลสำเร็จ/ล้มเหลว ทำในแต่ละ test case

Verify User Added Successfully
    # ใช้โดย test เชิงบวก: หลังบันทึกต้อง redirect กลับหน้า list (ตารางผู้ใช้ปรากฏ)
    Wait Until Element Contains      ${HEADER}    Admin    15s
    Wait Until Element Is Visible    ${RESULTS_TABLE}    15s

Search Information
    [Arguments]    ${username}    ${role}    ${employee}    ${status}
    
    # กรอกข้อมูลสำหรับการค้นหา
    Wait Until Element Is Visible    ${SEARCH_USERNAME_INPUT}    10s
    Input Text                       ${SEARCH_USERNAME_INPUT}    ${username}
     
    # เลือก User Role
    Click Element    ${USERROLE_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${role}']

    Input Text    ${EMPLOYEE_NAME_INPUT}    ${employee}
    # รอ option ตัวแรกให้ปรากฏจริง ๆ
    Wait Until Element Is Visible    xpath=(//div[@role='option'])[1]    10s
    # คลิกตัวแรกเลย (ไม่อิงชื่อ)
    Click Element    xpath=(//div[@role='option'])[1]

    # เลือก Status
    Click Element    ${STATUS_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${status}']
    
    # เพิ่มการคลิกปุ่มค้นหา (ที่ขาดไปตอนแรก)
    Click Element    ${SEARCH_BTN}
    # Assert ที่แข็งแรง: ต้องเจอ username ที่ค้นจริงในตารางผลลัพธ์
    # (ไม่พึ่ง "Records Found" เพราะข้อความนี้ขึ้นแม้ผลเป็น 0 record)
    Wait Until Element Is Visible    ${RESULTS_TABLE}    10s
    Wait Until Element Contains      ${RESULTS_TABLE}    ${username}    10s