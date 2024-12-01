//
//  GitReposView.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import SwiftUI
import CoreData

struct GitReposView: View {
    @StateObject private var viewModel: GitReposViewModel

    init(context: NSManagedObjectContext, connectivity: Connectivity) {
        _viewModel = StateObject(wrappedValue: GitReposViewModel(context: context, connectivity: connectivity))
    }

    var body: some View {
        NavigationView {
            VStack {
                
                if let _ = viewModel.accessToken {
                    // Search bar
                    TextField(Constants.searchRepoName, text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.filterRepositories()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    // Repository list with pull-to-refresh
                    List {
                        ForEach(viewModel.filteredRepositories) { repo in
                            VStack(alignment: .leading) {
                                Text(repo.name).font(.headline)
                                Text(repo.description ?? Constants.noDescription)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                HStack {
                                    Text("\(Constants.stars): \(repo.stars ?? 0)")
                                    Text("\(Constants.forks): \(repo.forks ?? 0)")
                                    Text("\(Constants.lastUpdatedAt): \(viewModel.formatDate(repo.updatedAt))")
                                }
                                .font(.footnote)
                                .foregroundColor(.secondary)
                            }
                            .onAppear {
                                if repo == viewModel.filteredRepositories.last! &&
                                    viewModel.hasMorePages && !viewModel.isLoading {
                                    viewModel.fetchRepositories(page: viewModel.currentPage + 1)
                                }
                            }
                        }

                        // Show loading indicator when fetching more pages
                        if viewModel.isLoading {
                            ProgressView(Constants.loading)
                        }
                    }
                    .refreshable {
                        viewModel.refreshData() // Reload data on pull-to-refresh
                    }
                } else {
                    Spacer()
                    // Login button when not logged in
                    Button(action: {
                        viewModel.initiateGitHubLogin()
                    }) {
                        Text(Constants.logInWithGitHub)
                            .padding()
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Spacer()
                }
            }
            .navigationTitle(viewModel.accessToken != nil && !viewModel.accessToken!.isEmpty ? Constants.repositories : "")
            .onOpenURL(perform: viewModel.handleOpenURL)
        }
    }
}
