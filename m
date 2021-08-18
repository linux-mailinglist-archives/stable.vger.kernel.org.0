Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6353F0D62
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 23:33:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbhHRVeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 17:34:15 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:23098 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234028AbhHRVeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 17:34:12 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17ILFvSS016226;
        Wed, 18 Aug 2021 21:33:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2021-07-09;
 bh=kcTwvxT5rPYg4AiRsvHivxkIUHm17Ttyo3O7O7BNFB8=;
 b=GMSYH17mUY85gHasm/4rh8BMElSDGAiEDizrFpoZSuKu0j9yQKovx/aemg9ubWEQp55c
 PUvnJBwsqu0vsZpf+jk1ykLbAg+yODgMZcMne9pfnu2HIaKQyW5OrxG31mxoY17cSw7B
 XSTMKMil6MV3awfBx3eNSmTHSpBAuWeXG1Y7XjviE3MS+h5KALRNJr3vztA7A2P9IPys
 nbRPAqG6YcsiHthrZOz+hS59k2XLN+cVruWDOS6/tRohs/UD7BtcTLpmp8K1/XdXwKBO
 tz36mb/16C0fEu2nqdjABH+6z+9LQA3219sEj9iQ2eijPHvFCw9wzLGjr4W1kSy0WJFx +Q== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2020-01-29;
 bh=kcTwvxT5rPYg4AiRsvHivxkIUHm17Ttyo3O7O7BNFB8=;
 b=X9m6uO1p8Sa5AcBLeqOHF5QCmHuCb/LBipeEosGmdYl2bHduO1Z7GfB92TxElSgRPorN
 HdZYa5AlGVWrltQeHZI/znK/RML8B80h0rT5RpNngcsgk/z5bRIMnALcyJ3bzgs05pTn
 tEU3JKqUBRwqE59YGmyCPQDQtmPTg2YHNZ4ZnPj6PBinDE78i0rZQl/PcOQ7OsDUuIWU
 0A5eqrYBU1w8i2qYo/41s6RSt9JfzM+mPJDs+3U+YPvdCNvy5chOvQhVCwF4YPP+Nm+l
 Z2H10QhME/8RjEN3H3IiHYOsJZT61rt8Dc1rNCNr8H7jXmfVnX9jERoCWr3Nw1V1Ao+V AQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3age7dbv43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 21:33:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17ILF8kg080410;
        Wed, 18 Aug 2021 21:33:16 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2104.outbound.protection.outlook.com [104.47.55.104])
        by userp3030.oracle.com with ESMTP id 3ae2y30pw2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Aug 2021 21:33:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G/UypwisKQRdxOFZcKOFk54WCsOLmftjNHRFytGZ3GAxVILM2n3hBXltElrXh8hWpvj1pIRNCjst6VCGwFonSEsHMf5YFSdDdSLZVu3Wpj7eNdGPrsqVaiCh9KPZ7PUBlSL3n0ICTw4mrNw9SY9wBSlrjUoYkyAbs7g+/6H+1IE7vzKZqBPOvRaKHt6k83oYaQjcpFwVocgXKgfRfuYHg3JgZzcYd6dI61FgRnKlrURVMCXShGe1NtJTaGXRsrrGXWSCOvPVfLBzzN9Q56n+MyCtKFxTaOoUPe+s1WdCqs2JBPc+ACQb/5Bkxlav5KJyDM6qEl+ZG7m2B1SYmO1q3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcTwvxT5rPYg4AiRsvHivxkIUHm17Ttyo3O7O7BNFB8=;
 b=h5WN2+JR+sHxs0GFL6RSazTlG6zRdPgvPMusyG0x2L5WSUIEj6SG2IeMrnIpflwzCDkiA62swauo/lESuPDwIlWsOH648PPk8RVTyktxvL3tNL0KcE4i3u0ohsSV0JnqCSrBmorU40z2twJxT2t64oGlM9ufl3Mrq9mzrv7LRk7TRGCNMSmFgKR+b+EGcGJIh0U19TmYKpnx6EaUZYl9bZPRAvTraeoa/ufxnmP2lbN8vvGKqFKw6HMtpA+lfgRR6kBijK3EsAWcnlXxLrBZuS2zS9oDaqQrPaGJ7ZIjW5UWYkWNd7nWh2ogv+pwebToE7p2DHKV4RqidKGELwHcIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kcTwvxT5rPYg4AiRsvHivxkIUHm17Ttyo3O7O7BNFB8=;
 b=aZuqxI7fNdXI6URy+xYaX0P5pAVL1zF2PVbAJybIRY2Hh038i+5Ng6hzFtWL0eqq1yl5KpPw4p1UzSZi/cv1UTnNAhyC8WemBNbYuZijmSfiRyRuOIQZyJIdAjNHrACQzkCXGMRmzZiLvM2e2PZl3QpKH04UQePH9L0OLHoMOBw=
