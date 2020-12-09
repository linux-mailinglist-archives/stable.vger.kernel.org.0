Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6AD02D4CDD
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 22:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLIVbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 16:31:01 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:49734 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388183AbgLIVbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 16:31:00 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0B9LThMY003366;
        Wed, 9 Dec 2020 13:30:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=QkW2vcLingYHK3rQD+3RBcJfh3nu5wcRx12YMaDgSnI=;
 b=STZT5PM83SalXzfoj+6kGJyDAxmOn6g6icK9Wln5wm+i1tEVGDfea338vthg1tYFAUKQ
 MjjnYlgGZjtilnhLFdckh4MLVgKarZXAs3p7EWdJgPwkF8SFLPr6EZwrtnvVLTEDRftL
 sRGLUcBFiHfOKWv+QUNgmwvWRY/a0CgXDDc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 35b68s844q-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 09 Dec 2020 13:30:09 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Dec 2020 13:30:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ew12s1FXEfMmC766dhq+f+7ymx8uJ1xJ0l+R3SERqfjTsxL0/M42UGo1OZgvXavap/aVyKeIfOKu4919BEeZcuq3AK6c6m5scsKV3kOXCRsLqbZc4D45pgpcimoJ9KYSYQu2487MeZO/EG/QPZ6ZQysuc1eefcKuIJOgfz3uU1YE/GzlSLjPpnkOR4GKeDBGvS9d89luFOyIDgSSDoBOOHjy3PV2w2ji/9YQMVcoBZkbcNr93Rht3//+YN3By6mJfOVd/GZPyL56tWjRb4BYSk1qwAjddPRIOzGhk44WEvFlo9D4jm0wBtSC/PMjXgU7nJe6fb8cI+lbwyP81ELfmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkW2vcLingYHK3rQD+3RBcJfh3nu5wcRx12YMaDgSnI=;
 b=dqjB6urgpwH8Mxq9a+snKysegPEgaruzdEPqVMZtBeEf8t7iMXmw08/iFpk1qB++oGGdBi5IiDfYxSSIAo7Il5CAusMp1Bx59E1CcNRHVTSn1rPm5MumnN6a29BgpI8RDzwU7lrga4tWMDryXQVRm7t0/Ap1OKyGHyiBpQHP6wVJP7Vp3Y5ghETAUSeqYkFK3OkRAOPQhnwAtdrr7bBrtMfnoO0ss4TytyabT43Am1BFWoutfoTwr4lRtUXVuXKmsYAJ0tkN7t3fzGf/s0gIQ5oSFmmwtwMgaBYBi68L5VTZMsSvLO9xPnzhPT+s6kR9JcE1N7xrE8wWtlwnGbk6gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QkW2vcLingYHK3rQD+3RBcJfh3nu5wcRx12YMaDgSnI=;
 b=CnxYi5BLpQAdTjR4Xolt3hAoqeFH48O3r4CuRUU7PuipkBlBldeziwaydM92M/iWb6XyEetpUUUes7JP4IzLamD4J98tl2T6Tf50rPjovOPh2yWkqR3nn0CG4VdPqazx1ohRJNuSdj9FPWl9P6sYX+bIrqA59PU7IsHIlc+Mh+8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB4135.namprd15.prod.outlook.com (2603:10b6:a03:a0::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Wed, 9 Dec
 2020 21:30:07 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3632.024; Wed, 9 Dec 2020
 21:30:07 +0000
Date:   Wed, 9 Dec 2020 13:30:04 -0800
From:   Roman Gushchin <guro@fb.com>
To:     <stable@vger.kernel.org>
CC:     <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <hannes@cmpxchg.org>, <mhocko@kernel.org>, <shakeelb@google.com>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>
Subject: Re: FAILED: patch "[PATCH] mm: memcg/slab: fix obj_cgroup_charge()
 return value handling" failed to apply to 5.9-stable tree
Message-ID: <20201209213004.GA2470631@carbon.dhcp.thefacebook.com>
References: <1607504747243177@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1607504747243177@kroah.com>
X-Originating-IP: [2620:10d:c090:400::5:c1d3]
X-ClientProxiedBy: SJ0PR13CA0066.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::11) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:c1d3) by SJ0PR13CA0066.namprd13.prod.outlook.com (2603:10b6:a03:2c4::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.5 via Frontend Transport; Wed, 9 Dec 2020 21:30:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 715675f4-7406-463f-fe34-08d89c89998d
X-MS-TrafficTypeDiagnostic: BYAPR15MB4135:
X-Microsoft-Antispam-PRVS: <BYAPR15MB4135856668365896E0C5F6B0BECC0@BYAPR15MB4135.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMkdrMKKFdZuLHSUgHchChaUGqxtUgV321q0IbrVcmE0f1tMZWmCaS7+yO/Si1nNaBIMkmbBOFV0/6h/N6LG1Pq+/eXx2Y95M32J/R1CxmD+k9ircfp4u0T+3HZXfRUmQB9Nnr76YyqiN85x4/wrTgPVQDOWlzKUqAyNlNmvt7yi8FXkaTsbMNywm3c60Dwi3r13GTFaiXBKFxBJuvIS3Hg+xKjmqC71urzD7/O+kByXB6n9vooGZ3jcH2tN1wsMRprqJlMd3s457aPLcB2YAgYjsnHCdNzb3cQTvvmwxZkYUKexeffjpQufBqnGQC8S2UcM0fxBSgFo33bH9QprufuGJ5St34R+naFYdN8UF2HUsqi3QV4SL29DnOmxyBDtJuymXWeHFEY/w3qjkZD3SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(66476007)(16526019)(66556008)(53546011)(8936002)(9686003)(7696005)(33656002)(66946007)(52116002)(508600001)(6506007)(6916009)(5660300002)(8676002)(2906002)(186003)(55016002)(86362001)(4326008)(1076003)(966005)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hpD/vWQME5uyWACzf+fiERU0MI6cilEsuQtQ0N78TBQx+1hZBB/6+Vfy7lkE?=
 =?us-ascii?Q?k+uTkaELERaox0km3807SxJ19u3c70I6aE9Zzk1NCORIAmCHluYGBvcRdi8P?=
 =?us-ascii?Q?4leHoBG74AFFyiLlUoZAUifa8vqqjwXoXMPzANjaHMUltJvvMb9dZYo+WSHW?=
 =?us-ascii?Q?A/iPqSlfwqkSm8dXCDjLZ2XXY18Go/0x7Tmnw17DkdPQ51kE0hHjXv0RhyaQ?=
 =?us-ascii?Q?B1I+eXMkJF0bWSsOwC4OgBunnPxUuSm7ddYma2UE9aJlAldgAKvaPIHLwyqj?=
 =?us-ascii?Q?WUAvSGeCUt8gDVbn+BEu6AlrwGUeZdv6cX7SfupGboESXYrIvayiK8xath7a?=
 =?us-ascii?Q?FNPlhMPCRTtrdMTuVBoVbisD1ezcWsdBZepGAB4tRU2IWy/zsdIgo/PclBTO?=
 =?us-ascii?Q?EnJq++BSOC66J3JOOxErsER8orIgmV+Xv2bOdNyZZWuZuFd1oE5kpVjbPkbs?=
 =?us-ascii?Q?Kf0hzLObaBtl5SoKk41EjSMLEs3loeoAVZ4xONW4EhkFN4XTikcFv0/noaQB?=
 =?us-ascii?Q?/4wZ/MYkxKkN74hs6I2FEApPqPMAIkN6KrnTw523vuBBLjY4FwlPC6184VKn?=
 =?us-ascii?Q?gWFImneHCSi5AJiPtWf4LawGYEZC35Zrg3s4oIUCXVhlyQPtp5PvW8dFo/6t?=
 =?us-ascii?Q?lttdIO71j53L9KjPq3iEJBM1pBIH8SLZuUmk6J939wxINExGAWOICA1Pp1YV?=
 =?us-ascii?Q?jF5b+gL8NtOYWirjaMJ/0Xm0Wa8nhHY9LS9ra7Xva41JBYK6ze/xL9EzI9AS?=
 =?us-ascii?Q?LtT5y575OmlKpknxoLd5lzQpcJzE5TartfKDAhEkgmBE97spry186hBnSY6C?=
 =?us-ascii?Q?gNm1O1peggq5WtJ1dYiJ4MvLaRGDzBJ8FQoqvNK1ZNXMEOHPaO2HRORgdPSf?=
 =?us-ascii?Q?8pmnCFUF3w1Ey0AyJfVouH4nUh81VVx3BgjUHi4QGB9E1PWIilc7BB8qKHRA?=
 =?us-ascii?Q?u7RxsIC9FhZBd0RpQCSZlNuVrcrloICVtIVCJt7haM01FnDaUYIPp11ACXkE?=
 =?us-ascii?Q?6QCTQrky9YyB0KcNAPfkOpKsMg=3D=3D?=
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2020 21:30:07.2118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-Network-Message-Id: 715675f4-7406-463f-fe34-08d89c89998d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V7nlJ0jP/UOQ1eOsaX4ZQ//8aWdBaXrOj+sAeKDC9L+SURNHucbLKqhyvEpg2oak
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB4135
X-OriginatorOrg: fb.com
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_18:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 spamscore=0
 phishscore=0 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0
 suspectscore=10 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090149
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 09, 2020 at 10:05:47AM +0100, Greg Kroah-Hartman wrote:
> 
> The patch below does not apply to the 5.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Hi Greg!

Please, find the backport below.

Thanks!

--------------------------------------------------------------------------------

From 838b473ad8fdba90afb2ec8220eb100bf73675d6 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Sat, 5 Dec 2020 22:14:45 -0800
Subject: [PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value handling

Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") introduced a regression into the handling of the
obj_cgroup_charge() return value.  If a non-zero value is returned
(indicating of exceeding one of memory.max limits), the allocation
should fail, instead of falling back to non-accounted mode.

To make the code more readable, move memcg_slab_pre_alloc_hook() and
memcg_slab_post_alloc_hook() calling conditions into bodies of these
hooks.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201127161828.GD840171@carbon.dhcp.thefacebook.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
(cherry picked from commit becaba65f62f88e553ec92ed98370e9d2b18e629)
---
 mm/slab.h | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 6dd4b702888a..70aa1b5903fc 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -275,25 +275,35 @@ static inline size_t obj_full_size(struct kmem_cache *s)
 	return s->size + sizeof(struct obj_cgroup *);
 }
 
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
-							   size_t objects,
-							   gfp_t flags)
+/*
+ * Returns false if the allocation should fail.
+ */
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
 	struct obj_cgroup *objcg;
 
