//
//  GitReposViewModel.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import SwiftUI
import CoreData

//class GitReposViewModel: ObservableObject {
//    
//    // MARK: Var define.
//    
//    @Published var accessToken: String?
//    @Published var repositories: [Repository] = []
//    @Published var filteredRepositories: [Repository] = []
//    @Published var searchText: String = ""
//    @Published var isLoading: Bool = false
//    @Published var hasMorePages: Bool = true
//    @Published var currentPage: Int = 1
//
//    private let viewContext: NSManagedObjectContext
//
//    init(context: NSManagedObjectContext) {
//        self.viewContext = context
//        loadAccessToken()
//        loadCachedRepositories()
//    }
//
//    func loadAccessToken() {
//        accessToken = KeychainHelper.load(for: Constants.GitHubAccessToken)
//    }
//
//    func saveAccessToken(_ token: String) {
//        KeychainHelper.save(value: token, for: Constants.GitHubAccessToken)
//        accessToken = token
//    }
//
//    func fetchRepositories(page: Int = 1) {
//        guard let token = accessToken else { return }
//        isLoading = true
//
//        let url = URL(string: "\(Constants.reposURL)?page=\(page)&per_page=10")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
//            guard let self = self else { return }
//            DispatchQueue.main.async { self.isLoading = false }
//
//            guard let data = data else { return }
//
//            do {
//                let decoder = JSONDecoder()
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
//                decoder.dateDecodingStrategy = .iso8601
//                let fetchedRepositories = try decoder.decode([Repository].self, from: data)
//
//                DispatchQueue.main.async {
//                    self.repositories.append(contentsOf: fetchedRepositories)
//                    self.filteredRepositories = self.repositories
//                    self.currentPage = page
//                    self.hasMorePages = !fetchedRepositories.isEmpty
//                    fetchedRepositories.forEach { self.saveRepositoryToCoreData($0) }
//                }
//            } catch {
//                print("Failed to decode repositories: \(error)")
//            }
//        }.resume()
//    }
//
//    func saveRepositoryToCoreData(_ repository: Repository) {
//        let entity = RepositoryEntity(context: viewContext)
//        entity.id = Int64(repository.id)
//        entity.name = repository.name
//        entity.repoDescription = repository.description
//        entity.stars = Int64(repository.stars ?? 0)
//        entity.forks = Int64(repository.forks ?? 0)
//        entity.lastUpdated = repository.updatedAt
//        try? viewContext.save()
//    }
//
//    func loadCachedRepositories() {
//        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
//        if let result = try? viewContext.fetch(fetchRequest) {
//            repositories = result.map { Repository(entity: $0) }
//            filteredRepositories = repositories
//        }
//    }
//
//    func filterRepositories() {
//        if searchText.isEmpty {
//            filteredRepositories = repositories
//        } else {
//            filteredRepositories = repositories.filter {
//                $0.name.lowercased().contains(searchText.lowercased())
//            }
//        }
//    }
//
//    func initiateGitHubLogin() {
//   
//
//        if let url = URL(string: "\(Constants.authURL)?client_id=\(Constants.clientID)&redirect_uri=\(Constants.redirectURI)&scope=\(Constants.scope)") {
//            UIApplication.shared.open(url)
//        }
//    }
//
//    func handleOpenURL(_ url: URL) {
//        if url.scheme == Constants.schemaName {
//            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
//            if let code = queryItems?.first(where: { $0.name == Constants.code })?.value {
//                exchangeCodeForAccessToken(code: code)
//            }
//        }
//    }
//
//    private func exchangeCodeForAccessToken(code: String) {
//   
//        var request = URLRequest(url: URL(string: Constants.tokenURL)!)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = try? JSONSerialization.data(withJSONObject: [
//            Constants.clientIdTitle: Constants.clientID,
//            Constants.clientSecretTitle: Constants.clientSecret,
//            Constants.code: code,
//            Constants.redirectURITitle: Constants.redirectURI
//        ])
//
//        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
//            guard let self = self, let data = data else { return }
//
//            if let responseString = String(data: data, encoding: .utf8),
//               let queryItems = URLComponents(string: "?" + responseString)?.queryItems,
//               let token = queryItems.first(where: { $0.name == "access_token" })?.value {
//                DispatchQueue.main.async {
//                    self.saveAccessToken(token)
//                    self.fetchRepositories()
//                }
//            }
//        }.resume()
//    }
//}



