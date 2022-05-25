Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C773E534337
	for <lists+stable@lfdr.de>; Wed, 25 May 2022 20:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343842AbiEYSmw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 14:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343858AbiEYSmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 14:42:19 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1386DA454;
        Wed, 25 May 2022 11:42:17 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 324F55C00F1;
        Wed, 25 May 2022 14:42:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 25 May 2022 14:42:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm1; t=1653504135; x=
        1653590535; bh=IzC1Lf6nigMRWiB9U/JcQwb9cl+2WkqbqCQ8B2xwhgQ=; b=s
        6ZP5jmjsZIoyBGP4epU3kxEFo1+la+txzb8Lwu9EpCUdo67NzNiBGyMBKb2qNVXG
        580T5/EfIsj1IAM5AZHSBDarEsdGz0fVu5O4CoLnNlqksMJeGR0tdgEHx/9t+I/t
        xJz6gvWdCX7GS/IFCRJdoUAlU3oaJ832DWq8AGOgE6+p8iOtkYuto5Vx2QRBUkiU
        VCI2g6ea6rnz6Q+CftOvlp938vebEW9kP/SI2kN1siwxSycKilfpam1mbU6va3+4
        2WBN6val8LlLbtZTH6nfuwHU+gFNNHPYesjh4jLbhV9nhcxdbqbKWndeX/gTb+Lu
        nfR4VzcYpxdUaWLNx6apQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1653504135; x=1653590535; bh=IzC1Lf6nigMRWiB9U/JcQwb9cl+2WkqbqCQ
        8B2xwhgQ=; b=hgYCk+9L+3wKSB7dO0pFs73z2RoYenuk8rByPFtDwl2EIrJz+qH
        loluingXVrThMudBibrCFJNkkCWTi/TqNNVWpreTArOfWUUpNXg8jBSubnL4qSUp
        UwlMYuqvgHrC7bHZkzgtEDxBYwPr7Ad/5a2TNnaf1cSkheqo/bR2tp02yG7C6Q+a
        hbU+YSP6ZCCrZzscu5Ej+d9aOWZtlkfprXaeM9mfce5A1LQENwp4913lA1FYhDxP
        43sKka8D3ULAP6VFyOvPoSL6kGEpOsrNrUAsNrGbfRq2j+aWxUzKYCGh96BsWv8c
        3K6ahDga19tUCb++gFPcfDpP0EwhFMTbxuQ==
X-ME-Sender: <xms:hniOYs0R-V0YjvPgm90sN4k_Ee-abckXXzBcg7awFwj1FwyL4B_vyg>
    <xme:hniOYnHe_D-oqs6KYPiERyJIU8-ZXcEo-2J4ngRWBK8g0dd9O0hnA6JsxAKNApWPv
    WROz4fx5Hhw2ek>
X-ME-Received: <xmr:hniOYk6UEHTXb9le5kkmbLMCHlZhjleHNc0tFAjjZCwPAElb7zHkLf1unPQvro098KCkQ2qImzup>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrjeehgdduvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepffgvmhhiucfo
    rghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhnghhslh
    grsgdrtghomheqnecuggftrfgrthhtvghrnhepieejgedufeeukeeijedukefgueekvdeg
    iedtudefhfdtffehffeuveefvdfglefgnecuffhomhgrihhnpehgihhthhhusgdrtghomh
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpeguvghm
    ihesihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtohhm
X-ME-Proxy: <xmx:hniOYl2lGPHW6kqe_87dWe7-IqPUZqMVWd9XPjYPFoNENxUQ8XPXKg>
    <xmx:hniOYvG6DyAXJ8WGdur_ECkcrefSaXKiHz8YMUTXPg2VsNV1yTl42g>
    <xmx:hniOYu-6uZ3zqBEwf0hbSqXA534xj0VFQKxp7_TtRdbidOcOOFT40Q>
    <xmx:h3iOYk6EsmptZgcIbu8xS5pnDZcjnY_Yz5fHGAfKk8VXdGC141q54A>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 25 May 2022 14:42:14 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Jennifer Herbert <jennifer.herbert@citrix.com>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] xen/gntdev: Avoid blocking in unmap_grant_pages()
Date:   Wed, 25 May 2022 14:41:53 -0400
Message-Id: <20220525184153.6059-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

