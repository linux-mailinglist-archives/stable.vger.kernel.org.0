Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6381667EFB5
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 21:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjA0UkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 15:40:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231898AbjA0UkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 15:40:01 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29BA2116;
        Fri, 27 Jan 2023 12:39:59 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30REScOC005521;
        Fri, 27 Jan 2023 20:39:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=iwb2TKLJPa/k4adKBS7hJ3cPQII295JdbdYJ5AxIiOnxLvrxMRAEX5fT1B/OTfu1ej6I
 Qz3Z1Az0jT7PtGx3IWpVjjSsog1ww4/ehOcl4iXhqchyS9u+heI2qZDQUgfARPrPreq1
 XLYjFVa/VnY/H0yiLXOBXTxPbU8UYq8ZJLA3VtOffLWGgQoigXNoUPMw6vPuWptQCgUB
 4eZNpnO3ADvzCFO0VFpe5KC32cLtqAyac1wrKUQOJRGs/BfgmF3K8feF2wX6YtmJQ7NH
 iwSkOuGD9Gg/o4cBess8h1T/T0yM82TV1/Cgwiypy0EqoYEEXYj5GI+8hemH+LzGSO85 YQ== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86u35rbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:51 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RKIs3G004965;
        Fri, 27 Jan 2023 20:39:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86ggjdwe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 20:39:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RiVoE0nZsWJMgHdIu/Mmib2Y3Tcvw7uLCGAvb1KUd316t/rUQFabsNzmKQ9n+NfK/4oqESMHo3UyHFjE8GE358rrQtkl+OJWtrou87D63GFuUfVYzE6ziZqOzZYciFiImup5spwuJFUXA0Gqdvf3nQW23ZI0iGgflbKZjjjeiDo3EIxwgqobaeDzgFUY/jSZOG9e/NyMNjKYrE7x/eaGnfJO9XXqB6KYRV4NjFEoXm6JYZb/DvcSWzGWyRISTi/f4mrBBlthICi9k/giUDuxW6BrvDGvWQA5PzBXbkaG9vDAy4CNlFjVto0wk93RnALgD5/YEIUrNm/TIvrW5siCLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=eYSJqMhSYUH/IwbJpB6u0o0PmIT8E+iGbEyRDmq4a54X05Iaz/9Q7EJLTdhC85XZHW8Bdzm5weI23SDnpMjiKjbh74NwKPuD7IryFxUxYHBlRwL4qOMXJXEJpJAT07Y1DUY9+iOq4PxI6AeHDQr1QkkDT7IA2Y8zzt2EGukPGPlwZ7v68VBztB4M/gCM9cAtiJVswymTTcVw/HOeN1IUi7GEo1ZEM3NyJCakdDMCxPbMmH4gKODhMAm/aOwWJ49ziobdHNoWLaUb4gNizZAAMga6t5f7KHo6c7v/LXRq9akPE8CyxUtOIQRo/PC+0H58hxVVQRo0tWLF3MNpN8yJKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liGK6Cfe7R3hLz9yjT29KaP2fem8h5ZkQP1LS4op+YU=;
 b=IWWt5l9c/MpnFniD4SaqoSx1H+j//njhubZ/lVsaQXXn32IkW3B8/+zQJK3GZREPeiD5ZHVKPauCrjHHN7HrjD8j2xnKJ8lJEm119DK4NAEHeRSnFWDrUGZx8tXe45G1TxlWViciBTumXH+DDttXBZ+agH9erRaS7sCRkVOwqJw=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by SJ0PR10MB4605.namprd10.prod.outlook.com (2603:10b6:a03:2d9::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.22; Fri, 27 Jan
 2023 20:39:49 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 20:39:49 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 5.10 fix build id for arm64 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 27 Jan 2023 13:39:27 -0700
Message-Id: <c605722f1659d93d0e95402723830cf7bc74e145.1674850666.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674850666.git.tom.saeger@oracle.com>
References: <cover.1674850666.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0050.prod.exchangelabs.com (2603:10b6:a03:94::27)
 To BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|SJ0PR10MB4605:EE_
