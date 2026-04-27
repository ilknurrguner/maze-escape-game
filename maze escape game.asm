org 100h
jmp start

;kolay seviye 20x20 labirent tasarimi 
;d:duvar, o:bosluk, *:oyuncu, x:cikis
mazeeasy db 'dddddddddddddddddddd'
         db '*oodoooootooodcdodod'
         db 'ddododddddddododotod'
         db 'docoodoooodoodooodod'
         db 'dodddddodddoddddddod'
         db 'dodooododododooooood'
         db 'dodcdododooooodddddd'
         db 'dodddododddoddoooood'
         db 'dooooootdoooooodddod'
         db 'ddddddooooodddododod'
         db 'dooooddddotdooododod'
         db 'doddoddcooddododoood'
         db 'dodcoddddoddododdddd'
         db 'doddddoooooooooooodd'
         db 'doooootdddoddddddodd'
         db 'dtddddodcdoddoctdodd'
         db 'dodcodooooodoodddocd'
         db 'doddodddddoooooodddd'
         db 'doooodcooooddddooood'
         db 'ddddddddddddddddddxd'

;orta seviye 30x20 labirent tasarimi
mazemedium db 'dddddddddddddddddddddddddddddd'
           db '*odooodooooooddcdddoddodddoddd'
           db 'dododododdddocdoooootooooododd'
           db 'dodcdododdddddddodddddddoddood'
           db 'dodddoooooooooddodooooooodddod'
           db 'dodcdodddddotddoododdddoodcood'
           db 'dodododoocdododdododooododddod'
           db 'dodooododddoooooodododcdooooox'
           db 'dodddodtdoddddddddododddoddodd'
           db 'doooooooooooooododooodcooddotd'
           db 'ddodooddddooodododddddddodcodd'
           db 'ddoddtdodoodododooodcotdodoodd'
           db 'ddocdoooooodododododddododdodd'
           db 'ddoddoddddddodooooooooooooootd'
           db 'ddodooooooodtdoddddddddddodddd'
           db 'ddddddddddodddodocdododododood'
           db 'doodooooooooooododdododootddod'
           db 'doododddddddodooodoooooooooood'
           db 'doddocdoodododododododoododddd'
           db 'dddddddddddddddddddddddddddddd'

;zor seviye 40x20 labirent tasarimi
mazehard db 'dddddddddddddddddddddddddddddddddddddddd'
         db '*oooddddddddddddooooddddoooooooooddddddd'
         db 'dddooooodddooooooddodcddodddddddoootdddd'
         db 'ddoooddodooodddddddoooooodoooooddddodcod'
         db 'ddtdoddodcdodcooooodddddddodddodooooddod'
         db 'ddcdodtddddoddddddodooooododcdoddodooood'
         db 'ddooooooooooooooodododddodododtddddddddd'
         db 'dddddddddtdodddoddtdodcdodododooooooooox'
         db 'ddcooooooodooododoododododooododdddddodd'
         db 'dddddddddddodododoodootdodddddodcddtoodd'
         db 'ddoooooootoodododdoooooooooooooooooodddd'
         db 'ddoddodddddodododdddoddddddddddddddodddd'
         db 'dooododdcddodododdcoooooooooooootcddoood'
         db 'dodddooooddodododdddddddddoddddddddododd'
         db 'dodcooddddoododoooooooooooooooddodoododd'
         db 'dodddddodddddddddddoddddddodooooooooodcd'
         db 'dtooooooooooooooddooooooooododddodddodod'
         db 'ddddodddddoddddodoodddddddododododododod'
         db 'doooooooooooocdcdcdooodoododododododoood'
         db 'dddddddddddddddddddddddddddddddddddddddd'

;kullaniciya zorluk seviyesi sectiren giris ekrani ve oyun sonunda yazacak mesajlar
msg1 db 'Select difficulty level',13,10,'1 - Easy',13,10,'2 - Medium',13,10,'3 - Hard',13,10,'Choice: $'
msg2 db 'YOU WIN ',2,'$'
msg3 db 'TIME UP!$'
msg4 db ' Play again? Y/N: $'

