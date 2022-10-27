Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 095F2610035
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiJ0S3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236130AbiJ0S3c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:29:32 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B895E5586
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:29:30 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHn0Jv019874;
        Thu, 27 Oct 2022 18:27:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=uCGNdLjm/zhf0NLs828ByF8uHl+HTT5XB6MBhQmDkFo=;
 b=hqfyWcVPJASGA5C8mVk7LApsYR2bQ1dysW77jzBGmt/ZrScyzwqfuGJdgySBVL7conO2
 6XprrSWPPQQAMMxF/99bl9pNTNb1XEAKhsJ+tatOWp+RAh/c7VHlbaD3SASu9s3Aalkj
 OvSMU1POrwQH8vj1XhHWz5UNZNhvjbitCiGYxeQsxSeYnnmTXkIqUIeN0a63lr33QCfe
 PhsxSzJmgINaojcklWlpodpQsxfuD12KkuqQuJ4CUulriURCU1e9O5g0NOCOH7cinHcd
 ovgaWSb7k3rvBu4/S2zKlZEoB4MiwD3QE5cH7yNBENywFzsE6ziewzXjqk7uo+y6ABxH IQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7tu9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:27:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGAXh5032662;
        Thu, 27 Oct 2022 18:27:20 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2044.outbound.protection.outlook.com [104.47.73.44])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagn9hmh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:27:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dnNyZ7KGquZPVt+cc9yJcAJoKiZ2ks/SFpkETjBt5+flob2CSoXSa3hn8VT8/N+ndW1gIaiH4Wb66gOvCz2Zp4C89AGI6lNPFVFmrVK+0aOruJFL4b7VNd69+eAcC9DoUB3ayjBF//ZiS8sK90EzeZ7jzQFQ+eRPVFQMAh5MFhGs51OlaHtgbUqRAI7NkFReiJR7IU+94OclG6pklUN+ROMSAo0izKqVJXzHHvW9n4amaiGjpV0IeYuegiVBYrZLTTy6f++e++tyv/YCR9YmqLhOrkuXZuFVv8/9Mns2PWY+fJgIACbx260S7vwS28o1ikZ5UH68xVYeF9lcd0Ymhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uCGNdLjm/zhf0NLs828ByF8uHl+HTT5XB6MBhQmDkFo=;
 b=FNollF/jbvKkqnh9V4drq163GXWAI1S7EGlkG7DKnXwfYsagkFCCaCrkCNvm9xIGHkAm4ONe6rms7YFekkKLRxGrZoSkzI/2biuVPrPWhkTOQIGMSXr+EIBPv1saVJKKLcZtPyIWMqX9n3y2j6b8xQBPFUpbEL/y3er1Zv47Rh6bVKzHyf3M6tudkLt9DOtx80I9xPDI8+vfSEDdRD6GVcV2YMeroesHAtHvXafnAILX+A+L2PRAt5raYdwp+9qDtgqHInlpaC8vVMYYAvieqjqRAuiIMu5n6Xw3m2jbojFpfI1X0Aenq5BIvkli/+8Jjx191w38qPCz7DFokhMTYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uCGNdLjm/zhf0NLs828ByF8uHl+HTT5XB6MBhQmDkFo=;
 b=c6/vGDnzp5gUAbO+ZNcGLKeQgSzV+yhLbYlhDitA33b+ZGGu3oDp311yoMfiaPThuRtSQzqQg2iibQHVeMEW3JOYN1Or4CtrO0pIcz6llGOaTVRuLlKMSuLi0CjEBWI560YqSNPGbu9cRD7xUKRfOdXzaKBm2cZceKLoTOCc8HE=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO1PR10MB4785.namprd10.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Thu, 27 Oct
 2022 18:27:19 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:27:19 +0000
