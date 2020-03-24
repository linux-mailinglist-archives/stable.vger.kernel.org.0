Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 181EC1902FC
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 01:43:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgCXAmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Mar 2020 20:42:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8254 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726986AbgCXAmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Mar 2020 20:42:36 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02O0UaS8020026;
        Mon, 23 Mar 2020 17:42:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=Nn+/9jI7fodF5HypccNRhRBClO1bGj638wu+Kbo8ZoU=;
 b=B3YXgpMHrUujsuqBoj/hJWSuPGwxsWRlgvUoOi3vNEbqkEyVeuciQk1UixEPFyphyKFH
 1OTcHpUkUpX0bjYtnq97Gl8p0UBfcpafrbgnH07DbcyG/rDuECjrUlO1iwqRj+QnNx6i
 am83yPm3dmUG0wkEzyQIpie/j4fPrDhsqpo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ywgeku19c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 23 Mar 2020 17:42:28 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 23 Mar 2020 17:42:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cGX7+iS66/ha2j3AwJN4S/Qbtg3zLwtdHZiV+y6XiN73Uo0YbFXkcys5RLmkc4HzRQrpt2iDr0Hib6HjWMxDaviYGVzNFB+eOiZhiuwlnmo5pvAseD0gBEb5OMI6nwWSrR6qlEEKLMcEGfKQFJfdnwWuvYsfrO1tTLemKCDBjMNTT5JVjML96TOvn2v4XBiLGWiX1R27lyCJGUi1qZA2NqVgWQ7bPtlSmU/YzvtP8XCqs2Y8E+9YMHvs/GBdDLIHIIIJlWn+oPYgsoAAShDvWmPuRmcn5ZI3gDpsWm6votblVG/q4gYBd0mehHhWqkzCfuIhYgNywdEr5i9bp5fR+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nn+/9jI7fodF5HypccNRhRBClO1bGj638wu+Kbo8ZoU=;
 b=GH2xdM3hMuoKEKkP2EEAvnz7XmczTrwy62R9EE132ALNZ6XRaFM2MkN8UmKGgbUdw/ftvxj8AHTS6fOnIlzv2iHxEeBzCGiuXKqlVH9vWjnpWe3jgk6QkwWubSBkv1k8QTYgOG4RSTezZwgwVFtSlteFzrZ3HMk7y/SzjveQgr8X2t5lBJh4a1TKYKtH808wGlZbqs2sCS3mjqDOjOT8kDDdt65J0dFxAWQ8T4CMhL2ygIXyamHguSHCg7UYQCo3EEt5Q7z/thVTDrp0SgnYTeE2XPj07Ju9qEu+FDo26ZefzYObEICvhlg9r0421It9BH68/H9WMhOyjUt86Tdflw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nn+/9jI7fodF5HypccNRhRBClO1bGj638wu+Kbo8ZoU=;
 b=O+nispp8IIyOVaFvHLoEHfZcRo7ma/Qz6HVhe87UQVrlHYf4zIuRN9FWTueJzsplMhL6ToDE/ZPeTJ34cC5Dao8kYaP6xBA6MTLsZif2npBP0WHOc5tL+p31+7dhBAdbc7GQHWdP5r81H1VZarkLhWmpwCL92AenfWkpVKeccHY=
Received: from BYAPR15MB4136.namprd15.prod.outlook.com (2603:10b6:a03:96::24)
 by BYAPR15MB2647.namprd15.prod.outlook.com (2603:10b6:a03:153::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.21; Tue, 24 Mar
 2020 00:42:26 +0000
Received: from BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275]) by BYAPR15MB4136.namprd15.prod.outlook.com
 ([fe80::bdf9:6577:1d2a:a275%7]) with mapi id 15.20.2835.021; Tue, 24 Mar 2020
 00:42:26 +0000
Date:   Mon, 23 Mar 2020 17:42:21 -0700
From:   Roman Gushchin <guro@fb.com>
To:     Andrew Morton <akpm@linux-foundation.org>
CC:     Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@kernel.org>, <linux-mm@kvack.org>,
        <kernel-team@fb.com>, <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.ibm.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: fork: fix kernel_stack memcg stats for various stack
 implementations
