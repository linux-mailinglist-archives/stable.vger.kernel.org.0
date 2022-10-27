Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D96610033
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiJ0S2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236372AbiJ0S2Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:28:25 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36FC79A47
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:28:24 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHnSAx006974;
        Thu, 27 Oct 2022 18:26:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=ElC6mlwkbYvjiuygLfj9uS5r08OESs7RAYIiPEJEDcY=;
 b=w/wVzNdvtqq1MT6nLmxbHMM0GbjMHWq/2W+nV8qIpPQI44F3MXsqzuISeCpmSnFo0zrT
 KDnnmNxEoxiAy5CYy6cJjm5vvSYBqSFRJy8V6kKfiTWBuXWEefy23JKWBrY4RrS4NEnU
 kDAi+Td21/XJZdWgyqyhuT9hlxC/nVAvPpv7HjxPWp3X3h+ghbT8V9xckU9eLr7vwrpZ
 op2YpL7Ka4+3JtnFlD6z9CqdGSwrMrAMiKFeB2TOG8eW7U6kN+RimRWd2w0lPy9duMjD
 7/lMFJoGId5wjUbexiKoPM4fshah+SzcAJOiH1nDYlkCfwnpMsOLtqivFGYn3eric75a Zw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0ajyah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:26:16 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHxeca026555;
        Thu, 27 Oct 2022 18:26:15 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagq9h7u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:26:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXVnx5ycJXhFKLDqqX2dYLdRB+JaYInYMwZGnWTpRW7P/l6DFMyvfSsa9ebt6Z1LvDUyBjchodlu+Qn3bqI/z7GTuDRF7Gic3hj7w8Cz/3jFIZln+RORka7tfDE0F16EK0U6v6QSvFvkg2sKtF3wWAMMEH1+hJL2xSv7OVcIDqpom2G3b3LH1jGWurgkheq9NuoALBD474dzi37YvgVkyQDI5f06P9EvWqlIHW91FHW+eSoKeDxN6tQV2PJmh3TX3xt+nxMSyuHidUuQYP/1e01zhiB9NfwM0gVdd0N9nTBmLstDse7OeXSVRjLDKlLror8O2ICHEzjjOMxIh43W5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ElC6mlwkbYvjiuygLfj9uS5r08OESs7RAYIiPEJEDcY=;
 b=Y4B6JKmMhDfXTNDRQ30+ma23tibgaLl8ZTb7tEyPPpfd2E+IXLv01m/nj8sTmKM2fammdJDRilNYjArZ91s6w8IS3NoG0OEiF1Ymhahbu+VYsWCQgvqMS+Wb5Jfv+MJErPjsm7UMnnaOu/68EDnFcsLWnu8uBNg2RO63CBOVZhJGwcNbcUWT0k/Ll585xcB7cx+UPY9Mk1snMFmdUwTmeXLZo5kD9Ws8jPPIulAQmGH9Nae5DaOFvFec0Z+51M8Exc52ILL7y+/MvSs/+WwfxqWBgXqb+zHHJ02DkPvyR0osi+J7lVl+zxD1MOvjwr9slZVZJwMF29fwvbscslaXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ElC6mlwkbYvjiuygLfj9uS5r08OESs7RAYIiPEJEDcY=;
 b=DOXkGGJwMaOaiGofsBE7/SuoxnB1UKcMjxQO0AdWNY0xXE1FDuI4Hvi8jJ8HdNR3cIUGgMplGlq3+43/tXjtp2IGdOHKrHZAzGZ5YyalV6MeHP8wG9tdMktXhDZ2jO1XTsKLGj4VQ371bR+kOHqiKFdjoklg/IUIQrghuAVOQog=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CO1PR10MB4785.namprd10.prod.outlook.com (2603:10b6:303:95::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Thu, 27 Oct
 2022 18:26:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:26:13 +0000
Date:   Thu, 27 Oct 2022 11:26:07 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 4.19-stable tree
Message-ID: <Y1rNP8DqjhMyb7hN@monkey>
References: <16667968441813@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16667968441813@kroah.com>
X-ClientProxiedBy: MW4PR03CA0034.namprd03.prod.outlook.com
 (2603:10b6:303:8e::9) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CO1PR10MB4785:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b153fd5-6ef3-4d1b-947b-08dab848ba3f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjkyZ/D0h5UEaI0O+g3pj94KUVmC5GhU4x5hFFBPQ+j31qJzq66KuRof6TCagIpANY4c5uNHh/UqcjA3IpZYXrvJLPQjYfD07gBceUojzMfk6UWVPegI04XKmPCT3tgix/bugH/Jo68G7qSW035J79EGmgFWG5BrzUro3h0CRoQ3a28GZUQeTH7DUbEzbO/Cv5iM7WQH9eVIMv1hcUtJjsy3NcrMPcG1LafLOZfahQmVH6neQ8YI1BlmVpmRVQfRUGBt58s7bizQirJkWa8qLOmGgDzRMbs+WkKBCffMZjZUeDKrNkc1xHLnOZVLBxC2KsQiWIoj7JxEKUGo1E+USR0yVLsSQ6n11vvBBRWPDnZCQKwsvpC+Dof87DyqnXEKZK1HzSzXSMOTZ95ASLHLpyxSEE06b2Iy/wArwV8ynm89/NSI9wHctnB/B2w0zzfyhXjOYuygDU4Y1J5mSU1q9+IdlG8vXle57W+deOkDbSTkRoIdR22PU/ckcLIoyLc/dOwAToWlCui4GxF7OXIx7YJUQXIhQ6mUZJCd7cbYvbcA+sVwcgK3o8TUOZPfKjkxXZtsOANFGJZeL9RFKhjy6CkL4Ul0QlP5dGCaurf0qcjHeDS+PxDDEP7MPSMloWlsT7lbjvUGMHppMpVQA6Nmw6d7NyA1VkPzg803xXHCqaDSHAr944pz+dXhMTNUPk2KMqwcb5PrAYNf/btGFlFZsX7S1zbzXx4hDRFd8ZkTK/c=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(39860400002)(346002)(136003)(376002)(366004)(396003)(451199015)(2906002)(66476007)(4326008)(8676002)(66556008)(6916009)(86362001)(316002)(186003)(6512007)(66946007)(44832011)(41300700001)(26005)(53546011)(9686003)(6666004)(5660300002)(38100700002)(33716001)(966005)(478600001)(83380400001)(6486002)(8936002)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vNuPte2534G+thBH39V0sdac1AZDjnxgmqcrGpN7E7pl68Z2ELdq/wKuOEfb?=
 =?us-ascii?Q?le2cWakUzlPgNcgtzLOVElmCLtuaZwNBI5QiyH/ysqR0H3sc2C9xG2JmdEHA?=
 =?us-ascii?Q?06lNMqgLlflSG2a8EvL3oU6lhZHOEE2+mljDM70OBPSNoAfehJ0y/wQtmj7j?=
 =?us-ascii?Q?8xrTTPZxCvHyVoiSPtn4B5KXWn9irTiMNUBs1nWp7RevYJmizvJNGIC4YaQm?=
 =?us-ascii?Q?WBDA+Mo1oAx3McsTqWLH6kklsMKPbRmsLcq3cwbnpi6oqYYB5AXlOm7trD0h?=
 =?us-ascii?Q?rnewOj+17r0BzM1iIBPYNEWRqzL3rxJN4GSIY69vB2dbXhj7ma50yZ886iZ+?=
 =?us-ascii?Q?kBAJ0QyrUgnDXU/3XVuuwBOMq6wtbdWFR6kBvhJGoJaDmqHwJ6MzMM6iBsa8?=
 =?us-ascii?Q?5dDH5ipE0moA21JAY2bGQnHc088Lg+mg4N0qBjfpbSrc0Bk1q+f2nH3RKjxg?=
 =?us-ascii?Q?y3uO699uSn6YxTgNGsXY/aMTxcvCYDnXY9Rbv41o61sdc8H2ntk64jTqnenG?=
 =?us-ascii?Q?zRc3tSbCEKq306iz6K6KoH4KCYUedRoJJRMyxLdpIPb7bxoKJxctd1u2r1rt?=
 =?us-ascii?Q?bEnCkj+lxGddBLirnFMlvunnpCGpnwLKFPjKB4hAUaLbiSYNp+Keup4drgNn?=
 =?us-ascii?Q?xSWTtk5MQe6u/HGFpHC0wupbXgleItaxeJvwi6LDmu0t8/w1AikjRRbLg6EE?=
 =?us-ascii?Q?HJFd5A1NBk/lKaQLpFxYxEl88nPHWrxJ7EvQ4vO0LLiS011Ut9M9gW2l7qVi?=
 =?us-ascii?Q?xOvxYQvygU5lQvMrDWeCAhhO00Q/SpK2aV5ey6tqpTI8W7f+kgm/2gIG73bp?=
 =?us-ascii?Q?JxtDJNHHK2I9+b3oJJGmkS7tLToRzlRN3MM9ZjC/SHYq1hxBk8/Wjc6PnWmp?=
 =?us-ascii?Q?6Lz2oAiQgNBxJvKzz2gx4venOoKV/SuuEthzKgdDceEHT0tOJo9vdR9ROY4u?=
 =?us-ascii?Q?JoR8WBZB1c9o49AdSXAOrXdPN0jiQMhh86TUFp/LkeRIePYXNj3VQXbrrzx2?=
 =?us-ascii?Q?dB8fNtQ010fBZLS7hint5pZjoYWkPLVWtXNt/G2GYFnJQFgqHulNik7OtOCw?=
 =?us-ascii?Q?XncK9sDpZi233BsHQgaGU68Ss5JEbSFqCpHqKfP4YgERfzPkHGTlEWV5yXoE?=
 =?us-ascii?Q?k2R7TWfVJajsseFw9vAyfuBy0zc63W9WqJ0SHyz1dVgOLPbgEVyPXjCWRmQo?=
 =?us-ascii?Q?hof3jnGQZHrMlXgEmVl1arIE/IBsQzqtmt4AHauy5f/6I4bem7fbOwrXoBDz?=
 =?us-ascii?Q?Fm0wEC5/DBHWSGoHvZOUeBklnwIY8ZiWbaLSoirk1XPbkh+Toj7BPIUiYvdb?=
 =?us-ascii?Q?qIl0/bBHdJLp4RUao+dmXLLf/VQ9NNs06B8U4TSqkVOLaW3HKIghAlBkSYil?=
 =?us-ascii?Q?wzL3F+mHODeC6jkJc/rAa7bG4cLVTBTVDtWOa3MBAdY01t40nHOCTODt8ZGH?=
 =?us-ascii?Q?Uezdx0uMOkuVe6663TIGa173y3LM6HAHrKu2Vou9mz6/Jh0MB1Yq2UKMyoYR?=
 =?us-ascii?Q?RDfb+UVQ/oMxHB9OHggTStAmjt3N++aFAwTDtOoChrDgSAD5nSjPBvuDgLAT?=
 =?us-ascii?Q?FkBK+GzkxiX444MGmXLWW+vU0+RflScfmu9kJlTqEZhhtqfltSowwo3kX1CK?=
 =?us-ascii?Q?+g=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b153fd5-6ef3-4d1b-947b-08dab848ba3f
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:26:13.1980
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: P5JjbKbizl+Y1gB4ABTiYpzHXn6JJHrX9jBxuJL6tFk0cScAf3lJz7btgPhwbvgPNb1T06qkG78IF3TECzrmtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4785
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210270103
X-Proofpoint-GUID: KpSn-WfKob4NHky52d94uvEI0qEV-Yw9
X-Proofpoint-ORIG-GUID: KpSn-WfKob4NHky52d94uvEI0qEV-Yw9
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
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From 4d87d52972b2201f95fe1fd2568fe5a9eb909c7f Mon Sep 17 00:00:00 2001
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
index 45e874fafdd7..47e98a5726c4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2116,11 +2116,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
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

