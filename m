Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8292A67A4BD
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 22:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234829AbjAXVPi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 16:15:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234712AbjAXVP1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 16:15:27 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5729251C42;
        Tue, 24 Jan 2023 13:15:20 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30OKx4Cg024819;
        Tue, 24 Jan 2023 21:14:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=P7RF08IFjPr8u101M+R3oBptWf9YNOkkALVPZ9ZHtPo=;
 b=GDKMbWVmZ4aSmpwGQtGrNDpT+waZZf5M6gcDkQvXtkjBmKJ0oAJF7kNVMo6ACreCxtQq
 hYm9YtAmJCFuXtbCa+d1SCJiI4gfZNlGKk024ucX4RNXZH83H2fwqIIdeg09WjuwPd7V
 jJupu5rkUchOLR9+Td6dnXBoPwpG+LLyD+P+djxjy6PNrjrIEamVB9NjR/TQdaBVnVlD
 VHT7u/kFiylfxbS+ucsFRzgZLsWwyR3IMhe+I7kQJUROzmJ4ESq91Z7OtiHcD3kzahcp
 FsawfhwCwuike84zYJy3zIikgDvsOFQMIDFj4Z3nS3fdKZIl3Pfmr0dlngvXJF28moPg /A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86n0xhnf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:50 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30OKXUJT025295;
        Tue, 24 Jan 2023 21:14:50 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3n86g51ekf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Jan 2023 21:14:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XPQtKlik97tzBsTCN3M5lvcKdJK+7EfVjgv8L+GD75CjPy8OqgycPxAmBFmNintTChVE66UsvufMk1zym+SmFmoWSIY1jhIAjJjk0rTc+nLHrMB45JYoyNWKzCcinRBVBdLedbmS5pKTrhW3ZrpVXKmFNy2gHC9du/ObDEiHUncONaph9JVFiuhXK0ZS92+ezc44hQUWto3og2NoDnmFq91/6mDQ5RHhw8guauUfaLM8ZwRHYCoMck3c+tg+dSbFRmasyuTGhOjpf9uwe2pUztKxjTrIq49YAUkQ0UY1L5uJeeZg8EAGAH2uSSjHKHo91Sy9jYxDWGiI8MfSwCxhNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P7RF08IFjPr8u101M+R3oBptWf9YNOkkALVPZ9ZHtPo=;
 b=G2uc/G2g5Zb4iW40o0+lm/6DU9RDwXTdDPt+TEFVec3lWIpFkfcibdtpNer/J/Pp/etRJPEYLOh0cKcGSQap6Y6Ts+MP9pJvOeaC5hun4dNjNsjhY/ezwSzXh9e0TouZRbQswE9fZr/I+wKr9A2DlTnBHGiev4RWmNQ1PpUKzhKcCyo4n1AWPStFxKWABBdeJmws1ofWLQckRr98cgTVOiXCK1qy4Q/z3qOxhg3EdNYLMQb1lNskj4er/glNcPukCJg5yA6d5f8v8FV9Fde4NpVS/hlNAK8hqp2UoQzf7qrYN1+cQUYw3VWWsbqI1sbbYSnluAUx8Iq0Yzn1uLssdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P7RF08IFjPr8u101M+R3oBptWf9YNOkkALVPZ9ZHtPo=;
 b=GGaYoFrFtTuNaMm6f/SG7rXGJpdGH65e6ZToqVgWW2C9/qThVetevz86VeFrRQtASezmYazlPcpJMicJDhszdA5YWB+n1XX/gMp+2xma5C6Asa2RbIL6FMFhh6jSG4M5ak9AW7TSJyO4YqF6IEx3IyX22QbKQRbz8XitT2Z9rNM=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CH3PR10MB6836.namprd10.prod.outlook.com (2603:10b6:610:14f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.17; Tue, 24 Jan
 2023 21:14:47 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.014; Tue, 24 Jan 2023
 21:14:47 +0000
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
Subject: [PATCH 5.4 fix build id for arm64 5/6] s390: define RUNTIME_DISCARD_EXIT to fix link error with GNU ld < 2.36
Date:   Tue, 24 Jan 2023 14:14:22 -0700
Message-Id: <02aed8d0fad05a87a02c226d8e9f55792e41c47b.1674588616.git.tom.saeger@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674588616.git.tom.saeger@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0103.namprd05.prod.outlook.com
 (2603:10b6:8:56::18) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CH3PR10MB6836:EE_
X-MS-Office365-Filtering-Correlation-Id: f8c0a92b-6321-4220-e5a9-08dafe5005e4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4GuSK3gsSdmrlceuFIIhSl2lRVhx2qaqkW3pGTO2ZUcCoB5/A8Z7dDUZl3cdONqdIh8yyL5Bb6s85AuhYHdsLZE4/Gq5Dgn599g1S1n2VYvFMmUG3vkJGB6SR2x+wKKEcbOycapavgtQUtdyfgL15Y+wdymaU4+Ad5wz3UsSA1P/Bc+X4MLs5OoVzrqde2LnIUP0wUAGDXEs7Tw1ixQwPFNElzRxnbnK8g7epNMH3PbEItV37t4XsVCH9yMYJfKwfyUHQJciUlBiaMwemgDGMe/XpG6CFstyWUjYOJcsSuoXtEcCoO4HL+7FVjVQV6SOxCsrdZSV+CXOu5ofHAY2mWgr3PB6L4jirlavAt/fv+jkRViJohvDRl+CwtXrn6wvEkik3XSIi9NTqqN6g16DiOErcvXLT9Onqkyp2h2T6bTcb4FyFFdtP/4s++tROoc7ErU9wOC6VCk6axY7OvgOV+26RN45U3Qkp/ug29oFY4RY3f2txHBlIrTYaxjU3LcxcTLeKS4hkRQareTh2CUiZxTfqGsgi8sguUwbqYqiR/MhueMzIhySy6fJtIyPsI/BwRwFHvzQVn4XZ8B9LOSBt3G3RICvuAUSTqcDoPaoFY2Pq/vviHCNbkcWRSnFROvtNRVWlB2aWbG1v215OJyNxL5HOCe8R9fJQ9uhSLZ+GM2KVgAL4/zDS/BY1OY/3z/orhzBQtWmqG+65ylcdwQ9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199018)(66899018)(86362001)(36756003)(478600001)(6916009)(54906003)(316002)(2906002)(5660300002)(6666004)(6486002)(7416002)(66556008)(66946007)(4326008)(8676002)(66476007)(41300700001)(8936002)(966005)(44832011)(6506007)(38100700002)(186003)(2616005)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9muwmtxJ1sklos87YcF+C4yYGHC0NMSJ3/Cou/QG+tNgMsF6eyKHtJ/G/uKE?=
 =?us-ascii?Q?7gX6+//BrJsum0dVRqe9hJkNtAynOTGkRu/QwEo0OEdKrNt1Jmd3JAxE96Ww?=
 =?us-ascii?Q?DANz2rtMiJoMBlkJ+ejfp8+qZMlo9Zg1q/FxSuFS5M7bEQ4mSaTsiXy4W2tn?=
 =?us-ascii?Q?MV8yzRwehKqlFoyUUMOAlvvPegJaGbqXgloSxTmFNxjxcCB/uBF2YO7uhFfW?=
 =?us-ascii?Q?OiAcMw5Smj8TDdcwhZ/KP+QdpFGzAy2CX1xQKmW8wT8vNvvrSgoYQu8YrfWM?=
 =?us-ascii?Q?yNMwxUqLJN9FI4DGNEa0dU1mQ/40gtVFJKcT4AHIstthjwF3t8ObMLG51VFs?=
 =?us-ascii?Q?CiK8qLYgwCgkXOQWdJnUxsuhG6SXNd5GdnoH567za2KL1JJhaBaMfSiSKLqS?=
 =?us-ascii?Q?RDi0cjscKOhduEiItBcuXMGmZ2ISJxEIwZf3kQeknahIcmwwcdmM30AX/btl?=
 =?us-ascii?Q?9/jFJ+58BSRX0po7RAqJ1CbrqmY3/t/3mgrwu7RaXMtL53WMrgYiA252Yi5F?=
 =?us-ascii?Q?w6s6tlC/3bIQFPPEBwbOohSxU+xufGRKA9NCDG5WAZsvCWtljL7Ubrc6PtkH?=
 =?us-ascii?Q?e/wABxWs98XyEOEcllg9ES98qp8Ghqt9nwlPpUmANXIeYArwORYYsICCXjkI?=
 =?us-ascii?Q?a7hR+kBjqp8GmWt3IpHr1/1WTmkO8tFY27ljEkfqhW6KgKigXrag6K7eUQCy?=
 =?us-ascii?Q?mDTGvRp2jsSb8pTMgzzEN3cghe9L6/DiYTkxLTHFCTUTfM+GtJ74mCP/Adfo?=
 =?us-ascii?Q?IhnJ3eos17v3XP/VL/KLfHPZ9DaEnWWvtlwjcs3WfAJxd2tFbXZMTFkOoaBf?=
 =?us-ascii?Q?P3cx7ImvCiMZXYe0JrCgtkDuwyJzU8ZWrq4apJqtnFLLJs7nyb812WBkrUWV?=
 =?us-ascii?Q?lHCd5h8Rqygo8g+O8nXjaZM7nWd52cqHOYLDkDjvY8qj65X4a9B7yqhlYw/a?=
 =?us-ascii?Q?3xhxttb2McG15xqtgjTrqej0BkjOn7Pqx4ZeyIuunz0gK9dUNYYg3wPAViNZ?=
 =?us-ascii?Q?JMrMdOGJYPmDvZKQazut5vDiBpLQg97ZNTSxl2bEkdeu0VnuH2abYzyVTiz7?=
 =?us-ascii?Q?l2jXWfG/OskvmxB2qoKadikykFHTWQpnJ+7DEX03VR/waSn4vnd+fO7hQTle?=
 =?us-ascii?Q?o4dsMIRudRFnaDFgkH0Gv+VC3NpskFLqvLLbI+iytjlsrMRiPEDHk53hCmr2?=
 =?us-ascii?Q?l9h8Ydjeo4VCiZxfMBn85XtfWwyCkSx/E4BtSr6OxpsiwwexH/sLUN0cYVct?=
 =?us-ascii?Q?NQmB5tO0BK+TM37OIC/sRRvRQ+jnIVtaz5epYTRw4rMipsAS/a5YRDeMCooH?=
 =?us-ascii?Q?x2jJ/ecsuajODbs/HNPEBrvtV8bIyW+dvmtJM6rtpKHjsDxTzFrOWScYBIMq?=
 =?us-ascii?Q?7rVdNNKlPAhRtGb2vsMJfy076vXKtGiOOXUh0Nyx1HRyCQ/4jWJqpgpPzo1d?=
 =?us-ascii?Q?KaB4V2GL37UsaWJUkd/DRUyypzB7QF0a9TtqE34m17Qk68g6YPc7TRVgLFKy?=
 =?us-ascii?Q?tTJJxlCs1gHHlAhL5wMKEe2xr+N6wruY02F6YoH9OtqydoEeg8hx9Zlq48pi?=
 =?us-ascii?Q?/aBqfIVnCtcG4SoCSIJsFBcFrbwqjoUNGEKR6ODs6eX3REVPbUqkxUVagi8Q?=
 =?us-ascii?Q?v46XzAsl4GgPo/vVIK5RjTY=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?pgJU/ql0PDTe+eYiqdXDs8Z24IYSuMejtq9ba4nU0r8yKCf/J1gzoe9Up8rG?=
 =?us-ascii?Q?qECL+eEBPXvZI47zcAdZebAS5CiF33n2PCpOi1Y2mJYXa4kT836YeUj/wgmE?=
 =?us-ascii?Q?MCTXqy3PuMZzENu9ean4qezoAbVRpwYLquBtW/QjQe6Fw6AtPNF/yzT+RnS7?=
 =?us-ascii?Q?NFfYP+gQbLtp+8pGGc7p51OqOuRLhOmpYuDmq9c6mh9LVeNxANVE5K75b45n?=
 =?us-ascii?Q?iD42P8ITQkY7+VQ5PmQ1+rGeT4NwcfLgvz7MYcTVgum8gsM7ac1GJLyTa1Qw?=
 =?us-ascii?Q?huST+mJYZwnGJ068lzglH/0HEwmhMqaIuQdiurPW8UYLnHBkMprDcsKcgmlT?=
 =?us-ascii?Q?4krc39Nixh+ytGSHYz7cp+v1NWWLSmmQlaxjTZpzG5BI3rEqy3esG68AhMKe?=
 =?us-ascii?Q?S/X6MOFEvxavy+rzt8AaAm3t/nY+2Rvl8dCXXv1f/Xm5mnzrvLekiev+lkPP?=
 =?us-ascii?Q?MciI7er/nTCNh57fMgs4oXwXYlzyrb+h7AabagkwVkM0pE26KjrGJwVKOGCL?=
 =?us-ascii?Q?YY1g6v2m8OadTb/ibnUH/jybs6kwkDItNRg7IYum8YukxXcbgHlxo7I+oVKb?=
 =?us-ascii?Q?YBIXtkKhhhrstMBve3hvvF99aVeYEjPh00bGNu2c0ouWO3IVFc//f7vZHxx9?=
 =?us-ascii?Q?JZBoCHOexDlsGS2pDIAWrjZk7MxyFElDBhMYDYZ8UyIK/cKjP9SrONPa+Fbx?=
 =?us-ascii?Q?jf2seAmzocPUTIuSGlCmsBnLjHRoUZAhGzxust+tQ3JnWp1phhH2gCD/N/pt?=
 =?us-ascii?Q?rIlVN3KNIHXBGKAq1lI1Av4sYvJyH/SWIVcONwiTQpOM3k6RLVJIlKm3lyUJ?=
 =?us-ascii?Q?KoUPLLmahJ5TbS2PF2JncpNHKI6f093+KS6MOm0CfC9SphRFuBCnxf9lPo7a?=
 =?us-ascii?Q?E3Hty9/drgz1vjwB67UMnUGiJqyldWZuKExDTOjPZ6yahpFTAi5CSD+TsNmG?=
 =?us-ascii?Q?nqQkUULkgIlp6ZfyaqO5pI9Epva6TLL1npmdYhDJH29AVDEZZ4QDy10ovumX?=
 =?us-ascii?Q?um8S2krenRPptWUYykdNvEnKKw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8c0a92b-6321-4220-e5a9-08dafe5005e4
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2023 21:14:47.8103
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5HnoQPziUDrjSbcPzhjnRffiK2QZA+mDhAtSGG7ln2wNELUTXZsus782ckkiGn4IfeM2IP1XgV/v7FcareQvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6836
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-24_15,2023-01-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301240196
X-Proofpoint-GUID: BPviMx7RtMB6SsvqEZRNslQUF-Yno3nq
X-Proofpoint-ORIG-GUID: BPviMx7RtMB6SsvqEZRNslQUF-Yno3nq
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

