Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD786140BB
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 23:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiJaWhL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 18:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiJaWhK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 18:37:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B0D15718;
        Mon, 31 Oct 2022 15:37:09 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29VLhnMx031085;
        Mon, 31 Oct 2022 22:34:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=2CckP/SErtMWY7yNX58DA9ZRQ64UaUX1bJH44PBTRz8=;
 b=bZVbyheGfAklKy0lwxSCH18b/JqRJK9eFXGzGrX+w2AD9QhquUJKr+18OiTLA3hSyxne
 oP4Xep1T5umFBSmFlsZGcTVBsksHouTRP3QIw9YMqze0rIx9Jxd5PJHVzwVS7cukRy1d
 Q3rgTP7HepLuIjugYaRQVbIbyJQVpCr/fQj41xJlOmR50LRwbHIM+TdGDzYXio66XcZX
 AeI6fn63jPRXUHQT2xJfiZONd+dxflBblmxPSr9dE/n83+qCZUPwR47mLY3NtfX7Zc7Y
 ynhPe5jFlqXxduVmDrO9ZVAqHQTBjGP/n6ILs5Uy9u9gmIqZceJBi8TanoOUZMeBceIO SA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgussn7a1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 22:34:48 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29VK34bM033134;
        Mon, 31 Oct 2022 22:34:47 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtm3rgv5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Oct 2022 22:34:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5EPouUjmatR8Wvll6PiwnCrDiPtbe3kc8e5opKzyIE0xl05xqz+ofbiCLfKVIqO+1iLJT9iJXkXYfvUMxuhQKGcXGoHfLGagTacV35oYF+cN8dWvROJbt2PWY4XjSna8eqTwtd1OvNO1Ncgbk3FPAWRNg6JhcJ5+pLDVkZ80asbQc/MUcAlfcFYjU5wz/+NajKbMvaONwjKCEJfdCcBys++ecIkHcxZ5IYMzj6LM0MKMohMY/spkD/GHKD8id5azSVisruvWMatmYvl63kwCtwHWIZa1yIXHKd7ISg6rtheZk8isuOQJGKajqThqZXNWoJrPu4FmlY1iuQaIa5WyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2CckP/SErtMWY7yNX58DA9ZRQ64UaUX1bJH44PBTRz8=;
 b=QytODUZr5VFjS8qsfWmGjoraIjb3UhjfBmbOU4EcPzSvvLKfh6mojNQOgs19wKRemJmLAgQwrGXyMO9J85hzg4F45gAhyJvaIJCjgijiE5Ov8ydyybMxNj+y93MChdXA2ax3WuT5n1Z7xBpgry9aAL09bwxFpO1a+c8mU6R/x99MoqNrucxcIVWbuSpHhFEhd/M/vT1n7sYzEYDTN9rF3ku5ph8bhOzpQUTnARm8ebHp3V/fYjmgxAor3RLvsjWIz9iFAtSuvAUrVGB7159uJcwSaavyXo3UVA/dbh43jpB5jh/1KLG6mOYPtNJs+jGJRi4GZugQ4tDOoTzF5ZnR+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2CckP/SErtMWY7yNX58DA9ZRQ64UaUX1bJH44PBTRz8=;
 b=COXzqUGvVunDG/sO2e/KHxQYOLdxysTuW7fK+93FC35FSkOWZMVi546y84N+Qw3Sd1lypqQwkYGZ7fs33AGHNnVHCaMyC+PFzENzbJe+Uwoi9Pff4OWwSJuHVbVtx1iq3UZNih+RVbWZSzx8nwONOaqI0S8HSRWD9fkB73x+2bs=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO6PR10MB5792.namprd10.prod.outlook.com (2603:10b6:303:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 22:34:45 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 22:34:44 +0000
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc:     Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Peter Xu <peterx@redhat.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v6] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Mon, 31 Oct 2022 15:34:40 -0700
Message-Id: <20221031223440.285187-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P222CA0022.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:303:114::27) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CO6PR10MB5792:EE_
X-MS-Office365-Filtering-Correlation-Id: 3066d9ab-4d18-4154-6971-08dabb901c00
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s5Jik8MbAbKHb8gKcYXALo+uwdGp3Jl5T9ZO/zbmo67OnrxqTSQQSDEaH0ZRjhRnAPQKvY35P7RH1eOS1L6H/Z0smiMfcnh88aGljJpLQ2k2/dstmoqgpcAusM8Uqeycpi+oJS6ImOaIK3zs3MXpoduL8yvHcov9taqLxzcseo7HJij0YV+We5lyixXuGJSU8s9Fjo0qOEAXyxQYbuItBwr4CThvGIkubgL9eaKO8g960UBm6xEAGiNyHtBw9Y8q1LqzpMPqSzT58ksYchogv1MuV6hvWowbJypzH+FZMMsWKHee68I97ebngXGtEVA5hAorGZbPHu5oro0Td8coBVtgkAIru+pzzNepSV1xmqSwyyolsiBYNGh51Lz5LN49pUsy8hUnkJGUZomVYpM/k4gWqJd86OAumkelnuuxmz9Wr/kbDT5ShqVTirIZIc1k8SkhthD3CPrWUBqublJ3YqCvE9xfiJCcyHbN8mj3uxH4D+zXpck0dv2ay8Lip2/dc09rg5g1LbY5rK71PnFw9ZWypQlb+qW0kGjPL9VIaatVTh71e1zOVIWaOGL2FkzJLcsRg4U/9fuo4nw2nJs0HCFg4snzCW22ai3aWqdmCg/aN0N0Y7IGBjKEEczfqpRUd63cs2uVtSDlHLjlIkQyJZmCVBbQswwdyFTJNNqqQGMyNK2qse37Sc/C3Tz7ho18P+TiA+W9ChNuVSsuH8705mhEdYY0GNYMuVzYwprjaRQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(366004)(396003)(39860400002)(376002)(451199015)(86362001)(36756003)(38100700002)(83380400001)(2906002)(44832011)(478600001)(26005)(6666004)(1076003)(6512007)(186003)(2616005)(6506007)(966005)(6486002)(316002)(66556008)(54906003)(7416002)(66476007)(8676002)(5660300002)(66946007)(41300700001)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IR3NAyfSx6Sj4rT/u1NOkjPr3K5BKN+UTLI68vdbjVCuHC+duaBtHY2hfR3f?=
 =?us-ascii?Q?vE/YIaW7RO4cRV44gzP0jTascsRLBxNld8QvqW36rKh6qz5DkTj6qBoNhB1k?=
 =?us-ascii?Q?G3x5gi+vJX3rT2UqEHGRrk4rqsXV7gzs3JHbji3iuO4HrQYe9aW3f7ArpX+W?=
 =?us-ascii?Q?MI0CxFhfd8HK0/VME69X1rT1FWQ9PSOCi0/SoDK681b0DgCRk+yLy8n90uRX?=
 =?us-ascii?Q?s5yyYUPtSycV+Yh23FQbU93Vot13hABHSB4IBqgkUap289Tw0O7JYkPKKSUX?=
 =?us-ascii?Q?yG+iETmOD4pu4sYJW1sGqqJLweXpwrPp70XuMXmxdO7exmQaFJByn3s2KT9E?=
 =?us-ascii?Q?WUAX0b1wCsexRdD47toKNu1ATAndln3+Un3O+X99ovwuigmiLkj1ZDHuIn5J?=
 =?us-ascii?Q?dGCDGq2i4X3l7Y/X3FT6sL+vY55EXoBKUForJSqoqCTtZEkwH3G2GX+tVTX8?=
 =?us-ascii?Q?QXM4h5TGKALCwXvLx/JXW0IEXzO6ESEdgW0kIo9sropEKMURMP3X9JKGTo9h?=
 =?us-ascii?Q?ubTcZ8ydYOo/DhkLoVfZIBl6o5qqbJHg74cIBnhca9druA3UvNxL9R0XgmGo?=
 =?us-ascii?Q?L6FCLM4mVKvlOFxSF4F8TpRPkCulRXLXczJ0XGbSlrjr2o8a9ZfgPXTeOqKH?=
 =?us-ascii?Q?Y34a6oliUgQayxycidrx9VRWSdv5CkJd6yUtWAuttVa7gHJrqnjH2N1jC14U?=
 =?us-ascii?Q?ZiL5r1Ssyi3HO+AOvorSQXj9Z5pVu3yzNhQBgchbL08ZAJR/7j+43ytlu5As?=
 =?us-ascii?Q?wMrGUVCCZKMeYDInuKQExKl++zb5jfQbnKQ1jO4MPOXZkOTcrqIb/KRYSzGS?=
 =?us-ascii?Q?Z5BTtTgaMWJO6unwyVHDSmCWrmfvdZeUSkcyITM9q/uNgdFH5rRXEYixx4nS?=
 =?us-ascii?Q?THh2ZqDLez5ASttHBRYo24QGdv4ufnj5dv4M1M2D42k6l0cDJFKve0bts8O3?=
 =?us-ascii?Q?4UFnUi8lN4jVUtO9Ci4ZT/KdT2CWP8VwQV5iryt/FtYRMkUJvpyRdMmuRmcj?=
 =?us-ascii?Q?WMjUtqEbqnYYNGjVk6wNI2YRHL1GdBDbFEpHieJtemiuysNVh5BZHUnz/xXf?=
 =?us-ascii?Q?ilicYoOEb5SrI59Gug6noCxpLr7lZz8JYyxxBv4LOOLaKmdIMrkrjAtDwAPf?=
 =?us-ascii?Q?dLOpnD3MP0Lla0F1mbVcPGZvpVQx1SgACEb7S2tSgt6EPP2XR8Pf0vUbRYX4?=
 =?us-ascii?Q?5pUoN751LaMFj7rMLKa3UkjdaY1Fkn45sqPQlHkQS1NkV8yXzZLmmJNKcXwv?=
 =?us-ascii?Q?054T1oeT33fbgHhcLj5j7DbsYoMrXFBZh3U48Ml+qjeFLGAunlmVSi+tAhFy?=
 =?us-ascii?Q?4s1d1bTGFIh8GUbyoQ5UCksDTXku3mhMqysWZ+/Itz47A+PhfyqD31pa/6nS?=
 =?us-ascii?Q?8e3anpzu3lyYKHQd5sKtsqZaSIl6tTkKHebnRgiZnpN/XQOOi6EgaaLxyjGc?=
 =?us-ascii?Q?V7FrNMYLCFvFJBcJDErU15NfoqQcJlyZ7xZtx9XIDkvrjCCwAGZYE46G0IiL?=
 =?us-ascii?Q?nfjsZU2Fa2YBcqxjE/G3cVhC3/8bVZ/Hk8rUqKLkemvzVqckwld2RtlFkmB0?=
 =?us-ascii?Q?LeaAo5aOg/ZghgCyCXcy/QWoW/e7o4+Kl9TtUmJArQdk1yYaEei4LfYzsE/d?=
 =?us-ascii?Q?jg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3066d9ab-4d18-4154-6971-08dabb901c00
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 22:34:44.8163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OWF4zQYRknETp6Z9od3YXDscsRxRxwePisZXYU2v3cCnXUzq5PNonI8ne52rfGSog5xN/82MzKj7D4tmlU/fTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5792
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-31_21,2022-10-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210310140
X-Proofpoint-ORIG-GUID: TMsHkrSs2jLS8kmN-FaNxLrnxQBOgMtG
X-Proofpoint-GUID: TMsHkrSs2jLS8kmN-FaNxLrnxQBOgMtG
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear the page
tables associated with the address range.  For hugetlb vmas,
zap_page_range will call __unmap_hugepage_range_final.  However,
__unmap_hugepage_range_final assumes the passed vma is about to be removed
and deletes the vma_lock to prevent pmd sharing as the vma is on the way
out.  In the case of madvise(MADV_DONTNEED) the vma remains, but the
missing vma_lock prevents pmd sharing and could potentially lead to issues
with truncation/fault races.

