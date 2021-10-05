Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B03B4231DC
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 22:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbhJEU17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 16:27:59 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27446 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230019AbhJEU16 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Oct 2021 16:27:58 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 195KMI0c004481;
        Tue, 5 Oct 2021 20:25:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=TVploggTLzAYMUiQ7PlVT0vPB97V+1yo25luDcshsBU=;
 b=kZRaNMBwM115+Y9+zsQWlkdj8Tzva4kPNfKxzHjA8HtgM06AiFhwAWOs4oFBSs0X4oaw
 /YuYWwAhFK9UYD5qNwgCn6C1ahorihAlCQgKPyyDY3dw6/a457Qf9myRL2CGiCEmQyhF
 12TXuu25nMUEFBbEf5jJxr+YQrLtMJU7aH6hnYiWfRt4O7kpdZdBZ6iEm3JeBRS7+JzO
 qB0+no5aUab7KivusJdM1TnNrRePxzhSdN1OoC5/riF7FvTSOg5zwy3oTs1BakJAAxpA
 R9s3xExJGKNZCBPhoMFCI5YMwjJwhZel4dcR/Fk8ltttt82d7XaOS1JoRBexFLAGF6X3 oQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bg43e1um2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 20:25:49 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 195KFvxn134660;
        Tue, 5 Oct 2021 20:25:47 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by aserp3030.oracle.com with ESMTP id 3bev7ttj50-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 05 Oct 2021 20:25:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lxh5IpjF06YS1FF4N3P52pISe2bT9i0+vz8H03BxwG2LgQXBtxBVsrmRV0ONxemHDfr6/x/HiXjsBz4yVPw5pYFCCQC82jnv0a8GgwyTqanVNnQkdiTX4/9vvjdyICfM+RniAPVJzPKp1Nx+miHCTzzr/QZFrgbm1LM3hMZW5zalX5DhCwuoUhb51av+zHREsd94+nAFYz/NcnGlj0mEQ+asJfJqeZwfeDxED5gEPZDaTu8aTR82c6FnKuy59a+o41PnVv1uWwUt2WGYmQ62IUHJsoaADyUyhVd3IfY9SjtqBxbbvo3Svjo1QDYhkfb+9ySssNije3zwXLhawMWxRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVploggTLzAYMUiQ7PlVT0vPB97V+1yo25luDcshsBU=;
 b=gYUs1KjvFTChFusmxtU7+BMss6EmTB/AS6CItgDmbULEb2OPLTpTty2VG+mVg6CKVOeoI5rQhG6dLC8f9wyRw3gWXfVQ6binMSWHOyd1c5eSCGVVYkb7s+/2IyBmMmiFrS+GDLJdDFp5CV9vP7zfYkAA97plkQPiv80JZBdo89O/Gl4vPPQC3OqdDjxlt+5R7AgfNuET8+ebjSO90lbaklCOwWnnYdRRLfS5+r8Qdd67u3uEy/vPJ6Zhk+2SF7w1ETGmEht+ys+Q7ohxm2hqd+91ljKF5knKds/LUyMGgYGx9bDjTFTmGZE4l4Mqg/mY8OXLu1iDOtHOpsfqLb5bLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TVploggTLzAYMUiQ7PlVT0vPB97V+1yo25luDcshsBU=;
 b=zzPbB8x9+8eCLB6bjvvM5ZsP472LQrpiyQ3yJ9HPTQO30mk6uFvF15Dyk6TvUijASsxZlC1uWSPqPit23n2nRv7dtWQPhJZM0GrvUn2oX1uVADL3ULFvBwJgUHaNd05Q0q7Kkpj6NV6W9itmCYNtiGpnmvbAJgUHMhwYHvReMzI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB2695.namprd10.prod.outlook.com (2603:10b6:a02:b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Tue, 5 Oct
 2021 20:25:45 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::bc59:71de:1590:cbf5]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::bc59:71de:1590:cbf5%6]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 20:25:45 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Anshuman Khandual <anshuman.khandual@arm.com>