;oyun icindeki degiskenler
selectedMaze dw 0
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
columnCount db 0

;coinlerden kazanilan puani tutar
coinScore dw 0

;oyun sonunda kalan sure ile coin puanini toplayarak final skoru tutar
finalScore dw 0

;secilen labirentin kopyalanip oyun sirasinda uzerinde islem yapildigi alan
workMaze db 800 dup(0)

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
mov word ptr [selectedMaze],offset mazeeasy
mov byte ptr [mazeWidth],20
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],400
mov word ptr [timeLeft],45
jmp initGame

;orta seviye icin labirent tasarimi ve sureyi ayarlar
setMedium:
mov word ptr [selectedMaze],offset mazemedium
mov byte ptr [mazeWidth],30
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],600
mov word ptr [timeLeft],75
jmp initGame

;zor seviye icin labirent tasarimi ve sureyi ayarlar
setHard:
mov word ptr [selectedMaze],offset mazehard
mov byte ptr [mazeWidth],40
mov byte ptr [mazeHeight],20
mov word ptr [mazeSize],800
mov word ptr [timeLeft],90

;secilen labirente gore ekrani hazirlar, oyuncuyu bulur ve oyunu baslatir
initGame:
mov ax,0003h
int 10h

;her yeni oyunda labirentin orijinal halini calisma alanina kopyalar
call CopyMaze

mov word ptr [coinScore],0
mov word ptr [finalScore],0

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
call DrawStatus

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
call DrawStatus
cmp word ptr [timeLeft],0
jne utEnd

timeFinish:
pop dx
pop bx
pop ax

; sure bittiginde final score'u sifirlar
mov word ptr [finalScore],0

call ShowLose
call AskReplay

utEnd:
pop dx
pop bx
pop ax
ret

;kalan sureyi ve mevcut skoru ekrana yazdirir
DrawStatus:
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
call PrintNumber

mov ah,0Eh
mov al,' '
int 10h
mov al,' '
int 10h
mov al,'S'
int 10h
mov al,'C'
int 10h
mov al,'O'
int 10h
mov al,'R'
int 10h
mov al,'E'
int 10h
mov al,':'
int 10h
mov al,' '
int 10h

mov ax,[coinScore]
call PrintNumber

mov ah,0Eh
mov al,' '
int 10h
mov al,' '
int 10h
mov al,' '
int 10h

pop dx
pop bx
pop ax
ret

;sure bittiginde ekrana TIME UP yazdirir
ShowLose:
push ax
push bx
push dx
mov ah,02h
mov bh,0
mov dh,[msgRow]
mov dl,[leftMargin]
int 10h
mov dx,offset msg3
mov bl,0Ch
call PrintStringColor

mov ah,0Eh
mov al,' '
int 10h
mov al,'S'
int 10h
mov al,'C'
int 10h
mov al,'O'
int 10h
mov al,'R'
int 10h
mov al,'E'
int 10h
mov al,':'
int 10h
mov al,' '
int 10h
mov ax,[finalScore]
call PrintNumber
pop dx
pop bx
pop ax
ret

;oyuncu kazandiginda ekrana YOU WIN yazdirir
ShowWin:
push ax
push bx
push dx
mov ah,02h
mov bh,0
mov dh,[resultRow]
inc dh
mov dl,30
int 10h

mov dx,offset msg2
mov bl,0Ah
call PrintStringColor

mov ah,0Eh
mov al,' '
int 10h
mov al,'S'
int 10h
mov al,'C'
int 10h
mov al,'O'
int 10h
mov al,'R'
int 10h
mov al,'E'
int 10h
mov al,':'
int 10h
mov al,' '
int 10h
mov ax,[finalScore]
call PrintNumber
pop dx
pop bx
pop ax
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
mov byte ptr [columnCount],0
mov dh,[topMargin]
mov dl,[leftMargin]

;labirent verisindeki karaktere gore duvar, bosluk, oyuncu veya cikis cizer
drawLoop:
cmp byte ptr [columnCount],0
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
cmp al,'x'
je drawExit
cmp al,'c'
je drawCoin
cmp al,'t'
je drawTrap
jmp drawChar 

