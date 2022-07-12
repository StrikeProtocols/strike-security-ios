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
        let request: WalletApprovalRequest = getSignersUpdateWalletRequest(nonceAccountAddresses: ["123455"])
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("12345")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.opHashData.toHexString(),
            "052ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf06666f09f8f34b25830470a1920b59fee4de9e04dd0134ba5365ceae769cf9d6637000000000000000000000000000000000000000000000000000000000000000000000000000000000d79ee6b8ae98d572459d5d6572f088a8f6b1f40655eee8c981056b205e41a37500010156b088482c6882a3def445509a410c837a27476140df0c0da4be446071000e"
        )
    }
    
    func testSignersUpdateApprovalDisposition() throws {
        let request: WalletApprovalRequest = getWalletApprovalRequest(getSignersUpdateRequest(nonceAccountAddresses: ["BzZpoiceSXQTtrrZUMU67s6pCJzqCDJAVvgJCRw64fJV"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("HPaFoRv9A6T14AhGu5nJWMWTb6YuJYCNZEGnteXe728v")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34a6bba3eafd49e6bf5e8facf0faeea7cf500c019cd18cfa625f764213df7b8bd5a3541700f919ae296291c89fcff67de5d3cc0d941dfd342c85e641f6cea2cb56067de40aba79d99d4939c2d114f77607a1b4bb284b5ccf6c5b8bfe7df8307bd506a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09bf3835ed0ddfb443583764c93f133c341bdcde7a0c5cd2a40348b67c20722edaf020603020400040400000007030301052209019e212bef13fd898e60f8981adf893ef21b3165905a31ea85d50d3bc0b17130a9"
        )
    }

    func testSignersUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getSignersUpdateRequest(nonceAccountAddresses: ["5Fx8Nk98DbUcNUe4izqJkcYwfaMGmKRbXi1A7fVPfzj7"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4ec605d194c0279e9b615464d8c6a723f8995e951b1d192b4123c602389af046".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("6HeTZQvWzhX8aLpm7K213scyGExytur2qiXxqLAMKnBb")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34067de40aba79d99d4939c2d114f77607a1b4bb284b5ccf6c5b8bfe7df8307bd538e70bc45546b0d63742dee544ecc6870f66da475c800d2d793c766b03266cca3f4336251703628ce12796daa20166a1f0da8a9a972775f9f04a256482e2bede06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000c43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f406a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b4e8e14d4ca1428da3032a7ca98a145dde83e2c86a7a5996eca2a42865f13f62a030703030400040400000007020001340000000080b2720000000000b80300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b080501050206004c0c0000000000000000000000000000000000000000000000000000000000000000000000000000000000010272808ca267038e63a906c4ce421be377743b634b97fc1726fd6de085d2bcc9b1"
        )
    }

    func testBalanceAccountCreationApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getBalanceAccountCreationRequest(nonceAccountAddresses: ["Hy4Ztych4X12wWieCaFbSEbwZRxmjRTMgbm7RDybYTpD"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("QRKqHqP5SNEngXrcK2QeAR2nqx9AmwbHrmYF49ZbkEK")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "7AH35qStXtrUgRkmqDmhjufNHjF74R1A9cCKT3C3HaAR").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7155b867b0ff902f8bd3503e7a6c3ba5a94b90bd26858f6de78aa0913af0d8be7c6fc178caf216681e7b5d744beeca4c54681c9df12ffbd88f3bb1629ec0d56475211fa69aa5bb02ddd4a80e4673e541767116f2034406d2f917725045d215bdd3f06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d05ffdcd59d8f12aab0f8644eb0a57db2187baf6cc1e0115a977082f2ecd54120020603020400040400000007030301052209010aba765b69604b25cb6cca94eb09179fb0c181d1ead2e25d4430fd8c52e89419"
        )
    }
    
    func testBalanceAccountCreationInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountCreationRequest(nonceAccountAddresses: ["CL8fZq5BzjCBXmixSMKqBsFoCLSFxqN6GvheDQ68HP44"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "2d7db52f8ff35aec03cd7be8d26c45d798774a4d5dfa9a9c559778752fb87d11".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("QRKqHqP5SNEngXrcK2QeAR2nqx9AmwbHrmYF49ZbkEK")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "3wKxhgiogoCaA2uxPYeH7cy3cG4hxRPogrPmDPLS54iZ").toHexString(),
            "0301050969ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c71511fa69aa5bb02ddd4a80e4673e541767116f2034406d2f917725045d215bdd3f2ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf0666a8574221c4298fd6dd12f8d67ac57a7e3586087ff177defef319a8f2b7ae8a9906a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ff90e321f14ded704cbb267d1cbd7c0e9ae8c5e3ccbb6f47c95bbf75d5a924a606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d05ffdcd59d8f12aab0f8644eb0a57db2187baf6cc1e0115a977082f2ecd54120030703030400040400000007020001340000000080b2720000000000b803000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d080501050206009901030000000000000000000000000000000000000000000000000000000000000000000000000000000000b59460e652df36f1ffb509cdf44bb3469f9054f93f8f707fe56685cdc6fc9c3300b94e0c79c1fb7db6ff3380f8bd8f09376fb8f87c488f98ec920164e1e3a7417101100e0000000000000100b33db8d45a74ca5c0593ea113efc73528320af0a70713d08f1ec3fa085c9c74c000001"
        )
    }
    
    func testSolWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSolWithdrawalRequest(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c71501d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd77c4c8d158b8f7d6a29a29e8f938db7344b356d823531737b5405d71c995eab1a06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a0206030204000404000000070303010522090132577d9ee7c270f02040c9da6af65a135da4b69c5d57bebdb52e245ecc0f16d8"
        )
    }

    func testSolWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getSolWithdrawalRequest(nonceAccountAddresses: ["CL8fZq5BzjCBXmixSMKqBsFoCLSFxqN6GvheDQ68HP44"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "7de2dc4f438213a502317cc43a58cbe4a23e8680a2438e9166334393effd726f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("4LTSSabuoUArWeLyAS2nstT4EjmP8L3y8qXYgJqRs6RC")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "3wKxhgiogoCaA2uxPYeH7cy3cG4hxRPogrPmDPLS54iZ").toHexString(),
            "0301080e69ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c715f6e8d816af808b1e4407ef06675d067e201881fc785606e3a12eec7c8bccb0712ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf0666a8574221c4298fd6dd12f8d67ac57a7e3586087ff177defef319a8f2b7ae8a990be476bc2de9162c6f52a1170d16d263bd60cca5c76b924b8b94690e4c22a10f000000000000000000000000000000000000000000000000000000000000000006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ff90e321f14ded704cbb267d1cbd7c0e9ae8c5e3ccbb6f47c95bbf75d5a924a61209c6930f6cb4d8e110eb62f6f9133ec338123ab6822970d5c055e0e0adc33b06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d318efd8bd8dbc9ddab3329f58c5b16054ef3506a1c7c284eb6a13411a94f913f030503030600040400000005020001340000000080b2720000000000b803000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d0d0d010704080209000505050a0b0c72070000000000000000000000000000000000000000000000000000000000000000000000000000000000b59460e652df36f1ffb509cdf44bb3469f9054f93f8f707fe56685cdc6fc9c330065cd1d00000000cd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be"
        )
    }


    func testSplWithdrawalRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getSplWithdrawalRequest(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "8CpMnz9RNojAZWMyzWirH3Y7vBebkf2965SGmcwgYSY").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3401d86d390e73db0061cc718bad82036d774f115923c2e5e6c675ca99dd41c4fd8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f23006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000000ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076267c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a02060302040004040000000703030105220901f5b64c094158e4d4b31dfc38b6c2b28b458a5d9fe0c33f1cb3736318f77f5a52"
        )
    }

    func testSplWithdrawalRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getSplWithdrawalRequest(nonceAccountAddresses: ["6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4ba2d7074c6fa66dca792b64260b0513a229fa0849b1ceaa5b9cff1285fedee7".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "AbmwBa52qPj5zpWQxeJJ3ZSDRDxnyZMWitrE8nd4mrmi").toHexString(),
            "03010a10d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e34e9cdb62a817da76d5163666c93570c210e7287f7f268c77236b3002156ca08ea1bcb15aa292a9b51b7f05f19d0e27669957b9990a4aa8f9cddc1cf4c56c55515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230f46cdc8655b9add6c8905bd1247a2ef15870d4076fb39915885d08628a9f22a493c4b438027247811fa84db55c2e6ede640264dad0876d56a8bf819f2cb17bfa06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000631f065d4a6b93340e8b8a8c3061fd6eb0b7d402fe560fc40a84e9c8ce1ac3035c66b35c237860fd27d95409d452edbd91300bbfe80850fd4841759722b5073106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008df1a38eac809d9806f4e9502bc085aadb4975b84dc3ba062b1ce416efd4b1c5000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076268201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030b0303060004040000000b020001340000000080b2720000000000b8030000000000000ec4916daf26706bf27b89ecfff6ba56155f1d4ab734f92f008b81d4176076260f0d010704080209000a050b0c0d0e72070000000000000000000000000000000000000000000000000000000000000000000000000000000000c381ac8c68089013328ad37eda42b285abedc13fef404fc34e56528011ded600f401000000000000f7d1a2ef642101c041a4523de1dd26652402149065ae308c55e1924cb217cb48"
        )
    }

    func testUSDCconversionRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getConversionRequest(nonceAccountAddresses: ["6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "02010307d2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e5335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230000000000000000000000000000000000000000000000000000000000000000006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998478201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a082602030302040004040000000603030105220901db20e8ec87e412a88078e810a7dda408df916bd03f429a92a6d3b00fd819e304"
        )
    }

    func testUSDCConversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getConversionRequest(nonceAccountAddresses: ["6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "5f27be66e3eb697a4274f9359c87f9069762a5e2cb7a63a622e923bd6119b963".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "6bpAbKqWrtXBtdnWqA8YSybGTeyD91u9MNzQuP7641MH").toHexString(),
            "03010a10d2c2e3ac53223ce6b5a6e04fe0f98071cf10a62646b6c1c100f9829afcced04e17ce130f4d1b123ff7f5f840aee4e9fa5665106de0cf2d1245c2b60f6ade6e245335831f99da167bf80d87be098dbaafc9309035be4aedd53460c3571c05b6a0515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f230d1e5bffc491a1b7890805d162a2cf8f0a2facae1df8579eddfed575e44f958108e829493f87ba7dc9497154a2cf8e656ee9979277f9ac88b5570775e7cb447d106a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000001bbc7e99fc43d0c442a698780fa1c7e4bcfbe5f100df263390ef0ab695e1b85aa1a993efade361c637af59e4d387db1aec381df43083f38e789f4bd57280889906a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000008ac94d970e27bc29711d382b1d5fac3fe82f590485b065e57fcc6e83424110cd000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998478201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030b0303060004040000000b020001340000000080b2720000000000b803000000000000a78bdd1907176367f56f7fab4bee90dabaa7372794fb0403f75f2a96580998470f0d010704080209000a050b0c0d0e72070000000000000000000000000000000000000000000000000000000000000000000000000000000000138543b25e89429dae0ec18a0fa198dc5006898f91b3b99d80a58d65bcdff9d00065cd1d00000000455c311d68d6d25a36bb09d58c4f62e6e637031c29b7fd3bd205b658500739cf"
        )
    }

    func testWrapConversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getWrapConversionRequest(nonceAccountAddresses: ["6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "46b397c81d81f9c745bb61baf28337888907696c5e653a08a98b5ecbcc1c82c8".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301090fd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af342a6b6e29ec48d15d528b864b1d58f441b263ed5f24db504928f6090efc8cb41d0b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f2309b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496f06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d8201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030a0303060004040000000a020001340000000080b2720000000000b803000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0e0c01070405080209000a0b0c0d530a0000000000000000000000000000000000000000000000000000000000000000000000000000000000c344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc0065cd1d0000000000"
        )
    }

    func testUnwrapConversionRequestInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getUnwrapConversionRequest(nonceAccountAddresses: ["6UcFAr9rqGfFEtLxnYdW6QjeRor3aej5akLpYpXUkPWX"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "4cdbc626f9cb68219d52d49d80041ab0b3b130d1880323a763b3eed8d4f8ff0f".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9kV51VcoGhA1YFkBxBhd7rG1nz7ZCVcsBpqaaGa1hgCD")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "mPAWwEkDygfLX7A8Tzox6wyZRBrEudpRN2frKRXtLoX").toHexString(),
            "0301090fd5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e9afcff207f5614ebfa3a3522dfdaac0bc90d89768e6ee6b0a700d41dada06180b5e9dd920eed912053e5333449d7a92d82d80ebea0f12829aa36e93559b000e515cf7a3ae636d0b1f0ac3f76dc5bafdf519e49df160e0d2f5eb77747a40f2309b0ed81b27ca1d63c6a994c30755027b44c213a3a5948040c8d4e1703ed539fb5abb3bbf8838f5129b8032b1f4ffac9f4043ef034e9d9dab4d32f25055c7496f06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ca16efb68a8429558cd821a7c0942d5960f0b2c5b7f3a54caf6920e4555ac75c069b8857feab8184fb687f634618c035dac439dc1aeb3b5598a0f0000000000106a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a906a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f859bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d8201354297cec572707724dac5f6c92613c5a8f04e34fe284c882de8d09a0826030a0303060004040000000a020001340000000080b2720000000000b803000000000000bad1dda43bb63a1a1841895eae8fc1398f8e943ccf637d87c6f25aa82b25067d0e0c01070405080209000a0b0c0d530a0000000000000000000000000000000000000000000000000000000000000000000000000000000000c344bc80949c53bf0f257f570c1beea68dbc9563a595d46d5c9a7367bd12a5cc00a3e1110000000001"
        )
    }

    func testDAppTransactionRequestInitiationRequest() throws {
        let opAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "179ae3647039dd13d58d78fdf31cb35e3b9103fb41720bdc95af9afe03f1662d".data(using: .hexadecimal)!)
        let dataAccountPk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "6b49f9cd575c582c8f64817cc7dba549bb69e567b6064628bbb6b65d7d1c6ac6".data(using: .hexadecimal)!)

        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: MultisigAccountCreationInfo(
                accountSize: 2696,
                minBalanceForRentExemption: 19655040
            ),
            initiatorIsApprover: true
        )

        let nonceAccountAddresses = ["6q8QvCakZbrCX9JfaX7wqSqEyH5jSXQfUXkWkdrwKjjR", "B6qJKT9jM179reREPi2bBDGNkPFu7AikcD16meF9oDAq"]
        let nonces = [StrikeApi.Nonce("7c64nnSxKeafeVJXDL8zevw7BrJuJXEBocKtq4ACqtMj"), StrikeApi.Nonce("CxHpDahpQjKoVWGS1GxMFZJH5EUo64SRv6tDw18fipxW")]

        let requestType: SolanaApprovalRequestType = getDAppTransactionRequest(nonceAccountAddresses: nonceAccountAddresses)
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: nonces,
            email: "dont care",
            opAccountPrivateKey: opAccountPk,
            dataAccountPrivateKey: dataAccountPk
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "9CZ2ZaGe961oLCWJUpr16ofZxBM4yK9tGfbdwj57JNJP").toHexString(),
            "0401050a69ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7150f44b95f05109e7d11916ea590ee2fea974c7b8f6770cc1ddf5803d23710c9b52f752b200e8b2e03e7771f9d4939b089d13eabf0bf33727cd15bbe9aacf6725779d318e6a73e07800b2926954fdb8d5a27f1ec0c18c3d6ca58c0425b12a80eec569eb1d501bd3e3c77f977f89c0320e93d84efaf1077cf7da0e3af8dd9e87cd406a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000020c679de1ce4f278bd4da2570d112234a9bee1b6190b7058b2f60a12312f9b2606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000a943a3e5f0b9c6a7eb4b22252661255343a37da20a0f14adb3f39a005c5fafe662232d616155a19d0e2b92928affb521a688ca8e045e3a70bc13eba7620b4a6e040803040500040400000008020001340000000080b2720000000000b803000000000000a943a3e5f0b9c6a7eb4b22252661255343a37da20a0f14adb3f39a005c5fafe608020002340000000080e92b0100000000880a000000000000a943a3e5f0b9c6a7eb4b22252661255343a37da20a0f14adb3f39a005c5fafe609060102060307008b0110000000000000000000000000000000000000000000000000000000000000000000000000000000000022cf856d07599f5067980ce99e7f9f23ca40ee4cfbc9e12abbbc50149c9d3bbb5799eb58cf6d907afb115709b5e2979cf8fcacf90c328977c15d618948009ae72e90c13b0d471b592c2984568133a41676460f72c885db57ad26bd5b628f938201"
        )

        let supplyInstructions = try initiationRequest.supplyInstructions
        XCTAssertEqual(supplyInstructions.count, 1)
        XCTAssertEqual(supplyInstructions[0].nonce, nonces[1])
        XCTAssertEqual(supplyInstructions[0].nonceAccountAddress, nonceAccountAddresses[1])
        try XCTAssertEqual(
            supplyInstructions[0].signableData(approverPublicKey: "9CZ2ZaGe961oLCWJUpr16ofZxBM4yK9tGfbdwj57JNJP").toHexString(),
            "0201030869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c71579d318e6a73e07800b2926954fdb8d5a27f1ec0c18c3d6ca58c0425b12a80eec9613627b7c3e405880c3383eff26242b7b69eafd4b76ed308fe32634485d9c9a0f44b95f05109e7d11916ea590ee2fea974c7b8f6770cc1ddf5803d23710c9b52f752b200e8b2e03e7771f9d4939b089d13eabf0bf33727cd15bbe9aacf6725706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000000000000000000000000000000000000000000000000000000000000000000000a943a3e5f0b9c6a7eb4b22252661255343a37da20a0f14adb3f39a005c5fafe6b19a832ef4b8133a48e17d0cd56a779299fac0fd77f41dd97051f8a64be75b570206030205000404000000070303040193021c0001008c97258f4e2489f1bb3d1029148e0d830b5a1399daff1084048e7bd8dbe9f8590700031e1fbf344b4b060e7a8cf8727f02c5ff4e52d2f6cfe3471c931d24aee167057801120bc93553699a0a797793414bc7059c5bcd6c596e1049341a5b4be8af8f372a031e1fbf344b4b060e7a8cf8727f02c5ff4e52d2f6cfe3471c931d24aee16705780020ac2e79fc1dac5bc9d5cab6f58ead3c9e9c135e1497a00015600ca33685fa9d0000000000000000000000000000000000000000000000000000000000000000000006ddf6e1d765a193d9cbe146ceeb79ac1cb485ed5f5b37913a8cf5857eff00a90006a7d517192c5c51218cc94c3d4af17f58daee089ba1fd44e3dbd98a000000000400010203ac"
        )
    }
    
    func testDAppTransactionRequestApprovalDisposition() throws {
        let request = getWalletApprovalRequest(getDAppTransactionRequest(nonceAccountAddresses: ["6qxrNFPEwqvTprbHjo5VwDCDL3sAzj16Ba1p3hQvzTt6"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("8tNhhNgromsiM2ieYrvmm79AS6fHZj7r6wf3A2sX71HK")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "BgfDEzbk9ZiH1UjmzB78gG6DSoiob8KXzbXWy1Y8dEc8").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7159ebdb9e802a55fc6781b8e0e13f1a2306fa6a4b82c21f15168bf624d7ff97f3956d576ed3651827f8030a11e6cb99c70be0fce8788407a66f1c627c317849bd30f44b95f05109e7d11916ea590ee2fea974c7b8f6770cc1ddf5803d23710c9b506a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000a943a3e5f0b9c6a7eb4b22252661255343a37da20a0f14adb3f39a005c5fafe6752af7c79311c9bf9adc6b2c48c30084a9efa9bc55bce55e91f06bba36b0d48202060302040004040000000703030105220901c8d7278004f9b6b989430ac3fbdcd9fd937777099acf64f4f2bff5d57ad0e576"
        )
    }

    func testAddDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddDAppBookEntry(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf6138e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e60206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a02060302040004040000000703030105220901d0225d0606ab4392c16c7be80cbf674e9424767c3c9acdb8ae1661470c4ddb65"
        )
    }

    func testAddDAppBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getAddDAppBookEntry(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "72ff8f7fb4a441c93d4003e2bf67dd367e3293311c4f9433c422a2fbf305c477".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34f9437a782883b62d38738b3da7fada188510e6d57d1e09bdbde19cf7ed16e602982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f1118e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000080b2720000000000b8030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c080501050206006d1400000000000000000000000000000000000000000000000000000000000000000000000000000000000100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb000"
        )
    }

    func testRemoveDAppBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getRemoveDAppBookEntry(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "ErWAApTUwunKAobwFrVe2fTwtqdsQecQqWKSQJzysg4z").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34cdd65bdd5302de9e0457368e03c37dcd1e9029c3ab0facdcfc5889a81d0cf6138e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd779dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209019268d8dd8d58ab95cf2d7f3ed9312dfbc131310a3068c8affa3b6518a359c85c"
        )
    }

    func testRemoveDAppBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getRemoveDAppBookEntry(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "1d3462075eae5a46257981c00c20982dd27a88b70a88ff95455dad6bc88859aa".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "BEzpSizrNZpCeLWTk23nozu4T4wEzxoDJGoUUYBBhVbE").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3479dac0b298597dcbf810eb17709c9a75e1f4e569efe90f323c91c4ef084882c2982acb779028b0afdd5da5a26d78e1b82804ae449ce2fd2767d15f4325a7f1118e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000064fd89d243e47f6bd6ea9c7462d7ca1d504c02bf67d2b6738f892897ecaeab206a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000080b2720000000000b8030000000000002345d893870173ce1252d056dbc6c8bf6bb01f157832734623958d6249e63b5c080501050206006d140000000000000000000000000000000000000000000000000000000000000000000000000000000000000100e4523ff383e6bb5f73d3745e3554f53a56c61ba17c7bc49e481a9d01a96fdbd6a9037bac86a669c3470c8da04dcec8f3a3ec671cd157264078954f38c387efb0"
        )
    }

    func testAddAddressBookEntryInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
       )
        let requestType: SolanaApprovalRequestType = getAddAddressBookEntry(nonceAccountAddresses: ["8R4EuFv5f31D8HijRXA4eyebKMZ287ho2UyPpbtQ8Gos"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "a37195e87d53a831c1947e8afe02aec367e78f62fb912f7a614c3a387cd911fa".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("7r8cdEASTnapMjhk569Kwq7mtWwaqjMmkxYe75PBCCK5")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "3wKxhgiogoCaA2uxPYeH7cy3cG4hxRPogrPmDPLS54iZ").toHexString(),
            "0301050969ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c715be9052f2d7dc89487f3ec139a60d9cdda96f0d21895effdc81fc6906936345442ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf06666e2b693808b4e0103f5b69faec8d19b9b92d12819052c214855f50e7dd3d1e2206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ff90e321f14ded704cbb267d1cbd7c0e9ae8c5e3ccbb6f47c95bbf75d5a924a606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d65bc30ccd8e88f4b8d5cf5903523b520f1cf0dea124d428b55038269c03609bc030703030400040400000007020001340000000080b2720000000000b803000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d080501050206006e16000000000000000000000000000000000000000000000000000000000000000000000000000000000001001209c6930f6cb4d8e110eb62f6f9133ec338123ab6822970d5c055e0e0adc33bcd62deaa07b0058a44cc8ec7b3a5fc67156a8b6d82bb4223b58d554a624256be0000"
        )
    }
    
    func testAddAddressBookEntryApprovalRequest() throws {
        let request = getWalletApprovalRequest(getAddAddressBookEntry(nonceAccountAddresses: ["Aj8MqPBaM8fSbgJiUtq2PXESGTSQPsgHqJ13JyzQZCRZ"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("7r8cdEASTnapMjhk569Kwq7mtWwaqjMmkxYe75PBCCK5")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "7AH35qStXtrUgRkmqDmhjufNHjF74R1A9cCKT3C3HaAR").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7155b867b0ff902f8bd3503e7a6c3ba5a94b90bd26858f6de78aa0913af0d8be7c69083e5bc3e157aff14eb7d4db4331ce36f0b43c131c269bbe16f79ab36f98eacbe9052f2d7dc89487f3ec139a60d9cdda96f0d21895effdc81fc69069363454406a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d65bc30ccd8e88f4b8d5cf5903523b520f1cf0dea124d428b55038269c03609bc0206030204000404000000070303010522090116aa15d9a45731f7335bdda8a6ffb737d81fa305362c38ff4e9a8495bea126c9"
        )
    }
    

    func testWalletConfigPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getWalletConfigPolicyUpdate(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "3tSshpPL1WyNR7qDfxPffinndQmgfvTGoZc3PgL65Z9o").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7152ae5404ca4d115addf760a932a2564636c071f3d93077c7722926026963d760e8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd7d17a6a48d07bbbf8d76e02379e0758f4580f3cb34a56980929e72e9b0d58e97206a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a020603020400040400000007030301052209019eeebc4458643d9d4e03275c4e0c7fa3f6b9d550948e0e7a6768da4e9a5e1e51"
        )
    }

    func testWalletConfigPolicyUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getWalletConfigPolicyUpdate(nonceAccountAddresses: ["5osJEyGL1Ryiv9jedyhjnMqXHQaAM6A5PK253DTCTVdf"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "57cd2b0b1df0dd87e9001553716f2f4e9e1d2a8d0f4019f3048584cd3e83b385".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("7r8cdEASTnapMjhk569Kwq7mtWwaqjMmkxYe75PBCCK5")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "3wKxhgiogoCaA2uxPYeH7cy3cG4hxRPogrPmDPLS54iZ").toHexString(),
            "0301050969ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7154bccd7a4522437daafe21e92b2b39dc596693b65aa9998ba1d961371884161272ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf066647705611fa76d9ad3d1f58734c7ddc3476ef2e1317d807cb3b367a67ff75f83e06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ff90e321f14ded704cbb267d1cbd7c0e9ae8c5e3ccbb6f47c95bbf75d5a924a606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d65bc30ccd8e88f4b8d5cf5903523b520f1cf0dea124d428b55038269c03609bc030703030400040400000007020001340000000080b2720000000000b803000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d08050105020600560e0000000000000000000000000000000000000000000000000000000000000000000000000000000000025046000000000000020001358bd353729e02da524daff5551b39a3560970f30898fb5eb106986174088441"
        )
    }
    

    func testBalanceAccountSettingsUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountSettingsUpdate(nonceAccountAddresses: ["CpBzxGEDYnzi9jfGteSR6sCnmtT9XwirXQaCtSvmWnka"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("QRKqHqP5SNEngXrcK2QeAR2nqx9AmwbHrmYF49ZbkEK")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "7AH35qStXtrUgRkmqDmhjufNHjF74R1A9cCKT3C3HaAR").toHexString(),
            "0201040869ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c7155b867b0ff902f8bd3503e7a6c3ba5a94b90bd26858f6de78aa0913af0d8be7c6af874a8154f0de3ee6ff1668b3c18c49d62445d051d6b5cdcd6f5ada742c7d5bbe5ad75c51ec9e4c5d99214b8857b1d3ef76e40960b3ce2160a1c70fb0047e3606a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d05ffdcd59d8f12aab0f8644eb0a57db2187baf6cc1e0115a977082f2ecd541200206030204000404000000070303010522090105339c334afb37619a4fd2bb47a885e8e1a72c52696893d8188666d0995a17b9"
        )
    }

    func testBalanceAccountSettingsUpdateUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountSettingsUpdate(nonceAccountAddresses: ["CL8fZq5BzjCBXmixSMKqBsFoCLSFxqN6GvheDQ68HP44"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "514c07777ad9cd72f1493191f785170e1c14c5e37c9c6714863c9fa425965545".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("J2gVnUf56KpHARmwbagi3sX2TFHXNBUBGugXtvJrgxJq")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "3wKxhgiogoCaA2uxPYeH7cy3cG4hxRPogrPmDPLS54iZ").toHexString(),
            "0301050969ab8cb05413af9614f898a1f1fdfbc07e7ad5eb2eb1d0f1c49f448bd179c715be5ad75c51ec9e4c5d99214b8857b1d3ef76e40960b3ce2160a1c70fb0047e362ba22d14fd3198775d3b9d1b22d6b48743f502ac2129cdf0094af144febf0666a8574221c4298fd6dd12f8d67ac57a7e3586087ff177defef319a8f2b7ae8a9906a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000ff90e321f14ded704cbb267d1cbd7c0e9ae8c5e3ccbb6f47c95bbf75d5a924a606a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b21000000000000000000000000000000000000000000000000000000000000000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03dfd04eac9b2ed33f69fc778f2c3d9e413e041a3a07bf3fa787f1c14301000214e030703030400040400000007020001340000000080b2720000000000b803000000000000095f6d73715ba2affc6e25f8845e8f18908d92a129f233413b34d675d6fbd03d080501050206004e120000000000000000000000000000000000000000000000000000000000000000000000000000000000b59460e652df36f1ffb509cdf44bb3469f9054f93f8f707fe56685cdc6fc9c3301010000"
        )
    }

    func testBalanceAccountPolicyUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountPolicyUpdate(nonceAccountAddresses: ["BzZpoiceSXQTtrrZUMU67s6pCJzqCDJAVvgJCRw64fJV"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("BeAVku8zsY9b1SzKU1UPkyqr6feVtiK7FS5bGHjfFArp")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "CDrdR8xX8t83eXxB2ESuHp9AxkiJkUuKnD98zyDfMtrG").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34a6bba3eafd49e6bf5e8facf0faeea7cf500c019cd18cfa625f764213df7b8bd5a3541700f919ae296291c89fcff67de5d3cc0d941dfd342c85e641f6cea2cb56bb2b351f441f46df2039f49e8cd3f01079a908cad599a84079cb8189b218f57806a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b9e1a189ce3273e79eef0d169e15ced5902ca2a4a680fc7f710ef4513ef02ebdd020603020400040400000007030301052209019373d32f7e0c28081730f51d9bb7f4f2c52c488b4e706a133f52a5768fcf4453"
        )
    }

    func testBalanceAccountPolicyUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountPolicyUpdate(nonceAccountAddresses: ["5Fx8Nk98DbUcNUe4izqJkcYwfaMGmKRbXi1A7fVPfzj7"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "370349daceb62cb1ad6f37fbaba12dc72e36367c57b2ee976527609cd8d3f63e".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("DvKqKEBaJ71C5Hw8Yn45NvsYhpXfAYHybBbUa17nHcUm")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4q8ApWsB3rSW2HPFwc1aWmGgcBMfj7tSKBbb5sBGAB6h").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34bb2b351f441f46df2039f49e8cd3f01079a908cad599a84079cb8189b218f57838e70bc45546b0d63742dee544ecc6870f66da475c800d2d793c766b03266cca3f4336251703628ce12796daa20166a1f0da8a9a972775f9f04a256482e2bede06a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea9400000c43a8066d7b0612d9abc74bf23e9bc1230258306dcb561755b8d71c5ad38d5f406a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09bbff5520f20afb88a51a9a0630fb5bc2738f26b68af438c6a1750a68a4c2fc3c6030703030400040400000007020001340000000080b2720000000000b80300000000000074252b614aa502d0fa9eb2aef6eb7b43c25b6db7a61b70ae56b0cde9770fe09b08050105020600761a000000000000000000000000000000000000000000000000000000000000000000000000000000000046834450499b8d2edd17b54df5b3cd21a7e40369f8e3f8f072470cac3a271a7402100e0000000000000200011618435becfcd77198205d44019be2254d324294b97ef819e0c77d3af8b0e446"
        )
    }
    
    func testBalanceAccountAddressWhitelistUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountAddressWhitelistUpdate(nonceAccountAddresses: ["481dDMZGAiATXnLkBw1mEMdsJSwWWg3F2zHEsciaXZ98"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("5XUBQaLXvXGvFArDtYpj3FW1TbNtZ3hP8fkrbzzY3VZJ")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "FuneCbHNcAmaG9gEyisDYiZFLiYTGsuVsFMArXJDR3np").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34dd896d086f2c63e124ed47d94ee7b4932644e826e8280cb345893312aa199bc92e5ed518e5ea088f46ae95e2cb452fc7be22322d0a63e0ef7a820e8aa2593d7759427bbc05d796626ca3c12d0b3553f51e4a0a0582be08acfed19d4d8fa6ca3106a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000007bd238678c7de6666b1fa72f0423be16b875681575a02d9bfb142bed5c64ea35433ce76291f054c3712f68b3fc11a56a6a3f2e5447b3eb7d387ddc739ce419610206030204000404000000070303010522090161b966b30dc8507d2afec35e43873267933214a601565865b80372ad926dca6d"
        )
    }

    func testBalanceAccountAddressWhitelistUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountAddressWhitelistUpdate(nonceAccountAddresses: ["9LGMMPep1WKdiNNwicDvx8JiwgtBKPWhidaSv3rVUNz"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "a9989f27d789b3c2266db5dbd1420e2831cacbb161d6e95bd48323911560fd11".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("Bb2XveQNyXVBJvJUPnsbhRtYqePUi8xbvBaJxk96BKDG")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "4AuJTW9fTnbPUq3LDAehK1CHsENF3x8X9vKnDwCUbTpk").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af3459427bbc05d796626ca3c12d0b3553f51e4a0a0582be08acfed19d4d8fa6ca312f1c6ccaca0b0a0d12b938444f2ec6a9ec82b810394c64237a4651c5a41d4cd902226dd9d2e98d75fab1c2b62b8b007bab361b66ddffaa2362d30e8d8b915e3706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000002827f15215947e7af780bb61613d832c508101f217f8c259828ffc4680fbcde06a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b210000000000000000000000000000000000000000000000000000000000000000000000007bd238678c7de6666b1fa72f0423be16b875681575a02d9bfb142bed5c64ea359d4c59b0c3139035ef4ad8c1c52ed58a7daf2db23646c0704575e009c35fac6f030703030400040400000007020001340000000080b2720000000000b8030000000000007bd238678c7de6666b1fa72f0423be16b875681575a02d9bfb142bed5c64ea35080501050206006d2100000000000000000000000000000000000000000000000000000000000000000000000000000000005560c327edbddd0faa5fe1ed8ff2e8da684374eb45e2cdd67cba4f3bb258fbd50201021b642a192de6a4165d92cf0e3d0c00e6ec86f02d6c71c537a879749da2200b91"
        )
    }

    func testBalanceAccountNameUpdateApprovalRequest() throws {
        let request = getWalletApprovalRequest(getBalanceAccountNameUpdate(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"]))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care"
        )
        XCTAssertEqual(
            try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL").toHexString(),
            "02010408d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af34e6e137f1b3e582e55db0f594a6cb6f05d5a08fc71d7413042921bf24f72e73eb8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd75c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb241006a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea940000006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a02060302040004040000000703030105220901ebdcefe98317428b88db3ec8c27fee8f20b12efaddbe4b6de661f8b74c0b509e"
        )
    }

    func testBalanceAccountNameUpdateInitiationRequest() throws {
        let initiation = MultisigOpInitiation(
            opAccountCreationInfo: getOpAccountCreationInfo(),
            dataAccountCreationInfo: nil,
            initiatorIsApprover: true
        )
        let requestType: SolanaApprovalRequestType = getBalanceAccountNameUpdate(nonceAccountAddresses: ["AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN"])
        let request = getWalletInitiationRequest(requestType, initiation: initiation)
        let pk = try Curve25519.Signing.PrivateKey.init(rawRepresentation: "7707e53ddb688826e19d5d1d651450222c3d6cf73680fd331430278bba237328".data(using: .hexadecimal)!)
        let initiationRequest = StrikeApi.InitiationRequest(
            disposition: .Approve,
            requestID: request.id,
            initiation: initiation,
            requestType: requestType,
            nonces: [StrikeApi.Nonce("9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy")],
            email: "dont care",
            opAccountPrivateKey: pk,
            dataAccountPrivateKey: nil
        )

        XCTAssertEqual(
            try initiationRequest.signableData(approverPublicKey: "Bg38YKHxGQrVRMB254yCKgVjtRapi68H4SD1RCiwWo7b").toHexString(),
            "03010509d5259a75898e5c16f1b0675c496a9f8ee74dd7687f234ba93c0ff09dfee8af345c5c48251d37fc912ce1ac482a5b79e5f904d3202d47287f39edf2e1b6bb24109e94ede101ab5be0734b6500e0fc10b51ca23e89e67391657197fd7b2529c13e8e3dffb3877aaf1f737715f58920c52f4fcec66fab4ac69bb95f0ad69e33bcd706a7d517192c568ee08a845f73d29788cf035c3145b21ab344d8062ea94000003468bd8cddd071cd3bb0a3c50c4b5cab7dfe4ae3328081889ebabd48d8b7c9c006a7d51718c774c928566398691d5eb68b5eb8a39b4b6d5c73555b2100000000000000000000000000000000000000000000000000000000000000000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f7c91fdec5cfa84288fc1e5d1732f0cc5ebba8ba90e1720fc85cf8f328bd1529a030703030400040400000007020001340000000080b2720000000000b80300000000000064424795ac2edb4b21b281bd120d0ababb12d4ae690773f41f5f61027a7add9f080501050206006a1800000000000000000000000000000000000000000000000000000000000000000000000000000000003c69f1851b7318b7f14f04992a80df6054b8bc4f325f24bce0d378d770e870c44e637072f628e09a14c28a2559381705b1674b55541eb62eb6db926704666ac5"
        )
    }

    func testLoginApproval() throws {
        let jwtToken = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJhZG1pbiIsImF1ZCI6IlNvbHIifQ.SWCJDd6B_m7xr_puQH-wgbxvXyJYXH9lTpldOU0eQKc"
        let email = "sample@email.co"
        let name = "Sample User Name"
        let request = getWalletApprovalRequest(getLoginApproval(jwtToken, email: email, name: name))
        let approvalRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [],
            email: "dont care"
        )
        XCTAssertEqual(
            String(decoding: try approvalRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL"), as: UTF8.self),
            jwtToken
        )
    }
    
    func testAcceptVaultInvitation() throws {
        let approvalData = "{\"id\": \"422e3504-4eea-493a-a0dd-64a001115540\", \"walletType\": \"Solana\", \"submitDate\": \"2022-06-21T14:20:38.145+00:00\", \"submitterName\": \"User 1\", \"submitterEmail\": \"authorized1@org1\", \"numberOfDispositionsRequired\": 1, \"numberOfApprovalsReceived\": 0, \"numberOfDeniesReceived\": 0, \"programVersion\": null, \"details\": {\"type\": \"AcceptVaultInvitation\", \"vaultGuid\": \"58e03f93-b9bc-4f22-b485-8e7a0abd8440\", \"vaultName\": \"Test Organization 1\"}, \"vaultName\": \"Test Organization 1\"}\n"

        let request: WalletApprovalRequest = Mock.decodeJsonType(data: approvalData.data(using: .utf8)!)
        let approvalDispositionRequest = StrikeApi.ApprovalDispositionRequest(
            disposition: .Approve,
            requestID: request.id,
            requestType: request.requestType,
            nonces: [],
            email: "dont care"
        )
        switch request.requestType {
        case .acceptVaultInvitation:
            XCTAssertEqual(
                String(decoding: try approvalDispositionRequest.signableData(approverPublicKey: "GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL"), as: UTF8.self),
                "Test Organization 1"
            )
        default:
            XCTFail("should not get here")
        }
        
    }
    
    func testBuildGetMultipleAccountsRequest() throws {
    
        var getMultipleAccountsRequest = StrikeApi.GetMultipleAccountsRequest.init(
            accountKeys: ["GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL", "AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN", "9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy"]
        )

        getMultipleAccountsRequest.id = "B199C55D-F8F0-4AF0-8D4B-B6AF6A3DA0B9"

        XCTAssertEqual(String(decoding: Mock.encodeJsonType(value: getMultipleAccountsRequest), as: UTF8.self), "{\"id\":\"B199C55D-F8F0-4AF0-8D4B-B6AF6A3DA0B9\",\"method\":\"getMultipleAccounts\",\"jsonrpc\":\"2.0\",\"params\":[[\"GYFxPGjuBXYKg1S91zgpVZCLP4guLGRho27bTAkAzjVL\",\"AaFj4THN8CJmDPyJjPuDpsfC5FZys2Wmczust5UfmqeN\",\"9PGftXH39kRKndTxL4hQppfonLMZQpWWWzvaHzYsAcLy\"],{\"encoding\":\"base64\",\"commitment\":\"finalized\"}]}")
       
    }

    func testExtractNonces() throws {
        
        let response = "{\"jsonrpc\":\"2.0\",\"result\":{\"context\":{\"slot\":402},\"value\":[{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNCdJE0k9Ajpn/cEy3TSbbYl5dgEsceAKtAIKa1nvxf6QiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNPowQba3TsNG8RNMBrZK/RZighANP8iUyL4yx85rzJDLiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},{\"data\":[\"AAAAAAEAAADVJZp1iY5cFvGwZ1xJap+O503XaH8jS6k8D/Cd/uivNIQJ8qqFaevM1IJGpCc4YNY67rnrwwyslHS6t+htayrBiBMAAAAAAAA=\",\"base64\"],\"executable\":false,\"lamports\":1447680,\"owner\":\"11111111111111111111111111111111\",\"rentEpoch\":0},]},\"id\":\"5c0c319a-4482-45c3-b9b9-d54975c1c4eb\"}"
        let getAccountInfoResponse: StrikeApi.GetMultipleAccountsResponse = Mock.decodeJsonType(data: response.data(using: .utf8)!)
        XCTAssertEqual(
            [
                StrikeApi.Nonce("3eMXeaEkwY5C6UxB6jsMjRGAsDcozgMCdjbZoowSTXZy"),
                StrikeApi.Nonce("HqdbyB576ggyavQPaodKiS8XNPHBoo95rb75Le7XzXrr"),
                StrikeApi.Nonce("9tRccoR8XEVfP32LEZYtZuR8YFYFbPg9kCKnBicdPQHN")
            ],
            getAccountInfoResponse.nonces
        )
    }
}
