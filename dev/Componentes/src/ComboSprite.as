package 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	/**
	 * @author CEPA/Diego
	 */
	public class  ComboSprite extends Sprite
	{
		private var _sprCombo:SprCombo = new SprCombo(); //SPRITE
		private var _iCampoArray = new Array(); //VETOR DE ICAMPOS GLOBAL
		private var _comboIndex:int = 0; //POSICAO DO COMBO EM RELAÇÃO AO VETOR ICAMPOS
		
		public function ComboSprite (iCampoArray:Array) {
			_iCampoArray = iCampoArray;
			config();
		}
		/**
		 * CONFIGURAÇÕES INICIAIS
		 */
		private function config():void 
		{
			_sprCombo.upButton.buttonMode = true;
			_sprCombo.downButton.buttonMode = true;
			
			_sprCombo.upButton.addEventListener(MouseEvent.MOUSE_DOWN, changeCombo);
			_sprCombo.downButton.addEventListener(MouseEvent.MOUSE_DOWN, changeCombo);
			addChild(_sprCombo);
			
			//AQUI VISUALIZA O SPRITE CORRESPONDENTE AO INDICE ZERO DO VETOR
				//CONFIGURAÇÃO INICIAL DO COMBO, CARREGANGO O SPRITE INICIAL NELE.
			//
		}
		
		/**
		 * FUNÇÃO CHANGECOMBO - CONTROLADA PELAS SETAS CIMA E BAIXO. FUNÇÃO DE ALTERAÇÃO DO CAMPO (UPBUTTON E DOWNBUTTON)
		 * TEM CONTROLE PARA NÃO SAIR DOS LIMITES DO ARRAY (INDICE ZERO ATÉ O MAIOR POSSIVEL)
		 * @param	e - MOUSEEVENT
		 */
		private function changeCombo(e:MouseEvent):void 
		{
			if (e.currentTarget.name == "upButton" && _comboIndex != _iCampoArray.length - 1) { //NÃO MAIOR QUE O MÁXIMO
				_comboIndex++;
				trace(_iCampoArray[_comboIndex]);
			}
			if (e.currentTarget.name == "downButton" && _comboIndex != 0) { //NÃO MENOR QUE O MÍNIMO
				_comboIndex--;
				trace(_iCampoArray[_comboIndex]);
			}
		}
		
		/**
		 * FUNÇÃO SET QUE HABILITA E DESABILITA A TROCA DE CAMPOS POR ESTE COMPONENTE. COMO UM ENABLE TRUE/FALSE, 
		 * SÓ QUE ELE APENAS ESCONDE OS BOTÕES.
		 */
		public function set locked (value:Boolean) : void {
			_sprCombo.upButton.visible = !value;
			_sprCombo.downButton.visible = !value;
		}
	}
	
}