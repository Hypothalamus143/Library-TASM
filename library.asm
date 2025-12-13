; Filename: FINAl-PROJECT.ASM
; Programmer Name: JOHN PRINCE ALONTE
; Date: November 28, 2025
; Description: Library Borrowing System

.model small
.stack 100h
.data

    ; Renew book variables
    renew_slot dw 0                  ; Slot to renew (1-based)
    books_found_renew dw 0           ; Counter for found books

    ; Renew book messages
    unreturned_books_renew_msg db 'Your borrowed books:',0ah,'$'
    no_books_to_renew_msg db 'No books to renew.',0ah,'Returning to Submenu...',0ah,0ah,'$'
    slot_empty_renew_msg db 'Slot is empty! Cannot renew.',0ah,'Returning to Submenu...',0ah,0ah,'$'
    renewing_book_msg db 'Renewing this book:',0ah,'$'
    current_date_label db 'Current date borrowed: $'
    by_separator db ' by $'

    ; Read pagination variables
    books_displayed dw 0             ; Books displayed on current page
    total_books_found dw 0           ; Total occupied books found
    total_pages_needed dw 0          ; Total pages needed

    ; Read pagination messages
    page_header_read db 'Page $'
    page_of_msg_read db ' of $'
    continue_prompt_read db 0ah,'Press any key for next page...',0ah,0ah,'$'
    end_of_list_read_msg db 0ah,'End of book list.',0ah,'$'
    total_books_msg db 'Total books: $'
    books_found_msg db ' book(s)',0ah,0ah,'$'
    ; Return book variables
    return_slot dw 0                ; Slot to return (1-based)
    books_found dw 0                ; Counter for found books

    ; Return book messages
    unreturned_books_list_msg db 'Your borrowed books:',0ah,'$'
    no_books_to_return_msg db 'No books to return.',0ah,'Returning to Submenu...',0ah,0ah,'$'
    slot_empty_return_msg db 'Slot is empty! Cannot return.',0ah,'Returning to Submenu...',0ah,0ah,'$'
    returning_book_msg db 'Returning this book:',0ah,'$'
    confirm_return_msg db 0ah,'Confirm return? (Y/N): $'
    return_cancelled_msg db 'Return cancelled.',0ah,'Returning to Submenu...',0ah,0ah,'$'

    ; ==================== PAGINATION VARIABLES ====================
    current_slot_display dw 1       ; Current slot being displayed (1-based)
    current_page dw 1               ; Current page number
    slots_displayed dw 0            ; How many slots displayed in current page

    ; ==================== PAGINATION MESSAGES ====================
    continue_prompt db 0ah,'Press any key for next page...',0ah,0ah,'$'
    end_of_list_msg db 0ah,'End of book list.',0ah,0ah,'$'
    page_header db 'Page $'
    page_of_msg db ' of 4',0ah,'$'  ; 10 slots ÷ 3 per page ≈ 4 pages


    ; Add these after your existing messages
    borrow_menu_header db 'Available Slots:',0ah,'$'
    slot_format db '  Slot $'
    occupied_msg db ': [OCCUPIED] $'
    empty_msg db ': [EMPTY] $'
    choose_slot_msg db 0ah,'Choose slot to borrow (1-10): $'
    invalid_slot_msg db 'Invalid slot! Must be 1-10. Returning to Submenu...',0ah,'$'
    book_details_prompt db 0ah,'Enter book details:',0ah,'$'

    current_field_counter dw 0      ; For tracking which book field we're storing
    ; Book storage arrays (10 users, 10 books per user)
    ; Each field is 50 characters max
    title_array      db 10 dup(10 dup(50 dup('$')))     ; 10 users × 10 books × 50 chars
    author_array     db 10 dup(10 dup(50 dup('$')))     ; 10 users × 10 books × 50 chars
    publisher_array  db 10 dup(10 dup(50 dup('$')))     ; 10 users × 10 books × 50 chars
    date_pub_array   db 10 dup(10 dup(50 dup('$')))     ; 10 users × 10 books × 50 chars
    date_borrow_array db 10 dup(10 dup(50 dup('$')))    ; 10 users × 10 books × 50 chars

    ; Book status array (10 users, 10 books per user)
    ; 0 = empty, 1 = occupied (borrowed)
    book_status_array db 10 dup(10 dup(0))

    ; Constants for book system
    MAX_BOOKS_PER_USER equ 10
    MAX_BOOK_FIELD_LENGTH equ 50

    ; Buffer for book input
    book_buffer db 51, ?, 51 dup('$')        ; 50 chars + terminator
    book_id_buffer db 3, ?, 3 dup('$')       ; For book ID input (1-2 digits)
    book_id dw 0                              ; Store parsed book ID

    ; Book-related messages
    enter_book_id db 'Enter book slot (1-10): $'
    slot_occupied db 'Slot already occupied!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    slot_empty db 'Slot is empty!',0ah,'Returning to Submenu...',0ah,0ah,'$'
    book_details_header db 'Book Details:',0ah,'$'
    book_id_display db 'ID: $'
    colon_space db ': $'
    separator_line db '------------------------',0ah,'$'

    ; Empty books message
    no_books_msg db 'No books borrowed.',0ah,'$'

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
    mov al, ' '
    mov bl, 1Fh
    mov bh, 0
    mov cx, 400
    int 10h

    mov ah, 09h
    mov al, ' '
    mov bl, 4Eh
    mov bh, 0
    mov cx, 320
    int 10h

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
    
    mov ah, 09h
    mov al, ' '
    mov bl, 1Fh
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print main menu title
    mov ah, 09h
    mov dx, offset mainmenu
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 31h
    mov bh, 0
    mov cx, 8
    int 10h

    ; Print menu options
    mov ah, 09h
    mov dx, offset option1
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov bh, 0
    mov cx, 21
    int 10h

    mov ah, 09h
    mov dx, offset option2
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 04h
    mov bh, 0
    mov cx, 7
    int 10h

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
    
    mov ah, 09h
    mov al, ' '
    mov bl, 31h
    mov bh, 0
    mov cx, 2400
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
    
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov bh, 0
    mov cx, 2400
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
    
    mov ah, 09h
    mov al, ' '
    mov bl, 1Fh
    mov bh, 0
    mov cx, 2400
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
    
    mov ah, 09h
    mov al, ' '
    mov bl, 31h
    mov bh, 0
    mov cx, 9
    int 10h

    ; Print submenu options
    mov ah, 09h
    mov dx, offset sub_option1
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov bh, 0
    mov cx, 10
    int 10h

    mov ah, 09h
    mov dx, offset sub_option2
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 5Eh
    mov bh, 0
    mov cx, 9
    int 10h

    mov ah, 09h
    mov dx, offset sub_option3
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 20h
    mov bh, 0
    mov cx, 11
    int 10h

    mov ah, 09h
    mov dx, offset sub_option4
    int 21h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 04h
    mov bh, 0
    mov cx, 10
    int 10h

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
    ; Clear screen and show current books
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 31h
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print borrow header
    mov ah, 09h
    mov dx, offset borrow_header
    int 21h
    
    ; Show current book status (similar to read_unreturned_books but simpler)
    call display_simple_slot_status
    
    ; Now get slot choice from user
    call get_slot_choice
    
    ret
