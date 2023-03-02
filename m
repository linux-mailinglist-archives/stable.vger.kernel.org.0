Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7829B6A7956
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjCBCIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:08:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229820AbjCBCIR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:08:17 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE998231F2
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:08:16 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321NAto8028228;
        Thu, 2 Mar 2023 02:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=EsNvMjVsT1VkRY2JLGWVwaUq3JWfMIlNI8B+aJaNirs=;
 b=UvCLvzTRVYXz8sEuedXT+5Rm/dOovh1EYeok9Ov9MkAbGQOENy1DuJaakbiihTzAFdDO
 hn+RSKCsrHfdnbQ5RDBxGN85Tx7a4NnMVpTRp9nAjWm/g/2UbwsPQ2u7ez6UAo4J3OdC
 Uf/imbNXmJ6r9fqhkateajQle9tBqzEuSUZz/B5fwSUoToA+Or2zwCtEulBqqllJpg6K
 mrxnnK0TxOU/tyE38z4TMlw+oHBhkh95EJ18hBcYYcH0s+EdihjoQ0x4vKNTY68kc66g
 5aoSqyrpUSuHSPiv6YSr3qzUifX9P8AbnXL4o5ncoAnrGE11F5IdrT66xpoJ0MTfqEoZ Gg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyb72jbnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:36 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221eJoR033045;
        Thu, 2 Mar 2023 02:07:35 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9c9g1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:07:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gw06a9ltdk1rreeeWDRQmoyGRep8lTprUZrtSPrJk70HVWcqqGjcj20KOmD3vFVWoJhZMn2JX6wJPeybby6mQlJyg27Zc3VbUxK45EBblBARjRdMkr8Py/GFrw5bzE3zdVsX03rwpNKtaw9pmXTgK8bm3epR7dBSM73BhwYRz8axQ0mc+17zAtyZYjdW0d4zlc71OznuROJGRh4dHaKakae6k+o2ftWCOOit/m68Rtkm7GHfegBDSPpF0t6p75jciHfRF0EsTPaXCE7MwdvyVMGg7WTAxCBhLU6+dP29ik5VFxcOIsnbIhd0A+3j8Z4UJyUFpGSCalOqklZzSLevCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EsNvMjVsT1VkRY2JLGWVwaUq3JWfMIlNI8B+aJaNirs=;
 b=ZokK8pi2WegzsWDvhT+PSHVxVfwCoBI3pFTX41wmwbH7E5gDLKWYtmU1pp3sLlwmgcd8d8cGt6JsPj4CdfOyggIYGZvuC3kxoNJn3VQc2qDaOt2GwY3MdUNJSb1e5licuaTGYjKvnmJ6tjL0PE7EZ7MuFydBzhmO8c3F67DQHCk+TjROoPmK4EALi+WmfxGv1DQy3n2WlYSPNjhZlobZCmGD7qPgfpFucRkeHtocKuK/sTdr62BikSRsULX3beLFx5mdFh/d34+YHx2mTZ/pB974SFRA6kJ+LJIK3DRXemkgD1R+VIJlVH5r+tEdeUysG+sztp5aY2zMMB4I4JA5cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EsNvMjVsT1VkRY2JLGWVwaUq3JWfMIlNI8B+aJaNirs=;
 b=aiV0CXMi+vCTaxSxbo3uASRGdDtvxoNN1vLy0ecJkGMucaHYEPE3sJjAj5arVsRopj6zJSofVR0osiy0ERZFpC29zd/EI3QXuDw99CQnFiWYoPum1VZlfGxlgrcHq7/axRAG2tIGaxxSWnKHHlCdKjgZwm//I/6uKaytIUC7JiA=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DM6PR10MB4284.namprd10.prod.outlook.com (2603:10b6:5:21f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.19; Thu, 2 Mar
 2023 02:07:32 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:07:32 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Dennis Gilmore <dennis@ausil.us>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 v3 6/6] sh: define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:07:04 -0700
Message-Id: <20230210-tsaeger-upstream-linux-stable-5-4-v3-6-122fc5440d4c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
References: <20230210-tsaeger-upstream-linux-stable-5-4-v3-0-122fc5440d4c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR16CA0005.namprd16.prod.outlook.com
 (2603:10b6:208:134::18) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DM6PR10MB4284:EE_
