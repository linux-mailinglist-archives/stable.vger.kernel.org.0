Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5E096205B4
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 02:22:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiKHBVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 20:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232936AbiKHBVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 20:21:52 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D709813F69;
        Mon,  7 Nov 2022 17:21:50 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A80Nwmm023024;
        Tue, 8 Nov 2022 01:19:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=corp-2022-7-12;
 bh=Ev4WDTeHBe4mf7N1u2hQAkFy0LtFk8H4NF+5jfqO56E=;
 b=n062DOviWgD54/LQL84gVzczR8LstI7yAMl2zjNQK5aEcGIP0cB2H2vzqQ2i7f4CN192
 odS+7RTUW2St0sACnoJ0r2DHsEP/63hoPlbOew7IpW7g+vZzD80/JXWtA2SqgFhUweqV
 ZX8A6iDaEKdGsPdHjN7r7BTulLZ/GBKoNqfteIOSIzqPWz7khxbr/tNogwXED7gy1Ay5
 wR7BN4eRQfx7nOmylH8jiT5o/zHRagHgeVGvFhc7KFhcQ5euStq2/5pkedvZNocyj9P4
 baMozLBOU/+TahTmsfI2HeXaRHlSBmTcW1/7US6L2F3bHHZ2A882OjIxxHpPmR0fobIh Pg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw5t60-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 01:19:29 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7MT3gh025544;
        Tue, 8 Nov 2022 01:19:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kpcqfe12s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 08 Nov 2022 01:19:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMaosaMbEVtxiroeYIartXePOmzqQDM/oXIMChS4esswmfEUi3BWem/KXfwCFfF9zgVPTehY3kL84KS8rVETx2dNxdRkjy1pEyET3LPIkvNQGLgoC9jWb8YfWsABlQZAxbFAukMSeAkGS7yZvVUa+TDeOW0OYa4JNH5W7yg3mgkAsgh+7BmV1UBJADWKJP74LZaTMjGVpicj528Gs4uIBefGyq7KhvdHehD4Ql5XVZd3dEq4KcaxN1f+16Q4/8l/tNHHT3HuTsiTx0JDz31CAIZEOa3th25YvcteH4809/KIgccmDsRsQy3o7fkmd8JCBVZDYc9MaFopEE/PWqcGuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ev4WDTeHBe4mf7N1u2hQAkFy0LtFk8H4NF+5jfqO56E=;
 b=CEzdabAekhRu2S+TYUmlOcCQrWEsuN51MJjlWkRS1JBjJHfPsyfpIBCT4qTCMkDEbpJTREYdrhs7M0K05AHt7iDmM2i9qrJZR2I0uNQKhzdEEW11Eb0uNpUa5Alcq5riPzTEZ6nD+ylx7m3BCbWrW3LtRLrH89psBhUJEyPKWtL7Al/QFnNUZBgjVy7tG6uWej4iMbc06jVsyrXDEy3sb7INJXz3TEU4quoZMNxeMCeo5qR2lE2pk6UL494pfJoPiaAIPW5PnFV8+2g4ZYo59Elshm39aam4WV4vzY3Zgezqg7C5xBgGq43K088O01EvIewPBzuZca+E9siAe1tBNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ev4WDTeHBe4mf7N1u2hQAkFy0LtFk8H4NF+5jfqO56E=;
 b=ABxNLk7FcrKH2gXTgQ/t3JUGvQu15CBwP6OymvVlQHIrJxK3xe3qAa4HAl3ndyaRBnureMLueO7MeZRqTOfj+LpISTJ6AtrH3TFgufMYfgXT7MGkw1EaP93C4sEwBATfltGgyZihIwkiBBH3lg6lZWwn+A9tQijzVJlNv+8XeWI=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by SJ0PR10MB5552.namprd10.prod.outlook.com (2603:10b6:a03:3da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Tue, 8 Nov
 2022 01:19:26 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::8d67:8c42:d124:3721%4]) with mapi id 15.20.5791.026; Tue, 8 Nov 2022
 01:19:26 +0000
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
Subject: [PATCH v8 1/2] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Mon,  7 Nov 2022 17:19:09 -0800
Message-Id: <20221108011910.350887-2-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221108011910.350887-1-mike.kravetz@oracle.com>
References: <20221108011910.350887-1-mike.kravetz@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR02CA0005.namprd02.prod.outlook.com
 (2603:10b6:303:16d::14) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|SJ0PR10MB5552:EE_
