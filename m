Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6819F610023
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234798AbiJ0SZr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236070AbiJ0SZ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:25:27 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2131C386B5
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:25:24 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHmxMm019842;
        Thu, 27 Oct 2022 18:23:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=bhuy3Chaq5A263zPH0AVwNVtkQmnDHbs8VGs9mwSyxs=;
 b=2C6MpqpxyBBjSn5gaQIzqFdX1edBSGfmjc9WMfz5MRbLPkc9oYPiiZSZLMrTpmSCAWJY
 eYtn57XBjwqTaPvoR7WJMJ/9eBcon+PmEZGP3miG+aFjHT9CwrBIoCCQ3XK/7BD3oter
 F+AmJ1CMfpV+hxrXJnaS0XCX42KSuHWVqLjpsmGSwVgEJfuv5Dm5pyEMhZFXsL+9Rbvc
 kQhNkhEAolLVgG4a6OzWeWjxt4UM5hhsxepNhyUS7y+IpGAAy5P6w0KbMVJZ3AaiNciH
 vgjlFRzIMgRPxd/xtHFH7sERKoXIx3G9S+2XW5uim6BvdycqeQAnGx71eob5Z7+nFMn+ 8Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfax7ttx6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:23:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RI8oIH011614;
        Thu, 27 Oct 2022 18:23:15 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2169.outbound.protection.outlook.com [104.47.73.169])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagr992y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:23:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/5Dnv4bohlkV7cVabFKsWe+oOawV4yX1D8GFdWZ7BSWe1z4s4LkOSYyBNH7hkIfLVvkamNThAatNcLLEtIPE7qVONlCGU1crAHvqV/ENM8iH2634buPcAmDbcio2+wxklxYWN28AW2+CqDhAy//QzzG9+cduYeuO/73DIDt2rdCNO38WCu4gQ0WssTd/UI41zRGLPhFF0bqQBsjYuj7crCV/QDOq9QyS107NWfGVKU3CHLZ3CR9jcbm2sZKbSpvzdmUhhvfwsiUPD+m7wqMa/Kn9TkwY75jEKJUAxhOj2a7qWkQduIeA3FuYJN47+fqmvygcR/9UQ4eMBdqWQNE9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bhuy3Chaq5A263zPH0AVwNVtkQmnDHbs8VGs9mwSyxs=;
 b=cjEY1nK696sbfmN7qHaZ3Dq3ARL4is1zDBOWuONjnv2LyaLtdKWAbGgcRmXKr/NkJsXrz9fX2DZEvJ/zvK83PUIw9ka+gKNq+1dmZEaq6BNvR+wd7zkj/10gqi+F739scSeCi8ThrKTl+1V4o6OhvPeQHem2wgtNMnQl9Xhot2lc+cIc8blNb0A9/3iGD2Rn+DHUrrHdAvIYu6l/IPdkKN67Xfc96rghV1RuQocuBpHT59A0YOSKXYTAiDAN1unjYEHAiI1lnylxF69xFwCRQIv48rRHG3Tn4Gr6XWrKg6Vgio8kqCtsbnH6g/8hT08blpeMM1c8bcAc1S49MbNkSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bhuy3Chaq5A263zPH0AVwNVtkQmnDHbs8VGs9mwSyxs=;
 b=ax7lkoWZ5CI6KU1ebJ09gUT/avXHUaOkcVK0RQnULmKSYrbrw2Atdw2g+4jEa+ZBZmniks4eRxVcROWR2Tvs1+8HeOHlrtEDZmEQ+561FlsqEBXi5f0AcFjob/PxKgWuZccOM8fPEqv5LInvFrlLiqIRUl8k5ie0G78LbtN+KL4=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by MW5PR10MB5739.namprd10.prod.outlook.com (2603:10b6:303:19c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.27; Thu, 27 Oct
 2022 18:23:13 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:23:13 +0000
Date:   Thu, 27 Oct 2022 11:23:06 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 4.14-stable tree
Message-ID: <Y1rMiioDOyZ/0vCZ@monkey>
References: <1666796845146209@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666796845146209@kroah.com>
X-ClientProxiedBy: MW4PR03CA0166.namprd03.prod.outlook.com
 (2603:10b6:303:8d::21) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|MW5PR10MB5739:EE_
X-MS-Office365-Filtering-Correlation-Id: 23a4773a-4e65-4b91-ac51-08dab8484f0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dvOfRtJqoFlGhAogE049as9lZwKJGENQu4aNsxkC7oTTmFSa+SO05tS04YyH2yjNZZOoDdc4qDl4eAIedhVhtLNYjMKOtE2yOdYi7vc608eVUpK+W8z9k6FhsxFw6QVKfYchx04fj6/flVX4lOgrdn9lrzL1ukBDZ6XvFIPN+VknUnVIWwQyxw04YTFd6AXXOp3kAcbJH5/9X0kxZByRG+Cs0M0EKyMaEHubC7pTFU1Z0rWoTe3+MPH8g72ADCmwO75I64DMmn65XZqO0AxppGBkGexYeNuBT2fJOjtzCUwMt/D4kp66nZoD/zQuyG4x5Pk9OSEOglqanqYc/CMQ/pojZ7z9gryqdSNoP4OkGlxc5lE3+09yPn1BDB1vT9W8nYVUWgxT+ul0Ud3ch4sVcXOoLdEj7IUHvxX4ad59ofvoFDNMZaL4BRaT0Sq9EOt5nDHjOQLWlmh6Z4xvlsIFivvO2h1MtWba0yh0cPFQzz64430W5tzJ8AsDsoC/z6bUZ4jvqoG25xwwnXE8eL/fa+yjO0/KWzHDFtswTHbKI8J5tynlEnxYowVCjs1KUZSfCG0Wu/ZyRmPsPmGDKBkhlaiAGaFuuAjJyrpIOg24tkVGrOFTQLgBOOYwKzS9Kj4o5Duc8Mq3NUjwP/6wygyYSeahkoi9aHv88zL990csYTx4ziThCN13kIGmnTENRjfV0AVnH6dYzegXQWY6kxa3qrnkpHgOT+7ztivHwwJMw/4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(396003)(366004)(346002)(376002)(136003)(39860400002)(451199015)(83380400001)(86362001)(26005)(186003)(44832011)(4326008)(38100700002)(5660300002)(2906002)(8936002)(66946007)(33716001)(6506007)(6666004)(41300700001)(6916009)(8676002)(66556008)(966005)(316002)(9686003)(53546011)(478600001)(66476007)(6486002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fgYMp5vfPpJYMkwBHkSdvrAoRkADAxVUq3D+r7kxWDrqBcr/1WTCYMjY4gKU?=
 =?us-ascii?Q?XOJpxgNWpntU6LdhQ7ws5Oos7ZKzJx1vm/ip8lP9cGk4A4ycYX4Q/ZKd+rpt?=
 =?us-ascii?Q?0w4dChgPBn4SlQAYyrx84hEhAkcjfV5T/f6WyEuOrW8mx0lVSvwu/lPSW+S0?=
 =?us-ascii?Q?0Qklu7P5hFYN4YpZbeB3nb4Q1gWUupWLU8Gq03oDMbqEG+dyBLHBskwPkSLh?=
 =?us-ascii?Q?uPIKoAfI7Y/ronXrfN8ojqhuIBYvI901a0PHTQal3X9KjGaOuQePsx9J7ERU?=
 =?us-ascii?Q?l5SpH23a2/zXWSzFf/RrGl1LtH9CpBzfxW0v8IzL2OjRF/NPrbXJadXBJpZT?=
 =?us-ascii?Q?iWYcL4T2WkmjS5Jg8gA4HJTa99RarvSdFiM4UGd6GOwA1y37ezAi4MOTD3S+?=
 =?us-ascii?Q?EGtJ6Yod+MuUBYSzSleQF9jIj2dITskgLWGSGiXd3TwwytYAFIPdfS0Cob6k?=
 =?us-ascii?Q?eF6n6qZVcEpZQe+1W4TrEwqRXtmhY2x6wvUEZPmrpNQig60S7L/8RRXRa5a+?=
 =?us-ascii?Q?nGhY0s0ZTGfebwcFGxsjmrpF4imPb6RRxAL1SIOmx2Prs2L9QyXDUxGLEEmq?=
 =?us-ascii?Q?Hjyw4oMb7LOhhTDPK/s1VdI4Wtqy6qmIg/Y4QXPStCTbZ5Q90ZKFB2Ij09H6?=
 =?us-ascii?Q?Z3thKufbLGfnsHEcrq5qCr6iEyOEL/vybbxv1dk+2LMGd9kwJCXAtSVinXw0?=
 =?us-ascii?Q?Da5/EqeM6x6iAyMe7HIw9B+mFkHOq2BmvOazrNnUgZyw17J3EansymK/eHw7?=
 =?us-ascii?Q?I1/LAKT5Pwl77lFVcj+bEmgCMCu3uEuWqYy92C2LA8JjxPfhgoCvySy5IP2H?=
 =?us-ascii?Q?5k5v/fVVLBJGp91bLlGhb1PUCiu1NdwZyp9mtfo97C2Wt0+YhOQ3NNtfu920?=
 =?us-ascii?Q?5avNelG/3I/htIKUXUzZ0G7Ty3KMLUPvOKSnH/ePOxfOsabaoYg6mWROFuLK?=
 =?us-ascii?Q?F6XhM5ydPJmkfNgXJWUfAkzLtFOvwud6Ppe2ASbVud1X1Ie4E6C4m5UM+KLG?=
 =?us-ascii?Q?CLhkd2hWX2MIo6VrrU1290F+4SYhFP0QjTtvfeyCgZMiG2CSV5/NlnOrrjE6?=
 =?us-ascii?Q?pKWF/5eUwm1b6h2v1NU+jdvjXYSC6ONvv7seL0SrFCylSF8NTkNmoBDjivrA?=
 =?us-ascii?Q?+GckhVa3U7mwIuc2hATJvq47zV7M/eoNM1ZSdFffNMKAFRZ8mKPII0vF/aSi?=
 =?us-ascii?Q?AIJWGVmF07yo8AvWbAXOczMqB3bmcMbuTjuv2Km6fk1TevloE/SCOZyu0nNn?=
 =?us-ascii?Q?PneTNsee9Yi7CvZVSzPa1Qd2PTd3YQi3MvADhDwl1cFofh7n3G6Vio6sS1yh?=
 =?us-ascii?Q?veRXUOIbOARUjw6Yypo1wY5YSy0PTLd2V+lZFWFwp4arRUWqGIsiHtvpc4bm?=
 =?us-ascii?Q?RyBC0oJqIYsj2HKqL8zVbavMngaSme5JMxJbc0pRESXGxYRwvuos4cUA/t83?=
 =?us-ascii?Q?so+F3neOVxg+bZoAePTFKj9icvPHs38/q25wyM6AHIGZpD1FebOIPaSoHoo1?=
 =?us-ascii?Q?XKAirE8Xcmagx3YCiKZeE14rc5T+jSFgIGKrMFGdFwuyOo9wCdryhoB5+UN+?=
 =?us-ascii?Q?r2wa5hf6OCJtENZprF2Bpg8C8VYSWHhnTzHI5PTEEpo8XBr5CiSbJUFpTxK+?=
 =?us-ascii?Q?Bg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23a4773a-4e65-4b91-ac51-08dab8484f0c
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:23:13.1620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abZAxg/RTmjFDeIEojK0B9YOUxySVAOxA+UtBKD5EjALmVu7Sj1E3tKY1ppWBSNxqxKQXmel+7OIFdp162EIxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5739
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0 bulkscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270103
X-Proofpoint-GUID: 4z2ZX74R32vGExklQcUDvEN3Q-HTM4Yv
X-Proofpoint-ORIG-GUID: 4z2ZX74R32vGExklQcUDvEN3Q-HTM4Yv
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
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From f550d2286f9c1fc308ce9fc678ba67b167d344c1 Mon Sep 17 00:00:00 2001
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
index 04ad2bba01eb..f09f5dd9c731 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2089,11 +2089,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
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

