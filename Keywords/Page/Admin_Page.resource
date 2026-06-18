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

Select Employee Autocomplete
    [Arguments]    ${query}
    # ช่อง Employee Name เป็น autocomplete ต้องเลือกจาก dropdown จริงๆ
    # ถ้าคลิกเร็วไปจะโดน "Searching..." ทำให้ field ขึ้น Invalid
    Input Text    ${EMPLOYEE_NAME_INPUT}    ${query}
    Wait Until Element Is Visible        xpath=//div[@role='listbox']    10s
    # รอให้ "Searching..." หายก่อน ค่อยอ่านผลจริง
    Wait Until Element Is Not Visible    xpath=//div[@role='option' and contains(.,'Searching')]    10s
    Wait Until Element Is Visible        xpath=//div[@role='option']    10s
    # กันเคสหาไม่เจอ (จะขึ้น "No Records Found" แล้วคลิกไปก็ได้ Invalid)
    ${selected}=    Get Text    xpath=(//div[@role='option'])[1]
    Should Not Contain    ${selected}    No Records Found    msg=ไม่พบพนักงานจาก query '${query}'
    Click Element    xpath=(//div[@role='option'])[1]
    RETURN    ${selected}

Add User
    [Arguments]    ${role}    ${employee}    ${status}    ${username}    ${password}    ${confirm_password}
    Click Element    ${ADD_BTN}
    Wait Until Page Contains    Add User    10s

    # User Role
    Click Element    ${USERROLE_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${role}']

    # Employee Name
    Select Employee Autocomplete    ${employee}

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
    # keyword นี้แค่กรอกฟอร์มกับกด save เฉยๆ ไม่เช็คผล
    # จะได้เอาไปใช้ได้ทั้ง case ถูก (TC-4) กับ case ผิด (TC-5)
    # ส่วนเช็คผลไปทำในแต่ละ test เอา

Verify User Added Successfully
    # ถ้า save ผ่าน หน้าจะเด้งกลับมา list แล้วมีตารางโผล่
    Wait Until Element Contains      ${HEADER}    Admin    15s
    Wait Until Element Is Visible    ${RESULTS_TABLE}    15s

Search Information
    [Arguments]    ${username}
    # ค้นด้วย username อย่างเดียวพอ เพราะมัน unique อยู่แล้ว
    # (ไม่ต้องใส่ filter role/employee/status ให้รก + เปราะ)
    Wait Until Element Is Visible    ${SEARCH_USERNAME_INPUT}    10s
    Input Text                       ${SEARCH_USERNAME_INPUT}    ${username}
    Click Element                    ${SEARCH_BTN}
    # เช็คว่าเจอ username ในตารางจริงๆ
    # อย่าเช็คแค่ "Records Found" เพราะมันขึ้นตลอดถึงจะได้ 0 อัน
    Wait Until Element Is Visible    ${RESULTS_TABLE}    10s
    Wait Until Element Contains      ${RESULTS_TABLE}    ${username}    10s