Message-ID: <20200324004221.GA36662@carbon.dhcp.thefacebook.com>
References: <20200303233550.251375-1-guro@fb.com>
 <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200321164856.be68344b7fac84b759e23727@linux-foundation.org>
X-ClientProxiedBy: MWHPR03CA0014.namprd03.prod.outlook.com
 (2603:10b6:300:117::24) To BYAPR15MB4136.namprd15.prod.outlook.com
 (2603:10b6:a03:96::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from carbon.dhcp.thefacebook.com (2620:10d:c090:400::5:2f3f) by MWHPR03CA0014.namprd03.prod.outlook.com (2603:10b6:300:117::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.20 via Frontend Transport; Tue, 24 Mar 2020 00:42:25 +0000
X-Originating-IP: [2620:10d:c090:400::5:2f3f]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c500e351-65df-466d-39d5-08d7cf8c3962
X-MS-TrafficTypeDiagnostic: BYAPR15MB2647:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR15MB264750BAD65F05563D8D1D13BEF10@BYAPR15MB2647.namprd15.prod.outlook.com>
X-FB-Source: Internal
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03524FBD26
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(396003)(376002)(346002)(39860400002)(136003)(5660300002)(186003)(6666004)(6506007)(54906003)(966005)(316002)(8676002)(81166006)(16526019)(7696005)(478600001)(86362001)(53546011)(6916009)(8936002)(33656002)(1076003)(4326008)(81156014)(2906002)(52116002)(9686003)(55016002)(66476007)(66946007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2647;H:BYAPR15MB4136.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QjdHHrCkMqUkxTgAQrKZf7COu1BHDJfds63EtJO/G8Mhn15PsopB6zX8jF4yFeRKzumnmCs+5biUkWmQjWawQAgno2agZxCU/nvR26aHsRqVxQWayNeWBjKe9tJgJk+HWPDW2imImuHn3Y+ejjlelJkzC1xIpQOKvOyLm5Wo3IFePVjeIAXBLn5YGKRbVg1zR3R7RpI3iX88Ed3QKNAPxlH0uX2X+H1NilGl5Fs0gOgFkAgYXEL43fd7YRUyVZVgr3voR+06GnWhIrZ57Ge683Y6jRGtO2D2Xu6Tk+EQ23uCG4VtooMoZ12uSiEutwdy9PzBbbFf4KTVfBVZP8+pdIvGh+NQsc7Iywr41rLtgQOTIf0ZAdnsYX7YmfRrFZzOo4pE4DcA2FHUaRVeiMuWtSlePFTPpJWbe4DfUbzuqTNXRuZ66MZ/Jsx+q3bdFxDVIAHzAU5stwxDIDgjiTr5AkU5N65NXfdb9xJWdXsLsnB8R6mQl24Yc2JEY1TUm0WmQ/mEHovYRioxQsbszJwwaA==
X-MS-Exchange-AntiSpam-MessageData: 2Ovhd4Z8EA4p296YeVOPTeATyh7UD1uFAjZA7paweF3fWkMjKmRW4xRdyMQ4tDp8P1EuhndPxqHrQMAQIK8FT3HHuazcMbBQBLMCMZ0j2EWIEdt5fTsaDvUVWYF8XsSHQRWdjQyilEMq77cd5vnNiJOU+RSXfFxG+pk2USgDEIrRwmEvhLtI/N5GZxcUEu+R
X-MS-Exchange-CrossTenant-Network-Message-Id: c500e351-65df-466d-39d5-08d7cf8c3962
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2020 00:42:26.3213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jSHgYVv6xam/AhZ4iwiSxhvNJRkRhIcY4T3xkZiA4ad55ermh4j+0eT45xjVBdMv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2647
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_10:2020-03-23,2020-03-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=2 phishscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2003240000
X-FB-Internal: deliver
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 21, 2020 at 04:48:56PM -0700, Andrew Morton wrote:
> On Tue, 3 Mar 2020 15:35:50 -0800 Roman Gushchin <guro@fb.com> wrote:
> 
> > Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio
> > the space for task stacks can be allocated using __vmalloc_node_range(),
> > alloc_pages_node() and kmem_cache_alloc_node(). In the first and the
> > second cases page->mem_cgroup pointer is set, but in the third it's
> > not: memcg membership of a slab page should be determined using the
> > memcg_from_slab_page() function, which looks at
> > page->slab_cache->memcg_params.memcg . In this case, using
> > mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
> > page->mem_cgroup pointer is NULL even for pages charged to a non-root
> > memory cgroup.
> > 
> > It can lead to kernel_stack per-memcg counters permanently showing 0
> > on some architectures (depending on the configuration).
> > 
> > In order to fix it, let's introduce a mod_memcg_obj_state() helper,
> > which takes a pointer to a kernel object as a first argument, uses
> > mem_cgroup_from_obj() to get a RCU-protected memcg pointer and
> > calls mod_memcg_state(). It allows to handle all possible
> > configurations (CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE
> > values) without spilling any memcg/kmem specifics into fork.c .
> > 
> > Note: this patch has been first posted as a part of the new slab
> > controller patchset. This is a slightly updated version: the fixes
> > tag has been added and the commit log was extended by the advice
> > of Johannes Weiner. Because it's a fix that makes sense by itself,
> > I'm re-posting it as a standalone patch.
> 
> Actually, it isn't a standalone patch.
> 
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -776,6 +776,17 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
> >  	rcu_read_unlock();
> >  }
> >  
> > +void mod_memcg_obj_state(void *p, int idx, int val)
> > +{
> > +	struct mem_cgroup *memcg;
> > +
> > +	rcu_read_lock();
> > +	memcg = mem_cgroup_from_obj(p);
> > +	if (memcg)
> > +		mod_memcg_state(memcg, idx, val);
> > +	rcu_read_unlock();
> > +}
> 
> mem_cgroup_from_obj() is later added by
> http://lkml.kernel.org/r/20200117203609.3146239-1-guro@fb.com
> 
> We could merge both mm-memcg-slab-introduce-mem_cgroup_from_obj.patch
> and this patch, but that's a whole lot of stuff to backport into
> -stable.
> 
> Are you able to come up with a simpler suitable-for-stable fix?

How about this one? I've merged them into one and stripped it a little bit.

Thanks!

--

From 1b8b039b05d49945aaf34a0600b04ea616fe0ba2 Mon Sep 17 00:00:00 2001
From: Roman Gushchin <guro@fb.com>
Date: Sat, 21 Mar 2020 23:05:42 +0000
Subject: [PATCH] mm: fork: fix kernel_stack memcg stats for various stack
 implementations

Depending on CONFIG_VMAP_STACK and the THREAD_SIZE / PAGE_SIZE ratio the
space for task stacks can be allocated using __vmalloc_node_range(),
alloc_pages_node() and kmem_cache_alloc_node().  In the first and the
second cases page->mem_cgroup pointer is set, but in the third it's not:
memcg membership of a slab page should be determined using the
memcg_from_slab_page() function, which looks at
page->slab_cache->memcg_params.memcg .  In this case, using
mod_memcg_page_state() (as in account_kernel_stack()) is incorrect:
page->mem_cgroup pointer is NULL even for pages charged to a non-root
memory cgroup.

It can lead to kernel_stack per-memcg counters permanently showing 0 on
some architectures (depending on the configuration).

In order to fix it, let's introduce a mod_memcg_obj_state() helper, which
takes a pointer to a kernel object as a first argument, uses
mem_cgroup_from_obj() to get a RCU-protected memcg pointer and calls
mod_memcg_state().  It allows to handle all possible configurations
(CONFIG_VMAP_STACK and various THREAD_SIZE/PAGE_SIZE values) without
spilling any memcg/kmem specifics into fork.c .

Note: This is a special version of the patch created for stable
backports. It contains code from the following two patches:
  - mm: memcg/slab: introduce mem_cgroup_from_obj()
  - mm: fork: fix kernel_stack memcg stats for various stack implementations

Fixes: 4d96ba353075 ("mm: memcg/slab: stop setting page->mem_cgroup pointer for slab pages")
Signed-off-by: Roman Gushchin <guro@fb.com>
Cc: stable@vger.kernel.org
---
 include/linux/memcontrol.h | 12 ++++++++++++
 kernel/fork.c              |  4 ++--
 mm/memcontrol.c            | 38 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 2 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a7a0a1a5c8d5..e9ba01336d4e 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -695,6 +695,7 @@ static inline unsigned long lruvec_page_state_local(struct lruvec *lruvec,
 void __mod_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 			int val);
 void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val);
+void mod_memcg_obj_state(void *p, int idx, int val);
 
 static inline void mod_lruvec_state(struct lruvec *lruvec,
 				    enum node_stat_item idx, int val)
@@ -1123,6 +1124,10 @@ static inline void __mod_lruvec_slab_state(void *p, enum node_stat_item idx,
 	__mod_node_page_state(page_pgdat(page), idx, val);
 }
 
+static inline void mod_memcg_obj_state(void *p, int idx, int val)
+{
+}
+
 static inline
 unsigned long mem_cgroup_soft_limit_reclaim(pg_data_t *pgdat, int order,
 					    gfp_t gfp_mask,
@@ -1427,6 +1432,8 @@ static inline int memcg_cache_id(struct mem_cgroup *memcg)
 	return memcg ? memcg->kmemcg_id : -1;
 }
 
+struct mem_cgroup *mem_cgroup_from_obj(void *p);
+
 #else
 
 static inline int memcg_kmem_charge(struct page *page, gfp_t gfp, int order)
@@ -1468,6 +1475,11 @@ static inline void memcg_put_cache_ids(void)
 {
 }
 
+static inline struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+       return NULL;
+}
+
 #endif /* CONFIG_MEMCG_KMEM */
 
 #endif /* _LINUX_MEMCONTROL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 080809560072..183a6722dfe2 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -397,8 +397,8 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		mod_zone_page_state(page_zone(first_page), NR_KERNEL_STACK_KB,
 				    THREAD_SIZE / 1024 * account);
 
