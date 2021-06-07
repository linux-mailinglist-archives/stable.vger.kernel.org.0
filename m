Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EA139E8B1
	for <lists+stable@lfdr.de>; Mon,  7 Jun 2021 22:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230502AbhFGUri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Jun 2021 16:47:38 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37250 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbhFGUrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Jun 2021 16:47:37 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157KdWYU154517;
        Mon, 7 Jun 2021 20:45:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=LD25ZDOxiYbr/oQcLwsCkLmWqyRWME7t13zZoZ39tRw=;
 b=eMGLrB1c0GoqToDcERTUlIjU0lz1kQzN6jLqwtROLcgOU6wf/R7j5eaKxGATyjVd2F04
 rd2UIrCyEFbJNlL3HdYKTB12lZakkaiHHWGwzYsdh3wG/zNAsKM1kGQE9+aRSvqvb3Ff
 yUyZASiCTVZ+RiXds+Vmjg5ZSqqCAewQfBV6ll32mhYikdhKkIcdpXrQcea3eQyKpO0A
 RkVriBB6J61fPZoEyeK4rFw52Xh1KXzVKRKKZ1/lUTa38Kow/BS/d5zpy1c42CVBPUEw
 2BWnU4XDNXppDF1436UC+Gw7dxMqQ88AXP9XjTPMAWKfzO1Oxgq1Vohzq3yffNdGVNzE YA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38yxscc61x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 20:45:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 157KeppD046294;
        Mon, 7 Jun 2021 20:45:23 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2040.outbound.protection.outlook.com [104.47.73.40])
        by aserp3030.oracle.com with ESMTP id 38yyaacdvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Jun 2021 20:45:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jnHwCrybvx0zVfeD/YDYne2ydauh+6H+mtFaqcCy4B4JNfn5wJ5MivTbjnWIp5bVm86tZUyH+NQCvcsdOkMZHFiv7XiZakcPPj08aQu7z29+PnVF1moPosCakRGo/Llblg/4awWIv5+rzAOTkzwi1FJDjHIYPuBfpWqXeuVUZqb4EsB54QGKIB/xbItQM4drLZ2aK+UOECJjfAoQhfcpeeqDLu2kRbch3U3m1YxZI125yibXSZKxLRUfSMuHrk1o0qR4jeFEeCOLWoaY8BrbCxiP7rTKwTJk8YLr0TgKG3M6EStHIk6faCKTlYhmczBYjYgm0B2ExKpISPRFxVXk1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LD25ZDOxiYbr/oQcLwsCkLmWqyRWME7t13zZoZ39tRw=;
 b=VYkuu+RlCmN9FjI6i21bWugO20XhkqH8e1ASw6d6b6stJKR0YoRHY3mCi9DjBo3jFRpLguaz6IK8/YYDPYD0Sa0fHZJu6cWVt4c1vDFGO/u5HkXdiycHhlsOPSpjLjDBktBkGVoJCgVgx7eQa/LEvD+MDooKus/joJnajdUSB6nBFXoGLRXiW617H7Nz8Wcd7fLkkUkS4g2jHu2/qZoS7JULq6Htk6h1Au9BTWNAp7dc8oqd+2OkPXih6ibsenLqqEkxZcbfNygs4VUvAEdYSm5/d1//W/LwydNh8JUpDMgeEHRbCb4A60w7CpEp63cqpw2asWy52uFaHR5ovQg6zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LD25ZDOxiYbr/oQcLwsCkLmWqyRWME7t13zZoZ39tRw=;
 b=zDPgnHHxHbzLbIBrFvaGD52sTjHcufyWPlOWzVxtn1Voe0oCXR6n5qZMpHjmUV8JnUUGF/H/+sIwTTIrjNWS6p201JN9Zs10tRzbbmClbwjCDCw0QfUJz+LUfqNbGiBJI7MFoANPM2XxHHYU+FT6wiZ0tsK5AEP1nzwqBXEJJ+g=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4736.namprd10.prod.outlook.com (2603:10b6:a03:2d6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Mon, 7 Jun
 2021 20:45:20 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::4407:2ff6:c0a:5d90%9]) with mapi id 15.20.4195.030; Mon, 7 Jun 2021
 20:45:20 +0000
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
Subject: [Patch v3] mm/hugetlb: expand restore_reserve_on_error functionality
Date:   Mon,  7 Jun 2021 13:45:10 -0700
Message-Id: <20210607204510.22617-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [50.38.35.18]
X-ClientProxiedBy: MWHPR15CA0030.namprd15.prod.outlook.com
 (2603:10b6:300:ad::16) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MWHPR15CA0030.namprd15.prod.outlook.com (2603:10b6:300:ad::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.23 via Frontend Transport; Mon, 7 Jun 2021 20:45:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d1c303f-0dae-451f-ead0-08d929f52a05
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4736:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB4736E4A3F6E2510A5203B9BEE2389@SJ0PR10MB4736.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kgcyMeB4YYBieguGbWm/zK6B8VnNJriEHaT1EmTs/mv7SEMdfq7yxBNZjoXuLxBsf7qciyPvUaXTTZXJiYYgjT1mE4i1SdrprWgnmqsRTjTriXIUvFqpyYdE3KDihXD/R3tzcm00yqIHzN8rIQnj3OAXg/2xbRfB/9a9pn+SraVtmKJK8BSMpcRCIonLxlXM3uiYf8TFRWqyUW2mSRz+wNviRIeoawlxcwK+7xG6GaTZTGcfap1T02baMYRIhDoWNK6Dox/3TDR1FRNAiAN1tA2uR5wKh1L0fraTPxQHs2sXRlx47Sh7iT/rZ4NLjBwxPKUK1NErxYhIV26hp5d7PuT7Zr4XPvbgANWKsecMWPq5PfWR1J87oGKm3r1X+ZYEZma2+qsleUus8XcVcvluK9vBpKg+CRYPJfV4MHkwkfbZ9XYY9eRDy1MLYcvf3EMOizrukLi1qkeRs4KVZr9zj2hDxRVws/Y6HQ9Anj9xzRFHDI2PDJgGifOJvT9uFWf9DaV23btNmx6LnG22rtMdorL2P2t2n6m2loBIQaowrkfC/y4Jvp1BfJZzxOPIxd0bc6x0zjJwq/chBnIJr2tAxIFg+sVRPcLMS7c7pRaG+3tE/RzjTGd4Tsz9Si4kyXikWXQiqAMSlH3iUk2YsVj7poAip3CeitqANIPQJvPQLZYueIix1w8jBBOppr75jo2ZGT5tFDvLqnYlMKezgpw+FG5nB6SWi8VFVwJ+tq/0SnOWbeM2M0O6WP2Z9NfGxnbhw4mqVHhlE0NQN7/or+4NkuHAEK7eYwe3IRO5zpwkDcY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(136003)(346002)(366004)(376002)(8936002)(6666004)(316002)(26005)(16526019)(966005)(30864003)(66946007)(66556008)(186003)(1076003)(956004)(44832011)(36756003)(478600001)(4326008)(66476007)(110136005)(54906003)(5660300002)(86362001)(7696005)(52116002)(38350700002)(2906002)(38100700002)(83380400001)(7416002)(6486002)(8676002)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?EELm0bzPJOamCpnDcbM+bAn/Jxf+H1PJV+VUD4hF9Gbznp3pAfp8lnALSjjq?=
 =?us-ascii?Q?NZiQ52yZAw1UewEF1hb4bWlErexCoMB4A7Ka8kyYdt7E8EouQAcSNcAkv5NZ?=
 =?us-ascii?Q?OmimbmcjABc4nvUsWxIKGxq5TdC9I7KYU/b39xSRoVVEFYuvdrzceX7stI2f?=
 =?us-ascii?Q?k9Gy/3r3lkXkqujmCPqbyntz/LMUmF+Ubpd3x88W+XiHdJQG75dmzcfRuqg5?=
 =?us-ascii?Q?l5iI3Gla6D/0V6cZ6i3336+nH+7oAiHeeq3J5CrFZS1xsMq6JZ+14NrPmhIT?=
 =?us-ascii?Q?ee6g4Nl2JVs+YpijKwmX682aZtyh29I0WfPHsR0q4aEHTXmMqHUp5Jxjqy+v?=
 =?us-ascii?Q?N/9tOXwgFQdm3KPVohwbuc84em5Oj/Z0f6k4zFXqUDaVnV/FIB9NvfyDCtqv?=
 =?us-ascii?Q?QyUUCPNFyYehV+B5VuNif5DkIf4dRqD8WApZq3dnxsmn4Ni3yyOYPCawS0b3?=
 =?us-ascii?Q?8738R9vTLHdpJ88U+R/n81y3hbct2x7WifJWAy+x4s+Az9nVtq7R7kmLp1pB?=
 =?us-ascii?Q?vwQ8bR/nsb6SdgfUrAcVhpV1Qhi80SlBtB5+Rck3vqf+ofgFOfYdltyAqhW/?=
 =?us-ascii?Q?m937KEB8s0NFpfWS7DRFSVpOK4i27ruCZ3jVQPeWZTWCYkWPDBNzEnm9Ys44?=
 =?us-ascii?Q?L5sOaREyZVpJa9lo119MY3N2kMxyiCG8VO81ERH73f1PHU9XLwRND+lxy/Ug?=
 =?us-ascii?Q?j1JV7S1HsoyZsdpTual2W+f1XEuGRPCKdyRUUFBv7VdDZ+qHVZCZHeu6/ago?=
 =?us-ascii?Q?yuRdIiA1KFMUCaymjd2koIgUgQ5kXZ2K3WjW0mrv4EiqXTxQaZHg1+a7N34g?=
 =?us-ascii?Q?56pSi2gyeHjyNDgP+r1bZK44Eh/x1FYKRQE+Cm3s0vhCN+CLQGRf1xUN7zmb?=
 =?us-ascii?Q?QQ7RLqzUYESDfmScOgJ5nTUT5vmLw2FLJsnBchmg4Z/sjc2noW4dJg+DPrEb?=
 =?us-ascii?Q?f/ZxFH2+UmpGgL4m7JwsiCsUwTmNJY4cZjL2g3hifJWjT2I3EKjE+hkHPSh+?=
 =?us-ascii?Q?ENVPALZb2393jJZY/Apc/nscSphxYf8YEuqourEbEuvg2bTiYXj3z4Iz/m1B?=
 =?us-ascii?Q?aTYWsLV7cPOVmMyj+EcnLs/KgMDHhVfoIzrl7U6rdMmmQ0VP9+hCQd0AtZOm?=
 =?us-ascii?Q?EozsidZ7vzrc/+1cHbD9G8Q/coHXnqTNleU8JunAs/9Eb5idiukAuK/wYWoa?=
 =?us-ascii?Q?3j6t3HPprvvcVpTVQBv5EsXHAAheOwLJDErsNm9NYnyLb09lDWt8hZfa/J+2?=
 =?us-ascii?Q?lZmwr5Q+zXUxWXV3rEvkC87uVdwh9L8Lirnminc7O7rtBlot1fKszFLZBCRE?=
 =?us-ascii?Q?TqZKYqPtFjliOHPrujBI7zf7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d1c303f-0dae-451f-ead0-08d929f52a05
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2021 20:45:20.0175
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bT9Ewl9sSUwrYotTb01qzGWpoI4hGV5qrwuz5BT+bLqBjTwZk410qGnvHWo7EwyuizqcZ+us99EPAklMAVIkKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4736
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070139
X-Proofpoint-ORIG-GUID: zYBc_KzeTE1n5JXYd0QUZRQx7gY-Z4kh
X-Proofpoint-GUID: zYBc_KzeTE1n5JXYd0QUZRQx7gY-Z4kh
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10008 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 malwarescore=0 mlxlogscore=999 clxscore=1015 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106070139
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
Changes in v3
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
index 9a616b7a8563..18fa91d440a1 100644
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
+ * 1) A reservation was in place and the page consumed the reservation.
+ *    HPageRestoreReserve is set in the page.
+ * 2) No reservation was in place for the page, so HPageRestoreReserve is
+ *    not set.  However, alloc_huge_page always updates the reserve map.
+ *
+ * In case 1, free_huge_page later in the error path will increment the
+ * global reserve count.  But, free_huge_page does not have enough context
+ * to adjust the reservation map.  This case deals primarily with private
+ * mappings.  Adjust the reserve map here to be consistent with global
+ * reserve count adjustments to be made by free_huge_page.  Make sure the
+ * reserve map indicates there is a reservation present.
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

