jmp main

desenho1Forca0 : string  "SCORE:                                  "
desenho1Forca1 : string  "----------------------------------------"
desenho1Forca2 : string  "|                                      |"
desenho1Forca3 : string  "|                                      |"
desenho1Forca4 : string  "|                                      |"
desenho1Forca5 : string  "|                                      |"
desenho1Forca6 : string  "|                                      |"
desenho1Forca7 : string  "|                                      |"
desenho1Forca8 : string  "|                                      |"
desenho1Forca9 : string  "|                                      |"
desenho1Forca10 : string "|                                      |"
desenho1Forca11 : string "|                                      |"
desenho1Forca12 : string "|                                      |"
desenho1Forca13 : string "|                                      |"
desenho1Forca14 : string "|                                      |"
desenho1Forca15 : string "|                                      |"
desenho1Forca16 : string "|                                      |"
desenho1Forca17 : string "|                                      |"
desenho1Forca18 : string "|                                      |"
desenho1Forca19 : string "|                                      |"
desenho1Forca20 : string "|                                      |"
desenho1Forca21 : string "|                                      |"
desenho1Forca22 : string "|                                      |"
desenho1Forca23 : string "|                                      |"
desenho1Forca24 : string "|                                      |"
desenho1Forca25 : string "|                                      |"
desenho1Forca26 : string "|                                      |"
desenho1Forca27 : string "|                                      |"
desenho1Forca28 : string "|                                      |"
desenho1Forca29 : string "----------------------------------------"
numeros :string "000102030405060708091011121314151617181920212223242526272829303132333435363738394041424344454647484950"
vocePerdeu: string "GAME OVER!Play again?(y/n)"

cobra :var#60
movimento :var#1
movAntigo :var#1
letra :var#1
comida :var#1
posComida :var#1
deveDesenharComida:var#1
pontos:var#1
delayTime:var#1

rand: var #30
static rand + #0, #1058
static rand + #1, #104
static rand + #2, #452
static rand + #3, #670
static rand + #4, #891
static rand + #5, #278
static rand + #6, #788
static rand + #7, #353
static rand + #8, #1024
static rand + #9, #401
static rand + #10, #134
static rand + #11, #512
static rand + #12, #1153
static rand + #13, #701
static rand + #14, #638
static rand + #15, #176
static rand + #16, #580
static rand + #17, #598
static rand + #18, #310
static rand + #19, #962
static rand + #20, #843
static rand + #21, #225
static rand + #22, #1110
static rand + #23, #837
static rand + #24, #384
static rand + #25, #83
static rand + #26, #946
static rand + #27, #526
static rand + #28, #545
static rand + #29, #81


main:
	call DesenhaTela
	loadn r1, #620
	loadn r0,#cobra
	storei r0,r1
	inc r0
	loadn r1,#1200
	storei r0,r1
	loadn r1,#'w'
	store movimento,r1
	store movAntigo,r1
	loadn r1,#1
	store deveDesenharComida,r1
	loadn r0,#0
	store pontos,r0
	loadn r0,#15
	store delayTime,r0

	Loop:	
		call printScore
		call MovimentaCobra
		call VerificaParede
		call CriaComida
		call VerificaComeuPonto
		call VerificaComeuCorpo
		
		call Delay
		inc r1
		jmp Loop
	
	halt
	
;--------------------------------------------------------------------------------	
;				GAME OVER
;--------------------------------------------------------------------------------	
GameOver:
	push r0
	push r1
	push r2
	
	loadn r1,#vocePerdeu
	loadn r0,#609  		;posicao da tela onde imprimir
	call Imprime		;imprimir string
	LoopVerifica:
		inchar r0		;le o comando do usuario (s ou n)
		
		loadn r1, #'n'
		cmp r0, r1		;verefica se o usario digitou n
		jeq FimDeJogo
		
		loadn r1, #'y'
		cmp r0, r1		;verifica se o usuario digitou s
		jeq NovoJogo
	jmp LoopVerifica
	
	NovoJogo:			;começa novo jogo, apagando a tela e resetando as variaveis
		pop r2
		pop r1
		pop r0
		call ApagaTela
		jmp main
	FimDeJogo:		;termina o jogo
		pop r2
		pop r1
		pop r0
		call ApagaTela
		halt
