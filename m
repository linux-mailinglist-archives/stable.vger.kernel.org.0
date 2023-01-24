Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8DE67A4B7
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234801AbjAXVPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234770AbjAXVPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E70EA518CC;
        Tue, 24 Jan 2023 13:15:13 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKtPO1006194;
        Tue, 24 Jan 2023 21:14:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=m0k0ASqY/0zUNpAQPw5wE4hs/76lnhfInYn0B1ZoOBU=;
 b=KvPBEII7ic/pDGuoZdBf2IVss8zt/MSHmhoF+EVUugdDoCihZ4jqMnrz1Dudw6Fmv5Rr
 316JirXXbjvt8YPaIQ+wRom821HLffS39oCSNpCCEFR+pbij7HSP2eX7rycI0Ot9i1wb
 WFN6OG96bObc4JKxfMeYOY5H9DnayVcrZVB0+K/lQOST7xqoe29ifGVQQ9bMVub3N7Xu
 790TAsdCG7bGU8y/MkHvjhpa32KSLFFtuwXboA/snAS7KdhjhgVbN9wUaExET1U+C0ei
 6YTdOvmfN2UI/W39iwJ+nk5+9lprgrjNjv8PzUVm+FSTgbLyHlDGYb/qm6SwI5CuH2Pa Iw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n87nt6hqh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:46 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKNa20029346;
        Tue, 24 Jan 2023 21:14:46 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gbu7mm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NsOI5pCAdQ2r3CWnaFtjmZorpbJ0EWzPWNs5E3hctugsW2jg4PhpdtKxqCjG/buGxmSH1tGdW6bPo8XyLRME4vPcPzCIzBfw5/PssyB2WKiYxCZTl/U+1Fugy2X0RCKqB/n/pRbFtwj6rV5iKX1nUBK0k7UhK+8PZpxEu+KEt4ztAsjg+QrGiyuXB9F79cBPOHT2/vIZMu2DDKGJQKrA7RDUajUo/MyVjCUB8nM73mjjWbKEEpySN/P4YEMrD9vnv8ZDyxopdeuMbODvU/pUW5eT+/qNzd98f/+L1Nn6gZJGeN7JHkHQ0n8waq0kVG5sDmSvDMBqO6V1JnMq1WTJtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m0k0ASqY/0zUNpAQPw5wE4hs/76lnhfInYn0B1ZoOBU=;
 b=VdbhyE9SxdSsgWNH64QsT4WC0F7FHjdIjhOPrYRklQ/PMvVHpKpruNF409n/1HvotsRkIw+Bj7AwGI/k2r/jN5tb95Hy6d6gqOiY6uQIm7bz77AeZI0RPXeJFTSAKVl38F5JcENwx39oP7nerNP/x4DlDNrUPaUEBHu/gbxxDoZyuFGD/xSaOoQBc7qMNxlY0KhqJZ7cjQtunhonjEJvlSCYfmyMvOzfKuaIjdxl8kee2guijk5WKYU5J8vua7KmXuCI2oSM3Znqd8a958jJFsjwS3e8s6FcjNteU4kgNMPPP9eD4qHtqsNnSTCs53auTwnwUz3crqNwfk78r3tbag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m0k0ASqY/0zUNpAQPw5wE4hs/76lnhfInYn0B1ZoOBU=;
 b=PoS7lDP10G1Y/9++CMSZDv1Qs+3rnviL5w4wCJ49S27+Lkz06HgP2cWdxUD1BADR95jZ2z67xy3imQnh8ysgBFTZkUW1zPUH9S53BVAqNDcZfQManFvahtgPn3KaBsBD6X29Cmu72f/GzEHw9/v4mE1zB7w8iWjH0yL44ltZlj8=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:44 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:44 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.4 fix build id for arm64 4/6] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Tue, 24 Jan 2023 14:14:21 -0700
