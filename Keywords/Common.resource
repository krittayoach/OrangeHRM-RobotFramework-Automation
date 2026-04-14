*** Settings ***
Library     SeleniumLibrary
Variables   ../config.py

*** Variables ***
# ใส่ตัวแปรที่ใช้ร่วมกันทั้งโปรเจกต์
#${BROWSER}      chrome

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

    Open Browser    ${URL}    ${BROWSER}    options=${options}
    Maximize Browser Window

Close Browser After Test
    Close All Browsers