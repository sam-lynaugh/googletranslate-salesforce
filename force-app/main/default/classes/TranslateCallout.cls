public with sharing class TranslateCallout {

    //For Production usage, store the following variables in Custom Metadata
    private static final String CERTIFICATE = 'yourcertificate'; //the name of the jks certificate uplodaded in salesforce
    private static final String GOOGLESERVICEACCOUNT = 'your-service-account@your-project.iam.gserviceaccount.com'; //the name of your GCP service account
    private static final String AUDIENCE_CLAIM = 'https://www.googleapis.com/oauth2/v4/token';
    private static final String SCOPE = 'https://www.googleapis.com/auth/cloud-translation'; //translate api specific scope (for JWT)

    @InvocableMethod(callout=true label='Translate Text' description='Calls the Google Translate API to detect the language of a string and translate it to English')
    public static List<Output> translate(List<Input> invocableRequest) {

        Input input = invocableRequest[0];

        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint('https://translation.googleapis.com/language/translate/v2');
        req.setMethod('POST');

        //req.setHeader('Content-Type', 'application/json');
        req.setHeader('Authorization', 'Bearer ' + getAccessToken());

        String body = 'q='+input.text+'&target='+input.target;
        req.setBody(body);
        res = http.send(req);
        Map<string, object> responseMap = (Map<string, object>) JSON.deserializeUntyped(res.getbody());
        Map<string, object>  data = (Map<string, object>) responseMap.get('data');
        Map<string, object> translations = (Map<string, object>)((List<object>) data.get('translations'))[0];

        List <Output> outputs = new List <Output>();
        Output objOutput = new Output();
        objOutput.translatedText = (string) translations.get('translatedText');
        outputs.add(objOutput);
        return outputs;       
        //return (string) translations.get('translatedText');
    }

    //input class to allow you to input multiple parameters from flow
    public class Input{
        @InvocableVariable
        public String text; //The text to be translated, input via the Flow Builder UI
        
        @InvocableVariable
        public String target; //ISO-639 code of language text is to be translated to, input via the Flow Builder UI
    }

    //output class
    public class Output{
        @InvocableVariable
        public String translatedText; //The translated text to be returned to the flow
    }

    //basic method to get authentication token
    private static String getAccessToken() {
        Auth.JWT jwt = new Auth.JWT();
        jwt.setAud(AUDIENCE_CLAIM);
        jwt.setIss(GOOGLESERVICEACCOUNT);
        jwt.setAdditionalClaims(new Map<String, Object>{ 'scope' => SCOPE });
        
        Auth.JWS jws = new Auth.JWS(jwt, CERTIFICATE);
        
        Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(
            jwt.getAud(),
            jws
        );
        if (!Test.isRunningTest()) {
            return bearer.getAccessToken();
        }
        else {
            return 'test-token';
        }
      }
}