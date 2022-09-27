pack	Creates an .msapp file from the previously unpacked source files.
        The result can be opened in Power Apps Studio by navigating to File > Open > Browse.
        After being unpacked, the source files can be edited and managed with external tools such as Visual Studio Code and GitHub.	
        
        pac canvas pack --sources MyHelloWorldFiles --msapp HelloWorld.msapp

unpack	Unpacks the .msapp source file.
        Download the .msapp file from Power Apps Studio by navigating to File > Save as > This computer.
        If the sources parameter is not specified, a directory with the same name and location as the .msapp file is used with _src suffix.	
        
        pac canvas unpack --msapp HelloWorld.msapp --sources MyHelloWorldFiles
        
        pac canvas unpack --msapp HelloWorld.msapp (unpacks to default HelloWorld_src directory)