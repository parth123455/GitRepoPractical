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

    init(context: NSManagedObjectContext) {
        _viewModel = StateObject(wrappedValue: GitReposViewModel(context: context))
    }

    var body: some View {
        NavigationView {
            VStack {
                if let _ = viewModel.accessToken {
                    TextField(Constants.searchRepoName, text: $viewModel.searchText)
                        .onChange(of: viewModel.searchText) { _ in
                            viewModel.filterRepositories()
                        }
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    List {
                        ForEach(viewModel.filteredRepositories) { repo in
                            VStack(alignment: .leading) {
                                Text(repo.name).font(.headline)
                                Text(repo.description ?? "No Description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                HStack {
                                    Text("Stars: \(repo.stars ?? 0)")
                                    Text("Forks: \(repo.forks ?? 0)")
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

                        if viewModel.isLoading {
                            ProgressView(Constants.loading)
                        }
                    }
                } else {
                    Spacer()
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
            .navigationTitle(viewModel.accessToken != "" ? Constants.repositories : "")
            .onOpenURL(perform: viewModel.handleOpenURL)
        }
    }
}
