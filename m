Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A666090DB
	for <lists+stable@lfdr.de>; Sun, 23 Oct 2022 04:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiJWCxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 22:53:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbiJWCx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 22:53:28 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FAC16A50F;
        Sat, 22 Oct 2022 19:53:26 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29MKxH8x030974;
        Sun, 23 Oct 2022 02:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=VQA2SOQAFtFMFnBZwPUrUgxV3MUHam15AWM8OzSqSDc=;
 b=Y358uiB2yQmluZqubTUCG9mQct7Bt5hF3FedgPU4pEoersSwgMQOxKyf5GXrx5YHpDLX
 JPdP/BlYTPGT7/u4v6VFk0CxQR3SXNpMcmU82NuacCPWEjCmcfI31GH0/mK9KfHtf1be
 D1RiMaLpGq+jeG40ZMRtyLU8FzTA81ch5AWEnUEGRSKkvMBVEsIHSkDDy3OP9p7Kirz2
 z1huT0HybQwKC3fxMYnN7LnjhApggnYDxcFwdvhip360Qmh3oQ8Yq09hHYkVI0lVcJH2
 Us+VlkRHbBp3iO2/Tb7jo7ZxpGDD4DP6oatglmAyxbmeAvdQkppFUBKaHr2lGUuxOz1A tw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kc741h7w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 02:50:56 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29MHwQ7F032346;
        Sun, 23 Oct 2022 02:50:56 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kc6y305uh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Oct 2022 02:50:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ScGqzPZWE36p0mLxW1JJxo2oXr2nbWCFhHP5jcfSZAsAJhFXUdlV/XhU6P+Jnb5fXAsaXS5bLKAC6DonSYYgGqj1RO/inGuxoumhsAadLCVojB0HIT8Z7tFwrfrhnzTWZu9IQAj9Pj7TUtkUPr4y+Xz9NP0FZRaqvcL8HXQgxojx7NnhNsh5lK1/Ec5mwX86X9fknhmJxrFGFrWrMIT9jYgSYs8rGLggxhk4t8x3Q6XrCqeKct7nhhQPBSPXTS4+o5UCJjna2wnao8bt76WvmC3cP7vvrYA7ZM7wo9WnpGhB6vQs0hM20dHsKFTZ5MLiWXWlKyw4cf/edTwXQu4oyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VQA2SOQAFtFMFnBZwPUrUgxV3MUHam15AWM8OzSqSDc=;
 b=PjaAeBIddbbwpuDZ7q1paEs3i67ZMnGTvwNKtCMRXKWfPYnzp3erGO7RwV38t5+2zb3bWiZ9HDGS1TGyDEFJnx0TnO5bTNGIeMCyRReqcG/xW1RbVHjurkOarQN2QbFVRCZzgMS0+kVAgDpgvB+uvRW4Algmwe8bHJxyo0ubYfbcKELhOiXbbsP3icHH0Gf0uBKiWca/s7e+qpYBwwb0dsePb0tEcjOn71lstgiL11/gwrgRdSX2G5ju0ffySTN4Ltmh4YeR/thr50IvEYFo8sJzKsUqWdB0g4PMcbE/7eBSuZTQOhpvBrlaIDcV+h6jJ962fSZ3MxsPiimSZN+kRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VQA2SOQAFtFMFnBZwPUrUgxV3MUHam15AWM8OzSqSDc=;
 b=gEW7/qUgpuJ5KQdacC+IqZ2wcsvPh6MZWELp1DMDOjKTQ0JUbErpC+OZRgVpPNC8Koh80m1yTSUnXA/GNBRStKrk+tIogwq1xbGVBoCwzAyFnvwgmhtzGnccyYjv1R7cLZnc7jdtyk3H8XXMBcJlI5mbuUgJagVijP27dGliYMU=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS7PR10MB4960.namprd10.prod.outlook.com (2603:10b6:5:38c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Sun, 23 Oct
 2022 02:50:53 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::5f85:c22e:b7fa:21bd%5]) with mapi id 15.20.5746.021; Sun, 23 Oct 2022
 02:50:53 +0000
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
Subject: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Sat, 22 Oct 2022 19:50:47 -0700
Message-Id: <20221023025047.470646-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW3PR06CA0020.namprd06.prod.outlook.com
 (2603:10b6:303:2a::25) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS7PR10MB4960:EE_