borrow_book endp

; Display simple slot status (just slot numbers and empty/occupied)
display_simple_slot_status proc
    
    ; Print slots header
    mov ah, 09h
    mov dx, offset borrow_menu_header
    int 21h
    
    ; Display all 10 slots with simple status
    mov cx, 10                    ; 10 slots total
    mov bx, 1                     ; Slot number (1-based)
    
DisplaySimpleSlotsLoop:
    ; Save registers
    push bx
    push cx
    
    ; Display "Slot X: "
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    ; Display slot number
    mov ax, bx
    call display_number
    
    ; Display colon and space
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Check if slot is occupied
    call check_slot_status        ; Input: BX = slot number (1-based)
    cmp al, 1
    je DisplayOccupiedSimple
    
    ; Slot is empty
    mov ah, 09h
    mov dx, offset empty_msg
    int 21h
    jmp NextSlotSimple
    
DisplayOccupiedSimple:
    ; Slot is occupied
    mov ah, 09h
    mov dx, offset occupied_msg
    int 21h
    
    ; Display just the title (not all details)
    push bx
    dec bx                       ; Convert to 0-based
    mov book_id, bx              ; Store 0-based book ID
    call display_book_title_only ; Display only the book title
    pop bx
    
NextSlotSimple:
    ; New line after each slot
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Restore registers
    pop cx
    pop bx
    
    inc bx                       ; Next slot
    loop DisplaySimpleSlotsLoop
    
    ret
display_simple_slot_status endp

; Display only book title for occupied slot
display_book_title_only proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Calculate offset for title in title_array
    ; offset = (user_index * 2500) + (book_id * 250) + 50
    ; 50 bytes offset for title field (after author)
    
    ; User offset
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user offset
    
    ; Book offset
    mov ax, book_id
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book offset
    
    ; Title field offset (field 1 = 50 bytes after start)
    add di, 50                   ; Skip author field
    
    ; Add array base address
    add di, offset title_array
    
    ; Check if title is empty (just '$')
    mov si, di
    cmp byte ptr [si], '$'
    je DisplayEmptyTitle
    
    ; Display the title
    call print_string
    jmp DisplayDoneTitle
    
DisplayEmptyTitle:
    ; Display placeholder for empty title
    mov ah, 09h
    mov dx, offset space
    int 21h
    
DisplayDoneTitle:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_book_title_only endp

; Get slot choice from user (same as before)
get_slot_choice proc
    ; Print choose slot prompt
    mov ah, 09h
    mov dx, offset choose_slot_msg
    int 21h
    
    ; Read slot number
    mov dx, offset book_id_buffer
    mov cx, 3                     ; Max 2 digits + enter
    call read_string_3fh
    
    ; Convert to number
    call parse_book_id
    cmp ax, 1
    jl InvalidSlot
    cmp ax, 10
    jg InvalidSlot
    
    ; Valid slot number
    mov book_id, ax              ; Store 1-based ID temporarily
    
    ; Check if slot is already occupied
    mov bx, ax                   ; BX = slot number (1-based)
    call check_slot_status
    cmp al, 1
    je SlotOccupiedError
    
    ; Slot is available - get book details
    call get_book_details_for_slot
    ret
    
InvalidSlot:
    ; Print error message
    mov ah, 09h
    mov dx, offset invalid_slot_msg
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to borrow menu
    call submenu_main
    ret
    
SlotOccupiedError:
    ; Print error message
    mov ah, 09h
    mov dx, offset slot_occupied
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to borrow menu
    call submenu_main
    ret
    
get_slot_choice endp
; Parse book ID from string to number (simpler version)
; Input: book_id_buffer contains the string
; Returns: AX = parsed number (0 if invalid or out of range 1-10)
parse_book_id proc
    push si
    push bx
    push cx
    
    mov si, offset book_id_buffer
    xor ax, ax                    ; Clear AX for result
    xor bx, bx                    ; Clear BX for temporary storage
    xor cx, cx                    ; Character counter
    
