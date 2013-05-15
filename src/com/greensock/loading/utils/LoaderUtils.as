package com.greensock.loading.utils
{
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.MP3Loader;
	import com.greensock.loading.SWFLoader;
	import com.greensock.loading.XMLLoader;
	import com.greensock.loading.core.LoaderCore;

	public class LoaderUtils
	{
		public static function generateLoader(url: String): LoaderCore
		{
			var prefix: String = url.substr(-3);
			switch(prefix)
			{
				case 'swf':
					return new SWFLoader(url);
					break;
				case 'jpg':
				case 'png':
				case 'gif':
				case 'bmp':
					return new ImageLoader(url);
					break;
				case 'mp3':
					return new MP3Loader(url);
				case 'xml':
					return new XMLLoader(url);
			}
			return null;
		}
		
		public function LoaderUtils()
		{
		}
	}
}