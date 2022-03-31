//
//  StrikeTests.swift
//  StrikeTests
//
//  Created by Donald Ness on 12/23/20.
//

import XCTest
@testable import Strike
import CryptoKit

class StrikeTests: XCTestCase {
    
    func testSignersUpdateSerializedOp() throws {
        let request: WalletApprovalRequest = getSignersUpdateRequest()
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("123455"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.opHashData.toHexString(),
            "05d79ee6b8ae98d572459d5d6572f088a8f6b1f40655eee8c981056b205e41a37500010156b088482c6882a3def445509a410c837a27476140df0c0da4be446071000e"
        )
    }
    
    func testSignersUpdateApprovalDisposition() throws {
        let request: WalletApprovalRequest = getWalletApprovalRequest(getSignersUpdateRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("DumeKnMBQxYVeXNuhc9paKn9hMooPpbJ6KCMA49UDSQn"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "020102053965e9f69936f81d71308f0d958058a12d119f2a1a09c1730bc3e08f8cd7323601d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd000000000000000000000000000000000000000000000000000000000000000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000005640214959d9f4df1eeec74b22b59f0faa41040ac269f6714825f85dccade4f8bfd0ec7c3ad222d262fbce36f0aa114a6a98d7a84c5b111dd40ac17bc80698b7010403020103220901af24bb0b13204c184b107a1f15c83e25e6e7ab7b59544d9ab02d92e19022a248"
        )
    }
    
    func testSignersUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSignersUpdateRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "c177b7a6f4f0d315802948cc872dbf813a165b193a1df16abcb3aef98d15b0f4".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("J3u7zr89XajLDc7KN97dkwBeaBEwrM9ksHzd2MnkfnGX"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "9zH1T9AjmUZkSpMNHLzvEqr5DBq4qxHJUTyr38ws8Xdj").toHexString(),
            "030104073965e9f69936f81d71308f0d958058a12d119f2a1a09c1730bc3e08f8cd7323693404c2b3290d2ea7a01ff8d74bb5acaf11e0a86b267d78edeb2fa74bb4d47d78589b39a3c40ace2639004c51282faa3def2c5f46298eee55b69e3ce8b6e1842dafd264571d2493a2438a3613d9dd6222448bbfaaf7c906491b27efb6d012e5a06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000005640214959d9f4df1eeec74b22b59f0faa41040ac269f6714825f85dccade4f8fd54c5b9cd786597cb7473c6aed0526452575a61bae0ea64ad2448b8ea0ea9180205020001340000000000a767000000000050030000000000005640214959d9f4df1eeec74b22b59f0faa41040ac269f6714825f85dccade4f8060401030204230c01026f205b49d23f88996c9085dab7875b22fdbef58b6e62925142c3253d439b2613"
        )
    }
    
    func testBalanceAccountCreationSerializedOp() throws {
        let request = getWalletApprovalRequest(getBalanceAccountCreationRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("123455"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.opHashData.toHexString(),
            "01759b1a550341b7d556b7fca0cc41d898f1bd85f24988494d29bb88ec5262c055c47958892a80bb2a2f40ac092a4f5f946354d2d3848a4883e0f6997ff2d0800b00b94e0c79c1fb7db6ff3380f8bd8f09376fb8f87c488f98ec920164e1e3a7417101100e0000000000000100542dc7218c23d87e0e5d9cf0b7cda11507871716641c663e0ae428ba65f0bf45000000"
        )
    }
    
    func testBalanceAccountCreationApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getBalanceAccountCreationRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("DumeKnMBQxYVeXNuhc9paKn9hMooPpbJ6KCMA49UDSQn"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "02010205a64dc04c0577c717e1de8999d7891989fe2a5e43025ec414a045d3e53c5e216601d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fdfa3e0f982ee37deaf0b5f82667cb6e201427a3ae2611f303026d5b599540ce2d06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000f9abb695c5f886e1d0756c588a872dec5915c1bc5d454e86ffdaa17dc94250d7bfd0ec7c3ad222d262fbce36f0aa114a6a98d7a84c5b111dd40ac17bc80698b701040302010322090130ce60882b394aeef62c528d1f03622b1a77cb5a6761c93d56f2ca98a33eddc6"
        )
    }
    
    func testBalanceAccountCreationInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountCreationRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "fc57704ac1985d1ceb68880b8431d5dd6027771c9b4d65ea5724585694a85b01".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("9ZcVaD3iwrTCcEUU8RDWSNFhJfhqXDRhWgahgU2QrDqG"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "6fbjW55k7m1ERjJ6cDKhHvpc6MryEyZyncpEXVd5EYKE").toHexString(),
            "03010407a64dc04c0577c717e1de8999d7891989fe2a5e43025ec414a045d3e53c5e21665cc746dd3b9aac95ca9bf3d787e0ab540023dd8dd63907fbf9515c382ea7dfc6542dc7218c23d87e0e5d9cf0b7cda11507871716641c663e0ae428ba65f0bf45759b1a550341b7d556b7fca0cc41d898f1bd85f24988494d29bb88ec5262c05506a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000f9abb695c5f886e1d0756c588a872dec5915c1bc5d454e86ffdaa17dc94250d77f383683a196f15bf40e73455e34c490fb156f326eab8ce3fc107df5da7f34970205020001340000000000a76700000000005003000000000000f9abb695c5f886e1d0756c588a872dec5915c1bc5d454e86ffdaa17dc94250d70604010302047003c47958892a80bb2a2f40ac092a4f5f946354d2d3848a4883e0f6997ff2d0800b00b94e0c79c1fb7db6ff3380f8bd8f09376fb8f87c488f98ec920164e1e3a7417101100e0000000000000100542dc7218c23d87e0e5d9cf0b7cda11507871716641c663e0ae428ba65f0bf45000000"
        )
    }
    
    func testSolWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSolWithdrawalRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("EdsedMi4Stt2fztX1bDwHKB4HKn563UCSs1pBJECH98x"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "0201020530fdcdd3275ee81bf960cce0fbb778edd4ed02baeeedcb76dc642caee636d4f501d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd000000000000000000000000000000000000000000000000000000000000000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000007f27f43059f33fb8617e294d080b3e05e67128b669639e515f8928ae1b4567bca9a1b9e122b67ab65b27c5f9e5f36c1c74385842c04b9ec44fdc76effd9787d01040302010322090197eecb9a94034177062f36372ed55fbfb19f1cf3dbaf23b224d4e046dbe0de93"
        )
    }
    
    func testSolWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSolWithdrawalRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "5758390b320bb83aca5a56addabbd72e86aee98f2ef75ce886bcca1ec54a8622".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("GwH732RyF7V5vXFuCXsoU5ijurTdCtm9qAMZ6WJWeVvN"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4rRgMiGsPoK7YgSCuDTHbCHcggXRdH7DSrMT3TK1ksKB").toHexString(),
            "0301070c30fdcdd3275ee81bf960cce0fbb778edd4ed02baeeedcb76dc642caee636d4f5140b5bfae04dd35d994a87e7832ed16fad6e4f9587cdef398cdf357ff843d0b4393c6cb0c8b63534855b1ec4e21a3d0e9b7b94311d72583c846a68a80ed9449ebbca5680a69fd4948374e205b9c7ecef6a0aedb2f1482a07e4d8627f22751c2000000000000000000000000000000000000000000000000000000000000000001b63972a7066da96aaf846330482882c28abd8dffaccf60f5f90f1a24bfbf0c963a4c21eed801fb89fb42cbf1e93acf5375ea86b0a72f4f00ce188cb889b7edc06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f85907f27f43059f33fb8617e294d080b3e05e67128b669639e515f8928ae1b4567becc6e061d65dbd7f963da7cf3e4c622dad093b9965e1b05e315d2617ca03a3ff0204020001340000000000a7670000000000500300000000000007f27f43059f33fb8617e294d080b3e05e67128b669639e515f8928ae1b4567b0b0d0105030602070404000408090a49075ecca0e48b93958a009409b102554590609e226e805b45cfbc737793d64166ac0065cd1d00000000cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be"
        )
    }
    
    func testSplWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSplWithdrawalRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("8AJmcSXpfahcEfbL9cUq271oYvNVUNfs2gprAMaNB4Hr"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "02010205b377f4f9b3e921b57ad72d2e0d5b32217d0897c2fbbd7363d5f058e0c0c4bf8601d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd000000000000000000000000000000000000000000000000000000000000000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000003f5dcfc1b29d4a71924e3c8301083252246414b15b672f887f653d54a49c94f66a64209e3fb9d6e2631dd3ffc22c890d17c8ef09d9fd4c954aa06fe8d6e7033d0104030201032209019cab423f8863dfdbaafb1ecff851c6bb80d9506a6f98f553f26cbd1a131f67d1"
        )
    }
    
    func testSplWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSplWithdrawalRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "ed942553764e7e8fdb90e812e0a40943434ead335f727eeb4eef05c7fb5ce870".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("8AJmcSXpfahcEfbL9cUq271oYvNVUNfs2gprAMaNB4Hr"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "8ZDnDoQFjNgTCdgvegSCQTNko3yW7hrvWA6V8HHKqGBZ").toHexString(),
            "0301090eb377f4f9b3e921b57ad72d2e0d5b32217d0897c2fbbd7363d5f058e0c0c4bf86bee6295cf95dadb7c618e01e3e15a93589d79851380218d5fcee9c660e11bf347042d829f99edcbe36a4963eb7ebd8909ba4fe812e727410ac565004242e7ba0ab9b58d393b241605dd23850b64a30be7ec8bd07096f4ff0ece60aefc12558e8eb6a50bdba03c5e43b224268de72f093a4764fb70fd13c82cfdbf83ed8e1aad279cabd8394d6b873aab65ab2eb08562dff0875d01284b039d875f857925016132eb5281e9960b1672196abe835c2b71ec0940d7ad0a06ac2f70e183af067fd1c06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000016a1f8d1efa43b8479a9880c9d8b57b6c8efb93fe64481bec8942f4857656d88000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8593f5dcfc1b29d4a71924e3c8301083252246414b15b672f887f653d54a49c94f66a64209e3fb9d6e2631dd3ffc22c890d17c8ef09d9fd4c954aa06fe8d6e7033d0209020001340000000000a767000000000050030000000000003f5dcfc1b29d4a71924e3c8301083252246414b15b672f887f653d54a49c94f60d0d010503060207080400090a0b0c490753d2734e2cb0297d65585280aa8a4147c3b81f91659254f940300a9494d38a94f401000000000000f7d1a2ef642101c041a4523de1dd26652402149065ae308c55e1924cb217cb48"
        )
    }

    func testUSDCconversionRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getConversionRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("4fkgvna8G3TPwHiBeWG6Hx6aTHx3qthuBAyBxVeYLD5P"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "02010205d2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e5335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0000000000000000000000000000000000000000000000000000000000000000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a9658099847368087b86f466669f67bd484fc7ff4e7efe78ddff6e3f6abb399becabd860336010403020103220901a4403ca23bc4f76030f2b2159bb991b66a696acdc81e72cedfa7d028be999b1e"
        )
    }
    
    func testUSDCconversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getConversionRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "5f27be66e3eb697a4274f9359c87f9069762a5e2cb7a63a622e923bd6119b963".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("4fkgvna8G3TPwHiBeWG6Hx6aTHx3qthuBAyBxVeYLD5P"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "0301090ed2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e17ce130f4d1b123ff7f5f840aee4e9fa5665106de0cf2d1245c2b60f6ade6e245335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0d1e5bffc491a1b7890805d162a2cf8f0a2facae1df8579eddfed575e44f958108e829493f87ba7dc9497154a2cf8e656ee9979277f9ac88b5570775e7cb447d11bbc7e99fc43d0c442a698780fa1c7e4bcfbe5f100df263390ef0ab695e1b85aa1a993efade361c637af59e4d387db1aec381df43083f38e789f4bd57280889906a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008ac94d970e27bc29711d382b1d5fac3fe82f590485b065e57fcc6e83424110cd000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a9658099847368087b86f466669f67bd484fc7ff4e7efe78ddff6e3f6abb399becabd8603360209020001340000000000a76700000000005003000000000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998470d0d010503060207080400090a0b0c4907138543b25e89429dae0ec18a0fa198dc5006898f91b3b99d80a58d65bcdff9d00065cd1d00000000455c311d68d6d25a36bb09d58c4f62e6e637031c29b7fd3bd205b658500739cf"
        )
    }
    
    func testDAppTransactionRequestInitiationRequest() throws {
        let opAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "427bae33c6d5ccc230996ce101a176403a050ed961245bf426a796f2bb1a59b1".data(using: .hexadecimal)!)
        let dataAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "5ea459c4f52f9423695c91a9e2862810017d1f3a517d62d5932d8743240769f8".data(using: .hexadecimal)!)
        
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: MultisigAccountCreationInfo(
                accountSize: 2696,
                minBalanceForRentExemption: 19655040
            )
        )
        let requestType: SolanaApprovalRequestType = getDAppTransactionRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("HAmRrbJbQ99rhoyNwzdb2j5W9EheJ4bBNoGvDDfMCQcS"),
            email: "dont care",
            opAccountPrivateKey: opAccountPk,
            dataAccountPrivateKey: dataAccountPk
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "8Wy7f6iLogS2jjqsAmqwipYG8SLqoQo9JktJ6ogPYE8E").toHexString(),
            "0401040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c71522e751350f46e9e376632755acf9e726dd509d1727eb393633f2a55fef09d8c63bf5de3a06b66133071d3e95c0089cecb839508044a870e532f0d455cd085a4e6faf19e34b077fa6fc0aa169772175f79e48702c0e16b08386ab4417fdda690ffd2da1e6ebb413150f6060185bd26c1cf68ec83f22c951da306f4806a4bf1cbf06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000e48fb9a24efc096601390bd1e6520fe5fc7334261760edd323ee24bfb2bebaeaf03b741fa589f8d771794b55f708641c8f3804528d3f75d8d824e0734c2f94fb0306020001340000000000a76700000000005003000000000000e48fb9a24efc096601390bd1e6520fe5fc7334261760edd323ee24bfb2bebaea06020002340000000080e92b0100000000880a000000000000e48fb9a24efc096601390bd1e6520fe5fc7334261760edd323ee24bfb2bebaea070501020403056210207cd1182db29dea5667c9b5fac4d2c23a19cd6283b6d68de2291f9ba50b6869c40b1781602bc1c83ab6c10cc39633b6e721ffbdfb61006557ee2132709919f62e90c13b0d471b592c2984568133a41676460f72c885db57ad26bd5b628f938201"
        )
        let signableInstructions = try initiationRequest.signableSupplyInstructions(approverPublicKey: "8Wy7f6iLogS2jjqsAmqwipYG8SLqoQo9JktJ6ogPYE8E")
        XCTAssertEqual(signableInstructions.count, 1)
        XCTAssertEqual(
            signableInstructions[0].toHexString(),
            "0201010569ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7156faf19e34b077fa6fc0aa169772175f79e48702c0e16b08386ab4417fdda690f22e751350f46e9e376632755acf9e726dd509d1727eb393633f2a55fef09d8c63bf5de3a06b66133071d3e95c0089cecb839508044a870e532f0d455cd085a4ee48fb9a24efc096601390bd1e6520fe5fc7334261760edd323ee24bfb2bebaeaf03b741fa589f8d771794b55f708641c8f3804528d3f75d8d824e0734c2f94fb01040302030193021c0001008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590700033b917baa190d282c5d8558f14b3fb88767b12c9d44af0c255fc22788a7b6cea90110e1b08cab22278dcde5c7cc8817ba98806a9c6fc6676c0a155e2badda54373e033b917baa190d282c5d8558f14b3fb88767b12c9d44af0c255fc22788a7b6cea900e80ec9d9255634baed16a97a0a5f3e306a4201610e3822ae823060f5dc440fde0000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90006a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000000400010203ac"
        )
    }

}
