*** Settings ***
Library    SeleniumLibrary
Resource   Test.Keywords.robot

Test Setup  open and login to portal
Test Teardown    close browser

*** Variables ***


*** Test Cases ***
Verify Cart Checkout
    [Tags]   first
     add item to cart    Sauce Labs Backpack
     sleep    1
     open cart page
     perform checkout
     verify checkout

Verify product sorting
    [Tags]    second
     verify product name sorting order    A-Z
     verify product name sorting order    Z-A
     verify product name sorting order    low - high
     verify product name sorting order    high - low

Add and remove product from cart
    [Tags]    third
     add all products to cart
     open cart page
     remove product from cart and verify    Sauce Labs Bike Light




