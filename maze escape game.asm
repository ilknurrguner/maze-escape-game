org 100h
jmp start

;kolay seviye 20x20 labirent tasarimi 
;d:duvar, o:bosluk, *:oyuncu, x:cikis
mazeeasy db 'dddddddddddddddddddd'
         db '*oodooooooooodododod'
         db 'ddododddddddododoood'
         db 'doooodoooodoodooodod'
         db 'dodddddodddoddddddod'
         db 'dodooododododooooood'
         db 'dododododooooodddddd'
         db 'dodddododddoddoooood'
         db 'dooooooodoooooodddod'
         db 'ddddddooooodddododod'
         db 'dooooddddoodooododod'
         db 'doddoddoooddododoood'
         db 'dodooddddoddododdddd'
         db 'doddddoooooooooooodd'
         db 'doooooodddoddddddodd'
         db 'doddddodododdooododd'
         db 'dodoodooooodoodddood'
         db 'doddodddddoooooodddd'
         db 'doooodoooooddddooood'
         db 'ddddddddddddddddddxd'

;orta seviye 30x20 labirent tasarimi
mazemedium db 'dddddddddddddddddddddddddddddd'
           db '*odooodooooooddodddoddodddoddd'
           db 'dododododdddoodooooooooooododd'
           db 'dododododdddddddodddddddoddood'
           db 'dodddoooooooooddodooooooodddod'
           db 'dodododddddooddoododdddoodoood'
           db 'dodododooodododdododooododddod'
           db 'dodooododddoooooododododooooox'
           db 'dodddodododdddddddododddoddodd'
           db 'doooooooooooooododooodoooddood'
           db 'ddodooddddooodododddddddodoodd'
           db 'ddoddododoodododooodooododoodd'
           db 'ddoodoooooodododododddododdodd'
           db 'ddoddoddddddodoooooooooooooood'
           db 'ddodooooooodododdddddddddodddd'
           db 'ddddddddddodddodoodododododood'
           db 'doodooooooooooododdododoooddod'
           db 'doododddddddodooodoooooooooood'
           db 'doddoodoodododododododoododddd'
           db 'dddddddddddddddddddddddddddddd'


;zor seviye 40x20 labirent tasarimi
mazehard db 'dddddddddddddddddddddddddddddddddddddddd'
         db '*oooddddddddddddooooddddoooooooooddddddd'
         db 'dddooooodddooooooddododdodddddddoooodddd'
         db 'ddoooddodooodddddddoooooodoooooddddodood'
         db 'ddododdodododoooooodddddddodddodooooddod'
         db 'ddodododdddoddddddodooooododododdodooood'
         db 'ddooooooooooooooodododddododododdddddddd'
         db 'dddddddddododddoddododododododooooooooox'
         db 'ddoooooooodooododoododododooododdddddodd'
         db 'dddddddddddodododoodooododddddododdooodd'
         db 'ddoooooooooodododdoooooooooooooooooodddd'
         db 'ddoddodddddodododdddoddddddddddddddodddd'
         db 'dooododdoddodododdooooooooooooooooddoood'
         db 'dodddooooddodododdddddddddoddddddddododd'
         db 'dodoooddddoododoooooooooooooooddodoododd'
         db 'dodddddodddddddddddoddddddodooooooooodod'
         db 'doooooooooooooooddooooooooododddodddodod'
         db 'ddddodddddoddddodoodddddddododododododod'
         db 'dooooooooooooodododooodoododododododoood'
         db 'dddddddddddddddddddddddddddddddddddddddd'

;kullaniciya zorluk seviyesi sectiren giris ekrani ve oyun sonunda yazacak mesajlar
msg1 db 'Select difficulty level',13,10,'1 - Easy',13,10,'2 - Medium',13,10,'3 - Hard',13,10,'Choice: $'
msg2 db 'YOU WIN ',2,'$'
msg3 db 'TIME UP!$'
msg4 db ' Play again? Y/N: $'

;oyun icindeki degiskenler
currentMaze dw 0
mazeWidth db 0
mazeHeight db 0
mazeSize dw 0
leftMargin db 0
topMargin db 2
msgRow db 0
playerRow db 0
playerCol db 0
timeLeft dw 0
lastSec db 0
resultRow db 22

;ekrani temizleyip zorluk secim menusunu gosterir 
start:
mov ax,0003h
int 10h

mov ah,09h
lea dx,msg1
int 21h

;kullanicidan zorluk seviyesi alir
readChoice:
mov ah,01h
int 21h
cmp al,'1'
je setEasy
cmp al,'2'
je setMedium
cmp al,'3'
je setHard
jmp readChoice

;kolay seviye icin labirent tasarimi ve sureyi ayarlar
setEasy:
mov word ptr [currentMaze],offset mazeeasy
mov byte ptr [mazeWidth],20
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],400
mov word ptr [timeLeft],45
jmp initGame

