Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F399615706
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 02:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiKBBdh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 21:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiKBBdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 21:33:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D9F13D6C;
        Tue,  1 Nov 2022 18:33:35 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A1M4JC5022298;
        Wed, 2 Nov 2022 01:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2022-7-12;
 bh=csT7Gyu6cyWZ8xgW7sZETBrK6Wd1sH2w/7j6W/IKDvs=;
 b=z3s/VR++CcWk71OlD/jvIkpzqZWWJJEsXNdVs8p1oDi7DRYqRLHHNlWwO5H9yZ0iRWqL
 KX75EjP2JSsiDbYBLcpU/GrBdQna9sqBb3XrDelRr6k1RaWgo4lF6It3k94i3dm+RoSy
 EncD3LBrY+fJ411xyCsBuFptBt8/lkiGFc7+wHfE05a6yDM8Hi2YVkiEt4AMHgS8J3Rt
 GHSDedPG/wWms68TClMEr5B06r/+RtoaAXxBCr0vOjPfsmNpjcHaYhmlrOR2AmNIqEoU
 AcSbMe5k59fhQPz1LNkoqR5HPMIf33hxjlEgzYeGYHum1zYM0QGE5Kkfo36r8OtQiXdG 2g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kgts18c6u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Nov 2022 01:31:11 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A209gKk002861;
        Wed, 2 Nov 2022 01:31:10 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2048.outbound.protection.outlook.com [104.47.56.48])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kgtmb2n8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Nov 2022 01:31:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BM/SB8W6dibqhEWTxvRRRnpZRzbA+Lw2EqvWSA10QvWJ6xA7P00vkMdNS+YvRupZVD6y+1eatqVszwVv5/xXUKA342DAm8puJrkXfEJbYPg4etU75qeNg0fXnHo5xJm4C/RSRQ6IHYDGBhvLqVMISABYWPDrg4uBunIZfw2vUjfxeA8BTVHsvlN7UyLmzwrj/2oICYVFhQyYvNhlTx7OXsx9S66oEHqRxmklx1WRvRsWoW7dXvBIT43u/jOmivK3kFV1BHlRQlRVGTlISbMbxRJEKH16eKQ3yeG1Xq+CRXRiU50aa+wMqzIvJ8syd0ZNhsXQiFWVzxh2jTUDeM5PFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=csT7Gyu6cyWZ8xgW7sZETBrK6Wd1sH2w/7j6W/IKDvs=;
 b=FS2yp2wsc/z0+etSQf7GDPQ2JstQ+AR6BbWDxpdrWEnM4yBnzrUWOr45o4EJibRqvVrHqTdUrsXTNzMSrlppYhJ0HxrwGcmxkwFzOeBCmFmVzovduEmRPpg7lovBnCUQ9ni8MctTUX5SOK2F2lm3J/uGY0CEACek7a89ZT1ZQk8EHHx0q31YGwu/IhAYrd4JxJvbYxGgHxhQIuChpn4jRXPGAVti1zlYR/3A0XscZMu2oGkpdDu/8+X9tif2ddoiZhqLVFne+jYtsKeHuVF1bChXRP0WGtvEKgIUg/a/A4CLtm4zDxS4BdDUXWBp70WSXjgwMxQYlrAKbTTrsce/xg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=csT7Gyu6cyWZ8xgW7sZETBrK6Wd1sH2w/7j6W/IKDvs=;
 b=qyswAFkZelCd4zGNUoznuXng33x09ATbTzDWkAOigpXUBSwfXW4Y76bNAic/q8fRAtGkKK1oaf1K5fohveELiZMts/qPL2vc3d+8Gmdjt2Bid9q/flnzk4wq+246yV5k00kTPxZVm+pbfvN/n3eXZgssbdCj54TZtDhudG/gaWk=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by BY5PR10MB4211.namprd10.prod.outlook.com (2603:10b6:a03:20c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Wed, 2 Nov
 2022 01:31:07 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5791.020; Wed, 2 Nov 2022
 01:31:07 +0000
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
Subject: [PATCH v7] hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing
Date:   Tue,  1 Nov 2022 18:31:00 -0700
Message-Id: <20221102013100.455139-1-mike.kravetz@oracle.com>
X-Mailer: git-send-email 2.37.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0188.namprd03.prod.outlook.com
 (2603:10b6:303:b8::13) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|BY5PR10MB4211:EE_
X-MS-Office365-Filtering-Correlation-Id: f19babbc-100c-447d-d769-08dabc71ea61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ttg90YWn+HEa0fRMM5HI/GJzQQzcmCQ+09mH8Q46SNrCl1OoAzfSYw2KUSXf6VpQStBWsVO37LBVA4VxcMiH5/HbCDxuTsPcxdhq4h2wEA37C8+d9Ed4b/R3tEBfeWPTTkHkqG8ADzm1iQQPpCD1W+LI/Dc+mEp3d73OwIadBebhIRGHjaW/9lBpjAQGFBze42mq+txGMCSWeY3OqvzTH06u2R0HTBHr5RD2jEtyIi74mC59f7DCC+9b1ZPYPKf3ABQa2gPXIXNWBbIBjCNVWJujNZd5/L0tBhNko4d1BuVvpgBUOaozxRUTcXIpeposJnMags0VO3/DfIVDGFAls/uc6+3TPpXTtBNLuQmQa0E8XLhesB8krx5VPq/+O6T+NX9s6HuvOkL5zFywCPsxWfQ5K6W+mH5DwVaGh17xkpCeSB0/eGeQhlqFFVH5Z83iaRVF1mU9XSUT+/9U0UifdHOhXCAgohqRQDbsi31NXp/wyvI7ayDhh9+A/NT0rWutaz1eHNNL81stcX7jbsIUV8hEnwSNX+rQLX8Z2c0dO8+4UKeyHgEok0Rysywww623V4HtZApppmeGLtMzbmxArrmbEjhH3+Bi7GSQGLlCoYmoZ0G0blo3rCEcy9QflBRCGokzDnbMUW+WoCTrW404tZ/Pn+ZGJWeTpI+N9C2wTPQaGl7ylkk3oBAh3hKJ6BcFB5zL2Yoh2uHNbdI6w9oBNOZewIfb30m1tzXApCnRVGc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(39860400002)(136003)(376002)(346002)(396003)(451199015)(38100700002)(36756003)(86362001)(2906002)(966005)(6486002)(44832011)(6666004)(478600001)(6506007)(4326008)(316002)(66946007)(66556008)(66476007)(8676002)(54906003)(8936002)(5660300002)(7416002)(41300700001)(2616005)(186003)(1076003)(26005)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9PZnFG+wjC/g4QwVmkZ59SXKTWtYKg9+mtChkzESkiEskkGelpzN7fO55cAg?=
 =?us-ascii?Q?MikjL5RJqrJn0O1qSY2/VQ9TrTo4b1J3ZxNz4+kWPuyFGa5KVJsZvYVN7l7w?=
 =?us-ascii?Q?mpi69OgIq+bAgLBOpOigAejniyrs/eERHfIJsGrez8y9a5GnkyOSCcnvBjrE?=
 =?us-ascii?Q?bi14gyu8daZXsO6lXYefuNHNpEQ5TZ17QgVYvIRKmMyDOGXyBnR4xOM7nful?=
 =?us-ascii?Q?f0HAZB8n2zKoHcSUfPPJCz0gYCnjTZvCli2Fe+CXVXnZP9dAVUSm2K8zSO+l?=
 =?us-ascii?Q?Lj+1c+EGlGCUx1UqtrBCchKMKFMDY3MTLOb5rhPW7U+7J/Q+CcQ0JX4lJ/tO?=
 =?us-ascii?Q?Ge1b+u9POjXAijJGKmbLIOkwGzl1by0ijBem0S0JriaDEA6LCI8/E/j7J0Q3?=
 =?us-ascii?Q?gqf7sjoyitT0M1LeQw0nZfUoHqtqx3edPXVC/KfENuZTNoY9pmxLnplSgj+h?=
 =?us-ascii?Q?tSWQ75LgTaYxsNf5s4Y0PFdIgrVYFwHZSLlDQeCHie8SA/eNdDOjzYgIM177?=
 =?us-ascii?Q?RmQ0kWe64dw4H0GNWyTsuOvjUDufIpmssplsgscNHXlSvNUYhJduW0nCzwqf?=
 =?us-ascii?Q?7pc2SmxZmj284rzkJtM+vi2oVV8ECGO3QId0jyL3ED/3HNvbW2b3XdL0GEeQ?=
 =?us-ascii?Q?e5LD2ehG1ZDkvSlBUvEvVk1sciIFJ8h9c9LEyHvNdTEvHGITeMkURVUVXsKk?=
 =?us-ascii?Q?VXBwlgSbKC+h4+4Cutg9riwCCutgs3AmNb2SV8scmWf5HHQooZYRlHCgjqD4?=
 =?us-ascii?Q?jcCOLUqzgt7agcWjEgMowKmiDybXszreoRs2M+dMLGgX21hvs9AgpOYTZZyG?=
 =?us-ascii?Q?ecb6+bXgGuhLS4MsZva708Hy30sjXSydxUlSJ8+y60kvfKs1Z0xBAfCuBUPR?=
 =?us-ascii?Q?IoqzSGk9uui7UkR0qdHMoE1BpUyH2HkEyGN/+kRddZPeKJuUW6UrVdmTjba9?=
 =?us-ascii?Q?KzNM4I4nlLk0ebYW6vrlE0oc7intXl0QPpKLVeLsmSZ+OZQYpyWg5+5bRAsO?=
 =?us-ascii?Q?04AU9C1mbyF5j09wTLQAm40gRUoSuGASNhP07HIcOXfFrVPwukiampYktQKo?=
 =?us-ascii?Q?6FuiTFjxePolhJAsXWg0PF2tqcWHN04vs7Vy9OWTvkUgXrhawiOuYwsUjG0G?=
 =?us-ascii?Q?Jkh8HXBSok4cn3Rlw9wtC77lOMIn83zHKKsCxOx1Au4VAiyDOAUkWG6N7ban?=
 =?us-ascii?Q?qbq9S12Dha252Fb15fDG5noPZIsGHZcPq53nxpQ9W1riSrP2wkVzjdCZnfMa?=
 =?us-ascii?Q?MdLpCnSTcDbO/DZ7qOmatkGWUPXc8tBucgbTJVigJd49wBTf3aMJQKlJQXlo?=
 =?us-ascii?Q?rELa5sMmSZUluxE4l1bV8PAZvpwF3SJTcwNczZ0mt1dUViaGyI7lEpde3qrm?=
 =?us-ascii?Q?HkWqk6WuazyvujVyeNrRWJp1ioeb3CK1Nv1zzeP+XsqEpDDh649k1hNVWyag?=
 =?us-ascii?Q?M/3X/ZFpcbbi5ML0ZPm4MvzE9D0YXiHUYdQMDG/WXhjQV5U3FUOceCGJBTGu?=
 =?us-ascii?Q?4/ImXVHk26qEb0e0IQ6E4q1gSshpo5tBcEtklwXnJ5RpVrVzvJD/IILBkLl9?=
 =?us-ascii?Q?nMo0UPMOxLM2iQd7ci+ZpOnWY7Dy5oH4K100qsfBrLfb8Iz4r+uu9EH0HVCl?=
 =?us-ascii?Q?GQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19babbc-100c-447d-d769-08dabc71ea61
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2022 01:31:07.8140
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2BSPE79rIQwrNS39mdYjuyzhMkK4TA6YE1XP8FC/ilGOshGSWCa7PQoSOdsgmK33hLLKB+5qq6UzTptBM1pVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4211
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-01_12,2022-11-01_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 mlxscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 phishscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211020006
X-Proofpoint-GUID: 1q_AGfEZ-vYB730K1GILPmsTgmRQvR1x
X-Proofpoint-ORIG-GUID: 1q_AGfEZ-vYB730K1GILPmsTgmRQvR1x
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
- notification calls are updated in zap_page range to take into account
  the possibility of multiple vmas.

[1] https://lore.kernel.org/lkml/CAO4mrfdLMXsao9RF4fUE8-Wfde8xmjsKrTNMNC9wjUb6JudD0g@mail.gmail.com/
Fixes: 90e7e7f5ef3f ("mm: enable MADV_DONTNEED for hugetlb mappings")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reported-by: Wei Chen <harperchen1110@gmail.com>
Cc: <stable@vger.kernel.org>
---
 include/linux/mm.h |  3 +++
 mm/hugetlb.c       | 45 +++++++++++++++++++++++++++------------------
 mm/memory.c        | 21 +++++++++++++++------
 3 files changed, 45 insertions(+), 24 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8bbcccbc5565..b19d65c36d14 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3475,4 +3475,7 @@ madvise_set_anon_name(struct mm_struct *mm, unsigned long start,
  */
 #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
 
+/* Set in unmap_vmas() to indicate an unmap call.  Only used by hugetlb */
+#define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
+
 #endif /* _LINUX_MM_H */
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 546df97c31e4..4699889f11e9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5064,7 +5064,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 	struct page *page;
 	struct hstate *h = hstate_vma(vma);
 	unsigned long sz = huge_page_size(h);
-	struct mmu_notifier_range range;
 	unsigned long last_addr_mask;
 	bool force_flush = false;
 
@@ -5079,13 +5078,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
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
@@ -5174,7 +5166,6 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
 		if (ref_page)
 			break;
 	}
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_end_vma(tlb, vma);
 
 	/*
@@ -5199,32 +5190,50 @@ void __unmap_hugepage_range_final(struct mmu_gather *tlb,
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
+	 * When called via zap_page_range (MADV_DONTNEED), this is not the
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
 
diff --git a/mm/memory.c b/mm/memory.c
index f88c351aecd4..474c43156ecf 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1720,7 +1720,7 @@ void unmap_vmas(struct mmu_gather *tlb, struct maple_tree *mt,
 {
 	struct mmu_notifier_range range;
 	struct zap_details details = {
-		.zap_flags = ZAP_FLAG_DROP_MARKER,
+		.zap_flags = ZAP_FLAG_DROP_MARKER | ZAP_FLAG_UNMAP,
 		/* Careful - we need to zap private pages too! */
 		.even_cows = true,
 	};
@@ -1753,15 +1753,24 @@ void zap_page_range(struct vm_area_struct *vma, unsigned long start,
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
+					vma->vm_mm,
+					max(start, vma->vm_start),
+					min(end, vma->vm_end));
+		if (is_vm_hugetlb_page(vma))
+			adjust_range_if_pmd_sharing_possible(vma,
+						&range.start, &range.end);
+		mmu_notifier_invalidate_range_start(&range);
+		/*
+		 * unmap 'start-end' not 'range.start-range.end' as range
+		 * could have been expanded for pmd sharing.
+		 */
+		unmap_single_vma(&tlb, vma, start, end, NULL);
+		mmu_notifier_invalidate_range_end(&range);
 	} while ((vma = mas_find(&mas, end - 1)) != NULL);
-	mmu_notifier_invalidate_range_end(&range);
 	tlb_finish_mmu(&tlb);
 }
 
-- 
2.37.3

