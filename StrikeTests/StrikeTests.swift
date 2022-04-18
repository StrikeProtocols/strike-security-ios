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
    
    func testBalanceAccountCreationApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getBalanceAccountCreationRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("Dkdb79TLNTRVzf1w3H6ShSqr34wHAEa1SoxnA8y84NWM"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342ae5404ca4d115addf760a932a2564636c071f3d93077c7722926026963d760e631a8298317f9291ee863ec4f900b9213341828b6ec8ee46ce9fc9414aac7ca706a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacfbd79968f918c540d27a31c936a3be43f07c6e9e931b64307d107fb6b1b17ccc2010403020103220901f6c209de6aa7973eaafbbc9416fd72f7f9fed1b527a4b71eb3c1c30d36b388f8"
        )
    }
    
    func testBalanceAccountCreationInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountCreationRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "bda2d5239064df336700833fd4092414ff0b220153718154ccf93e6bd5c6fe9f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("5g9Yqjwjpp2nyJ4M36rtwzpxXzM8pNUKfHfDo3fqU2sR"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "5zpDzYujD8xnZ5B9m93qHCGMSeLDb7eAKCo4kWha7knV").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34631a8298317f9291ee863ec4f900b9213341828b6ec8ee46ce9fc9414aac7ca74a3e400b6f36e0b517ed08ced47959f691ac7badf37f3894b745a78ae4c4a01a0a4b19fe3af610a9e087ccad29c92dbcbc2a3a6671794cd819a6004877bb0ea006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf457610cbf81f090b0acb2f1817ddf832d7d91ebc7f041092626711f364206b080205020001340000000000a7670000000000500300000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf06040103020470034769675cd49f8236615121384afba87c6573c04f5b131f5f831ad85045ed099b00b94e0c79c1fb7db6ff3380f8bd8f09376fb8f87c488f98ec920164e1e3a7417101100e000000000000010011bc008a04027d5cefeeb9d1b4a0b3efa2a1a04db7deee2ffe5ae17e599a5a5f000000"
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
    
    func testUSDCConversionRequestInitiationRequest() throws {
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
    
    func testWrapConversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getWrapConversionRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "46b397c81d81f9c745bb61baf28337888907696c5e653a08a98b5ecbcc1c82c8".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("3YPf6YcEVffsNo7eeo2YAQBhmZVUqNvRo5huz22H4tqY"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301080dd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342a6b6e29ec48d15d528b864b1d58f441b263ed5f24db504928f6090efc8cb41d0b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e9b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496fca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d25c1ff40d356e53b6d109057a197cad545e2e9e29a79491ac0eb43f251c31f030208020001340000000000a76700000000005003000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0c0b0105030406020708090a0b2a0ac344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc0065cd1d0000000000"
        )
    }
    
    func testUnwrapConversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getUnwrapConversionRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4cdbc626f9cb68219d52d49d80041ab0b3b130d1880323a763b3eed8d4f8ff0f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("HGiNAhtgRePu3yoRfFGqYsJCBNr6aR3bhwuqwKKvjBC5"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301080dd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e9afcff207f5614ebfa3a3522dfdaac0bc90d89768e6ee6b0a700d41dada06180b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e9b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496fca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067df1c179763a9f9e0947da940adb8c19fe6adbd5224dd281193948061cbac2818a0208020001340000000000a76700000000005003000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0c0b0105030406020708090a0b2a0ac344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc00a3e1110000000001"
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
    
    func testAddDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddDAppBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("HQMSirmFbK8Xj4MyoGojSb7TGKXMgSBEX39ReMBYeKdN"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf613f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e60206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5cf3b67706912f5eb25524a3aa127ebd6254ec0e940d3d07e693bf585735d27b3d0104030201032209018d6b5e5ef60fb6e4f56efd65c050a066d2195a8c3ec205bfd21116e175126792"
        )
    }
    
    func testAddDAppBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddDAppBookEntry()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "72ff8f7fb4a441c93d4003e2bf67dd367e3293311c4f9433c422a2fbf305c477".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("9rPXx8wSWt6SZUyEHTZTCmJxKf7EdqDJYHCmcUfGvDCx"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e602982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f111064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c83846f14fd6dccfe09a66897fedd27ea00e440ba619bc36e28ec856920cb6e9d0205020001340000000000a767000000000050030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c06040103020444140100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb000"
        )
    }
    
    func testRemoveDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getRemoveDAppBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("76VdskQyW28LuJJoJ7SQHAyYhMBSgkrGbouPudFfioN8"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf61379dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c5a8e6778354218717f3793abf1852fffef24fd1229d7f64f3a6d1f71fe3d49c9010403020103220901b5b1693386fac4e14cbba717c482605fedd188df4188ef1f9f0046c94ab5b729"
        )
    }
    
    func testRemoveDAppBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getRemoveDAppBookEntry()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "1d3462075eae5a46257981c00c20982dd27a88b70a88ff95455dad6bc88859aa".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("8vU5xsx8gzbpoZVdy7bZrEh5ZAq9mFZN1YQhfr7342rZ"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3479dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c2982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f111064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c75b43795726f2b3bbafcbd59cd9824ef543135097b4d9b55d51eed274e2f0df60205020001340000000000a767000000000050030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c0604010302044414000100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb0"
        )
    }
    
    func testAddAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddAddressBookEntry()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "584bd0f067048bf9cfafb61fd95324add9c32b507096029a9c2bbe41f37dc15f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("2k2h349Dv1g94CmArR4mtA1PDzbqK66ePVXrViJUYesz"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af346a09fad4652960dff9ac2bfe72f66fa35828c2bfa1eb58d981f5bd4d6e6368969e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e3468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f19e192a9fb5dd780345fb1767bebdf6d96b2e5b9ca671f0c6b1cfecf390a00290205020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f06040103020445160101b2d8f074dd1e2bd86969cafa743e1fa4142c2a653c753c3ffe8e423c253f4f24cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be0000"
        )
    }
    
    func testAddAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddAddressBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("CQnSFRqhv5L7aERLDL4umuuK4uxt35kPiPE4aGEzeE4Q"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb6a09fad4652960dff9ac2bfe72f66fa35828c2bfa1eb58d981f5bd4d6e63689606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9fa98849e71b8b58b54fd82d1c7aeab5909ec262b36caf49fe1f7bbd0f1ef52251010403020103220901f4165fbb207f95f5e37dc69454109fcfa88d75fe31b6444723b898c8d117ffb9"
        )
    }
    
    func testWhitelistAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddressBookWhitelistUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "0b54157b978b3fb33a1baf99bc18bcac0eb2ace03fb1fe4fa8ee1a03151459d6".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("5NLw4Q2cSbJruSap1wB8bwKgE1BehhAhuFJxZpKLLoh9"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3487a7481044ee570421adbd55b3b4d959b20e74fa0bd065f7d74fd72c2b1875699e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e3468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f40e67b5fc931c2068538c4e3a8c11d86accdfb5e19f4fac708298bae899bd2b80205020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f06040103020467160000013c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c40101b2d8f074dd1e2bd86969cafa743e1fa4142c2a653c753c3ffe8e423c253f4f24cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be00"
        )
    }
    
    func testWhitelistAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddressBookWhitelistUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("AyQ8biRdSG1koAMyRVBQGp3NG6NGZtNZMUAxcEpydqFP"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb87a7481044ee570421adbd55b3b4d959b20e74fa0bd065f7d74fd72c2b18756906a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f942bdca9735da4d8b2c4272d049163e892b255517e410249cf592e737f67c9420104030201032209019c4072ce0c1eb0bcdbd363de6e32fa3510e1b98a9493809711cdaecdd01d37a9"
        )
    }
    
    func testRemoveWhitelistAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddressBookWhitelistRemove()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4f4649c4dd936a7161d63376ba2d2e6372aee4ef8a9a234f01cd0954b628dce2".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("4NgwRtPcqw6qc1DxXqBEbUFDKaCoM8H7VsFaTp3qRXfy"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34ecd4aa14aa2e8b20411a9c971b70a6d2606f87438168b85eb977f7f1b59688719e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e3468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f32216a9291060d94a64913610f243e2f5b3836e8b5c386b1f1c04b2e9c5830cc0205020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f06040103020467160000013c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c4000101b2d8f074dd1e2bd86969cafa743e1fa4142c2a653c753c3ffe8e423c253f4f24cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be"
        )
    }
    
    func testRemoveWhitelistAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddressBookWhitelistRemove())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("3YjjuHiU3g7p12BFGPvAw4aCKj7JfbecDvtTX8Fjfxne"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73ebecd4aa14aa2e8b20411a9c971b70a6d2606f87438168b85eb977f7f1b596887106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f25d8b470c6eef99858d0821f01f94f9cb255626f08743557ec4e1c2b2a3fa5230104030201032209013fce038435fef269f2a63f20554c472fd8ae4d1cfe2ad77d36660ea3a9948c4e"
        )
    }
    
    func testWalletConfigPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getWalletConfigPolicyUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("Es934LEc4AUG1VvtZVmhhmu518qHmWGeGUfsGkYD1g7n"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342ae5404ca4d115addf760a932a2564636c071f3d93077c7722926026963d760ed17a6a48d07bbbf8d76e02379e0758f4580f3cb34a56980929e72e9b0d58e97206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacfce000e6566f2c3e7ce3b2d0d3b97571702fd93559e0ea54c780f2ea3d5b029650104030201032209019a8396d2fa315bafcfe5ca0d78946f4bf31297feb3036fd82998f28c0af3332c"
        )
    }
    
    func testWalletConfigPolicyUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getWalletConfigPolicyUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "9fa146dbd7f5bdaef9b0b4c99980a0acb0bfc4b874d02c86694f1193acfbb87f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("BHBT3QmGb7ZkXCk3WKfJ5bSqQq6MGQHCiKXHCiKEEzLd"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "5zpDzYujD8xnZ5B9m93qHCGMSeLDb7eAKCo4kWha7knV").toHexString(),
            "03010307d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34d17a6a48d07bbbf8d76e02379e0758f4580f3cb34a56980929e72e9b0d58e9724a3e400b6f36e0b517ed08ced47959f691ac7badf37f3894b745a78ae4c4a01a0a4b19fe3af610a9e087ccad29c92dbcbc2a3a6671794cd819a6004877bb0ea006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf98b9fa178cf6ae68bdc3efcafbcf245bc40866c97121581950adcc1388e9e44e0205020001340000000000a7670000000000500300000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf0604010302042e0e035046000000000000030001024041109cb8f8611bd2813af557df74e80cb9da3a2599894d5d990fc13536d917"
        )
    }
    
    func testBalanceAccountSettingsUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountSettingsUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("5QJJ2uizSGqFZLA6oo6zmp1aMfmkjeXki1LLKsyWs6yV"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73ebe40128881204af69745129ee3357a788ce003ce6171a9e92a011afc775b8ce6006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f4166a90b6675c56cf09852855a8eab13521f8473f3b720f3149e6c2c5edc0ea00104030201032209011df7ee9884d25dddac4fa0b133456174394207dba45a16fbd963f07c8c5447f4"
        )
    }
    
    func testBalanceAccountSettingsUpdateUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountSettingsUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "43ae13e0827d8034dbb880c3210ab7f7b7c49c5d2b3120933c184c8942110ed0".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("EoUoU5nnW4dxZzRi1oqXy9xtt63n4b14B2w2EpBnzbVW"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e40128881204af69745129ee3357a788ce003ce6171a9e92a011afc775b8ce609e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e3468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9fcd1015062914321b0bbfc892cc4612963106435c54d4bbe1abb5cc8949b16b750205020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f06040103020425123c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c401010000"
        )
    }
    
    func testBalanceAccountPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountPolicyUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("6Neim24UMYvnZHFLcCZqT57KUGXoPPBtXuRPzyyevDn6"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342ae5404ca4d115addf760a932a2564636c071f3d93077c7722926026963d760e2ede24d6b2e1b97138f6f38d2ba3ea9b237a0e6d072f5e23b0f8c7ba22cd0cb206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf4fd648203706fcad20208365d4d8c64959b9fe83062cf04d9f25990a84d1baff0104030201032209017ccb45a1034fd22dfee5c3636f43eb2d63bee375415019e3bfd1d6c06a07c745"
        )
    }
    
    func testBalanceAccountPolicyUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountPolicyUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)

        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "505f102d7c741f53165ec1feb6d00cc45600bdfa34300a5ad551b062bf2a54d4".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("4QpShEKsnJTxFtnNFYHqZW1wTPe4WZ3Bmt4FqQo4qk2T"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "5zpDzYujD8xnZ5B9m93qHCGMSeLDb7eAKCo4kWha7knV").toHexString(),
            "03010307d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342ede24d6b2e1b97138f6f38d2ba3ea9b237a0e6d072f5e23b0f8c7ba22cd0cb24a3e400b6f36e0b517ed08ced47959f691ac7badf37f3894b745a78ae4c4a01a0a4b19fe3af610a9e087ccad29c92dbcbc2a3a6671794cd819a6004877bb0ea006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf32ad1037cc85a1bb8e71021657196e70fa63d15787cc0d26be01ec1359ce56900205020001340000000000a7670000000000500300000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf0604010302044d1a4769675cd49f8236615121384afba87c6573c04f5b131f5f831ad85045ed099b02100e00000000000002000133d16784b488113764a49a5f1e7217ca5ec64d62a610d7cb1ab8beb8514bdb77"
        )
    }
    
    func testBalanceAccountNameUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountNameUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("Dx6qrNbS1xovmV9SfyjqQD77JBYv8yPyPjR7837fvuC8"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb5c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb241006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9fc069cb21b4742b9d9525d977328dbc26c920364dc56d70bb6abd30f5c7ddae3d0104030201032209010c2b34abcc84e4ae92d3120231ba6a13303976d34e1e8951565dbe2700ca6538"
        )
    }
    
    func testBalanceAccountNameUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountNameUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "7707e53ddb688826e19d5d1d651450222c3d6cf73680fd331430278bba237328".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("9krPSEV48dRoKQuJU4j7FxkU3UoJ77oSrMAsyk6B1fCQ"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010407d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af345c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb24109e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e3468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f82194fe24537fa0ff325cbdd0c0f78b5905cc792dc8fb546d77798d6a77a816d0205020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f06040103020441183c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c44e637072f628e09a14c28a2559381705b1674b55541eb62eb6db926704666ac5"
        )
    }
    
    func testSPLTokenAccountCreationInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSPLTokenAccountCreation()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "affd2d3a1283a92c72347c5075126b7868a9bc17b32dbb06eaf90ec8fdb51f3e".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            blockhash: getRecentBlockhash("FMLrVDN8DQcpmSSK3kE8BfFaaxRiWHtHtiEBRkpjFddD"),
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )
        
        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "CXCdHsyMVVKEQbRorowkBBnRtmC7QSAmg4QFqQJAMt85").toHexString(),
            "03010609d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af344b6a3d93450d66eb4dc907e6f3c8f478feb3c8afd69ea70a6f73eb771d87cb14ab2d202d4ab70a619c12c35cd765878d7711743f57c555940b27087173491fd6687ead1fdbf865a46fc37cbdfbc2fa26b99494d07735fffceb691ef2f4d090fb069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008269b01bf858c755348eccb7fd606a006e63d0cd6c0eb0b1a88694fbd26ffae0000000000000000000000000000000000000000000000000000000000000000005415f4b0cb8304a7975aa7869199943d71dafffc5b9d93f9d7b796f4618bf50d539ae667f9041f13c6ffbbb4957e2d60e66d47144518c3f24efd6e7c40b4d340207020001340000000000a7670000000000500300000000000005415f4b0cb8304a7975aa7869199943d71dafffc5b9d93f9d7b796f4618bf500806010302040506621d794b77f810f9c71db95d8fd3a9adc5805b501983c8e0b50ee675c3dc13eca3f601794b77f810f9c71db95d8fd3a9adc5805b501983c8e0b50ee675c3dc13eca3f6069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f00000000001"
        )
    }
    
    func testSPLTokenAccountCreationApprovalRequest() throws {
        let request = getWalletApprovalRequest(getSPLTokenAccountCreation())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("Dx6qrNbS1xovmV9SfyjqQD77JBYv8yPyPjR7837fvuC8"),
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010205d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73ebe7b32e6d93f1c1f4dbb3409025e13c12a5435a91acd65bae3a898d0c89f086e606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000005415f4b0cb8304a7975aa7869199943d71dafffc5b9d93f9d7b796f4618bf50c069cb21b4742b9d9525d977328dbc26c920364dc56d70bb6abd30f5c7ddae3d010403020103220901a15ac12f9dcfdaeea5d80de21a6e3195288f17d4a57f9835151301ed7061a545"
        )
    }
    
    func testLoginApproval() throws {
        let jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6IlNvbHIifQ.SWCJDd6B_m7xr_puQH-wgbxvXyJYXH9lTpldOU0eQKc"
        let request = getWalletApprovalRequest(getLoginApproval(jwtToken))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            blockhash: getRecentBlockhash("AyQ8biRdSG1koAMyRVBQGp3NG6NGZtNZMUAxcEpydqFP"),
            email: "dont care"
        )
        XCTAssertEqual(
            String(decoding: try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL"), as: UTF8.self),
            jwtToken
        )
    }

}