+	if (!memcg_kmem_enabled())
+		return true;
+
+	if (!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT))
+		return true;
+
 	if (memcg_kmem_bypass())
-		return NULL;
+		return true;
 
 	objcg = get_obj_cgroup_from_current();
 	if (!objcg)
-		return NULL;
+		return true;
 
 	if (obj_cgroup_charge(objcg, flags, objects * obj_full_size(s))) {
 		obj_cgroup_put(objcg);
-		return NULL;
+		return false;
 	}
 
-	return objcg;
+	*objcgp = objcg;
+	return true;
 }
 
 static inline void mod_objcg_state(struct obj_cgroup *objcg,
@@ -319,7 +329,7 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	unsigned long off;
 	size_t i;
 
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
 	flags &= ~__GFP_ACCOUNT;
@@ -404,11 +414,11 @@ static inline void memcg_free_page_obj_cgroups(struct page *page)
 {
 }
 
-static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
-							   size_t objects,
-							   gfp_t flags)
+static inline bool memcg_slab_pre_alloc_hook(struct kmem_cache *s,
+					     struct obj_cgroup **objcgp,
+					     size_t objects, gfp_t flags)
 {
-	return NULL;
+	return true;
 }
 
 static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
@@ -512,9 +522,8 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp = memcg_slab_pre_alloc_hook(s, size, flags);
+	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
 
 	return s;
 }
@@ -533,8 +542,7 @@ static inline void slab_post_alloc_hook(struct kmem_cache *s,
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
 
 #ifndef CONFIG_SLOB
-- 
2.26.2