X-MS-Office365-Filtering-Correlation-Id: 8484bce1-a688-41ac-c842-08dac1274706
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kVE/7G5QnRm9PLMetCxtMtz/eJMFpwdi8NfGiNJKLrmi4PlvClMouDNL8iOhH6BHLdxkmZxMF4BD8+Kb/5dXwbUQW0SG4IUjUCZb6MTGdG3cnm9vZYqTEwbLPxhhvhr5Eb4IXkh+ENj3VgVbfUj9btVt97IUGN5mQUgIk0ry6ENBcjEjd7HHSfr9pnomWQ2HtW9L+sYkREhR4aTSiSjtqMBOBH10OVkuunWtEPJK6bDu0liFTdKybUnjw4Le77PIKAYZrDdoNXe37KysTA/llpkEDgppOSwmOhIHUKBLyH1/TW9Zo9FrOSnVpkLrqYLa68QxRFAb7g2FJNhB0YEW++BReczb8VYJhTZ2rIuIFAMRE34kccu+5ny+bjndSvPwR8lBzcVdry5qe6CxHvhjEgv9vM/2j85tt++k5MVogGYQeFcj7BNODl/UXTPBuKYX325WQewyyxX00h8STuFSnRAFwdmA5JxOI3KddHH12EbZRHSXerJlVwfhV9xp8Ky3c/dZV//+iPERAQalcY5hu/TC6e+8XgtRzKQ1AGbyuscCsPlJrruZczqncA8/4Yt0HonqRSLtFMr6YdMYUL9555xE2XtphW+cS3fH/GagDsBs26Yj4Tx96qNM+gmJX9gnmIGEEJ5bbfkDCCWND3faeo0j0ABo4AiWDOog6DhV45VXB3YWj6g8O3lftqtDx9lqSMC0LXomksKt+Jl/x3nGQfTTiZxbbYUpbCWVH9fLZJc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(136003)(376002)(366004)(39860400002)(451199015)(4326008)(66556008)(8676002)(316002)(966005)(66476007)(66946007)(6486002)(54906003)(2906002)(38100700002)(8936002)(44832011)(41300700001)(6506007)(6666004)(7416002)(186003)(1076003)(2616005)(6512007)(26005)(478600001)(83380400001)(5660300002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?16WJ1h6S1zm8RjYBBxuyPECR7fsz+gwUoGF7zNmTyoPQsFDZL6fL6X9VUFwp?=
 =?us-ascii?Q?PR5IlDoIVL5faosuCZeoZC7E3NfK2aAzr5LXg2b1/GHnP12ekYtjTuf89P0B?=
 =?us-ascii?Q?mjoqkUjVbBXoTy2IPxjz05oOklMnFVG66HHNl0h8E0pu7tFGmaoIo+kURQik?=
 =?us-ascii?Q?xfTm6I08PiaW7D5/ooPCQqxNS3+JIJVjOEQlzMict/uI+gTD67KE+XcVu98M?=
 =?us-ascii?Q?jsWBixQfRO0jph1Xo7IthUQIQOCgZZ8WS1rpzDZ4ksKq9oXDD/5F0OS12pLu?=
 =?us-ascii?Q?AmIF1la58MRcKwywiKr2L+KgPFToP0OqQI4atu2f2Ztgx/pK4JKTq1pJtaSo?=
 =?us-ascii?Q?obZsSVI7zEXqAtc6RDk5Agp4w2FLkuOgNf0EpmLqFHmrxutl7M9AzvT4cuof?=
 =?us-ascii?Q?M6FD78/vF1EKKI9U+vnGPYcWpPACXdaiHesn5fMoJs3CpL9Y2DGgtu7vFHsp?=
 =?us-ascii?Q?DjaOVcOSyPeEwujxaDsleW0vp/EiyzzYREkwHMLeIiVMKBj2NeVm1zVDWmKS?=
 =?us-ascii?Q?O3nRMUjbfAgEXErSnmmyde9vD8cpBd21RnmDI4waQnP1IhgTzmhb3ZKvSlYq?=
 =?us-ascii?Q?JfKEwB/BltEY2bC9gfYv62eq0t4UDMSA6iJlcEujHMGMPv5cipgmAocehxpW?=
 =?us-ascii?Q?H2o00nr2IExDc1w5eAs/IqjQTXA8KSlVqZXt5wBsoGD8nyKwo5flYMSTJUXk?=
 =?us-ascii?Q?1lZPvDSd3480fkLzoYje0R1eJJuYILwm4n6Vrkcilhv7MUhoILmP8TjJ2yx5?=
 =?us-ascii?Q?EEU+Rm51wWh5dUEbEjHav8PRVC5WUbZnPquxwo8Ie1VG/nIFJ8bWTsdK5mme?=
 =?us-ascii?Q?GBglRnijSjGqtFaMSyLNzzn84C4ZBsJXrGfx7g5QtuovjSZbedklNC3l4GAl?=
 =?us-ascii?Q?nM+xo/wZeLjQSoSLYgPK2kzEFWn/hLTxwdLyLTx7G1Qbs7zScEazuYrY1VHf?=
 =?us-ascii?Q?wiauYQ950d2+GNvdl6FyYSWrFC6yMVrGKod4Y8+RiucwXd8kJ59dzgRg4phC?=
 =?us-ascii?Q?37yQLlfN5xHCJdiKHpRRQDLIZq37HyXA3lTn82x8MWHqFWoLgq6p2emY90G/?=
 =?us-ascii?Q?HqGK71W1sYsI3EZdieCTCGIIV6aFq/5gqm2xLIF/MdJUyxWiB6ls1IjsK1gU?=
 =?us-ascii?Q?zvegvDDm5dgBmFGnY4tf56wemmWe3sNUR1AjbZhx6dTy5gmEtfLJodgIUPHn?=
 =?us-ascii?Q?7cZ0WaqsLz90EvW5mc205ymbm6R4z4cLP8vX1OwF9WgxSbsIJuoaDvnnpIDQ?=
 =?us-ascii?Q?njb9Tuta6B9icuafwxZ3n6z9AtecjyZNs8Lf2ewbhPR5mmOC2SrGOJghaGm2?=
 =?us-ascii?Q?FXaeTNr5P76g8/HDeySDGCa8es+7ToL/Abx4d56F0393K6oK1umppyeCdh2t?=
 =?us-ascii?Q?HRCzlwILgVD1sibPRoGlZvJwnsLroNVIQf4N30Hj/2QrAVx9mkn4oUmmTblQ?=
 =?us-ascii?Q?+LjO0XpwOcsIr3D6i+DjCB6+f8pnY9SIjN/A+ELBEFMUR+sXIkQORODNyFHS?=
 =?us-ascii?Q?JOmpRrsOdTuRNW39N6o2Z7tyGwVEBigmo8UvP/ffTTXGP3BPF6B24iwEJ3yw?=
 =?us-ascii?Q?huUz17P/Dfw1WST7kLLM1CTnbJFqR8b78wuvRzogSN/imtVgd0Jun0wIMg9p?=
 =?us-ascii?Q?2w=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8484bce1-a688-41ac-c842-08dac1274706
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 01:19:26.7419
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ak7jstKhvgB7OiQWhIyN4be9qnx8XGXENVVNnlIJed7ev0U6eYenXkHpySGyGqlMs17UpWpw0XrBQVCBKSUZJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5552
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_11,2022-11-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0 mlxscore=0
 suspectscore=0 spamscore=0 malwarescore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211080004
