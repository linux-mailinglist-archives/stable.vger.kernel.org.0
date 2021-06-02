Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDFE39967D
	for <lists+stable@lfdr.de>; Thu,  3 Jun 2021 01:50:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbhFBXwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 19:52:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38944 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhFBXwN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 19:52:13 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152NoDf8041103;
        Wed, 2 Jun 2021 23:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=cHmpP85U1siAsDY5vbNNGLtG7oCU/5ETxRyme2yRxVo=;
 b=K+dX/nyKMJVaUa/P5Ige97fir5ZUDlrCQFK/4tt70tG8BpDumOy6I1o5PFQcz/3Du81Y
 IBuIkewvUqYPCYm59c5FJBIpmaBjuFKrixWbT6wbmUU2UvGaySDGR/9lIrjrE5XpD8tU
 Zjd5QQ0xCSvyCfzq/3yR4kfHw+DCsZdrth3mYi4evbfwfrtm83BLEPuVcGlmFmT17/is
 2PBhOdvg6w7IR2sK/ReftMcwlIZ5iclvYTOH/ql8aKqmo9SIODoCFNBJfe+86STmwcOc
 LlEp60seLHTSPEoUwwMMWknaHtEJ7PbAzJM24Ni2rP7QO01Fp/W7cu8c8M9Leizf6bF6 iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38ud1shx2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 23:50:12 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 152No1ju057782;
        Wed, 2 Jun 2021 23:50:12 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2041.outbound.protection.outlook.com [104.47.57.41])
        by userp3030.oracle.com with ESMTP id 38uaqxrpcu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Jun 2021 23:50:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ixiE9UeOz2dyIC0G4qBIf8ipTOuWoqxtY+lwiC6bVZqtP2xsqKmiFkwo9dLZgAXkLICk6i2IFI4CD1Hgtn2fpEv2lzgh/vAIf/rs8PRwW2bQD4vBMPZzU/xXJMIviZVJE7ySYRi0TXAJlwZVTeeEKVhmFgSNpRB/OhU2FkkhW69ukCeFQxDe3ia4iXaUZK2o1bLviY6YXjFcdLFzbMvEC9hvt3ZwkL4AuDX9tefvGt2pRI0zfeOUX+WAN1zF71yaXF6wRBYpjKulvKP4mkfDsBkgsxIrtnBB7IAdNYqK2/N+OUCvQPJ6o/IhKmoOKEVPi2zO/paQCnP2On/G199z8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHmpP85U1siAsDY5vbNNGLtG7oCU/5ETxRyme2yRxVo=;
 b=Jr/q1ZKCQIe4QvJi1F+bDWUZhQWQRx89ByKWMQOIxG+OCTsae/3ff/MizdS7ATzcfwslvGqIik2AzwcKYdkALb8M7BeGDSRJzZoEq7VNBVF/U1YfRYvkCUBuAlmEORMd1sCxxD5ynqKBuB8T16lQ8Xi9W+awkD+b3feMPS8PTEn2+9h8BABZUcTBsJy0k3ZpchruiYVaaB89cEMPr+rkLL3OEslg1AWUY+KAEknUetARFFoZzOEm5qjiOlB/bgIczjKgUPaoCOMQFPoduHhwYPoUBiK74ysiI3rb0uVYuKWTdPz2iaKOjzacZrteRjYMTgO3xorXYUX0wUK7YAgn8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHmpP85U1siAsDY5vbNNGLtG7oCU/5ETxRyme2yRxVo=;
 b=aX8DhrJXTYG/9zvD7gs8k37ageHDd3PB6IhU/H8TP7jW7rUimPED2sKzI+VuShuDjo7TLNbjoqaUB+a0E1ZPsjS7HEtXxQiPmvPMNVA0OAX5eA0R88216Qc0YNmmbnCjp5Dqnf0NA13LMwrDbOgZp7lP6wvSXRJ7xcFwhtyEnD4=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4784.namprd10.prod.outlook.com (2603:10b6:a03:2d4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Wed, 2 Jun
 2021 23:50:10 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%8]) with mapi id 15.20.4173.033; Wed, 2 Jun 2021
 23:50:10 +0000
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
Subject: [PATCH] mm/hugetlb: expand restore_reserve_on_error functionality
Date:   Wed,  2 Jun 2021 16:49:54 -0700
Message-Id: <20210602234954.122199-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MW4PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:303:dc::17) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW4PR03CA0342.namprd03.prod.outlook.com (2603:10b6:303:dc::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.22 via Frontend Transport; Wed, 2 Jun 2021 23:50:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4cb80d5-aac4-443f-af6f-08d926212833
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4784:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47845CC472A82B5D022025E5E23D9@SJ0PR10MB4784.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7sva9J70TIrigF4ktPQFMy43dcKqYVQ5G9BBa1kGzPPMElUQKWiMGrftP7nD69a1T6yVVcHmxJL5vArJ7PS85JVyo5DqPN4BmZoOcQ6Xq/PVF/nkmkWKfJhJjlZ326NyTWtnMGyCMOjgxhfl2qBQzbPZtzF5PzELFZqbCDHl2gW4yM3Qf1O0hsrSsG0xQpoDGU18Be5hbhR58YQxvZJLQ/m/RHoquxrxkdSQ/XlLelZyvCi5lP4QH4aTfCN413Lz62JcpSd8hxHOOkpL8KDt7ku7KPU4i1Bgn7Jnx3UYzxr8gGfXOcLkbACOD9MTzEKUri5d4Ce4llBINlRomdDJL5oPnD/iOce8a92lmKpaPhChCtKr1HhICrPRaHw9t3NhzpU/BBMOPIrAW+cV0EMZE5w/MqRNkEamonoB04Oeei33cLuITuKZ7fd0a7SoPKDhTEEMHjZjsU4PQz6WFdI4jmJ/6f09JzRWzLn9C7kemhmCrrZM/5JP1sPYYe0i/Sq6GtP1YNvz/5/x+fOKtqo6HRcWKukJNB+3xLKwwFEYuw0TrsNU4Y7kBltIHcO+4d6bXPplV28DVYM7udEsdNHff1e/MQ+K0RAseFjaHyWICy7vLP6EcCEk7GLu473u4YQc6bTXtrs52Sosf6CJXTAu3TKwrEmrobckULsYb2GJ4S87a66XGZb0Ww4exf81Sjmi+ZvXIt6RbB1eOpxAT7cyUrWtjzMLfROK24WyTg3Ti/HD/phjiXqj+CGvTN872fF+MvJ8loVvFUn5506lQxCzPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(366004)(396003)(136003)(346002)(6486002)(6666004)(86362001)(5660300002)(8676002)(4326008)(2616005)(956004)(44832011)(8936002)(38350700002)(30864003)(38100700002)(1076003)(478600001)(966005)(66476007)(66946007)(66556008)(83380400001)(26005)(54906003)(110136005)(7416002)(2906002)(52116002)(7696005)(186003)(16526019)(36756003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ttBWz6OrI2H7DTA0jUz4xteOaVQFdbWjHUNlnQzMpP+PLtGLqtC26+nmVEG7?=
 =?us-ascii?Q?LS5X+Ljpz2yp3L+q0z/UGSZKHKi148LjeXI0xVkfSNI9jzKUGpRRh/F46SS7?=
 =?us-ascii?Q?6/B/0uEzvNMP2yCMwcTJqZDxCLQ3tbq0tfhaLyZVHJzdAh+MpZ9IYGdOCd+y?=
 =?us-ascii?Q?wO8kYqlxLysihCxouZHgY/O6+rLznlja81emSdJcu47HL3OsTvbUKANdl6a5?=
 =?us-ascii?Q?8DftKO36NI0IsNCdNptK//4GYnYUxXQIIV8GIRYRxLzUzkOkl45O03Rg8HlU?=
 =?us-ascii?Q?BBwaaLNWrQqeOab5Gwhc6CSsdSwRZqyM1Xg65LHgg08yKHdQohrZn54ocZH2?=
 =?us-ascii?Q?RGICwOC36vq7BroXurRWtl/bQpHkdLPLrwAumSwmqQzYWuMlbYGGR3TQILlu?=
 =?us-ascii?Q?j7r2ngDHGmIg7ApG9pFSyuAjYbv0QMfiDIk5J3EqXQ5rJNmuRBTCuozSZV1z?=
 =?us-ascii?Q?gYgH2gJD+nISPeFAAVK32r55c25QnEI/62RWjTYhi47q2U9Oc9CAJo0nanEM?=
 =?us-ascii?Q?j8CP7yH6JXoUgdQYHHxwusic32LNcZXBI9cbkZIFnwZlXHzVyWbaKKx3JsVq?=
 =?us-ascii?Q?6dpu84YuihYx+yih5/+6roXggkv4iwW+bJ2Zu+gzZ7i+Byp5y3ca9OYkb5Bs?=
 =?us-ascii?Q?hBiP6l8NW9SwJC82TNCI/x66GpFFMzWOv+4HFwz06dG5pN2YYY2tOAFWHMnI?=
 =?us-ascii?Q?A7GcjcXJ38Oxn3MX0O0eHVKaUUodJ3OZOxZYhv7aGV2e8xRWFxkvBxVYm8hX?=
 =?us-ascii?Q?SNyK0XacNn6ldrvUcAVxnuJBcHzJRLt8BYbJfqvMZQOVPi/JuPOQaSgFrJk1?=
 =?us-ascii?Q?0e3oOEvkT/OSysh7JPOw51X6s7Mj4sZLslbOPpaa2yRtWYelNkp/GveX6p1U?=
 =?us-ascii?Q?7sOS1E2PHxeFyWyYfa6AP6pZSowe7QEixFhx1OEbY4Kz+xWlV2qjk+31d0Tr?=
 =?us-ascii?Q?qKPs0rhDoZiegXrOjgcVpyrMqTzr11ptXdqYmbpPduWWyrl3KHiq2LAFmL3v?=
 =?us-ascii?Q?1FLC45N0rWXPHtxNIXL3zdU3U5kJz4dyk1y4aNC2KE50Doy/AjgvJWchj7pg?=
 =?us-ascii?Q?DrknXjPTYEkO8y2m9c5/ukvWol4cNCGg9imk0ROi1aX4XIY9SsScgwOGdhTQ?=
 =?us-ascii?Q?zXXGISmoWDHH2eAEnNNELSxBOtLvJe8uSSiyyKps/EQfv4BUpzme26vkKDwj?=
 =?us-ascii?Q?Q8/5Lf2yjAPXCDVeOoiGZjJCvNEDi2RI69fiaamY2ye9roo7z8IGgoFRss1J?=
 =?us-ascii?Q?dW7n09gpUL8jO+aNh3pWARmvKjlA1B0erY3cB6apVYyUiZ4DcfSk8u76efoL?=
 =?us-ascii?Q?Iv2vs3EqIIm2nstf1srAVslz?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4cb80d5-aac4-443f-af6f-08d926212833
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 23:50:10.2476
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EUHynx0+QsVNyCZcZVKiLOSBdykgeoFGobjm8OcPBLM7aODPtk2nXHuZ7QKd57EGHRs4RkdK6ZPxeUX2NIu8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4784
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020152
X-Proofpoint-ORIG-GUID: gjkZYjCBHYgkPnnOUu9t6Rb94gfeIQ9O
X-Proofpoint-GUID: gjkZYjCBHYgkPnnOUu9t6Rb94gfeIQ9O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10003 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020152
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
Cc: <stable@vger.kernel.org>
---
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

