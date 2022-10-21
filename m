Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C691C6081FE
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 01:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiJUXJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 19:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiJUXJ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 19:09:56 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CFF42B19E;
        Fri, 21 Oct 2022 16:09:52 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LLDtIa004534;
        Fri, 21 Oct 2022 23:07:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=Al0ZGHQvCxYq5w5/nwNfqpAHRIrSwyR0+SaDxTSRDTk=;
 b=MltRD3n1BO0Ig9WT1Y0UbT/v4kQz/n+idflVAU7OO2480cX7RrQ1wi4XzjgnMhG8F6dR
 aq/DfP5D5/RhqaO4Che4gjYAH+htlh2LW/YhEMJs6hKRK3vREB3jrusuNyZxWDzg6h+4
 xB1v9/dGf4ZS2TM7xBomRQDh1apwrLixrut0zd08lCbeqQvRkTYc5IKBjPaWbxTwMOyZ
 1Rhx11HbFivUrdAVucoC8Xe1ED4UFFCO3DB3YFlqCcAHjWC7K+4qpGcU2phB0qSmFobA
 Asm8BIk4NV5wsIHAbhM+AkL6IgjLGdJbp3pPF3PfNUc1ttCpN12sz2MpxYYBbS8lAgYZ hQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3k7mu0akeu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 23:07:31 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29LL0BwI018105;
        Fri, 21 Oct 2022 23:07:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3k8j0ucru3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Oct 2022 23:07:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIRDw5eY527WbGu9g2rAlttaNMXiz9HYUkr7PVTlatY2zrROa++Z0RJS1Bx+EXiEm2mEzP9izXEUfaGNep8yHLcmGLibK7UiU4XBKAty/pKzqGbp6gKJtptCRIJAuzSzLEOpLLI9uyFwACHiRqymHe2GNsGzEHw0PniNaRs0BdABe4liVH79WC/rVqdPUa+vC9Y2TqRNO7yM+tsDWmwjpAqaLWPdrf9vW1gpuqwmLrlMadHcg+5L4G9xhD6JnWeaWa23Hz71lL983aiMI6if+QptZP1ZwYQAZkPx2nNgzDIb6SI01emNPsU2HMlhwBh6B/F2br9P3HLXWKYh7PdHPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Al0ZGHQvCxYq5w5/nwNfqpAHRIrSwyR0+SaDxTSRDTk=;
 b=APZc7gnUZIvcc2yWVOo2NxyKCQB5adoYWgM+PmI6M/Yqvy44Z1gz0/YZc3zqhWfVs9iGHpdxYyegDCdzLui3pZu9y16CNAE9iNnOqrLjX28m02pdWObL2jm3C9+gps7QckU/T+utOfALTH2rXgcOGCSbLaS6KrRWds/NhsQwpFhywi3DI1svgUCEFqQCtX74jBnj6mXQKEI23QzlfOHNu5q6h54vx1yD/1nD+ph7BBXudarXQFUpeudIJXZ72a+PUWNhUMaNcPY8XxIb0A830Cth9t/kRhnuxzjI0LBgp2HQ290QyHKz6wCZokfB6cFFobL5Lqgkn3F/NCtsPxw9UA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Al0ZGHQvCxYq5w5/nwNfqpAHRIrSwyR0+SaDxTSRDTk=;
 b=rH6SzOqAwO7pCy57SWI6AAmxI1UzdnwEmWJuPPGzkwXXInHI03aXfJ4XYcX6tLd5ibypHCuP0ziKgXaoyo4T7ju5dtBF3yTuevHoTE60/WmryzC0tw8K5KUorjvDd3lNFS01eGcbx8L+U3G6ZQ8Z68x7D0BuSFhE4Ca9A2KWljE=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by PH7PR10MB6380.namprd10.prod.outlook.com (2603:10b6:510:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Fri, 21 Oct
 2022 23:07:28 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd%5]) with mapi id 15.20.5746.021; Fri, 21 Oct 2022
 23:07:28 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>, Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Fri, 21 Oct 2022 16:07:22 -0700
