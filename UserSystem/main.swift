import Foundation
import CryptoKit

struct User {
    let username: String
    let email: String
    let password: String

    init(username: String, email: String, password: String) {
        self.username = username
        self.email = email
        self.password = Self.hashPassword(password)
    }

    static func hashPassword(_ password: String) -> String {
        let hashed = SHA256.hash(data: Data(password.utf8))
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }

    func verifyPassword(_ input: String) -> Bool {
        return Self.hashPassword(input) == password
    }
}

class UserManager {
    private var users: [String: User] = [:]

    func registerUser(username: String, email: String, password: String) -> Bool {
        guard users[username] == nil else {
            print("Username '\(username)' already exists.")
            return false
        }
        let newUser = User(username: username, email: email, password: password)
        users[username] = newUser
        print("User '\(username)' registered.")
        return true
    }

    func login(username: String, password: String) -> Bool {
        guard let user = users[username], user.verifyPassword(password) else {
            print("Invalid username or password.")
            return false
        }
        print("Login successful for '\(username)'.")
        return true
    }

    func removeUser(username: String) -> Bool {
        if users.removeValue(forKey: username) != nil {
            print("User '\(username)' removed.")
            return true
        }
        print("User '\(username)' not found.")
        return false
    }

    var userCount: Int {
        return users.count
    }

    func getAllUsers() -> [String: User] {
        return users
    }
}

class AdminUser: UserManager {
    override init() {
        print("AdminUser initialized.")
    }

    func listAllUsers() -> [String] {
        return Array(getAllUsers().keys)
    }

    deinit {
        print("AdminUser instance deallocated.")
    }
}

let admin = AdminUser()

if admin.registerUser(username: "anano", email: "anano@example.com", password: "secure123") {
    print("anano registered.")
}
if admin.registerUser(username: "gio", email: "gio@example.com", password: "hello123") {
    print("gio registered.")
}

if admin.login(username: "anano", password: "secure123") {
    print("anano logged in.")
} else {
    print("Login failed for anano.")
}

if admin.removeUser(username: "gio") {
    print("gio removed.")
}

print("Total users: \(admin.userCount)")
print("Usernames: \(admin.listAllUsers())")
