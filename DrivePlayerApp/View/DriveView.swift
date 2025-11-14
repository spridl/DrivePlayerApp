////
////  DriveView.swift
////  DrivePlayerApp
////
////  Created by Тимур on 09.11.2025.
////
//
//import SwiftUI
//
//struct DriveView: View {
//    @StateObject private var viewModel = DriveViewModel()
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if let user = viewModel.user {
//                    Text("Hello, \(user.name)!")
//                    Button("Загрузить файлы") {
//                        viewModel.fetchDriveFiles()
//                    }
//                    
//                    List(viewModel.files) { files in
//                        VStack(alignment: .leading) {
//                            Text(files.name)
//                                .font(.headline)
//                            Text(files.mimeType)
//                                .font(.subheadline)
//                                .foregroundStyle(.gray)
//                        }
//                    }
//                } else {
//                    Button("Войти через Google") {
//                        if let rootVC = UIApplication.shared.connectedScenes
//                            .compactMap({ $0 as? UIWindowScene })
//                            .first?.windows.first?.rootViewController {
//                            viewModel.signIn(presenting: rootVC)
//                        }
//                    }
//                }
//                
//                if viewModel.isLoading {
//                    ProgressView("Загрузка...")
//                }
//            }
//            .navigationTitle("GoogleDrive")
//        }
//    }
//}
//
//
//#Preview {
//    DriveView()
//}