This issue was originally reported here [1] as a BUG triggered in
page_try_dup_anon_rmap.  Prior to the introduction of the hugetlb
vma_lock, __unmap_hugepage_range_final cleared the VM_MAYSHARE flag to
prevent pmd sharing.  Subsequent faults on this vma were confused as
VM_MAYSHARE indicates a sharable vma, but was not set so page_mapping was
not set in new pages added to the page table.  This resulted in pages that
appeared anonymous in a VM_SHARED vma and triggered the BUG.

Create a new routine clear_hugetlb_page_range() that can be called from
madvise(MADV_DONTNEED) for hugetlb vmas.  It has the same setup as
zap_page_range, but does not delete the vma_lock.  Also, add a new zap
flag ZAP_FLAG_UNMAP to indicate an unmap call from unmap_vmas().  This
is used to indicate the 'final' unmapping of a vma.  The routine
__unmap_hugepage_range to take a notification_needed argument.  This is
used to prevent duplicate notifications.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/hugetlb.h |  7 ++++
 include/linux/mm.h      |  3 ++
 mm/hugetlb.c            | 80 ++++++++++++++++++++++++++++++-----------
 mm/memory.c             | 18 ++++++----
 4 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 3568b90b397d..badcb277603d 100644
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
@@ -428,6 +430,11 @@ static inline void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 	BUG();
 }
 
