Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0100C39C424
	for <lists+stable@lfdr.de>; Sat,  5 Jun 2021 01:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhFEABX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Jun 2021 20:01:23 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:54752 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbhFEABW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Jun 2021 20:01:22 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NxJHY088064;
        Fri, 4 Jun 2021 23:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MLV+p/Q6hGPFSp7m0LKdS0eRyjzqtXsf6PGoD+39xfo=;
 b=ljEYp+b9sxtEHGkcPg9nCHk0IVNwdVn+WPOkUBd5mQnOLn1LrzBebCKvJrJrwZlvP6Uw
 M5axKABtcOd0EiG2Do8Ws7HXN6JFykLxbUp60MstMoHhFEjcuwMpciueqJtYLLGMyn3Z
 Rt6yjZ5v9VL65LYn4Y+AKWsdDVsTAy5UqxtRxY1f34WuLBuadDKmnJk78JKucKsgyrIy
 JTWJUWCzO8OXCvFP5IwUwo8lhIwa2Ib5jj1vZqiDBPqS6mm7LCDcuCz06SM6bo064qw9
 BD1zn7AbOO+hPPYxYG7zOIgwrRagpnBLpEXXYGW2LF3oNFwo3rQ6vZyD72muHIG3o2yP Wg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38ub4cy2yj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 23:59:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154NsnUV013607;
        Fri, 4 Jun 2021 23:59:17 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by userp3020.oracle.com with ESMTP id 38x1bfdf62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 23:59:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LmjitILbcr7R+XT0RXh2eZsK8X6L/sMCLLB3YpbRNbdTQC3pI+1nlzSVyrT3xHeJqmEeSRTinIJO9uqh2Yis+4nHrkRWfo2e3bNsJtTlMl55YJDkXyqHZFeWlDDjBnOxCXxthQAj/N17MIg6YZkfQ/g5orKXCYwKGmYaARe7/jYkux6zWUXu4e5DwwwONtl+2xaIJpSZ6OsHakUVvLP7i7e8wCjtCGV0nqFqzAHgYFMHUpG2huI1D9WIFq+SuxX743HeWJ2NGOIg0mMJ7ivwVcFuFlnYFVVNhPArhhRcoM6J7p19zjrKUbJtutUB4bJNTa4QG+lbOjBopQnPMGlZkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLV+p/Q6hGPFSp7m0LKdS0eRyjzqtXsf6PGoD+39xfo=;
 b=Be4HREc+gSFEPUwoIcuaURIoixgUD4cvE3Xnh/5+jxD+Wgbm2a9oBQGgt6U50FJ3JMP+X2p10rW/ooQTfWEUbCc7tt/l0hsX6B7zzap6sQ0ZnjgBYZanRCxNg6+PLGWsQU/jl1xjbfUkFlL6q70i8BA42CSDCZf711x9SXHf/Gh9r9tyuDnKrlGjZ2qHJXNbk+3AUOtTnvJtL/0ouMxOildK+5txtcNQQInUZSQXin/vKTAZeWgEUXo0RP1fZm/glHKipf1IZ/smMOuEMX3O/CDmpGHftEwDn5GTd8U0gLC+86M3PXKYI472k/nU4HMd4fQt99+JZAqYwi5a49ngLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MLV+p/Q6hGPFSp7m0LKdS0eRyjzqtXsf6PGoD+39xfo=;
 b=ppyfbrK8qKP4EybmTXHrHDLWXe2UHCE73x6cNEp10N2xQ4qOGSdxmVcFWk0jElmJmu1pN78926fw1noeE62F3ZXIPJG9CMoE4Wv7+s641HdikYwylWw7TcWESlh4oLD9gUPiqIyAPOKe23OSv4mWw/Pi4Nc04Oj59P2AOWN2CBE=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BYAPR10MB3638.namprd10.prod.outlook.com (2603:10b6:a03:125::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Fri, 4 Jun
 2021 23:59:15 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%9]) with mapi id 15.20.4195.025; Fri, 4 Jun 2021
 23:59:14 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     Linux-MM <linux-mm@kvack.org>, lkml <linux-kernel@vger.kernel.org>