X-MS-Office365-Filtering-Correlation-Id: 5534f1c0-ba9e-43c9-4682-08db00a6a249
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hjXmw/yRFbeXiIQ5siXhNJU+6dT1fH0q+BC0FAhJdgPYQPe0WFR/bJRi1BLotOxw2kogvtyChGUsR1csOmYvlEY1LEi8tNSX9aI598R5cZrYm74eokPoRfKBhGzW4EES/IhN0lMN2szjmHgHqUZMamzSAczkE1HKBihyUqNcaM76Tm2AnmgIVL6/WYi6GvwZ9EGN0u0/tKd1qZc+fLO/z3IadbAVylkuidXs5CmIzeNxWmLVLQPo7UKscWnUyXMUs4s7J1vtUhi+ejzGFsfC5H4xueI328X5a2oN3zz2pXpX04EGV/4wl6kt0SUVe0R3ZtKLPCbE7pQxfvpqAmDjZZ2S7PiebAP2u7Qt3wpAqQBEgy2YFvBpfow00Z2GIbb+OtJ6urRz70FLq1j0eHn+OLAcF2ul/kfkTpm1s+L53EWW6AFyxDeL9a3/uVfzF7Y1GdiRLh4m0wKNwC2JAxeUm3zP1U6nQdxnwVr44JF6vCJ8BNfe/jKzc/T3A3Cx5S3qzLcB9ALiYy6oZA6hMGl+3yV6PVIWTncGXvscWR88m9CUGXljj4Vlqzf5cbuEJAd4zxKSXJGxRMGkA8Y52AaUTKIqT5JZYQgkHBQncjDoUS2E8aBED4ZBVTSQKR2+PPoBbGeJEi0VZ34CtrLM8FYkw28PS7EsuiYUTNWo9CqXCt4trBSN2SBa5rcDSdNC4Z1APxS8V3ih/4LvOFRr6ViWlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(376002)(366004)(39860400002)(396003)(346002)(451199018)(2906002)(8936002)(7416002)(5660300002)(44832011)(41300700001)(6916009)(4326008)(8676002)(316002)(6666004)(66899018)(54906003)(6506007)(6486002)(966005)(478600001)(6512007)(2616005)(186003)(66946007)(66476007)(66556008)(86362001)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hNvBSM6+eQhsO+ZILwqm6kNSRVs++X6GPBgaDwQGQjDtmLaAgUkUGc3EWDn4?=
 =?us-ascii?Q?I1EH5r/Jxve7u6cl+CwEbjn8Y0CrG4VjRUr+ES1NiKGols+ktxrrv5I9wTRd?=
 =?us-ascii?Q?NEg/VXrjmBqSMnzhfxLxLGWanxOBvHsk2DCHv1DnqdC0ZJAlfGj0m6C8IUDD?=
 =?us-ascii?Q?VUKhf1GOHE+F8vQ1f8mOEyXCvvUVPwZ38FquUhEfZqyHYGNzI8uyej0l/rNa?=
 =?us-ascii?Q?wkiY39d9/iyW/6M2b8Cho+i8d+qXMtV6pDEyzL/9yOaomKLo73hPQ6iz54aa?=
 =?us-ascii?Q?o4iPoDx0v+8ZuG7j2gaLoZG3383m30hG94rKNM9V/hkaPSwf26EuvgpyaeD+?=
 =?us-ascii?Q?5/uC1o3MPAl+dldiUVJ7zvJeC2nEIe2mZ5UDBCGihu0WR51NsDzeP2Tam54i?=
 =?us-ascii?Q?MqT3DNCLDb6OCvgK2h+8YB2w572DV1x7/XavBCNlExYLjl7dOJMPlLR95q9V?=
 =?us-ascii?Q?Bv4vLG2BlxIshnbqwxGl+KOt4lFgMFsChRlZTpgd7Jt2ZI6JBmd0Hcam+yp7?=
 =?us-ascii?Q?+rLSB/ie4ZyGB0tuJMUmlE8yZUYHH7kFlaDFE/dXHuhA71P+hv7LzTu+dmq3?=
 =?us-ascii?Q?0eSB5ek0Ak4gWdu/dVYrIMLKPjERtnoNHYq66FV/+8gQpMsjhdPVAzDo8fQt?=
 =?us-ascii?Q?0TQdtI0eInc/YCKeNe1VYwz2bzKNvH1QlLCVWxZ8W9QYFR35FfIlcfuyMBZz?=
 =?us-ascii?Q?mLOEcxZGJVZ7DrmDQzQimp184astG6fm1lhsVfFh4Z0VRpokL2xXhijE4ZMe?=
 =?us-ascii?Q?i3aI1Afh/ap5I2a0P01+YdycZFtg9OdoVy8zxVtNEqgnTdvBIThy/2/1AKOY?=
 =?us-ascii?Q?meqUK//8wa2srm/pTQ4qCxbTAkCCBMJm7t2eOijKfqrgvZjlNK/dlCnA1a+S?=
 =?us-ascii?Q?1mAMdiKVA28It1dYQhePkg174u5n50Tt89XVN2glLAPIJzVJOHXlHrClP4XR?=
 =?us-ascii?Q?lkPLZHN3cHRXdB8Ol63lzj03WlJVJr2C5BTfCJQaboOxnsn23vQEdEq3yUzt?=
 =?us-ascii?Q?OnfXrz7qB2I1JlY6nLYPAbNDa9uWJ4g7LQOLYTNiOGjm+t3wVHE+YCglNVxp?=
 =?us-ascii?Q?WFf1UlwPOIUfUWd1X2UU/Y5jfs41xM6ELUalbEXdpj53itB4J8HQBSvmIU5d?=
 =?us-ascii?Q?GUS5gcFx3aEBPc1ZzmCKemm5xaBwwgM+jgJ2v0/4VDAsm0WKF4o4+aFQSRhI?=
 =?us-ascii?Q?PuMLal+gXJtP+uLGHHdNuxoKb/+j469KH0W/tTYijIlzJVh3I9EuVAhN3Jl9?=
 =?us-ascii?Q?mwY5t6weJqCM1wTVAaWRj9nMgrKsO3xP5LrKZkOEubAqP47fT+rHfSEiT1Pn?=
 =?us-ascii?Q?1s5sh2wAtRanfR9XI7u+HSXMQXHRpQW9F9KRICS0GneAXxc2YTIUmFCyxob/?=
 =?us-ascii?Q?7qZTCvIrgRW2ECVhQHYcjrB7KO59rS4MF9oVd2GEvqsF2T+KNK5Gd9m83i19?=
 =?us-ascii?Q?K53AtNN49h/CECSj68p6njwlWFX1H0O957zVvpPDvc8GVev+QTO+WZFIPYvj?=
 =?us-ascii?Q?JPg3LBAOfZQgE9A6C+v+JyqFI/MReNgikhII5Crq67u/WrkEZSOhPLRk+/Rm?=
 =?us-ascii?Q?ieEd8D6cZPKt+r0KUH51n/TmmjVULKD6zy1D0Efl92UNunZbHVOMo3yDIriY?=
 =?us-ascii?Q?h/4boJeTGNkG6LTHSou54SE=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?CCmNCmEmsz4vl7FYnfsZzCyVmJG/g8JNSu/0saezVLN0X0YYFZ8iwQq6blgv?=
 =?us-ascii?Q?Fp7RpuFvrtJXkQ0O5bO28h1QFeA6v6luhZpnBcA5Cut/hvLe6oo17A7EFbAs?=
 =?us-ascii?Q?Zso5Hc9d9Y0LqU4MzT5WjdELbabtBCq07nlHuEvg0JQL7bxHUX2aT78T3KT7?=
 =?us-ascii?Q?39LECe21Htp4sjrtLEZeB/KPAD7MDt6bHauMJfM7IiGqEcnP+EqUSHbTiSpx?=
 =?us-ascii?Q?key4Po2TDVipyfpzNEehXYUt4/gmpEUtT//yv2gc8ZWE8nZI5MNQ8nV1xeA/?=
 =?us-ascii?Q?YiS1yfDZH+R+uqRaHpI1naac365x+gSmrdpOVexfncNq+c9f4d/v5FJTrGW4?=
 =?us-ascii?Q?w+wIp5QcxFJubFz5o5E3bf29Recoh8tXxDf70R8vCFrURCyFsK7uoXwE8zyD?=
 =?us-ascii?Q?BF6aPYcZfxpGXSwcVHdxxqLDHxhLY7Q5E8MWvM1c2EgpNNqC3ymw/wxtynTb?=
 =?us-ascii?Q?lPn2PnFosWovk6iyJSG9yS9CCEpYj/vCBqxgUDkpfvWc1yQQBAyz520vd+Lo?=
 =?us-ascii?Q?6N8NADVv5WKxylsl5QKPwzn1c7OfyJJgsLUDkIhGh1FKKOdHK15Hsl20f1f/?=
 =?us-ascii?Q?3HoFNJyJod5wLHgyPKQIbqALuaDPD9lft/DAtFE8kGCB8pZ5hNR0V6hc0i9Y?=
 =?us-ascii?Q?W9eFXsBD8cvv9JB4jevSjL0HPd1sA/oxWrmCJQDiPpVC08FZTmPp0ONybRJd?=
 =?us-ascii?Q?S9r79slp4/wCPRy/3Xhexwm9cIFIlCy6QLmj3AXe72JPqSh6aAMS60uA5Y+N?=
 =?us-ascii?Q?/blNFGRM3fPvIgM9k00739Dc2JHj6q0iUpyizQl6nsN/KOCsAbApXkL3Fr3v?=
 =?us-ascii?Q?01xdongcLlbMqrPs76fxb3QEbE0+lyQ/UOTO0kOwl9SxWBe3pSjhYGlXXwEF?=
 =?us-ascii?Q?3km+wiFgu/LoophKxSfD49f/gK6OhiopW+BU5LOYAfAh2+OL4nWCMyt+KKoO?=
 =?us-ascii?Q?fq5Cy/P8glURbs5KzLHnRaa8P8+XAuQSKc9NK2m4aO6F8wB9rwrvu7wMvSla?=
 =?us-ascii?Q?GJ4kv1Qq6lwsVaouueZmr5NBFTy/+T694t8qcyU7Y8rZvifvtniCRx6484at?=
 =?us-ascii?Q?8goyoL4nPayhOVm4s0KmBIzcGWi0QA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5534f1c0-ba9e-43c9-4682-08db00a6a249
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 20:39:49.2526
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4WU3eqAavS6pgXzHlZzjf8U3aUhhMYyuEqbD5OOzUMPfv6Ih8OEBouzPTgy8zQ1MTXuekszSEPaPMEKUufjkIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4605
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_13,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301270190
X-Proofpoint-GUID: t852A3SWCFGKr3eLB_omL9xVhnUAM6Hu
X-Proofpoint-ORIG-GUID: t852A3SWCFGKr3eLB_omL9xVhnUAM6Hu
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..791c06b9a54a 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,8 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>
-- 
2.39.1

