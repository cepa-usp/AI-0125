/*
 * Before fetch hook (executes setup that are independent of AI status).
 */
function preFetchHook () {
	
	$(".init-message").show();
	
	// Insere o filme Flash na página HTML
	$("#ai-container").flash({
		swf: "swf/AI-0125.swf",
		width: 640,
		height: 480,
		play: false,
		id: "ai",
		allowScriptAccess: "always",
		flashvars: {},
		expressInstaller: "swf/expressInstall.swf",
	});

	// Referência para o filme Flash. 
	movie = $("#ai")[0]; 	
	
	// Conta o número de frames
	N_FRAMES = countFrames();
  
	// Sidebar
	$(".borda").click(toggleSidebar);
	
	// Botão "avançar"
	$("#step-forward").button().click(stepForwardOrFinish);

	// Tecla "enter" (também avança)
	$(":input").keypress(function (event) {
		if (event.which == 13) stepForwardOrFinish();
	});
	
	// Botão "reset"
	$("#reset").button({disabled: true}).click(function () {
		$("#reset-dialog").dialog("open");
	});

	// Configura as caixa de diálogo do botão "reset".
	$("#reset-dialog").dialog({
		buttons: {
			"Ok": function () {
				$(this).dialog("close");
				reset();
			},
			"Cancelar": function () {
				$(this).dialog("close");
			}
		},
		autoOpen: false,
		modal: true,
		width: 350
	});

	// Configura as caixa de diálogo de seleção dos animais (imagens).
	$("#finish-dialog").dialog({
		buttons: {
			"Ok": function () {
				$(this).dialog("close");
			}
		},
		autoOpen: false,
		modal: true,
		width: 500
	});	
	
	// Oculta os feedbacks
	$(".wrong-answer").hide();
	$(".right-answer").hide();
}

/*
 * After fetch hook (executes setup that are dependent of AI status).
 */
function postFetchHook (state) {

	// Adiciona o nome do usuário
	if (state.learner != "") {
		var prename = state.learner.split(",")[1];
		$("#learner-prename").html(prename + ",");
	}

	if (memento.completed) $(".completion-message").show();
	else $(".completion-message").hide();
	
	// Espera os callbacks do filme Flash ficarem disponíveis
	t1 = new Date().getTime();
	checkCallbacks();
}

/*
 * Before set-frame hook.
 */
function preSetFrameHook (targetFrame) {
	return true;
}

/*
 * After set-frame hook.
 */
function postSetFrameHook (targetFrame) {

	memento.frame = targetFrame;
	
	$(".start-invisible").removeClass("start-invisible");
	
	// Restaura o status da AI-0121
	

	// Restaura as respostas dadas
	for (var i = 0; i < 6; i++) {
		var value = memento.answers[i];
		if (value != "") $("#input-" + i).val(value).attr("disabled", "true");
		else $("#input-" + i).val("").removeAttr("disabled");
	}

	// Reexibe campos que estavam visíveis na seção anterior
	$(".wrong-answer").hide();
	$(".right-answer").hide();
	for (var i = 0; i < memento.show.length; i++) {
		$(memento.show[i]).show();
	}
	
	// Restaura campos alterados na seção anterior
	for (var i = 0; i < memento.restore.length; i++) {
		$(memento.restore[i][0]).html(memento.restore[i][1]);
	}

	// Configura os botões "avançar" e "recomeçar"
	var allow_reset = memento.completed && memento.frame > 0;
	$("#reset").button({disabled: !allow_reset});
	$("#step-forward").button({disabled: (memento.frame == N_FRAMES && memento.completed)});
  
	// Configuração específica de cada quadro
	switch (frame) {
		// 0 --> 1
		case  1:
		  break;
		  
		// 1 --> 2
		case  2:
		  break;
		  
		// 2 --> 3
		case  3:
		  break;
		  
		// 3 --> 4
		case  4:
		  break;

		// 4 --> 5
		case  5:
			break;
		  
		// 5 --> 6
		case  6:
		  break;
		  
		// 6 --> 7
		case  7:
		  break;

		// 7 --> 8
		case  8:
		  break;
		  
		// 8 --> 9
		case  9:
		  break;
		  
		// 9 --> 10
		case 10:
		  break;
		  
		// 10 --> 11
		case 11:
		  break;
		  
		// 11 --> 12
		case 12:
		  break;
		  
		// 12 --> 13
		case 13:
		  break;
		  
		// 13 --> 14
		case 14:
		  break;
		  
		// 14 --> 15
		case 15:
		  break;
		  
		// 15 --> 16
		case 16:
		  break;
		  
		// 16 --> 17
		case 17:
		  break;
		  
		// 17 --> 18
		case 18:
		  break;
		  
		default:
		  break;
	}
}

