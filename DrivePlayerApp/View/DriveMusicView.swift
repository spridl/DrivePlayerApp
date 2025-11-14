//
//  DriveMusicView.swift
//  DrivePlayerApp
//
//  Created by Тимур on 12.11.2025.
//

import SwiftUI

struct DriveMusicView: View {
    @StateObject var viewModel: DriveViewModel
    @State var trackID = ""
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                List(viewModel.files) { file in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(file.name)
                                .font(.headline)
                            Text(file.mimeType)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
                        Spacer()
                        Button {
                            if viewModel.currentTrack?.id == file.id, viewModel.isPlaying {
                                viewModel.pause()
                            } else if viewModel.currentTrack?.id == trackID {
                                viewModel.downloadAndPlay(file: file, fileID: trackID)
                            } else {
                                viewModel.stop()
                                viewModel.downloadAndPlay(file: file, fileID: trackID)
                                trackID = file.id
                            }
                        } label: {
                            Image(systemName: viewModel.currentTrack?.id == file.id && viewModel.isPlaying ? "pause.fill" : "play.fill")
                        }
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMusic()
        }
        .navigationTitle("Музыка из Google Drive")
    }
}
