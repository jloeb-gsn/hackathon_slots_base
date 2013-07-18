/**
* Notice: All JSFL commands have the ability to damage your files. It is recommended
* that you run these commands on copies of your files. You take all responsibility
* for any problems or damage incurred directly or indirectly from running this command.
*/

// These are replaced by the ANT task //
//	// List of files to compile
var fileListString="@fileList@";
//	// Publish location
var publishDir="@pubdir@";
//	// Filepath of the complete file (used to trigger ANT completion)
var completeFile="file:///@completeFile@";


execute();

function execute(){
	
	// Generate array from file list
	var fileList = fileListString.split(",");
	
	// Loop through the files
	for (var ind=0;ind<fileList.length;ind++){
	
		var fileName = "file:///" + fileList[ind];
		
		// Compile the file
		//fl.publishDocument(fileName);
		
		// Open the file
		exists = FLfile.exists(fileName);
		if(exists){
			var sourceFlaDoc = fl.openDocument(fileName);
			if (sourceFlaDoc)
			{
				// Change the publish settings to point to /assets
				updatePublishSettings(sourceFlaDoc);
				
				// Save/replace the FLA
				//fl.saveDocument(sourceFlaDoc, fileName);
		
				// Publish swf of bundle FLA
				sourceFlaDoc.publish();
		
				// Close the bundle FLA;
				fl.closeDocument(fileName,false);
				
			}
		}
		
	}
	
	// Write the complete file to indicate completion to ANT
	//FLfile.write(completeFile, "build complete");
	
	// Quit and ask to save changes to open files. This should have no affect on the build machine as it should not have any open files
	fl.quit(true);//fl.quit(false);
	
}

function updatePublishSettings(sourceFlaDoc)
{
	// Change the publish settings to export just the .swf, and to set correct file path
	var profileXML = sourceFlaDoc.exportPublishProfileString('Default');
	// remove html publishing and default naming
	profileXML = profileXML.replace("<html>1</html>","<html>0</html>");
	profileXML = profileXML.replace("<defaultNames>1</defaultNames>","<defaultNames>0</defaultNames>");
	profileXML = profileXML.replace("<flashDefaultName>1</flashDefaultName>","<flashDefaultName>0</flashDefaultName>");
	var findString = "<flashFileName>";
  	var startIndex = profileXML.indexOf(findString) + findString.length;
  	findString = "</flashFileName>";
	var endIndex = profileXML.indexOf(findString);
	var curName = profileXML.substring(startIndex,endIndex);
	var pubPath = publishDir + sourceFlaDoc.name.split(".")[0];
	//fl.trace("pub:" + pubPath);
	profileXML = profileXML.replace(curName,pubPath);
	sourceFlaDoc.importPublishProfileString(profileXML);
}