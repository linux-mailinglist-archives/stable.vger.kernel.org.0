Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32DE731DF3B
	for <lists+stable@lfdr.de>; Wed, 17 Feb 2021 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhBQSuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Feb 2021 13:50:39 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:43580 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232565AbhBQSuh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Feb 2021 13:50:37 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HIhdkS030434;
        Wed, 17 Feb 2021 18:49:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version;
 s=corp-2020-01-29; bh=l3BG6/SVEWI7yKMIu2dZjARVCsDlzZwVhTKqA99H6yw=;
 b=GVfmwWHSKd6x4uaPafIUUsn7MqmCpCYVJbgbOu5Q1pHNH+zfKA+hVLGV2vT+7QYq89Xz
 5+09IWzEwMUAym+XqCpt8k2JojHXRyL52bAaHAtdh8IZe5BXYpoV/ifJMCgz0xcWEw3U
 Zc5C/YKlD43wIrNLYIBDRpfTpS9JHcbAL8bvCGnMtWxbLC23lN29z8wiRok1aavn2ceR
 3FYWA/yrZPV99Kpo1AxgLsTTh9q3zQMcSeiwQQSVvb5rJ8+YozxHXeIgXU1uPOa/LnjK
 vJLc5p1BPvvpTord62AHstxUk69YVZSHZ0vkzJnznCdnD2N/MN5ucFkM8L/iPKkQAYqz vA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 36pd9aay77-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 18:49:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11HIkCpU142816;
        Wed, 17 Feb 2021 18:49:44 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by aserp3020.oracle.com with ESMTP id 36prp0jyyn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Feb 2021 18:49:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyf2d9khDjVabht6nZnHYy3Oq9Bglg2k1Q8bgcVdzXdb9tYQ889HkJOBuIotYnCdhSP+1oNYzOw+HehbDQdnDIeIVklaooqqS/+iNVeVIKJ5oXt5HxXMXYFaymRH0VZokxG/AM3cwfUWoEyujH5j8Rv5m6rDIhoVXD7mCwDSdiDzmiZkCuLh620PB9B/e2bswr6Ej9Lcruvc7Y6jMgYuGD4VwSnrQJ07Z90g/AVu5LLzm6A1vmoY+CCZSfA/ee3PRu6g4f0a8hr35acvbVoBNv5j+LY5cQS/xKngd3zjgO3I0N6hxgfxpcnTRr7Rf21wf4kAQHoUamq3q/FaGLqnbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3BG6/SVEWI7yKMIu2dZjARVCsDlzZwVhTKqA99H6yw=;
 b=hoqlye6XUbprc9N2gyn9zTbCjuOIqaWQ2JyDtDWP6iSuolwalQTA9Cen1YyyWDkp5wYiMl/KV1Mbzs5MLW/I9wnHSt2s+GTKx02aW9tJ7pcnEyDagLJWipUQZVWh52i0nbYtLkogXOCWHpvkj5AjxeRQ9w6dGLzjbgAAVFX/WTe2ocFNYfWng0YYjEHTKiesfXUa23webwOIgvpk5xNX0XPT7Pbgjzce0lxctqb2vpX02wQ7OLC3hLn2y6RYp5akShZbvaTT/D2nQe7830H4ly1kGwg/X1HzHlt6zs9Mvx7/gyeGuiZB2Jl0Rq4LdTmJBMEIDfRU37wZlby9Xj8yCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3BG6/SVEWI7yKMIu2dZjARVCsDlzZwVhTKqA99H6yw=;
 b=uhiiwMyDXXpcxqyo31JoCkzrdNYVryf6tNk8czU7IFIlQ01MNNtCr0IT8e5860WO3JRCXgEmdoxMJ5nDTaDLQ0cujZ+CrqzQGHQnE0uS3RjfmFRc3yMz5ixmR6AaaWs2qUujm7tb/n61Hwmcxatkugha1ZeCNcapwJ1cj0w8wS8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4445.namprd10.prod.outlook.com (2603:10b6:a03:2ae::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27; Wed, 17 Feb
 2021 18:49:42 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::e035:c568:ac66:da00%4]) with mapi id 15.20.3846.041; Wed, 17 Feb 2021
 18:49:42 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc:     Zi Yan <ziy@nvidia.com>, Davidlohr Bueso <dbueso@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew Wilcox <willy@infradead.org>,
        Oscar Salvador <osalvador@suse.de>,
        Joao Martins <joao.m.martins@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [PATCH 2/2] hugetlb: fix copy_huge_page_from_user contig page struct assumption
