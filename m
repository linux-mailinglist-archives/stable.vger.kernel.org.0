Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E50C67A4AC
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234708AbjAXVPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbjAXVPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:05 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FBD45225;
        Tue, 24 Jan 2023 13:15:04 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKuaw3018687;
        Tue, 24 Jan 2023 21:14:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=1OLMPfywqWiuxO9AxppMUi0bW4XREoi2eA0/fAjtbuA=;
 b=fmeX/7+wLyjsKmrZxPr/DJbyplMDtw6FtUROgzD2Y15wjrbZPAl2LMk961IAizwiPu76
 izIzVxZ+Lv9ZwB/RMPoNd9RTtjjJ3VXG4J3wj9KQoG9EisCLk0+5jKa5QqcKWpDXICQ7
 ExiflG+AH1bj7/TTfuPuIE7vSXRq1w/qqruS77TxajhFx9BMiaj98nMOffsjKaiJ8p7I
 WO+TBJmyZAg0ScFK14lL/zVSJL6lt7HnlgdlaVg6Oe7Oc0fWeA3W1EcRVCmAOZ37HsXr
 PMSN00Y1kDfHufowRMRf0/xUDbmfBtP79Rsee+XoNiKv0YTSoc7rKBP7FwiT2cAgXi2M EQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n883c6jtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:36 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKfjbQ021074;
        Tue, 24 Jan 2023 21:14:36 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gcbej0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MMDGISx/MNcwPLwpTAC9anFnGdKLFRHeYaxNkUpr/SP8P1yiEXtr5ipivpIU9le9YnhNGVz8++ghkWTZD/9n+cmQjP3ci1RAgY6AL9996NoMcGXE5a7Kt3P3rwZ8fYtT90jNMkMr/v3PkX2O2G6R4wAH227XGfeWsJAFLXorqIzrT2Fm1HSG/6Tj6DbZo6Sr3M12HzyjLZfq3YUVhY4GbEM3iIi64GNtRuidaxgchJ5H4Cfk7+2UTzcO8zGBW387Chap1zTQLiM3L4MfGSqLe4UCUgLwMiwQaFOlm00WjPPvxeNttQClqCxZWvJMJUrEAgKh5yJOVZRlfhT2DA/EFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1OLMPfywqWiuxO9AxppMUi0bW4XREoi2eA0/fAjtbuA=;
 b=YZ20SLiWTGPxJ+H0L7/Z5F7rTQAVVubBz6whi+dMKahSci8dAT7QhwxprpsFsgLV8TzYDVW8eyuBkwHAbUuCkurv3k9er8sXFcvuN1dSdrrQwZfKpgG3rrbpTNDF3LlxBSQhw0x0e9eGiLXI/tMTgqEF9MnkslI5WtZq6dari3NxdNR+JTVa9XHOnfA2yTA17WcPhRTcrHzd91DihSvxAOz3ZgUY+g6nqtBxLg/T38CiewnyvImOKvZf95mB7Ig2jpZ/G3uhlqQ2wtYDTw7fFZf7ZgXg1gGoRYEpTAlu68J5wU+dC2CAT5Qjylflou6Vua++ETmJe7K/mRiy5H0DIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1OLMPfywqWiuxO9AxppMUi0bW4XREoi2eA0/fAjtbuA=;
 b=DNk+lhpx2UHdCMgQhyKvPO+vupgFiC9+fsZ5dk+oNl+whKy9MdgrU/jN2ZyvopwtCSh0rpO/0ngrBWZVsGC209qHKoOXZAUfy8ePXK0vCQrfIpIO8+3g0UTLqw6sig1F/HcidX/E43Ir7L9ZJTWEIL3OfQj/+jBEmFSYmI+EaKI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:34 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:34 +0000
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
Subject: [PATCH 5.4 fix build id for arm64 1/6] x86, vmlinux.lds: Add RUNTIME_DISCARD_EXIT to generic DISCARDS
Date:   Tue, 24 Jan 2023 14:14:18 -0700
Message-Id: <92564d1254985c3983353204bf56fa6c5f507d33.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0108.namprd05.prod.outlook.com
 (2603:10b6:8:56::27) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 759b3e3e-bacc-445a-d051-08dafe4ffdab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L2frSY4ZXW50MKo0zEsFaNO1axlpY46+RU1MyKeWgadwEQZSw02lBosava7bOKv/cNpZPR3RHNSORVYpBfMnGS0tazqA0D7fBXMvtwbvPIvgTcdNSmKsJzvcclsabt6fKXigx3XbpuMAPxqL8qroIQ6UZ8aA0U4rap7IMaUGNwg29YsYlsKJg8VrV4ET/gKN5zU5GegE4sB+FdzYaAg4BIknhx+ydZpwDqVmzOfRLcFY7ORzeeH9wCB46VGUaAj8uYeBucFcG7qdhgUfOpp49P2z6W3wSZfghJtioqp+MR/jG4Kdq9Was+ke8IK1wZ1Snp+Er01OSewNPwy1vfgur4EADxdMrHlX2KTy5rTDmxYtzqETBidjT4n8h46wI0VYnk9fXwsTHUJoP5dnGQeO7jynet74l2E2J4Kn6ogGfQ8NmugXVfZP5TMclEJLSPRRsWQ0z+sfPJ5hUn+CoBmZJggLbCrvMHGvs+5gXiTbc+7ezIyYlXaqW1AKlHucEv6aMAk0pjrLG6RNwnC6SNWwHtNHgEjYyJtO/J/kpkZUjwQ2qM2InPwjePSBe0AXJFiE0q2/xuqF53lTX3vGscYi2xAekpISk9ECmTqJIsVOdgkhk21PXstZmQ6k2AVBc0Vrig6U6TXUFdi91oGCr98Z+9miy20rxk0r7dlrlEjgrgv4R5Tq7HCbf0q2KSSnxLJaeqoilnhNoJh3YB6I6yF3nkfHzOat7bwOTAAXB6OLi1c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007)(83380400001)(41533002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ltmGQoO74FZd4Wq0+GEmTP/+h6Sg+JS6uB8KSh+UK2F5Vqb8HYoFClOVEj60?=
 =?us-ascii?Q?mYD4jDAakgR1uL8ZE4rdE0qQ4MYqDz1qrbM+Cp0T7c3SgIClSQhYZBeUP+ZP?=
 =?us-ascii?Q?Qv/ljF9gKxYbILwfBcbqb4zmTGPMdKTIuWlyofHFt6aRzAFqcrWShKEkFBGj?=
 =?us-ascii?Q?s/1gJvwCHPXooMF7Q3CKe2uyBCKMBQ+in6VZ00i5L3xrdYUHw6sbmpSIUodp?=
 =?us-ascii?Q?HT2A+YCqO8J0yCKZsrNXQdNZZRL8HmIOzcfQRGHN70eFKLYxNagbb5p/nTsl?=
 =?us-ascii?Q?wdFczcuvhyPAIauTPOXcHNRI0gQ5HiSQJyHAm919CweylHvI2CoBEnR3wvzG?=
 =?us-ascii?Q?e/QUzxWym0MUfqB9f8pX5y9KD+4kR1YIG9WbSmAo5T2s/KSZhcYt/voUgOBa?=
 =?us-ascii?Q?KHKHXVcbq5jnJtUrffr9FXdVjdhT9Gc5+OlC7ucBQXDMVVzp5nlfzAEd2p/g?=
 =?us-ascii?Q?lUN+cNZoQcEODdCweP1GfA/MylGERNe0orie4IG8ng7IsmQpFmnydAWGo3ld?=
 =?us-ascii?Q?bJypNVomIwCRgJVSM6w3HTI1KjnAoAklj1/upXPbPMImwQ8z/0HUFbX+TqOm?=
 =?us-ascii?Q?n2tfN1Jn415pTLVmxK483B36IYbrpwvhdtIF+P8VEuy2EcJMqWHb8JQxDpKz?=
 =?us-ascii?Q?JYabcQ30BTLb/Tw1c9hzBYDD+OzSDOt5ZP6pSTXiFzbvDgK8GnLHzzhsb8w8?=
 =?us-ascii?Q?++RcL/TQnVmnXI/owDu+SP93jTPyMc6i+x8dQuU1tpYOpIBkEDb5w8DvMyXc?=
 =?us-ascii?Q?CAI8SJcpXXMyjv7PhGmf66I73XNbqneGkNkUDoIC9XUGpkYu0oKw7jWF+Yn/?=
 =?us-ascii?Q?FoM2c9lreF3GEMLK+RtlOP7gPanUhjvKK4UgK/lnpkhHLWOJJSAiaqwxAM5L?=
 =?us-ascii?Q?TWJXqDVIBnA6dB1B62xj9x2QKo8IaSuySJeVxHMtxK6J1ou04tGaQPm8fGQZ?=
 =?us-ascii?Q?se4Vgant0T4ZVnOYTvp52a+GbOZPML5fP5p0CtlhmZ94tttdSx1uc4ker5OX?=
 =?us-ascii?Q?Mbr7VaGYQBcBq1qO1ZPWmJRLfjXWJuTy4pnByIu/envCui58/A1HQRTrCqwm?=
 =?us-ascii?Q?3DzXl2UycMZ2S9j9nveQRY2GZuKD0215ANoBr/Kto7qgq44ErU68jFtjQp0g?=
 =?us-ascii?Q?DrCFwQQDz2VVVzSbhuHGu1hPnfm5f7Qux7JAVexfwcf8h5On8o+13aN2UbgN?=
 =?us-ascii?Q?NMbzSbkN2+jdnWxF0x6tiIxJYRN9LDoI9ygu2pnFM2v4RhVqPYSuQptqRn4W?=
 =?us-ascii?Q?nSxBB1ejv0bD+Pcx221YFXwEMcBHi768juXvsOmlYejr4vbOWpXv18fbdapH?=
 =?us-ascii?Q?p/SAmrn0ItMMt89Fx4ph1/G8kzu4gp7brTRHFbxvW9ur4s1ANn4R9xFqwif5?=
 =?us-ascii?Q?CerlIzk0KzV+1KYHrRlXcJlzYPek7dWTnDGSBR4YFj8T/Cr/d/sAXA28PPNf?=
 =?us-ascii?Q?2VsVjY8RpPuR1ZAaBz63Dp40ZrDptl23eObNS1Km5yMCg9wmD9tJ/ToZa5ym?=
 =?us-ascii?Q?+D/DqGjni0MncrXdiErJimkpn2bohUJnGyE27oBsnmXMRtLnBXDbjnWLGis7?=
 =?us-ascii?Q?qvX76PqTpGPHHBOv+o43+vmjuJV62zl5+B8zXzr4it5NE1x6oqw1zpx5l4ad?=
 =?us-ascii?Q?kdNaBLsH1oPMVHyCHseDJMg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?HRC/dElJzwv2ONdi9qo0rR/GF2NNh8BMeTTsqiCGG9u3xghJHN7QI9s70Qc0?=
 =?us-ascii?Q?odlAINbhEy5OPkXFe1FF5DCEnVw3Wp73xpCoexLQMeHzqXuuHJ34+mZ6gcZ6?=
 =?us-ascii?Q?UuNampKu2fnq1BZS/Dy+QsklYeV4CkJyMLRl3AbCgaJviyI5kQuoTrpEye3g?=
 =?us-ascii?Q?d0kYjWaSEcIZ/A59+Cfvd9Zdxhz6lebxv3GvmU73BAbQrZ+qX7+9vQOW3Ihb?=
 =?us-ascii?Q?R4QGHzByGa5/+Jfr6fuxxI6/2vpty5d6W+8vYS7oUUfsQGG1JVL+AxBJj1qO?=
 =?us-ascii?Q?L0kcL6Xf4eNdIwiYy87/5zu7cH21scI2dPK3T71pvRYsGtt9dmMk9IGBzfTy?=
 =?us-ascii?Q?6uSoSQ6ZwP0yoZZQEeNqvM6JlF/io5Pgon9zk04si/YMBPuW2kXswC54iv0+?=
 =?us-ascii?Q?lWlYGd+RiCAn8AvtW2txngeAlFK2sOK7HGszCXrO9Y8M4fDcpiTmVOfhoolN?=
 =?us-ascii?Q?5fZGdQQZLuLIE5w/oJqQnW3IFUMgdW41E0aiqutcLBtnKsG4aOWZdxrXJg3n?=
 =?us-ascii?Q?/K7GD3edzzbgXr4SZR0f+aQuMjoewzQVnImLjtMObch+V0Va00P165kWd2Na?=
 =?us-ascii?Q?/ck83Bz6RVfMsQpiY8C8EC/70wM8/sMnBhCZfDPiTW4OJe1eejch/58jMApW?=
 =?us-ascii?Q?yjwcMY2vKdCv5UkJ2kRbRMQYTMEcHQdTIVg73hOUncKE+gJKkcQ5k1RM+Nur?=
 =?us-ascii?Q?JQKf2zIY5YMsl03J8H2zIwwcB/GtVe4hCbuflrbW6543U4aLW+s1qLIa5rYC?=
 =?us-ascii?Q?In/r0hRBNacifKaZ8cxVTlw4uFsqSsTIuHEboedAVbYFNx4VaFl9bpecLNFE?=
 =?us-ascii?Q?oGzL5OKN3LxMqRnqImFulQxZ7v2JSgRi1iXGtCNTLu+lA6m8uPbxghBWxzLp?=
 =?us-ascii?Q?wOXHJHYEqyIV4axYRFjJn3uun5atJo4EHPLE+NEnzXLkoPd/WY9c1zx6ARY/?=
 =?us-ascii?Q?9TsjaIjXPBkhw6ISDmI14dsD3qbT09WYZYaEAP4I6UScc1oy9WfmmQ6yp1c4?=
 =?us-ascii?Q?vJI1B6MKrd9ZvKGSvqCbsF3jJg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 759b3e3e-bacc-445a-d051-08dafe4ffdab
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:33.9832
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4qS+4TsAlFhAOuPa8FWJYmFfccr4GXpnK94fA5Xc/gizfMBXOR8yi/mi7fGYZuiaiVPD5N0NpuXfWcFqe/0eUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240196
X-Proofpoint-ORIG-GUID: fMpqxxL_l8kMviJgYv1gOUo3XuE9ukxn
X-Proofpoint-GUID: fMpqxxL_l8kMviJgYv1gOUo3XuE9ukxn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "H.J. Lu" <hjl.tools@gmail.com>

commit 84d5f77fc2ee4e010c2c037750e32f06e55224b0 upstream.

In the x86 kernel, .exit.text and .exit.data sections are discarded at
runtime, not by the linker. Add RUNTIME_DISCARD_EXIT to generic DISCARDS
and define it in the x86 kernel linker script to keep them.

The sections are added before the DISCARD directive so document here
only the situation explicitly as this change doesn't have any effect on
the generated kernel. Also, other architectures like ARM64 will use it
too so generalize the approach with the RUNTIME_DISCARD_EXIT define.

 [ bp: Massage and extend commit message. ]

Signed-off-by: H.J. Lu <hjl.tools@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Link: https://lkml.kernel.org/r/20200326193021.255002-1-hjl.tools@gmail.com
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/x86/kernel/vmlinux.lds.S     |  1 +
 include/asm-generic/vmlinux.lds.h | 11 +++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1afe211d7a7c..0ae3cd9a25ea 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -21,6 +21,7 @@
 #define LOAD_OFFSET __START_KERNEL_map
 #endif
 
+#define RUNTIME_DISCARD_EXIT
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/asm-offsets.h>
 #include <asm/thread_info.h>
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index c3bcac22c389..2d45d98773e2 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -900,10 +900,17 @@
  * section definitions so that such archs put those in earlier section
  * definitions.
  */
+#ifdef RUNTIME_DISCARD_EXIT
+#define EXIT_DISCARDS
+#else
+#define EXIT_DISCARDS							\
+	EXIT_TEXT							\
+	EXIT_DATA
+#endif
+
 #define DISCARDS							\
 	/DISCARD/ : {							\
-	EXIT_TEXT							\
-	EXIT_DATA							\
+	EXIT_DISCARDS							\
 	EXIT_CALL							\
 	*(.discard)							\
 	*(.discard.*)							\
-- 
2.39.1