Cc:     Mina Almasry <almasrymina@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>, stable@vger.kernel.org
Subject: [Patch v2] mm/hugetlb: expand restore_reserve_on_error functionality
Date:   Fri,  4 Jun 2021 16:59:04 -0700
Message-Id: <20210604235904.48761-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW2PR2101CA0006.namprd21.prod.outlook.com
 (2603:10b6:302:1::19) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW2PR2101CA0006.namprd21.prod.outlook.com (2603:10b6:302:1::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.3 via Frontend Transport; Fri, 4 Jun 2021 23:59:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a100dc2f-5e59-4620-4357-08d927b4c1ac
X-MS-TrafficTypeDiagnostic: BYAPR10MB3638:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB36387E2C89ED8CD673301CD2E23B9@BYAPR10MB3638.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iv3ETTHKO9QmjAVZlCDAycaDAjwwY3y1KH3sn/1P3cPgGFETRRzu4JQx68ysEfJxh9tnRhi3xknXi6ljrFTh5rGD5xnT/MuCURpfg+20XHhhDJbFBA4s7voLfWNSpS3lOpHurdUK7Y5P9ti5Y8LEn7FjD+OFjm0gjTfPKRovfI4iH/CCneeKedcGa7ulWdru4DSSfrFVGLyHytSy9TGdQJoG/oKsgyoBpvz3USHztwiaQpA0kaXXP5Flqd6cFvHkM2QLzFuHcxmLhSpiQr+9juCnbhculbk+/8tcERZMAwq6xdFThJMzE9iEuyscGmtteKJwUpFJ9+jlC/VVTPXF0KtyYrAXf/dVuoKkLHggiUg31KTEvaUJA9tcGH/dIJ9xZJ/sQ8939WBhp1LxS7b43eFFoklFmfvApm8CVhrm8CUUDB0L6NHMPMPhwJ+WEWXn/k4VVwdAiAJMJiIAS8wumdqup0TVkZUBfBV5WvyObKcbkpW1fBB6YMZj+i9cWbWD/t9RRgNDO67sGjQ/vmTsg5B482S4054jkgaTekciHG7+GYntAdIaTgeCVhqz5GK9l+gdmyap1vbz6t8Oy9BTuSHByOPtI7J3Kmj3cClraInsdRBBF35OMGszIs+c2Wvgz15kF7eS6nwQD23O9RTKD1sSh4yi+457enpV61oZ6aS19tfGqqEeanq99Tl3N1xrIHXQL1fhwAZh6BI3FeaIqJEGW5+MEDwS5QX049frq/qVIq5ZELasyFZU/06NJfL53umpOcHo7UB4V/tSpJkxCheyNN8k8BkFbgjTQdBe3vM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(136003)(366004)(396003)(966005)(54906003)(1076003)(44832011)(8936002)(6486002)(16526019)(8676002)(66476007)(38350700002)(316002)(186003)(4326008)(83380400001)(66556008)(6666004)(38100700002)(2616005)(7416002)(956004)(36756003)(30864003)(86362001)(5660300002)(26005)(66946007)(478600001)(7696005)(52116002)(2906002)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JBC08z1drZZEOzYhCjVcMXIX+LwwcMfsLcdZ9d/pRDMTdDJX3rP57w1MmwKt?=
 =?us-ascii?Q?jARNNAcN1Px3csHjc9TkMF5Y4McL6tv6qeKLpGyT2Mzk2+FqDuiiqLFheADe?=
 =?us-ascii?Q?tDFiVuSKlZFyFFHs4AqvCCwNKeVj1qV5IMnsfSj45yH6Ty/YwjMSr9Bp23Kn?=
 =?us-ascii?Q?kRrTkqBQFvpAUa/pJ2WdblNhUvvza2eD4hLVz6xVDGCQT8Qn5cpvFx77eYA/?=
 =?us-ascii?Q?L+JjoAsx6qlbqx2iCb1H76Dy1p4y3JqDkd7IQBRq2kkwsSlJ4IBgjBdXmbRm?=
 =?us-ascii?Q?GIW2QxfJAs9IZnj+X5DosUe5oFUdmYCg1Zm+JugRy5kpi0cFbjrOG5y+8UKP?=
 =?us-ascii?Q?NtrPCga8oJ8BeF49LfuhgjzoIquxNyPN2pYcRyZev/SeJI1SVSYNIzXMr4ey?=
 =?us-ascii?Q?sQqRO3buVJDPiSCPj5VKxRca2WRcwpPJbTsN9PL+WLyWc7NiNlPu4SA5Ajib?=
 =?us-ascii?Q?O0+cwLwWh6EfUHyywexrCPH5n677giwazS3WdLZf2Qo8MG44Y6/PL5yES9AT?=
 =?us-ascii?Q?GSlZyiqirv5YBjhKVzbWE7TgHzJoSNYoegX/qqQeHbqJXjXkn9h9A+bKgyA+?=
 =?us-ascii?Q?bFgwmakUHLDrVDeUK0Y0nH5ZLQaUnT6kVPiNRzudwuqz5s0RR4vCIf17lf/m?=
 =?us-ascii?Q?H10ig0ocwG68/9vbWNyZW33oJcSSqg+3YuETMXtAcwaCH+WtjRUY4OKNdOTL?=
 =?us-ascii?Q?WOz6szdBoaZnAXkeDyl7Wrz+01dnF9LRpNx4TiGPRw1CZ4nYHN25NBNZ9IbL?=
 =?us-ascii?Q?k3D44ggiikm6ZzZdKZbAcJbEp533Z/eB7P7rsnZPVzrleHWTYCOAV9Zl0T9+?=
 =?us-ascii?Q?aoSPUpxzwrK2YDKSVGzaX9Run6G4PDw62N2yVr2vNDkbSunFcdKcWjSD+/sa?=
 =?us-ascii?Q?ZbP7YI9KFoM8gpabivwr2hPEm5iWXA9tUPG5mZPG3PkNunU55fKvADNR5gP4?=
 =?us-ascii?Q?fqk+PRs1XWDlpZDJqvhHN+eRF8BkYCM7Y8VSdbbQg3nAXS5eORZBQtkOyVC6?=
 =?us-ascii?Q?BVUofrUzTsJMr2CwqXKXMd6A1XwXBlTMBOTkfCMMmnv2DCoNs3Fse34wV8ED?=
 =?us-ascii?Q?rziQUb1S9b04J26IaYg5cNmENHXd+IRnvXihutj1t6z9aGhSb7WUl/eaxJoo?=
 =?us-ascii?Q?VmQzVkOk2nS7uZ1XKNTddQ0e09eM6QWA5YDp1TA+pUEn0ItAgzYiJ/HoY3g7?=
 =?us-ascii?Q?EjsN0AFQrSs5xMUw7mCaVY0I8YPfr4KwL5/Ayc4cpbq7oo7Px/lrDIIq4cSV?=
 =?us-ascii?Q?NQlORHv0Mee8Tiqct/jG/hNm181hhs7cEJxeWoLmAYctVMRxsS0nXBmB7ZU0?=
 =?us-ascii?Q?TkKry9SE9rBUcTBK3jzb6A6+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a100dc2f-5e59-4620-4357-08d927b4c1ac
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2021 23:59:14.8446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: j4Hl+J/tRZIT0eHRLcEELtr3Hy9NSLGT66h4iGY2umaXOO9iBGRhhWo35/pbfZrYIVdkP3Gf76w+rdDqFb2ITw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3638
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040164
X-Proofpoint-GUID: g5mPCMoInADY73eW7aXb11wtNy9fTdrb
X-Proofpoint-ORIG-GUID: g5mPCMoInADY73eW7aXb11wtNy9fTdrb
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10005 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106040165
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The routine restore_reserve_on_error is called to restore reservation
information when an error occurs after page allocation.  The routine
alloc_huge_page modifies the mapping reserve map and potentially the
reserve count during allocation.  If code calling alloc_huge_page
encounters an error after allocation and needs to free the page, the
reservation information needs to be adjusted.

Currently, restore_reserve_on_error only takes action on pages for which
the reserve count was adjusted(HPageRestoreReserve flag).  There is
nothing wrong with these adjustments.  However, alloc_huge_page ALWAYS
modifies the reserve map during allocation even if the reserve count is
not adjusted.  This can cause issues as observed during development of
this patch [1].

One specific series of operations causing an issue is:
- Create a shared hugetlb mapping
  Reservations for all pages created by default
- Fault in a page in the mapping
  Reservation exists so reservation count is decremented
- Punch a hole in the file/mapping at index previously faulted
  Reservation and any associated pages will be removed
- Allocate a page to fill the hole
  No reservation entry, so reserve count unmodified
  Reservation entry added to map by alloc_huge_page
- Error after allocation and before instantiating the page
  Reservation entry remains in map
- Allocate a page to fill the hole
  Reservation entry exists, so decrement reservation count
This will cause a reservation count underflow as the reservation count
was decremented twice for the same index.

A user would observe a very large number for HugePages_Rsvd in
/proc/meminfo.  This would also likely cause subsequent allocations of
hugetlb pages to fail as it would 'appear' that all pages are reserved.

This sequence of operations is unlikely to happen, however they were
easily reproduced and observed using hacked up code as described in [1].

Address the issue by having the routine restore_reserve_on_error take
action on pages where HPageRestoreReserve is not set.  In this case, we
need to remove any reserve map entry created by alloc_huge_page.  A new
helper routine vma_del_reservation assists with this operation.

There are three callers of alloc_huge_page which do not currently call
restore_reserve_on error before freeing a page on error paths.  Add
those missing calls.

[1] https://lore.kernel.org/linux-mm/20210528005029.88088-1-almasrymina@google.com/
Fixes: 96b96a96ddee ("mm/hugetlb: fix huge page reservation leak in private mapping error paths"
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: <stable@vger.kernel.org>
---
Changes in v2
  Change incorrrect flag name in comment (Mina) and fix up text
  describing restore_reserve_on_error function.
  Add Reviewed-by: (Mina)

 fs/hugetlbfs/inode.c    |   1 +
 include/linux/hugetlb.h |   2 +
 mm/hugetlb.c            | 120 ++++++++++++++++++++++++++++++++--------
 3 files changed, 100 insertions(+), 23 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 21f7a5c92e8a..926eeb9bf4eb 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -735,6 +735,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		__SetPageUptodate(page);
 		error = huge_add_to_page_cache(page, mapping, index);
 		if (unlikely(error)) {
+			restore_reserve_on_error(h, &pseudo_vma, addr, page);
 			put_page(page);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 44721df20e89..b375b31f60c4 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -627,6 +627,8 @@ struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
+void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
+				unsigned long address, struct page *page);
 
 /* arch callback */
 int __init __alloc_bootmem_huge_page(struct hstate *h);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9a616b7a8563..36b691c3eabf 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2259,12 +2259,18 @@ static void return_unused_surplus_pages(struct hstate *h,
  * be restored when a newly allocated huge page must be freed.  It is
  * to be called after calling vma_needs_reservation to determine if a
  * reservation exists.
+ *
+ * vma_del_reservation is used in error paths where an entry in the reserve
+ * map was created during huge page allocation and must be removed.  It is to
+ * be called after calling vma_needs_reservation to determine if a reservation
+ * exists.
  */
 enum vma_resv_mode {
 	VMA_NEEDS_RESV,
 	VMA_COMMIT_RESV,
 	VMA_END_RESV,
 	VMA_ADD_RESV,
+	VMA_DEL_RESV,
 };
 static long __vma_reservation_common(struct hstate *h,
 				struct vm_area_struct *vma, unsigned long addr,
@@ -2308,11 +2314,21 @@ static long __vma_reservation_common(struct hstate *h,
 			ret = region_del(resv, idx, idx + 1);
 		}
 		break;
+	case VMA_DEL_RESV:
+		if (vma->vm_flags & VM_MAYSHARE) {
+			region_abort(resv, idx, idx + 1, 1);
+			ret = region_del(resv, idx, idx + 1);
+		} else {
+			ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
+			/* region_add calls of range 1 should never fail. */
+			VM_BUG_ON(ret < 0);
+		}
+		break;
 	default:
 		BUG();
 	}
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma->vm_flags & VM_MAYSHARE || mode == VMA_DEL_RESV)
 		return ret;
 	/*
 	 * We know private mapping must have HPAGE_RESV_OWNER set.
@@ -2360,25 +2376,39 @@ static long vma_add_reservation(struct hstate *h,
 	return __vma_reservation_common(h, vma, addr, VMA_ADD_RESV);
 }
 
+static long vma_del_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	return __vma_reservation_common(h, vma, addr, VMA_DEL_RESV);
+}
+
 /*
- * This routine is called to restore a reservation on error paths.  In the
- * specific error paths, a huge page was allocated (via alloc_huge_page)
- * and is about to be freed.  If a reservation for the page existed,
- * alloc_huge_page would have consumed the reservation and set
- * HPageRestoreReserve in the newly allocated page.  When the page is freed
- * via free_huge_page, the global reservation count will be incremented if
- * HPageRestoreReserve is set.  However, free_huge_page can not adjust the
- * reserve map.  Adjust the reserve map here to be consistent with global
- * reserve count adjustments to be made by free_huge_page.
+ * This routine is called to restore reservation information on error paths.
+ * It should ONLY be called for pages allocated via alloc_huge_page(), and
+ * the hugetlb mutex should remain held when calling this routine.
+ *
+ * It handles two specific cases:
+ * 1) A reservation was in place and page consumed the reservation.
+ *    HPageRestoreRsvCnt is set in the page.
+ * 2) No reservation was in place for the page, so HPageRestoreRsvCnt is
+ *    not set.  However, alloc_huge_page always updates the reserve map.
+ *
+ * In case 1, free_huge_page will increment the global reserve count.  But,
+ * free_huge_page does not have enough context to adjust the reservation map.
+ * This case deals primarily with private mappings.  Adjust the reserve map
+ * here to be consistent with global reserve count adjustments to be made
+ * by free_huge_page.  Make sure the reserve map indicates there is a
+ * reservation present.
+ *
+ * In case 2, simply undo reserve map modifications done by alloc_huge_page.
  */
-static void restore_reserve_on_error(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address,
-			struct page *page)
+void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
+			unsigned long address, struct page *page)
 {
-	if (unlikely(HPageRestoreReserve(page))) {
-		long rc = vma_needs_reservation(h, vma, address);
+	long rc = vma_needs_reservation(h, vma, address);
 
-		if (unlikely(rc < 0)) {
+	if (HPageRestoreReserve(page)) {
+		if (unlikely(rc < 0))
 			/*
 			 * Rare out of memory condition in reserve map
 			 * manipulation.  Clear HPageRestoreReserve so that
@@ -2391,16 +2421,57 @@ static void restore_reserve_on_error(struct hstate *h,
 			 * accounting of reserve counts.
 			 */
 			ClearHPageRestoreReserve(page);
-		} else if (rc) {
-			rc = vma_add_reservation(h, vma, address);
-			if (unlikely(rc < 0))
+		else if (rc)
+			(void)vma_add_reservation(h, vma, address);
+		else
+			vma_end_reservation(h, vma, address);
+	} else {
+		if (!rc) {
+			/*
+			 * This indicates there is an entry in the reserve map
+			 * added by alloc_huge_page.  We know it was added
+			 * before the alloc_huge_page call, otherwise
+			 * HPageRestoreReserve would be set on the page.
+			 * Remove the entry so that a subsequent allocation
+			 * does not consume a reservation.
+			 */
+			rc = vma_del_reservation(h, vma, address);
+			if (rc < 0)
 				/*
-				 * See above comment about rare out of
-				 * memory condition.
+				 * VERY rare out of memory condition.  Since
+				 * we can not delete the entry, set
+				 * HPageRestoreReserve so that the reserve
+				 * count will be incremented when the page
+				 * is freed.  This reserve will be consumed
+				 * on a subsequent allocation.
 				 */
-				ClearHPageRestoreReserve(page);
+				SetHPageRestoreReserve(page);
+		} else if (rc < 0) {
+			/*
+			 * Rare out of memory condition from
+			 * vma_needs_reservation call.  Memory allocation is
+			 * only attempted if a new entry is needed.  Therefore,
+			 * this implies there is not an entry in the
+			 * reserve map.
+			 *
+			 * For shared mappings, no entry in the map indicates
+			 * no reservation.  We are done.
+			 */
+			if (!(vma->vm_flags & VM_MAYSHARE))
+				/*
+				 * For private mappings, no entry indicates
+				 * a reservation is present.  Since we can
+				 * not add an entry, set SetHPageRestoreReserve
+				 * on the page so reserve count will be
+				 * incremented when freed.  This reserve will
+				 * be consumed on a subsequent allocation.
+				 */
+				SetHPageRestoreReserve(page);
 		} else
-			vma_end_reservation(h, vma, address);
+			/*
+			 * No reservation present, do nothing
+			 */
+			 vma_end_reservation(h, vma, address);
 	}
 }
 
@@ -4176,6 +4247,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 				entry = huge_ptep_get(src_pte);
 				if (!pte_same(src_pte_old, entry)) {
+					restore_reserve_on_error(h, vma, addr,
+								new);
 					put_page(new);
 					/* dst_entry won't change as in child */
 					goto again;
@@ -5174,6 +5247,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
+	restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }
-- 
2.31.1

