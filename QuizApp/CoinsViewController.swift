//
//  CoinsViewController.swift
//  QuizApp
//
//  Created by Виталий Волков on 10.07.16.
//  Copyright © 2016 Виталий Волков. All rights reserved.
//

import UIKit
import StoreKit
import MoPub


class CoinsViewController: UIViewController, MPInterstitialAdControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var coins = NSUserDefaults.standardUserDefaults().valueForKey("coins") as? String ?? "0"
    
    
    @IBOutlet weak var FreeCoins: UIButton!
    @IBOutlet weak var price1: UILabel!
    @IBOutlet weak var price2: UILabel!
    @IBOutlet weak var price3: UILabel!
    @IBOutlet weak var Get50Coins: UIButton!
    @IBOutlet weak var Get10Coins: UIButton!
    @IBOutlet weak var Get100Coins: UIButton!
    
    @IBOutlet weak var RestoreButton: UIButton!
    
    @IBOutlet weak var CoinsLabel: UILabel!

    var interstitial: MPInterstitialAdController =
        MPInterstitialAdController(forAdUnitId: "095a207910074051b61c64c78474069f")


    
    @IBAction func Exit(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.interstitial.delegate = self
        // Pre-fetch the ad up front
        self.interstitial.loadAd()

        Get10Coins.enabled = false
        Get50Coins.enabled = false
        Get100Coins.enabled = false
        FreeCoins.enabled = false
        RestoreButton.enabled = false

        price1.hidden = true
        price2.hidden = true
        price3.hidden = true
        CoinsLabel.text = coins
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
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func GetCoinsClicked(sender: UIButton) {
        
        
        for product in list
        {
            let productId = product.productIdentifier
            switch sender.tag {
            case 10:
                if(productId == "Vitalyi.QuizApp.add.10coins")
                {
                  p = product
                    BuyProduct()
                    break;
                }
            case 50:
                if (productId == "Vitalyi.QuizApp.add.50coins")
                {
                    p = product
                    BuyProduct()
                    break;
                }
                
            case 100:
                if (productId == "Vitalyi.QuizApp.add.100coins")
                {
                    p = product
                    BuyProduct()
                    break;
                }
            default:
                print("error in tags")
            }

                }
    }

    @IBAction func RestorePurchaseClicked(sender: UIButton) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func GetCoins(number:Int){
        var intValue = Int(coins)!
        intValue += number
        NSUserDefaults.standardUserDefaults().setInteger(intValue, forKey: "coins")
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
            let prodID = product.productIdentifier as String
            switch prodID {
            case "Vitalyi.QuizApp.add.10coins":
                price1.text = "\(product.price)₽"
            case "Vitalyi.QuizApp.add.50coins":
                price2.text = "\(product.price)₽"
            case "Vitalyi.QuizApp.add.100coins":
                price3.text = "\(product.price)₽"
            default:
                print("______")
            }

            
            list.append(product as SKProduct)
        }
        
        Get10Coins.enabled = true
        Get50Coins.enabled = true
        Get100Coins.enabled = true
        RestoreButton.enabled = true
        FreeCoins.enabled = true
        price1.hidden = false
        price2.hidden = false
        price3.hidden = false
        
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
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            if (self.interstitial.ready) {
                let new = Int(self.coins)! + 5
                NSUserDefaults.standardUserDefaults().setValue("\(new)", forKey: "coins")
                self.CoinsLabel.text = "\(new)"
                self.interstitial.showFromViewController(self)
            }
        }

        
    }
    
    
    
}
