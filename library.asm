; Filename: FINAl-PROJECT.ASM
; Programmer Name: JOHN PRINCE ALONTE
; Date: November 28, 2025
; Description: Library Borrowing System

.model small
.stack 100h
.data
    ; Account storage arrays (10 accounts max)
    username_array db 10 dup(20 dup('$'))   ; 10 usernames, 20 chars each
    password_array db 10 dup(20 dup('$'))   ; 10 passwords, 20 chars each
    
    ; Account counter
    account_count dw 0
    
    ; Buffer for input
    username_buffer db 21, ?, 21 dup('$')   ; 20 chars + terminator
    password_buffer db 21, ?, 21 dup('$')   ; 20 chars + terminator
    
    ; Index for current account being processed
    current_index dw 0
    
    input_length dw 0

    stdin_handle equ 0       

    ; Constants
    MAX_ACCOUNTS equ 10
    MAX_USERNAME_LENGTH equ 20
    MAX_PASSWORD_LENGTH equ 20

    account_limit_msg db 'Account limit reached! Maximum 10 accounts.',0ah,'Returning to Main Menu...',0ah,0ah,'$'
    ; Header Section
    press_any_key db 'Press any key to continue...',0ah,0ah,'$'

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

    call main_menu

mov ah, 4Ch
int 21h

main_menu proc
    call print_main_menu
    call process_main_menu
    ret
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
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print login header
    mov ah, 09h
    mov dx, offset login_header
    int 21h
    
    ; Get username
    mov ah, 09h
    mov dx, offset username_prompt
    int 21h
    
    ; Read username using 3Fh
    mov dx, offset username_buffer
    mov cx, MAX_USERNAME_LENGTH
    call read_string_3fh
    
    ; Add newline
    mov ah, 02h
    mov dl, 0ah
    int 21h
    
    ; Find username index
    call find_username_index
    cmp ax, -1
    je UsernameNotFound
    
    ; Save user index
    mov current_index, ax
    
    ; Get password
    mov ah, 09h
    mov dx, offset password_prompt
    int 21h
    
    ; Read password using 3Fh
    mov dx, offset password_buffer
    mov cx, MAX_PASSWORD_LENGTH
    call read_string_3fh
    
    ; Add newline
    mov ah, 02h
    mov dl, 0ah
    int 21h
    
    ; Verify password
    call verify_password
    cmp al, 1
    je PasswordCorrect
    
    ; Password incorrect
    call handle_password_error
    ret
    
UsernameNotFound:
    call handle_username_error
    ret
    
PasswordCorrect:
    call handle_login_success
    ret
login endp

; ==================== HELPER FUNCTIONS ====================

; Find username in array
; Returns: AX = index if found, AX = -1 if not found
find_username_index proc
    mov cx, account_count
    cmp cx, 0
    je NotFound
    
    mov si, offset username_buffer  ; Input username (NO +2 with 3Fh)
    mov di, offset username_array   ; First stored username
    xor bx, bx                      ; Index counter
    
CheckLoop:
    push cx
    push si
    push di
    push bx
    
    ; Compare usernames
    mov cx, MAX_USERNAME_LENGTH
CompareLoop:
    mov al, [si]
    mov ah, [di]
    cmp al, ah
    jne NotEqual
    
    ; Check if we reached end of both strings
    cmp al, '$'
    je Found
    
    inc si
    inc di
    loop CompareLoop
    
NotEqual:
    pop bx
    pop di
    pop si
    pop cx
    
    ; Move to next username
    inc bx
    add di, MAX_USERNAME_LENGTH
    loop CheckLoop
    
NotFound:
    mov ax, -1
    ret
    
Found:
    pop bx
    mov ax, bx          ; Return index
    pop di
    pop si
    pop cx
    ret
find_username_index endp

; Verify password for current user index
; Returns: AL = 1 if correct, AL = 0 if incorrect
verify_password proc
    ; Calculate password array offset
    mov ax, current_index
    mov bx, MAX_PASSWORD_LENGTH
    mul bx
    mov di, offset password_array
    add di, ax                     ; DI points to stored password
    
    mov si, offset password_buffer  ; Input password (NO +2 with 3Fh)
    
    ; Compare passwords
    mov cx, MAX_PASSWORD_LENGTH
ComparePasswords:
    mov al, [si]
    mov bl, [di]
    
    ; Check for string terminators
    cmp al, '$'
    je CheckStoredEnd
    
    ; Compare characters
    cmp al, bl
    jne PasswordWrong
    
    ; Check if stored password ended
    cmp bl, '$'
    je CheckInputEnd
    
    inc si
    inc di
    loop ComparePasswords
    
    ; If loop completes without mismatch
    mov al, 1
    ret
    
CheckStoredEnd:
    ; Input ended, check if stored also ended
    cmp byte ptr [di], '$'
    je PasswordRight
    jmp PasswordWrong
    
CheckInputEnd:
    ; Stored ended, check if input also ended
    cmp byte ptr [si], '$'
    je PasswordRight
    
PasswordWrong:
    mov al, 0
    ret
    
PasswordRight:
    mov al, 1
    ret
