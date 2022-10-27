Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C4B761002C
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiJ0S1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:27:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235679AbiJ0S1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:27:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E948C61701
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:27:19 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHmpsC001412;
        Thu, 27 Oct 2022 18:25:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=gnoCVEp+w6DqCLBGrGNpxdV0Wv+9GNFoxkTODIq8r0s=;
 b=MY6/iEI4ayHxPNOG6ABjMs8aWODiio8aRX/R+t43JJKihMztB7gwZgbk4AvBct6cC3/B
 aUD5nDhCMn8i+tITpq8kVMsUEDh9WSrbAZWH2TIcSZpUHrKUkLuvyQT0A1yiwjM92sZk
 YYL/kRUGducZEBxt/Ml3ynZAu3zMWAkjV/0p1kKX2uSpCt+8Kj27VVzwsVXdJKptkyfT
 I2e63Zg17ZCW1en/R12xGlj+Bzqx6mYRZw1o2eGu/QBGS/M6dW3k+tmCOjzzhKT4QVm6
 QDciGs6bkhqz3XAG8SzukNSYUVvNslua77AYEpDYqZOhCu5gNm9xjD3e6CCYeakN75X8 Gg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfawru00c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:25:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RGMCAD006493;
        Thu, 27 Oct 2022 18:25:11 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagh8k8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:25:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KIPSLPjQacp1K9bNDG5SaQj5KTUkSvtE0+Z3clkM9kgRMClTW2I02ZEw0O2qFdosNC90k7KSok21sA8tXHlwqdqDDwKjigkJxQGjQl9nccl0xkUE9sjYwJLWFmuTToYVYMcp9Sg5fP5Bfvvc1Ka/6kff0g8xHmac95qT57DTuHXyQR3+Pa4DhzHqdX7QQNNxxgZ51ornAzsDMAD5PJAwpuZD3Nw0qEfAgWKu0awogcMD7FVQEm2+2MtBWmtwAtWc1dSosREIobEEfQn6BifyOhs1K2bSOc7Rypfci+kdbb/dGFZ8y2bA4H/57gAyHHgqJkdUr5UHs5BeaLjAug7szQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnoCVEp+w6DqCLBGrGNpxdV0Wv+9GNFoxkTODIq8r0s=;
 b=DyZiBzgpOBX7cGkJKpwjFVphHraMnT6zhdHXjXz2bCNrGblHWjQNAj1uo1aIxFtEUoTEfuFhlLwYSytY8izmAcWzbYsHP1uPqWuzqOg47acC3UammEiVgWuT5gizC4wRPx3j7BCOLYIT4Qo+uYCAaEEUyYKNaoMFxryTQ1qE3U9HRkJT5Bpan1CK3nySKEjKqMpgjX8co2mi3Yj++SvF1zBJcbkAX1x8eFKvuscTG4zdGVtfYqvTIjIsDvcydY3pLf7l1nABTGfljPq8LXoPT52lFVgZtzAyllQuJ9i6Y1oC8dpSrhlJSc5DyaI7K1cr0+UYicpA9U6Dq9MUupYZcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gnoCVEp+w6DqCLBGrGNpxdV0Wv+9GNFoxkTODIq8r0s=;
 b=OCQea0j9bpYw9rJNxVEpE38VBMXRE/7vSKpQXVa6CNyGBt96EDKX4ls9NbvYR/g5hbhfrHMmFKrXswVTmOHb6B0p38ihm+cVCl+CTWNRQMGKl0iORai4Mv4XR/18JlBxFkm6NCFane8KKlAzv7Y52iFEDs2vIPIP+WjPhxpXlbo=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by CY5PR10MB5937.namprd10.prod.outlook.com (2603:10b6:930:2e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Thu, 27 Oct
 2022 18:25:09 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:25:08 +0000
Date:   Thu, 27 Oct 2022 11:25:03 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 4.9-stable tree
Message-ID: <Y1rM/w5zV8im4Z8o@monkey>
References: <1666796846105131@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666796846105131@kroah.com>
X-ClientProxiedBy: MW4P221CA0025.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::30) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|CY5PR10MB5937:EE_
X-MS-Office365-Filtering-Correlation-Id: d86da1f1-2eb5-4af1-035f-08dab84893fc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tb4d0q005vNqHUEGBV0r+QCpqfUudm8JPc7ZanveTZXWY/P4x+TJ12tx1oZZKAEVQSxsHFAg1kP+R3X5zGa8WuJ1kvSzKI24uHbt+zgzFgfw78KvgB09hFEQgXieZcjyN6QOYRRzgpi+fPBRERqWKyTUvr3cnu8dPxB0iYtIQzYfOrYF6b2/xw8SkuyHQmGbzpZFDK7G1BeGY2nqhD+dbauhNACs36NG4MSq6Z0hdOzUrgQg1reULSYxeDwVxy4XbQDPPTW6N6OHFgbcQxkhigzi198S5sO0ikfeBFJtE9NS28j3FYO6sieAC9+69V1EJqi65M91ZGb9EY5NLhm1apISiU6bFaZoITIFno0SgF3eMq1/R1uETf/btJDsfVDsw+grgDzKRUuz9JWLjpyachE9yk/zTrSitxDTJTXt134MKwHQsk85tXP0JV9g6nMiBvaFXrShLJKB/Bc7YC8ruOlqEhBgNB/W6/3KVNeoCCMYSY1Tt/QQ9mXhCs6yaonpMbrCG2H3sw1bD/GacoEnSj2mG/cf6xFMlS9Ao2gyPRDedoibn6Lh8qKkVOZhW5D2DZX6vp9XyIVuQ17WCnt2LKHKwXvnm2j4gk8wUindgYHvvYVBGU8/Hi6Otg3FtTYgPR38D7ufzqDefTw9qCqMa3YlZwTO5QH0JyzDx+IV3dkiJxBV51TMk9lv8Z7jIWUoBVuoBwDl1aXzZgPXroLkRHXSKVOWYt7lbsIzp0KYPN3cgwnBpJIaBfiIvZQFpL/0
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(346002)(366004)(396003)(376002)(136003)(39860400002)(451199015)(44832011)(86362001)(6666004)(6916009)(33716001)(66946007)(4326008)(66556008)(5660300002)(66476007)(53546011)(6506007)(8676002)(186003)(316002)(38100700002)(478600001)(83380400001)(2906002)(6486002)(966005)(8936002)(6512007)(9686003)(26005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8l2X6KeroWQwr4clDmUhUp2Wrew7T6jMFu6Hlk8frwhYNwS6xZ7G++LtnNBc?=
 =?us-ascii?Q?fWCeDHy8MVLvrTVf4/OKvgJRQbg8x+O4M9Fdh6SMVI571Oxxr5b09XCEdzB6?=
 =?us-ascii?Q?iIgjd0qPVI4LQbPLhdTmgKwC6b/heN5vafqMkefpkRrvjVHVH/6atDm9CwFV?=
 =?us-ascii?Q?GJJPocd/psywLqS2evJwEVXqGDFt5AYQ/P3gHIs76rm4PzDI8vzJEGfKwe9p?=
 =?us-ascii?Q?LCmM02ldsBCzv2jDxrWoKVO8cLTCxTqrh3gFzcErpNUjhGpM4d+ltgTAkmrg?=
 =?us-ascii?Q?I0SBT6Kot8k+Hgp6Wqu07nnSXY1ySYn0iOaxELy94bw0bWlh7J6b6AoC7+vY?=
 =?us-ascii?Q?Xz4CcccV22eTnzszrEC94KthznG7WZeTa60/82x+nmu7v5tCNRkXlc8cmHjo?=
 =?us-ascii?Q?lYuFGOkef3nwQDK+BZivrLq8dBz8aUstL6qDXXMV50UngtgynoazD03Y783o?=
 =?us-ascii?Q?hWr6PYgWUAps4GfvxgDN55ZKmJZeIfArjgLTEwSVrKUDXyWhlrkGBwKg0FNN?=
 =?us-ascii?Q?zGnuxtzixWCWYLxIxuTrrRdboP7gym5nvWdlSZqRuJNeiz5GMh9lw4jbdWV0?=
 =?us-ascii?Q?CIeyohM/bgFh5tzyPhMiy/CcoQ3dQDO2e6AOk8xFP6FNqlOPu/V3AapKEqiA?=
 =?us-ascii?Q?rQitTB7ivpDInH0aWEI5WUvA31FFzasNHMfO04CkOSEthpyi/RziayasCEyb?=
 =?us-ascii?Q?ko6nUocd2/3C5Y5LQgPqzgeUnYi5bhXVEtBYdkGzfm1AgJ5/rk4QGxqyaYad?=
 =?us-ascii?Q?kxemx9DUsWb0p65oa6hQNFPoKh0JDLG/YUe4JY8WP9fcZFvoa1zx+YoTASJV?=
 =?us-ascii?Q?6rGrts5+tK6Hc43Uo59B6dYfYaZYobIV3W/XYCA4PnKjpAM1E0IQtxfD70iS?=
 =?us-ascii?Q?B1SNHkPWMba8l1NIddkwV9DOH/8TQrsAc1KCc0/e4vDL4qvo9aFN7No6LrwH?=
 =?us-ascii?Q?/Zs4CaYl5BFNeni4Imj+rXYlOIKwMnM3Y/gX3amgtL/8IfeGQcjsqLQ8CP+w?=
 =?us-ascii?Q?NE2v8Di8a4yr6RrKXyhIj3YhmUGdi0Zd8LNvHZYJctQPk5lNOrCOip03cT64?=
 =?us-ascii?Q?CPKFxp1iPL6KecjY6VPVG+GTeYHETmLvLx4vco+1h0PGfj39kGM5g7YecBfV?=
 =?us-ascii?Q?x47Fjj1wqUBfIp/8vx6RxIzIXRrkgWzKJhNUxFYI2WM6MRwc0x/fwIfjk6GS?=
 =?us-ascii?Q?UAinG2dCMznGXhYetWI7QPlHzGt4AUJXmq4y42/AdUSKJ8oumSMGPaReEHCY?=
 =?us-ascii?Q?Es/7waHjWPnnReftfqxasMCW0iVsIKtOqdigPe8ULmVg4TH7TGF+xYyeNIiG?=
 =?us-ascii?Q?qnThc4rNBWCcoG/maoH0MBqXLUyQYoA5ci3xSedwHn8X+KRME9A3aTsYOZTb?=
 =?us-ascii?Q?Cg7ByFUxSY0/1f1p7ZstXOWbeOquaQFf47z3NRsR2j9ejjZMNdKbFpokNtDK?=
 =?us-ascii?Q?LC0NvEW+HJrBVwYBvZZXksQVbjlWJkzZxury7BFOjXhHxekma/FUi8doYD0H?=
 =?us-ascii?Q?UhFcSzIvaRFMAAX2pFXQSpLNv6xidjNk05LxRPwT3IrZJWyTb/vaX7BpSgUo?=
 =?us-ascii?Q?ponGsYnkooaTLHv6oq+IYzc9ov+YEtmpNNnzx4jnQ/pD1LOSeClQVjDVed/q?=
 =?us-ascii?Q?OA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d86da1f1-2eb5-4af1-035f-08dab84893fc
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:25:08.7519
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: c4pni+g4bUvFHr+2CBJqAaC9nS8AVM0cvxBr/Hf+yj/ZcvoFslk1iW5Rcknk/maHXAI4d8GATVtye7GnHXEZgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR10MB5937
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270103
X-Proofpoint-ORIG-GUID: VZmS8xbYJd8VK5LlCAZHFztiGHRg4q37
X-Proofpoint-GUID: VZmS8xbYJd8VK5LlCAZHFztiGHRg4q37
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
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From c90324c242ddfabe1cc328bdeda1e2cbf4b77d61 Mon Sep 17 00:00:00 2001
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
index 6bed5da45f8f..b9128eaafffe 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2104,11 +2104,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = __alloc_buddy_huge_page_with_mpol(h, vma, addr);
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

