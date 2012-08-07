
/*
	MÉTODOS start_FRAMENAME
	SÃO EXECUTADOS AUTOMATICAMENTE, AO FINAL DO MÉTODO loadSlide(FRAMENAME)
	Toda vez que um slide é carregado, caso exista a função relacionada, ela é executada.
	Elas servem para carregar o conjunto adequado de métodos do SWF que são disponibilizados via ExternalInterface.
*/
var DEBUG = false; //MUDE DEBUG PARA TRUE PRA FACILITAR A NAVEGAÇÃO PELA ATIVIDADE!!!

function start_n0(){
	
}

function start_n1(){
	// exibe campo vetorial
	try {
		movie.reset();	
	} catch(err) {
		trace("NÃO FUNCIONOU O MOVIE.RESET")
	}
	
	
	movie.setField("Campo2");
	//movie.showField(true);
	movie.showFieldName(true);	
	
	movie.setAllButtonsInteractive(false);
	//mostra o vetor que acompanha o mouse
	movie.setMouseVec(true);	

}

function start_n2(){
	//A área de experimentação então oculta o campo vetorial e passa a exibir o vetor na posição do mouse, à medida que o usuário o movimenta. Todas as demais //interações são inibidas
	//movie.setField("Campo1");
	trace("Rodando o Start_N2")
	movie.reset();
	movie.setField("Campo2")
	movie.showFieldName(true);	
	movie.showField(false);	
	try {
		movie.setMouseVec(false);
		trace("MouseVec = false")
	} catch(error) {
		
	}

	movie.setAllButtonsInteractive(false);
	
}

function start_n3(){
	$('#n3_avancar').hide();
	movie.reset();
	movie.setField("Campo1");	
	movie.showField(false);
	movie.showFieldName(true);	
	movie.setMouseVec(false);
}

function start_n4(){
		movie.reset();
		movie.showField(false);
		movie.showFieldName(true);			
		movie.setAllButtonsInteractive(false);
		movie.setButtonInteractive("VEC", true);
		movie.setButtonInteractive("DEL", true);
		movie.setMaxVecs(1);

		if(DEBUG){
			movie.addVec(dadosExercicio1[0], dadosExercicio1[1], dadosExercicio1[2], dadosExercicio1[3], false, true);
		}
		//Limitar qtde de vetores para uso em apenas 1
		//Apenas as interações necessárias para a criação, edição e remoção dessas flechas devem estar disponíveis (zoom in e out também).
}
function start_n5(){
		movie.reset();
		movie.showField(false);
		movie.showFieldName(true);			
		movie.setAllButtonsInteractive(false);
		movie.setButtonInteractive("VEC", true);
		movie.setButtonInteractive("DEL", true);
		movie.addVec(dadosExercicio1[0], dadosExercicio1[1], dadosExercicio1[2], dadosExercicio1[3], false, true);
		movie.setMaxVecs(15);
		//Limitar qtde de vetores para uso em algo maior que 5 (10?)
		//Remover da tela todos os vetores menos o gerado em n4, ou seja, menos o primeiro da pilha (é o reset deste ponto) 
}

function start_n5resposta(){
	var scoreEx1 = movie.addAnswerEx1();
	if(memento.ex1 == false){
		memento.score += scoreEx1/2;
		memento.ex1 = true;
		commit(memento);
	}
	//notificar("Nível de acerto: " + scoreEx1 + "%.");
	$("#n5_acerto").html(scoreEx1 + "%.");
	movie.setAllButtonsInteractive(false);
}

function start_n6(){
		//movie.reset();
		movie.showField(true);
		movie.setAllButtonsInteractive(false);
}

function start_n7(){

	//Agora é preciso limpar a área de exploração (remover todas as flechas), redefinir o campo para F = (y,x) e ocultá-lo. 
	//Além disso, o range do gráfico deve ser definido de 0 a 5, tanto em x quanto em y, e as curvas de nível y = z/x 
	//devem ser exibidas [z = 1, 4, 9, 16 (PARÂMETROS, os valores de z e a quantidade de curvas de nível)].
	movie.reset();
	movie.showFieldName(false);
	movie.setField("Campo3");
	movie.showField(false);
	movie.setAllButtonsInteractive(false);
	movie.changeBounds(0,5,0,5);
	movie.addCurves();
}

function start_n8(){
//Redefinir o range do gráfico novamente para 0 a 7, em x e y, para o caso de o aluno ter mexido nisso.
	movie.reset();
	movie.setField("Campo3");
	movie.showField(false);
	movie.changeBounds(0, 7, 0, 5);
	movie.addCurves();
	movie.setAllButtonsInteractive(false);
	movie.setButtonInteractive("VEC", true);
	movie.setButtonInteractive("DEL", true);
	// LIBERAR SOMENTE O BOTÃO DE VETORES 3+
}

