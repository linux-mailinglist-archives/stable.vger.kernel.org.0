Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0F12C694B
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 17:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731364AbgK0QSu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 11:18:50 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:34142 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731401AbgK0QSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 11:18:50 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0ARGH66r009520;
        Fri, 27 Nov 2020 08:18:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=GwHJSizVFinPEL2T/mhMqS6woUJ9iZbVMHuA7YHw7ik=;
 b=pjgBvKST2OG3TRXXMRORFIcW2pjm5iwdICzyq/4sle4j9XPqsVSnm1ApxlmmNE25LigM
 wUbXmvAXV5gqZNrgfOupQDveMrwudIPurdK2qy/lUfxXGB+3FO6u0jiTcXJYXj5ciwtS
 IF4v7yY9LT94LGaJqtQfi7rDY6cgqCEsKio= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3530c3h5xw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 27 Nov 2020 08:18:38 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 27 Nov 2020 08:18:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlnfKsFJ6hd904Q+tVUI+Kl5KGWUw70SBNiX6mhCgFkjkyfBx2KY9vVQYy4DB4/4iRHHoCKm6E7GbXl3kaiTOXzE9yaUvif5CHm0UbsGTfgDMX2P8WBmOZ+S+t0pKgWEGrbF3uUL1rAOIsgahCxzALql2SNNJd0SNgv+8hpR17qzO8t8T6/yyku3K/VuBx3qr13tNWlubTQ6jrL+PYDr/EL83UDzpQOjM7NVSg/jqHJ8MCe7GZH2zHZWNfLQ/geUP5o1nxiqH8Z/zIbU4JPsAPO9EUyjSU5vgWxoGKmzrXlMC2napeUKHBM0+azyB7wOZsJelEc3EW157Ief1oHNVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwHJSizVFinPEL2T/mhMqS6woUJ9iZbVMHuA7YHw7ik=;
 b=UqmHAFxuDI/rSJT5P+Hwv8SA+lVT4Sgg6B8uaENjHlQaj9D7fAs21XA4cTAsJofZTl8M6t99sNDyei0LPpk26/hj9Ly0v62pzIuW1T/mRA9mMQqjyEqh4eqWe/pbolmwY84gZL3AGpQ3GxNpCqugI1un1y68G9NgkFXRdRhuEVaVwavMAoidIAWDWrbJooDsVORntG18q4cB+Cw19Pq2njxYy6/SAf0j+5JfSgYoCvitsvs9FFWHLl+sVsZvNEGRSlal997HtFjMLJ3vkvvF1ma2nfjaRAdSx+F2rxTaSLsjkCbjlHCd9+7cKfWo4Zp3auNGxJ7hpNyiHnlMcOq77A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GwHJSizVFinPEL2T/mhMqS6woUJ9iZbVMHuA7YHw7ik=;
 b=WcrJZXZZNZ9aM3FkAE1u5JgMxG5ne34/xlsRsIW3wRhyxGwcoTKTH9FvyQC3fgPw0WeXG+8orLXyRcF4N69PnW9TlF/70kSZnIoOwLx2+tkE2WRi9N69Dgw/XKzH3O+uVYeVAIfHCCdalWwzggYnOggtILQDhq4po45irNErQjI=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=fb.com;
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB3078.namprd15.prod.outlook.com (2603:10b6:a03:fe::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Fri, 27 Nov
 2020 16:18:33 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::3925:e1f9:4c6a:9396%6]) with mapi id 15.20.3611.025; Fri, 27 Nov 2020
 16:18:32 +0000
Date:   Fri, 27 Nov 2020 08:18:28 -0800
From:   Roman Gushchin <guro@fb.com>
To:     Shakeel Butt <shakeelb@google.com>
CC:     Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>, <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value
 handling
Message-ID: <20201127161828.GD840171@carbon.dhcp.thefacebook.com>
References: <20201127041405.3459198-1-guro@fb.com>
 <CALvZod56VUdDQmvoHrYFz2mfW_j2C9M+06wcWoz4oCOFmNA4eA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALvZod56VUdDQmvoHrYFz2mfW_j2C9M+06wcWoz4oCOFmNA4eA@mail.gmail.com>