ReadLoop:
    mov bl, [si]
    
    ; Check for string terminators
    cmp bl, '$'
    je EndOfString
    cmp bl, 0Dh                   ; Carriage return
    je EndOfString
    cmp bl, 0Ah                   ; Line feed
    je EndOfString
    
    ; Check if digit
    cmp bl, '0'
    jl ParseError
    cmp bl, '9'
    jg ParseError
    
    ; Convert ASCII to digit
    sub bl, '0'
    
    ; Multiply current result by 10
    mov cx, 10
    mul cx                       ; AX = AX * 10
    
    ; Add new digit
    add ax, bx
    
    ; Check if we've read too many digits
    inc si
    cmp ax, 10                   ; Already exceeds max?
    jg ParseError
    
    jmp ReadLoop
    
EndOfString:
    ; Check if we got at least one digit
    cmp ax, 0
    je ParseError
    
    ; Validate range (1-10)
    cmp ax, 1
    jl ParseError
    cmp ax, 10
    jg ParseError
    
    jmp ParseDone
    
ParseError:
    xor ax, ax                    ; Return 0 for error
    
ParseDone:
    pop cx
    pop bx
    pop si
    ret
parse_book_id endp
; Store book field to appropriate array
; Uses current_field_counter to determine which array
; 0 = author, 1 = title, 2 = publisher, 3 = date published, 4 = date borrowed
store_book_field_to_array proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Calculate base offset for user's books
    ; Total size per user = 10 books × 5 fields × 50 chars = 2500 bytes
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user base offset
    
    ; Calculate book offset within user
    ; Each book has 5 fields × 50 chars = 250 bytes
    mov ax, book_id              ; 0-based book ID
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book base offset
    
    ; Calculate field offset within book
    ; Each field is 50 bytes
    mov ax, current_field_counter
    mov bx, 50                   ; Bytes per field
    mul bx
    add di, ax                   ; DI = final offset
    
    ; Determine which array to write to based on current_field_counter
    mov ax, current_field_counter
    cmp ax, 0
    je StoreToAuthor
    cmp ax, 1
    je StoreToTitle
    cmp ax, 2
    je StoreToPublisher
    cmp ax, 3
    je StoreToDatePub
    ; Else store to date borrowed
    
StoreToDateBorrow:
    add di, offset date_borrow_array
    jmp CopyFieldData
    
StoreToAuthor:
    add di, offset author_array
    jmp CopyFieldData
    
StoreToTitle:
    add di, offset title_array
    jmp CopyFieldData
    
StoreToPublisher:
    add di, offset publisher_array
    jmp CopyFieldData
    
StoreToDatePub:
    add di, offset date_pub_array
    
CopyFieldData:
    ; Copy from book_buffer to array
    mov si, offset book_buffer
    
CopyFieldLoop:
    mov al, [si]
    cmp al, '$'
    je CopyFieldDone
    cmp al, 0Dh                  ; Skip carriage return
    je SkipChar
    cmp al, 0Ah                  ; Skip line feed
    je SkipChar
    mov [di], al
    inc di
SkipChar:
    inc si
    jmp CopyFieldLoop
    
CopyFieldDone:
    ; Terminate with '$'
    mov byte ptr [di], '$'
    
    ; Increment field counter for next call
    inc current_field_counter
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
store_book_field_to_array endp

; Display book title for a specific slot
; Input: book_id = slot number (0-based)
display_book_title proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Calculate offset for title in title_array
    ; offset = (user_index * 2500) + (book_id * 250) + (1 * 50)
    ; Field 1 = title (after author which is field 0)
    
    ; User offset
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user offset
    
    ; Book offset
    mov ax, book_id
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book offset
    
    ; Title field offset (field 1 = 50 bytes after start)
    add di, 50                   ; Skip author field
    
    ; Add array base address
    add di, offset title_array
    
    ; Display the title
    mov si, di
    call print_string
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_book_title endp

; Mark current slot as occupied
mark_slot_occupied proc
    push ax
    push bx
    push si
    
    ; Calculate offset: (user_index * 10) + book_slot
    mov ax, current_index
    mov bx, 10                    ; MAX_BOOKS_PER_USER
    mul bx
    add ax, book_id              ; book_id is 0-based
    
    mov si, offset book_status_array
    add si, ax
    
    mov byte ptr [si], 1        ; Mark as occupied
    
    pop si
    pop bx
    pop ax
    ret
mark_slot_occupied endp



; ==================== RENEWAL FUNCTION ====================
renew_book proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print renew header
    mov ah, 09h
    mov dx, offset renew_header
    int 21h
    
    ; Check if user has any books to renew
    call count_user_books
    cmp ax, 0
    je NoBooksToRenew
    
    ; Display occupied books only (similar to return function)
    call display_occupied_books_for_renew
    
    ; Ask for book ID to renew
    call get_book_to_renew
    
    ret
    
NoBooksToRenew:
    ; No books to renew
    mov ah, 09h
    mov dx, offset no_books_to_renew_msg
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
renew_book endp

; ==================== DISPLAY OCCUPIED BOOKS FOR RENEW ====================
; Display only occupied books with their details
display_occupied_books_for_renew proc
    ; Print instruction
    mov ah, 09h
    mov dx, offset unreturned_books_renew_msg
    int 21h
    
    ; Initialize
    mov cx, 10                    ; 10 slots total
    mov bx, 1                     ; Slot number (1-based)
    mov books_found_renew, 0      ; Counter for found books
    
