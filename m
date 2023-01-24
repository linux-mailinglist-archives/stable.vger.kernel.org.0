Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9C3267A4B2
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234818AbjAXVPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234700AbjAXVPN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B7F51436;
        Tue, 24 Jan 2023 13:15:10 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKxbRV000593;
        Tue, 24 Jan 2023 21:14:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=5OQStQmNMkhkKHeRg+xPFJTie+R1hX8NmkrTOikIuhw=;
 b=dVWgyOpemwKA6yQ6j1LQ2vffsw7JoWupA8PLyJ6KhLgCVMBIS6ESWvG20wSL30ZiQUh0
 fxGtkygcvC7/1ZjAv6og22IaGqc0eipUKVQ3E3JPk/bA7fBrNIE4qWJF4CB9zT7+rnj5
 clXkkZpUl7Ic2U3WSY8pC14ELzPex3BYBZKbMsUvSVq8V/czu7pLCs55rKrgMva+gXhD
 oB1+PaqNysJv+GVyyJbmC8OE9HtQMUWsut3nbTcH6iDX4ZWpmyqxc4VQoB/l1QDFeYA5
 TMnkjbz93RiT90RAQQneGabevCBhwX8zbUccMvqKkXthXH/0ixr9KFg2r4mgqayNkTnn QQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86ybeg2y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKBXRm030217;
        Tue, 24 Jan 2023 21:14:39 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g5ubwt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AcB/RcQxaeJqFtnQyqF7uCz1H1Dha5lPdwehBmLfBJhPqtI9B9ceRyje1fpnj5WMv9B9ViMTY4nVp1thtguYKxFKtu14Aqds8pKD8lIWFDfpmXYks9fk2sbjKYTI14HsV0Q+J7Sh0AgarIiGOTAiGYo/lWjKMILhq+/+/Gly8u9CJJdcLZ89yRFgy/SgQmasAAzQxy8/2DASYsotwV1EeqOWsRL7A/rXfwerV7MdA3cnkyb8Cn5BAKn9ECkFhpb+suY+tFuU76ktf7yGEkNBwvS4kP4+k3ZO4SfppLaODh3ds84s9p+0acedrHylIkNqMjgfM93GdL1DOS84lj9tcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5OQStQmNMkhkKHeRg+xPFJTie+R1hX8NmkrTOikIuhw=;
 b=kqb2x38pA5zkhs7PGdwN8YUxnRXatTi6GdSW1tNGYdUJsIlkZKAnGzFVVlX2XmEawUN26KJt+Eel21l2RDVuVWprmKewMe/m+TsaZSwHNxS4X84bRDugS5O6gWtTSSRDYpUyNsDDv2Bwl8lSsuvlxamT6HiVPbZQaO1g0EOWbAIWSNbSXwcmOew4nFTEcl3zxRFz52yOI6vhtVaTkv75iOMfu7IQlSoOzL7yrK74mKqUFsLSj4kIXzVJ540vH327sHsGiBandgoKahLgF8xC9Qfdo9XJto5WgJceuJLY+Rdlt0E/nPO/V1eJuKLkM6kpsnPnxcFEn8jbIU1Qki43YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5OQStQmNMkhkKHeRg+xPFJTie+R1hX8NmkrTOikIuhw=;
 b=NOgqgLWc1CkPQ4tcz5tYbTNqVCsxf5gFXU7t9ecfZMHQUgmgU/4sxlVoVA69xQOIA/1sf7eGH0nkrb3WEmudPfr6qs4qTdmdHMDUzaoQ7Afe984I3Lxq+KTONBLx3lQOB+2Lff3jkxQOdyR4ZJRO3sWFjAjqEPvyLHpYfOK8WuI=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:37 +0000
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
Subject: [PATCH 5.4 fix build id for arm64 2/6] arch: fix broken BuildID for arm64 and riscv
Date:   Tue, 24 Jan 2023 14:14:19 -0700
Message-Id: <33319e16cbdf3b817ff150a9d1e072f349398ff3.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR11CA0068.namprd11.prod.outlook.com
 (2603:10b6:5:14c::45) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: 0484a83a-6ba1-4cc0-0011-08dafe4fff8b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f6Vxb58DOnlWlMVJb7qT8GZQxpNqZRbjM5Rvde3c1ZKqwUEHg4rPiiSevaye5Bb+wvPlICrn31gxbeEmEqrE8YzGhTu77FY9h7tyyXjntSFb3DEGFIigtXvp0YCP9vgFQneT7so7KLHy0YKO4sopEj5k/7Cd/6IPKmnqXojHkbvS3dHJmDP64tfSs1EKktq92oSR0Z5kO/kul/pGv8wBT1lbrUueNS4gPclM3sACH0l1KqbGapMIaCFpHkXHXCqWR3ZHnL2n2Oha8qwTbO7jtGcBrjqjhcT6pmwJzQmLY4k5mDCXJZZu6AvcPg05nsWrS5JIQmqW8qs2uW8ibg7XtZqmepL+tGQmicl4scfFsVMbdvpdOLAUxmCdyRIpZQ7EoM+2J8HNYEK4dEavOy3RbkqcrwGqxce9stkAFg++LkEP39JmG3uL+fheUTlUyr7eERM/2gPU4iqVgmBowgLPO4IsOuo8NZEIZ8qpaXG1zhGhIuN/BdtKeCeCgpu/tWfVc7n9F2wY0rrgu8jvLve297bi2kLbqScJrkVDq8yE7UjnIuZRjCalND2G8qsreXsiHZb5oxO74v1uAbjUOeL0uPehSfQ7glw5SzKz0VuAAzbiFw6cbByN5vFfw+h6lfj4EFygwRgfvw/RtS0TGPrPgf7ugTbl6P+NgeFPgLfZ1Br6t9q9YgserfrICW34Sj6t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gHBAdMqDyrsjp+iESYSk9NWWsriX+pgjgYM77UNXfTj/DRW8sBrbY9si7Ej+?=
 =?us-ascii?Q?b2gs3w8RQS3JSC1jXebsgrZlEmS9PMnFsTcfQRdh9/nq0x8x7Mnb91tcEM6L?=
 =?us-ascii?Q?uAmZLFIMfJy+3MjFHpoARRg/jL9Dva8yzsCiEAqlXdYdvSC+AwBcSCciQGjW?=
 =?us-ascii?Q?VBP6nOOppm5XOWWRJqaGnmBBmIuUWA/rtc7OmXEjlRuHKJG9TGH8NJCtbC5d?=
 =?us-ascii?Q?bnSBlX703XO+6J2UqONeLVLLwBWdoFrMtf2eTlfpULi9FlvsQYcnuvhKrbze?=
 =?us-ascii?Q?B0xElL836QvXrdtqLOzpDHQr8JPpOz0Z6SRPDow9ujsUwB2cHmddruIO7Hdg?=
 =?us-ascii?Q?KS1Hka/Ez1Pv1NTJNDA69bx9Mxn5n0UZsd0VwADXnSo3ohwLSMk7YCxKN0qC?=
 =?us-ascii?Q?vWY69D6LhqayVS03RwQR+U37ExjkIqh7SZ3SV1uPtrwX3qeDpD18jNSAGc3W?=
 =?us-ascii?Q?gmSVfGtn6B71+yZ5slgaiqQYOhyZGMTk6S3wkOiDeCw+ED0vLUWIBIC7IoIM?=
 =?us-ascii?Q?H5G43tpmrUEinoAd63skzUd7YCaXkFrlQMJajUhWifadT58/aY/JCxfiTwyT?=
 =?us-ascii?Q?b4QpN0sFtg3MqCg5bq7NzdhLov04feUIXau5wdp+XMpZnEs4b83nm/OXxnbn?=
 =?us-ascii?Q?YJMy+7RAEbT9m9a0pwaOgmCoqWk9GEruG0DXkM2MLZw/quzykAqLeLofVo1V?=
 =?us-ascii?Q?A4pW8OAMv0mDpVfsDf5Zk6qLVe44gzQrioxkGADUonX8rTnYhYriyg+5lbr3?=
 =?us-ascii?Q?gOdrM1/mPI3uxYxbf5D8pzOz47JziOMNXxvmS/d4e0j63fhtEO5wdM8ywTN9?=
 =?us-ascii?Q?fTpfqEZuDP2D2AFmUPoyPCbaDsjUWFM1pTgeW738NaaFIHiuG06CkXIFYEaq?=
 =?us-ascii?Q?pRRTE6RTKoIQrphLgONOHYrfC1ZXQJANByt4fkAZ1Wardro6+hM03WhQFwEK?=
 =?us-ascii?Q?6WpdlV6igLeLY17X2T37P4RpmdvffJdFq6PgDpxJ3P5xEC7KnJe+HaIFSDrM?=
 =?us-ascii?Q?qp84BRt3a4IlI/DNr+KVh6SbXAMEt+PLi9cxHObPaI3rsXNyei2aSwS3WIex?=
 =?us-ascii?Q?/YFHa2mOcOoto2CAENddMEvL8xmugh2R2MYbnYfL9ic2f+Su3SlopZI7jAQd?=
 =?us-ascii?Q?2G4FAh82ym3bZsiUxAK2p8XmX69+wORYu1lNvLEKG1Jt2iWqGlqAJSZLIYLP?=
 =?us-ascii?Q?c7lgSfULERKx+xJnigYfh2mounvyWJnOP/afIWiHPehIHYB2TyDitWuTFvAf?=
 =?us-ascii?Q?JS5FQ8vZIcWLkSBskUAeM5n9xdbgbD27zEsmzl2axMi1577MWu9gINhEskQD?=
 =?us-ascii?Q?JWC4UTMhcMYN35NiFkqDTuriYl9A53QGi/qSmk3TTtPMEL3s+5+0kK3+ICpp?=
 =?us-ascii?Q?UGXxX1oCuMS0BntAXmUAjb/AvpyVCxQXFukmhhZBtamJszHQBp7PHcrcuK3B?=
 =?us-ascii?Q?N4cn4y5jiudXg9+wQYUjk5mYAnj0RvTPX6MWJ5BF4ok7Y7dCUe251IteCjan?=
 =?us-ascii?Q?jsEIsYZYlqMhVFuXxOWxIpk/RK9gSGnoPXGXAgIHdJzTJiSxQSsT+LkttxWC?=
 =?us-ascii?Q?DacfrHbFdQTqDsUs23ILAuE3EHCx/BXM7Sae1CV57ilgWCMfwSaAJKcTo8zX?=
 =?us-ascii?Q?arNDTMxNAguP2XjCNkY9w1Y=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?a+UMN/Fq1DGAwMk0Di4nFBJFC+eF+cQ9/ZinsOFTCFBYEDqvz4ow1fmOSTVh?=
 =?us-ascii?Q?+/MLhQdtETs/rC33p1UiP70zQzHkhdlhfTknbEZABvb3d+KazfR66NU/mSx4?=
 =?us-ascii?Q?zj0ESeqXo5C8O2ABaMaQOdJEmrcfDFmZvOZ1CSAiO/v/oR7UK/sYv8tEvZU7?=
 =?us-ascii?Q?OlJBOZhe0hNknWsbqgfuXKDaEaaslKiuFrw1E0gV3UYFoWpn+KjitD5Mfx9g?=
 =?us-ascii?Q?a+ItXvNyBNK1sCy+/JjUXKC3cmTeDARC1BCVCigtcUQmPLhryO2UO7niNJY9?=
 =?us-ascii?Q?BA+3WV0hYW+8vS2Pg8KZ0tfON8UZszPFIvMDSeGcoarlAmqNcScbswhAwEsn?=
 =?us-ascii?Q?dIviXVXyOrsDdmgu9Z0RBifqwERpGEc8bRwNsYc7Q3/1b9syOWt2QgC9q/M/?=
 =?us-ascii?Q?aQ/iOzAWeS9q0kaP6Mutdm11FzEyjaBgog6e37b7pXMfyrPaXNCDpi/FSfb3?=
 =?us-ascii?Q?QemDhqNBkQY220skeCcvw94VbSEj6H/GGVPsoUyjU39zO82/iK3ybO3vtBYC?=
 =?us-ascii?Q?vRqvxuZ8LiMc/LbL2+oP9ZDWWLzuST4eE7ou/l0K4sbT7e2oXSdWyTXq+FSZ?=
 =?us-ascii?Q?mz6SDyQETRXLh1H8hYKdxXj7vay6GxKLPSkkHOCpRKZnNQIqGKxFZ6mQDFGP?=
 =?us-ascii?Q?Lgnhh0EUXr3tlqWCmQduN3COfSUlwcAvTmih87VzFTjV9cv9lXpVKHXC3HdK?=
 =?us-ascii?Q?aVdQHiwTtlgh+J0mWGHU5x9x8BB5PEotW2YUs3jrUrl+47iuZijqOpkgTGcX?=
 =?us-ascii?Q?9sgKhVzf7bZG0+Y4Uiqxa3OX4oWPKsYkwChDMglCPzWdTJbZbaoLxOaU4Uec?=
 =?us-ascii?Q?EvJErHEEKK/EUvi2ng5AwrEToY4fATbS89gcj3TLBrLYBI6HHB0iKUy5g+MG?=
 =?us-ascii?Q?DYo1cx0eLEeDD0BGtz+zf++DJzSRRHbFVeVBaoyUTMFuvLYdgOb7IIM/ust+?=
 =?us-ascii?Q?rWd7Csy6SNFK2Wdh2dgKNEevpxDMFZQC4M/RKgqt04bF2FTxBUCKC5JSvOc6?=
 =?us-ascii?Q?JqaKlr7ZkB48bsdriHhoemx9wA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0484a83a-6ba1-4cc0-0011-08dafe4fff8b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:37.1548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jgpze5sKjTm97FVsy6vpbOddTP7BKQAK5SO0B98vDH+IT1REAm7EyuO5z9yCMrlMKfht8uJMxbwNdvfQaMzvfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 malwarescore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301240196
