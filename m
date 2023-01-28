Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A49B67F48C
	for <lists+stable@lfdr.de>; Sat, 28 Jan 2023 05:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231975AbjA1ELN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 23:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjA1ELK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 23:11:10 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02ECD7BE75;
        Fri, 27 Jan 2023 20:11:07 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30S3N6qF008293;
        Sat, 28 Jan 2023 04:10:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=SOR9L9S2gESsojG7jbWfxFEj2E1dBoIJl/TES8CchmM=;
 b=FknzWdCPUcilziS/q03rkQWzlI/HVmOojoJeishFTFimXh0veTnbU8Mupdol8d42oA9O
 sUtr1vduZlpS5cFd9SR+9RLaRkhK1KL6lAfmLpuemxj93UhFLVJ0wvA6IC4Hd2zl/RrP
 lY7R+EKuphFmo41dbaRRXAWpB/b3hpw8CRV940XaDujiXbQieHhL2HSkv7Eu4c2IVxhA
 6/TGR42g1XWkxsjFvwmjNefefyVnXayDsW6Tk5MKQUd/Kq710n9BQFTOfNymhfIeWIz4
 D6WVdDQkSvu6KUzVLq2hOJz1ePXPcTBCLn7IejERl973iOrp3X3BJYoqe9jzq38MgdGN dw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ncurbr0w2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30S1XeYS037510;
        Sat, 28 Jan 2023 04:10:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2103.outbound.protection.outlook.com [104.47.58.103])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nct58u4g0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Jan 2023 04:10:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NTHh2RACIER7wiqsVHMRcJavsqD+7T64t5cSsnzRijQt/EvTw8BTf/l56FRoJ7XFxuWFO71OhblhUjkqpZUthZ1lSrRgmK+9Mq+nu1apMh+eLfmbcfSIQRMCq/CijUyevZ4F24cnrcwB+vVlZMVgAv2Ikj+JhTLguI7j495cTDfd3Vd3BRX1SX07M05VAB4uVU+UtIjCuEH92FcTJCwfVy/FHFhkzqCX70MWZNARkkIHgg99sKKU4egQxiDOmkemIHg1eBovJktvQWls9zgPTxJjNK2nAGmSYWo/NiCZpIQ7tcSNhnWJSIgyOXxWmMawN7ieKDmoKzt2ngDD51eLbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SOR9L9S2gESsojG7jbWfxFEj2E1dBoIJl/TES8CchmM=;
 b=HJBmRC+cABowUrnVz44joRyf5N6/oM+gH1IvsmK5FTa0PPIG/JJEEIHET57i2wQ8Ww+CsTT9Di19iTLbymWC4wJ/m/NA04QR2Sv/0xZ7uOv5rWnDEep5mOyrop/GwiDbH+9Dmzzkv+c55g5v7hL0g67OfZf69p94BDYghxZR1IAJ/OGtRVqymFKA33g2ekTmh4EzhztuH+v37AzBo/6vwjcKygT7KFq3Mx+fLVwsewNYA5g2s1UiXht7SxaPWEocjpWCLfZqEf+c6BcQYXoJi6/jeJC8D9mRxbK8qVOR6a99efEfO2LOrtkZJf7/S9vCvd5KiLt77RIHpPausIkJ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SOR9L9S2gESsojG7jbWfxFEj2E1dBoIJl/TES8CchmM=;
 b=YphBwaXTahncoQU2kiKG3A/2P70J1/ECdih0moCo8Opo2UHN+uCRz3eYQJtSM/oGxy9t2h6Btvz5d3nhV8RpgoSUo1nNEpXBvoDQsAtWcEAbcoejSgZrrZpWVfGUofmAh0PDwq/7n/ionBQ/DZx/01QuMoe7qLtCV/o3ZxoJn8U=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CY8PR10MB7124.namprd10.prod.outlook.com (2603:10b6:930:75::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Sat, 28 Jan
 2023 04:10:38 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Sat, 28 Jan 2023
 04:10:38 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Jisheng Zhang <jszhang@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 6.1 fix build id for arm64 3/5] powerpc/vmlinux.lds: Don't discard .rela* for relocatable builds
