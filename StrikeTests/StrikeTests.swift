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
        let request: WalletApprovalRequest = getSignersUpdateWalletRequest()
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("123455", "12345")],
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
            nonceInfos: [getNonceAccountInfo("BzZpoiceSXQTtrrZUMU67s6pCJzqCDJAVvgJCRw64fJV", "HPaFoRv9A6T14AhGu5nJWMWTb6YuJYCNZEGnteXe728v")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34a6bba3eafd49e6bf5e8facf0faeea7cf500c019cd18cfa625f764213df7b8bd5a3541700f919ae296291c89fcff67de5d3cc0d941dfd342c85e641f6cea2cb56067de40aba79d99d4939c2d114f77607a1b4bb284b5ccf6c5b8bfe7df8307bd506a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09bf3835ed0ddfb443583764c93f133c341bdcde7a0c5cd2a40348b67c20722edaf02060302040004040000000703030105220901172d281d591babce5353660adac4a2d3deecd7bb68c92be44fc9643700880a0d"
        )
    }

    func testSignersUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSignersUpdateRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4ec605d194c0279e9b615464d8c6a723f8995e951b1d192b4123c602389af046".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("5Fx8Nk98DbUcNUe4izqJkcYwfaMGmKRbXi1A7fVPfzj7", "6HeTZQvWzhX8aLpm7K213scyGExytur2qiXxqLAMKnBb")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34067de40aba79d99d4939c2d114f77607a1b4bb284b5ccf6c5b8bfe7df8307bd538e70bc45546b0d63742dee544ecc6870f66da475c800d2d793c766b03266cca3f4336251703628ce12796daa20166a1f0da8a9a972775f9f04a256482e2bede06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000c43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f406a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b4e8e14d4ca1428da3032a7ca98a145dde83e2c86a7a5996eca2a42865f13f62a030703030400040400000007020001340000000000a7670000000000500300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b080401050206230c010272808ca267038e63a906c4ce421be377743b634b97fc1726fd6de085d2bcc9b1"
        )
    }

    func testBalanceAccountCreationApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getBalanceAccountCreationRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("9R4VxgBXwFZr244eb8mf3hD7NdCw87pfEDbWwSV7Hvy4", "8kNEgm8XHszsu1wfMxTJ5ggn6pTLs1ieoKqfAxjEP3mK")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34a6bba3eafd49e6bf5e8facf0faeea7cf500c019cd18cfa625f764213df7b8bd57d076439fee3c5087b8680e43f511afa72542f4a94d570aec3cf2b8b4392efc7fc48f2475f5472e0addaaacfa28b931f9484fc10830fe4f0728331a1e7ca486a06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b731dcb7b2e2119f31a81d06bb59a14fde556d82fdeb76be9aa96a9b53a9ade1202060302040004040000000703030105220901a3791fd7186a9f424f24267d4cdaafb07dfb0cf54d1b2e9e533e305d03e22e40"
        )
    }

    func testBalanceAccountCreationInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountCreationRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "5d4596a82bc0381481cb5facc5851a5558b9472f705d410f7272a7c8efed33f3".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34fc48f2475f5472e0addaaacfa28b931f9484fc10830fe4f0728331a1e7ca486a38e70bc45546b0d63742dee544ecc6870f66da475c800d2d793c766b03266cca8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000c43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f406a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000000a7670000000000500300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b080401050206700346834450499b8d2edd17b54df5b3cd21a7e40369f8e3f8f072470cac3a271a7400b94e0c79c1fb7db6ff3380f8bd8f09376fb8f87c488f98ec920164e1e3a7417101100e0000000000000100984f81da5180cf06a171042d2f5f04de68f366c53ae858b0dde1585b1539ec0e000000"
        )
    }

    func testSolWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSolWithdrawalRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3401d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd77c4c8d158b8f7d6a29a29e8f938db7344b356d823531737b5405d71c995eab1a06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000899214152f11043e929bf192a199efcb1e835a247acd4a25f1b7e5c61537bc967c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209017776689e72de20ea0d0b74a954741c7f8538a915a8d036d908465d565c5ab0cc"
        )
    }

    func testSolWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSolWithdrawalRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "0c7c37ea5a2f70937405de74bee9bb7a5c161d161789aa8ed7c3f78be106fa70".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("9NDFtaczqouZ9SGTfd489EfN3KvMQgrAjpuu4QEr9Kys", "Dht1NBhu5uzMknbEYNzK5XCi8cXaJ51bHM8XQTqVx7eP")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "7v7no3zjzuxAkmEijayVa2Xom4LPdQJwrLNDrSkv5xcZ").toHexString(),
            "0301080ed5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34ef4aeae3692a6c880884390c98c6845b8c30ab27796e67c7063f5a247685034066c194d74223f4faec86f9bfe1c062355769d1f415e63bc4dce76df30cc31a5a7c4c8d158b8f7d6a29a29e8f938db7344b356d823531737b5405d71c995eab1a1157eecaf1721efd1027585b06cee0d40a758851373ad1df33637ac50c3dc940000000000000000000000000000000000000000000000000000000000000000006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000aa9fadc4043a369c55a1f0b81d537ce2f4188a038505f6052b898f9f25863b2094872d1d5b8a164cfe33e3d64bf11a8b8f17a4113d4f85ff9e6bd95cb990b06b06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859899214152f11043e929bf192a199efcb1e835a247acd4a25f1b7e5c61537bc96bcc5260305811f01df6bf98f587eea24c46dbf26c4ad74591df9bfd0bfde69a8030503030600040400000005020001340000000000a76700000000005003000000000000899214152f11043e929bf192a199efcb1e835a247acd4a25f1b7e5c61537bc960d0d010704080209050500050a0b0c4907b7aa84f48ee4708075c4b01fd18c8cae39d6564eb2bd6564abd3ae9ce46a33e500c2eb0b00000000cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be"
        )
    }

    func testSplWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSplWithdrawalRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3401d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f23006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000000ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076267c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209011c0a4bfe5d78c21d08e264df641758a6c3bccda1deef997b360a7e0c56555968"
        )
    }

    func testSplWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getSplWithdrawalRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4ba2d7074c6fa66dca792b64260b0513a229fa0849b1ceaa5b9cff1285fedee7".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX", "9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "AbmwBa52qPj5zpWQxeJJ3ZSDRDxnyZMWitrE8nd4mrmi").toHexString(),
            "03010a10d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e34e9cdb62a817da76d5163666c93570c210e7287f7f268c77236b3002156ca08ea1bcb15aa292a9b51b7f05f19d0e27669957b9990a4aa8f9cddc1cf4c56c55515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230f46cdc8655b9add6c8905bd1247a2ef15870d4076fb39915885d08628a9f22a493c4b438027247811fa84db55c2e6ede640264dad0876d56a8bf819f2cb17bfa06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000631f065d4a6b93340e8b8a8c3061fd6eb0b7d402fe560fc40a84e9c8ce1ac3035c66b35c237860fd27d95409d452edbd91300bbfe80850fd4841759722b5073106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008df1a38eac809d9806f4e9502bc085aadb4975b84dc3ba062b1ce416efd4b1c5000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076268201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030b0303060004040000000b020001340000000000a767000000000050030000000000000ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076260f0d0107040802090a05000b0c0d0e4907c381ac8c68089013328ad37eda42b285abedc13fef404fc34e56528011ded600f401000000000000f7d1a2ef642101c041a4523de1dd26652402149065ae308c55e1924cb217cb48"
        )
    }

    func testUSDCconversionRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getConversionRequest())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX", "9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "02010307d2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e5335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230000000000000000000000000000000000000000000000000000000000000000006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998478201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a082602030302040004040000000603030105220901a4403ca23bc4f76030f2b2159bb991b66a696acdc81e72cedfa7d028be999b1e"
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
            nonceInfos: [getNonceAccountInfo("6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX", "9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "03010a10d2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e17ce130f4d1b123ff7f5f840aee4e9fa5665106de0cf2d1245c2b60f6ade6e245335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230d1e5bffc491a1b7890805d162a2cf8f0a2facae1df8579eddfed575e44f958108e829493f87ba7dc9497154a2cf8e656ee9979277f9ac88b5570775e7cb447d106a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000001bbc7e99fc43d0c442a698780fa1c7e4bcfbe5f100df263390ef0ab695e1b85aa1a993efade361c637af59e4d387db1aec381df43083f38e789f4bd57280889906a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008ac94d970e27bc29711d382b1d5fac3fe82f590485b065e57fcc6e83424110cd000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998478201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030b0303060004040000000b020001340000000000a76700000000005003000000000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998470f0d0107040802090a05000b0c0d0e4907138543b25e89429dae0ec18a0fa198dc5006898f91b3b99d80a58d65bcdff9d00065cd1d00000000455c311d68d6d25a36bb09d58c4f62e6e637031c29b7fd3bd205b658500739cf"
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
            nonceInfos: [getNonceAccountInfo("6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX", "9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301090fd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342a6b6e29ec48d15d528b864b1d58f441b263ed5f24db504928f6090efc8cb41d0b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f2309b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496f06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d8201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030a0303060004040000000a020001340000000000a76700000000005003000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0e0b010704050802090a0b0c0d2a0ac344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc0065cd1d0000000000"
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
            nonceInfos: [getNonceAccountInfo("6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX", "9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301090fd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e9afcff207f5614ebfa3a3522dfdaac0bc90d89768e6ee6b0a700d41dada06180b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f2309b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496f06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d8201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030a0303060004040000000a020001340000000000a76700000000005003000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0e0b010704050802090a0b0c0d2a0ac344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc00a3e1110000000001"
        )
    }

    func testDAppTransactionRequestInitiationRequest() throws {
        let opAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "bc020c43289b29e89674d4d2ef381508583b7894f5e7957e91ec0bf90e58476b".data(using: .hexadecimal)!)
        let dataAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "170c7dbfca9b52c9bb5572d32053e56ca422fe4e409fa6ab30784e3dfd9f9493".data(using: .hexadecimal)!)

        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: MultisigAccountCreationInfo(
                accountSize: 2696,
                minBalanceForRentExemption: 19655040
            )
        )
        let nonceInfos = [
            getNonceAccountInfo("CeQNynfs9Mx1MGTeGQaDZDZnCiUWTkUsUyYf4qT51Cek", "HqdbyB576ggyavQPaodKiS8XNPHBoo95rb75Le7XzXrr"),
            getNonceAccountInfo("HSwjDt3MYHutJcXtryaQEG3SBfRktqkuoU8cVyWoRE7P", "6PuZZuAFFYutbMY1JuYFHQUnZMXQeBe9ZrzoCaL4YGD5")
        ]
        
        let requestType: SolanaApprovalRequestType = getDAppTransactionRequest()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: nonceInfos,
            email: "dont care",
            opAccountPrivateKey: opAccountPk,
            dataAccountPrivateKey: dataAccountPk
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "HnCLpPZrMdXdogoesmx6bX3z3tPo8mvvaRXXkaonzZtf").toHexString(),
            "0401050ad5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34910d0175251385b1ee8fd8a19a360563f04ebdf43e6a7d0040f85ed2e6ec00e29c361e34407dab66e0d07e010c882241a9e967912a087b517092cb177093de69f94ef38875324ed73252ad52b51449f4615b2f1da3645635582db54dafe4a56cad057b14f59401a098a66e40e1bed86e00f949ba796e9a5af604d1e84cd96f1906a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000051a5c79873c30d67e853c870935f0b76c02dfbc48624afc1188ede15558fb77a06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000baec1d8d88c2a1f9c53d90c084f0288926771f41a2a363e9493b3d35e9b7fdfcfa3041b6b74ec346f1134c06b64afd166282100d3fc894c8be32c7ce6bcc90cb040803040500040400000008020001340000000000a76700000000005003000000000000baec1d8d88c2a1f9c53d90c084f0288926771f41a2a363e9493b3d35e9b7fdfc08020002340000000080e92b0100000000880a000000000000baec1d8d88c2a1f9c53d90c084f0288926771f41a2a363e9493b3d35e9b7fdfc0905010206030762105858d7574baea93cb0dd0e2c9a5c9c6a18d4b58fd0079d0fbf02aee8e7ca93814a2401cbeb9bb1c99935b6775fa040b4f0e4c90b5e473c28d871e8f240b5b5432e90c13b0d471b592c2984568133a41676460f72c885db57ad26bd5b628f938201"
        )
        let signableInstructions = try initiationRequest.signableSupplyInstructions(
            approverPublicKey: "HnCLpPZrMdXdogoesmx6bX3z3tPo8mvvaRXXkaonzZtf",
            nonceInfos: [nonceInfos[1]]
        )
        XCTAssertEqual(signableInstructions.count, 1)
        XCTAssertEqual(signableInstructions[0].nonce, nonceInfos[1].nonce)
        XCTAssertEqual(signableInstructions[0].nonceAccountAddress, nonceInfos[1].nonceAccountAddress)
        XCTAssertEqual(
            signableInstructions[0].data.toHexString(),
            "02010308d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34f94ef38875324ed73252ad52b51449f4615b2f1da3645635582db54dafe4a56cf46064647351baf7c5594ff5df2c40351745fc44521994a2d22c76243775c506910d0175251385b1ee8fd8a19a360563f04ebdf43e6a7d0040f85ed2e6ec00e29c361e34407dab66e0d07e010c882241a9e967912a087b517092cb177093de6906a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000000000000000000000000000000000000000000000000000000000000000000000baec1d8d88c2a1f9c53d90c084f0288926771f41a2a363e9493b3d35e9b7fdfc5028a4d782430b75cf8637ccc7df21fe6d186a69ddb048cc9dc925a78e1472800206030205000404000000070303040193021c0001008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590700035916cb79b8ad2bae04f10515239d1c14887f73176f3e999782551840df5e982e0159fba9d95655503acdbd5e4817229ecd4fe12aca67536b5ddc9d4782ca22d11a035916cb79b8ad2bae04f10515239d1c14887f73176f3e999782551840df5e982e00c726a968258c654f7622595c108fc3333d676e45b15b9d541c1034d2a68031440000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90006a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000000400010203ac"
        )
    }

    func testAddDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddDAppBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf6138e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e60206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209018d6b5e5ef60fb6e4f56efd65c050a066d2195a8c3ec205bfd21116e175126792"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e602982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f1118e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000000a767000000000050030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c08040105020644140100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb000"
        )
    }

    func testRemoveDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getRemoveDAppBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf6138e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd779dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a02060302040004040000000703030105220901b5b1693386fac4e14cbba717c482605fedd188df4188ef1f9f0046c94ab5b729"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3479dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c2982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f1118e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000000a767000000000050030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c0804010502064414000100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb0"
        )
    }

    func testAddAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddAddressBookEntry()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "d593c3bc464cf65719a8881ef79c66d8a4684870ccdbf314f012ff8ed879295a".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("AFpfUonk56y9aZdjnbs1N2VUsUrtPQfVgFncAMyTReeH", "F2MWViB8wyK77MHVUbzyWDABgXu8SFBcM3iEREUdevAd")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "77A6RbdEjz8JQFFfXBepk7ssX5QUxunQ3TTJdayjkqw5").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3414f77b30cf799b059605b79ab2be10641f9c65a9bc4f226e8c8b290557ed0c7e5ab9e373e1af4f5248eaefd355eb8e6d5853f11bdc95fcf3fdd0a85add6eac98898534f677e9f6b843ebcf3e53c93f9382e9e02287d16066540638f00fa2718606a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000dc4dc6b8f1d08cfa8efcce33cd97d55a46422050a94f87ca154768f0676220a506a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ced05c6308b8f9874498edf6cfda59d7a1ee89e5661d4196385d502db9a16c5cca030703030400040400000007020001340000000000a767000000000050030000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce080401050206880216040150a93021a0aaaba0128166790f8450472dccded2f9d9809f4e89ccad52e80b7e3c788df5ccf194a18ab2990c7e57f4b837320f003b6d726d14c04bbe6dc3714302a67db9e36bc38212d9422dd0d8868e392c4094cea41b8255945935213f3bc9e305e3ff86ee538ceb42fa3281c4f2333126567b733b1b9806001f23f8fbc2d68a03a2e447c3e0d4793616b5ae546c20f611ffb8eb6b4dbb479d4eba6cf853b093dadbee0f3f1f7b06ea8c55dafeba11a7e0fa28652a97139f10d252e62b8a4b8d0f04846135552cd5ce2088bb9c41de367a0d1d77ce1b0aab33b4e2ed1edecb29429252424a0fea7a7b1d89b581700670463854377ef7181e7a2a740d22ea7f3703bc0000"
        )
    }

    func testAddAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddAddressBookEntry())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("Hd4srpDtCzUsySDVZVeaBNJA7txQrJfvaZjhVpWePnK9", "F2MWViB8wyK77MHVUbzyWDABgXu8SFBcM3iEREUdevAd")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8u1nbZ2Zv42ouiCVcJPqKQa7VZRoFSQhH6q7Ghkiurkb").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af347554e641b3f3724c0660945d56ca6c51979b4f8f8dfdb8969bb4f1633a8f88d4f6f848968b4992558e8a75c9f6dcffe090932a702d806fece59c015babc5391014f77b30cf799b059605b79ab2be10641f9c65a9bc4f226e8c8b290557ed0c7e06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ced05c6308b8f9874498edf6cfda59d7a1ee89e5661d4196385d502db9a16c5cca020603020400040400000007030301052209019a7410636292e6fe6a79c43d9986fd2ac850746a8b60cc37d96797c0cd847385"
        )
    }

    func testWhitelistAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddressBookWhitelistUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "d289ad6ec351ed2fa1dca209ac8e3bbdd19f3a7d5444e6583187631e0044022b".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("DcQPFjFjaTWCSvCNDu3fMzHjJJZggtgM69qasNGiKp7J", "9AxzqxyCzsFQFpRkXJsCbnkww53JCCZ9j5dBiVYtKRr5")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "77A6RbdEjz8JQFFfXBepk7ssX5QUxunQ3TTJdayjkqw5").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3440f2c5e3aff76fd4158bf8e53d852839783967ffa057e0989a18233b3de59f085ab9e373e1af4f5248eaefd355eb8e6d5853f11bdc95fcf3fdd0a85add6eac98bb5e02eeb4d3329a986b4f3fa26c0b6edd33bb9ac40a66ad9fce8e55f948b70906a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000dc4dc6b8f1d08cfa8efcce33cd97d55a46422050a94f87ca154768f0676220a506a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce796b09ffac78f0a42d65d5745216350086645772730cd520a9faf9e91700a55e030703030400040400000007020001340000000000a767000000000050030000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce08040105020648160000011c39ffbe2869723a3485c86d0ce1a0d00ee545abba4e1bad3de637f8b4aa46010201020033fa9b2a9a24f8261fb4d3cff40006a665314331e184bc66560bf63344f91337"
        )
    }

    func testWhitelistAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddressBookWhitelistUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("CDXW6vcyi78ZwLPpXJwumV4dqDYyW4Wg37a8FZznaTs3", "9AxzqxyCzsFQFpRkXJsCbnkww53JCCZ9j5dBiVYtKRr5")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8u1nbZ2Zv42ouiCVcJPqKQa7VZRoFSQhH6q7Ghkiurkb").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af347554e641b3f3724c0660945d56ca6c51979b4f8f8dfdb8969bb4f1633a8f88d4a6a603ac71f0551c6d9953d550bf3fc34347a96ea975b60e6d4aa790c6ad309640f2c5e3aff76fd4158bf8e53d852839783967ffa057e0989a18233b3de59f0806a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce796b09ffac78f0a42d65d5745216350086645772730cd520a9faf9e91700a55e02060302040004040000000703030105220901ff6beef8f31ebbff0f5f2379404e1b3b63b0cdd3ee1bae7ed5af529b997937f8"
        )
    }

    func testAddAndRemoveWhitelistAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getAddressBookWhitelistAddAndRemove()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "c72dc3b10c6905ac3d824707d37378238d5410fc2e4f975aeaa035b601e8705c".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("H7zYfWgtQE36oFigyuGY4XKuScoCWJaJjFESZbwMKBXk", "9AxzqxyCzsFQFpRkXJsCbnkww53JCCZ9j5dBiVYtKRr5")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "77A6RbdEjz8JQFFfXBepk7ssX5QUxunQ3TTJdayjkqw5").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af343803b4689d806534c7aae6d4a2271b4e6d1ce47015e12b6b13bdf9b90c328b145ab9e373e1af4f5248eaefd355eb8e6d5853f11bdc95fcf3fdd0a85add6eac98ef858b067c16f0c45e0758c97a463a1620b9d0fecc1a60a902d07fc5c8563daf06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000dc4dc6b8f1d08cfa8efcce33cd97d55a46422050a94f87ca154768f0676220a506a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce796b09ffac78f0a42d65d5745216350086645772730cd520a9faf9e91700a55e030703030400040400000007020001340000000000a767000000000050030000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce0804010502064a160000011c39ffbe2869723a3485c86d0ce1a0d00ee545abba4e1bad3de637f8b4aa46010203040201023e16f1767fefc769b7ec3ff138f6dd3d01c1da6745484166e3c0ac6069174681"
        )
    }

    func testAddAndRemoveWhitelistAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddressBookWhitelistAddAndRemove())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("E7RtSB2u2sZy54FeHppaj4nYhdfvxsshAKd5u3iB71wW", "B1vADBUUbPLrZGg43MUwsvoGF8nhGhMZgnG6jiz9HWfS")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8u1nbZ2Zv42ouiCVcJPqKQa7VZRoFSQhH6q7Ghkiurkb").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af347554e641b3f3724c0660945d56ca6c51979b4f8f8dfdb8969bb4f1633a8f88d4c2cd8df2aa60eb0f9489722851b74098d191194381c7519d79b13b07d1478d093803b4689d806534c7aae6d4a2271b4e6d1ce47015e12b6b13bdf9b90c328b1406a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000008629739ae31d052f08b5534253dac669eb963e39b38fdfa02dc4b52ce55db0ce94d0f9e1ddeb6a4c1d7f10e6b1511457c16a7d1bb08b328bf1c832167aacd1a902060302040004040000000703030105220901f95f01739c3b38b7c5b916a1eecd4b69db2153281078c97065a610a171b661ca"
        )
    }

    func testWalletConfigPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getWalletConfigPolicyUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342ae5404ca4d115addf760a932a2564636c071f3d93077c7722926026963d760e8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7d17a6a48d07bbbf8d76e02379e0758f4580f3cb34a56980929e72e9b0d58e97206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209019a8396d2fa315bafcfe5ca0d78946f4bf31297feb3036fd82998f28c0af3332c"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "5zpDzYujD8xnZ5B9m93qHCGMSeLDb7eAKCo4kWha7knV").toHexString(),
            "03010409d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34d17a6a48d07bbbf8d76e02379e0758f4580f3cb34a56980929e72e9b0d58e9724a3e400b6f36e0b517ed08ced47959f691ac7badf37f3894b745a78ae4c4a01a8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd70a4b19fe3af610a9e087ccad29c92dbcbc2a3a6671794cd819a6004877bb0ea006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030500040400000007020001340000000000a7670000000000500300000000000046b0ea2883f065b5469948ac86ffcda8d7fb98f891b0c6f805c4cccb9dabcacf0804010402062e0e035046000000000000030001024041109cb8f8611bd2813af557df74e80cb9da3a2599894d5d990fc13536d917"
        )
    }

    func testBalanceAccountSettingsUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountSettingsUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7e40128881204af69745129ee3357a788ce003ce6171a9e92a011afc775b8ce6006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209011df7ee9884d25dddac4fa0b133456174394207dba45a16fbd963f07c8c5447f4"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e40128881204af69745129ee3357a788ce003ce6171a9e92a011afc775b8ce609e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000003468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f08040105020625123c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c401010000"
        )
    }

    func testBalanceAccountPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountPolicyUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("BzZpoiceSXQTtrrZUMU67s6pCJzqCDJAVvgJCRw64fJV", "BeAVku8zsY9b1SzKU1UPkyqr6feVtiK7FS5bGHjfFArp")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34a6bba3eafd49e6bf5e8facf0faeea7cf500c019cd18cfa625f764213df7b8bd5a3541700f919ae296291c89fcff67de5d3cc0d941dfd342c85e641f6cea2cb56bb2b351f441f46df2039f49e8cd3f01079a908cad599a84079cb8189b218f57806a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b9e1a189ce3273e79eef0d169e15ced5902ca2a4a680fc7f710ef4513ef02ebdd020603020400040400000007030301052209013805e2569f36e15a83d558a3092cfd97e9932b34a06ec76bc04fa649f7c23d40"
        )
    }

    func testBalanceAccountPolicyUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountPolicyUpdate()
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "370349daceb62cb1ad6f37fbaba12dc72e36367c57b2ee976527609cd8d3f63e".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonceInfos: [getNonceAccountInfo("5Fx8Nk98DbUcNUe4izqJkcYwfaMGmKRbXi1A7fVPfzj7", "DvKqKEBaJ71C5Hw8Yn45NvsYhpXfAYHybBbUa17nHcUm")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h").toHexString(),
            "03010409d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34bb2b351f441f46df2039f49e8cd3f01079a908cad599a84079cb8189b218f57838e70bc45546b0d63742dee544ecc6870f66da475c800d2d793c766b03266cca3f4336251703628ce12796daa20166a1f0da8a9a972775f9f04a256482e2bedec43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f406a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09bbff5520f20afb88a51a9a0630fb5bc2738f26b68af438c6a1750a68a4c2fc3c6030703030500040400000007020001340000000000a7670000000000500300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b0804010402064d1a46834450499b8d2edd17b54df5b3cd21a7e40369f8e3f8f072470cac3a271a7402100e0000000000000200011618435becfcd77198205d44019be2254d324294b97ef819e0c77d3af8b0e446"
        )
    }

    func testBalanceAccountNameUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountNameUpdate())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd75c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb241006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209010c2b34abcc84e4ae92d3120231ba6a13303976d34e1e8951565dbe2700ca6538"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af345c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb24109e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000003468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000000a7670000000000500300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f08040105020641183c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c44e637072f628e09a14c28a2559381705b1674b55541eb62eb6db926704666ac5"
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
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "CXCdHsyMVVKEQbRorowkBBnRtmC7QSAmg4QFqQJAMt85").toHexString(),
            "0301070bd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af344b6a3d93450d66eb4dc907e6f3c8f478feb3c8afd69ea70a6f73eb771d87cb14ab2d202d4ab70a619c12c35cd765878d7711743f57c555940b27087173491fd68e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000c43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f4069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008269b01bf858c755348eccb7fd606a006e63d0cd6c0eb0b1a88694fbd26ffae0000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030903030400040400000009020001340000000000a7670000000000500300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b0a06010502060708621d794b77f810f9c71db95d8fd3a9adc5805b501983c8e0b50ee675c3dc13eca3f601794b77f810f9c71db95d8fd3a9adc5805b501983c8e0b50ee675c3dc13eca3f6069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f00000000001"
        )
    }

    func testSPLTokenAccountCreationApprovalRequest() throws {
        let request = getWalletApprovalRequest(getSPLTokenAccountCreation())
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [getNonceAccountInfo("AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7067de40aba79d99d4939c2d114f77607a1b4bb284b5ccf6c5b8bfe7df8307bd506a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a02060302040004040000000703030105220901609e5e67b61a6817c2071005eff4f663226b78e78fd533c6f8d3ce80c564bd5c")
    }

    func testLoginApproval() throws {
        let jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6IlNvbHIifQ.SWCJDd6B_m7xr_puQH-wgbxvXyJYXH9lTpldOU0eQKc"
        let request = getWalletApprovalRequest(getLoginApproval(jwtToken))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonceInfos: [],
            email: "dont care"
        )
        XCTAssertEqual(
            String(decoding: try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL"), as: UTF8.self),
            jwtToken
        )
    }
    
    func testBuildGetMultipleAccountsRequest() throws {
    
        let getMultipleAccountsRequest = StrikeApi.GetMultipleAccountsRequest.init(
            accountKeys: ["GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL", "AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy"],
            id: "B199C55D-F8F0-4AF0-8D4B-B6AF6A3DA0B9"
        )
        
        XCTAssertEqual(String(decoding: Mock.encodeJsonType(value: getMultipleAccountsRequest), as: UTF8.self), "{\"id\":\"B199C55D-F8F0-4AF0-8D4B-B6AF6A3DA0B9\",\"method\":\"getMultipleAccounts\",\"jsonrpc\":\"2.0\",\"params\":[[\"GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL\",\"AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN\",\"9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy\"],{\"encoding\":\"base64\",\"commitment\":\"finalized\"}]}")
       
    }

    func testExtractNonces() throws {
        
        let response = "{\"jsonrpc\":\"2.0\",\"result\":{\"context\":{\"slot\":402},\"value\":[{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNCdJE0k9Ajpn/cEy3TSbbYl5dgEsceAKtAIKa1nvxf6QiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNPowQba3TsNG8RNMBrZK/RZighANP8iUyL4yx85rzJDLiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNIQJ8qqFaevM1IJGpCc4YNY67rnrwwyslHS6t+htayrBiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},]},\"id\":\"5c0c319a-4482-45c3-b9b9-d54975c1c4eb\"}"
        let getAccountInfoResponse: StrikeApi.GetMultipleAccountsResponse = Mock.decodeJsonType(data: response.data(using: .utf8)!)
        XCTAssertEqual(["3eMXeaEkwY5C6UxB6jsMjRGAsDcozgMCdjbZoowSTXZy", "HqdbyB576ggyavQPaodKiS8XNPHBoo95rb75Le7XzXrr", "9tRccoR8XEVfP32LEZYtZuR8YFYFbPg9kCKnBicdPQHN"], getAccountInfoResponse.nonces)
    }

}