;--------------------------------------------------------------------------------	
;				VERIFICA SE COMEU PONTO
;--------------------------------------------------------------------------------	
VerificaComeuCorpo:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #cobra
	loadi r1, r0
	loadn r3,#1200
	mov r2,r1   ;posicao cabeça
	inc r0		;corpo
	loopComeuCorpo:
		loadi r1, r0
		cmp r1,r3		;fim de string
		jeq endVerificaComeuCorpo
		cmp r2,r1		;posicao da cabeça for igual a alguma do corpo
		jeq GameOver
		inc r0
		jmp loopComeuCorpo
	
	endVerificaComeuCorpo:
		pop r3
		pop r2
		pop r1
		pop r0
		rts	
	
;--------------------------------------------------------------------------------	
;				VERIFICA SE COMEU PONTO
;--------------------------------------------------------------------------------
VerificaComeuPonto:
	push r0
	push r1
	push r2
	push r3	
	push r4
	
	loadn r0, #cobra	;posicao do Cobra
	load r1,posComida
	loadn r2,#1
	
	loadi r3,r0		;se a posicao da comida for igual a posicao da cabeça
	cmp r3,r1
	jeq comeu
	jmp endVerificaComeu
	
	comeu:
		store deveDesenharComida,r2			;store para fazer desenhar no proximo ciclo
		load r2,pontos						;incrementa os pontos
		inc r2
		store pontos,r2
		load r2,delayTime					;aumenta a dificuldade do jogo
		dec r2
		store delayTime,r2
		
	load r1, movimento
	loadn r2,#1200
	adicionaRabo:
		loopRabo:					;chega até o final do rabo
			loadi r3,r0
			cmp r3,r2
			jeq rabo
			mov r4,r3
			inc r0
			jmp loopRabo
			
		rabo:				;adiciona um pedaço do corpo conforme o movimento
			loadn r2,#'w'
			cmp r2,r1
			jeq adicionaRaboW
			loadn r2,#'s'
			cmp r2,r1
			jeq adicionaRaboS
			loadn r2,#'d'
			cmp r2,r1
			jeq adicionaRaboD
			loadn r2,#'a'
			cmp r2,r1
			jeq adicionaRaboA
		
		adicionaRaboW:			;adiciona pedaço em baixo se for pra cima
			loadn r2,#40
			add r4,r4,r2
			storei r0,r4
			jmp adiciona1200
		adicionaRaboS:			;adiciona pedaço em cima se for pra baixo
			loadn r2,#40
			sub r4,r4,r2
			storei r0,r4
			jmp adiciona1200
		adicionaRaboD:	;adiciona rabo na esquerda se for pra direita
			loadn r2,#1
			sub r4,r4,r2
			storei r0,r4
			jmp adiciona1200
		adicionaRaboA: ;adiciona rabo na diraita se for pra esquerda
			loadn r2,#1
			add r4,r4,r2
			storei r0,r4
			jmp adiciona1200
		adiciona1200:			;adiciona um indicativo de final de cobra
			loadn r2,#1200
			inc r0
			storei r0,r2
	endVerificaComeu:
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts
		
		
;--------------------------------------------------------------------------------	
;				MOVIMENTA COBRA
;--------------------------------------------------------------------------------
MovimentaCobra:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	loadn r0, #cobra	;posicao do Cobra
	loadn r1, #'O'	;cabeça
	loadn r2, #'o'	;corpo
	loadn r3,#255
	loadn r4,#' '   ;espaço para apagar a cobra
	loadn r5,#1200
	loadn r6,#512	;adiciona a cor verde
	add r1, r1, r6
	loadn r6,#2560 ;cor oliva
	add r2,r2,r6
	
	;inchar r7				;le da teclado o movimento da cobra
	load r7, letra
	cmp r7,r3				;se for invalido, sai do movimento
	jeq JaMove
	
	Movimento:						;verifica qual movimento está fazendo
		loadn r3,#'d'
		cmp r7,r3
		jeq MoveDireita
		loadn r3,#'a'
		cmp r7,r3
		jeq MoveEsquerda
		loadn r3,#'w'
		cmp r7,r3
		jeq MoveFrente
		loadn r3,#'s'
		cmp r7,r3
		jeq MoveTras
	
	JaMove:						;verifica se ja esta movendo para continuar o movimento
		load r7,movimento
		jmp Movimento
	
	MoveFrente:	
		load r6,movAntigo  ;se o movimento for s e estiver movimentando para cima, nao faz nada
		loadn r3,#'s'
		cmp r6,r3
		jeq SaiMove		
		store movAntigo,r7
		store movimento,r7
		imprimeCabecaFrente:
			loadi r6,r0   		; load da posicao da cobra do vetor
			outchar r4,r6		;imprime vazio
			mov r3,r6
			loadn r7,#40		; carrega 40 para andar
			sub r6,r6,r7		; vai para frente
			outchar r1,r6
			storei r0,r6		;guarda a posicao no vetor
		imprimeCorpoFrente:
			inc r0
			loadi r6,r0   		; load da posicao da cobra do vetor
			cmp r6,r5
			jeq SaiMove			; se for 1200,acabou de imprimir
			outchar r4,r6		;imprime vazio
			outchar r2,r3
			storei r0,r3		;guarda a posicao no vetor
			mov r3,r6
			jmp imprimeCorpoFrente
			
	MoveTras:
		load r6,movAntigo  ;se o movimento for w e estiver movimentando para baixo, nao faz nada
		loadn r3,#'w'
		cmp r6,r3
		jeq SaiMove	
		store movAntigo,r7
		store movimento,r7
		imprimeCabecaTras:
			loadi r6,r0   		; load da posicao da cobra do vetor
			outchar r4,r6		;imprime vazio
			mov r3,r6
			loadn r7,#40		; carrega 40 para andar
			add r6,r6,r7		; vai para frente
			outchar r1,r6
			storei r0,r6		;guarda a posicao no vetor
		imprimeCorpoTras:
			inc r0
			loadi r6,r0   		; load da posicao da cobra do vetor
			cmp r6,r5
			jeq SaiMove			; se for 1200,acabou de imprimir
			outchar r4,r6		;imprime vazio
			outchar r2,r3
			storei r0,r3		;guarda a posicao no vetor
			mov r3,r6
			jmp imprimeCorpoTras

	MoveEsquerda:
		load r6,movAntigo  ;se o movimento for d e estiver movimentando para esq, nao faz nada
		loadn r3,#'d'
		cmp r6,r3
		jeq SaiMove	
		store movAntigo,r7
		store movimento,r7
		imprimeCabecaEsquerda:
			loadi r6,r0   		; load da posicao da cobra do vetor
			outchar r4,r6		;imprime vazio
			mov r3,r6
			loadn r7,#1		; carrega 40 para andar
			sub r6,r6,r7		; vai para frente
			outchar r1,r6
			storei r0,r6		;guarda a posicao no vetor
		imprimeCorpoEsquerda:
			inc r0
			loadi r6,r0   		; load da posicao da cobra do vetor
			cmp r6,r5
			jeq SaiMove			; se for 1200,acabou de imprimir
			outchar r4,r6		;imprime vazio
			outchar r2,r3
			storei r0,r3		;guarda a posicao no vetor
			mov r3,r6
			jmp imprimeCorpoEsquerda		
		
	MoveDireita:
		load r6,movAntigo  ;se o movimento for e e estiver movimentando para dir, nao faz nada
		loadn r3,#'a'
		cmp r6,r3
		jeq SaiMove	
		store movAntigo,r7
		store movimento,r7
		imprimeCabecaDireita:
			loadi r6,r0   		; load da posicao da cobra do vetor
			outchar r4,r6		;imprime vazio
			mov r3,r6
			loadn r7,#1		; carrega 40 para andar
			add r6,r6,r7		; vai para frente
			outchar r1,r6
			storei r0,r6		;guarda a posicao no vetor
		imprimeCorpoDireita:
			inc r0
			loadi r6,r0   		; load da posicao da cobra do vetor
			cmp r6,r5
			jeq SaiMove			; se for 1200,acabou de imprimir
			outchar r4,r6		;imprime vazio
			outchar r2,r3
			storei r0,r3		;guarda a posicao no vetor
			mov r3,r6
			jmp imprimeCorpoDireita
			