Date:   Fri, 27 Jan 2023 21:10:20 -0700
Message-Id: <6e4db0d62b534dda21568c491dbf2e04dd9c6101.1674876902.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674876902.git.tom.saeger@oracle.com>
References: <cover.1674876902.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR03CA0006.namprd03.prod.outlook.com
 (2603:10b6:806:20::11) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CY8PR10MB7124:EE_
X-MS-Office365-Filtering-Correlation-Id: 056b9933-53ba-47c0-b90b-08db00e59c96
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /aiSN/cTogQtcLoU4Buwll5zVGRX0Q0kK79ut+0+L0ezrj14Gl4jBiorrX+rP3kwp3Izn0H8TIbQ36i5cfwzOf6Fex7iBx/idl7701zKnSoZB28kNfvK7XJr4Ap2HANCPvZLyR8CzbfHjPizvhJQ4JKP5vnFcaBlHRH/UKjlUgZdVredGT8B35zSYQmF6MTgelsssegSr5BdAX8lc5NJJs9VrsONFRRcxyure+tliNlfc7GvgkhzTO445mEKG/EA0u2qWsvznoCesnJHhKP2xEMk3gmd3Wrm5kRNu8OQMZey5GcWDzDjki7iy0lsY84vdM3+bRy2bWw1qS3G1i0E0uA0N5ElDLCpLdfrJzfrM+KExiUL6/EMEZuRJ0tf5e5tbKYZTq4lsMoT2QTzSrrksg5FdSgBwKWSKh5j3LX/DU1D4///01KPj+qh3kihdSGg+/GbuiJWzSFxjhws9KQjkpBGZNvWqHfFNrlVY7aQen/WUeg3YxPUT96ERKBmdk0d0mj34ohOFZ+XCbB0QNJ136wG9per6KMfc+KqHiEyxyI5hViZY98dgUhCYszIYJ9OUjc2QcLCJUmsgu75JFoLc+o5jf59AByATY5ujz2ag8bgibX68vH40v6cGJwh+dX6M8Q6e08NdW8F+3FPvhr0Vjbz8p3iTkUrzU40tiw0ACIUhJOgnu0pwGxX0xls57bD5rLpUtaYsTLHQdybszBxvw015oAl8Z2r3YD1YP54H2I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(39860400002)(136003)(346002)(376002)(396003)(451199018)(6666004)(186003)(8936002)(6512007)(6506007)(7416002)(54906003)(5660300002)(2906002)(36756003)(44832011)(86362001)(966005)(6486002)(478600001)(316002)(6916009)(8676002)(66556008)(66946007)(4326008)(66476007)(83380400001)(41300700001)(2616005)(38100700002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?i1HqYHII5IjMnHF7BshHtU83iRsRonXdkVq3wBrwOgNCKmUQfUfpkQ4aOf58?=
 =?us-ascii?Q?OPF8YRkiGCPs7dCx+K95ZDVC4solFtvZMyJHJoIBRPoIRUJWavz5Zy1KTTLn?=
 =?us-ascii?Q?1gb5agKBkwbxCaEyvXzr8o3q8Ms8JCxey45DiyK3h05QLEiVZYrwqghzORCZ?=
 =?us-ascii?Q?kXWhkAUt076zkyi4ZkyEzmqWc0Qnux7ZK2IDckWvCc84O9xjFah+AfwO4DD2?=
 =?us-ascii?Q?eHvPjNLNIpVr7l7Q2aRnlKJBJxSP6z9Okwkc/w+bZ9rlJwWyTfoga3TS2DXN?=
 =?us-ascii?Q?n0yuXTuUNP6jAtw3dvHwvuuFF+clz3QZyDYtrj5sNCWWr+XMhDLdbhBHrXvG?=
 =?us-ascii?Q?oXjZJLZpO5IlTB06WhEL2lzoO/CyzWqfdRNKbJuLcorRt5fwk8YFX1JCm+dI?=
 =?us-ascii?Q?s/JQYtlD0CIBNU9Xe/8+FJesh/MQbApD/dta2iRNKKlUe9ROxBCwyivLyeEm?=
 =?us-ascii?Q?YLJD7kmgpQHyzqoyPurB2Df+a4Lb6HHRwK92eHaMTFGWvTYFf0GNYNDAGb+e?=
 =?us-ascii?Q?r802EAQglLzMvPA7QcSQEJICdn++p8bnF5+Pe3OyQiy8ufE2x3z58X0JkNY4?=
 =?us-ascii?Q?bsFN2p8IHoPkJMxFb15whcO6op0nzrS4V/7IqeI8AzOP+QbScG/flgmWG9GV?=
 =?us-ascii?Q?dtzxvNqBYEBVpgA1KoXn864Nn+RjmCACSbsNDt8hGc2u9XjyyQwuNKH0213v?=
 =?us-ascii?Q?K4JtMZoib+JKxrQkXSG+8gIo0mrVAOZa/UvOgzklLtxY+8qkPD9nrdotTmtY?=
 =?us-ascii?Q?umdPEFVEuLCxrfUVcR0UqM5Xe7CjiAbFQes4kP1HMyd0qeJMaFBnzr5rez22?=
 =?us-ascii?Q?YYaYfYP3Fm3jRByN/nnYV/vgr5UBc7XfteArlE7Iu9I8fW8eQ3UKeoitMOkh?=
 =?us-ascii?Q?Q0Z4IzZhAqu6V6FWdxF0FrfYjS0erg6eZ5BTKEYWue2XMnMeI0MIAGhQO8VD?=
 =?us-ascii?Q?/gsUv5cmaPQrrMmAHaCf6/HeNlo/9GL9dyBo2pgEw2B9LQWNBZgzGXsqL83p?=
 =?us-ascii?Q?vbr0I7jbtVJCm8a40VBmI0O8dOXI5YNvGS4DCFDiL4tXOS1u9MvZhk2YolsK?=
 =?us-ascii?Q?AsibpDYoJ7DLQZ5s5tpnIZFHPYvlEgIuy2+jHe5eh6ewanELmEoWzJdBRnqi?=
 =?us-ascii?Q?7HXvULS6QoQjwTj/Wur40jIH7WqeGphhh8U+bVjch5AnKwge50GzFC1cQuIs?=
 =?us-ascii?Q?+nfVsQV2kPmRwKGwLQw4SCxRY1LLQureQk66MOxLlY0lVhfhRLxxM7IoHPt/?=
 =?us-ascii?Q?fGX7kPuJBJp28QGNEsVf2fK9nxTWQ4NDRrLWJQt1hzsccJcnPgaDogHcEIp8?=
 =?us-ascii?Q?vK2l8mKwmLdvlCtE7CUxyISaJAcHaG8uDJ/eZCzPt3AmtGNhCWjxDrSO6HjE?=
 =?us-ascii?Q?FCzduKh49Uuv5Il/aAxGBkyCT2F4f/jDotIzOHwGA22qYIgv56ULir8M2iB7?=
 =?us-ascii?Q?HGirz2gnmZ3OP5E5GSDtfxq5Mf84ukugmVO/QtpesAKIvYwN1KWaDCn6MJYk?=
 =?us-ascii?Q?oUftc1S2iHcXNngo3qjflGJbJXVqeqGrZwylqoXEaz6cSMintAWX8tEpeZ2Z?=
 =?us-ascii?Q?F20keBcc5j0F5D9velzjZzngyy4MY4Nn9FL8x8ql6z7ORlXa7YMkPTLxwz7m?=
 =?us-ascii?Q?DCjUXj/Xq0mK83j9XsJcuwU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?NdXEg7783tjr54VR7FHmJIYhZQAsYqJTi9R2eHMxeHfZpe3dyWo1f71y68Vs?=
 =?us-ascii?Q?eoYyka7sKkx5x15CesX/QFNoWmTlpYBTf0QVfA2JmhgkThowCzrOb5e7k3q0?=
 =?us-ascii?Q?6vs8yEES15X3rF5vDdePc/82JJHYtUjgdwWCh7sU8GbkbKWIwwkB5PpevkPv?=
 =?us-ascii?Q?rov6B9jTlslfTOBDlvXlrhxuVFdr8PfNYU7heN+GH3EPIiEbjqvoCnS99B7h?=
 =?us-ascii?Q?hQ4D/V2flDMHT2Z1bveAfb1PbJ1Bxk3/zh1FZvPu1FKPPeUCK/vcYFZ+dKSl?=
 =?us-ascii?Q?sweHIwuC4z/NtPhKfoUXSaXHtUYzRyXrt0HaE4I/3Tq0jDEeSKnRGFmYbvgZ?=
 =?us-ascii?Q?cZ8vyv76ujsXUJeWsWrR0vT25Sz39e03paXw3VEU+Fsc3OuqmuhH6GF5sAZn?=
 =?us-ascii?Q?ch8V2I4zrqJyriKOCC7c49H5OirLEbeJ0QF85d1YqP2c2cS2kxQPQohaGY89?=
 =?us-ascii?Q?cpibJr8VsUt9AjH6pX7XZS7QqGJlVEWxmY6BBDGldVrdQsjKgHFWZeZCCzRj?=
 =?us-ascii?Q?LN8AUzZeDGNhSjziqeU3kImbqKWagLq8kdULZdtNt6XS13oJg53jGifn6gtv?=
 =?us-ascii?Q?qkbFJ37nE7LXH+S/ovu5bQORR1i98E+xSxoSX2YeZk8zzQ4m3KUQdEQD6sy2?=
 =?us-ascii?Q?lh3PlMBMpRITgozHJ06qs+tdPdp0kp1GU/cqzJ3v5uJ/ackAU6dZ1K3ey4iJ?=
 =?us-ascii?Q?W2LkSUpy62vnDAGLxc8KOb9FJ4ymw/vgKgxBBJxdYDRiLYQc0bAl1Dojua6s?=
 =?us-ascii?Q?tRNxB5OyFBAZxgSr3NhRrElBEbKq+0zMu/aeSKPm1oT5ahZea36OMpAlNqrV?=
 =?us-ascii?Q?mlEN/ctljzlQN/HtYmSoLwwo1Rt7so8lsNvK1fVY1mhvhR84sFSPDxJpXs+9?=
 =?us-ascii?Q?Iv30H/b/MZjH5jLtfxSEvh5Qx/GHAUzSm3ptIJvi3mDD2Gwh/yxTk6CMJEvZ?=
 =?us-ascii?Q?nAC8RH+1GBmJ6Ph23A2VG+bL9MziHab0Qr99gRFj0L9UIV2y2S/0qqYTqsxz?=
 =?us-ascii?Q?Da8ekE3sJhTy0u/7qSD40Mc9wH0xNh/9D50dQv96qDA4ja3Yj/PV1n+uvi5W?=
 =?us-ascii?Q?fC8K8fJ1fISSHs9/MQb2yy7WCa+GJg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 056b9933-53ba-47c0-b90b-08db00e59c96
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 04:10:37.9410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vgffr2+egjezgc8LXTS7plEhnpPg8Rw5CANVLfhtOsT9V1dkhoE2tCq3wvF4dGGM7lYmiFEiCq7HTdtYV/PLzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7124
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-28_01,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301280039
X-Proofpoint-GUID: iD-oaASsZi5x2XYr91dYRb93a4hHYe2c
X-Proofpoint-ORIG-GUID: iD-oaASsZi5x2XYr91dYRb93a4hHYe2c
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
index b24b53134bad..078ead9cf6d3 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -411,9 +411,12 @@ SECTIONS
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