function start_n9(){
//Redefinir o range do gráfico novamente para 0 a 5, em x e y, para o caso de o aluno ter mexido nisso.
	movie.showField(false);
	movie.setAllButtonsInteractive(false);
	// LIBERAR SOMENTE O BOTÃO DE VETORES 3+
}

function start_n10(){

	//A partir deste frame a atividade começa a explorar o conceito de linhas de campo. 
	//Para isso, remova todas as flechas criadas pelo usuário nos frames anteriores e exiba o campo na grade do gráfico.
	
	//A atividade pede ao aluno que pegue a bússola (ponto de prova) e escolha um ponto qualquer da área de exploração para começar. 
	//Apenas as ferramentas necessárias para criar, editar e remover o ponto de prova (bússola) deve estar disponíveis.

	movie.reset();
	movie.showField(false);
	movie.setAllButtonsInteractive(false);	
	movie.setButtonInteractive("PARTICULA", true);

	
}


function start_n11(){
	movie.reset();
	movie.setField("Campo3");
	movie.showField(true);
	movie.setAllButtonsInteractive(false);	
	movie.setButtonInteractive("PONTO_PROVA", true);
	movie.setButtonInteractive("DEL", true);
	
	
}


function start_n12(){
	movie.setButtonInteractive("PONTO_PROVA", true);
	movie.setButtonInteractive("MARKER", true);
	movie.setMaxMarkers(1);
	
}

function start_n12b(){
	movie.setMaxMarkers(2);
}

function start_n13(){
	movie.setButtonInteractive("PONTO_PROVA", true);
	movie.setButtonInteractive("MARKER", true);
	movie.setMaxMarkers(-1);
}

function start_n14(){
	var scoreEx2 = movie.addAnswerEx2();
	if(memento.completed == false){
		memento.score += scoreEx2/2;
		memento.completed = true;
		commit(memento);
	}
	$("#n14_acerto").html(scoreEx2 + "%.");
	movie.setButtonInteractive("PARTICULA", true);
	movie.setMaxMarkers(-1);
}

/*
 Essas funções eval_FRAMENAME são disparadas geralmente pelos botões de interação. É onde colhe-se as respostas dos usuários.
 */



function eval_n3(x, y, r1, r2){
    valid = validateAnswer("#n3_tx1") && validateAnswer("#n3_tx2") && validateAnswer("#n3_tx3") && validateAnswer("#n3_tx4");
    if(!valid) {
		notificar("Um ou mais valores estão incorretos ou em branco, corrija-os antes de prosseguir.");
		return;
	}
	
	
	dadosExercicio1 = [x, y, x*y, x+y]
	$("#posicaoEx1").html("(" + x + ", " + y + ")")
	var xmin, xmax, ymin, ymax; // colhe os limites do gráfico
	var ok = false;
	/*
	if(x < xmin || x > xmax || y < ymin || y > ymax){
		//caso o valor de (x,y) escolhido não esteja na área do gráfico, apresentar uma caixa de diálogo com a mensagem 
		//"Escolha um (x,y) que esteja na área do gráfico (apenas para simplificar)." e esperar uma nova resposta
		notificar('Escolha um (x,y) que esteja na área do gráfico (apenas para simplificar).');
		return;
	}
	*/	
	// calcula se a resposta está correta e devolve ok (true/false)
	if(r1==dadosExercicio1[2] && r2==dadosExercicio1[3]){ //TODO: botar uma tolerância de 0.1 aqui (isso é muito, ivan!)
		ok=true;
	}

	if(ok) {	
		loadSlide('n3_s')
	} else {
		// Em (x,y) o valor do campo é (f(x,y),g(x,y)). (usar os valores)
		
		
		$("#n3_correcao").html("Resposta errada! Em ("+dadosExercicio1[0]+","+dadosExercicio1[1]+") o campo é ("+dadosExercicio1[2]+","+dadosExercicio1[3]+").");
		loadSlide('n3_n')
	}
}

function eval_n4(dx, dy){


		if(movie.getUserCount("VEC") < 1){
			proceed = false;			
			notificar("Você precisa colocar o vetor no campo antes de prosseguir.");			
		}else{
			var posXswf = movie.getPositionX();
			var posYswf = movie.getPositionY();
			var posXuser = Number(dadosExercicio1[0]);
			var posYuser = Number(dadosExercicio1[1]);
			
			var difX = Math.abs(Math.abs(posXuser) - Math.abs(posXswf));
			var difY = Math.abs(Math.abs(posYuser) - Math.abs(posYswf));
			
			if(difX > 0.1 && difY > 0.1){
				proceed = false;
				notificar("Você posicionou o vetor no local errado. Corrija antes de prosseguir.");
			}else if(movie.getScoreEx1() < 80){
				proceed = false;
				notificar("Este vetor está incorreto. Reveja seus cálculos e corrija-os antes de prosseguir.");
			}else {
				proceed = true;
			}
		}


//	var resposta = 90; // TODO: Colher do flash a resposta
	
	//if(resposta > 80){
	if(proceed){
		loadSlide('n4_s');
	} /*else {
		loadSlide('n4_n')
	}*/
	
}