DisplayOccupiedLoopRenew:
    ; Save registers
    push bx
    push cx
    
    ; Check if slot is occupied
    call check_slot_status        ; Input: BX = slot number (1-based)
    cmp al, 1
    jne NextSlotRenew             ; Skip if empty
    
    ; Slot is occupied - display it
    inc books_found_renew         ; Increment found counter
    
    ; Display separator line
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; Display "Slot X: "
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    ; Display slot number
    mov ax, bx
    call display_number
    
    ; Display colon and space
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Display book details
    push bx
    dec bx                       ; Convert to 0-based
    mov book_id, bx              ; Store 0-based book ID
    
    ; Display title, author, and current date borrowed
    call display_book_for_renew   ; Show title, author, and current date
    
    pop bx
    
    ; New line after book
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
NextSlotRenew:
    ; Restore registers
    pop cx
    pop bx
    
    inc bx                       ; Next slot
    loop DisplayOccupiedLoopRenew
    
    ; Display final separator
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; If no books found
    cmp books_found_renew, 0
    je NoBooksFoundRenew
    
    ret
    
NoBooksFoundRenew:
    ; This shouldn't happen, but just in case
    mov ah, 09h
    mov dx, offset no_books_to_renew_msg
    int 21h
    
    ; Wait for key and return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
display_occupied_books_for_renew endp

; ==================== DISPLAY BOOK FOR RENEW ====================
; Display title, author, and current date borrowed for renew view
; Input: book_id = slot number (0-based)
display_book_for_renew proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; First display title and author
    ; Calculate offset for title in title_array
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user offset
    
    mov ax, book_id
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book offset
    
    ; Title field offset (field 1 = 50 bytes after start)
    mov si, di
    add si, 50                   ; Skip author field
    add si, offset title_array   ; Add array base
    
    ; Display title
    call print_string
    
    ; Display " by " separator
    mov ah, 09h
    mov dx, offset by_separator
    int 21h
    
    ; Now display author
    ; Calculate offset for author in author_array
    mov si, di
    add si, offset author_array   ; Add array base
    
    ; Display author
    call print_string
    
    ; New line for date information
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Display current date borrowed
    mov ah, 09h
    mov dx, offset current_date_label
    int 21h
    
    ; Calculate offset for date borrowed in date_borrow_array
    ; Field 4 = 200 bytes after start (4 fields × 50 bytes)
    mov si, di
    add si, 200                  ; Skip to field 4 (date borrowed)
    add si, offset date_borrow_array
    
    ; Display current date borrowed
    call print_string
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_book_for_renew endp

; ==================== GET BOOK TO RENEW ====================
; Ask user which book to renew
get_book_to_renew proc
    ; Print choose book prompt
    mov ah, 09h
    mov dx, offset enter_id_renew
    int 21h
    
    ; Read slot number
    mov dx, offset book_id_buffer
    mov cx, 3                     ; Max 2 digits + enter
    call read_string_3fh
    
    ; Convert to number
    call parse_book_id
    cmp ax, 1
    jl InvalidBookIDRenew
    cmp ax, 10
    jg InvalidBookIDRenew
    
    ; Valid slot number (1-based)
    mov renew_slot, ax          ; Store 1-based slot
    
    ; Check if slot is occupied
    mov bx, ax                   ; BX = slot number (1-based)
    call check_slot_status
    cmp al, 1
    jne SlotEmptyRenew
    
    ; Slot is occupied - get new date
    call get_new_date_and_renew
    ret
    
InvalidBookIDRenew:
    ; Print error message
    mov ah, 09h
    mov dx, offset invalid_id
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
    
SlotEmptyRenew:
    ; Print error message
    mov ah, 09h
    mov dx, offset slot_empty_renew_msg
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
    
get_book_to_renew endp

; ==================== GET NEW DATE AND RENEW ====================
; Get new date borrowed and update the book
get_new_date_and_renew proc
    ; Convert renew_slot to 0-based
    mov ax, renew_slot
    dec ax
    mov book_id, ax              ; Store 0-based book ID
    
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 70h
    mov bh, 0
    mov cx, 2400
    int 10h
    
    ; Print renew header
    mov ah, 09h
    mov dx, offset renew_header
    int 21h
    
    ; Display book being renewed
    mov ah, 09h
    mov dx, offset renewing_book_msg
    int 21h
    
    ; Display slot number
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    mov ax, renew_slot
    call display_number
    
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Display book title and author
    call display_book_for_renew
    
    ; Ask for new date
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    mov ah, 09h
    mov dx, offset new_date_borrowed
    int 21h
    
    ; Read new date
    mov dx, offset book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    
    ; Update date borrowed field
    call update_date_borrowed
    
    ; Display success message
    mov ah, 09h
    mov dx, offset borrow_renewed
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
get_new_date_and_renew endp

; ==================== UPDATE DATE BORROWED ====================
; Update the date borrowed field for the current book
update_date_borrowed proc
    push ax
    push bx
    push cx
    push si
    push di
    
    ; Calculate offset for date borrowed field
    ; Total size per user = 10 books × 5 fields × 50 chars = 2500 bytes
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user base offset
    
    ; Calculate book offset within user
    mov ax, book_id              ; 0-based book ID
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book base offset
    
    ; Date borrowed is field 4 = 200 bytes offset (4 fields × 50 bytes)
    add di, 200                  ; Skip to field 4
    
    ; Add date borrowed array base
    add di, offset date_borrow_array
    
    ; Copy new date from book_buffer to array
    mov si, offset book_buffer
    
CopyNewDateLoop:
    mov al, [si]
    cmp al, '$'
    je CopyNewDateDone
    cmp al, 0Dh                  ; Skip carriage return
    je SkipDateChar
    cmp al, 0Ah                  ; Skip line feed
    je SkipDateChar
    
    mov [di], al
    inc di
    
SkipDateChar:
    inc si
    jmp CopyNewDateLoop
    
CopyNewDateDone:
    ; Terminate with '$'
    mov byte ptr [di], '$'
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
update_date_borrowed endp

