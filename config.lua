--
-- For more information on config.lua see the Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application =
{
	content =
	{
	    --寬
		width = 320,
		--高 
		height = 480,
		--縮放模式 
		 --scale = "letterbox",
		scale = "zoomStretch",
		--偵數
		fps = 60,
		
		
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		
	},
}