/**
 * This hook runs when the pre-set-frame hook returns false.
 */
function refusedSetFrameHook (targetFrame) {
}

/*
 * Before step-forward hook. If it returns false, step-foward will not be executed.
 */
function preStepForwardHook () {
  
  var proceed = false;
  
  switch (frame) {
    // 3 --> 4
    case 3:
      proceed = validateAnswer("#input-0") && validateAnswer("#input-1") && validateAnswer("#input-2") && validateAnswer("#input-3");
	  if(!proceed) alert("Um ou mais valores estão incorretos ou em branco, corrija-os antes de prosseguir.");
      break;
      
    // 4 --> 5
    case 4:
		if(movie.getUserCount("VEC") < 1){
			proceed = false;
			alert("Você precisa colocar o vetor no campo antes de prosseguir.");
		}else{
			var posXswf = movie.getPositionX();
			var posYswf = movie.getPositionY();
			var posXuser = Number($("#input-0").val().replace(",", "."));
			var posYuser = Number($("#input-1").val().replace(",", "."));
			
			var difX = Math.abs(Math.abs(posXuser) - Math.abs(posXswf));
			var difY = Math.abs(Math.abs(posYuser) - Math.abs(posYswf));
			
			if(difX > 0.1 && difY > 0.1){
				proceed = false;
				alert("Você posicionou o vetor no local errado. Corrija antes de prosseguir.");
			}else if(movie.getScoreEx1() < 80){
				proceed = false;
				alert("Este vetor está incorreto. Reveja seus cálculos e corrija-os antes de prosseguir.");
			}else {
				proceed = true;
			}
		}
      break;
	  
	// 5 --> 6
	case 5:
		var minVecs_5 = 6; //1 do anterior + 5 do exercício atual.
		var minDist = 0.5;
		var nVecs_5 = movie.getUserCount("VEC");
		var minimumDistance = movie.getMinimunDistanceBetweenVecs();
		
		if(nVecs_5 < minVecs_5){
			proceed = false;
			alert("Você deve criar 5 ou mais flechas (além da criada no exercício anterior) para prosseguir.");
		}else if(minimumDistance < minDist){
			proceed = false;
			alert("As flechas estão muito próximas umas das outras. Afaste-as antes de continuar.");
		}else{
			proceed = true;
		}
		
		break;
      
    // 7 --> 8
    case 7:
		//TO DO: validar o campo de texto que recebe strings.
		if($("#input-4").val() != "" && $("#input-5").val() != "") proceed = true;
		else alert("Um ou mais campos estão em branco, corrija-os antes de prosseguir");
		break;
	  
	// 8 --> 9
	case 8:
		var minVecs_8 = 3;
		var nVecs_8 = movie.getUserCount("VEC");
		var minScore_8 = 80;
		var score_8 = movie.getScoreEx1();
		
		if(nVecs_8 < minVecs_8){
			proceed = false;
			alert("Você deve criar 3 ou mais flechas para prosseguir.");
		}else if(score_8 < minScore_8){
			proceed = false;
			alert("Os vetores estão incorretos. Corrija-os antes de prosseguir.");
		}else{
			proceed = true;
		}
		
		break;
	
	//11 --> 12
	case 11:
		if(movie.getUserCount("MARKER") < 1){
			proceed = false;
			alert("Faça uma marcação para continuar.");
		}else{
			proceed = true;
		}
		break;
		
	//12 --> 13
	case 12:
		if(movie.getUserCount("MARKER") < 2){
			proceed = false;
			alert("Faca outra marcação para continuar.");
		}else{
			var minBussolaPass = movie.getMinimunDistanceBetweenMarkers();
			var minPass = 20;
			if(minBussolaPass > minPass){
				proceed = false;
				alert("Reduza um pouco mais o passo ou sua linha de campo ficará incorreta.");
			}else{
				proceed = true;
			}
		}
		break;
		
	// 13 --> 14
	case 13:
		var passosUsuario = movie.getUserCount("MARKER");
		var minPassos = 20;
		
		if(passosUsuario < minPassos){
			var passosRestantes = minPassos - passosUsuario;
			proceed = false;
			alert("Você precisa executar no mínimo mais " + passosRestantes + " passos antes de prosseguir.");
		}else{
			proceed = true;
		}
		break;
      
    // Demais transições não requerem análise   
    default:
      proceed = true;
      break;
  }
  
  return proceed;
}