Date:   Thu, 27 Oct 2022 11:27:13 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 5.4-stable tree
Message-ID: <Y1rNgSoljcEguqwy@monkey>
References: <1666796843223135@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666796843223135@kroah.com>
X-ClientProxiedBy: MW4PR04CA0108.namprd04.prod.outlook.com
 (2603:10b6:303:83::23) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CO1PR10MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: f799307b-bf0c-4ca8-64dd-08dab848e180
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2EZCbxz0cxmgxzCCt1I4klYn48uz4nPKm6uO+5TC8Hade6krLB1WoxszsWGw1YDJJiIYeD0TO44fDudU2hyTkCuLUBYRvc1Wh8QH1eHO9I5E+cjIsAngHDqHYWa6WfBYTyBHedc+eXJXVnkKT56mZe0MoNhQmYH1Fqw7Nk8wmNNMz+99xrz9ruvyJ6BJU3LTK+njnAflx2ZS4KTUibGeKME7C0wg37fs6jnhNOsOtIk6vl4jFqrpZNnE+0iEbsyfU69yP0diYElaMR4h37O7F0NVk8EqT511i97Bq775iVEp1ZYucXOibTJ3SWWbJKL6EiO/wt0C9Ek/WHBupB8ZsG3RWEIYLeOANEFMFE6BoSPzJa50+P4p+Ramvb0JshPMqzDovazpWly9GniTudTSL1NjeKb3+nd0sYmkJvrCA8Rmuyz++Ly4TjOx+P5dGWFPVV6JpRkE+Kyn2Dfe29ZmeywsrtflMAHmU2BFTw3qVAiDeq3KzKZ6gIG2yrdpmXu74PDspiKaACtTDnlActTRFg3nGd6NumpiRaL2XseOa8g5k8skatPVa3NI61P0b5ZgApkYQxt0Y59bA/GL+eZUXoltELZJCWWx0QtLuSYMOLFQCD91Ktmw1+0EUYqimO3IVIkTigFv9hEzH6TnJC+bmX4eS7YQ2T3wW0rRQk6uUU3g1PVwQIOZhEG6Kd9sicfo5VRwhxPg/M3bkATHfT2xBoRqqH6qzRNXuXCH2PkWyRg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(2906002)(66476007)(4326008)(8676002)(66556008)(6916009)(86362001)(316002)(186003)(6512007)(66946007)(44832011)(41300700001)(26005)(53546011)(9686003)(6666004)(5660300002)(38100700002)(33716001)(966005)(478600001)(83380400001)(6486002)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YLoqYyRuYhsIx9EH2tbNtwvQ9qQ1yYh65cdqew/5rU5pdTNK0C6mKzjc34kh?=
 =?us-ascii?Q?VRX2c7Qmy1WxCypGV2l+qTqOn3c/rkJd3IFyYqYHWXs19quPMJQoFwuiJzSE?=
 =?us-ascii?Q?bHcEoUklpOFRQHAY8uHBd4C5eL9bYmjDlsQQB/2foED6Zg0CxysUfQfeOL/m?=
 =?us-ascii?Q?Mru8Yg1SpV5kQUvnE6hUtrg3mjsoSyxLepCffOMOiix98bZ/k9+qw4Orqo6y?=
 =?us-ascii?Q?ipVVGUuBfXYE9F5dB7sklkXHN43dXm+u1AcIO0888IRQWe+7Xtlou7hDK2Vw?=
 =?us-ascii?Q?wR1xWUoCg9XSPRdfXey/YZVwgf54F2CHzV9pqWPyUT/oKifuQKEwcBcNyxhe?=
 =?us-ascii?Q?paB6jdZhhAIGNos9obQrtWarwDtFWsucFLMOkRHlW+j8BZRL9idYg1lVJ7Wj?=
 =?us-ascii?Q?x2xo75Sh3BJK54nZYPOcJACg7hTB7TvIsjhWHKSRQy6h3CsSopCgT5bNijw2?=
 =?us-ascii?Q?ICnug9lgzy5yr1hnHYIoKs2dBxvpoWx4W/JmZk0z3ACYlb1qKL7xWX4LPvjL?=
 =?us-ascii?Q?RfLUOBquJs6yP8LjsUHuCwpcevZhb/OiRh3qFaCUzhbLreux7Nm/JuqworM2?=
 =?us-ascii?Q?7qDIX7iI219fvLscxRAk3tSdVR6Bb++bO4SvN+hDyIzFO1njnq++Ne7rCsIC?=
 =?us-ascii?Q?O8uSfMFPJbIpXStqVMvDeVeFvWty/6PwTNnbFfu0q34sSmLqb+fpGgblLlXc?=
 =?us-ascii?Q?l4/0ETp6ehHVCM2Q5UDB5innEgQlEVyg1WCBJO0nhw5O25l/kixJogrhmmxz?=
 =?us-ascii?Q?LGWInq6bP7TGMpd4ZVoACBKQ/4TA71HjlbcI1CXAq/H8cmxArjot6oqg/egX?=
 =?us-ascii?Q?A9mhq66g7JWXr+AI/7CpvsXA9B5slZt1Bpagia/YTUO7jhR3U6J5lo5RORW1?=
 =?us-ascii?Q?zbDd7qwPyPhwILB7p1KVMUTjSIeUVP3uOD7Pu4ce+5QM2PSaflJPvdENceth?=
 =?us-ascii?Q?usIfsB5WTA1CO9EFXlO/VNNx+TPViwEduEK5vX4HWUf8rhG21yAbEPEoFOTL?=
 =?us-ascii?Q?zmL88PXfokRoT5mMgV5995uDSHLwLcpQQaLPErV2AFWdbBQUgHE/dHYtbYRw?=
 =?us-ascii?Q?ZgkKYs/HcXXkdUvOV5TPwQKFz+myrLFEUt3Nh8nPB/gpBqnxmyvQBcxALnWx?=
 =?us-ascii?Q?mgdRAITa2/PRRYU6T4BZD4oterrj0ZnfKMTS8UcXrRFPI+5O9P6U6QU2iCEX?=
 =?us-ascii?Q?0cML0NMu4+dyqpiQaLCeJS/yXdHrYxIvYI3k9dIVy97mk5frEiVIhLZ6jbMO?=
 =?us-ascii?Q?FrhZmvp39gUWyWpZASJwAnlH1wHOxIXCoSGXwHuALYNmzZaWLM6DURgulmdg?=
 =?us-ascii?Q?f9ysRHcLWl2Sspvwicy2Zkp7dZICgGOzh7w0+dbop/47b85isS0yF9Mw+rk1?=
 =?us-ascii?Q?O3j2ityUut/rsRa5/G46i7vtnGt+rWp0Z6SgPZYYNzSSTBLTIdsfJNOG0y3l?=
 =?us-ascii?Q?6RDTIbAoj78qahPyKLomM66SaWIadd3daqqQeKPCqIt51avork+b3lXAAHXl?=
 =?us-ascii?Q?IrXFX28rFL6nW3ziX0O2klnRUu9xadWTHr8HdERAsYUX2j6lVKMLS6PNjkXK?=
 =?us-ascii?Q?F0lKx9g1tzX0HhVNNpYuyAWZqcPi/CdyPkwxBJSIpxHPpDFAz7Iy75/VKxO4?=
 =?us-ascii?Q?aQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f799307b-bf0c-4ca8-64dd-08dab848e180
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:27:18.9133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y6838ahM7FCByHtRyoD2tb+ouE0GZyt2z4KR27MLbM+zckUGXQ4ls5xKoTz6Z2KGT+TmzdOwYKUeLAhlBGrMHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 malwarescore=0 suspectscore=0 phishscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270103
X-Proofpoint-GUID: PzR1gnTKtOzJm_5E5SuQD_jngYdsmsDe
X-Proofpoint-ORIG-GUID: PzR1gnTKtOzJm_5E5SuQD_jngYdsmsDe
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/26/22 17:07, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From cd6ddb4b5dd029d41b380df32f81043631a26dc0 Mon Sep 17 00:00:00 2001
From: Rik van Riel <riel@surriel.com>
Date: Wed, 26 Oct 2022 13:28:04 -0700
Subject: [PATCH] mm,hugetlb: take hugetlb_lock before decrementing
 h->resv_huge_pages

commit 12df140f0bdfae5dcfc81800970dd7f6f632e00c upstream.

The h->*_huge_pages counters are protected by the hugetlb_lock, but
alloc_huge_page has a corner case where it can decrement the counter
outside of the lock.

This could lead to a corrupted value of h->resv_huge_pages, which we have
observed on our systems.

Take the hugetlb_lock before decrementing h->resv_huge_pages to avoid a
potential race.

Link: https://lkml.kernel.org/r/20221017202505.0e6a4fcd@imladris.surriel.com
Fixes: a88c76954804 ("mm: hugetlb: fix hugepage memory leak caused by wrong reserve count")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Glen McCready <gkmccready@meta.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b6f029a1059f..2126d78f053d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2218,11 +2218,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetPagePrivate(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
 		list_move(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
-- 
2.37.3