X-Proofpoint-GUID: -X-v-jaCTA7eR2MVHNBUEjByZMV-axG-
X-Proofpoint-ORIG-GUID: -X-v-jaCTA7eR2MVHNBUEjByZMV-axG-
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

madvise(MADV_DONTNEED) ends up calling zap_page_range() to clear page
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

Address issue by:
- Add a new zap flag ZAP_FLAG_UNMAP to indicate an unmap call from
  unmap_vmas().  This is used to indicate the 'final' unmapping of a vma.
  When called via MADV_DONTNEED, this flag is not set and the vm_lock is
  not deleted.
- mmu notification is removed from __unmap_hugepage_range to avoid
  duplication, and notification is added to the other calling routine
  (unmap_hugepage_range).
- notification range in zap_page_range_single is updated to take into
  account the possibility of hugetlb pmd sharing.
- zap_page_range_single renamed to __zap_page_range_single to be used
  internally within mm/memory.c
- zap_vma_range() interface created to zap a range within a single vma.
- madvise_dontneed_single_vma is updated to call zap_vma_range instead of
  zap_page_range as it only operates on a range within a single vma

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h |  5 +++++
 mm/hugetlb.c       | 45 +++++++++++++++++++++++++++------------------
 mm/madvise.c       |  4 ++--
 mm/memory.c        | 17 +++++++++++++----
 4 files changed, 47 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 978c17df053e..d205bcd9cd2e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1840,6 +1840,8 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 		  unsigned long size);
 void zap_page_range(struct vm_area_struct *vma, unsigned long address,
 		    unsigned long size);
