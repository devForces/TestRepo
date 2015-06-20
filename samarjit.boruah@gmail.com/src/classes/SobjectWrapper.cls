public with sharing class SobjectWrapper {
	public boolean selected{get;set;}
	public Sobject sObj{get;set;}
	public SobjectWrapper(Sobject so){
		sObj = so;
		selected = false;
	}

}