X-MS-Office365-Filtering-Correlation-Id: 741e81f7-8bcb-4aa7-f9a4-08db1ac2e1d7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RVYRNIjQR3s1766HNumZjxW3X3oA4Jt3Knd9tbRJ2cG0fJKqQr7be3NWbi3/6xxX1S6WBrVwlfAQ8S4KyNQo7RNMtD/33EWUflCFlENHOFKOombblpAbfwBiYY+d9vIROZTSeEBklK+Ecd00aR1kdu3rbed4OmSLyB0QUir0Rc1mWp+tEmrYmzxKHTMhfXXoLofMlUrQwuR7ZVU8N0Ee5NWqmG4WBb4UIEkiZJLBNN99jwO+pIqQov0HQnDMWg3dQP212uoxYou6F07igCbnirxF91mm84Nau9yPpo2IuaTKoFhGtXTStTGMR1+XCz0lV3u2KtgOrssJznQZRW5egfTbjxrtqg3RRZw9jj4gvhZvWdyo69/374aY7D75VpM+NB+M+mE6ba243fIL+7zbNvZFMobq/z/eLsZmA8aKlt5KiRbW08gehYTZxBHEocX9HCTCWPdn9LNdy90HSJTvnamDDRNxwgSmOf93Fpo9Kh6BfcATaU5eqUUxLUIZZ/wEX9h7qHaRHYLzkviGnWSHaVG4BoKR343/w2JrDMoGeJgfst81mS6Ngsyw9W53zlIRoAQMimbXZ8/M4n0qpGkt3HoFUvdaBTTdq3XvZa0iQYdaYHWHRMUi/t7wbdNiT5PQ93djH4K5iFLelmAo6DYQVywpSsEBlE/NX0l/b5IH5Ug=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(66476007)(66556008)(8676002)(8936002)(7416002)(66946007)(316002)(54906003)(38100700002)(966005)(36756003)(2906002)(6486002)(6512007)(86362001)(6506007)(26005)(186003)(6666004)(478600001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHJaenZBbHpVRVZVemJQb01jb1BEYVEydFB0MGxpSXNTWDgrZGZ4YTZ5cFMx?=
 =?utf-8?B?Y01laVpQdDRqYTlrTWFtZkFnZWpDSndVaUpUdmVSYk9DRStBMkZuQnVOT04r?=
 =?utf-8?B?Q2Z1L1MrZCt0QW1XTGNIWjkzd0tTMW5CNEZpeWlCNkxYQ1M3dXI4QVhFNkJR?=
 =?utf-8?B?M1ZrRER6OGFmK2ZNbXBMYVVjTnpScG5Qb0VZYTlYSTlOT2wvaUtwNzhzUDJV?=
 =?utf-8?B?MzZTZ1dBRUJqREhmVk1aQkF5SWpjL29iazUvVk84K3FCZmh3aTdoOUpwMHJ5?=
 =?utf-8?B?ZXc5MTh0MDR2cGhDcStrb1ZFTk1jYXM1MTV1eUVpVm9NQ3p2NnNXcTB1QmNO?=
 =?utf-8?B?SS9sWlhNM29pajBuWnR4alZqcEh6dS91c0pYOWJha0g3dWxKc0lvQTRBdDdL?=
 =?utf-8?B?ZWNUK3NVbEwyMmZ4V21ISkE0U3NSMGhCNDVSUW8rUEJGK080RmF0N3ZSRytI?=
 =?utf-8?B?RVNSRWQvcmFqYXRxaktPcE41aDh1cU5SSk5qNjg0d1dLdXc3UVFPK2Y1ZU5t?=
 =?utf-8?B?emhuaGFhVkZuMmdFV1NiRERYQ3FzUXk2QkJyRXFvWDlOZU1vaVJ4MzNoSEpm?=
 =?utf-8?B?bW04dGFkR0V0UERRMytkaWtmZXBUWk1GRE1qdzlyU0ljWmpvdGJPaS9qRVl5?=
 =?utf-8?B?V0t1YkI1Z0FwQnpSRm5tOTJqdlh1NDhQZFBqNThDbFI5YWYrVkFjTFBOdlAx?=
 =?utf-8?B?czVYdXdFVTlCU2ROVWtVWEt0MlVqRGhvSVdSTU41Q2YzUzdUaVNtS3VOc016?=
 =?utf-8?B?M3N5UHY5dEtvZWdKSGdaeHdzU01tZjlHRWRQU1ZXYVp5OHBnOHFnUU9Ia010?=
 =?utf-8?B?dDkwSG5DZzYvdTVwVHFJZ2xwajdiZXlsRFFJRUdLaU9SZkhDc1o4bHg2RU0y?=
 =?utf-8?B?cGljSzRWSVBNa3NyMVM1NWI1TVkzZmFrdXc2bG1EblJDVXFzZGl1VnE0YS9v?=
 =?utf-8?B?dnYxZEpKZE15K1g2NjVqSU9INVUzNG1NMHREbmxyUzkwZDZNOGsrRE44ZE9F?=
 =?utf-8?B?N0Fab3grY0E0WFJCeENRdjViUWVGZlBRZVZjQlZ4MmJpMDBhVkhRT1E2djRa?=
 =?utf-8?B?R2pHeWN3MmRVZ0IrWDhnT3VuTjJkVDBtcWg5MWxYdWRBdkRBMkRIa2Z3T012?=
 =?utf-8?B?Q3dRRUJham16V0s2bEc4bERZeis5WlNNODV6eFNSSDFmVWI2TkxOM2wvTjJ0?=
 =?utf-8?B?UjVOVFl4ZTU0N0RMQ2dZd0NYc3QyZkxKVzQ4ZStJa215TUhlNm9KcUhyOHR0?=
 =?utf-8?B?djZWRGJJMnBiem1UbWtKWGtrUWtmbnp3R3ArNU5zS0o5aE42cFlRVzh4ZGlh?=
 =?utf-8?B?aEYzVi9NZ3MvZ1l4UUliVlA1R09RaU9PYXpUdHRWaXcvVkNGaHJpNWtXSVhD?=
 =?utf-8?B?SzRraUJMTGgwcUk2VVcrWXBVdDlrMzNKb2VNei9CbjhacWo0R1FNVyt2UUR1?=
 =?utf-8?B?OXVwaWxuMHlXNHo1c2ZzWDU4SmtNbXNNaDdZek9LajJJc2ZMV2U5YldrUXZN?=
 =?utf-8?B?dmg0THNhQy9LaWxWVlQxYmtUSWNMd3lMMmpkeWZaQXhrZ3NhZEtweGdaVVp1?=
 =?utf-8?B?K3hSWkk3ckhTU1BHT3RQeStuMFV2WW9hSnNwWU1rdnh6NURQcG9ieDN5ZHlk?=
 =?utf-8?B?TGR1dEVyWUVpNG5RMWpzQzRMOUZIK0lLczhDS3g3YnMza1BZT25QZXgwc1BZ?=
 =?utf-8?B?b0tKcU4reTZPYWx0SWx6Wm1vbTRQRW9NK3JzbHZCY1NzTU1VdWhxbkJOSWwx?=
 =?utf-8?B?Vy9oMDJWK1pmc2lpWnlFODByTnl5MkpRU1dqV3FwVWI1WmMrd1k4U1Y3S01n?=
 =?utf-8?B?enZST3laRmpBbFcxenJMVEtDTjR4UlVZYWxaVUVJNTh6MG9NUXJpUzlEbThr?=
 =?utf-8?B?NnhIZ28zd2phWWVWRjdrb2w2ZFJTZVFlU3ErVFcrRTNQcXhad0VIY29SWHQ4?=
 =?utf-8?B?MzVFTlVrS1Mvb0haYzJ2dENxUGQvazdrNGMybHBmSHk3Q01YcnFZRkRySURt?=
 =?utf-8?B?blNOUXhFYnpQTjJwRWVqd0JRRUlIM0E1RG41MEQ0NGE2U0lZblJnbjZ2cS85?=
 =?utf-8?B?T0VnM21PYUpDeGNMaGFQZkpaSUQyaENlWTEzMmxDQmE3dzhWQ0JHUXZLcGJG?=
 =?utf-8?B?Tlh3QzUzUjRKMVBtQlpSNElFTGNmaFpVc3BVYjM4bVVvZjRNNHgvZ3BIMkpz?=
 =?utf-8?B?dXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UUZiSUVNUldkT1dLbHVqd1RWTy9DQzFiSE9iTkxQUkEyTXhVV3VPajN6Tkwy?=
 =?utf-8?B?N2R0R1FybTZMV3FVcHJWSjdENTBsb1lXamVtV2VRY3JrT0w2czJlSVFMWS9I?=
 =?utf-8?B?UVN1ZnB5eTd0d05VZ05mcjdNNjhaL1dzdUx2OTBNK2pjQVhsY3k5SFNySWhH?=
 =?utf-8?B?ZFNVRjN0Q01QbllMUFF0TGEzOW85aXpDQVNJOUpRZktNNnFJT21mV0NHL0hX?=
 =?utf-8?B?dEJQNHVHUGZJQ2xJMGZabnBraW5kd1VLL1Jtc2xHeXAwY01uSEtiQkFvMTQz?=
 =?utf-8?B?ZG1CdnB1RGx0N2NTVXJQWllwVkRLYjIvSWNCQndOZng0YXQxNXVzSHlHN3ZK?=
 =?utf-8?B?a09tblQrcGVvKzd2TlIvenlXVzFhVkxCR0o0bXJsci9aRURoUTZKbVB1dzJ6?=
 =?utf-8?B?SFFWNGZoUFJIeE1uWmRPTDNKL2xRZlh2MXBzTXM3VzJxeVpGckxSaHJvNnZt?=
 =?utf-8?B?SlJGeTZvTGtuQmIyQlAxU3BaNXNGSlZLREVuUXpJUjhsS2t6QU9tSUVHSzhC?=
 =?utf-8?B?Tlh3UjYvcjhxdkdiOXlrTUxNWFdqNmhFYk5QdEZ2REZxTDN4NTROL2QvdzE4?=
 =?utf-8?B?TVFKVjVESDlNVHVRSzFLNWNCZmEvOWxkZGlXZmtubUc2MTc3K29SWEpiVDAv?=
 =?utf-8?B?OWhTVkdTR21tNXM2SmlBV0pQeWs1U1JYQnJZRVhXbDhCUEVldGF0cFFQcUpy?=
 =?utf-8?B?ZnVkRGMxVVdnOCt6OG1mOG5OYlhFbnhGUEVRK2ZzSStkKzFUWTBzZmpkMERV?=
 =?utf-8?B?QXc0NzJWRElaZG55WnFBSzVEaDVTL2xyWUFXUVQ4UUlPWlN4ZWlhajV5WUxE?=
 =?utf-8?B?dDFPOUVocTZxM2tCTWEvdFgveU9GamdVWVliVEI2ZFlHK1dVY0JEemVpcUtY?=
 =?utf-8?B?ckNrR1V5NHdnUFdabEFRd2FqdlVkVDRvYXJqV2RIY2gyT3ArRG9iMXIrbHQr?=
 =?utf-8?B?Vk01Yi93UnlLaXpOWlVrYXcvTVNVZEdIbW5NZUZObnNkcWJha2J2YkJFZXVt?=
 =?utf-8?B?V3Y3OTA4bW5lMml4VDFWdmh0NTJYdEJEZHl3bE5EL0FCdGVWNC85d1p6SEJL?=
 =?utf-8?B?cXFONzhMRURhQVRHVk82clMyYlZtd2U4a3ozNmp1cytnUjRWV1FMbG1IajdH?=
 =?utf-8?B?WU5vVUVPQ1owUUhhbGplZlhvR2JoclpKWlVmSFc0YWFDa2xlRTZzZzBvQTNY?=
 =?utf-8?B?SUdvaHQ5eEIyeVJlTnpFbERBd3V6OTZHUENDQUg4akRwRXJYM0ZVWWxqdkFN?=
 =?utf-8?B?MlVOeXUxajZhd2Qwd1NDYTVoSkF1RFZBZzlNRFZZTTdiVEVvdFAwNG9pZUZJ?=
 =?utf-8?B?dXo4V2xVZ2ZHdDRWL0hKSXhQMUNLckJvZC9GRDJOY3c4VDYrN3QxM0FoUTNH?=
 =?utf-8?B?M2FUd0dGV0lKd0k4UDk2OVFwazA3OWwxakFBSEJOL1JhTnMzZGgyeTBkWWNF?=
 =?utf-8?B?bHBMSWliZWRRdlR5STRzUFVtQXpLbEdHUGV0NXJTcCtPZG95dTNPQm9xc2sz?=
 =?utf-8?B?TnVmY29BZGZZYlhjM3RYNE9aWmlFZmRscnhwakhOcmlncW5ldUxZM3kvME9I?=
 =?utf-8?B?WHJjZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 741e81f7-8bcb-4aa7-f9a4-08db1ac2e1d7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:07:32.0406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GZuD0MEEDJfSUOQGD074LwdbnpiGJuFrOz4kzHgIAuplnQnLtcZ9jCq7KpcOH8aZAqSxSxsVFq/kt56Vcbu9+g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4284
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: UO_uZhF0sEg0kyzn6th-ZiBYcExm9lj8
X-Proofpoint-GUID: UO_uZhF0sEg0kyzn6th-ZiBYcExm9lj8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1c551bebf928889e7a8fef7415b44f9a64975f4 upstream.

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Link: https://lkml.kernel.org/r/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com
Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dennis Gilmore <dennis@ausil.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 77a59d8c6b4d..ec3bae172b20 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -10,6 +10,7 @@ OUTPUT_ARCH(sh:sh5)
 #define LOAD_OFFSET	0
 OUTPUT_ARCH(sh)
 #endif
+#define RUNTIME_DISCARD_EXIT
 
 #include <asm/thread_info.h>
 #include <asm/cache.h>

-- 
2.39.2