Message-Id: <20221021230722.370587-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:303:b9::15) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|PH7PR10MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d0e9dea-d08b-4334-21c4-08dab3b9065b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EZpIYMwIIpv2oqQa/F1wq4hc8kBCjmvRVbYknOI/77ZusU5IoVtq2OcEEfwmbv2cj68SkblzuDsoj59z7/g6HoziYEx6l0r98gGY9nc9Sf9EJLsHn7pVRgpZiRmZR5Ruloxk51vDP3bO6mYFt3aiWStynpS+FHmPPDGbVTEXa3oHNyDYGsUL6ubd+UOzVOYNIQPYJE1GFVLQ8yBdCa3MU3JIBDhus0r+lX5n/62mwhRnyUqZthbL13sj/VYbi4wIl5goFH3l1Yhy7UtrhY4GlE672PDnwvrH4UIUoIW64x+p6cs5FfrtakAB76LcioWIiQzusrQBkrSWUd1wDe7Gsv3zy8mAnNd5TTd0d0h2CQnoXKDPyLQKv3F65+PtpOMth2K2ONokrk05h4F4Rn9QUXABuGdV4UXJz/TnS4HN6LVD3wOnofpwiQu1RMapfUXQcPfPKYwecHuJAgeW3DR1t6tWLk4xutzeXnK6wNWACMY08TshF+taPH/yB//TWyLjn4HYrr/bvXzIHDQRP3hpfW6TZkYDw9VjL34yit5LsllpLt+aVf0rpQUWK0/9u36PJQ0s85muYw89Ek3yYwKVJZCzyJo8YuaFsOlt4fE9hEKfSZfmlolo0JVMlaG76ROUbXSEgjHbRs0blEgXTiL/ohlXe0Tl7cpIpLOh3F724lImn9BW6l7/UxW2dQPx+ldo3PJacXWWmi6fq73Kk/jioa/9f921V7WkgtGw8ClYb2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199015)(36756003)(86362001)(186003)(44832011)(2906002)(38100700002)(6506007)(1076003)(2616005)(83380400001)(4326008)(8676002)(478600001)(6486002)(6512007)(26005)(966005)(54906003)(66946007)(66556008)(66476007)(316002)(8936002)(7416002)(5660300002)(41300700001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tb7RpENoaWy4KNi4Isw8lCLYhpC07lK8Pgx9uHrlZSNjUarH9fBI4nKTTJiD?=
 =?us-ascii?Q?+1Q0mx7G4lxiPB7O1q4bOzihowFxyxBnfzcWm8yGoBFTLbVdYC4P3+XkxFpT?=
 =?us-ascii?Q?Bg/BgnIVaDbAkCGaQjCJq74pFBHdNdRkzFxQsObTh0m7OIg5J8IMc/s/ciR1?=
 =?us-ascii?Q?EHtV2Tm+myeBlNeXHGwzfdnyYa19haay6duKFSs56bje4AXiNyIS8uBF1QCv?=
 =?us-ascii?Q?ulwBxEtKKbt39fWfvOQChmmmzHaTG2J35ZvCrOBb4XwPS9KVlrVPEfuWYtTf?=
 =?us-ascii?Q?sVIoESa8q0CWvIHObEKIe4m15COYya0qbmyvss/XLcO85quNheDXM8Do1e23?=
 =?us-ascii?Q?iynXY6DbonZOqrdUDR6J3kAWQ9mtv51MR38GA6Mg2FJGsXbTTA6IT1HA8Z+i?=
 =?us-ascii?Q?BY3JYExjoOO3Rj2HhYI1TNwOwoskozQ94HP/JjB5VH/m2gdR0Md9RLeqfNgo?=
 =?us-ascii?Q?u7AntsQI5oftdvA0MVxtfwr6pRC7Zp8yPgV/sKOwmKDuy4zj/h7CkDwN98nV?=
 =?us-ascii?Q?TK8G3LBIF6xVMakMTEqrqqtGH0MLqnL8yEoGvGTdRNsHiJK5iNgZRQxAJOYx?=
 =?us-ascii?Q?KAj+lhw9BTqICllOywCYe2qStfk30c/cE+2zuqZgIEAsL1+zJgfd2TUqVKbN?=
 =?us-ascii?Q?R3Y1nkmUJa6vj7qNyL4jqmcwYszmhlfCFO9CpjDGzrC2RJ0g2SkDXZw+iyz5?=
 =?us-ascii?Q?2MYeTGRH+9BoOflK3/iBZbziIo8dnDBbIcFlsLUTnbxGVoZpTMS3Y+Tmn+gp?=
 =?us-ascii?Q?67+yfK3o0oQrgVHfWe5lElBxZpze2SBlt63D/Y5C1xmOmNL75Y7UmcyH28ZV?=
 =?us-ascii?Q?yjPSKliJCAs0582gZA5IubyY/uTGE72kO2uhwEQDmpuvC5tKaOG8K99VsS3a?=
 =?us-ascii?Q?WvUpVCYRgS+iAG+4Fth03WdHiuFVoFk+kNbpdnCzQ4WyetV71fK0hNanWzBt?=
 =?us-ascii?Q?q+N5MlUTtuqX6z9X1vr73o4/dJeoByuA9ZEi20CRkcJtLAotjs8obkftUlFJ?=
 =?us-ascii?Q?hPUE+tm3uI67SGKqkSH9SuW3FtBlSPCrryqH/cYH1y9tBrJdnSEj4hoUtx6Z?=
 =?us-ascii?Q?10TI/p52+b16qk/3CrvnakSIHtlP9Mso8dNumv6HYF/NI7kUXX0NIanBMhZ8?=
 =?us-ascii?Q?u7i33h4DW/wAbwAViiYiBS0gselZSRGfEDaxNAXF/I864HM9tTqUUseiVLj/?=
 =?us-ascii?Q?rP5Ty2513s2PUdDCEfJJawYuptqBlUW68xUUkcEK/q9ObSC+8qUeqveBNITo?=
 =?us-ascii?Q?IwjN/HS6Q1l1CbfX9tZ09FFfC27bbtNNomRuY15hdpDxSWsRuJXsQ0t73IxY?=
 =?us-ascii?Q?/TwlnrpOxlX60E+75W9dq62J1bVNxLaU0kbk791XcfA1xOh9pHHrd/DDHm7W?=
 =?us-ascii?Q?VwdykzhlWE9QusJPJBaEXBbnHcSFYnI5GYJLhl+zteGh2Ds3xcynQHt9NMyv?=
 =?us-ascii?Q?lVB33sdDh6XEVd9HsPGfrhiISmBzjO+aI+TOpSJcPjc5jmT0ciUKT8HdAcSX?=
 =?us-ascii?Q?hWybqbdNARN+inQU3mgryNFG6JRJVwIeFdwTwChmdV4jF5Blq9BIUJG4NpWp?=
 =?us-ascii?Q?fX05kwlQOp1u9P/IUW+osg2lM2wdoPJ+7veyHeFnER7c65lodzo0iDBVKDtV?=
 =?us-ascii?Q?kg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d0e9dea-d08b-4334-21c4-08dab3b9065b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2022 23:07:28.4242
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EZ+ymqBOehclu+u5HTIlD1SKJfv0iNZg4mAP3nuj3BM2WXpICU8BUPG7DzkLT5NyF+K5GaBpl8ZFvgmbQI80Ig==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6380
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=880 phishscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210210134
X-Proofpoint-ORIG-GUID: 8EfPUnoYRoOABdx_OA0jm594Y5Oyqx0r
X-Proofpoint-GUID: 8EfPUnoYRoOABdx_OA0jm594Y5Oyqx0r
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the
page tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be
removed and deletes the vma_lock to prevent pmd sharing as the vma is
on the way out.  In the case of madvise(MADV_DONTNEED) the vma remains,
but the missing vma_lock prevents pmd sharing and could potentially
lead to issues with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping
was not set in new pages added to the page table.  This resulted in
pages that appeared anonymous in a VM_SHARED vma and triggered the BUG.

