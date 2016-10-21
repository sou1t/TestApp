//
//  CoinsViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 10.07.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import StoreKit
import mopub_ios_sdk
import Chirp
import Flurry_iOS_SDK
import GoogleMobileAds


class CoinsViewController: UIViewController, MPInterstitialAdControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var coins = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
    
    

    @IBOutlet weak var Indicator50: UIActivityIndicatorView!
    @IBOutlet weak var Indicator100: UIActivityIndicatorView!
    @IBOutlet weak var Indicator10: UIActivityIndicatorView!
    @IBOutlet weak var FreeCoins: UIButton!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var price3: UILabel!
    @IBOutlet weak var Get50Coins: UIButton!
    @IBOutlet weak var Get10Coins: UIButton!
    @IBOutlet weak var Get100Coins: UIButton!
    var interstitial: GADInterstitial!
    @IBOutlet weak var RestoreButton: UIButton!
    
    @IBOutlet weak var CoinsLabel: UILabel!

    var interstitial1: MPInterstitialAdController =
        MPInterstitialAdController(forAdUnitId: "095a207910074051b61c64c78474069f")

    
    
    @IBAction func Exit(sender: AnyObject) {
        Flurry.logEvent("User exit the page with coins")
        self.navigationController?.popToRootViewControllerAnimated(true)
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Indicator10.startAnimating()
        Indicator50.startAnimating()
        Indicator100.startAnimating()
        CoinsLabel.text = coins
        Get10Coins.enabled = true
        Get50Coins.enabled = true
        Get100Coins.enabled = true
        FreeCoins.enabled = true
        RestoreButton.enabled = true
        price1.hidden = true
        price2.hidden = true
        price3.hidden = true
        

        if(SKPaymentQueue.canMakePayments())
        {
            print("IAP is enabled, loading...")
            let productID: NSSet = NSSet(objects: "Vitalyi.QuizApp.add.10coins", "Vitalyi.QuizApp.add.50coins", "Vitalyi.QuizApp.add.100coins")
            let request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as! Set<String>)
            request.delegate = self
            request.start()
        }
        else
        {
            print("please enable IAPs")
        }
        createAndLoadInterstitial()
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.prepareSound(fileName: "tapMenu.mp3")
            Chirp.sharedManager.prepareSound(fileName: "coins.mp3")
        }
        //self.interstitial.delegate = self
        // Pre-fetch the ad up front
        //self.interstitial.loadAd()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GetCoinsClicked(sender: UIButton) {
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        
        for product in list
        {
            let productId = product.productIdentifier
            switch sender.tag {
            case 10:
                if(productId == "Vitalyi.QuizApp.add.10coins")
                {
                  p = product
                    BuyProduct()
                    Flurry.logEvent("User click 'buy 10 coins'")
                    break;
                }
            case 50:
                if (productId == "Vitalyi.QuizApp.add.50coins")
                {
                    p = product
                    BuyProduct()
                    Flurry.logEvent("User click 'buy 50 coins'")
                    break;
                }
                
            case 100:
                if (productId == "Vitalyi.QuizApp.add.100coins")
                {
                    p = product
                    BuyProduct()
                    Flurry.logEvent("User click 'buy 100 coins'")
                    break;
                }
            default:
                print("error in tags")
            }

                }
    }

    @IBAction func RestorePurchaseClicked(sender: UIButton) {
        Flurry.logEvent("User wants to restore purchase")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func GetCoins(number:Int){
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "coins.mp3")
        }
        let new = Int(self.coins)! + number
        NSUserDefaults.standardUserDefaults().setValue("\(new)", forKey: "coins")
        self.CoinsLabel.text = "\(new)"
        SweetAlert().showAlert("Покупка выполнена!", subTitle: "Вы получаете \(number) монет.", style: AlertStyle.CustomImag(imageFile: "goldIco"))
    }
    
    var list = [SKProduct]()
    var p = SKProduct()
    
    //Vitalyi.QuizApp.add.10coins
    //Vitalyi.QuizApp.add.50coins
    //Vitalyi.QuizApp.add.100coins
    
    func BuyProduct(){
        print("buy" + p.productIdentifier)
        let pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
        
    }
    
    func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
        print("product request")
        let products = response.products
        
        for product in products {
            print("product added")
            print(product.localizedTitle)
            print(product.localizedDescription)
            print(product.price)
            Indicator10.hidden = true
            Indicator50.hidden = true
            Indicator100.hidden = true
            let prodID = product.productIdentifier as String
            switch prodID {
            case "Vitalyi.QuizApp.add.10coins":
                price1.text = "\(product.price)₽"
                price1.hidden = false
                RestoreButton.enabled = true
            case "Vitalyi.QuizApp.add.50coins":
                price2.text = "\(product.price)₽"
                price2.hidden = false
                
            case "Vitalyi.QuizApp.add.100coins":
                price3.text = "\(product.price)₽"
                price3.hidden = false
            default:
                print("______")
            }

            
            list.append(product as SKProduct)
        }
        
