//
//  AudioPlayerService.swift
//  DrivePlayerApp
//
//  Created by Тимур on 12.11.2025.
//

import AVFoundation

final class AudioPlayerService: ObservableObject {
    private var player: AVPlayer?
    @Published var isPlaying: Bool = false
    
    func play(url: URL) {
//        stop()
//        
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.play()
        isPlaying = true
        print("Воспроизведение началось: \(url)")
    }
    
    func playResume() {
        player?.play()
        isPlaying = true
        print("Воспроизведение продолжилось")
    }
    
    func pause() {
        player?.pause()
        player = nil
        isPlaying = false
        print("Пауза")
    }
    
    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
        print("Остановлено")
    }
}
