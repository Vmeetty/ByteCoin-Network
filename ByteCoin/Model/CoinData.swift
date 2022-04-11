//
//  CoinData.swift
//  ByteCoin
//
//  Created by user on 12.04.2022.
//  Copyright © 2022 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Decodable {
    let rate: Float
    let asset_id_quote: String
}
