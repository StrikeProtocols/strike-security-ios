//
//  BipTests.swift
//  StrikeTests
//
//  Created by Brendan Flood on 6/8/22.
//

import XCTest
@testable import Strike
import BIP39

struct TestItem: Codable {
    let mnemonic: String
    let privateKeyHex: String
    let publicKeyBase58: String
}

struct TestItems: Codable {
    let items: [TestItem]
}


class BipTests: XCTestCase {
    
    func testWithKnownDataSet() throws {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: "test-data", withExtension: "json") else {
            XCTFail("Missing file: test-data.json")
            return
        }
        let decoder = JSONDecoder()
        let testItems = try! decoder.decode(TestItems.self, from: try Data(contentsOf: url))
        for testItem in testItems.items {
            let ed25519PrivateKey = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: testItem.mnemonic.components(separatedBy: " ")).seed)
            // @solana/web3j code which generated this data set represents the private key as the actual private key(32 bytes) appended with public key (another 32 bytes)
            XCTAssertEqual(testItem.privateKeyHex, (ed25519PrivateKey.privateKey.rawRepresentation + ed25519PrivateKey.privateKey.publicKey.rawRepresentation).toHexString().lowercased())
            XCTAssertEqual(testItem.publicKeyBase58, Base58.encode(ed25519PrivateKey.privateKey.publicKey.rawRepresentation.bytes))

        }
    }
    
    func testMnemonicGenerationAndValidation() throws {
        // generate a new 24 word phrase and generate key
        let words = Mnemonic(strength: 256).phrase
        XCTAssertEqual(words.count, 24)
        let rootSeed = try Mnemonic(phrase: words).seed
        let hdKey = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: rootSeed)
        let signature = try hdKey.privateKey.signature(for: "Hello World".data(using: .utf16)!)
        
        // regenerate from same set and verify keys match
        let hdKey2 = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: words).seed)
        XCTAssertEqual(hdKey.privateKey.rawRepresentation.toHexString(), hdKey2.privateKey.rawRepresentation.toHexString())
        XCTAssertTrue(hdKey2.privateKey.publicKey.isValidSignature(signature, for: "Hello World".data(using: .utf16)!))
    }
    
    func testMnemonic() throws {
        XCTAssertTrue(
            Mnemonic.isValid(
                phrase: "echo flat forget radio apology old until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare".components(separatedBy: " ")
            )
        )
        XCTAssertFalse(
            Mnemonic.isValid(
                phrase: "echo flat forged radio apology old until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare".components(separatedBy: " ")
            )
        )
        XCTAssertFalse(
            Mnemonic.isValid(
                phrase: "echo flat forget radio apology new until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare".components(separatedBy: " ")
            )
        )
    }
    
    func testVerificationError() throws {
        let originalPhrase = "echo flat forget radio apology old until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare"
        let hdKey = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: originalPhrase.components(separatedBy: " ")).seed)

        // radio and forget are flipped - Mnenomics implementation detects words are transposed based on checksum validations
        let transposedWords = "echo flat radio forget apology old until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare"
        XCTAssertThrowsError(try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: transposedWords.components(separatedBy: " ")).seed)) { error in
            XCTAssertEqual(error as! Mnemonic.Error, Mnemonic.Error.invalidMnemonic)
        }
       
        // change the word old to new (which is not a valid word)
        let wrongWords = "echo flat forget radio apology new until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare"
        XCTAssertThrowsError(try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: wrongWords.components(separatedBy: " ")).seed)) { error in
            XCTAssertEqual(error as! Mnemonic.Error, Mnemonic.Error.invalidMnemonic)
        }
       
        // change forget to forged
        let incorrectSpelledWords = "echo flat forged radio apology old until elite keep fine clock parent cereal ticket dutch whisper flock junior pet six uphold gorilla trend spare"
        XCTAssertThrowsError(try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: incorrectSpelledWords.components(separatedBy: " ")).seed)) { error in
            XCTAssertEqual(error as! Mnemonic.Error, Mnemonic.Error.invalidMnemonic)
        }
       
        // valid phrase for a different key
        let otherValidPhrase = "refuse hedgehog nerve insect silent sunset regret slush walnut illness visit slim advance mobile shrug initial grid topple inch okay bunker marriage bench chapter"
        let hdKey2 = try Ed25519HierachicalPrivateKey.fromRootSeed(rootSeed: try Mnemonic(phrase: otherValidPhrase.components(separatedBy: " ")).seed)
        XCTAssertNotEqual(hdKey.privateKey.rawRepresentation.toHexString(), hdKey2.privateKey.rawRepresentation.toHexString())
   }
    
    func testValidWords() throws {
        XCTAssertTrue(Wordlists.english.contains("zoo"))
        XCTAssertFalse(Wordlists.english.contains("zoom"))
        XCTAssertTrue(Wordlists.english.contains("forget"))
        XCTAssertFalse(Wordlists.english.contains("forged"))
    }
}