;orta seviye icin labirent tasarimi ve sureyi ayarlar
setMedium:
mov word ptr [currentMaze],offset mazemedium
mov byte ptr [mazeWidth],30
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],600
mov word ptr [timeLeft],75
jmp initGame

;zor seviye icin labirent tasarimi ve sureyi ayarlar
setHard:
mov word ptr [currentMaze],offset mazehard
mov byte ptr [mazeWidth],40
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],800
mov word ptr [timeLeft],90

;secilen labirente gore ekrani hazirlar, oyuncuyu bulur ve oyunu baslatir
initGame:
mov ax,0003h
int 10h

mov al,80
sub al,[mazeWidth]
shr al,1
mov [leftMargin],al

mov al,[topMargin]
add al,[mazeHeight]
inc al
cmp al,24
jbe msg_ok
mov al,24
msg_ok:
mov [msgRow],al

mov ah,2Ch
int 21h
mov [lastSec],dh

call FindPlayer
call DrawMaze
call DrawTimer

;sureyi kontrol eder ve klavye tuslarini okur
gameLoop:
call UpdateTimer
mov ah,01h
int 16h
jz gameLoop

mov ah,00h
int 16h
cmp ah,48h
je moveUp
cmp ah,50h
je moveDown
cmp ah,4Bh
je moveLeft
cmp ah,4Dh
je moveRight
jmp gameLoop

;duvar yoksa yukari ok tusuna basilinca oyuncuyu yukari hareket ettirir
moveUp:
mov al,[playerRow]
cmp al,0
je gameLoop
dec al
mov bl,[playerCol]
call TryMove
jmp gameLoop

;duvar yoksa asagi ok tusuna basilinca oyuncuyu asagi hareket ettirir
moveDown:
mov al,[playerRow]
mov dl,[mazeHeight]
dec dl
cmp al,dl
je gameLoop
inc al
mov bl,[playerCol]
call TryMove
jmp gameLoop

;duvar yoksa sol ok tusuna basilinca oyuncuyu sol hareket ettirir
moveLeft:
mov al,[playerCol]
cmp al,0
je gameLoop
dec al
mov bl,al
mov al,[playerRow]
call TryMove
jmp gameLoop

;duvar yoksa sag ok tusuna basilinca oyuncuyu sag hareket ettirir
moveRight:
mov al,[playerCol]
mov dl,[mazeWidth]
dec dl
cmp al,dl
je gameLoop
inc al
mov bl,al
mov al,[playerRow]
call TryMove
jmp gameLoop

;sureyi kontrol eder ve sure bittiyse oyunu bitirir
UpdateTimer:
push ax
push bx
push dx

mov ah,2Ch
int 21h
cmp dh,[lastSec]
je utEnd

mov [lastSec],dh
cmp word ptr [timeLeft],0
je timeFinish
dec word ptr [timeLeft]
call DrawTimer
cmp word ptr [timeLeft],0
jne utEnd

timeFinish:
pop dx
pop bx
pop ax
call ShowLose
call AskReplay

utEnd:
pop dx
pop bx
pop ax
ret

;kalan sureyi ekrana yazdirir
DrawTimer:
push ax
push bx
push dx

mov ah,02h
mov bh,0
mov dh,0
mov dl,[leftMargin]
int 10h

mov ah,0Eh
mov al,'T'
int 10h
mov al,'I'
int 10h
mov al,'M'
int 10h
mov al,'E'
int 10h
mov al,':'
int 10h
mov al,' '
int 10h

mov ax,[timeLeft]
xor dx,dx
mov bx,60
div bx

add al,'0'
mov ah,0Eh
int 10h

mov al,':'
int 10h

mov ax,dx
xor dx,dx
mov bx,10
div bx

add al,'0'
mov ah,0Eh
int 10h
mov al,dl
add al,'0'
mov ah,0Eh
int 10h

pop dx
pop bx
pop ax
ret

;sure bittiginde ekrana TIME UP yazdirir
ShowLose:
push ax
push dx
mov ah,02h
mov bh,0
mov dh,[msgRow]
mov dl,[leftMargin]
int 10h
mov ah,09h
lea dx,msg3
int 21h
pop dx
pop ax
ret

;oyuncu kazandiginda ekrana YOU WIN yazdirir
ShowWin:
mov ah,02h
mov bh,0
mov dh,[resultRow]
inc dh
mov dl,30
int 10h

mov ah,09h
lea dx,msg2
int 21h
ret

;labirent tasariminda oyuncunun baslayacagi yeri bulur
FindPlayer:
mov si,[currentMaze]
mov cx,[mazeSize]
xor bx,bx