-		mod_memcg_page_state(first_page, MEMCG_KERNEL_STACK_KB,
-				     account * (THREAD_SIZE / 1024));
+		mod_memcg_obj_state(stack, MEMCG_KERNEL_STACK_KB,
+				    account * (THREAD_SIZE / 1024));
 	}
 }
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6c83cf4ed970..a0aa1c213231 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -775,6 +775,17 @@ void __mod_lruvec_slab_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_unlock();
 }
 
+void mod_memcg_obj_state(void *p, int idx, int val)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	memcg = mem_cgroup_from_obj(p);
+	if (memcg)
+		mod_memcg_state(memcg, idx, val);
+	rcu_read_unlock();
+}
+
 /**
  * __count_memcg_events - account VM events in a cgroup
  * @memcg: the memory cgroup
@@ -2636,6 +2647,33 @@ static void commit_charge(struct page *page, struct mem_cgroup *memcg,
 }
 
 #ifdef CONFIG_MEMCG_KMEM
+/*
+ * Returns a pointer to the memory cgroup to which the kernel object is charged.
+ *
+ * The caller must ensure the memcg lifetime, e.g. by taking rcu_read_lock(),
+ * cgroup_mutex, etc.
+ */
+struct mem_cgroup *mem_cgroup_from_obj(void *p)
+{
+	struct page *page;
+
+	if (mem_cgroup_disabled())
+		return NULL;
+
+	page = virt_to_head_page(p);
+
+	/*
+	 * Slab pages don't have page->mem_cgroup set because corresponding
+	 * kmem caches can be reparented during the lifetime. That's why
+	 * memcg_from_slab_page() should be used instead.
+	 */
+	if (PageSlab(page))
+		return memcg_from_slab_page(page);
+
+	/* All other pages use page->mem_cgroup */
+	return page->mem_cgroup;
+}
+
 static int memcg_alloc_cache_id(void)
 {
 	int id, size;
-- 
2.25.1