drawPlayerStart:
mov al,15
mov bl,0Dh
call PrintColor
jmp afterColorPrint 

drawExit:
mov al,'X'
mov bl,0Ah
call PrintColor
jmp afterColorPrint

;coin karakterini sari karo olarak ekrana cizer
drawCoin:
mov al,4
mov bl,0Eh
call PrintColor
jmp afterColorPrint

;trap karakterini kirmizi yildiz olarak ekrana cizer
drawTrap:
mov al,42
mov bl,0Ch
call PrintColor
jmp afterColorPrint

;d karakterini duvara cevirir
drawWall:
mov al,219
mov bl,09h
call PrintColor
jmp afterColorPrint

;o karakterini bosluga cevirir
drawEmpty:
mov al,' '
mov bl,07h
call PrintColor
jmp afterColorPrint

;hazirlanan karakteri ekrana yazdirir
drawChar:
mov ah,0Eh
int 10h

afterColorPrint:
inc byte ptr [columnCount]
mov al,[columnCount]
cmp al,[mazeWidth]
jne drawCont
mov byte ptr [columnCount],0
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
cmp dl,'c'
je moveToCoin
cmp dl,'t'
je moveToTrap

call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
jmp moveDone

;coin alindiginda puani 5 artirir ve coin hucreyi bosluk yapar
moveToCoin:
add word ptr [coinScore],15
call SetCellEmpty
call DrawStatus
call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
jmp moveDone

;trap'e basilinca sureden 5 saniye dusurur ve trap hucreyi bosluk yapar
moveToTrap:
cmp word ptr [timeLeft],5
ja trapSub
mov word ptr [timeLeft],0
jmp trapAfter
trapSub:
sub word ptr [timeLeft],5
trapAfter:
call SetCellEmpty
call DrawStatus
call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
cmp word ptr [timeLeft],0
je trapTimeFinish
jmp moveDone

trapTimeFinish:
pop bx
pop ax
call CalculateFinalScore
call ShowLose
call AskReplay

;gidilecek yer cikissa oyunu kazanma durumuna gecirir
moveToExit:
call EraseOldPlayer
mov [playerRow],al
mov [playerCol],bl
call DrawPlayer
pop bx
pop ax
call CalculateFinalScore
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
mov al,' '
mov bl,07h
call PrintColor
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
mov al,15
mov bl,0Dh
call PrintColor
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

;renkli karakter yazdirir ve cursoru bir sonraki sutuna tasir
PrintColor:
push ax
push bx
push cx

mov ah,09h
mov bh,0
mov cx,1
int 10h

pop cx
pop bx
pop ax

mov ah,0Eh
int 10h
ret

;$ isaretine kadar olan yaziyi secilen renkte ekrana basar
PrintStringColor:
push ax
push si
mov si,dx
pscLoop:
lodsb
cmp al,'$'
je pscEnd
call PrintColor
jmp pscLoop
pscEnd:
pop si
pop ax
ret

;sayisal degeri ekrana decimal olarak yazdirir
PrintNumber:
push ax
push bx
push cx
push dx

cmp ax,0
jne pnStart
mov ah,0Eh
mov al,'0'
int 10h
jmp pnEnd

pnStart:
xor cx,cx
mov bx,10

pnDiv:
xor dx,dx
div bx
push dx
inc cx
cmp ax,0
jne pnDiv

pnPrint:
pop dx
mov ah,0Eh
mov al,dl
add al,'0'
int 10h
loop pnPrint

pnEnd:
pop dx
pop cx
pop bx
pop ax
ret

;oyun sonunda coin puani ile kalan sureyi toplayarak final skoru hesaplar
CalculateFinalScore:
push ax
mov ax,[coinScore]
add ax,[timeLeft]
mov [finalScore],ax
pop ax
ret

;secilen labirenti orijinal veriden calisma alanina kopyalar
CopyMaze:
push ax
push cx
push si
push di
push ds
pop es
mov si,[selectedMaze]
mov di,offset workMaze
mov cx,[mazeSize]
rep movsb
mov word ptr [currentMaze],offset workMaze
pop di
pop si
pop cx
pop ax
ret