function eval_n5(){

	var minVecs_5 = 6; //1 do anterior + 5 do exercício atual.
	var minDist = 0.5;
	var nVecs_5 = movie.getUserCount("VEC");
	var minimumDistance = movie.getMinimunDistanceBetweenVecs();
	
	if(nVecs_5 < minVecs_5){
		proceed = false;
		notificar("Você deve criar 5 ou mais flechas (além da criada no exercício anterior) para prosseguir.");
	}else if(minimumDistance < minDist){
		proceed = false;
		notificar("As flechas estão muito próximas umas das outras. Afaste-as antes de continuar.");
	}else{
		proceed = true;
	}
	if(proceed){
		loadSlide('n5resposta');
	}
	


	
	
// Antes de avaliar a resposta do aluno (botão "avançar"), a atividade (o Javascript, não o Flash!) deve verificar se (1) existem cinco ou mais flechas criadas e (2) se 
// uma flecha qualquer está a mais de 0,5 unidades do gráfico (PARÂMETRO) distante de qualquer outra, nesta ordem. Se a primeira condição não for satisfeita, exibir uma 
//caixa de diálogo (jQuery) com a mensagem "Você deve criar cinco ou mais flechas para prosseguir.". Se a segunda condição não for satisfeita, apresentar a mensagem
 //"As flechas estão muito próximas umas das outras. Afaste-as antes de continuar."	
}



function eval_n7(){
		//A resposta esperada é F=(y,x), ou seja, o primeiro text field preenchido com y e o segundo, com x. Aceitar também Y e X (maiúsculas), respectivamente.
		if($('#n7_tx1').val().toUpperCase()=="Y" && $('#n7_tx2').val().toUpperCase()=="X"){
			//notificar("Correto!");
			loadSlide('n7_s');
		} else {
			//notificar('O campo vetorial correto é F = (y,x).');
			loadSlide('n7_n');
		}

}

function eval_n8(){
	//Antes de prosseguir para o frame seguinte (botão "avançar"), verificar se 
	//(1) há ao menos três vetores criados e se 
	//(2) o nível de acerto deles é superior a 80% (PARÂMETRO). Se a primeira condição não for satisfeita, apresentar uma caixa de diálogo (jQuery) com a mensagem 
	//"Você deve criar três ou mais flechas para prosseguir.". Se a segunda condição não for satisfeita, apresentar uma caixa de diálogo com a mensagem 
	//"Os vetores estão incorretos. Corrija-os antes de prosseguir.". Não há avaliação de nota a ser feita aqui.

	

	var minVecs_8 = 3;
		var nVecs_8 = movie.getUserCount("VEC");
		var minScore_8 = 80;
		var score_8 = movie.getScoreEx1();
		
		if(nVecs_8 < minVecs_8){
			proceed = false;
			notificar("Você deve criar 3 ou mais flechas para prosseguir.");
		}else if(score_8 < minScore_8 && !DEBUG){
			proceed = false;
			notificar("Os vetores estão incorretos. Corrija-os antes de prosseguir.");
		}else{
			proceed = true;
		}
	
	if(proceed){
		//notificar('Etapa concluída!');
		loadSlide('n8b');

	}
}

function eval_n12(){
		if(movie.getUserCount("MARKER") < 1){
			notificar("Faça uma marcação para poder continuar.");
		}else{
			loadSlide('n12b');
		}		
		

}

function eval_n13(){
		if(movie.getUserCount("MARKER") < 2){
			proceed = false;
			notificar("Faça outra marcação para continuar.");
		}else{
			var minBussolaPass = movie.getMinimunDistanceBetweenMarkers();
			var minPass = 20;
			if(minBussolaPass > minPass){
				proceed = false;
				notificar("Reduza um pouco mais o passo ou sua linha de campo ficará incorreta.");
			}else{
				proceed = true;
			}
		}
		if(proceed) loadSlide('n13');
}

function eval_n14(){
	var passosUsuario = movie.getUserCount("MARKER");
	var minPassos = 20;
	
	if(passosUsuario < minPassos){
		var passosRestantes = minPassos - passosUsuario;
		proceed = false;
		alert("Você precisa executar no mínimo mais " + passosRestantes + " passos antes de prosseguir.");
	}else{
		proceed = true;
	}
	
	if(proceed) loadSlide('n14');
}

function notificar(tx){
	//TODO: substituir o 'alert' por um pseudo pop-up (?)
	alert(tx);
}


// Checks if given selector (type input) is a valid number. If not, resets field.
function validateAnswer (selector) {
  var value = $(selector).val().replace(",", ".");
  var isValid = !isNaN(value) && value != "";
  if (!isValid) $(selector).val("");
  return isValid;
}

 