Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57828204B84
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 09:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731508AbgFWHsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 03:48:01 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:38467 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731245AbgFWHsB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jun 2020 03:48:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 248B1E26;
        Tue, 23 Jun 2020 03:48:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 23 Jun 2020 03:48:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2TqfR8
        XeqtX4PTzJhQdPFzY0grBDfmZZBB2ta4C8Nck=; b=rZbsVSUQ5NJW1YNEYAqzWb
        kF+K94WVQybHTNJQjZ1XZRAFxWNfivZASmB+HTh7uwrM7ibBjSCyIQ9HZVUV3VwV
        ftlQfWCGYJiW/8Or7XFcv/aQYoaHdw39Ym2iwr33owjjBk/u35Tq8a8jIX3wG34X
        zA61JKoREJO/bpKxeK+ZLl2t/zDh0J7W9V0DnlSB6fsjjnXnLucz1j27u46dpGsQ
        2uGkLXD+oV41UnMCu8kfcfPpqKnAC2jgdMzYROPu224PJ6+uhyJzrl/2EbjDT0j2
        138eCK1/cavDQcBnl4E/6ZTRglvfKx6imZJpIKHYxdZGAy00EKhmFexdiomD79Ug
        ==
X-ME-Sender: <xms:r7PxXvNQDhSBrpXTOugz7Wb75JM-JV7a-ZKUbG9jgTKr4DulD3Q9Mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudekfedguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeekhffhfefgfeehfeefudeguedvvdevgffgffdtud
    eujefhhffgveeutddvtdejgfenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhr
    ghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenuc
    frrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:r7PxXp_lzAjVDwyO1_cUmfCE7Mhp8sFtSGK7MA7zJ0blXWLIqy50TA>
    <xmx:r7PxXuT2fl2jj5ph2h5zPUIDs4tknY8R_UlFhUFFywHYXDwd6sB8_g>
    <xmx:r7PxXjtj83f5Ld7mSTSCV27PN4Grmwlqb5SZ3VS7syj1AgkThUxd9g>
    <xmx:r7PxXorLcpWwO_jHTlCYiBjpKK5QmE5aZukVF3IgkhIZSMrOkvHe0YSIGiI>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 57C3430674A6;
        Tue, 23 Jun 2020 03:47:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/gem: Avoid iterating an empty list" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, joonas.lahtinen@linux.intel.com,
        maciej.patelczyk@intel.com, matthew.auld@intel.com,
        stable@vger.kernel.org, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jun 2020 09:47:46 +0200
Message-ID: <159289846689111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 757a9395f33c51c4e6eff2c7c0fbd50226a58224 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Fri, 22 May 2020 14:27:06 +0100
Subject: [PATCH] drm/i915/gem: Avoid iterating an empty list

Our __sgt_iter assumes that the scattergather list has at least one
element. But during construction we may fail in allocating the first
page, and so mark the first element as the terminator. This is
unexpected!

[22555.524752] RIP: 0010:shmem_get_pages+0x506/0x710 [i915]
[22555.524759] Code: 49 8b 2c 24 31 c0 66 89 44 24 40 48 85 ed 0f 84 62 01 00 00 4c 8b 75 00 8b 5d 08 44 8b 7d 0c 48 8b 0d 7e 34 07 e2 49 83 e6 fc <49> 8b 16 41 01 df 48 89 cf 48 89 d0 48 c1 e8 2d 48 85 c9 0f 84 c8
[22555.524765] RSP: 0018:ffffc9000053f9d0 EFLAGS: 00010246
[22555.524770] RAX: 0000000000000000 RBX: 0000000000000000 RCX: ffff8881ffffa000
[22555.524774] RDX: fffffffffffffff4 RSI: ffffffffffffffff RDI: ffffffff821efe00
[22555.524778] RBP: ffff8881b099ab00 R08: 0000000000000000 R09: 00000000fffffff4
[22555.524782] R10: 0000000000000002 R11: 00000000ffec0a02 R12: ffff8881cd3c8d60
[22555.524786] R13: 00000000fffffff4 R14: 0000000000000000 R15: 0000000000000000
[22555.524790] FS:  00007f4fbeb9b9c0(0000) GS:ffff8881f8580000(0000) knlGS:0000000000000000
[22555.524795] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[22555.524799] CR2: 0000000000000000 CR3: 00000001ec7f0004 CR4: 00000000001606e0
[22555.524803] Call Trace:
[22555.524919]  __i915_gem_object_get_pages+0x4f/0x60 [i915]

Fixes: 85d1225ec066 ("drm/i915: Introduce & use new lightweight SGL iterators")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v4.8+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200522132706.5133-1-chris@chris-wilson.co.uk
(cherry picked from commit 957ad9a02be6faa87594c58ac09460cd3d190d0e)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 5d5d7eef3f43..7aff3514d97a 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -39,7 +39,6 @@ static int shmem_get_pages(struct drm_i915_gem_object *obj)
 	unsigned long last_pfn = 0;	/* suppress gcc warning */
 	unsigned int max_segment = i915_sg_segment_size();
 	unsigned int sg_page_sizes;
-	struct pagevec pvec;
 	gfp_t noreclaim;
 	int ret;
 
@@ -192,13 +191,17 @@ static int shmem_get_pages(struct drm_i915_gem_object *obj)
 	sg_mark_end(sg);
 err_pages:
 	mapping_clear_unevictable(mapping);
-	pagevec_init(&pvec);
-	for_each_sgt_page(page, sgt_iter, st) {
-		if (!pagevec_add(&pvec, page))
+	if (sg != st->sgl) {
+		struct pagevec pvec;
+
+		pagevec_init(&pvec);
+		for_each_sgt_page(page, sgt_iter, st) {
+			if (!pagevec_add(&pvec, page))
+				check_release_pagevec(&pvec);
+		}
+		if (pagevec_count(&pvec))
 			check_release_pagevec(&pvec);
 	}
-	if (pagevec_count(&pvec))
-		check_release_pagevec(&pvec);
 	sg_free_table(st);
 	kfree(st);
 

