*** Settings ***
Library     SeleniumLibrary
Library     String
Library     Collections
Library     BuiltIn
Resource    ../Constants.robot

*** Variables ***
@{productnames}

*** Keywords ***
open and login to portal
    open browser    ${BASE_URL}    ${BROWSER}
    maximize browser window
    login to portal

login to portal
    input text  id:user-name    ${USER_NAME}
    input password  id:password    ${PASSWORD}
    click button    id:login-button
    location should be    ${HOME_PAGE_URL}
    element should be visible    xpath://span[text()="Products"]

add item to cart
    [Arguments]    ${product}
    click element    xpath://*[text()='${product}']
    sleep    2
    click element    xpath://button[text()="Add to cart"]
    sleep    1

add all products to cart
     ${add_to_cart_buttons} =    get webelements    xpath://button[text()="Add to cart"]
     FOR    ${element}    IN    @{add_to_cart_buttons}
         click element    ${element}
     END
     sleep    2

open cart page
    click element    id:shopping_cart_container
    sleep    2
    element should be visible    xpath://span[text()="Your Cart"]
    element should be visible    id:checkout
    location should be  ${CART_URL}

perform checkout

    click element    id:checkout
    element should be visible    xpath://span[text()="Checkout: Your Information"]
    input text    id:first-name    ${FIRST_NAME}
    input text    id:last-name     ${LAST_NAME}
    input text    id:postal-code   ${POST_CODE}
    click element    id:continue
    element should be visible    xpath://*[text()="Checkout: Overview"]
    element should be visible    xpath://*[text()="Payment Information"]
    element should be visible    xpath://*[text()="Shipping Information"]
    element should be visible    xpath://*[text()="Price Total"]
    ${payment_information} =    get text    xpath:(//*[@class="summary_value_label"])[1]
    log to console     ${payment_information}
    ${shipping_information} =    get text    xpath:(//*[@class="summary_value_label"])[2]
    log to console     ${shipping_information}
    ${subtotal} =    get text    xpath://*[@class="summary_subtotal_label"]
    log to console     ${subtotal}
    ${tax} =    get text    xpath://*[@class="summary_tax_label"]
    log to console     ${tax}
    ${total} =    get text    xpath://*[@class="summary_info_label summary_total_label"]
    log to console     ${total}
    ${total} =     fetch from right   ${total}    $
    ${subtotal} =    fetch from right   ${subtotal}    $
    ${tax} =       fetch from right   ${tax}    $
    ${expectedtotal} =    evaluate    ${subtotal}+${tax}
    should be equal as numbers    ${total}    ${expectedtotal}
    log to console    Expected total:${expectedtotal} Actual total:${total}
    click element    id:finish

verify checkout
    element should be visible    xpath://h2[text()="Thank you for your order!"]
    click element    id:back-to-products
    element should be visible    xpath://*[text()="Products"]

verify product name sorting order
    [Arguments]    ${order}
    @{products}  create list
    log to console    Order:${order}

    IF     $order == "A-Z"
         select from list by label    xpath://*[@class="product_sort_container"]    Name (A to Z)
         sleep    2

         @{products} =   get all products
         @{sorted_products} =  set variable    ${products}
         sort list    ${sorted_products}

    ELSE IF    $order == "Z-A"
         select from list by label    xpath://*[@class="product_sort_container"]    Name (Z to A)
         sleep    2

         @{products} =   get all products
         @{sorted_products} =  set variable    ${products}
         sort list       ${sorted_products}
         reverse list    ${sorted_products}

    ELSE IF    $order == "low - high"
         select from list by label    xpath://*[@class="product_sort_container"]    Price (low to high)
         sleep    2
         @{products} =   get all product prices
         ${sorted_products} =  set variable    ${products}
         sort list    ${sorted_products}
    ELSE IF    $order == "high - low"
         select from list by label    xpath://*[@class="product_sort_container"]    Price (high to low)
         sleep    2
         @{products} =   get all product prices
         ${sorted_products} =  set variable    ${products}
         sort list    ${sorted_products}
         reverse list    ${sorted_products}
    END
    log to console    Actual List:${products}
    log to console    Expected List:${sorted_products}
    lists should be equal    ${products}    ${sorted_products}


get all products
    @{productnames}  create list
    @{products}    create list
    @{products} =    get webelements    xpath://*[@class="inventory_item_name "]
    FOR    ${product}  IN    @{products}
       ${productname} =  set variable   ${product.text}
       log to console    Product name : ${productname}
       append to list    ${productnames}    ${productname}
    END
    RETURN  ${productnames}

get all product prices
    @{pricelist}  create list
    @{prices}    create list
    @{pricelist} =    get webelements    xpath://*[@class="inventory_item_price"]
    FOR    ${price}  IN    @{pricelist}
       ${pricevalue} =  set variable   ${price.text}
       ${pricevalue}    remove string    ${pricevalue}    $
       ${pricevalue} =    convert to number    ${pricevalue}
       log to console    Product name : ${pricevalue}
       append to list    ${prices}    ${pricevalue}
    END
    RETURN  ${prices}

remove product from cart and verify
    [Arguments]    ${product}
    sleep    2
    click element    xpath://*[text()='${product}']/../..//button[text()="Remove"]
    sleep    2
    element should not be visible    xpath://*[text()='${product}']