+static void __maybe_unused clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
 static inline vm_fault_t hugetlb_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 978c17df053e..517c8cc8ccb9 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3464,4 +3464,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 
+/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a0289ef09fa..7ba46fa62f75 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5072,7 +5072,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5087,13 +5086,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	tlb_change_page_size(tlb, sz);
 	tlb_start_vma(tlb, vma);
 
-	/*
-	 * If sharing possible, alert mmu notifiers of worst case.
-	 */
-	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, mm, start,
-				end);
-	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
-	mmu_notifier_invalidate_range_start(&range);
 	last_addr_mask = hugetlb_mask_last_page(h);
 	address = start;
 	for (; address < end; address += sz) {
@@ -5178,7 +5170,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5198,37 +5189,86 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		tlb_flush_mmu_tlbonly(tlb);
 }
 
-void __unmap_hugepage_range_final(struct mmu_gather *tlb,
+static void __unmap_hugepage_range_locking(struct mmu_gather *tlb,
 			  struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	bool final = zap_flags & ZAP_FLAG_UNMAP;
+
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
+					zap_flags);
+}
+
+#ifdef CONFIG_ADVISE_SYSCALLS
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
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	update_hiwater_rss(vma->vm_mm);
+	mmu_notifier_invalidate_range_start(&range);
+
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0);
+
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
 }