X-MS-Office365-Filtering-Correlation-Id: 7382de3a-56b0-49df-4fac-08dab4a1665a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: txtaNrxCMPrenrLGmLjEXSr11slc45pbL33sLL6+EcKFFPRVEUjUnIRhT3Wu/yq8t+5qdz0v6OPTHVfunxucmDL4sJ7zhGMw65o6aZFPhjDrnKGUEM28xtE/iAGBXc3BjLEe2JM+IJdumZGi/fIHhj4HQ/eNlRs4DUcInln23h6JtU9reF2BzhzlRw+S5Ld9EVfHMMP9vwvcWJK/O7Rq+apbs79xn3J4CaaTFDu5ZGtyCTsKOIB+is19Mg43M6t5dM3iXI+rVmoT26S1I3rOcKXWn7NzDXmFMY52+LXDbxsnSF46fpr5GNLrnLbAjdbSzEd1ZGDSeuauPN/mLF5dV/Vqy+EoLEXnj+8DokS4gOcP77SFpxd1cXgAL28TQTd8nZ5oYrMFsZtehsmxfSWCDUw8N+xGVNHYnokik2sq/I1cTzF8uI8L66WPKjohq+bWe9eOe8xkQlon6TeGMCL/wonHJIM/weiA7vHZrxir0IrBbdair3nKYv6YwKTqwjLp3vrIN4z5uJnxPIEFLnUCC89L986xmzm/mB2GggwFfBb6l9ibn2AxHSM86JaACl1/MMNCVoqXU0v2zTU619EhU8srg2LPr0V3ljpl0iZ3rrsU1iUTAxppvll8l0vvewGb26OxEqsuJ4/QvuD04tpS8j4UBUFZi8dMWNYMgM2gyzmpGT6syt224NGBlT0T/OWhXtbtk8wX8kxaKxHeeLfDCebic6xf99c4pDhiCB3z+mA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(376002)(39860400002)(136003)(451199015)(8936002)(478600001)(83380400001)(86362001)(38100700002)(41300700001)(4326008)(966005)(66556008)(6486002)(8676002)(5660300002)(7416002)(316002)(6506007)(66946007)(26005)(54906003)(6512007)(1076003)(2616005)(186003)(44832011)(6666004)(2906002)(66476007)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xIupHzxbEU6pkWC5mzB59JL+yp43keoqcN/41v6PPkJuXDkYOaMIsV3rIxdW?=
 =?us-ascii?Q?OC+8S38G7HwHacoooSLGDla+AqIH5EqDeKQ5nvJrjTncQfnOVBKdFAntfNa0?=
 =?us-ascii?Q?INFnUitECtt9SKqIMvXo6QgFIfuQVPqpiFJlCminAg79xToQWzAei+Z4CNLY?=
 =?us-ascii?Q?i9yCV9OdBTMDRrXz4i34bsvwAGg1cexBQ81j8z2Q9Qpw+8z6aGgZDy9M8vwM?=
 =?us-ascii?Q?gSPwXCvAO4PmJEk7cThKOXL8pyA0VhNcv1qNfe9brV55a8qlBN48LRbM8EJy?=
 =?us-ascii?Q?f0LoVDyiS21wcqbch2DfzYgJbRi82U2ga2MjVBOMCrDMCtQkQX2C26YdyKem?=
 =?us-ascii?Q?e9N3kF8lREi+pCX8UWU7Wjl6eZGQQw5xdTrpkMOdLXqHk7dOTrPQsFms4lHb?=
 =?us-ascii?Q?w9uQkoFKis3Tc/1PiSATYPjMUVcyf4CRtZX3FYcJej7oRC5kv7HcFz8yB9Da?=
 =?us-ascii?Q?GukKMoLeRqjmCp3EqxB04mA0iV8HvBnde5TnVO10MZ7oXN87LeDPv/S78cAa?=
 =?us-ascii?Q?D+omNbkQOI3x6V6SEsM0xebvQa5DlaNAFR+aqWFa2SrzxYGORop1ac4MBoiw?=
 =?us-ascii?Q?2F/BcxlgfhtCOn2yq/gKplOKRH2pmkKaEMzxwKRjfm9p8zUx/dHVq17zQktD?=
 =?us-ascii?Q?foRjFqCyL6JHMNseV7ZCC0wP9xi3GNaiwl0UrKbAF9sj0GLbznL8KHiysr8Z?=
 =?us-ascii?Q?54Mv4i5y4r72J+1spqJhAjRyedeAQRukmB0DexE6xbqOYuF/EZ6Riiing7PU?=
 =?us-ascii?Q?m1wlLyWwrY8WgdJRfs0Gs5P7BEXOaaxTFEOnTt9+cLNsv1R4ZQkIFvls73Te?=
 =?us-ascii?Q?0rkJs6XPZFhYu4s1jJu29KwC3+vqj1BSybD9fZJL4ILdyMIVvWIL2SG0JHTS?=
 =?us-ascii?Q?GP4+e5eWJd49AS+juCkUmLPMOBv937x/kP3w0HsTko76y9Hho+ESn+Ph0uFY?=
 =?us-ascii?Q?3re3czZpuNGG9lw4JbAETBmCN4C6IprujDBtQ6ECyVWTrF648wThLkbfPLEs?=
 =?us-ascii?Q?ndp2bYgMtjU3KoIco89eec0/j+eov/HMa3fJOimw0zbzdHeAJ31mE8DJJz+2?=
 =?us-ascii?Q?6D6Zhm4+l9VNEaH5yCPd1aftHm7Sf9gUpk1MTIicBbMjei9Pv1YeInJHv/Z6?=
 =?us-ascii?Q?LyV7PRjvqxAgFtHLVjfqMf6H3QEAELj4xq3Kl+xbYMph4m3dseyHwjMGUPbV?=
 =?us-ascii?Q?wJTQSs9/Z/CpKjqJbVMwlKPAD7134W72Yk+uUc/xueC4JtnW1/lqBI52Xrys?=
 =?us-ascii?Q?vYDY1kx3Pb+nF4wpMWswxg1324RUz2TXXHPE7ymjvDvykBeA8XTrJ6U2au9f?=
 =?us-ascii?Q?c8IVHwJqT1+K/sUqve8eB4S2FZKwSI64Mp3OqfN5b0JOhgQaKULWFRLeLdT1?=
 =?us-ascii?Q?HS0QywIUKDnjRmpmdRaDYWdmSSeve/qIF1lfw1s4z4BSPbQZDty+kNXt5kcW?=
 =?us-ascii?Q?2mcfcjL6vhp19kYSMg5EGzlKP5DvSNOijvW0qjR/+5M1Q4CF2Dee0IVdYwvO?=
 =?us-ascii?Q?YyVh6qeLaK132LxIbiJQxxTZSqhG5kpyiZsh1ofVNrH39/fJ3D3GvJ+7D61k?=
 =?us-ascii?Q?DOKZF2sH66BI74tey4KgowPKd8PK8mtzrit5JOlSHYB+73cSQN+1DFhEaV7h?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7382de3a-56b0-49df-4fac-08dab4a1665a
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 02:50:52.8618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W+d2Xjww9VPlAJ4FxAe8Mkw5p6DNcO6uvA6tiHNN8F5e7a14tNcbjSQXrxtcw3b2MatQNqmiXFLAefEiexVa7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4960
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210230016
X-Proofpoint-GUID: bHqztj2VfC0b6lL5Mdv8-gZndM-eG8pr
X-Proofpoint-ORIG-GUID: bHqztj2VfC0b6lL5Mdv8-gZndM-eG8pr
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
v2 - Fix build issues associated with !CONFIG_ADVISE_SYSCALLS

 include/linux/hugetlb.h |  7 +++++
 mm/hugetlb.c            | 62 +++++++++++++++++++++++++++++++++--------
 mm/madvise.c            |  5 +++-
 3 files changed, 61 insertions(+), 13 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index a899bc76d677..0246e77be3a3 100644
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
 
+static void __maybe_unused clear_hugetlb_page_range(struct vm_area_struct *vma,
+			unsigned long start, unsigned long end)
+{
+}
+
 static inline vm_fault_t hugetlb_fault(struct mm_struct *mm,
 			struct vm_area_struct *vma, unsigned long address,
 			unsigned int flags)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 931789a8f734..807cfd2884fa 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5202,29 +5202,67 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
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
 }
 
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
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+	update_hiwater_rss(vma->vm_mm);
+
+	__unmap_hugepage_range_locking(&tlb, vma, start, end, NULL, 0, false);
+
+	mmu_notifier_invalidate_range_end(&range);
+	tlb_finish_mmu(&tlb);
+}
+#endif
+
 void unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			  unsigned long end, struct page *ref_page,
 			  zap_flags_t zap_flags)
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

