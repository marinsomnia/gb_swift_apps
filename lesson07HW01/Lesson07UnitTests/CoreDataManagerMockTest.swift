import Foundation
import XCTest
@testable import lesson07Hw01

final class CoreDataManagerMock: CoreDataManagerProtocol {
    private(set) var isFetchFriendsCalled = false
    private(set) var isSaveFriendsCalled = false
    private(set) var isFetchGroupsCalled = false
    private(set) var isSaveGroupsCalled = false
    private(set) var isSaveFriendsLastUpdate = false
    private(set) var isSaveGroupsLastUpdate = false
    private(set) var isFetchFriendsLastUpdate = false
    private(set) var isFetchGroupsLastUpdate = false
    
    func saveFriends(_ friendsData: [FriendsModel.Response.Friend]) {
        isSaveFriendsCalled = true
    }
    func saveGroups(_ groupsData: [GroupsModel.Response.Group]) {
        isSaveGroupsCalled = true
    }
    func fetchFriends() -> [FriendsModel.Response.Friend] {
        isFetchFriendsCalled = true
        return []
    }
    func fetchGroups() -> [GroupsModel.Response.Group] {
        isFetchGroupsCalled = true
        return []
    }
    func saveFriendsLastUpdate(date: Date) {
        isSaveFriendsLastUpdate = true
    }
    func saveGroupsLastUpdate(date: Date) {
        isSaveGroupsLastUpdate = true
    }
    func fetchFriendsLastUpdate() -> String {
        isFetchFriendsLastUpdate = true
        return ""
    }
    func fetchGroupsLastUpdate() -> String {
        isFetchGroupsLastUpdate = true
        return ""
    }
}
