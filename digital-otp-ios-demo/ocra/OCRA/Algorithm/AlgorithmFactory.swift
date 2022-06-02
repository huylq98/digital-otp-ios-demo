//
//  AlgorithmFactory.swift
//  OCRASwift
//
//  Created by ttcn_cntt on 16/05/2022.
//

import Foundation

struct AlgorithmFactory {
    private init() {}
    static let shared: AlgorithmFactory = .init()

    func getHMACAlgorithm(by cryptoFunction: String) -> HMACAlgorithmType {
        if cryptoFunction.lowercased().contains(HMACAlgorithmSHA1.identifier) {
            return HMACAlgorithmSHA1()
        }

        if cryptoFunction.lowercased().contains(HMACAlgorithmSHA256.identifier) {
            return HMACAlgorithmSHA256()
        }

        if cryptoFunction.lowercased().contains(HMACAlgorithmSHA512.identifier) {
            return HMACAlgorithmSHA512()
        }

        fatalError("=====HMAC Algorithm is not suppported: \(cryptoFunction)")
    }

    func getPasswordAlgorithm(by dataInput: String) -> PasswordAlgorithmType? {
        if dataInput.lowercased().contains(PasswordAlgorithmSHA1.identifier) {
            return PasswordAlgorithmSHA1()
        }

        if dataInput.lowercased().contains(PasswordAlgorithmSHA256.identifier) {
            return PasswordAlgorithmSHA256()
        }

        if dataInput.lowercased().contains(PasswordAlgorithmSHA512.identifier) {
            return PasswordAlgorithmSHA512()
        }

        //print("=====Hash password algorithm is not suppported: \(dataInput)")
        return nil
    }

    func getQuestionFormat(by dataInput: String) -> QuestionFormatType? {
        if dataInput.uppercased().contains(QuestionNumberFormat.identifier) {
            return QuestionNumberFormat()
        }

        if dataInput.uppercased().contains(QuestionCharacterFormat.identifier) {
            return QuestionCharacterFormat()
        }

        if dataInput.uppercased().contains(QuestionHexadecimalFormat.identifier) {
            return QuestionHexadecimalFormat()
        }

        //print("=====Question's format is not suppported: \(dataInput)")
        return nil
    }

    func getSessionInformation(by dataInput: String) -> SessionInfomationType? {
        if dataInput.lowercased().contains(SessionInfomation064.identifier) {
            return SessionInfomation064()
        }

        if dataInput.lowercased().contains(SessionInfomation128.identifier) {
            return SessionInfomation128()
        }

        if dataInput.lowercased().contains(SessionInfomation256.identifier) {
            return SessionInfomation256()
        }

        if dataInput.lowercased().contains(SessionInfomation512.identifier) {
            return SessionInfomation512()
        }

        //print("=====Session information's format is not suppported: \(dataInput)")
        return nil
    }
}