findLoop:
mov dl,[si]
cmp dl,'*'
je foundPlayer
inc si
inc bx
loop findLoop
ret

;oyuncunun bulundugu satir ve sutun bilgisini tutar
foundPlayer:
mov ax,bx
mov bl,[mazeWidth]
div bl
mov [playerRow],al
mov [playerCol],ah
ret

;secilen labirenti ekrana duvar ve bosluk olarak cizer
DrawMaze:
mov si,[currentMaze]
mov cx,[mazeSize]
xor bx,bx
mov dh,[topMargin]
mov dl,[leftMargin]

;labirent verisindeki karaktere gore duvar, bosluk, oyuncu veya cikis cizer
drawLoop:
cmp bx,0
jne skipPos
mov ah,02h
mov bh,0
int 10h
skipPos:
lodsb
cmp al,'d'
je drawWall
cmp al,'o'
je drawEmpty
cmp al,'*'
je drawPlayerStart
jmp drawChar 

drawPlayerStart:
mov al,15
jmp drawChar

;d karakterini duvara cevirir
drawWall:
mov al,219
jmp drawChar

;o karakterini bosluga cevirir
drawEmpty:
mov al,' '

;hazirlanan karakteri ekrana yazdirir
drawChar:
mov ah,0Eh
int 10h
inc bx
cmp bl,[mazeWidth]
jne drawCont
xor bx,bx
inc dh
drawCont:
loop drawLoop
ret

;oyuncunun gitmek istedigi hucreyi kontrol eder
TryMove:
push ax
push bx
call GetCell
cmp dl,'d'
je moveBlocked
cmp dl,'x'
je moveToExit

call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
jmp moveDone

;gidilecek yer cikissa oyunu kazanma durumuna gecirir
moveToExit:
call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
pop bx
pop ax
call ShowWin
call AskReplay

;hareket engellendiyse oyuncuyu yerinde birakir
moveBlocked:
moveDone:
pop bx
pop ax
ret

;oyuncunun eski konumunu ekrandan ve labirent verisinden temizler
EraseOldPlayer:
push ax
push bx
push dx
mov al,[playerRow]
mov bl,[playerCol]
call SetCursorByCell
mov ah,0Eh
mov al,' '
int 10h
pop dx
pop bx
pop ax
ret

;oyuncunun yei konumunu cizer
DrawPlayer:
push ax
push bx
push dx
mov al,[playerRow]
mov bl,[playerCol]
call SetCursorByCell
mov ah,0Eh
mov al,15
int 10h
pop dx
pop bx
pop ax
ret

;labirent satir-sutun bilgisini ekran koordinatina cevirir
SetCursorByCell:
push ax
push bx
mov dh,al
add dh,[topMargin]
mov dl,bl
add dl,[leftMargin]
mov ah,02h
mov bh,0
int 10h
pop bx
pop ax
ret

;oyuncunun gitmek istedigi hucrede hangi karakter oldugunu okur
GetCell:
push ax
push bx
push si
push cx
xor ah,ah
mov cl,[mazeWidth]
mul cl
xor bh,bh
add ax,bx
mov si,[currentMaze]
add si,ax
mov dl,[si]
pop cx
pop si
pop bx
pop ax
ret

;oyuncunun eski yerini labirent verisinde bosluk olarak isaretler
SetCellEmpty:
push ax
push bx
push si
push cx
xor ah,ah
mov cl,[mazeWidth]
mul cl
xor bh,bh
add ax,bx
mov si,[currentMaze]
add si,ax
mov byte ptr [si],'o'
pop cx
pop si
pop bx
pop ax
ret

;oyuncunun yeni yerini labirent verisinde oyuncu olarak isaretler
SetCellPlayer:
push ax
push bx
push si
push cx
xor ah,ah
mov cl,[mazeWidth]
mul cl
xor bh,bh
add ax,bx
mov si,[currentMaze]
add si,ax
mov byte ptr [si],'*'
pop cx
pop si
pop bx
pop ax
ret  

;oyun bittikten sonra kullaniciya tekrar oynamak isteyip istemedigini sorar
AskReplay:
mov ah,0Ch
mov al,00h
int 21h

mov ah,02h
mov bh,0
mov dh,[resultRow]
inc dh
mov dl,0
int 10h

mov cx,80

clearResultLine:
mov ah,0Eh
mov al,' '
int 10h
loop clearResultLine

mov ah,02h
mov bh,0
mov dh,[resultRow]
inc dh
mov dl,25
int 10h

mov ah,09h
lea dx,msg4
int 21h

askKey:
mov ah,00h
int 16h
cmp al,'Y'
je restartGame
cmp al,'y'
je restartGame
cmp al,'N'
je exitGame
cmp al,'n'
je exitGame
jmp askKey

restartGame:
jmp start

exitGame:
mov ax,4C00h
int 21h