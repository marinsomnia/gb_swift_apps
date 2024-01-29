import Foundation
import XCTest
@testable import lesson07Hw01

final class FriendsControllerTest: XCTestCase {
    private var friendsController: FriendsController!
    private var apiManager: APIManagerMock!
    private var coreDataManager: CoreDataManagerMock!
    
    override func setUp() {
        super.setUp()
        apiManager = APIManagerMock()
        coreDataManager = CoreDataManagerMock()
        friendsController = FriendsController(apiManager: apiManager, coreDataManager: coreDataManager)
    }
    
    override func tearDown() {
        friendsController = nil
        apiManager = nil
        coreDataManager = nil
        super.tearDown()
    }
    
    func testGetFriends() {
        friendsController.loadFriendsData()
        XCTAssertTrue(apiManager.isGetDataCalled, "failure")
    }
    
}
