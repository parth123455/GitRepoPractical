//
//  Constance.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import Foundation

struct Constants {
   
    //MARK: Auth constants
    static let clientID = "Ov23linxbfVtYw6rXpiq"
    static let redirectURI = "gitrepopractical://callback"
    static let authURL = "https://github.com/login/oauth/authorize"
    static let scope = "repo user"
    static let schemaName = "gitrepopractical"
    static let clientSecret = "908f210c01d9a30824b64d52789915ccb7571c6a"
    static let tokenURL = "https://github.com/login/oauth/access_token"
    static let reposURL = "https://api.github.com/user/repos"
    static let redirectURITitle = "redirect_uri"
    static let code = "code"
    static let clientSecretTitle = "client_secret"
    static let clientIdTitle = "client_id"
    
    //MARK: Keychain key title
    static let GitHubAccessToken = "GitHubAccessToken"
    
    static let logInWithGitHub = "Login with GitHub"
    static let searchRepoName = "Search repositories..."
    static let loading = "Loading..."
    static let repositories = "Repositories List"
    
}