Date:   Wed, 17 Feb 2021 10:49:26 -0800
Message-Id: <20210217184926.33567-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210217184926.33567-1-mike.kravetz@oracle.com>
References: <20210217184926.33567-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW2PR16CA0050.namprd16.prod.outlook.com
 (2603:10b6:907:1::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW2PR16CA0050.namprd16.prod.outlook.com (2603:10b6:907:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.27 via Frontend Transport; Wed, 17 Feb 2021 18:49:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d749afb2-f0fc-425c-b9cb-08d8d374c961
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4445:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB44459BBB8BD7956AFDD41A8BE2869@SJ0PR10MB4445.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HMXE3NWKBLZflrnbWL7SqJknDwIiD02HyMjIBqNMcj8JYjVjD7HEX6D9reqptIn51XP9qGftQHh6o/qG5XINGUu5uvebdV5yNqKqGKETatVWVoZxbxdoiH7n4r0JDbCMW4+udg0NTO6xax3lZJXIl9QvKSXV91bqKoLR9wUdZ9wyzXsjVLhRk3/qS0KqfFqzEWCbbaRqElrfveZFSp+orUuSNLTDeJwbqoDKYDpJevvrGT7VHkJci777L2UDvuW5ITWMWkVOqQWCCBXQz0tjWTK048HGACyomgnJ4SAce5vOgVSSGUbui4ZzxEPApx468ORot4I1AJdapx7iERD0MZ2cZXK85iu2uFv5dereDcDzHS9IxVY61/uhDGUSnkPLG/7tvFk3gPpkAwvFR9nS+wJRZ9TdsZQNG6DrBlE3ViKQxjI4+M1+a9pECjovSlU2Oe1xusRq9Pgo9vYudYYLUcvkKMZFP8BL656hoTMHn5CZcY74mYM1HDtTmThnxSCzi0JLhiDNsWyYgfiP3/e3xR/mjFTOIxpWnNnxc6GHyM4EuH8qMSK3y/j7pMy8q/IZ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(346002)(366004)(376002)(4326008)(86362001)(16526019)(2616005)(44832011)(186003)(956004)(66476007)(66556008)(66946007)(83380400001)(36756003)(6486002)(2906002)(6666004)(316002)(54906003)(478600001)(7696005)(52116002)(8676002)(5660300002)(7416002)(26005)(8936002)(1076003)(14583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y/pqZUmThPbtedpjBogKpx1x2yf/5Xvc8lsnXleAngf5AiGnGhJ+L7pRlB6E?=
 =?us-ascii?Q?pvfnxmm5XQnoDKcXOYJJt1JcTh9pgpqEmKSl+dOjbxGNZu1PaahyqlHvxYtS?=
 =?us-ascii?Q?+vOxVo+qTjwK54o/lRR7Hfiz7gTzx/Y/uexLz6gjPqeM6XqNNnJnn3wDRVRV?=
 =?us-ascii?Q?toAL9Tg5NoJnWeef9AwSbYiPY6cz7nThwwbJ8Bxy6cOq35U9esPJpPXuMzri?=
 =?us-ascii?Q?6AAjBqYFWHv9fHik3btNxLMZ+mCmSD5aAdEt7cPB2qy/TkUYgVoQPKKuIF/N?=
 =?us-ascii?Q?vSfJiRD/vzI+rdbAq1Yb/eCHHiGtPOT6SvdtgpCVK4fmU8i0Fog78wITtwdb?=
 =?us-ascii?Q?4HuGWJwnVsKCtnPnrr4WmN6cJmWKeNjCHAgo9LYC/hpBNpmbgIGtzVosFALi?=
 =?us-ascii?Q?UXlcpg/0cJ5zOJyhXfnKP9Sewv16I4Ackbt+7/tk8ktRYhvVkshW/isyufIQ?=
 =?us-ascii?Q?l8+nMLIyoFEw+YJCUFpdWj/CF3LEkbhYb4XVlmr3BGK2eAY7lGGfr8puvOqY?=
 =?us-ascii?Q?t5WzHoyHXRedvPzvsHykeI8RNhRV6tNIbCpJOuOBH70hS2f++Mz5m7jZulJm?=
 =?us-ascii?Q?RE4DgEHOEafTjpRFmAMNBfCQaPuhdMh/SF9PDBM3obg7b9osdbS1SiqyEJFW?=
 =?us-ascii?Q?V3M1X6+/L1SbyDs7sQKLCDfNZnSkjUaCW16NhcnLc+WHHPB+2RayM8Fd6z2m?=
 =?us-ascii?Q?hyTtXjrFKJNpz8aNBYy7i2MkI88DdstCQHP/WRgnkYNlYusR1D1QkPP6sTQN?=
 =?us-ascii?Q?Z71X8rEs054Z8t0p24PycsCb+F6sdIft6PwZLLaYVhSo8tpuZxQ5cHO+ApSN?=
 =?us-ascii?Q?hQMykJYycXD1QzplbMJvuY1WtQYKrHeC9mpY32KUDlRFHVTkdFBCJKWzK2gs?=
 =?us-ascii?Q?WJINWUbzi1ND6NIUa2EKi4S6M/nCnCl/uTpslNtwOx4437xr700x0CTXc3Si?=
 =?us-ascii?Q?2yQxqXBazhuSIHo9QOvo+BmlAj+rNgny+LBP2j3W+iSXvdDV0lDq2sorzoRB?=
 =?us-ascii?Q?xAm7BDFg7JrPQiYtwkB+7PycYYg6oN+3PYrUksCxwBq4BYQPpho9VTG18t7B?=
 =?us-ascii?Q?KjFQmP52VIwZqZHRCApY1PfCsbfziq9daE8XH/LGruEPWVnA++ir1lPWoTUO?=
 =?us-ascii?Q?giGHzWDzOcmUt5FpkoUFp/qxRdRg4O6B4yGhyk8swRF/G8x+aVT/LXtvSd1l?=
 =?us-ascii?Q?ssvXz7E0AiIGsAZ16spuZP/42pEz1YqIBdL4MrcoGXGFif1HJb2mbnFUSMJp?=
 =?us-ascii?Q?DmArghFTSwgoUFXznLpj+CtyDBe5vgjEyR015O8oDJJpL469DhkIFdCMXv8q?=
 =?us-ascii?Q?S57kAr5emfIZRf7adytuxIVh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d749afb2-f0fc-425c-b9cb-08d8d374c961
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2021 18:49:42.2869
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: umMJHgeMxFHZ3aEFb2hWtorm0ksZB4bCz5/w7zdYoEVsCO78+KVU8mJ3ACL6ht0P/jLUNrCDSwFrhi88DgEHZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4445
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 bulkscore=0 suspectscore=0 spamscore=0 malwarescore=0 mlxscore=0
 adultscore=12 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170135
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9898 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=4
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102170135
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

page structs are not guaranteed to be contiguous for gigantic pages.
The routine copy_huge_page_from_user can encounter gigantic pages, yet it
assumes page structs are contiguous when copying pages from user space.

Since page structs for the target gigantic page are not contiguous,
the data copied from user space could overwrite other pages not
associated with the gigantic page and cause data corruption.

Non-contiguous page structs are generally not an issue.  However, they can
exist with a specific kernel configuration and hotplug operations.  For
example: Configure the kernel with CONFIG_SPARSEMEM and
!CONFIG_SPARSEMEM_VMEMMAP.  Then, hotplug add memory for the area where the
gigantic page will be allocated.

Fixes: 8fb5debc5fcd ("userfaultfd: hugetlbfs: add hugetlb_mcopy_atomic_pte for userfaultfd support")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 mm/memory.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index feff48e1465a..241bec4199b5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5173,17 +5173,19 @@ long copy_huge_page_from_user(struct page *dst_page,
 	void *page_kaddr;
 	unsigned long i, rc = 0;
 	unsigned long ret_val = pages_per_huge_page * PAGE_SIZE;
+	struct page *subpage = dst_page;
 
-	for (i = 0; i < pages_per_huge_page; i++) {
+	for (i = 0; i < pages_per_huge_page;
+	     i++, subpage = mem_map_next(subpage, dst_page, i)) {
 		if (allow_pagefault)
-			page_kaddr = kmap(dst_page + i);
+			page_kaddr = kmap(subpage);
 		else
-			page_kaddr = kmap_atomic(dst_page + i);
+			page_kaddr = kmap_atomic(subpage);
 		rc = copy_from_user(page_kaddr,
 				(const void __user *)(src + i * PAGE_SIZE),
 				PAGE_SIZE);
 		if (allow_pagefault)
-			kunmap(dst_page + i);
+			kunmap(subpage);
 		else
 			kunmap_atomic(page_kaddr);
 
-- 
2.29.2

