Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0AC2D462B
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730469AbgLIP5I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:57:08 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:58095 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730441AbgLIPxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:53:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2DC0D19439D8;
        Wed,  9 Dec 2020 04:04:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:04:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=nll7Zi
        FrgJhKmzVyn2NCJzE0jeKHq6VsmqRHH0CcZEQ=; b=VIQ26TVuervX21uisLIa3H
        tqZfx06FrRR/ypAdRp5KJkI7DKqDvOdVq47ycYWkvYxJVAlxRrjuxtCQV62UZgr1
        VYts9K8wUCrIbNKYapKCz3DxJwhduEfrJEsBOdnGhMK/khSDuMBzjXPVJNADGkrE
        jPZV31V32VSLFwd+ou+YafY45GpVZOa9rs5cp4R0RaeEeUDsvVInH5y02k3LqgTm
        EZ7nfSGu2++TR6XOMeSbtpw2RbF2BNKJe85Gc9adM2Bg9ojz12oZT6FIT1MsYuT+
        64ckF/mSuvfkTrXCT9Qbp6WaMckEd3EYtyxCJA2kZctdudFIsDMTC9K6ADoEZ3bw
        ==
X-ME-Sender: <xms:HZPQX80du6nHkyyDSUwBZ4733Wy9tBZH6eWWg_mixfZvfwjK1bg3fA>
    <xme:HZPQX3H6Y-j4VARyVS676jvoSApNRuMxP-TkFBDX8YNUVS-9dbgj3_kW4x7hrWTG0
    ZCs5rN6Qsozbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekgeefle
    egieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:HZPQX06AH5sAMjoxhYxwoxeay2UTk95lZmCAZOntOuP7A0dYsBe3cA>
    <xmx:HZPQX10he4rhhWAX3y3mfm-l_nYe6AVJSuR4JvxV0i43kwzI9Y1Y-A>
    <xmx:HZPQX_GGZjoTcxKp-w_Jhcdf8xtNxAEN8qEA19KxWFZrcCS4X1G1bA>
    <xmx:H5PQXzheWUIKHpq3AothP5lYxqM8eGFG6hIo03BhPnDtnLWhnJKbEw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8A691080059;
        Wed,  9 Dec 2020 04:04:28 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm: memcg/slab: fix obj_cgroup_charge() return value handling" failed to apply to 5.9-stable tree
To:     guro@fb.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        mhocko@kernel.org, shakeelb@google.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:05:47 +0100
Message-ID: <1607504747243177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From becaba65f62f88e553ec92ed98370e9d2b18e629 Mon Sep 17 00:00:00 2001
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

diff --git a/mm/slab.h b/mm/slab.h
index 6d7c6a5056ba..f9977d6613d6 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -274,22 +274,32 @@ static inline size_t obj_full_size(struct kmem_cache *s)
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
@@ -315,7 +325,7 @@ static inline void memcg_slab_post_alloc_hook(struct kmem_cache *s,
 	unsigned long off;
 	size_t i;
 
-	if (!objcg)
+	if (!memcg_kmem_enabled() || !objcg)
 		return;
 
 	flags &= ~__GFP_ACCOUNT;
@@ -400,11 +410,11 @@ static inline void memcg_free_page_obj_cgroups(struct page *page)
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
@@ -508,9 +518,8 @@ static inline struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s,
 	if (should_failslab(s, flags))
 		return NULL;
 
-	if (memcg_kmem_enabled() &&
-	    ((flags & __GFP_ACCOUNT) || (s->flags & SLAB_ACCOUNT)))
-		*objcgp = memcg_slab_pre_alloc_hook(s, size, flags);
+	if (!memcg_slab_pre_alloc_hook(s, objcgp, size, flags))
+		return NULL;
 
 	return s;
 }
@@ -529,8 +538,7 @@ static inline void slab_post_alloc_hook(struct kmem_cache *s,
 					 s->flags, flags);
 	}
 
-	if (memcg_kmem_enabled())
-		memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
+	memcg_slab_post_alloc_hook(s, objcg, flags, size, p);
 }
 
 #ifndef CONFIG_SLOB

