//
//  LoginView.swift
//  ChatAppSwiftUI
//
//  Created by UKESH KUMAR on 20/04/23.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @State var isLoginMode = false
    @State var email = ""
    @State var password = ""
    
    @State var shouldShowImagePicker = false
    @State var image: UIImage?
    
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
               
                VStack(spacing: 16) {
                    
                    
                    Picker(selection: $isLoginMode) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    } label: {
                        Text("Picker")
                    }
                    .pickerStyle(.segmented)
                    
                    Spacer()
                    
                    if !isLoginMode {
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            ZStack {
                                Circle()
                                    .stroke(.black, lineWidth: 5)
                                    .frame(width: 120,height: 120)
                            
                                VStack {
                                    
                                    if let image = self.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120,height: 120)
                                            .cornerRadius(64)
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 64))
                                            .foregroundColor(.black)
                                            .padding()
                                    }
                                }
                            }
                                
                        }
                    }
                    
                    Spacer()
                    
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding(12)
                        .background()
                        .clipShape(Capsule())
                    SecureField("Password", text: $password)
                        .padding(12)
                        .background()
                        .clipShape(Capsule())
                    
                    
                    Spacer()
                    
                    Button {
                        handleAction()
                    } label: {
                        Text(isLoginMode ? "Log In" : "Create Account")
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 32, height: 50)
                            .background(LinearGradient(colors: [.red,.pink], startPoint: .topLeading, endPoint: .bottomTrailing ))
                            .clipShape(Capsule())
                    }
                                        
                }
                .padding()
                
                
            }
            .navigationTitle(isLoginMode ? "Log In" : "Create Account")
            .background(LinearGradient(colors: [.green,.yellow], startPoint: .topLeading, endPoint: .bottomTrailing ).ignoresSafeArea())
        }.navigationViewStyle(StackNavigationViewStyle())
         .fullScreenCover(isPresented: $shouldShowImagePicker) {
                ImagePicker(image: $image)
            }
        
    }
    private func handleAction() {
        if isLoginMode {
            loginUser()
        } else {
            createNewAccount()
        }
    }
    
    private func createNewAccount() {
        Auth.auth().createUser(withEmail: email, password: password ) {
            result, err  in
            if let err = err {
                print("Failed to create user:", err)
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            
            self.persistImageToStorage()
            
        }
    }
    
    private func persistImageToStorage() {
        
        
        
    }
    
    private func loginUser() {
        Auth.auth().signIn(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to login user:", err)
            }
            
            print("Successfully LoggedIn user: \(result?.user.uid ?? "")")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