/*
 * After step-forward hook.
 */
function postStepForwardHook () {

	memento.frame = frame;
  
	var allow_reset = memento.completed && memento.frame > 0;
	$("#reset").button({disabled: !allow_reset});
	
	switch (frame) {
		// 0 --> 1
		// -------------------------------------------
		case 1:
			movie.reset();
			movie.showField(true);
			movie.setAllButtonsInteractive(false);
			break;
		  
		// 1 --> 2
		// -------------------------------------------
		case  2:
			movie.showField(false);
			movie.setMouseVec(true);
			break;
		  
		// 2 --> 3
		// -------------------------------------------
		case  3:
			movie.setMouseVec(false);
			break;
		  
		// 3 --> 4
		// -------------------------------------------
		case  4:
			var user_answer = $("#input-0").val().replace(",", ".");
			var user_answer1 = $("#input-1").val().replace(",", ".");
			var user_answer2 = $("#input-2").val().replace(",", ".");
			var user_answer3 = $("#input-3").val().replace(",", ".");
			
			var correct_answer = $("#input-0").val().replace(",", ".");
			var correct_answer1 = $("#input-1").val().replace(",", ".");
			var correct_answer2 = correct_answer * correct_answer1;
			var correct_answer3 = Number(correct_answer) + Number(correct_answer1);
			
			if (checkAnswer(correct_answer, user_answer, TOLERANCE) && checkAnswer(correct_answer1, user_answer1, TOLERANCE) &&
				checkAnswer(correct_answer2, user_answer2, TOLERANCE) && checkAnswer(correct_answer3, user_answer3, TOLERANCE)) {
				++memento.count;
				$("#right-answer-0").show();
				memento.show.push("#right-answer-0");
				message("Acertou frame 3");
			}
			else {
				var formated_answer = formatNumber(correct_answer);
				var formated_answer1 = formatNumber(correct_answer1);
				var formated_answer2 = formatNumber(correct_answer2);
				var formated_answer3 = formatNumber(correct_answer3);
				$("#answer-0").html(formated_answer);
				$("#answer-1").html(formated_answer1);
				$("#answer-2").html(formated_answer2);
				$("#answer-3").html(formated_answer3);
				memento.restore.push(["#answer-0", formated_answer]);
				memento.restore.push(["#answer-1", formated_answer]);
				memento.restore.push(["#answer-2", formated_answer]);
				memento.restore.push(["#answer-3", formated_answer]);
				$("#wrong-answer-0").show();
				memento.show.push("#wrong-answer-0");
				message("Errou frame 3.");
			}

			$("#input-0").attr("disabled", "true");
			$("#input-1").attr("disabled", "true");
			$("#input-2").attr("disabled", "true");
			$("#input-3").attr("disabled", "true");
			
			memento.answers[0] = formatNumber(user_answer);
			memento.answers[1] = formatNumber(user_answer1);
			memento.answers[2] = formatNumber(user_answer2);
			memento.answers[3] = formatNumber(user_answer3);
			
			
			movie.setButtonInteractive("VEC", true);
			movie.setButtonInteractive("DEL", true);
			movie.setMaxVecs(1);
			
			break;
		  
		// 4 --> 5
		// -------------------------------------------
		case  5:
			movie.setMaxVecs(-1);
			break;
		
		// 5 --> 6  
		// -------------------------------------------
		case  6:
			var scoreEx1 = movie.addAnswerEx1();
			alert("Nível de acerto: " + scoreEx1 + "%.");
			movie.setAllButtonsInteractive(false);
			break;
		  
		// 6 --> 7
		// -------------------------------------------
		case  7:
			movie.reset();
			movie.setAllButtonsInteractive(false);
			//movie.setField("f=(y/x)");
			movie.changeBounds(0,5,0,5);
			movie.addCurves();
			
			break;
		  
		// 7 --> 8
		// -------------------------------------------
		case  8:
			var user_answer_1 = $("#input-4").val().toUpperCase();
			var correct_answer_1 = "Y"

			var user_answer_2 = $("#input-5").val().toUpperCase();
			var correct_answer_2 = "X";
				
			var check_1;
			var check_2;
			
			if(user_answer_1 == correct_answer_1) check_1 = true;
			else check_1 = false;
			if(user_answer_2 == correct_answer_2) check_2 = true;
			else check_2 = false;
			
			if (check_1 && check_2) {
				++memento.count;
				++memento.count;
				$("#right-answer-1").show();
				memento.show.push("#right-answer-1");
				message("Acertou frame7");
			}
			else {
				if (check_1 || check_2) ++memento.count;
				
				$("#answer-4").html(correct_answer_1);
				memento.restore.push(["#answer-4", correct_answer_1]);
				
				$("#answer-5").html(correct_answer_2);
				memento.restore.push(["#answer-5", correct_answer_2]);
				
				memento.show.push("#wrong-answer-1");
				$("#wrong-answer-1").show();
				
				message("Errou frame 7");
			}

			$("#input-4").attr("disabled", "true");
			$("#input-5").attr("disabled", "true");

			
			memento.answers[4] = correct_answer_1;
			memento.answers[5] = correct_answer_2;
			
			movie.changeBounds(0,5,0,5);
			movie.setButtonInteractive("VEC", true);
			movie.setButtonInteractive("DEL", true);
			
			break;
		  
		// 8 --> 9
		// -------------------------------------------
		case  9:
			movie.setAllButtonsInteractive(false);
			break;
		  
		// 9 --> 10
		// -------------------------------------------
		case 10:
			movie.reset();
			movie.showField(true);
			movie.setAllButtonsInteractive(false);
			break;
		
		// 10 --> 11
		// -------------------------------------------
		case 11:
			movie.setButtonInteractive("PONTO_PROVA", true);
			movie.setButtonInteractive("MARKER", true);
			movie.setButtonInteractive("DEL", true);
			movie.setMaxMarkers(1);
			break;
		
		// 11 --> 12 
		case 12:
			movie.setMaxMarkers(2);
			break;
			
		// 12 --> 13
		// -------------------------------------------
		case 13:
			movie.setMaxMarkers(-1);
			break;
			
		// 13 --> 14
		// -------------------------------------------
		case 14:
			var scoreEx2 = movie.addAnswerEx2();
			alert("Nível de acerto: " + scoreEx2 + "%.");
			
			movie.setButtonInteractive("PARTICULA", true);
			
			break;
			
		// 14 --> 15
		// -------------------------------------------
		case 15:
			//movie.setField("");
			movie.setAllButtonsInteractive(true);

			break;
		  
		
		// Demais transições não requerem análise
		// -------------------------------------------
		default:
			// Nada
			break;
	}
	
	commit(memento);
}

