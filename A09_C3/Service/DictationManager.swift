//
//  DictationManager.swift
//  A09_C3
//
//  Created by Richie Daryl Kwenandar on 19/07/26.
//

import Foundation
import Speech
import AVFoundation

@Observable
final class DictationManager {
    private(set) var isRecording = false
    private(set) var transcribedText = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "id_ID"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    // MARK: - Permission
    
    func requestAuthorization() async -> Bool {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        
        guard speechStatus == .authorized else { return false }
        
        let micStatus = await AVAudioApplication.requestRecordPermission()
        return micStatus
    }
    
    // MARK: - Start Recording
    
    func startRecording() throws {
        guard let speechRecognizer, speechRecognizer.isAvailable else {
            throw DictationError.recognizerUnavailable
        }
        
        if audioEngine.isRunning {
            stopRecording()
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw DictationError.audioEngineFailed
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        recognitionRequest = request
        
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.removeTap(onBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            throw DictationError.audioEngineFailed
        }
        
        isRecording = true
        transcribedText = ""
        
        recognitionTask = speechRecognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self else { return }
            
            if let result {
                self.transcribedText = result.bestTranscription.formattedString
            }
            
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
            }
        }
    }
    
    // MARK: - Stop Recording
    
    func stopRecording() {
        guard isRecording else { return }
        
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        
        recognitionRequest = nil
        recognitionTask = nil
        isRecording = false
        
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
    }
    
    func appendTranscription(existingText: String, newText: String) -> String {
        let trimmedNew = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedNew.isEmpty else { return existingText }
        return existingText.isEmpty ? trimmedNew : existingText + " " + trimmedNew
    }
}

enum DictationError: Error, Equatable {
    case notAuthorized
    case recognizerUnavailable
    case audioEngineFailed
}
