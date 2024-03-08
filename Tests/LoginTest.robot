*** Settings ***
Library    SeleniumLibrary
Library    DataDriver    ../TestData/login.csv
Resource    ../Constants.robot

Test Template   Login Scenario

*** Test Cases ***
login scenario    ${username}    ${password}


*** Keywords ***
Login Scenario
    [Arguments]    ${username}    ${password}
    open browser  ${BASE_URL}   ${browser}
    input text  id:user-name    ${username}
    input password  id:password    ${password}
    click button    id:login-button
    location should be    ${HOME_PAGE_URL}
    element should be visible    xpath://span[text()="Products"]
    close browser