Message-Id: <53a8183997789febfbe4e86920b470bc4e59c1f7.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR02CA0138.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::40) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 455c7c69-2bd4-4c17-09b5-08dafe5003b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5E/xxh43n6eJs9rlJbfiwA1hUa6DJ83D5uro9qhZblrdR3s/Ymf+dADwjIyUzbGYkVU8yHcAc4XlhmlWSe/uhIHw0+B3eFl403qIFdJBHuHKEI4MS/Vp1HhVcDzE/cDXecGs44ZI0gJMndujM0wG0X5df6EHaZ5Vtw2DrFrmGQdPB27h9hfSJxCeip6sKHZlZTG5u+1BO+l+/FlpHC6m7/8XMDJPW9IDmsC4R8MfPzB6/GFHjXfz/Uq7ngJBW3Q718n+S+uCv2MHNl0UTqIocLcMqsbcwXVWG1QdVr7osD8oiIzT6ei5ThnEPM1hBUxmsJFAcThMEh9GHU9RlJi3cLhNAngoRyw8F3Uz30DlMnph3/04V2Xc37BTvr5IkbXgnH1d4Zoiyv6T8SFJchmZG3CTfGqG9Om7Y8eM5A34wXpEsesQQbQ4ty9c2lAPSPIoA9oUEtqyRyqvflNQ1ucxNdZ1k+7pex0ktJZKptOy5yKIhA1L6fB43Qezzen4bCDDG919CvbuAS01a6LWD4KpnIFiBDtNCtygApp15xmVy3nZtd8AfCGweGz4TN0FiXXx07rb23PUKEbozNGPGSMn33q6sXnurRNVV/0FxTfyPL/nFR/7nMBLjIRUBnNLt2a9Gm70xI4ygGzeHlhYfBHZlLtPpoPH/Qhgf/qebl5DzFoxUFL420FkyGiPBh1nkmfNjhIqYHvy+t+InEQvfeHR+HNbI7ORHsQAwKEBQfrCXw4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007)(83380400001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eqvSinUXZ2R67ufw7srvdUY8453Z0FKPL1WgA9sy4iPcYu1BY9bMOIeZiOuy?=
 =?us-ascii?Q?rTDBUrXxJ8lnPYyQczvVA+VNwcP7WcStHDF/XOqzSyRP00nWmguyV4d5RR+N?=
 =?us-ascii?Q?x5EQ7ro/TAqACR/OtvmFgKtyvBiO7t/tI1bbD4JXEPj2PGFfVJNK1AO/Q8gz?=
 =?us-ascii?Q?rIUsT9Dgmu7dtQ6yovEF097EF8JxADnfMSwCTY2SfEwhFaT2n/OmtpZMRQY1?=
 =?us-ascii?Q?06CzMRkkG8gMW1+n+7khVY+4A6BqGhKlZf9Wj0lypvaSmoQyoEQVSCWq7fjH?=
 =?us-ascii?Q?i5R9VtBiHCT/Xp5BF695IVz9SA9py5WPbxlTwkGJqmNeiBwsyTP5eKVNMNLx?=
 =?us-ascii?Q?6RYolrPwwduMTvw3zaiOhqyBIkYZAA9i4aQ5vtjjgC3qK9fukluwT2zkWTFc?=
 =?us-ascii?Q?eYV5MUrSEhrn5Kyd3IPaljqA2ok3z9/+SYn9PydLmh0etbXyOOtAWe1Qmbah?=
 =?us-ascii?Q?zATe9kL7J1JYblVh0yl7UftWyzUqkrsc2ZPbIx9ZP7950EHtRGq4qjA3RnAk?=
 =?us-ascii?Q?L7Cd7GMejGLYdXLCPA6BVMLZSyIWCJ0CKDQ01Gsa2LLVeQSzVfimx32H43VW?=
 =?us-ascii?Q?Sd2eMitOUix2n6F3AuwwGTHqxNe1GaCfGlyFqdxnVFV/6lEw/l3Q+e8IL1jx?=
 =?us-ascii?Q?LZjb2mcLsiiy2NzHRpVzGir5FlPeS3cKJ03/ErLL4rjO1wfQ/ACUgNoSlCOi?=
 =?us-ascii?Q?TwSI0WNvNsKWeJWLcIUqFP5nIeppD2WdqEt+72KHIYSQIanjdQ/l4WMUdB6Z?=
 =?us-ascii?Q?u7MhPU02MJGI91MTLNCud82xGsBwy1j5EwlaBO2zxLv5R+vzH/eq8sBVYkZT?=
 =?us-ascii?Q?PaOD1nUE7YkgLzgmvmP6bPthzG3nrzRatlLctK7FGEhsGa1SJ09+yArL5x4i?=
 =?us-ascii?Q?VDXqF+AMnFthUjxl7G9VLPRODL2qopeltueA6jWYqPUDHbmUctaGVc+aGcAo?=
 =?us-ascii?Q?ZuH/ZUaXmTnvJD1mjqAo2qRCAIDMLT7ILDY/AfzbkWesth2hRt60fxXUZOQV?=
 =?us-ascii?Q?lbuJTnM6/40gfSd2LT5a/QKYIhPV8VAWMbwzZ9hntudSWtZ2FNRq54srTjmT?=
 =?us-ascii?Q?eKkIH9YTD/0CXWDo1x7Bcz9iRTaO3OfWRXbOrQyhNcNtEMi1Sde932EDDKcN?=
 =?us-ascii?Q?Dfj31FAkd5PeCH7rCMUKGc2AREj9NgX6fqll5HWzH5RH4qaSde34QVVvGFIO?=
 =?us-ascii?Q?yzNNVGLw4n++JkktNCkayfgp1Y+y8gvQRlMNQObcvwxG2jIalOeCRKRtXOCO?=
 =?us-ascii?Q?+Db0cC7BuC8tjsVKJwrAVVMrA0cJtBJxA0GqiulJBpzD7s+0uKa0OPuHkkse?=
 =?us-ascii?Q?F8fUem8wYarUcQNTmaBkohhHoQerwoEK+ubX43HMR7rKLE/OufntRRjMDqaR?=
 =?us-ascii?Q?1hvYs9GOmZClwba3XkEO43eFA5OmkF1QGSMJ4q1thn6TSFqomoAXXiZUuHht?=
 =?us-ascii?Q?+Q9zvTTi32SAbaSI5cko1gbtjVAOGQnGYsTU9XO+07QP8krl9xwRTq4oqmQk?=
 =?us-ascii?Q?WgCA+J8mOwVUTRvVDPlXwgU7515Sj26TX0Y7n2fTqdM5yzSOVwNY0d/e90je?=
 =?us-ascii?Q?Az3EJ1E2QYEg95GpQLnSJPodk1aCHUjoVpGTJcdWSEtbPUjc1ZWM27YeMfUO?=
 =?us-ascii?Q?tc7d6kSr+i6y5gGY9uIu1DM=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?JDQHZHDhV5VQO5J4fX4MF7C76yFopXX4J/E9AO8QluJuBdtxdsfULgRB47u3?=
 =?us-ascii?Q?6aMmvw+erl2KikT+pB17MEBXFFrnu9K85zckPtqxq1TYC1Xe3EL3nrcM6FIB?=
 =?us-ascii?Q?OqkcjGb6bAIPFBe+io4rsd9RKy8vSRq4TuviB6m1fcTAx/Z0UQizzdhM4/81?=
 =?us-ascii?Q?n4FJRx2CYBf4AZ9KVwSl9hbOb6W6z4S/yBMFG6652uFJg1hYtBLvsXAVc6Q+?=
 =?us-ascii?Q?Vcu7gSHhv27JG/7s0DLRAUaeb4GzV66LglYJ+DB8zIIS9HZVndW+7L+V4BoW?=
 =?us-ascii?Q?tb0PW0hUCncnAIIYy8OYqaueP9K5OmOthKlyfv3okQAasMcKwJG+oriLWK9g?=
 =?us-ascii?Q?F1hEgkdZ/5FD6mVwec5nSXaW/j5Pt7sbUfJTAKfmc/7/z+8iSBN81A1d32xM?=
 =?us-ascii?Q?rIQ7A06B3TdAxpv38a6Py8+QnJsrs+Vta34yqv+hSDGaFlZinkk2FWVodRDp?=
 =?us-ascii?Q?34V3Nv1njlr1N0a27a/SDXGeaLIhp5hDT28HOkB/c8YsLBPpePYVtCr3esyw?=
 =?us-ascii?Q?GLiwcSWQy90KnNlqJESZFDzC/bgtomr54ZoYwl5boyALTnlock+S61So4Sl8?=
 =?us-ascii?Q?s0+JOlAxuIW29J0wJ4afuUCHVNCk/elmi0QDdf9rUauXFp8ybhoEey4yBmO0?=
 =?us-ascii?Q?CTwh5Kfs9C7srVUikG7bbmBszcOqHp87nshgl8ttxofHH3AunHSdgbJg2TPw?=
 =?us-ascii?Q?6Oc6JuYlcuEpr2aOXDy+/Y3Ql8L+jn4St8gNeZfYQNYX0BmfNa63VCRV1jZl?=
 =?us-ascii?Q?h6YXeowX6oO493hdqIwZhMnetKkhjYgntKsrGVH+uy8qerHGLXA0WZXD5e4M?=
 =?us-ascii?Q?136c8noalvr5OIKVWAWOeCKHkyC92Bk00+pzq1Pnb6lfxUnTkr9VJ5lS/PIt?=
 =?us-ascii?Q?SFcungb+CAmMr67tMRRAp8jprsC7ubF1HHeToT7+v9mVykiUAwuBPBHJOqS/?=
 =?us-ascii?Q?Q4TgHasZlMeIgrIxbuyetGMr2Falmb18/gU9KBtdtsuwwEH+eiVr1yoJLFWH?=
 =?us-ascii?Q?oEtTAAQQ1/LCscbo45b9PgeV8w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 455c7c69-2bd4-4c17-09b5-08dafe5003b7
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:44.2481
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GS0JoSXxrLM9yhO6g3wn/arysguthKwHAxvCfH1RKgo/027QUYWRj3Y3f1IMDXVgms3LJTZN5cnQPDSc/SCBlw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240196
X-Proofpoint-ORIG-GUID: 0QvMZEbV6gwcYBbeZXeIjtbB4MDst0U_
X-Proofpoint-GUID: 0QvMZEbV6gwcYBbeZXeIjtbB4MDst0U_
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

commit 07b050f9290ee012a407a0f64151db902a1520f5 upstream.

Relocatable kernels must not discard relocations, they need to be
processed at runtime. As such they are included for CONFIG_RELOCATABLE
builds in the powerpc linker script (line 340).

However they are also unconditionally discarded later in the
script (line 414). Previously that worked because the earlier inclusion
superseded the discard.

However commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and
riscv") introduced an earlier use of DISCARD as part of the RO_DATA
macro (line 137). With binutils < 2.36 that causes the DISCARD
directives later in the script to be applied earlier, causing .rela* to
actually be discarded at link time, leading to build warnings and a
kernel that doesn't boot:

  ld: warning: discarding dynamic section .rela.init.rodata

Fix it by conditionally discarding .rela* only when CONFIG_RELOCATABLE
is disabled.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>

Link: https://lore.kernel.org/r/20230105132349.384666-2-mpe@ellerman.id.au
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/powerpc/kernel/vmlinux.lds.S | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 4d5e1662a0ba..46dfb3701c6e 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -395,9 +395,12 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(*.EMB.apuinfo)
-		*(.glink .iplt .plt .rela* .comment)
+		*(.glink .iplt .plt .comment)
 		*(.gnu.version*)
 		*(.gnu.attributes)
 		*(.eh_frame)
+#ifndef CONFIG_RELOCATABLE
+		*(.rela*)
+#endif
 	}
 }
-- 
2.39.1

