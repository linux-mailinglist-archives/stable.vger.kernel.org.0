Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF74610039
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 20:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbiJ0Sar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 14:30:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236451AbiJ0Sa3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 14:30:29 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A511B3FA28
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 11:30:18 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RHnRQJ006899;
        Thu, 27 Oct 2022 18:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=aik5LpOsl58m74pWa5eVTmd0hPHzpvsoCrJukma1Woc=;
 b=u20FlnN+lYfc37ZA/4QhTfEhtYQ6X5uDKCqsNyupOqvvUKvwvXNBCs8FvuBJ7SzrwsNZ
 N/ffjHlL2/bOnhGbkn9BA3tv6iUv+6zzJShd7TknrdPEToNCk1/8kcgOB/XYSqADPYrp
 UnZsKgZSnf5wPvVGRqurhiZa7Yb/Ewzstp35k5u1dEpc2+usdDpLeZmHT7Nt0AsKi6Hs
 JFR4XxvzgckK64w5p19ialXpym3UWrc/05BlddqngrK9O48TQup/nNoZwp8duME8Tox7
 sZx9Sg6asYkPr80sqhF+RhVMl+q5dspZ048vp1AdNnPugjRZxkV/a7yhaEVmUg2jMk95 rA== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfb0ajyj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:28:12 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29RIKmIs006946;
        Thu, 27 Oct 2022 18:28:11 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagh8nxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 18:28:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BtDy7ycA8g3BOpP5TcJcnNm1jgvf8R7yvBEpQ5GwV3nyHnqXukXANLjtE944I7e/jXt5fabWVqahqV2x/NsLjQNWmyRFovfvil3ehjQLrKpFk8fPhETR9pQkOqLXiKimyYGIIXyEcwwRFruAYwmWVPPFZj0nBjhKJQsivVd5QlZjEo44k8y3P3uUS10Ja6MY7yRGIWCnU506pjYRf1IWiaT3jBIY4qN4Xg0YWlCnxC1j8teG04RaHDD+FWKRo3LKnSwNMVA+K6Ri6vvoqz0tT/7//+iPNl+seicg8jUBSmqVRAEHzz00w2vzL0IytrqNhYAbXK+XntHzGDrnfEaJaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aik5LpOsl58m74pWa5eVTmd0hPHzpvsoCrJukma1Woc=;
 b=crJR13ekzmjLye1ZQkGEA9Lu/TbZrlHb2O02mY75ewU1WctKJ6mWnkwZKsrs6vUJLm3QqUcFRTargvvJDbd+IfuUbjZnKPVG9QEJ4QfqnS0d4o7JfBrWDlh6yTBanUIil3QG6lukApMdLGOzMoaXq+wYh0L9VZT6Cxy7SvsuYJiSP/Y9LTlaYeLttaEAm9A1chh8oQdRvFvgzGHlM6+D0JJZfpUXJo9yeynNQu0wj+rl5HFYLwgXfOdm0zdmJAYRcn9DFT8k2zREg0Et/+1wfMoXvb15PY4F/nH9qE89uAMfl5iDRdjgWA+EtrOGu+Y9vA41jaSKIasrcodQY5UKqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aik5LpOsl58m74pWa5eVTmd0hPHzpvsoCrJukma1Woc=;
 b=M+Npgp4nkvK/2ZSc2u1e+yqtaKtqKkQbRxhHi6KKHpaE1RrcogUqRZisqHfrZW//XdpAalQDWKCUnHGtq8wIVobpCaLXnMpuYOWSNBSy6gYFyST4mIPBBCdcDI7+6Ss/RtmLmgCByaBAM4/JPg31GyQUxJzkSZc0cmH7s0SAP+g=
Received: from BY5PR10MB4196.namprd10.prod.outlook.com (2603:10b6:a03:20d::23)
 by DS0PR10MB6919.namprd10.prod.outlook.com (2603:10b6:8:134::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Thu, 27 Oct
 2022 18:28:10 +0000
Received: from BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3]) by BY5PR10MB4196.namprd10.prod.outlook.com
 ([fe80::58e9:95ba:d31e:ddd3%6]) with mapi id 15.20.5769.015; Thu, 27 Oct 2022
 18:28:09 +0000
Date:   Thu, 27 Oct 2022 11:28:04 -0700
From:   Mike Kravetz <mike.kravetz@oracle.com>
To:     gregkh@linuxfoundation.org
Cc:     riel@surriel.com, akpm@linux-foundation.org, gkmccready@meta.com,
        n-horiguchi@ah.jp.nec.com, songmuchun@bytedance.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] mm,hugetlb: take hugetlb_lock before
 decrementing" failed to apply to 5.10-stable tree
