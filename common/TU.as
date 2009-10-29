/* Convenience functions for generating text */
package common{

	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import common.LU;

	public class TU{
		public static function text_format(options:Object=null):TextFormat{
			options = LU.defaults(options, {
				'font' : 'Arial',
				'size' : 12,
				'color' : 0x0,
				'bold' : false,
				'italic' : false,
				'underline' : false,
				'url' : false,
				'target' : null,
				'align' : TextFormatAlign.LEFT,
				'leftMargin' : 0,
				'rightMargin' : 0,
				'indent' : 0,
				'leading' : 0,
				// non constructor options
				'blockIndent' : 0,
				'bullet' : false,
				'kerning' : false,
				'tabStops' : null
			});
			var format:TextFormat = new TextFormat(
				options.font,
				options.size,
				options.color,
				options.bold,
				options.italic,
				options.underline,
				options.url,
				options.target,
				options.align,
				options.leftMargin,
				options.rightMargin,
				options.indent,
				options.leading
			);
			format.blockIndent = options.blockIndent;
			format.bullet = options.bullet;
			format.kerning = options.kerning;
			format.tabStops = options.tabStops;
			return format;
		}

		public static function text_field(options:Object = null):TextField{
			options = LU.defaults(options,{
				'format' : null,
				'autoSize' : TextFieldAutoSize.LEFT,
				'background' : false,
				'backgroundColor' : 0xFFFFFF,
				'border' : false,
				'borderColor' : 0,
				'condenseWhite' : false,
				'embedFonts' : false,
				'htmlText' : false,
				'multiline' : false,
				'selectable' : false,
				'text' : '',
//				'textColor' : 0, // will get overridden by default format
				'wordWrap' : false,
				'padding' : 0
			});
			var field:TextField = new TextField();
			field.defaultTextFormat = TU.text_format(options.format);
			field.embedFonts = options.embedFonts;
			field.background = options.background;
			field.backgroundColor = options.backgroundColor;
			field.border = options.border;
			field.borderColor = options.borderColor;
			field.condenseWhite = options.condenseWhite;
			field.htmlText = options.htmlText;
			field.multiline = options.multiline;
			field.selectable = options.selectable;
			field.wordWrap = options.wordWrap;
			field.text = options.text;
			field.autoSize = options.autoSize;
			if(options.padding > 0){field.width = field.textWidth + options.padding;}
			return field;
		}
	}
}