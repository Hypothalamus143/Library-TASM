; Filename: FINAl-PROJECT.ASM
; Programmer Name: JOHN PRINCE ALONTE
; Date: November 28, 2025
; Description: Library Borrowing System

.model small
.stack 100h
.data
    ; Header Section
    programmer db 'Programmer: John Prince Alonte',0ah,'$'
    description db 'Description: Library System',0ah,'$'
    date db 'Date: November 28, 2025',0ah,'$'
    project_title db 'Project Title: Final Project',0ah,0ah,'$'
    
    ; Main Menu
    mainmenu db '===== MAIN MENU ====',0ah,'$'
    option1 db '1. Login',0ah,'$'
    option2 db '2. Create New Account',0ah,'$'
    option3 db '3. Exit',0ah,0ah,'$'
    choose_option db 'Choose option: $'
    
    ; Exit Message
    exit_msg db 'Exiting, come back again!',0ah,'$'
    
    ; Login Section
    login_header db '===== LOGIN ====',0ah,'$'
    username_prompt db 'Username: $'
    password_prompt db 'Password: $'
    invalid_username db 'Invalid Username!',0ah,'Returning to Main Menu...',0ah,0ah,'$'
    incorrect_password db 'Incorrect Password!',0ah,'Returning to Main Menu...',0ah,0ah,'$'
    welcome_msg db 'Welcome $'
    exclamation db '!',0ah,0ah,'$'
    
    ; Create Account Section
    create_acc_header db '===== CREATE NEW ACCOUNT ====',0ah,'$'
    username_exists db 'Username already exists!',0ah,'Returning to Main Menu...',0ah,0ah,'$'
    account_created db 'Account created, hello $'
    your_password db 'Your password is $'
    
    ; Submenu Section
    submenu_header db '===== SUBMENU ====',0ah,'$'
    sub_option1 db '1. Borrow',0ah,'$'
    sub_option2 db '2. Renewal',0ah,'$'
    sub_option3 db '3. Return',0ah,'$'
    sub_option4 db '4. Read All',0ah,'$'
    sub_option5 db '5. Log Out',0ah,0ah,'$'
    
    ; Borrow Section
    borrow_header db '===== BORROW ====',0ah,'$'
    input_details db 'Input Details of Book to Borrow:',0ah,'$'
    author_prompt db 'Author: $'
    title_prompt db 'Title: $'
    publisher_prompt db 'Publisher: $'
    date_published_prompt db 'Date Published: $'
    date_borrowed_prompt db 'Date Borrowed: $'
    book_borrowed_msg db 'Book Borrowed!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    
    ; Renew Section
    renew_header db '===== RENEW ====',0ah,'$'
    unreturned_books db 'Unreturned books:',0ah,'$'
    enter_id_renew db 'Enter ID of book to Renew: $'
    invalid_id db 'Invalid ID!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    new_date_borrowed db 'Enter new Date Borrowed: $'
    borrow_renewed db 'Borrow Renewed!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    
    ; Return Section
    return_header db '===== RETURN ====',0ah,'$'
    enter_id_return db 'Enter ID of book to Return: $'
    book_returned db 'Book Returned!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    
    ; Read All Section
    read_header db '===== UNRETURNED BOOKS ====',0ah,'$'
    
    ; Logout Section
    logout_msg db 'Logging Out...',0ah,'Returning to Main Menu...',0ah,0ah,'$'
    
    ; Utility strings
    newline db 0ah,'$'
    space db ' $'
    colon db ': $'
    comma db ', $'
.code
start:
    mov ax, @data
    mov ds, ax

    call print_main_menu

mov ah, 4Ch
int 21h

main_menu proc
    call print_main_menu
    call process_main_menu
main_menu endp
; put functions here
print_header proc
    call clear
    mov ah, 09h
    mov dx, offset programmer
    int 21h
    
    mov ah, 09h
    mov dx, offset description
    int 21h
    
    mov ah, 09h
    mov dx, offset date
    int 21h
    
    mov ah, 09h
    mov dx, offset project_title
    int 21h
    
    ret
print_header endp

clear proc
    mov ax, 0003h
    int 10h
    ret
clear endp

print_main_menu proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print header
    call print_header
    
    ; Print main menu title
    mov ah, 09h
    mov dx, offset mainmenu
    int 21h
    
    ; Print menu options
    mov ah, 09h
    mov dx, offset option1
    int 21h
    
    mov ah, 09h
    mov dx, offset option2
    int 21h
    
    mov ah, 09h
    mov dx, offset option3
    int 21h
    
    ; Print choose option prompt
    mov ah, 09h
    mov dx, offset choose_option
    int 21h
    
    ret
print_main_menu endp

process_main_menu proc
    ; Get user input
    mov ah, 01h
    int 21h
    
    ; Handle new line
    push ax
    mov ah, 02h
    mov dl, 0ah
    int 21h
    mov ah, 02h
    mov dl, 0ah
    int 21h
    pop ax
    
    ; Check input and call appropriate functions
    cmp al, '1'
    je CallLogin
    cmp al, '2'
    je CallCreateAccount
    cmp al, '3'
    je CallExit
    
    ; If invalid input, reprint main menu
    call main_menu
    ret
    
CallLogin:
    call login
    ret
    
CallCreateAccount:
    call create_account
    ret
    
CallExit:
    call exit_program
    ret
    
process_main_menu endp

; Placeholder functions (you'll need to implement these)
login proc
    ; Login function implementation here
    ret
login endp

create_account proc
    ; Create account function implementation here
    ret
create_account endp

exit_program proc
    ; Exit function implementation here
    ret
exit_program endp

end start