+#endif
 
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	struct mmu_notifier_range range;
 	struct mmu_gather tlb;
 
+	mmu_notifier_range_init(&range, MMU_NOTIFY_UNMAP, 0, vma, vma->vm_mm,
+				start, end);
+	adjust_range_if_pmd_sharing_possible(vma, &range.start, &range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
+
 	__unmap_hugepage_range(&tlb, vma, start, end, ref_page, zap_flags);
+
+	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index c5599a9279b1..ecd2b4a6cbc3 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1671,7 +1671,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
@@ -1704,15 +1704,21 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 	MA_STATE(mas, mt, vma->vm_end, vma->vm_end);
 
 	lru_add_drain();
-	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
-				start, start + size);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
-	mmu_notifier_invalidate_range_start(&range);
 	do {
-		unmap_single_vma(&tlb, vma, start, range.end, NULL);
+		mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma,
+				vma->vm_mm,
+				max(start, vma->vm_start),
+				min(start + size, vma->vm_end));
+		if (is_vm_hugetlb_page(vma))
+			adjust_range_if_pmd_sharing_possible(vma,
+				&range.start,
+				&range.end);
+		mmu_notifier_invalidate_range_start(&range);
+		unmap_single_vma(&tlb, vma, start, start + size, NULL);
+		mmu_notifier_invalidate_range_end(&range);
 	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
-- 
2.37.3

