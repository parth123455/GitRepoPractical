//
//  ConnectivityHelper.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 01/12/24.
//

import Foundation
import networkext
import Reachability
import SystemConfiguration

class Connectivity: ObservableObject {
    @Published var isConnected: Bool = true

    init() {
        monitorReachability()
    }

    private func monitorReachability() {
        let reachability = try? Reachability()
        reachability?.whenReachable = { _ in
            DispatchQueue.main.async {
                self.isConnected = true
            }
        }
        reachability?.whenUnreachable = { _ in
            DispatchQueue.main.async {
                self.isConnected = false
            }
        }
        do {
            try reachability?.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
}
