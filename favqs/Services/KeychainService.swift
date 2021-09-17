//
//  KeychainService.swift
//  favqs
//
//  Created by Clement Picot on 17/09/2021.
//

import KeychainAccess

class KeychainService {
    private var keychain = Keychain(service: Bundle.main.bundleIdentifier ?? "")

    public static let shared = KeychainService()
    private init () {}

    var token: String? {
        get {
            keychain["token"]
        }
        set {
            keychain["token"] = newValue
        }
    }
    private (set) var login: String? {
        get {
            keychain["login"]
        }
        set {
            keychain["login"] = newValue
        }
    }

    func updateCredantials(session: SessionResponse) {
        login = session.login
        token = session.userToken
    }

    func resetCredentiels() {
        login = nil
        token = nil
    }
}
