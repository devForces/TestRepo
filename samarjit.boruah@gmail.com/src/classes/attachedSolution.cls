public with sharing class attachedSolution {
	public Id caseId{get;set;}
	public Solution sol{
		get{
			List<CaseSolution> csolList = [Select c.Solution.SolutionName, c.Solution.Id, c.SolutionId, c.CaseId From CaseSolution c where c.CaseId =:caseId];
			if(csolList != null && csolList.size()>0){
				sol = csolList[0].Solution;
			}
			return sol; 
		}
		set;
	}
}