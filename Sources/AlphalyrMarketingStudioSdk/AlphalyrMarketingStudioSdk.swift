import Foundation
import UIKit

public class AlphalyrMarketingStudioSdk {
    static private var aid: String = ""
    static private var gdprConsent: Bool = false
    static private var deviceType: String = "u"
    static private let deviceId: String = UIDevice.current.identifierForVendor?.uuidString ?? "unknown"
    static private var customerId: String = ""
    static private var universalLinkingUrl: URL?

    public init(aid: String) {
        AlphalyrMarketingStudioSdk.aid = aid
        AlphalyrMarketingStudioSdk.setDeviceType()
    }

    static public func onOpenUrl(_ url: URL) {
        AlphalyrMarketingStudioSdk.universalLinkingUrl = url
        AlphalyrMarketingStudioSdk.trackLandingHit()
    }

    static public func setGdprConsent(_ newValue: Bool) {
        AlphalyrMarketingStudioSdk.gdprConsent = newValue
    }

    static public func setCustomerId(_ newValue: String) {
        AlphalyrMarketingStudioSdk.customerId = newValue
    }

    static public func trackLandingHit() {
        let queryParams = [AlphalyrMarketingStudioSdk.commonQueryParams(), AlphalyrMarketingStudioSdk.universalLinkingQueryParams()].compactMap { $0 }

        AlphalyrMarketingStudioSdk.requestApi(path: "tag/store", queryParams: queryParams.joined(separator: "&"))
    }

    static private func universalLinkingQueryParams() -> String? {
        guard let url = AlphalyrMarketingStudioSdk.universalLinkingUrl else { return nil }
        let queryParams = AlphalyrMarketingStudioSdk.getUniversalLinkingQueryParams()
        return "path=\(url.path)&utm_source=\(queryParams["utm_source"] ?? "")&utm_medium=\(queryParams["utm_medium"] ?? "")&utm_campaign=\(queryParams["utm_campaign"] ?? "")&referrer=\(queryParams["referrer"] ?? "")"
    }

    static private func getUniversalLinkingQueryParams() -> [String: String] {
        guard let components = URLComponents(url: AlphalyrMarketingStudioSdk.universalLinkingUrl!, resolvingAgainstBaseURL: false) else { return [:] }
        var queryParams: [String: String] = [:]

        for queryItem in components.queryItems ?? [] {
            queryParams[queryItem.name] = queryItem.value
        }

        return queryParams
    }

    static private func commonQueryParams() -> String {
        return "aid=\(AlphalyrMarketingStudioSdk.aid)&device_type=\(AlphalyrMarketingStudioSdk.deviceType)&uuid=\(AlphalyrMarketingStudioSdk.deviceId)&gdpr_consent=\(AlphalyrMarketingStudioSdk.gdprConsent ? "1" : "0")&cid=\(AlphalyrMarketingStudioSdk.customerId)"
    }

    static public func trackTransaction(totalPrice: Float, totalPriceWithTax: Float, reference: String, new: Bool, currency: String, discountCode: String, discountAmount: Float, products: [(id: String, quantity: Int, price: Float)]) {
        let transactionQueryParams = "totalPrice=\(totalPrice)&totalPriceWithTax=\(totalPriceWithTax)&reference=\(reference)&new=\(new ? "1" : "0")&currency=\(currency)&discountCode=\(discountCode)&discountAmount=\(discountAmount)&products=\(stringifyProducts(products))"

        let queryParams = [AlphalyrMarketingStudioSdk.commonQueryParams(), transactionQueryParams].compactMap { $0 }
        requestApi(path: "track/store", queryParams: queryParams.joined(separator: "&"))
    }

    static private func stringifyProducts(_ products: [(id: String, quantity: Int, price: Float)]) -> String {
        return products.map { "\($0.id):\($0.quantity):\($0.price)" }.joined(separator: ";")
    }

    static private func setDeviceType() {
        if UIDevice.current.userInterfaceIdiom == .phone {
            deviceType = "m"
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            deviceType = "t"
        } else {
            deviceType = "u"
        }
    }

    static private func requestApi(path: String, queryParams: String) {
        let fullUrl = "https://webhook.site/4bc1a57c-09ab-40fb-b3cd-76b12d7a2f71?\(queryParams)"
        // let url = URL(string: "https://tck.elitrack.com/\(path)?\(queryParams)")
        
        guard let url = URL(string: fullUrl) else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request)
        task.resume()
    }
}