unmap_grant_pages() currently waits for the pages to no longer be used.
In https://github.com/QubesOS/qubes-issues/issues/7481, this lead to a
deadlock against i915: i915 was waiting for gntdev's MMU notifier to
finish, while gntdev was waiting for i915 to free its pages.  I also
believe this is responsible for various deadlocks I have experienced in
the past.

Avoid these problems by making unmap_grant_pages async.  This requires
making it return void, as any errors will not be available when the
function returns.  Fortunately, the only use of the return value is a
WARN_ON(), which can be replaced by a WARN_ON when the error is
detected.  Additionally, a failed call will not prevent further calls
from being made, but this is harmless.

Because unmap_grant_pages is now async, the grant handle will be sent to
INVALID_GRANT_HANDLE too late to prevent multiple unmaps of the same
handle.  Instead, a separate bool array is allocated for this purpose.
This wastes memory, but stuffing this information in padding bytes is
too fragile.  Furthermore, it is necessary to grab a reference to the
map before making the asynchronous call, and release the reference when
the call returns.

Fixes: 745282256c75 ("xen/gntdev: safely unmap grants in case they are still in use")
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
---
 drivers/xen/gntdev-common.h |   5 ++
 drivers/xen/gntdev.c        | 100 +++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 46 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 20d7d059dadb..a268cdb1f7bf 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -16,6 +16,7 @@
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
 #include <xen/interface/event_channel.h>
+#include <xen/grant_table.h>
 
 struct gntdev_dmabuf_priv;
 
@@ -56,6 +57,7 @@ struct gntdev_grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
 
@@ -73,6 +75,9 @@ struct gntdev_grant_map {
 	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
 	xen_pfn_t *frames;
 #endif
+
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 59ffea800079..90bd2b5ef7dd 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -62,8 +63,8 @@ MODULE_PARM_DESC(limit,
 
 static int use_ptemod;
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -120,6 +121,7 @@ static void gntdev_free_map(struct gntdev_grant_map *map)
 	kvfree(map->unmap_ops);
 	kvfree(map->kmap_ops);
 	kvfree(map->kunmap_ops);
+	kvfree(map->being_removed);
 	kfree(map);
 }
 
@@ -140,10 +142,13 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
 	add->unmap_ops = kvmalloc_array(count, sizeof(add->unmap_ops[0]),
 					GFP_KERNEL);
 	add->pages     = kvcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kvcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 	if (use_ptemod) {
 		add->kmap_ops   = kvmalloc_array(count, sizeof(add->kmap_ops[0]),
@@ -349,79 +354,84 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 	return err;
 }
 
-static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			       int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
-
-	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
-		int pgno = (map->notify.addr >> PAGE_SHIFT);
-		if (pgno >= offset && pgno < offset + pages) {
-			/* No need for kmap, pages are in lowmem */
-			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
-			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
-			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
-		}
-	}
-
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
-
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
+	unsigned int i;
+	struct gntdev_grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
 		pr_debug("unmap handle=%d st=%d\n",
 			map->unmap_ops[offset+i].handle,
 			map->unmap_ops[offset+i].status);
 		map->unmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		if (use_ptemod) {
-			if (map->kunmap_ops[offset+i].status)
-				err = -EINVAL;
+			WARN_ON(map->kunmap_ops[offset+i].status);
 			pr_debug("kunmap handle=%u st=%d\n",
 				 map->kunmap_ops[offset+i].handle,
 				 map->kunmap_ops[offset+i].status);
 			map->kunmap_ops[offset+i].handle = INVALID_GRANT_HANDLE;
 		}
 	}
-	return err;
+
+	/* Release reference taken by __unmap_grant_pages */
+	gntdev_put_map(NULL, map);
 }
 
-static int unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			     int pages)
+static void __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			       int pages)
+{
+	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
+		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
+		if (pgno >= offset && pgno < offset + pages) {
+			/* No need for kmap, pages are in lowmem */
+			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
+			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
+			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
+		}
+	}
+
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
+
+	gnttab_unmap_refs_async(&map->unmap_data);
+}
+
+static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			      int pages)
 {
-	int range, err = 0;
+	int range;
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages &&
-		       map->unmap_ops[offset].handle == INVALID_GRANT_HANDLE) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset + range].handle ==
-			    INVALID_GRANT_HANDLE)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -473,7 +483,6 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -494,10 +503,9 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			range->start, range->end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 
 	return true;
 }
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