X-Proofpoint-GUID: EFf5L0lm8jj1DvSoE28W-AqzVNRr_u9s
X-Proofpoint-ORIG-GUID: EFf5L0lm8jj1DvSoE28W-AqzVNRr_u9s
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 99cb0d917ffa1ab628bb67364ca9b162c07699b1 upstream.

Dennis Gilmore reports that the BuildID is missing in the arm64 vmlinux
since commit 994b7ac1697b ("arm64: remove special treatment for the
link order of head.o").

The issue is that the type of .notes section, which contains the BuildID,
changed from NOTES to PROGBITS.

Ard Biesheuvel figured out that whichever object gets linked first gets
to decide the type of a section. The PROGBITS type is the result of the
compiler emitting .note.GNU-stack as PROGBITS rather than NOTE.

While Ard provided a fix for arm64, I want to fix this globally because
the same issue is happening on riscv since commit 2348e6bf4421 ("riscv:
remove special treatment for the link order of head.o"). This problem
will happen in general for other architectures if they start to drop
unneeded entries from scripts/head-object-list.txt.

Discard .note.GNU-stack in include/asm-generic/vmlinux.lds.h.

Link: https://lore.kernel.org/lkml/CAABkxwuQoz1CTbyb57n0ZX65eSYiTonFCU8-LCQc=74D=xE=rA@mail.gmail.com/
Fixes: 994b7ac1697b ("arm64: remove special treatment for the link order of head.o")
Fixes: 2348e6bf4421 ("riscv: remove special treatment for the link order of head.o")
Reported-by: Dennis Gilmore <dennis@ausil.us>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 include/asm-generic/vmlinux.lds.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index 2d45d98773e2..a68535f36d13 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -825,7 +825,12 @@
 #define TRACEDATA
 #endif
 
+/*
+ * Discard .note.GNU-stack, which is emitted as PROGBITS by the compiler.
+ * Otherwise, the type of .notes section would become PROGBITS instead of NOTES.
+ */
 #define NOTES								\
+	/DISCARD/ : { *(.note.GNU-stack) }				\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		__start_notes = .;					\
 		KEEP(*(.note.*))					\
-- 
2.39.1

