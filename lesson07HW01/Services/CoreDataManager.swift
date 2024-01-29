import CoreData
import UIKit

protocol CoreDataManagerProtocol {
    func saveFriends(_ friendsData: [FriendsModel.Response.Friend])
    func saveGroups(_ groupsData: [GroupsModel.Response.Group])
    func fetchFriends() -> [FriendsModel.Response.Friend]
    func fetchGroups() -> [GroupsModel.Response.Group]
    func saveFriendsLastUpdate(date: Date)
    func saveGroupsLastUpdate(date: Date)
    func fetchFriendsLastUpdate() -> String
    func fetchGroupsLastUpdate() -> String
    
}

final class CoreDataManager: CoreDataManagerProtocol {
    
    static let shared = CoreDataManager()
    
    private let context: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удаётся найти AppDelegate")
        }
        context = appDelegate.persistentContainer.viewContext
    }
    // Сохранение контекста Core Data
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch let error as NSError {
                print("An error occurred while saving: \(error), \(error.userInfo)")
            }
        }
    }
    
    // Получение LastUpdate сущности, или создание новой если не существует
    private func getLastUpdateEntity() -> LastUpdate {
        let fetchRequest: NSFetchRequest<LastUpdate> = LastUpdate.fetchRequest()
        if let lastUpdate = try? context.fetch(fetchRequest).first {
            // Возвращаем существующую сущность
            return lastUpdate
        } else {
            // Создаем новую сущность, если не существует
            let newLastUpdate = LastUpdate(context: context)
            return newLastUpdate
        }
    }
    
    
    // Сохранение друзей в Core Data
    func saveFriends(_ friendsData: [FriendsModel.Response.Friend]) {
        friendsData.forEach { friendData in
            let friend = FriendCoreDataModel(context: context)
            friend.id = Int32(friendData.id)
            friend.firstName = friendData.firstName
            friend.lastName = friendData.lastName
            friend.online = Int32(friendData.online)
            friend.photo = friendData.photo
        }
        saveContext()
        saveFriendsLastUpdate(date: Date())
    }
    
    // Сохранение групп в Core Data
    func saveGroups(_ groupsData: [GroupsModel.Response.Group]) {
        groupsData.forEach { groupData in
            let group = GroupCoreDataModel(context: context)
            group.id = Int32(groupData.id)
            group.name = groupData.name
            group.photo = groupData.photo
            group.screenName = groupData.screenName
        }
        saveContext()
        saveGroupsLastUpdate(date: Date())
    }
    
    
    func fetchFriends() -> [FriendsModel.Response.Friend] {
        do {
            let friends = try context.fetch(FriendCoreDataModel.fetchRequest())
            var newFriends = [FriendsModel.Response.Friend]()
            for friend in friends {
                let newFriend = FriendsModel.Response.Friend(
                    id: Int(friend.id),
                    firstName: friend.firstName ?? "",
                    lastName: friend.lastName ?? "",
                    online: Int(friend.online),
                    photo: friend.photo ?? "",
                    photo200: friend.photo200 ?? ""
                )
                newFriends.append(newFriend)
            }
            return newFriends
        } catch {
            return []
        }
    }
    
    
    // Извлечение групп из Core Data
    func fetchGroups() -> [GroupsModel.Response.Group] {
        do {
            let groups = try context.fetch(GroupCoreDataModel.fetchRequest())
            var newGroups = [GroupsModel.Response.Group]()
            for group in groups {
                let newGroup = GroupsModel.Response.Group(
                    name: Int(group.id) == 0 ? "Неизвестная группа" : group.name ?? "",
                    photo: group.photo ?? "",
                    screenName: group.screenName ?? "",
                    id: Int(group.id)
                )
                newGroups.append(newGroup)
            }
            return newGroups
        } catch {
            return []
        }
    }
    
    
    // Сохранение времени последнего обновления друзей
    func saveFriendsLastUpdate(date: Date) {
        let lastUpdate = getLastUpdateEntity()
        lastUpdate.friendsLastUpdate = date
        saveContext()
    }
    
    // Сохранение времени последнего обновления групп
    func saveGroupsLastUpdate(date: Date) {
        let lastUpdate = getLastUpdateEntity()
        lastUpdate.groupsLastUpdate = date
        saveContext()
    }
    
    // Извлечение времени последнего обновления друзей
    func fetchFriendsLastUpdate() -> String {
        let lastUpdate = getLastUpdateEntity()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if let date = lastUpdate.friendsLastUpdate {
            return dateFormatter.string(from: date)
        } else {
            return "Неизвестно"
        }
    }
    
    // Извлечение времени последнего обновления групп
    func fetchGroupsLastUpdate() -> String {
        let lastUpdate = getLastUpdateEntity()
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        
        if let date = lastUpdate.groupsLastUpdate {
            return dateFormatter.string(from: date)
        } else {
            return "Неизвестно"
        }
    }
}