SaiMove:
	pop r7
	pop r6
	pop r5
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
;--------------------------------------------------------------------------------	
;				CRIA COMIDA
;--------------------------------------------------------------------------------
CriaComida:
	push r0
	push r1
	push r2
	push r3
	push r4
	push r5
	push r6
	push r7
	
	load r0,comida   ;qual comida que está
	loadn r1,#'@'
	loadn r2,#2304 ;cor vermelha
	add r1,r1,r2
	loadn r3,#rand
	loadn r5,#cobra
	loadn r7,#0		  ;contador
	load r6,deveDesenharComida
	
	deveDesenhar:
		cmp r6,r7
		jeq endComida
	
	verificaPosVetorComida:
		loadn r6,#29			;reseta o vetor de rand
		cmp r0,r6
		jne loopComida
		loadn r0,#0				;se esta no final, passa para 0
	

	loopComida:
		cmp r0,r7		;avança no vetor de random até o numero qeu parou
		jeq verificaNewPos
		inc r7
		inc r3
		jmp loopComida
	
	verificaNewPos:
		loadn r6,#1200
		inc r3  ;proximaPosicao
		loadi r2,r3	;posicao rand
		inc r7
		compare:
			loadi r4,r5  ;posicao vetor cobra
			cmp r2,r4	 ;compara a posicao da comida com a posicao da cobra
			jeq verificaNewPos
			cmp r4,r6	;verifica se ja acabou o vetor da cobra
			jeq printComida
			inc r5
			jmp compare
			
	printComida:				;printa comida
		outchar r1,r2
		store posComida,r2
		store comida,r7
		loadn r6,#0
		store deveDesenharComida,r6  ;não deve desenhar mais
	endComida:
		pop r7
		pop r6
		pop r5
		pop r4
		pop r3
		pop r2
		pop r1
		pop r0
		rts
		
		