/*
 * Step-forward failure hook. It runs after "preStepForwardHook()" returns false
 */
function refusedStepForwardHook () {
}

/*
 * Before step-backward hook. If it returns false, step-backward will not be executed.
 */
function preStepBackwardHook () {
	return true;
}

/*
 * After step-backward hook.
 */
function postStepBackwardHook () {
}

/*
 * Step-backward failure hook. It runs after "preStepBackwardHook()" returns false
 */
function refusedStepBackwardHook () {
}

/*
 * Finish this AI
 */
function finish () {
	
	$(".completion-message").show();
	$("#score").html(memento.count);
	$("#finish-dialog").dialog("open");
	$("#step-forward").button({disabled: true});
	$("#reset").button({disabled: false});
	
	if (!memento.completed) {
		memento.completed = true;
		memento.score = Math.max(0, Math.min(Math.ceil(100 * memento.count / memento.answers.length), 100));
		commit(memento);
	}
}

/*
 * Move forward, stepping to the next frame or finishing this AI
 */
function stepForwardOrFinish () {
	if (memento.frame < N_FRAMES) stepForward();
	else finish();
}

// Checks if given selector (type input) is a valid number. If not, resets field.
function validateAnswer (selector) {
  var value = $(selector).val().replace(",", ".");
  var isValid = !isNaN(value) && value != "";
  if (!isValid) $(selector).val("");
  return isValid;
}

// Check given answer against expected one, with relative tolerance also given
function checkAnswer (correct_answer, user_answer, tolerance) {
  return Math.abs(correct_answer - user_answer) < correct_answer * tolerance;
}

// Format a given number with 2 decimal places, and substitute period by comma.
function formatNumber (string) {
	return new Number(string).toFixed(2).replace(".", ",");
}