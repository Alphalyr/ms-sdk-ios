import Foundation
import UIKit

public class AlphalyrMarketingStudioSdk {
    static private var aid: String = ""
    private var gdprConsent: Bool = false
    private var deviceType: String = "u"
    private let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"

    public init(aid: String) {
        AlphalyrMarketingStudioSdk.aid = aid
        self.setDeviceType()
    }
    
    static public func setReferer(_ application: UIApplication, _ launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) {
        print("setReferer")
        if let userUrl = launchOptions?[.url] {
            // Access the NSUserActivity object
            print("User Activity: \(userUrl)")
        }
    }
    
    public func setGdprConsent(_ newValue: Bool) {
        self.gdprConsent = newValue
    }
    
    public func trackLandingHit(cid: String) {
        let page = "app"
    
        let path="path"
        let referrer = "self"
        let utm_source = "source"
        let utm_medium = "medium"
        let utm_campaign = "campaign"
        
        let queryParams = "aid=\(AlphalyrMarketingStudioSdk.aid)&page=\(page)&device_type=\(self.deviceType)&uuid=\(self.deviceId)&path=\(path)&gdpr_consent=\(gdprConsent ? "1" : "0")&referrer=\(referrer)&utm_source=\(utm_source)&utm_medium=\(utm_medium)&utm_campaign=\(utm_campaign)&cid=\(cid)"
        self.requestApi(path: "tag/store", queryParams: queryParams)
    }
    
    private func setDeviceType(){
        if UIDevice.current.userInterfaceIdiom == .phone {
            self.deviceType = "m"
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            self.deviceType = "t"
        } else {
            self.deviceType = "u"
        }
    }
    
    private func requestApi(path: String, queryParams: String) {
        let fullUrl = "https://webhook.site/d70665a4-e0cf-439a-9706-e4c2696e773f?\(queryParams)"
        // let url = URL(string: "https://webhook.site/d70665a4-e0cf-439a-9706-e4c2696e773f?\(queryParams)")
        let url = URL(string: fullUrl)
        //let url = URL(string: "https://tck.elitrack.com/\(path)?\(queryParams)")
        guard let requestUrl = url else { fatalError() }
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
         
        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                // Convert HTTP Response Data to a String
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("Response data string:\n \(dataString)")
                }
        }
        task.resume()
    }
}