+void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
+		    unsigned long size);
 void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 		struct vm_area_struct *start_vma, unsigned long start,
 		unsigned long end);
@@ -3464,4 +3466,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 
+/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ceb47c4e183a..7c8fbce4441e 100644
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
@@ -5203,32 +5194,50 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
 {
+	bool final = zap_flags & ZAP_FLAG_UNMAP;
+
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(vma->vm_file->f_mapping);
 
 	__unmap_hugepage_range(tlb, vma, start, end, ref_page, zap_flags);
 
 	/*
-	 * Unlock and free the vma lock before releasing i_mmap_rwsem.  When
-	 * the vma_lock is freed, this makes the vma ineligible for pmd
-	 * sharing.  And, i_mmap_rwsem is required to set up pmd sharing.
-	 * This is important as page tables for this unmapped range will
-	 * be asynchrously deleted.  If the page tables are shared, there
-	 * will be issues when accessed by someone else.
+	 * When called via zap_vma_range (MADV_DONTNEED), this is not the
+	 * final unmap of the vma, and we do not want to delete the vma_lock.
 	 */
-	__hugetlb_vma_unlock_write_free(vma);
-
-	i_mmap_unlock_write(vma->vm_file->f_mapping);
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
 }
 
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
 
diff --git a/mm/madvise.c b/mm/madvise.c
index c7105ec6d08c..9d2625b8029a 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -772,7 +772,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for shrink_active_list to actually free
+ * zap_vma_range call sets things up for shrink_active_list to actually free
  * these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
  * shrink_active_list to pick up before reclaiming other pages.
@@ -790,7 +790,7 @@ static int madvise_free_single_vma(struct vm_area_struct *vma,
 static long madvise_dontneed_single_vma(struct vm_area_struct *vma,
 					unsigned long start, unsigned long end)
 {
-	zap_page_range(vma, start, end - start);
+	zap_vma_range(vma, start, end - start);
 	return 0;
 }
 
diff --git a/mm/memory.c b/mm/memory.c
index 6090124b64f1..af3a4724b464 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1717,7 +1717,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
 }
 
 /**
- * zap_page_range_single - remove user pages in a given range
+ * __zap_page_range_single - remove user pages in a given range
  * @vma: vm_area_struct holding the applicable pages
  * @address: starting address of pages to zap
  * @size: number of bytes to zap
@@ -1725,7 +1725,7 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
  *
  * The range must fit into one VMA.
  */
-static void zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
+static void __zap_page_range_single(struct vm_area_struct *vma, unsigned long address,
 		unsigned long size, struct zap_details *details)
 {
 	struct mmu_notifier_range range;
@@ -1734,6 +1734,9 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
 	lru_add_drain();
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, vma, vma->vm_mm,
 				address, address + size);
+	if (is_vm_hugetlb_page(vma))
+		adjust_range_if_pmd_sharing_possible(vma, &range.start,
+							&range.end);
 	tlb_gather_mmu(&tlb, vma->vm_mm);
 	update_hiwater_rss(vma->vm_mm);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1742,6 +1745,12 @@ static void zap_page_range_single(struct vm_area_struct *vma, unsigned long addr
 	tlb_finish_mmu(&tlb);
 }
 
+void zap_vma_range(struct vm_area_struct *vma, unsigned long address,
+		unsigned long size)
+{
+	__zap_page_range_single(vma, address, size, NULL);
+}
+
 /**
  * zap_vma_ptes - remove ptes mapping the vma
  * @vma: vm_area_struct holding ptes to be zapped
@@ -1760,7 +1769,7 @@ void zap_vma_ptes(struct vm_area_struct *vma, unsigned long address,
 	    		!(vma->vm_flags & VM_PFNMAP))
 		return;
 
-	zap_page_range_single(vma, address, size, NULL);
+	__zap_page_range_single(vma, address, size, NULL);
 }
 EXPORT_SYMBOL_GPL(zap_vma_ptes);
 
@@ -3453,7 +3462,7 @@ static void unmap_mapping_range_vma(struct vm_area_struct *vma,
 		unsigned long start_addr, unsigned long end_addr,
 		struct zap_details *details)
 {
-	zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
+	__zap_page_range_single(vma, start_addr, end_addr - start_addr, details);
 }
 
 static inline void unmap_mapping_range_tree(struct rb_root_cached *root,
-- 
2.37.3

