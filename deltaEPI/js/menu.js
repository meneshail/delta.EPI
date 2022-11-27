// JavaScript Document
var tID=0;
var subtID=0;
function showTabs(ID){  
		 if(ID!=tID){  
        eval("document.getElementById('menu"+[tID]+"').className='suboff';");  
        eval("document.getElementById('menu"+[ID]+"').className='subon';");
        tID=ID;  
   	}  
}  
	
function showSubTabs(ID){  
   if(ID!=subtID){  
        eval("document.getElementById('sub"+[subtID]+"').className='suboff';");  
        eval("document.getElementById('sub"+[ID]+"').className='subon';");
        subtID=ID;  
   	}  
}  
