@isTest
public class TranslateCalloutTest {

    private static final String CERTIFICATE = 'yourcertificate';
    private static final String GOOGLESERVICEACCOUNT = 'your-service-account@your-project.iam.gserviceaccount.com';
    private static final String AUDIENCE_CLAIM = 'https://www.googleapis.com/oauth2/v4/token';
    private static final String SCOPE = 'https://www.googleapis.com/auth/cloud-translation';
    
    @isTest
    static void testTranslateCallout() {
        Test.setMock(HttpCalloutMock.class, new TranslateCalloutMock());
        Test.startTest();
        
        TranslateCallout.Input input = new TranslateCallout.Input();
        input.text = 'Bonjour';
        input.target = 'en';
        
        List<TranslateCallout.Output> result = TranslateCallout.translate(new List<TranslateCallout.Input>{input});
        
        System.assertEquals('Hello', result[0].translatedText);
        Test.StopTest();
    }
    
    private class TranslateCalloutMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if(req.getEndpoint().contains('language/translate/v2')){
                System.assertEquals('POST', req.getMethod());
                System.assertEquals('https://translation.googleapis.com/language/translate/v2', req.getEndpoint());
                
                HTTPResponse res = new HTTPResponse();
                res.setHeader('Content-Type', 'application/json');
                res.setBody('{"data":{"translations":[{"translatedText":"Hello"}]}}');
                res.setStatusCode(200);
                
                return res;
            }
            else return null;
        }
    }
}