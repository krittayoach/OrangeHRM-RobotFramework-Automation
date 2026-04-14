*** Settings ***
Library      SeleniumLibrary
Variables    config.py

*** Variables ***
${LOGIN_BTN}                xpath=//button[@type='submit']
${USER_BTN}                 css:.oxd-userdropdown-tab
${LOGOUT_BTN}               xpath=//a[normalize-space()='Logout']
${HEADER}                   xpath=//h6[contains(@class,'oxd-topbar-header-breadcrumb-module')]
${ADMIN_BTN}                xpath=//span[normalize-space()='Admin']
${ADD_BTN}                  xpath=//button[contains(@class,'oxd-button--secondary') and normalize-space()='Add']
${SEARCH_BTN}               xpath=//button[normalize-space()='Search']
${SAVE_BTN}                 xpath=//button[normalize-space()='Save']
${PIM_BTN}                  xpath=//span[normalize-space()='PIM']

# Form Fields Locators
${USERROLE_SLT}    xpath=//label[normalize-space()='User Role']/following::div[contains(@class,'oxd-select-text')][1]
${USERROLE_SLT}             xpath=//label[normalize-space()='User Role']/following::div[contains(@class,'oxd-select-text')][1]
${USERNAME_INPUT}           xpath=//label[normalize-space()='Username']/ancestor::div[contains(@class,'oxd-input-group')]//input
${STATUS_SLT}               xpath=//label[normalize-space()='Status']/ancestor::div[contains(@class,'oxd-input-group')]//div[contains(@class,'oxd-select-text')]
${EMPLOYEE_NAME}            xpath=//label[normalize-space()='Employee Name']/ancestor::div[contains(@class,'oxd-input-group')]//input
${PASSWORD_FIELD}           xpath=//label[normalize-space()='Password']/ancestor::div[contains(@class,'oxd-input-group')]//input
${CONFIRM_PASSWORD_FIELD}   xpath=//label[normalize-space()='Confirm Password']/ancestor::div[contains(@class,'oxd-input-group')]//input

*** Keywords ***
Open Browser To Login Page
    ${options}=    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs}=      Create Dictionary
    ...    credentials_enable_service=${False}
    ...    profile.password_manager_enabled=${False}
    ...    profile.password_manager_leak_detection=${False}
    ...    safebrowsing.enabled=${False}

    Call Method    ${options}    add_experimental_option    prefs    ${prefs}
    ${arg_disable_features}=    Set Variable    --disable-features=PasswordLeakDetection,SafeBrowsingPasswordCheck

    Call Method    ${options}    add_argument    --disable-notifications
    Call Method    ${options}    add_argument    ${arg_disable_features}

    Open Browser    ${URL}    chrome    options=${options}
    Maximize Browser Window

Login To OrangeHRM
    [Arguments]    ${username}    ${password}
    Go To    ${URL}
    Wait Until Element Is Visible    name:username    15s
    Input Text        name:username    ${username}
    Input Password    name:password    ${password}
    Click Element     ${LOGIN_BTN}

Logout To Login Page
    Wait Until Element Is Visible    ${USER_BTN}    10s
    Click Element    ${USER_BTN}
    Wait Until Element Is Visible    ${LOGOUT_BTN}    10s
    Click Element    ${LOGOUT_BTN}
    Wait Until Element Is Visible    name=username    10s

Login With Credentials
    [Arguments]    ${username}    ${password}    ${expected}
    Login To OrangeHRM    ${username}    ${password}
    
    # ใช้ IF/ELSE แทน Run Keyword If เพื่อความทันสมัยและอ่านง่าย
    IF    '${expected}' == 'Dashboard'
        Wait Until Element Is Visible    ${HEADER}    10s
        Logout To Login Page
    ELSE
        Wait Until Page Contains    ${expected}    10s
    END

#Admin Management Keywords
Go To Admin Page
    Wait Until Element Is Visible    ${ADMIN_BTN}    10s
    Click Element    ${ADMIN_BTN}
    Wait Until Element Contains    ${HEADER}    Admin    10s

Add User
    [Arguments]    ${role}    ${employee}    ${status}    ${username}    ${password}    ${confirm_password}

    Click Element    ${ADD_BTN}
    Wait Until Page Contains    Add User    10s

    # User Role
    Click Element    ${USERROLE_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${role}']

    # Employee Name
    # พิมพ์บางส่วนก่อน
    Input Text    ${EMPLOYEE_NAME}    Paul
    # รอ option ตัวแรกให้ปรากฏจริง ๆ
    Wait Until Element Is Visible    xpath=(//div[@role='option'])[1]    10s
    # คลิกตัวแรกเลย (ไม่อิงชื่อ)
    Click Element    xpath=(//div[@role='option'])[1]


    # Status
    Click Element    ${STATUS_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${status}']

    # Username / Password
    Input Text        ${USERNAME_INPUT}         ${username}
    Wait Until Element Is Visible    ${PASSWORD_FIELD}    10s
    Input Password    ${PASSWORD_FIELD}         ${password}
    Input Password    ${CONFIRM_PASSWORD_FIELD}    ${confirm_password}

    Click Element    ${SAVE_BTN}
    Wait Until Element Contains    ${HEADER}    Admin    15s 

Search Information 
    [Arguments]    ${username}    ${role}    ${employee}    ${status}
    
    # กรอกข้อมูลสำหรับการค้นหา
    Input Text    ${USERNAME_INPUT}    ${username}
     
    # เลือก User Role
    Click Element    ${USERROLE_SLT}
    Wait Until Element Is Visible    xpath=//div[@role='listbox']    5s
    Click Element    xpath=//div[@role='option']//span[normalize-space()='${role}']

    Input Text    ${EMPLOYEE_NAME}    Paul
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
    Wait Until Page Contains    Records Found    10s

#Employee Management Keyword
Go To PIM Page
    Wait Until Element Is Visible    ${PIM_BTN}    10s
    Click Element    ${PIM_BTN}
    Wait Until Element Contains    ${HEADER}     PIM    10s

Input New Employee
    Click Element    

