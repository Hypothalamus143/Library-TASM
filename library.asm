; Filename: FINAl-PROJECT.ASM
; Programmer Name: JOHN PRINCE ALONTE
; Date: November 28, 2025
; Description: Library Borrowing System

.model small
.stack 100h
.data

    ; Add these after your existing messages
    borrow_menu_header db 'Available Slots:',0ah,'$'
    slot_format db '  Slot $'
    occupied_msg db ': [OCCUPIED] $'
    empty_msg db ': [EMPTY] $'
    choose_slot_msg db 0ah,'Choose slot to borrow (1-10): $'
    invalid_slot_msg db 'Invalid slot! Must be 1-10.',0ah,'$'
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
    ; Clear screen and show current books
    mov ax, 0003h
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
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print header
    mov ah, 09h
    mov dx, offset borrow_header
    int 21h
    
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
    call display_simple_slot_status
    call get_slot_choice
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
    call display_simple_slot_status
    call get_slot_choice
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
    ; Clear screen
    mov ax, 0003h
    int 10h
    
    ; Print header
    mov ah, 09h
    mov dx, offset read_header
    int 21h
    
    ; Check if user has any books
    call count_user_books
    cmp ax, 0
    je NoBooksMessage
    
    ; Display all 10 slots with details
    mov cx, 10                    ; 10 slots total
    mov bx, 1                     ; Slot number (1-based)
    
DisplayAllSlotsLoop:
    ; Save registers
    push bx
    push cx
    
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
    
    ; Check if slot is occupied
    call check_slot_status        ; Input: BX = slot number (1-based)
    cmp al, 1
    je DisplayOccupiedSlotCompact
    
    ; Slot is empty
    mov ah, 09h
    mov dx, offset empty_msg
    int 21h
    jmp NextSlotComplete
    
DisplayOccupiedSlotCompact:
    ; Slot is occupied - display all details in compact format
    push bx
    dec bx                       ; Convert to 0-based
    mov book_id, bx              ; Store 0-based book ID
    call display_book_details_compact ; Display all details separated by commas
    pop bx
    
NextSlotComplete:
    ; New line after each slot
    mov ah, 09h
    mov dx, offset newline
    int 21h
    
    ; Restore registers
    pop cx
    pop bx
    
    inc bx                       ; Next slot
    loop DisplayAllSlotsLoop
    
    jmp WaitForKeyPress
    
NoBooksMessage:
    mov ah, 09h
    mov dx, offset no_books_msg
    int 21h
    
WaitForKeyPress:
    ; Display final separator
    mov ah, 09h
    mov dx, offset separator_line
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

; Display book details in compact format (comma separated)
; Input: book_id = slot number (0-based)
display_book_details_compact proc
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    
    ; Reset field counter
    mov current_field_counter, 0
    
DisplayCompactFieldLoop:
    ; Get and display the field
    call get_and_display_field_compact
    
    ; Check if we've displayed all 5 fields
    inc current_field_counter
    cmp current_field_counter, 5
    jl AddCommaSeparator
    
    ; All fields displayed
    jmp DisplayCompactDone
    
AddCommaSeparator:
    ; Add comma and space between fields (except after last field)
    mov ah, 09h
    mov dx, offset comma          ; ", "
    int 21h
    
    jmp DisplayCompactFieldLoop
    
DisplayCompactDone:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
display_book_details_compact endp

; Get and display a specific field in compact format
get_and_display_field_compact proc
    push ax
    push bx
    push cx
    push dx
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
    
    ; Calculate field offset within book
    mov ax, current_field_counter
    mov bx, 50                   ; Bytes per field
    mul bx
    add di, ax                   ; DI = final offset
    
    ; Determine which array to read from based on current_field_counter
    mov ax, current_field_counter
    cmp ax, 0
    je CompactReadAuthor
    cmp ax, 1
    je CompactReadTitle
    cmp ax, 2
    je CompactReadPublisher
    cmp ax, 3
    je CompactReadDatePub
    ; Else read from date borrowed (field 4)
    
CompactReadDateBorrow:
    mov si, offset date_borrow_array
    jmp CompactDisplayField
    
CompactReadAuthor:
    mov si, offset author_array
    jmp CompactDisplayField
    
CompactReadTitle:
    mov si, offset title_array
    jmp CompactDisplayField
    
CompactReadPublisher:
    mov si, offset publisher_array
    jmp CompactDisplayField
    
CompactReadDatePub:
    mov si, offset date_pub_array
    
CompactDisplayField:
    ; Add the base array address to DI
    add di, si
    
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
get_and_display_field_compact endp

; Count how many books a user has borrowed
; Returns: AX = count
count_user_books proc
    push cx
    push si
    
    mov cx, MAX_BOOKS_PER_USER    ; 10 slots
    mov ax, current_index
    mov bx, MAX_BOOKS_PER_USER
    mul bx                       ; AX = user_index * 10
    mov si, offset book_status_array
    add si, ax                   ; SI points to user's status array
    
    xor ax, ax                   ; Counter = 0
    
CountLoop:
    cmp byte ptr [si], 1
    jne NotOccupied
    inc ax                       ; Increment count
NotOccupied:
    inc si
    loop CountLoop
    
    pop si
    pop cx
    ret
count_user_books endp
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
    ret
exit_program endp

end start