X-Originating-IP: [2620:10d:c090:400::5:6fc7]
X-ClientProxiedBy: MW4PR03CA0385.namprd03.prod.outlook.com
 (2603:10b6:303:114::30) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:6fc7) by MW4PR03CA0385.namprd03.prod.outlook.com (2603:10b6:303:114::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Fri, 27 Nov 2020 16:18:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b07948c0-5db1-476f-4d07-08d892f015bd
X-MS-TrafficTypeDiagnostic: BYAPR15MB3078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB30780F1009B381E75F7DE23CBEF80@BYAPR15MB3078.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:2449;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5F3RBeVlj7V8LCpzvazmG4+5dJ6fGwZ2i1PVXHXsplrRc54fvSg5rgV07Z2vsdQnfhndsnwyTxtV4VgDnyyyLGXRKyFT/q9n4zCIXWl8zl40Uyxk3AIrg4ex4sI+Y3h+NN5woWWmznOQNa5u2TkwZqXjgodrO16M4Lp4IITMdAD5O2Rx3SZyKzZ3F+brLOGYXoIFTXiWupc47Npk40MuPWcu9ZxepGMbK5UjYueQRzAurSgkafnG08V6BbKfAT773QLjmi4bGOleyKISBr0/8XCLaPB2YuUnU1l+CTluwUTv2AmeizotOn1s+zmqmH89
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB4136.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(396003)(376002)(366004)(39860400002)(186003)(53546011)(7696005)(52116002)(6506007)(316002)(55016002)(83380400001)(66476007)(66556008)(66946007)(478600001)(6916009)(54906003)(2906002)(5660300002)(4326008)(16526019)(86362001)(8676002)(8936002)(1076003)(33656002)(6666004)(9686003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?q2tE2/I/JN8NnTFCytqkn70dxS1VJlAcwy8Yihwh1O+5FOz4/mpPXMSVFnOx?=
 =?us-ascii?Q?vJbj8uvPhWp3dBz0qe4NWmLp6zYJx/G23hN9ryYUEC5MPQdMrFVVNTSRTd+F?=
 =?us-ascii?Q?t+ma5E/Bk+rmhmhloGY25x0/xcSmaxIbIjKB9xfpZvgXZK7aUUtmImaGnWzz?=
 =?us-ascii?Q?jKp64/QW71o4FTO4jggr4S7yP914+rRdO0eeoTBAWCPO92GRPJ8w7CZeUqVw?=
 =?us-ascii?Q?vNelpfsZdjD5FCXs6g3dGMciXEaTin+FcFjToja1xBDQ+4HVYFDUUwQC+lV2?=
 =?us-ascii?Q?0jxJRAysUSjT+BWgN97c9oRKKnITjzH6Y+fVDOoL75sVEz1s+AnmZhcT9b4c?=
 =?us-ascii?Q?edBd5RR5du62/TXaq3bqY5uAPDiJtdIsA5OxR1o5nzZdFdSJ2U2jx0WoMoZ/?=
 =?us-ascii?Q?J8t1/fOYqgjEvyyir3rzhfLoGDKJyJPlU3momH1ivg2dEY457zGpVmJYxche?=
 =?us-ascii?Q?BcABSMiPSnspdGUpDRnZXw64+M/YqMMz5HtOG60azBJsocQe999DDdbnt5DD?=
 =?us-ascii?Q?amJfy0LpJZhJz0wAhHGX9Cs1SAAnIthZMWHyK2MCHGlI6t3QHKNpKlsabAP1?=
 =?us-ascii?Q?pbZvvrV4S2PDJltPftOQ8LiiYT5CzHIrT/xdj5/8krDUPsa2g7STpClcMGZ5?=
 =?us-ascii?Q?CImnyznvZIDfd7cECWJTbu4Owtv4sywloP/Eq1SC3pgGzuUOKWSGIw2IfHSn?=
 =?us-ascii?Q?L64tzNjG6B7gwH05HDZgi5sbCiJx6H2HV/fJ3zz4AEgzXtzOD0qKmcqSPK6N?=
 =?us-ascii?Q?L1kd5pCSLFjxaZFzfF5jOvyrdYx8RvDZDy1v0wTtwep1jgzBpaicP1SdFntD?=
 =?us-ascii?Q?Ti5lasgni97UtJdVsL10za9+umEEFjC6r7vZXEeaJbSOyb5fpjYJZWlzJnXI?=
 =?us-ascii?Q?eMT/WNhzJ9nE9IfMOL8XJC4nQcMGBDVz2apGGjp3WCuGlRw4Qp7M6N2moLO1?=
 =?us-ascii?Q?GhmHEb8mEAQQHQmQvfQElqetsh/0z7TLhvXyeO3wEKJ5YaWC64kQcrg5Hs5S?=
 =?us-ascii?Q?2N1Jme/IN96BlgGtbDSmZLwsVA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b07948c0-5db1-476f-4d07-08d892f015bd
X-MS-Exchange-CrossTenant-AuthSource: BYAPR15MB4136.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 16:18:32.9068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EkyrLuYkNq/wo+EDOXkDETSXUOlkPTSwcnbXXs3GsesUtCq2emwEUBf/+ydXl7Nh
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3078
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-27_08:2020-11-26,2020-11-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 spamscore=0 bulkscore=0 suspectscore=5 phishscore=0 mlxlogscore=999
 mlxscore=0 malwarescore=0 clxscore=1015 priorityscore=1501 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011270094
X-FB-Internal: deliver
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 09:55:24PM -0800, Shakeel Butt wrote:
> On Thu, Nov 26, 2020 at 8:14 PM Roman Gushchin <guro@fb.com> wrote:
> >
> > Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
> > for all allocations") introduced a regression into the handling of the
> > obj_cgroup_charge() return value. If a non-zero value is returned
> > (indicating of exceeding one of memory.max limits), the allocation
> > should fail, instead of falling back to non-accounted mode.
> >
> > To make the code more readable, move memcg_slab_pre_alloc_hook()
> > and memcg_slab_post_alloc_hook() calling conditions into bodies
> > of these hooks.
> >
> > Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
> > Signed-off-by: Roman Gushchin <guro@fb.com>
> > Cc: stable@vger.kernel.org
> > ---
> >  mm/slab.h | 40 ++++++++++++++++++++++++----------------
> >  1 file changed, 24 insertions(+), 16 deletions(-)
> >
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 59aeb0d9f11b..5dc89d8fb05e 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -257,22 +257,32 @@ static inline size_t obj_full_size(struct kmem_cache *s)
> >         return s->size + sizeof(struct obj_cgroup *);
> >  }
> >
> > -static inline struct obj_cgroup *memcg_slab_pre_alloc_hook(struct kmem_cache *s,
> > -                                                          size_t objects,
> > -                                                          gfp_t flags)
> > +/*
> > + * Returns true if the allocation should fail.
> 
> IMO returning false if the allocation should fail makes this more
> clear. Otherwise the patch looks good to me.

Ok, I agree. Here is an updated version.

Thank you for looking in!

--

From 456ce03f1c91baf5e2441dce0649e09617437fe4 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Thu, 26 Nov 2020 07:39:57 -0800
Subject: [PATCH v2] mm: memcg/slab: fix obj_cgroup_charge() return value
 handling

Commit 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches
for all allocations") introduced a regression into the handling of the
obj_cgroup_charge() return value. If a non-zero value is returned
(indicating of exceeding one of memory.max limits), the allocation
should fail, instead of falling back to non-accounted mode.

To make the code more readable, move memcg_slab_pre_alloc_hook()
and memcg_slab_post_alloc_hook() calling conditions into bodies
of these hooks.

Fixes: 10befea91b61 ("mm: memcg/slab: use a single set of kmem_caches for all allocations")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
---
 mm/slab.h | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 59aeb0d9f11b..0698a3c0a9da 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -257,22 +257,32 @@ static inline size_t obj_full_size(struct kmem_cache *s)
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
@@ -298,7 +308,7 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	unsigned long off;
 	size_t i;
 
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
 	flags &= ~__GFP_ACCOUNT;
@@ -382,11 +392,11 @@ static inline void memcg_free_page_obj_cgroups(struct page *page)
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
@@ -494,9 +504,8 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp = memcg_slab_pre_alloc_hook(s, size, flags);
+	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
 
 	return s;
 }
@@ -515,8 +524,7 @@ static inline void slab_post_alloc_hook(struct kmem_cache *s,
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
 
 #ifndef CONFIG_SLOB
-- 
2.26.2

