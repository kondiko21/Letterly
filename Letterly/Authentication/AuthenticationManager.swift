//
//  AuthenticationManager.swift
//  Letterly
//
//  Created by Konrad on 15/08/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct AuthResultModel {
    let uid: String
    let email: String?
}

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    
    private init() { }
    
    func getAuthenticatedUser(completion: @escaping (AuthResultModel?) -> Void) {
        var handle: AuthStateDidChangeListenerHandle?

        handle = Auth.auth().addStateDidChangeListener { auth, user in
            // Remove the listener once we have the user
            Auth.auth().removeStateDidChangeListener(handle!)
            if let loggedUser = user {
                let authResult = AuthResultModel(uid: loggedUser.uid, email: loggedUser.email)
                completion(authResult)
            } else {
                completion(nil)
            }
        }
    }
    
    func getAuthenticatedUser() async -> AuthResultModel? {
        await withCheckedContinuation { continuation in
            getAuthenticatedUser { user in
                continuation.resume(returning: user)
            }
        }
    }

    
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            let uid = result.user.uid
            
            let data: [String: Any] = [
                "email": email,
                "uid": uid,
                "username": username
            ]
            
            try await Firestore.firestore().collection("users").document(uid).setData(data)
            print("Document successfully written!")
        } catch {
            print(error)
        }
    }
    
    func signIn (email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw AuthError.signIn
            print(error)
        }
    }
    
    
    func signOut() throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AuthError.signOut(message: "Couldn't sign out")
        }
    }
}

enum AuthError: Error {
    case signOut(message: String)
    case signIn
}