Message-ID: <Y1rNtNeTICAv9EcK@monkey>
References: <1666796842124254@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1666796842124254@kroah.com>
X-ClientProxiedBy: MW2PR16CA0067.namprd16.prod.outlook.com
 (2603:10b6:907:1::44) To BY5PR10MB4196.namprd10.prod.outlook.com
 (2603:10b6:a03:20d::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB4196:EE_|DS0PR10MB6919:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d068ef5-7fd0-4404-e9e3-08dab848fff3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ClXkTJna1l0/7+QaLt+J9Jj4ssYmLGUdnmOc5eMOLWMKM9rja269oX/0VIekca5MoTk4O50nvB10QJxtlFxbXETYwO5EUTdRRx+2pzWRVguq5orFZZEhP90pdkHj1yR4suvQn96PEoQiCmc86YDxUPxlnMzC/gU+Ksh948pHaUc9Sj8W2QqBrUctD6bFrK+pxljnZewkqz3uZig4tlPMNkN9mgon+w/5PY8OglC+8bo+AwxYr/pU6FDstBLTUfIK1tFhiuB+Saf13Yvhtv102Lt1zWCYnHwKi1TWLV+KVY8PTNRBa1MArC1ak9ZmNSCr7cVJ7anFt/n46FwhAlE8VwwXHCYumoG84mVbEGh7UX6BUHGlrP+4OnN1qYuoNwYBefwDZ2kvw86mTGkWJGaQx6gHPBcdW57UPthoyxx5wEFe+hercbt509wpzUF2VYQ2LHbd6o+cKfndqdopSmFHM3TBBNdcxFIheQrr0hHNvHpFconfhnWYYKa550eaNXGrbwUnz5fE6MXpAz26gWInI3uA3uEC/pqrbRyW7n8VdMoLPdKn1K77udovVvXwFHAZv1mfQzes4qJBKe8QYhJ6tCRBV8sf9Nd9JdLfwL6EtdgGWrf05T/1OWsOUML0kMaKnZ3yNbcKQ8NxFS4uVH/dJMj2kpKuVDDGuFQI0SivJOYhIjK0B5/2TDzl2NmIL0WoZsByojo8TWZur2gLLopHokw3q7233QtbhWnNd2mnw2E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4196.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199015)(8676002)(66946007)(66476007)(66556008)(2906002)(41300700001)(6916009)(316002)(86362001)(8936002)(44832011)(966005)(4326008)(5660300002)(186003)(38100700002)(83380400001)(6486002)(478600001)(6666004)(6512007)(53546011)(26005)(9686003)(6506007)(33716001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tB8NOenqXcqYcj4r4nOM8OH0YC6RVEw/12B4cDTv+MJz0BY4BEEzw8YvwMXx?=
 =?us-ascii?Q?zwWfXfqJ77vbnttyrVaKok/IlWZJS6G0EbLrwXyBLPzyyoiz0w1Ug8LevJZa?=
 =?us-ascii?Q?dTb/7MUpTdlH4hmPWZLFK6WcKYtackeRy1htCMzNiErpvP+U7fUtd9FbccCb?=
 =?us-ascii?Q?HNcH6hgCTJyUxplGZbrQztdKvIxIW023nbHYgK0xt+ve+zVT8MOj2Wf/aUJc?=
 =?us-ascii?Q?1p/0aALSn0h/CJ3Wl4rzO6IVGNy7AIQRkwz9ORABnoC6aUuhkRhs/7y43n8U?=
 =?us-ascii?Q?LHapGLVHHlPc85+HAkVceKlKF+h8I7huyqbdBzT7C2s4gGtGoD69CPME1XCD?=
 =?us-ascii?Q?8uVsTtsUeYJbzz2ZFpXTagonpH0aWmVaSfyvrB8BYUbkT3rWSBoyZWrjL98h?=
 =?us-ascii?Q?jvUro6pSX9TVF2pyExF8X1i6BrmNb5z2aO20wpa64OK/FS1hKZ7o3sEfDyBs?=
 =?us-ascii?Q?Jo1Od6kR7x617tbAprbNE7kQ2g/WwJoKCE8O9tRgMXvIPv6hRUTekJU9esP5?=
 =?us-ascii?Q?dzcWkLdw2fgQFFSaNpRRAdVx7tYwwjTkoSOcu6WDlX950+cQ6CTH7a81kqXD?=
 =?us-ascii?Q?wCQA+JuZWZpoBxfxav2u91BQ/jaDNxVIfIe6PBCc3gPPxy7z+q32ZbaWQKU3?=
 =?us-ascii?Q?scgeADKxr0o+j+pfNAa3/eR3iOsPdDbyZvtmIeXFdD/r59++eq7+qW3iwX+C?=
 =?us-ascii?Q?bZLxdHlfDVWBe8JHUbZiIPXbb2qPok0k9kZGt4E3UgHglbTCj2old7ierjsU?=
 =?us-ascii?Q?3/GdBHVVZgqJjq+4rXpiY7cfs5S3qKPKYuwsG4W1d1ghQSVOfTDsTgjqp13h?=
 =?us-ascii?Q?FGq4EUTL68U7ye6B67HXESrkWzGWMEFKp3soINlPweOerCZmePKvFVETRLm/?=
 =?us-ascii?Q?+XCPozMYL7SeWMbZ7rwXXKSnGnYiHmGJaHr/HLc/hiO1J2qO6e9GGjmudq6Y?=
 =?us-ascii?Q?rRzzx7IFIq0Vxtu1q6BkmNDuezXe2LVtffVou6ApI/OJjpGf/fS9w+WwC8Fs?=
 =?us-ascii?Q?HZ566CAZk3kDrTWLqvzOLC0FUVc9vT2kTIpUbXvUCfTpmp4y/+a4m6yJwgNS?=
 =?us-ascii?Q?Md31ikSXojsd/qJAqaV7eiwWeYP7j9GRHYd8WK3cYnQI1pWcKRT0HpIsGaGm?=
 =?us-ascii?Q?lS+NOMlCYfNtcn549hSEw55RfAegpD2uYO+Y1fC70I5H7s4Vq+q1kL6A18Z9?=
 =?us-ascii?Q?vsTfykJ4dU6r3wtZUOlvCpurR+sSr+Psd3CsA4KlntxNSVqtmfLSPgcqSeIi?=
 =?us-ascii?Q?Hgq5E/KHjrRox5NKb/iowrecazM7b9FJgfZweNwvHp2zXeb0RsMPVkLejUco?=
 =?us-ascii?Q?mPAksy7LH3/1zRAgw17lvnzV2gdL6BapwD+MDXowDtGWg7sUTKb3jvdIGTtz?=
 =?us-ascii?Q?wyYII51UvPrzGJMptYk8dxtNMvGZ5B+CVFlFjn27+oj1JgvALGQbCs0PK5/J?=
 =?us-ascii?Q?uUjque/2PribOD/Ax42SXMJL2EsBfdCOIpsRrjg+cbgVdfUAdie130yXWlw9?=
 =?us-ascii?Q?1aYKbegi83YRtFHaa22jVxNSJpd9MTd2fKhkMtj72TVu42VkCNLTacTjz9KH?=
 =?us-ascii?Q?IEnVXp7Ssbe7XLT+2PzBGtqqg/gkWhD7CSQSwqTroOZatlXpUKTVg6Z1SIoB?=
 =?us-ascii?Q?kQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d068ef5-7fd0-4404-e9e3-08dab848fff3
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4196.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 18:28:09.8771
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QAoRlGrNqOAu/CfOONlknz9tLZwr0rFB6q/sNFGWxFqZcXHC9WS+dQZctEnQEabPT/D5F7NThnSk/6vcZBvjSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6919
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270104
X-Proofpoint-GUID: yTuNNg393brNk09vtjhXkKwrWxnH-Sri
X-Proofpoint-ORIG-GUID: yTuNNg393brNk09vtjhXkKwrWxnH-Sri
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
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

From 6ad2a29a188c16b7336ba34542043a0657d07244 Mon Sep 17 00:00:00 2001
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
index c57c165bfbbc..d8c63d79af20 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2387,11 +2387,11 @@ struct page *alloc_huge_page(struct vm_area_struct *vma,
 		page = alloc_buddy_huge_page_with_mpol(h, vma, addr);
 		if (!page)
 			goto out_uncharge_cgroup;
+		spin_lock(&hugetlb_lock);
 		if (!avoid_reserve && vma_has_reserves(vma, gbl_chg)) {
 			SetPagePrivate(page);
 			h->resv_huge_pages--;
 		}
-		spin_lock(&hugetlb_lock);
 		list_add(&page->lru, &h->hugepage_activelist);
 		/* Fall through */
 	}
-- 
2.37.3

