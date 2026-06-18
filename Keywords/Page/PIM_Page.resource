*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem

*** Variables ***
${PIM_BTN}       xpath=//span[contains(@class,'oxd-main-menu-item--name') and normalize-space()='PIM']
${HEADER}        xpath=//h6[contains(@class,'oxd-topbar-header-breadcrumb-module')]
${ADD_BTN}       xpath=//button[contains(@class,'oxd-button--secondary') and normalize-space()='Add']
${SEARCH_BTN}    xpath=//button[normalize-space()='Search']
${RESET_BTN}     xpath=//button[normalize-space(='Reset')]
${SAVE_BTN}      xpath=//button[normalize-space()='Save']

# Form Fields Locators
${PICTURE_FIELD}   xpath=//input[@type='file']
${F_NAME_FIELD}    xpath=//input[@name='firstName']
${M_NAME_FIELD}    xpath=//input[@name='middleName']
${L_NAME_FIELD}    xpath=//input[@name='lastName']
${EMP_ID_FIELD}    xpath=//label[text()='Employee Id']/parent::div/following-sibling::div/input
${EMP_NAME_FIELD}    xpath=//div[label[text()='Employee Name']]/following-sibling::div//input
${RECORDS_FIELD}     xpath=//div[contains(@class, 'orangehrm-container')]
#Function
${DROPDOWN_OPTION}    xpath=//div[@role='listbox']//div[@role='option']   

#Fields Path (ใช้ path แบบ relative จะได้รันได้ทุกเครื่อง ไม่ fix เป็นเครื่องเรา)
${FIELD_PATH}      ${CURDIR}/../../TestData/profile.png

*** Keywords ***
Go To PIM Page
    Click Element    ${PIM_BTN}
    Wait Until Element Is Visible    ${HEADER}    10s
    #Element Text Should Be    ${HEADER}    PIM
    
Input New Employee 
    [Arguments]    ${f_name}    ${m_name}    ${l_name}    ${emp_id}   
    Click Element    ${ADD_BTN}
    # 1. รอให้หน้า Add Employee โหลดเสร็จก่อน (สำคัญมาก)
    Wait Until Element Is Visible    ${F_NAME_FIELD}    15s

    # 2. รอให้ Input File ปรากฏใน DOM (อาจจะไม่ Visible ในสายตาคน แต่ต้องมีใน DOM)
    Wait Until Page Contains Element    ${PICTURE_FIELD}    10s

    # 3. ใส่รูปภาพ (Normalize Path เพื่อตัด ../ ออก ไม่งั้น chromedriver ฟ้อง path is not canonical)
    ${picture_path}=    Normalize Path    ${FIELD_PATH}
    Choose File    ${PICTURE_FIELD}    ${picture_path}

    # 4. ใส่ข้อมูลอื่นๆ
    Input Text    ${F_NAME_FIELD}    ${f_name}
    Input Text    ${M_NAME_FIELD}    ${m_name}
    Input Text    ${L_NAME_FIELD}    ${l_name}

    # เคลียร์ค่าเดิมใน Emp ID ก่อนถ้ามี
    Clear Element Text    ${EMP_ID_FIELD}
    Input Text    ${EMP_ID_FIELD}    ${emp_id}

    # รอให้ form loader (ตอนอัปโหลดรูป) หายก่อน ไม่งั้นมันบังปุ่ม Save -> click intercepted
    Wait Until Element Is Not Visible    xpath=//div[contains(@class,'oxd-form-loader')]    15s
    Click Button    ${SAVE_BTN}
    # รอให้การบันทึกสำเร็จ
    Wait Until Page Contains    Successfully Saved    30s

Search Employee
    [Arguments]    ${emp_name}

    Wait Until Element Is Visible    ${EMP_NAME_FIELD}    15s
    Click Element    ${EMP_NAME_FIELD}
    
    Input Text    ${EMP_NAME_FIELD}    ${emp_name}
    Wait Until Element Is Visible    ${DROPDOWN_OPTION}    15s
    Click Element    ${DROPDOWN_OPTION}

    Click Element    ${SEARCH_BTN}
    
    Wait Until Element Is Visible    ${RECORDS_FIELD}    15s
    
    Wait Until Page Contains    ${emp_name}    15s
    Page Should Contain    ${emp_name}

    

