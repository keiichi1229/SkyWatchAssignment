//
//  ApiProvider.swift
//  WhoTube
//
//  Created by Raymondting on 2023/8/30.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

public class ApiProvider {
    
    public static let shared = ApiProvider()
    private init() {}
    
    private var provider = MoyaProvider<MultiTarget>()
    
    func request<Request: TargetType>(_ request: Request) -> Single<Any> {
        let target = MultiTarget.init(request)
        return provider.rx.request(target)
            .flatMap { res in
                if 200 ... 299 ~= res.statusCode {
                    return Single.just(res)
                } else {
                    #if DEBUG
                    print("API Failed: \(request.baseURL.absoluteString + request.path)")
                    print("\(JSON(try res.mapJSON()))")
                    print("###############################")
                    #endif
                    let errorMessage = MoyaError.jsonMapping(res).localizedDescription
                    return Single.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage]))
                }
            }
            .filterSuccessfulStatusCodes()
            .mapJSON()
    }
    
    func observe<Request: TargetType>(_ request: Request) -> Observable<Event<Any>> {
        let target = MultiTarget.init(request)
        return self.request(target)
            .flatMap { res in
                return Single.just(res)
            }
            .asObservable()
            .materialize()
    }
}
