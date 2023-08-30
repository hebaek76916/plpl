//
//  extension+DataRequest.swift
//  temp1
//
//  Created by 현은백 on 2023/08/28.
//

import Alamofire
import Foundation


extension DataRequest {}


class Interceptor: RequestInterceptor {
    let retryLimit = 3
    let retryDelay: TimeInterval = 2
    var isRetrying: Bool = false
    
    public func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, Error>) -> Void
    ) {
        
    }
    
    public func retry(
        _ request: Request,
        for session: Session,
        dueTo error: Error,
        completion: @escaping (RetryResult) -> Void
    ) {
        if request.retryCount < self.retryLimit {
            completion(.retryWithDelay(self.retryDelay))
        } else {
            completion(.doNotRetry)
        }
    }
}

enum TempError: Error {
    case A
}

extension DataRequest {
    
    func customValidate(
        apiType: KCPA_APIType,
        logParams: [String: Any],
        delegate: KCPA_HttpAPIClientDelegate
    ) -> Self {
        return self.validate { request, response, data -> Request.ValidationResult in
            let errorType: Int? = {
                guard let data else { return ERR_RESULT_DOES_NOT_EXIST }
            
                let dictionary: [String: Any]?
                do
                {
                    dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]//<= success에 이걸 담아야하는데?
                }
                catch
                {
                    //TODO: ERR_SEND_FAILURE의 경우는 request 외에 아래의 delegate의 analyticsDebug도 함께 호출하도록 한다.
                    return ERR_SEND_FAILURE
                }
                
                guard let dictionary else { return ERR_UNKNOWN_RESULT }

                if let result = dictionary[kResult] as? String
                {
                    if result == kFailure
                    {
                        return ERR_RESPONSE
                    }
                    else
                    {
                        return ERR_UNKNOWN_RESULT
                    }
                }
                return nil
            }()
            
            //TODO: error case 로 감싸서 던져주면 request부분에서 해결하게하기
            if let _ = errorType {
                return .failure(TempError.A)
            }
            
            return .success(())
        }
    }
}

class HttpClientConnector {// session 마다 심어야할까?
    let session: Session
    let interceptor = Interceptor()
    
    init() {
        session = Session(interceptor: interceptor)
    }
    
    func makeRequest(completion: @escaping () -> Void) {
//        let urlString = ""
//        let url = URL(string: urlString)!
    }
}
