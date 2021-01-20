//
//  RestaurantViewController.swift
//  FinalProject
//
//  Created by James Monahan on 12/10/20.
//

import UIKit
import WebKit
import MapKit
import GooglePlaces

class RestaurantViewController: UIViewController, WKNavigationDelegate{
    var webView: WKWebView!
    
    override func loadView(){
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://www.google.com")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
    }
}