;--------------------------------------------------------------------------------	
;				SCORE
;--------------------------------------------------------------------------------	
printScore:
	push r0
	push r1
	push r2
	push r3
	loadn r1,#numeros
	load r0,pontos
	loadn r3,#0
	loopScore:			;percorre na variavel de numeros para saber qual o score
		cmp r3,r0
		jeq score
		inc r3
		inc r1
		inc r1
		jmp loopScore
	score:				;printa 2 posicoes do vetor de numero, dependendo da posicao que está
		loadi r3,r1
		loadn r2,#6
		outchar r3,r2
		inc r1
		loadi r3,r1
		loadn r2,#7
		outchar r3,r2
	pop r3
	pop r2
	pop r1
	pop r0
	rts
;--------------------------------------------------------------------------------	
;				VERIFICA PAREDE
;--------------------------------------------------------------------------------
VerificaParede:
	push r0
	push r1
	push r2
	push r3
	
	loadn r0, #cobra
	loadi r1, r0				;posicao da cabeça
	loadn r2, #79       		;posicao final da parede
	LoopParedeDeCima:	;comparacao para ver se é paredede cima
		cmp r1, r2
		jel GameOver
	
	loadn r2, #1160
	LoopParedeDeBaixo:		;comparacao para ver se é paredede baixo
		cmp r1, r2
		jeg GameOver
		
	loadn r2, #40	
	loadn r3, #39
	LoopParedeDeDireita:	;comparacao para ver se é paredede dir
		mod r2, r1, r2
		cmp r2, r3
		jeq GameOver
		
	loadn r2, #40	
	loadn r3, #0
	LoopParedeDeEsquerda:	;comparacao para ver se é paredede esq
		mod r2, r1, r2
		cmp r2, r3
		jeq GameOver
		
	
