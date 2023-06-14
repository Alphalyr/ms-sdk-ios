# Alphalyr Marketing Studio Swift SDK

## Getting started

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
AlphalyrMarketingStudioSdk.setCustomerId(_ customerId: String)
AlphalyrMarketingStudioSdk.setGdprConsent(_ consent: Bool)
```

### Track a transaction

```swift
AlphalyrMarketingStudioSdk.trackTransaction(
    totalPrice: Float, 
    totalPriceWithTax: Float, 
    reference: String, 
    new: Bool, 
    currency: String, 
    discountCode: String?, 
    discountAmount: Float?, 
    products: [(id: String, quantity: Int, price: Float)])
)
```

### Track a screen change

```swift
AlphalyrMarketingStudioSdk.trackScreenChange("/new_path")
```