verify_password endp

; Handle username not found error
handle_username_error proc
    mov ah, 09h
    mov dx, offset invalid_username
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call main_menu
    ret
handle_username_error endp

; Handle password incorrect error
handle_password_error proc
    mov ah, 09h
    mov dx, offset incorrect_password
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call main_menu
    ret
handle_password_error endp

; Handle successful login
handle_login_success proc
    ; Print welcome message
    mov ah, 09h
    mov dx, offset welcome_msg
    int 21h
    
    ; Save current_index before any modifications
    mov ax, current_index
    push ax                     ; Save current_index to stack
    
    ; Calculate username position
    mov bx, MAX_USERNAME_LENGTH
    mul bx                     ; AX = current_index * MAX_USERNAME_LENGTH
    mov si, offset username_array
    add si, ax                 ; SI points to username
    
    ; Print username using existing function
    call print_string          ; This modifies AH, corrupting AX!
    
    ; Restore current_index from stack
    pop ax                     ; Get original current_index back
    mov current_index, ax      ; Store it back to variable
    
    mov ah, 09h                ; Reset AH for string output
    mov dx, offset exclamation
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    ; Go to submenu
    call submenu_main
    ret
handle_login_success endp

create_account proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print create account header
    mov ah, 09h
    mov dx, offset create_acc_header
    int 21h
    
    ; Check if account limit reached
    mov ax, account_count
    cmp ax, MAX_ACCOUNTS
    jge AccountLimitReached
    
    ; Get username
    mov ah, 09h
    mov dx, offset username_prompt
    int 21h
    
    ; Read username using 3Fh
    mov dx, offset username_buffer
    mov cx, MAX_USERNAME_LENGTH
    call read_string_3fh
    
    ; Add newline after input
    mov ah, 02h
    mov dl, 0ah
    int 21h
    
    ; Check if username already exists
    call check_username_exists
    cmp al, 1
    je UsernameExistsError
    
    ; Get password
    mov ah, 09h
    mov dx, offset password_prompt
    int 21h
    
    ; Read password using 3Fh
    mov dx, offset password_buffer
    mov cx, MAX_PASSWORD_LENGTH
    call read_string_3fh
    
    ; Add newline after input
    mov ah, 02h
    mov dl, 0ah
    int 21h
    
    ; Store the account
    call store_account
    
    ; Print success message
    mov ah, 09h
    mov dx, offset account_created
    int 21h
    
    ; Print username (NO +2 offset needed with 3Fh)
    mov si, offset username_buffer
    call print_string
    
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    mov ah, 09h
    mov dx, offset your_password
    int 21h
    
    ; Print password (NO +2 offset needed with 3Fh)
    mov si, offset password_buffer
    call print_string
    
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    ; Wait for key press
    mov ah, 07h
    int 21h
    
    ; Return to main menu
    call main_menu
    ret
AccountLimitReached:
    call AccountLimitReachedFunc
UsernameExistsError:
    ; Print error message
    mov ah, 09h
    mov dx, offset username_exists
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call main_menu
    ret
    
AccountLimitReachedFunc proc
    ; Print error message
    mov ah, 09h
    lea dx, account_limit_msg
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call main_menu
    ret
AccountLimitReachedFunc endp
create_account endp

; Helper function to check if username already exists
; Returns: AL = 1 if exists, AL = 0 if not exists
check_username_exists proc
    mov cx, account_count
    cmp cx, 0
    je NoAccounts
    
    mov si, offset username_buffer  ; Input username (NO +2 with 3Fh)
    mov di, offset username_array   ; First stored username
    
CheckLoop1:
    push cx
    push si
    push di
    
    ; Compare usernames
    mov cx, MAX_USERNAME_LENGTH
CompareLoop1:
    mov al, [si]
    mov bl, [di]
    cmp al, bl
    jne NotEqual1
    
    ; Check if we reached end of both strings
    cmp al, '$'
    je FoundMatch
    
    inc si
    inc di
    loop CompareLoop1
    
NotEqual1:
    pop di
    pop si
    pop cx
    
    ; Move to next username (20 bytes each)
    add di, MAX_USERNAME_LENGTH
    loop CheckLoop1
    
NoAccounts:
    mov al, 0
    ret
    
FoundMatch:
    pop di
    pop si
    pop cx
    mov al, 1
    ret
check_username_exists endp

; Helper function to store new account
store_account proc
    ; Get current index
    mov ax, account_count
    mov bx, MAX_USERNAME_LENGTH
    mul bx
    mov di, offset username_array
    add di, ax                     ; DI points to username storage
    
    ; Copy username
    mov si, offset username_buffer  ; NO +2 with 3Fh
    mov cx, MAX_USERNAME_LENGTH
CopyUsername:
    mov al, [si]
    cmp al, '$'        ; Check for string terminator
    je EndUsername
    mov [di], al
    inc si
    inc di
    loop CopyUsername
EndUsername:
    
    ; Get password storage position
    mov ax, account_count
    mov bx, MAX_PASSWORD_LENGTH
    mul bx
    mov di, offset password_array
    add di, ax                     ; DI points to password storage
    
    ; Copy password
    mov si, offset password_buffer  ; NO +2 with 3Fh
    mov cx, MAX_PASSWORD_LENGTH
