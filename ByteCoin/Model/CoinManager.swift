//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegat {
    
    func didGetCoin(_ coin: CoinModel)
    func failWithError(_ error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=334915FD-D8CB-4B32-8592-24A51E7CA0A1"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegat: CoinManagerDelegat?
    
    func getCoinPrice(for currency: String) {
        let urlStr = "\(baseURL)/\(currency)\(apiKey)"
        if let url = URL(string: urlStr) {
            getCurrencyDataWith(url)
        }
    }
    
    
    func getCurrencyDataWith(_ url: URL) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                self.delegat?.failWithError(error!)
            } else {
                if let coin = parseJSON(data!) {
                    self.delegat?.didGetCoin(coin)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(_ data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        do {
            let decoded = try decoder.decode(CoinData.self, from: data)
            let coinInstance = CoinModel(rate: decoded.rate, quote: decoded.asset_id_quote)
            return coinInstance
        }
        catch {
            print(error)
            return nil
        }
    }
    
}