SaiVerificaParede:
	pop r3
	pop r2
	pop r1
	pop r0
	rts
;--------------------------------------------------------------------------------	
;				DELAY
;--------------------------------------------------------------------------------
Delay:				
	Push R0
	Push R1
	push r2
	push r3
	push r4
	Load R1, delayTime 				; a
	loadn r2,#0						;delay diminui conforme come
	loadn r4, #255
	store letra, r4
	cmp r2,r1
	jne Delay_volta2
	loadn r1,#1					;caso contador seja 0
	Delay_volta2:				; contador de tempo quebrado em duas partes (dois loops de decremento)
		Loadn R0, #100		; b
		loop_delay_2:
				inchar r3
				cmp r3, r4			;nulo
				jeq Delay_volta
				
				
				store letra, r3		; Se apertar uma tecla, guarda na variavel Letra
		Delay_volta: 
			
			Dec R0				; (4*a + 6)b = 1000000  == 1 seg  em um clock de 1MHz
			JNZ loop_delay_2			
			Dec R1
			JNZ Delay_volta2
		
			pop r4
			pop r3
			pop r2
			Pop R1
			Pop R0
		
			RTS	

			

;--------------------------------------------------------------------------------	
;				DESENHA TELA
;--------------------------------------------------------------------------------
	
DesenhaTela:
	push r0	
	push r1	
	push r2	
	push r3
	push r4	
	push r5

	loadn r0, #0		; posicao inicial tem que ser o comeco da tela!
	loadn r1, #desenho1Forca0 
	loadn r2, #0				;cor branca
	loadn r3, #40  		; Incremento da posicao da tela!
	loadn r4, #41  		; incremento do ponteiro das linhas da tela
	loadn r5, #1200 	; Limite da tela!
 
ImprimeTela_Loop:
	call Imprime
	add r0, r0, r3	;incrementa posição para próxima linha 
	add r1, r1, r4 	;incrementa posicao do ponteiro para próxima linha
	cmp r0, r5		;critério de parada (final da tela)
	jne ImprimeTela_Loop
	pop r5	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
	
;--------------------------------------------------------------------------------	
;				IMPRIME STRING
;--------------------------------------------------------------------------------
	
Imprime:	
	push r0
	push r1
	push r2
	push r3
	push r4
	
	loadn r3, #'\0'	; Criterio de parada
	loadn r4, #0	;seleciona a cor 
	
LoopImprime:	
	loadi r2, r1
	cmp r2, r3
	jeq SaiImprime
	add r2, r4, r2
	outchar r2, r0
	inc r0
	inc r1
	jmp LoopImprime
	
SaiImprime:	
	pop r4
	pop r3
	pop r2
	pop r1
	pop r0
	rts
;-----------------------------------------
;					APAGA TELA
;-----------------------------------------
ApagaTela:
	push r0
	push r1
	push r2
	
	loadn r0, #0            ;inicia na posição 0 da tela
	loadn r1, #1200		    ;posicao final da tela
	loadn r2, #' '		    ;espaço em branco para ser adicionado
	
	LoopApagaTela :
		cmp r0, r1          ;compara o critério de parada (final da tela)
		jeq ApagaTelaSai    ;irá retorna à DesenhaTela
		outchar r2, r0      ;imprimi espaço na posição de r0
		inc r0				;incrementa r0
		jmp LoopApagaTela	;realiza um loop até chegar no critério de parada
	
ApagaTelaSai:
	pop r2
	pop r1
	pop r0
	rts