//        Get10Coins.enabled = true
//        Get50Coins.enabled = true
//        Get100Coins.enabled = true
//        RestoreButton.enabled = true
//        FreeCoins.enabled = true
//        price1.hidden = false
//        price2.hidden = false
//        price3.hidden = false
        
    }
    
    func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print("add payment")
        for transaction in transactions {
            print(transaction.error)
            
            switch transaction.transactionState {
            case .Purchased:
                print("Buy ok, unlocked")
                print(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "Vitalyi.QuizApp.add.10coins":
                    print("get 10 coins")
                    GetCoins(10)
                case "Vitalyi.QuizApp.add.50coins":
                    print("get 50 coins")
                    GetCoins(50)
                case "Vitalyi.QuizApp.add.100coins":
                    print("get 100 coins")
                    GetCoins(100)
                
                default:
                    print("IAP is not enabled")
                }
                queue.finishTransaction(transaction)
                break;
                
            case .Failed:
                print("Purchase error")
                queue.finishTransaction(transaction)
                break;
                
            default:
                print("default")
                break;
            }
        }
    }
    
    func finishTransaction(trans: SKPaymentTransaction)
    {
        print("finish transaction")
    }
    

    func paymentQueue(queue: SKPaymentQueue, removedTransactions transactions: [SKPaymentTransaction]) {
        print("remove trans")
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue) {
        print("transactions restored")
        
        //var purchasedIDs = []
        
        for transaction in queue.transactions{
            let ProdID = transaction.payment.productIdentifier as String
            switch ProdID {
            case "Vitalyi.QuizApp.add.10coins":
                print("get 10 coins")
                GetCoins(10)
            case "Vitalyi.QuizApp.add.50coins":
                print("get 50 coins")
                GetCoins(50)
            case "Vitalyi.QuizApp.add.100coins":
                print("get 100 coins")
                GetCoins(100)
                
            default:
                print("IAP is not enabled")
            }

        }
    }
    
    @IBAction func FreeCoins(sender: AnyObject) {
        Flurry.logEvent("User click 'get free coins'")
        dispatch_async(dispatch_get_main_queue()){
            Chirp.sharedManager.playSound(fileName: "tapMenu.mp3")
        }
        stopBGmusic()
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            
            if self.interstitial.isReady {
                let new = Int(self.coins)! + 5
                NSUserDefaults.standardUserDefaults().setValue("\(new)", forKey: "coins")
                self.CoinsLabel.text = "\(new)"

                self.interstitial.presentFromRootViewController(self)
            } else {
                print("Ad wasn't ready")
            }
            let delay1 = 8.0 * Double(NSEC_PER_SEC)
            let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay1))
            dispatch_after(time1, dispatch_get_main_queue()){
                playBackgroundMusic("fon")
            }
            
    }

        
    }
    func createAndLoadInterstitial() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-8901960017865562/4264150132")
        let request = GADRequest()
        interstitial.loadRequest(request)
        
    }
    
    
    
}

extension UINavigationController : UINavigationControllerDelegate {
    private struct AssociatedKeys {
        static var currentCompletioObjectHandle = "currentCompletioObjectHandle"
    }
    typealias Completion = @convention(block) (UIViewController)->()
    var completionBlock:Completion?{
        get{
            let chBlock = unsafeBitCast(objc_getAssociatedObject(self, &AssociatedKeys.currentCompletioObjectHandle), Completion.self)
            return chBlock as Completion
        }set{
            if let newValue = newValue {
                let newValueObj : AnyObject = unsafeBitCast(newValue, AnyObject.self)
                objc_setAssociatedObject(self, &AssociatedKeys.currentCompletioObjectHandle, newValueObj, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    func popToViewController(animated: Bool,comp:Completion){
        if (self.delegate == nil){
            self.delegate = self
        }
        completionBlock = comp
        self.popViewControllerAnimated(true)
    }
    func pushViewController(viewController: UIViewController, comp:Completion) {
        if (self.delegate == nil){
            self.delegate = self
        }
        completionBlock = comp
        self.pushViewController(viewController, animated: true)
    }
    
    public func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool){
        if let comp = completionBlock{
            comp(viewController)
            completionBlock = nil
            self.delegate = nil
        }
    }
}
