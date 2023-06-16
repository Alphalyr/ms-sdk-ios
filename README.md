# Alphalyr Marketing Studio Swift SDK

## Getting started

### Pre-requisites
This SDK relies on Universal Links. You may refer to this [guide](https://abhimuralidharan.medium.com/universal-links-in-ios-79c4ee038272) in order to setup your mobile app with a domain name.

### Install the SDK

### Initialize the SDK in your app

```swift
import SwiftUI
import AlphalyrMarketingStudioSdk

@main
struct myApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // Initializing the SDK
                    AlphalyrMarketingStudioSdk(aid: "MY_ALPHALYR_AID")
                }
                .onOpenURL { URL in
                    // Adding a listener on Universal Links
                    AlphalyrMarketingStudioSdk.onOpenUrl(URL)
                }
        }
    }
}
```

### Register your customer preferences

```swift
AlphalyrMarketingStudioSdk.setCustomerId(_ customerId: String)  // usually SHA256 of email address
AlphalyrMarketingStudioSdk.setGdprConsent(_ consent: Bool)
```

### Track a transaction

```swift
AlphalyrMarketingStudioSdk.trackTransaction(
    totalPrice: Float,  // amount without taxes, without shipping costs 
    totalPriceWithTax: Float, // amount with taxes included
    reference: String, // order id
    new: Bool, // true if new customer, false if returning customer
    currency: String, // currency ISO-4217 code (i.e: EUR)
    discountCode: String?, // coupon code
    discountAmount: Float?,
    products: [(id: String, quantity: Int, price: Float)])
)
```