; ==================== RETURN BOOK FUNCTION ====================
return_book proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 5Eh
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print return header
    mov ah, 09h
    mov dx, offset return_header
    int 21h
    
    ; Check if user has any books to return
    call count_user_books
    cmp ax, 0
    je NoBooksToReturn
    
    ; Display occupied books only
    call display_occupied_books_for_return
    
    ; Ask for book ID to return
    call get_book_to_return
    
    ret
    
NoBooksToReturn:
    ; No books to return
    mov ah, 09h
    mov dx, offset no_books_to_return_msg
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
return_book endp

; ==================== DISPLAY OCCUPIED BOOKS FOR RETURN ====================
; Display only occupied books with their details
display_occupied_books_for_return proc
    ; Print instruction
    mov ah, 09h
    mov dx, offset unreturned_books_list_msg
    int 21h
    
    ; Initialize
    mov cx, 10                    ; 10 slots total
    mov bx, 1                     ; Slot number (1-based)
    mov books_found, 0            ; Counter for found books
    
DisplayOccupiedLoop:
    ; Save registers
    push bx
    push cx
    
    ; Check if slot is occupied
    call check_slot_status        ; Input: BX = slot number (1-based)
    cmp al, 1
    jne NextSlotReturn            ; Skip if empty
    
    ; Slot is occupied - display it
    inc books_found               ; Increment found counter
    
    ; Display separator line
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; Display "Slot X: "
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    ; Display slot number
    mov ax, bx
    call display_number
    
    ; Display colon and space
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Display book details
    push bx
    dec bx                       ; Convert to 0-based
    mov book_id, bx              ; Store 0-based book ID
    
    ; Display title and author (brief info)
    call display_book_brief_info  ; Show title and author only
    
    pop bx
    
    ; New line after book
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
NextSlotReturn:
    ; Restore registers
    pop cx
    pop bx
    
    inc bx                       ; Next slot
    loop DisplayOccupiedLoop
    
    ; Display final separator
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; If no books found (shouldn't happen since we checked earlier)
    cmp books_found, 0
    je NoBooksFoundReturn
    
    ret
    
NoBooksFoundReturn:
    ; This shouldn't happen, but just in case
    mov ah, 09h
    mov dx, offset no_books_to_return_msg
    int 21h
    
    ; Wait for key and return to submenu
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    call submenu_main
    ret
display_occupied_books_for_return endp

; ==================== DISPLAY BOOK BRIEF INFO ====================
; Display only title and author for occupied book
; Input: book_id = slot number (0-based)
display_book_brief_info proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; First display title
    ; Calculate offset for title in title_array
    ; offset = (user_index * 2500) + (book_id * 250) + 50
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user offset
    
    mov ax, book_id
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book offset
    
    ; Title field offset (field 1 = 50 bytes after start)
    add di, 50                   ; Skip author field
    add di, offset title_array   ; Add array base
    
    ; Display title label
    mov ah, 09h
    mov dx, offset title_prompt
    int 21h
    
    ; Display the title
    mov si, di
    call print_string
    
    ; Display comma separator
    mov ah, 09h
    mov dx, offset comma
    int 21h
    
    ; Now display author
    ; Calculate offset for author in author_array
    ; offset = (user_index * 2500) + (book_id * 250)
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user offset
    
    mov ax, book_id
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book offset
    
    add di, offset author_array   ; Add array base
    
    ; Display author label
    mov ah, 09h
    mov dx, offset author_prompt
    int 21h
    
    ; Display the author
    mov si, di
    call print_string
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_book_brief_info endp

; ==================== GET BOOK TO RETURN ====================
; Ask user which book to return
get_book_to_return proc
    ; Print choose book prompt
    mov ah, 09h
    mov dx, offset enter_id_return
    int 21h
    
    ; Read slot number
    mov dx, offset book_id_buffer
    mov cx, 3                     ; Max 2 digits + enter
    call read_string_3fh
    
    ; Convert to number
    call parse_book_id
    cmp ax, 1
    jl InvalidBookIDReturn
    cmp ax, 10
    jg InvalidBookIDReturn
    
    ; Valid slot number (1-based)
    mov return_slot, ax          ; Store 1-based slot
    
    ; Check if slot is occupied
    mov bx, ax                   ; BX = slot number (1-based)
    call check_slot_status
    cmp al, 1
    jne SlotEmptyReturn
    
    ; Slot is occupied - confirm return
    call confirm_and_return_book
    ret
    
InvalidBookIDReturn:
    ; Print error message
    mov ah, 09h
    mov dx, offset invalid_id
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
    
SlotEmptyReturn:
    ; Print error message
    mov ah, 09h
    mov dx, offset slot_empty_return_msg
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
    
get_book_to_return endp

; ==================== CONFIRM AND RETURN BOOK ====================
; Confirm return and clear book data
confirm_and_return_book proc
    ; Convert return_slot to 0-based
    mov ax, return_slot
    dec ax
    mov book_id, ax              ; Store 0-based book ID
    
    ; Display book being returned
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 5Eh
    mov bh, 0
    mov cx, 2400
    int 10h

    mov ah, 09h
    mov dx, offset return_header
    int 21h
    
    mov ah, 09h
    mov dx, offset returning_book_msg
    int 21h
    
    ; Display slot number
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    mov ax, return_slot
    call display_number
    
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Display book details
    call display_all_book_details
    
    ; Ask for confirmation
    mov ah, 09h
    mov dx, offset confirm_return_msg
    int 21h
    
    ; Get confirmation (Y/N)
    mov ah, 01h
    int 21h
    
    ; Handle new line
    push ax
    mov ah, 02h
    mov dl, 0ah
    int 21h
    pop ax
    
    ; Check response
    cmp al, 'Y'
    je DoReturnBook
    cmp al, 'y'
    je DoReturnBook
    
    ; User cancelled
    mov ah, 09h
    mov dx, offset return_cancelled_msg
    int 21h
    
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
    
DoReturnBook:
    ; Clear book data from arrays
    call clear_book_data
    
    ; Mark slot as empty
    call mark_slot_empty
    
    ; Display success message
    mov ah, 09h
    mov dx, offset book_returned
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
confirm_and_return_book endp

; ==================== CLEAR BOOK DATA ====================
; Clear all book data for the specified slot
clear_book_data proc
    push ax
    push bx
    push cx
    push si
    push di
    
    ; Calculate base offset for user's books
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user base offset
    
    ; Calculate book offset within user
    mov ax, book_id              ; 0-based book ID
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book base offset
    
    ; Clear all 5 fields (250 bytes)
    mov cx, 250                  ; Total bytes to clear
    
    ; Clear author array
    mov si, offset author_array
    add si, di
    call clear_field_memory
    
    ; Clear title array
    mov si, offset title_array
    add si, di
    call clear_field_memory
    
    ; Clear publisher array
    mov si, offset publisher_array
    add si, di
    call clear_field_memory
    
    ; Clear date published array
    mov si, offset date_pub_array
    add si, di
    call clear_field_memory
    
    ; Clear date borrowed array
    mov si, offset date_borrow_array
    add si, di
    call clear_field_memory
    
    pop di
    pop si
    pop cx
    pop bx
    pop ax
    ret
clear_book_data endp

; ==================== CLEAR FIELD MEMORY ====================
; Clear 250 bytes of memory starting at SI
clear_field_memory proc
    push ax
    push cx
    push di
    
    mov di, si
    mov cx, 250                  ; Clear 250 bytes (5 fields × 50 chars)
    mov al, '$'                  ; Fill with string terminators
    
ClearLoop:
    mov [di], al
    inc di
    loop ClearLoop
    
    pop di
    pop cx
    pop ax
    ret
clear_field_memory endp

; ==================== MARK SLOT EMPTY ====================
; Mark current slot as empty in status array
mark_slot_empty proc
    push ax
    push bx
    push si
    
    ; Calculate offset: (user_index * 10) + book_slot
    mov ax, current_index
    mov bx, 10                    ; MAX_BOOKS_PER_USER
    mul bx
    add ax, book_id              ; book_id is 0-based
    
    mov si, offset book_status_array
    add si, ax
    
    mov byte ptr [si], 0        ; Mark as empty
    
    pop si
    pop bx
    pop ax
    ret
mark_slot_empty endp

; ==================== COUNT USER BOOKS ====================
; Count how many books a user has borrowed
; Returns: AX = count
count_user_books proc
    push cx
    push si
    
    mov cx, MAX_BOOKS_PER_USER
    mov ax, current_index
    mov bx, MAX_BOOKS_PER_USER
    mul bx
    mov si, offset book_status_array
    add si, ax                  ; SI points to user's status array
    
    xor ax, ax                  ; Counter
    
CountLoop:
    cmp byte ptr [si], 1
    jne NotOccupied
    inc ax
NotOccupied:
    inc si
    loop CountLoop
    
    pop si
    pop cx
    ret
count_user_books endp

; ==================== READ UNRETURNED BOOKS (ONLY OCCUPIED) ====================
read_unreturned_books proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 20h
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print header
    mov ah, 09h
    mov dx, offset read_header
    int 21h
    
    ; Check if user has any books
    call count_user_books
    cmp ax, 0
    je NoBooksToRead
    
    ; Display only occupied books
    call display_occupied_books_for_read
    
    ret
    
NoBooksToRead:
    ; No books borrowed
    mov ah, 09h
    mov dx, offset no_books_msg
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
read_unreturned_books endp

; ==================== DISPLAY OCCUPIED BOOKS FOR READ ====================
; Display only occupied books with full details
display_occupied_books_for_read proc

    ; Initialize pagination
    mov current_slot_display, 1      ; Start from slot 1
    mov current_page, 1              ; Start from page 1
    mov books_displayed, 0           ; Counter for books displayed
    mov total_books_found, 0         ; Counter for total books found
    
    ; First, count total occupied books
    call count_user_books
    mov total_books_found, ax
    
    ; Calculate total pages needed
    mov ax, total_books_found
    mov bx, 2                        ; 2 books per page
    xor dx, dx
    div bx                           ; AX = total_books / 2 
    cmp dx, 0                        ; Check remainder
    je NoRemainder
    inc ax                           ; Add extra page for remainder
NoRemainder:
    mov total_pages_needed, ax
    
DisplayPageRead:
    ; Clear screen for new page
    mov ax, 0003h
    int 10h
    push cx
    push bx 
    mov ah, 09h
    mov al, ' '
    mov bl, 20h
    mov bh, 0
    mov cx, 2400
    int 10h

    pop bx
    pop cx
    ; Print header with page info
    mov ah, 09h
    mov dx, offset read_header
    int 21h
    
    ; Display page number
    mov ah, 09h
    mov dx, offset page_header_read
    int 21h
    
    mov ax, current_page
    call display_number
    
    mov ah, 09h
    mov dx, offset page_of_msg_read
    int 21h
    
    mov ax, total_pages_needed
    call display_number
    
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Reset books displayed counter for this page
    mov books_displayed, 0
    
    ; Start searching for occupied books from current slot
    mov bx, current_slot_display
    
FindBooksForPage:
    ; Check if we've checked all 10 slots
    cmp bx, 10
    jg PageComplete
    
    ; Check if slot is occupied
    push bx
    call check_slot_status
    pop bx
    cmp al, 1
    jne ContinueSearching
    
    ; Found an occupied book - display it
    inc books_displayed
    
    ; Display separator line
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; Display "Slot X: "
    mov ah, 09h
    mov dx, offset slot_format
    int 21h
    
    ; Display slot number
    mov ax, bx
    call display_number
    
    ; Display colon and space
    mov ah, 02h
    mov dl, ':'
    int 21h
    mov dl, ' '
    int 21h
    
    ; Display full book details
    push bx
    dec bx                       ; Convert to 0-based
    mov book_id, bx              ; Store 0-based book ID
    
    ; Display all book details
    call display_all_book_details_read ; Display full book details
    
    pop bx
    
    ; Check if we've displayed 2 books for this page
    mov ax, books_displayed
    cmp ax, 2
    je PageComplete
    
ContinueSearching:
    inc bx
    jmp FindBooksForPage
    
PageComplete:
    ; Update current_slot_display for next page
    inc bx
    mov current_slot_display, bx
    
    ; Display final separator
    mov ah, 09h
    mov dx, offset separator_line
    int 21h
    
    ; Check if we have more books to display
    mov bx, current_slot_display
    cmp bx, 10
    jg AllBooksDisplayed
    
    ; Check if we found any books on this page
    cmp books_displayed, 0
    je AllBooksDisplayed          ; No books found, we're done
    
    ; Display continue prompt
    mov ah, 09h
    mov dx, offset continue_prompt_read
    int 21h
    
    ; Wait for any key press
    mov ah, 07h
    int 21h
    
    ; Increment page number
    inc current_page
    
    ; Continue with next page
    jmp DisplayPageRead
    
AllBooksDisplayed:
    ; Display completion message
    mov ah, 09h
    mov dx, offset end_of_list_read_msg
    int 21h
    
    ; Display book count
    mov ah, 09h
    mov dx, offset total_books_msg
    int 21h
    
    mov ax, total_books_found
    call display_number
    
    mov ah, 09h
    mov dx, offset books_found_msg
    int 21h
    
    ; Wait for key press to return
    mov ah, 09h
    mov dx, offset press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
display_occupied_books_for_read endp

; ==================== DISPLAY ALL BOOK DETAILS FOR READ ====================
; Display all details for a book (optimized for read view)
; Input: book_id = slot number (0-based)
display_all_book_details_read proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Set up field counter
    mov current_field_counter, 0
    
DisplayFieldLoopRead:
    ; Get the field based on current_field_counter
    mov ax, current_field_counter
    
    cmp ax, 0
    je DisplayAuthorRead
    cmp ax, 1
    je DisplayTitleRead
    cmp ax, 2
    je DisplayPublisherRead
    cmp ax, 3
    je DisplayDatePubRead
    cmp ax, 4
    je DisplayDateBorrowRead
    jmp DisplayDoneRead
    
DisplayAuthorRead:
    ; New line for first field
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Display author label
    mov ah, 09h
    mov dx, offset author_prompt
    int 21h
    call display_specific_field
    jmp NextFieldRead
    
DisplayTitleRead:
    ; Display title label
    mov ah, 09h
    mov dx, offset title_prompt
    int 21h
    call display_specific_field
    jmp NextFieldRead
    
DisplayPublisherRead:
    ; Display publisher label
    mov ah, 09h
    mov dx, offset publisher_prompt
    int 21h
    call display_specific_field
    jmp NextFieldRead
    
DisplayDatePubRead:
    ; Display date published label
    mov ah, 09h
    mov dx, offset date_published_prompt
    int 21h
    call display_specific_field
    jmp NextFieldRead
    
DisplayDateBorrowRead:
    ; Display date borrowed label
    mov ah, 09h
    mov dx, offset date_borrowed_prompt
    int 21h
    call display_specific_field
    jmp DisplayDoneRead
    
NextFieldRead:
    ; Move to next line
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Increment field counter
    inc current_field_counter
    jmp DisplayFieldLoopRead
    
DisplayDoneRead:
    ; Add extra newline after book details
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_all_book_details_read endp

; ==================== DISPLAY ALL BOOK DETAILS ====================
; Display all details for a book
; Input: book_id = slot number (0-based)
display_all_book_details proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Reset field counter
    mov current_field_counter, 0
    
DisplayFieldLoop:
    ; Get the field based on current_field_counter
    mov ax, current_field_counter
    
    cmp ax, 0
    je DisplayAuthor
    cmp ax, 1
    je DisplayTitle
    cmp ax, 2
    je DisplayPublisher
    cmp ax, 3
    je DisplayDatePub
    cmp ax, 4
    je DisplayDateBorrow
    jmp DisplayDone
    
DisplayAuthor:
    ; New line for first field
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Display author label
    mov ah, 09h
    mov dx, offset author_prompt
    int 21h
    call display_specific_field
    jmp NextField
    
DisplayTitle:
    ; Display title label
    mov ah, 09h
    mov dx, offset title_prompt
    int 21h
    call display_specific_field
    jmp NextField
    
DisplayPublisher:
    ; Display publisher label
    mov ah, 09h
    mov dx, offset publisher_prompt
    int 21h
    call display_specific_field
    jmp NextField
    
DisplayDatePub:
    ; Display date published label
    mov ah, 09h
    mov dx, offset date_published_prompt
    int 21h
    call display_specific_field
    jmp NextField
    
DisplayDateBorrow:
    ; Display date borrowed label
    mov ah, 09h
    mov dx, offset date_borrowed_prompt
    int 21h
    call display_specific_field
    jmp DisplayDone
    
NextField:
    ; Move to next line
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Increment field counter
    inc current_field_counter
    jmp DisplayFieldLoop
    
DisplayDone:
    ; Add extra newline after book details
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_all_book_details endp

; ==================== DISPLAY SPECIFIC FIELD ====================
; Display a specific field for the current book
; Input: current_field_counter = which field to display
display_specific_field proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Calculate base offset for user's books
    ; Total size per user = 10 books × 5 fields × 50 chars = 2500 bytes
    mov ax, current_index
    mov bx, 2500                  ; Bytes per user
    mul bx
    mov di, ax                   ; DI = user base offset
    
    ; Calculate book offset within user
    mov ax, book_id              ; 0-based book ID
    mov bx, 250                  ; Bytes per book
    mul bx
    add di, ax                   ; DI = book base offset
    
    ; Calculate field offset within book
    mov ax, current_field_counter
    mov bx, 50                   ; Bytes per field
    mul bx
    add di, ax                   ; DI = final offset
    
    ; Determine which array to read from based on current_field_counter
    mov ax, current_field_counter
    cmp ax, 0
    je ReadFromAuthor
    cmp ax, 1
    je ReadFromTitle
    cmp ax, 2
    je ReadFromPublisher
    cmp ax, 3
    je ReadFromDatePub
    ; Else read from date borrowed (field 4)
    
ReadFromDateBorrow:
    add di, offset date_borrow_array
    jmp DisplayFieldData
    
ReadFromAuthor:
    add di, offset author_array
    jmp DisplayFieldData
    
ReadFromTitle:
    add di, offset title_array
    jmp DisplayFieldData
    
ReadFromPublisher:
    add di, offset publisher_array
    jmp DisplayFieldData
    
ReadFromDatePub:
    add di, offset date_pub_array
    
DisplayFieldData:
    ; Display the field content
    mov si, di
    call print_string
    
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_specific_field endp

; Display a 1 or 2 digit number
; Input: AX = number to display (0-99)
display_number proc
    push ax
    push bx
    push dx
    
    cmp ax, 10
    jl SingleDigit
    
    ; Two-digit number
    mov bl, 10
    div bl                      ; AL = tens, AH = units
    
    ; Display tens digit
    push ax                     ; Save AH (units)
    mov dl, al
    add dl, '0'
    mov ah, 02h
    int 21h
    
    ; Display units digit
    pop ax                      ; Restore AH (units)
    mov dl, ah
    add dl, '0'
    mov ah, 02h
    int 21h
    
    jmp DisplayDone1
    
SingleDigit:
    ; Single-digit number
    add ax, '0'
    mov dl, al
    mov ah, 02h
    int 21h
    
DisplayDone1:
    pop dx
    pop bx
    pop ax
    ret
display_number endp

; Check if a slot is occupied
; Input: BX = slot number (1-based)
; Returns: AL = 1 if occupied, 0 if empty
check_slot_status proc
    push bx
    push si
    push cx
    
    ; Convert to 0-based
    dec bx
    
    ; Calculate offset in status array
    ; offset = (user_index * 10) + slot_index
    mov ax, current_index
    mov cx, 10                    ; MAX_BOOKS_PER_USER
    mul cx                       ; AX = user_index * 10
    add ax, bx                   ; Add slot index
    
    mov si, offset book_status_array
    add si, ax                   ; SI points to the status byte
    
    mov al, [si]                ; Get status (0 or 1)
    
    pop cx
    pop si
    pop bx
    ret
check_slot_status endp

; Get book details for chosen slot
get_book_details_for_slot proc
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    mov ah, 09h
    mov al, ' '
    mov bl, 31h
    mov bh, 0
    mov cx, 2400
    int 10h

    ; Print header
    mov ah, 09h
    mov dx, offset borrow_header
    int 21h
    
    ; Print book details prompt
    mov ah, 09h
    lea dx, book_details_prompt
    int 21h
    
    ; Convert book_id to 0-based and store
    mov ax, book_id
    dec ax                      ; Make it 0-based (it was 1-based from user input)
    mov book_id, ax
    
    ; Reset field counter
    mov current_field_counter, 0
    
    ; Get Author
    mov ah, 09h
    lea dx, author_prompt
    int 21h
    lea dx, book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    call store_book_field_to_array  ; Field 0 = Author
    
    ; Get Title
    mov ah, 09h
    lea dx, title_prompt
    int 21h
    lea dx, book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    call store_book_field_to_array  ; Field 1 = Title
    
    ; Get Publisher
    mov ah, 09h
    lea dx, publisher_prompt
    int 21h
    lea dx, book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    call store_book_field_to_array  ; Field 2 = Publisher
    
    ; Get Date Published
    mov ah, 09h
    lea dx, date_published_prompt
    int 21h
    lea dx, book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    call store_book_field_to_array  ; Field 3 = Date Published
    
    ; Get Date Borrowed
    mov ah, 09h
    lea dx, date_borrowed_prompt
    int 21h
    lea dx, book_buffer
    mov cx, MAX_BOOK_FIELD_LENGTH
    call read_string_3fh
    call store_book_field_to_array  ; Field 4 = Date Borrowed
    
    ; Mark slot as occupied
    call mark_slot_occupied
    
    ; Display success message
    mov ah, 09h
    lea dx, book_borrowed_msg
    int 21h
    
    ; Wait for key press
    mov ah, 09h
    lea dx, press_any_key
    int 21h
    mov ah, 07h
    int 21h
    
    ; Return to submenu
    call submenu_main
    ret
get_book_details_for_slot endp

exit_program proc
    ; Exit function implementation here
    mov ah, 09h
    mov al, ' '
    mov bl, 14h
    mov bh, 0
    mov cx, 2400
    int 10h

    mov ah, 09h
    lea dx, exit_msg
    int 21h 
    ret
exit_program endp

end start
