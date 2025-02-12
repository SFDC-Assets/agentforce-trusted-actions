/**
 * @description       : Returns the unique id of the current AuthSession to update the Messaging Session
 * @author            : tegeling@salesforce.com
 * @group             :
 * @last modified on  : 12-19-2024
 * @last modified by  : tegeling@salesforce.com
 **/
public with sharing class AgentAuthenticator {
  @InvocableMethod(
    label='Get AuthSession identifier'
    description='Returns the unique id of the current AuthSession.'
  )
  public static List<ActionResponse> getAuthSessionId() {
    List<ActionResponse> responses = new List<ActionResponse>();
    ActionResponse response = new ActionResponse();
    response.authSessionId = Auth.SessionManagement.getCurrentSession()
      .get('SessionId');
    responses.add(response);
    return responses;
  }

  public class ActionResponse {
    @InvocableVariable(description='Current AuthSession Id.')
    public String authSessionId;
  }
}