Authentication-Results: kvack.org; dkim=none (message not signed)
 header.d=none;kvack.org; dmarc=none action=none header.from=oracle.com;
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB4701.namprd10.prod.outlook.com (2603:10b6:a03:2dc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Wed, 18 Aug
 2021 21:33:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d2a:558d:ab4a:9c2a%7]) with mapi id 15.20.4415.023; Wed, 18 Aug 2021
 21:33:13 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Mina Almasry <almasrymina@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Michal Hocko <mhocko@suse.com>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com,
        stable@vger.kernel.org
Subject: [PATCH] hugetlb: don't pass page cache pages to restore_reserve_on_error
Date:   Wed, 18 Aug 2021 14:33:04 -0700
Message-Id: <20210818213304.37038-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR04CA0177.namprd04.prod.outlook.com
 (2603:10b6:303:85::32) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from monkey.oracle.com (50.38.35.18) by MW4PR04CA0177.namprd04.prod.outlook.com (2603:10b6:303:85::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.18 via Frontend Transport; Wed, 18 Aug 2021 21:33:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 389dd950-6893-4ee7-8db8-08d9628fc877
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4701:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB47014744E53B50ED6BDED3AFE2FF9@SJ0PR10MB4701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 24qsCT3DJo37fy/FbsO+vKzPKrv28Cp/d89/wteavPX4pchmB33+t8OIRcG53mSuwFiEH5wJv5dRrA7uyCozIkn6n1Nsr6fpUOExNNZkk9oCFTfjqm7Ofj3H0AvGgk4c92o/Xyarmc2CAqEoYP9eN5zlI1GNy4sj0K8BeKrjquN5g8SnmeL+YLlGANobPnG+HVZHSgX1hLilLdDBQSrYvdFdudQIKso7WEzXq9ifhYJQy/miFj8lmEoSQe0bXaz+LGxQyM+DwqkDqhdy7y990gJ2/GFIYKiRuCLZb7kH/54YLiKdRFzvJfk45Vhq4HXyIRt5vuqcN7+AYxta5C7+4rxq5GihtWuBnrwDqou4IBmumkVrqDiXy1gmFQ9lZ4Cwa27GbCTriaTYdbCds0mvg859UIAp9KztS1PYcvNDcGau92JBkwcnixhG0GxSh9acHD4rkQlYU++FZH+sQ9peREvvi0tjQNwfYZv2UJTvlEzWbr8MG8926VlZKXVQj1r4mKSc9KlmwHFkc6GVshKhquGiyqxuy0STQ7jE6/jpaUeFd+AmGWAz383+M8Zmsa6govfiZNLeK8yVtp2kAha5lyhNchXwHI0sl80CkV4i3MvpfKCr/BYdaCRjgV7KITEKsnuuqPbHmC4Hb0+Scwteoea0yz0zRXAUOJtlOqKGV1/oB8tkKt70/nKWumA2TGQhnNguRyg63SlK+3ohIQwWfltvpsBYJZayqMDO9+/f4uytHiKig7YhaHg70tCJTVOeickFBcIQtN3EphUDAIvZLATaHkVN+wGSdiy7YQtp35M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(6486002)(316002)(8936002)(52116002)(5660300002)(7696005)(7416002)(186003)(86362001)(6666004)(36756003)(1076003)(478600001)(4326008)(956004)(66556008)(66476007)(8676002)(54906003)(38100700002)(38350700002)(2616005)(66946007)(83380400001)(44832011)(2906002)(26005)(966005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oQonDru45Eyp1neMkv2SZy8grrnV37QPd+6rmcNYakW8DOIum+sVQJfiIm1A?=
 =?us-ascii?Q?ojJogDZVFx9Yow1qEQwUeDbEP5weJRxwcpwg175GFPk9xgc48u0AtQdEcxsY?=
 =?us-ascii?Q?PWkQP8G3mH0kQS0YBc1Iln2Jxdx25uw9f7Ulyh1BEfnDSn6XcGZMgSu8mvDG?=
 =?us-ascii?Q?GTVfeHBim6WzSZO1J+S3bw9Ujo6yhFVz8JD4aZqGW67NFs03QdtJgSt9EeRE?=
 =?us-ascii?Q?kzcJvoAMMbYiOKsLUCF6+em89aeHS/vG7smnBSESgGlxNUzxF871VCX2BK4c?=
 =?us-ascii?Q?w+aFV7tf67HtI3sOymaKCQtRAPgSd65ctWL2/2AUTuMnlngcvuZZPjDxbd4h?=
 =?us-ascii?Q?XSo4zIEpwQQWsKm7cFYeUuH8ECvl8YdiJcsADfUrawtrwRDOkC1jn5ytWRwE?=
 =?us-ascii?Q?ii/ihNPHbNKcRntNiDyzgjHLoRi+uSCk5y2B/eAwHlNWA6sfBYOHYNrDrOYs?=
 =?us-ascii?Q?kiKq/qBwzrFRmtmMcONTQeaidhwwE+bWK5IYuHWlG+0FrPD67n0jtlaLn8ss?=
 =?us-ascii?Q?st2fmaMwuIABgIAttcjBSf7nGvW3RvOEHFPrLmqFO8sNndpE+2wzNeLNtU+J?=
 =?us-ascii?Q?TLUr1XTSIz5Tu+I8eNws2IJh1RT2dc6yEyNShz7e4ZgXp7o/5TdBZCAGru/b?=
 =?us-ascii?Q?4ULkhUmv6RTOEaO1F/ssupfUmSCz1bKUOOX4+uWwDg3e9CpwAnKF/ofRWT+C?=
 =?us-ascii?Q?93XzEawhse14OgfDpUaj29URzxjxd+oMCH+EsMwn1UvpQwkS1GLIsSLxsCPb?=
 =?us-ascii?Q?hM29JYfLTFqEgDu0CCcxKeWnZtOZ/4lT9nI6h8d5BRRmG8Mn5y9ejVCU8/Dp?=
 =?us-ascii?Q?4LbeNHPzpwULgOaOyyDuHTdHBoL9PstWzawYu6gN+SUPMwqviXxqu3Ct0qSC?=
 =?us-ascii?Q?JPyTU9q6770Yvfg1QY6HOF9TojBj2G8Ez+d2mKxW+gtEitxx3gS3mWmypzaT?=
 =?us-ascii?Q?xHwYxqU16XK2wwkb/rzqoFB0Vnkz4SCgNckJMcLxnQlIirAWJrnfiYw0G6hB?=
 =?us-ascii?Q?QPuzBOJVc1lFdbpbCQ/wYZdbwng77DT9BjcTARHVv+sQTh11i338RxSZXNwI?=
 =?us-ascii?Q?XzzeujGb037j4Vepn2mXXS3elerMHhGItWmkjHBSS1cYZspzWE5t1qqp+ioQ?=
 =?us-ascii?Q?IlVU5iV18plNdqY+sWVLCnRPJyPAoN3ERHcXq/K9VDwbHe15Ckpy2KjgwNiq?=
 =?us-ascii?Q?6pMTduyNdcBMFVaS/EI6nbau2Dnq0dZLCiik30L4mFpD+rzao1XBtMovLSUs?=
 =?us-ascii?Q?3pa1M/A9Frwrz+xDdmFuMPwXVF6x9lZB7XLXgE0to6kWTCwbYSyS00DXjejg?=
 =?us-ascii?Q?0q2z58TbjCMLE2C37+QSPvkW?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 389dd950-6893-4ee7-8db8-08d9628fc877
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2021 21:33:13.4531
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5AfhmPEM2B1gFcIxF3KNU4SyZtPyh4Jsp6MYv+UYA63NkH2XIPbBbLLX+FfGbyK+XOZOn9QDIcr0J9MCppaIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4701
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10080 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108180132
X-Proofpoint-GUID: pWtYQxg0ktzloaDjakcTvSukbfMLpqxO
X-Proofpoint-ORIG-GUID: pWtYQxg0ktzloaDjakcTvSukbfMLpqxO
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot hit kernel BUG at fs/hugetlbfs/inode.c:532 as described in [1].
This BUG triggers if the HPageRestoreReserve flag is set on a page in
the page cache.  It should never be set, as the routine
huge_add_to_page_cache explicitly clears the flag after adding a page
to the cache.

The only code other than huge page allocation which sets the flag is
restore_reserve_on_error.  It will potentially set the flag in rare out
of memory conditions.  syzbot was injecting errors to cause memory
allocation errors which exercised this specific path.

The code in restore_reserve_on_error is doing the right thing.  However,
there are instances where pages in the page cache were being passed to
restore_reserve_on_error.  This is incorrect, as once a page goes into
the cache reservation information will not be modified for the page until
it is removed from the cache.  Error paths do not remove pages from the
cache, so even in the case of error, the page will remain in the cache
and no reservation adjustment is needed.

Modify routines that potentially call restore_reserve_on_error with a
page cache page to no longer do so.

Note on fixes tag:
Prior to commit 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error
functionality") the routine would not process page cache pages because
the HPageRestoreReserve flag is not set on such pages.  Therefore, this
issue could not be trigggered.  The code added by commit 846be08578ed
("mm/hugetlb: expand restore_reserve_on_error functionality") is needed
and correct.  It exposed incorrect calls to restore_reserve_on_error which
is the root cause addressed by this commit.

[1] https://lore.kernel.org/linux-mm/00000000000050776d05c9b7c7f0@google.com/

Fixes: 846be08578ed ("mm/hugetlb: expand restore_reserve_on_error functionality")
Reported-by: syzbot+67654e51e54455f1c585@syzkaller.appspotmail.com
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
 mm/hugetlb.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6337697f7ee4..54c715e7e362 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2546,7 +2546,7 @@ void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
 		if (!rc) {
 			/*
 			 * This indicates there is an entry in the reserve map
-			 * added by alloc_huge_page.  We know it was added
+			 * not added by alloc_huge_page.  We know it was added
 			 * before the alloc_huge_page call, otherwise
 			 * HPageRestoreReserve would be set on the page.
 			 * Remove the entry so that a subsequent allocation
@@ -4753,7 +4753,9 @@ static vm_fault_t hugetlb_cow(struct mm_struct *mm, struct vm_area_struct *vma,
 	spin_unlock(ptl);
 	mmu_notifier_invalidate_range_end(&range);
 out_release_all:
-	restore_reserve_on_error(h, vma, haddr, new_page);
+	/* No restore in case of successful pagetable update (Break COW) */
+	if (new_page != old_page)
+		restore_reserve_on_error(h, vma, haddr, new_page);
 	put_page(new_page);
 out_release_old:
 	put_page(old_page);
@@ -4869,7 +4871,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	pte_t new_pte;
 	spinlock_t *ptl;
 	unsigned long haddr = address & huge_page_mask(h);
-	bool new_page = false;
+	bool new_page, new_pagecache_page = false;
 
 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -4892,6 +4894,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 		goto out;
 
 retry:
+	new_page = false;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		/* Check for page in userfault range */
@@ -4935,6 +4938,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 					goto retry;
 				goto out;
 			}
+			new_pagecache_page = true;
 		} else {
 			lock_page(page);
 			if (unlikely(anon_vma_prepare(vma))) {
@@ -5019,7 +5023,9 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 	spin_unlock(ptl);
 backout_unlocked:
 	unlock_page(page);
-	restore_reserve_on_error(h, vma, haddr, page);
+	/* restore reserve for newly allocated pages not in page cache */
+	if (new_page && !new_pagecache_page)
+		restore_reserve_on_error(h, vma, haddr, page);
 	put_page(page);
 	goto out;
 }
@@ -5228,6 +5234,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	int ret = -ENOMEM;
 	struct page *page;
 	int writable;
+	bool new_pagecache_page = false;
 
 	if (is_continue) {
 		ret = -EFAULT;
@@ -5321,6 +5328,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		ret = huge_add_to_page_cache(page, mapping, idx);
 		if (ret)
 			goto out_release_nounlock;
+		new_pagecache_page = true;
 	}
 
 	ptl = huge_pte_lockptr(h, dst_mm, dst_pte);
@@ -5384,7 +5392,8 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
-	restore_reserve_on_error(h, dst_vma, dst_addr, page);
+	if (!new_pagecache_page)
+		restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }
-- 
2.31.1