import SwiftUI
import CoreData

class GitReposViewModel: ObservableObject {
    @Published var accessToken: String?
    @Published var repositories: [Repository] = []
    @Published var filteredRepositories: [Repository] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var hasMorePages: Bool = true
    @Published var currentPage: Int = 1

    private let viewContext: NSManagedObjectContext
    private let connectivity: Connectivity

    init(context: NSManagedObjectContext, connectivity: Connectivity) {
        self.viewContext = context
        self.connectivity = connectivity
        loadAccessToken()
        loadData()
    }

    // MARK: Refresh Data on Pull-to-Refresh
    func refreshData() {
        repositories.removeAll()
        filteredRepositories.removeAll()
        currentPage = 1
        hasMorePages = true
        loadData()
    }

    // MARK: Load Data Based on Connectivity
    func loadData() {
        if connectivity.isConnected {
            fetchRepositories()
        } else {
            loadCachedRepositories()
        }
    }

    func loadAccessToken() {
        accessToken = KeychainHelper.load(for: Constants.GitHubAccessToken)
    }

    func saveAccessToken(_ token: String) {
        KeychainHelper.save(value: token, for: Constants.GitHubAccessToken)
        accessToken = token
    }

    // MARK: API Data Fetch
    func fetchRepositories(page: Int = 1) {
        guard let token = accessToken else { return }
        isLoading = true

        let url = URL(string: "\(Constants.reposURL)?page=\(page)&per_page=10")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self else { return }
            DispatchQueue.main.async { self.isLoading = false }

            guard let data = data else { return }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                decoder.dateDecodingStrategy = .iso8601
                let fetchedRepositories = try decoder.decode([Repository].self, from: data)

                DispatchQueue.main.async {
                    self.repositories.append(contentsOf: fetchedRepositories)
                    self.filteredRepositories = self.repositories
                    self.currentPage = page
                    self.hasMorePages = !fetchedRepositories.isEmpty
                    fetchedRepositories.forEach { self.saveRepositoryToCoreData($0) }
                }
            } catch {
                print("Failed to decode repositories: \(error)")
            }
        }.resume()
    }

    func saveRepositoryToCoreData(_ repository: Repository) {
        let entity = RepositoryEntity(context: viewContext)
        entity.id = Int64(repository.id)
        entity.name = repository.name
        entity.repoDescription = repository.description
        entity.stars = Int64(repository.stars ?? 0)
        entity.forks = Int64(repository.forks ?? 0)
        entity.lastUpdated = repository.updatedAt
        try? viewContext.save()
    }

    func loadCachedRepositories() {
        let fetchRequest: NSFetchRequest<RepositoryEntity> = RepositoryEntity.fetchRequest()
        if let result = try? viewContext.fetch(fetchRequest) {
            repositories = result.map { Repository(entity: $0) }
            filteredRepositories = repositories
        }
    }

    func filterRepositories() {
        if searchText.isEmpty {
            filteredRepositories = repositories
        } else {
            filteredRepositories = repositories.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }
    }

    func initiateGitHubLogin() {
        if let url = URL(string: "\(Constants.authURL)?client_id=\(Constants.clientID)&redirect_uri=\(Constants.redirectURI)&scope=\(Constants.scope)") {
            UIApplication.shared.open(url)
        }
    }

    func handleOpenURL(_ url: URL) {
        if url.scheme == Constants.schemaName {
            let queryItems = URLComponents(string: url.absoluteString)?.queryItems
            if let code = queryItems?.first(where: { $0.name == Constants.code })?.value {
                exchangeCodeForAccessToken(code: code)
            }
        }
    }

    private func exchangeCodeForAccessToken(code: String) {
        var request = URLRequest(url: URL(string: Constants.tokenURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: [
            Constants.clientIdTitle: Constants.clientID,
            Constants.clientSecretTitle: Constants.clientSecret,
            Constants.code: code,
            Constants.redirectURITitle: Constants.redirectURI
        ])

        URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
            guard let self = self, let data = data else { return }

            if let responseString = String(data: data, encoding: .utf8),
               let queryItems = URLComponents(string: "?" + responseString)?.queryItems,
               let token = queryItems.first(where: { $0.name == "access_token" })?.value {
                DispatchQueue.main.async {
                    self.saveAccessToken(token)
                    self.fetchRepositories()
                }
            }
        }.resume()
    }

    func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "N/A" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