commit a494398bde273143c2352dd373cad8211f7d94b2 upstream.

Nathan Chancellor reports that the s390 vmlinux fails to link with
GNU ld < 2.36 since commit 99cb0d917ffa ("arch: fix broken BuildID
for arm64 and riscv").

It happens for defconfig, or more specifically for CONFIG_EXPOLINE=y.

  $ s390x-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- allnoconfig
  $ ./scripts/config -e CONFIG_EXPOLINE
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu- olddefconfig
  $ make -s ARCH=s390 CROSS_COMPILE=s390x-linux-gnu-
  `.exit.text' referenced in section `.s390_return_reg' of drivers/base/dd.o: defined in discarded section `.exit.text' of drivers/base/dd.o
  make[1]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make: *** [Makefile:1252: vmlinux] Error 2

arch/s390/kernel/vmlinux.lds.S wants to keep EXIT_TEXT:

        .exit.text : {
                EXIT_TEXT
        }

But, at the same time, EXIT_TEXT is thrown away by DISCARD because
s390 does not define RUNTIME_DISCARD_EXIT.

I still do not understand why the latter wins after 99cb0d917ffa,
but defining RUNTIME_DISCARD_EXIT seems correct because the comment
line in arch/s390/kernel/vmlinux.lds.S says:

        /*
         * .exit.text is discarded at runtime, not link time,
         * to deal with references from __bug_table
         */

Nathan also found that binutils commit 21401fc7bf67 ("Duplicate output
sections in scripts") cured this issue, so we cannot reproduce it with
binutils 2.36+, but it is better to not rely on it.

Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Link: https://lore.kernel.org/r/20230105031306.1455409-1-masahiroy@kernel.org
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/s390/kernel/vmlinux.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 4df41695caec..a471bd480397 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -15,6 +15,8 @@
 /* Handle ro_after_init data on our own. */
 #define RO_AFTER_INIT_DATA
 
+#define RUNTIME_DISCARD_EXIT
+
 #include <asm-generic/vmlinux.lds.h>
 #include <asm/vmlinux.lds.h>
 
-- 
2.39.1