CopyPassword:
    mov al, [si]
    cmp al, '$'        ; Check for string terminator
    je EndPassword
    mov [di], al
    inc si
    inc di
    loop CopyPassword
EndPassword:
    
    ; Increment account count
    inc account_count
    ret
store_account endp

; Helper function to print string until '$'
print_string proc
    mov ah, 02h
PrintLoop:
    mov dl, [si]
    cmp dl, '$'
    je PrintDone
    cmp dl, 0Dh        ; Skip carriage return
    je NextChar
    cmp dl, 0Ah        ; Skip line feed
    je NextChar
    int 21h
NextChar:
    inc si
    jmp PrintLoop
PrintDone:
    ret
print_string endp

; Helper function to read string using 3Fh
; Input: DX = buffer offset, CX = max length
; Output: AX = bytes read (excluding CR/LF)
read_string_3fh proc
    push bx
    push cx
    push dx
    
    ; Read from stdin (handle 0)
    mov ah, 3Fh
    mov bx, stdin_handle
    ; CX already has max length
    ; DX already has buffer offset
    int 21h
    
    ; Save bytes read
    mov input_length, ax
    
    ; Replace CR/LF with '$'
    mov si, dx
    add si, ax                    ; Point to end of input
    dec si                       ; Last character
    
    ; Check and replace terminator
    cmp byte ptr [si], 0Dh       ; Carriage return
    je ReplaceTerminator
    cmp byte ptr [si], 0Ah       ; Line feed
    je ReplaceTerminator
    inc si                       ; No terminator, add one
    
ReplaceTerminator:
    mov byte ptr [si], '$'
    
    pop dx
    pop cx
    pop bx
    ret
read_string_3fh endp

print_submenu proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print welcome message with username
    mov ah, 09h
    mov dx, offset welcome_msg
    int 21h
    
    
    ; Check if we have a valid current_index
    mov ax, current_index
    cmp ax, -1
    je SkipUsername
    
    push ax                     ; Save current_index
    
    mov bx, MAX_USERNAME_LENGTH
    mul bx
    mov si, offset username_array
    add si, ax
    
    ; Print username using existing function
    call print_string          ; Modifies AH (part of AX)
    
    pop ax                     ; Restore current_index
    mov current_index, ax      ; Store it back
    
SkipUsername:
    mov ah, 09h                ; Reset AH for string output
    mov dx, offset exclamation
    int 21h
    
    ; Print submenu header
    mov ah, 09h
    mov dx, offset submenu_header
    int 21h
    
    ; Print submenu options
    mov ah, 09h
    mov dx, offset sub_option1
    int 21h
    
    mov ah, 09h
    mov dx, offset sub_option2
    int 21h
    
    mov ah, 09h
    mov dx, offset sub_option3
    int 21h
    
    mov ah, 09h
    mov dx, offset sub_option4
    int 21h
    
    mov ah, 09h
    mov dx, offset sub_option5
    int 21h
    
    ; Print choose option prompt
    mov ah, 09h
    mov dx, offset choose_option
    int 21h
    
    ret
print_submenu endp


; Main submenu function that handles everything
submenu_main proc
    call print_submenu
    call process_submenu
    ret
submenu_main endp

; Process user selection in submenu
process_submenu proc
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
    je CallBorrow
    cmp al, '2'
    je CallRenew
    cmp al, '3'
    je CallReturn
    cmp al, '4'
    je CallReadAll
    cmp al, '5'
    je CallLogout
    
    ; If invalid input, reprint submenu
    call submenu_main
    ret
    
CallBorrow:
    call borrow_book
    ret
    
CallRenew:
    call renew_book
    ret
    
CallReturn:
    call return_book
    ret
    
CallReadAll:
    call read_unreturned_books
    ret
    
CallLogout:
    call logout
    ret
    
process_submenu endp

; Logout function
logout proc
    ; Print logout message
    mov ah, 09h
    mov dx, offset logout_msg
    int 21h
    
    ; Reset current_index to -1 (no user logged in)
    mov current_index, -1
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    ; Return to main menu
    call main_menu
    ret
logout endp

; Placeholder functions for submenu options
borrow_book proc
    ; TODO: Implement borrow book functionality
    mov ah, 09h
    mov dx, offset borrow_header
    int 21h
    
    ; For now, just return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
borrow_book endp

renew_book proc
    ; TODO: Implement renew book functionality
    mov ah, 09h
    mov dx, offset renew_header
    int 21h
    
    ; For now, just return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
renew_book endp

return_book proc
    ; TODO: Implement return book functionality
    mov ah, 09h
    mov dx, offset return_header
    int 21h
    
    ; For now, just return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
return_book endp

read_unreturned_books proc
    ; TODO: Implement read all unreturned books functionality
    mov ah, 09h
    mov dx, offset read_header
    int 21h
    
    ; For now, just return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
read_unreturned_books endp

exit_program proc
    ; Exit function implementation here
    ret
exit_program endp

end start
