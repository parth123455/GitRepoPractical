//
//  GitReposView.swift
//  GitRepoPractical
//
//  Created by Parth gondaliya on 30/11/24.
//

import SwiftUI

struct GitReposView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Button(action: initiateGitHubLogin) {
                    HStack {
                        Text(Constants.logInWithGitHub)
                            .fontWeight(.bold)
                            .font(.title2)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.black)
                    .cornerRadius(10)
                }
                
                Spacer()
            }
        }
    }
    
    //MARK: Initiates GitHub login
    private func initiateGitHubLogin() {
        if let url = URL(string: "\(Constants.authURL)?client_id=\(Constants.clientID)&redirect_uri=\(Constants.redirectURI)&scope=\(Constants.scope)") {
            UIApplication.shared.open(url)
        }
    }

}

#Preview {
    GitReposView()
}