Cc:     Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE
Date:   Tue,  5 Oct 2021 13:25:29 -0700
Message-Id: <20211005202529.213812-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR21CA0045.namprd21.prod.outlook.com
 (2603:10b6:300:129::31) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
Received: from monkey.oracle.com (50.38.35.18) by MWHPR21CA0045.namprd21.prod.outlook.com (2603:10b6:300:129::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.1 via Frontend Transport; Tue, 5 Oct 2021 20:25:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c06826f9-6260-4b17-00f8-08d9883e4f02
X-MS-TrafficTypeDiagnostic: BYAPR10MB2695:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB2695E5DB2CAD8B4DAF3BA502E2AF9@BYAPR10MB2695.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lwFxBIEvXX6LxWiKu8lqmLiGJ3bk5u/bW/f/xxkIk6wX+7jtFx1BZ8Enpd/vCPMk1Q5w+hSNnPpD/bePzqoOP3Eff4pJigvLXhcY4YLpZETdVoTLBwhU+1qdkWhnNNvul3B6yBVz6HXsDEwp4dvQjtU1uRqYYtWtlKLCOVL6S0u31kvvwR0Gd+yVArYPABP+C4vrGkWKhv0X9JH0QlDjpKhVbDj56JKv0M3cHtxO5BWiyXeuQZtoIw+jhjTY+CsJxODlsGGduIDEDb8XY1takOnBSdk0b/Bmc1Rxh2mc6I2cSEXarRPexuxnVc/WGCfAXls99shVwh0AK/sXwlQfP9L4pGZ69/IfGcQdfQTdCfmnnN6Di7mksGzBZkVT0LovMurx3/q1xqxxSjLlK9lCaYYoXFilaT79yPKysuyvyOOEXtF6mhTtXmfW5eQbITrAMB/0zXiZg0dsJToLmY9fpjT75PdYXqmIaNlstVNMAJNwp3X2ebmkq5tZICl7wrMXrv+Nv2ekKZZhWA1ZXvbM5l2G6JYkuLaGFbZ0XcuUcSILTPwcQ7MAqQWxngMlVwGT1XFzigkAYNKDeXLBNO4wjpVio2wFy8GqEPoxowWHdhnpsL2SLKqDVrv7wrDvRxePwV/5gc1sh+cqcePcVM1Inb33cCCocDz58vYwCCi0hHCp2MTjv5s3uLyGlz3xan/5CauVxSp9wz0/f7/uXX+qgg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(44832011)(38100700002)(38350700002)(5660300002)(2906002)(26005)(186003)(956004)(83380400001)(52116002)(4326008)(2616005)(7696005)(316002)(54906003)(6916009)(36756003)(4744005)(8936002)(508600001)(6486002)(86362001)(66556008)(66476007)(8676002)(66946007)(1076003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3S6wkK5f7MrmcX/Etzo9GxjYCXdmxH9b6kfrPmvq63xadO2Iar9KlzOTijKF?=
 =?us-ascii?Q?o+JY1nIhFIY3MfWENiMhzNLE+UjFOhbFe5JntWqIUAifYu5tPJgaCNqodKY4?=
 =?us-ascii?Q?nd1gMlUDZ716lgR8ZIQBDLZVu1ZUxw1DXg+VkKC/C27l6WKNHyaMhru0YWlo?=
 =?us-ascii?Q?pyicevM2WjmgtM4vdNJ5pmjadi0MItCZhtrF81VaiD+N1cYgSYcKOKBKdnUR?=
 =?us-ascii?Q?lvf6/crqBkCGM8oF5k+OVjxwl4ssyUEakp9Sau+ryH1xKjY+dS64jNgu99ou?=
 =?us-ascii?Q?cvSsYgYmepiDu4diSvXMpFkcQD9R+omRBjTBAqEaWorfrgWkrBk3aR+2G2t0?=
 =?us-ascii?Q?6BYgycOZs/pr7QqpzWbM/Oua0KusaonJJT1VsaenHFUYnOxkLJzmlJAR84+J?=
 =?us-ascii?Q?DPwHvRjJCTAJtxk8bvYhTya6dMK3TbLUypED2uot7KmKh+QcDxFAnToBuQwE?=
 =?us-ascii?Q?Nv4YBBxrOiUtzI1w6iig5eLc3tQ6iS3DahXmHS1Gzl3wupr/Rp0XRfOEJ+5g?=
 =?us-ascii?Q?a5HIJt28oL3kOZejs9RH5UxbRDu0Sfrdhbnv1gnB1TBv1sjZ7ioVmWYcoF7J?=
 =?us-ascii?Q?KIaJrRo/mRADktUyYYvQYanElHIWQaodMtX8WoRJq3GSWL2fzT+SSf8IyxLm?=
 =?us-ascii?Q?mYrm4SuPjvrT+taMFaLMBHIgmebgQysjC/xCkcf6fmAiXH0Pj7eH++mZriGr?=
 =?us-ascii?Q?tC8MZ+2B/V1+Aar4pUdYqNgxXUFfa3Se0RFWA+y/1sKKq/owwwTEVJcJwVg3?=
 =?us-ascii?Q?815ZekKorQDSJC76S9kvM6tY9awLIib1VbWbfE9K3zdTf7qe/PZpj9hYQNve?=
 =?us-ascii?Q?o8wYrz9EFyX7WCDFhhOpICApNKhrYCahcN9GhqcTsD+sBWG31aU7/M9IYD2A?=
 =?us-ascii?Q?iyH0DfIrIGUm2rB+p39+3ovRF8pn5I4RjZRvqqQCQ3ybVyef1udcE3ZqQvpZ?=
 =?us-ascii?Q?0G53+qdxxiVGSgx41WogD2qLa4dvmjh4EoIrXk2QYmRM7IDTI4b+LstaAYiZ?=
 =?us-ascii?Q?ygPmXEU78CYSWrDsIto1YzyLOrXXA0yXSeiv3OkVgTefcJxxy38EVHwVCaLG?=
 =?us-ascii?Q?qX01TaFLfQjFe6bcWVqzNgd+llIB7ubDyTLOxm4Y4x1LLQ0kbuhwGIO6Bl7i?=
 =?us-ascii?Q?FcraYj2RXLyQhp/Niphg0AUr1GO4xTsJtQFG/qSMdeUMtw3E7fixDol8zRcK?=
 =?us-ascii?Q?w+tP3ZTGT3+BFXEXA0TyOiqW9EkVVv5haUK3r6IqZWcAr4TpyYYsOIyuqYcQ?=
 =?us-ascii?Q?ztn+A+tviZlKsFO94SUPNLYS+s1/DH+qPaWrtjDjMMlrZWiW46y73ouPtTrc?=
 =?us-ascii?Q?G1yfBYxQ9PsT7Y4E0PwZUvKS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06826f9-6260-4b17-00f8-08d9883e4f02
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 20:25:45.2731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NxLh0BUlV1+qdWynVTRfjYC+Czr+EKWyO4e46/lafhQKNLvoZZ8+bxKWuYBTZ3oDIHmiFavTkN6hmFrwfvRMQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2695
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10128 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110050119
X-Proofpoint-GUID: Yo7K6qSmUkJhqGVU78fP7GUcfCsL2CJq
X-Proofpoint-ORIG-GUID: Yo7K6qSmUkJhqGVU78fP7GUcfCsL2CJq
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
CONT_PMD_SHIFT order.

Fixes: abb7962adc80 ("arm64/hugetlb: Reserve CMA areas for gigantic
pages on 16K and 64K configs")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 23505fc35324..a8158c948966 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -43,7 +43,7 @@ void __init arm64_hugetlb_cma_reserve(void)
 #ifdef CONFIG_ARM64_4K_PAGES
 	order = PUD_SHIFT - PAGE_SHIFT;
 #else
-	order = CONT_PMD_SHIFT + PMD_SHIFT - PAGE_SHIFT;
+	order = CONT_PMD_SHIFT - PAGE_SHIFT;
 #endif
 	/*
 	 * HugeTLB CMA reservation is required for gigantic
-- 
2.31.1