Create a new routine clear_hugetlb_page_range() that can be called from
madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
zap_page_range, but does not delete the vma_lock.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/

Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Reported-by: Wei Chen <harperchen1110@gmail.com>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
---
Note: backports to stable will be somewhat different as hugetlb vma_lock
      was added in 6.1.

 include/linux/hugetlb.h |  7 +++++
 mm/hugetlb.c            | 60 ++++++++++++++++++++++++++++++++---------
 mm/madvise.c            |  5 +++-
 3 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a899bc76d677..5cf2028ebad4 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -158,6 +158,8 @@ long follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 void unmap_hugepage_range(struct vm_area_struct *,
 			  unsigned long, unsigned long, struct page *,
 			  zap_flags_t);
+void clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end);
 void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma,
 			  unsigned long start, unsigned long end,
@@ -426,6 +428,11 @@ static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 	BUG();
 }
 
+static void clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
 static inline vm_fault_t hugetlb_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 931789a8f734..3de717367e0a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5202,27 +5202,63 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		tlb_flush_mmu_tlbonly(tlb);
 }
 
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
-			  zap_flags_t zap_flags)
+			  zap_flags_t zap_flags, bool final)
 {
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
-	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
-	 */
-	__hugetlb_vma_unlock_write_free(vma);
+	if (final) {
+		/*
+		 * Unlock and free the vma lock before releasing i_mmap_rwsem.
+		 * When the vma_lock is freed, this makes the vma ineligible
+		 * for pmd sharing.  And, i_mmap_rwsem is required to set up
+		 * pmd sharing.  This is important as page tables for this
+		 * unmapped range will be asynchrously deleted.  If the page
+		 * tables are shared, there will be issues when accessed by
+		 * someone else.
+		 */
+		__hugetlb_vma_unlock_write_free(vma);
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+	} else {
+		i_mmap_unlock_write(vma->vm_file->f_mapping);
+		hugetlb_vma_unlock_write(vma);
+	}
+}
 
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
+void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+			  struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, struct page *ref_page,
+			  zap_flags_t zap_flags)
+{
+	__unmap_hugepage_range_locking(tlb, vma, start, end, ref_page,
+					zap_flags, true);
+}
+
+/*
+ * Similar setup as in zap_page_range().  madvise(MADV_DONTNEED) can not call
+ * zap_page_range for hugetlb vmas as __unmap_hugepage_range_final will delete
+ * the associated vma_lock.
+ */
+void clear_hugetlb_page_range(struct vm_area_struct *vma, unsigned long start,
+				unsigned long end)
+{
+	struct mmu_notifier_range range;
+	struct mmu_gather tlb;
+
+	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
+				start, end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	update_hiwater_rss(vma->vm_mm);
+
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
+
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
 }
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
diff --git a/mm/madvise.c b/mm/madvise.c
index 2baa93ca2310..90577a669635 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -790,7 +790,10 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	if (!is_vm_hugetlb_page(vma))
+		zap_page_range(vma, start, end - start);
+	else
+		clear_hugetlb_page_range(vma, start, end);
 	return 0;
 }
 
-- 
2.37.3

