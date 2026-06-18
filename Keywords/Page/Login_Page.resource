*** Settings ***
Library     SeleniumLibrary
Resource    ../Common.resource

*** Variables ***
${LOGIN_BTN}            xpath=//button[@type='submit']
${USER_BTN}             css:.oxd-userdropdown-tab
${LOGOUT_BTN}           xpath=//a[normalize-space()='Logout']
${HEADER_BREADCRUMB}    xpath=//h6[contains(@class,'oxd-topbar-header-breadcrumb-module')]
${ERROR_MSG_ALERT}      xpath=//p[contains(@class,'oxd-alert-content-text')] 

#ตัวแปร
${USERNAME_INPUT}                 name:username 
${USERPASSWORD_INPUT}            name:password 

*** Keywords ***
Login To OrangeHRM
    [Arguments]    ${username}    ${password}
    Go To    ${URL}
    Wait Until Element Is Visible    ${USERNAME_INPUT}    15s
    Input Text       ${USERNAME_INPUT}    ${username}
    Input Password   ${USERPASSWORD_INPUT}    ${password}
    
    Click Element    ${LOGIN_BTN}

Logout To Login Page
    Wait Until Element Is Visible    ${USER_BTN}    10s
    Click Element    ${USER_BTN}
    Wait Until Element Is Visible    ${LOGOUT_BTN}    10s
    Click Element    ${LOGOUT_BTN}
    Wait Until Element Is Visible    ${USERNAME_INPUT}    10s

Ensure At Login Page
    [Documentation]    กันเคสเทสก่อนหน้า fail แล้วค้างสถานะ login → เทสถัดไปจะได้เริ่มที่หน้า login เสมอ
    Go To    ${URL}
    # ถ้ายัง login ค้างอยู่ (เจอปุ่ม user dropdown) ให้ logout ก่อน
    ${logged_in}=    Run Keyword And Return Status
    ...    Wait Until Element Is Visible    ${USER_BTN}    3s
    IF    ${logged_in}
        Logout To Login Page
    END
    Wait Until Element Is Visible    ${USERNAME_INPUT}    15s

Login With Credentials
    [Arguments]    ${username}    ${password}    ${expected}
    Login To OrangeHRM    ${username}    ${password}
    
    IF    '${expected}' == 'Dashboard'
        Wait Until Element Is Visible    ${HEADER_BREADCRUMB}    10s
        Logout To Login Page
    ELSE
        Wait Until Element Contains    ${ERROR_MSG_ALERT}    ${expected}    10s    
    END