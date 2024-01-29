import Foundation
import XCTest
@testable import lesson07Hw01

final class APIManagerMockTest: APIManagerProtocol {
    private(set) var isGetDataCalled = false
    
    func getData<T: Decodable>(for request: APIManager.Requests, completion: @escaping (Result<T, Error>) -> Void) {
        isGetDataCalled = true
    }
}
