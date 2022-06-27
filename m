Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B568655DDED
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:28:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbiF0SK3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 14:10:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbiF0SK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 14:10:27 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A734A9FCC
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:10:26 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 1A7B85C01CF;
        Mon, 27 Jun 2022 14:10:26 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 27 Jun 2022 14:10:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm2; t=
        1656353426; x=1656439826; bh=lOgO7/MkD/pT4PfK69b91gFfkelWuZztBiA
        L6+qToLw=; b=llieCiZBXLbkXZGOfCR9hyK5iUCGnrXyHEfu4pm/xco/WbiUYfw
        m4YfIlTTed6Oq1/RusdqQeQqRdR9Svjlf1q6bKiCdzKjzfmcwhXpFvlYQfWN6UNP
        TyZyfR9gNAWJbGHjpkeNXVVBU4AzRvkZcyPHKwffO8AYrRTy5iFTtIWjM0AeM6YF
        0xTwOYPsW5LF0sMsN68uMuPvwg1yQwn5r8EDLKElaqEgFUorkUYHBn0ovqHRYzAB
        AJkgsGBd1lJcpL11JqmhRZM3LkSXVG6HahP9CrvKDuZzpdOYsS3HXUUu8+vqqGHV
        4cS2jyzhl/ROSxV7whtHWihNzdyz75yMCgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1656353426; x=1656439826; bh=lOgO7/MkD/pT4
        PfK69b91gFfkelWuZztBiAL6+qToLw=; b=iO6uNxFtRmfY8kW6yvdkW90T/tkO7
        +5+ihtclmMYmAAibdh624QgqV86qGPc31vcQ/PfX4gOQmT/vZaPg6o/RO0GoCdc5
        EMJSGiKZEAyUQwj28pUlomwmj9ZXmf817sxkQdcGhublCGlu+1gsI2jdvMdv03GU
        AGO7lhW139N3J3GIA9JPNnYxng9E5DPdb8R4zOK95QjGGFb10xfdwkdbw1Oe9gvj
        dC2CWfz4sVr2sNQN5qo7syT8SIEke6vrlHUyg+R9RGR7seCUzoDgtmt9OYuWS08x
        +jGmoKg9Y6D4+MyFV53jVyZQvyYEgJt9L3HvJQTdBAq8omuo8w+W+/QdQ==
X-ME-Sender: <xms:kfK5YiEcRkT70Ov0wytkUB1WneSnm1OuXwsjriKQJCoblcQZ15Fr_w>
    <xme:kfK5YjW8geMgrRWb2aZrW1EuqdYzYmukxFfzdKhvab60PPXlFzRLKKkbBH57BEYPs
    S3e-RgKA9X4ZD0>
X-ME-Received: <xmr:kfK5YsIYkdu1LPZGwMSnNsjBRhh6LBASKdIL4trLEGBbY0xXLOz5TCy39Tyn-RSbOaaPQMWVzRYF>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeghedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeffvghm
    ihcuofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinh
    hgshhlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeettdegudelkeelveejhefhvdek
    hfevuedvvedtudfhhfdvledtgedtgfekuddugeenucffohhmrghinhepghhithhhuhgsrd
    gtohhmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhlrggsrd
    gtohhm
X-ME-Proxy: <xmx:kfK5YsFCwSy7ugcmGGoG21zHIZqaRrYPPB0VZprxYm_-jg70EqJEPg>
    <xmx:kfK5YoWWctQWNbo7KvtdUArwO2noAMNQr2lsvVPXG6hHMKQJRfGYlA>
    <xmx:kfK5YvMwiAH4aA5tyEL9n4ADEBiK0TObHtJMbY1b2NNkaYKY1schFQ>
    <xmx:kvK5YjeFm22CkV5ZMhSBCJ9qJtMCPp9pYXYFeINpFtXljJ0v14f3UA>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Jun 2022 14:10:25 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>,
        Juergen Gross <jgross@suse.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 4.19] xen/gntdev: Avoid blocking in unmap_grant_pages()
Date:   Mon, 27 Jun 2022 14:10:04 -0400
Message-Id: <20220627181006.1954-3-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220627181006.1954-1-demi@invisiblethingslab.com>
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit dbe97cff7dd9f0f75c524afdd55ad46be3d15295 upstream

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

It is also necessary to guard against reentrancy in gntdev_map_put(),
and to handle the case where userspace tries to map a mapping whose
contents have not all been freed yet.

Fixes: 745282256c75 ("xen/gntdev: safely unmap grants in case they are still in use")
Cc: stable@vger.kernel.org
Signed-off-by: Demi Marie Obenour <demi@invisiblethingslab.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20220622022726.2538-1-demi@invisiblethingslab.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/gntdev-common.h |   8 ++
 drivers/xen/gntdev.c        | 146 +++++++++++++++++++++++++-----------
 2 files changed, 109 insertions(+), 45 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 2f8b949c3eeb..fab6f5a54d5b 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -15,6 +15,8 @@
 #include <linux/mman.h>
 #include <linux/mmu_notifier.h>
 #include <linux/types.h>
+#include <xen/interface/event_channel.h>
+#include <xen/grant_table.h>
 
 struct gntdev_dmabuf_priv;
 
@@ -61,6 +63,7 @@ struct gntdev_grant_map {
 	struct gnttab_unmap_grant_ref *unmap_ops;
 	struct gnttab_map_grant_ref   *kmap_ops;
 	struct gnttab_unmap_grant_ref *kunmap_ops;
+	bool *being_removed;
 	struct page **pages;
 	unsigned long pages_vm_start;
 
@@ -78,6 +81,11 @@ struct gntdev_grant_map {
 	/* Needed to avoid allocation in gnttab_dma_free_pages(). */
 	xen_pfn_t *frames;
 #endif
+
+	/* Number of live grants */
+	atomic_t live_grants;
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index e519063e421e..492084814f55 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -64,11 +64,12 @@ MODULE_PARM_DESC(limit, "Maximum number of grants that may be mapped by "
 
 static atomic_t pages_mapped = ATOMIC_INIT(0);
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 #define populate_freeable_maps use_ptemod
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -125,6 +126,7 @@ static void gntdev_free_map(struct gntdev_grant_map *map)
 	kfree(map->unmap_ops);
 	kfree(map->kmap_ops);
 	kfree(map->kunmap_ops);
+	kfree(map->being_removed);
 	kfree(map);
 }
 
@@ -144,12 +146,15 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
 	add->kmap_ops  = kcalloc(count, sizeof(add->kmap_ops[0]), GFP_KERNEL);
 	add->kunmap_ops = kcalloc(count, sizeof(add->kunmap_ops[0]), GFP_KERNEL);
 	add->pages     = kcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
 	    NULL == add->map_ops   ||
 	    NULL == add->unmap_ops ||
 	    NULL == add->kmap_ops  ||
 	    NULL == add->kunmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 
 #ifdef CONFIG_XEN_GRANT_DMA_ALLOC
@@ -245,6 +250,35 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 		return;
 
 	atomic_sub(map->count, &pages_mapped);
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * reference count greater than 1, so they will return before
+		 * this code is reached.  The recursion depth is thus limited to
+		 * 1.  Do NOT use refcount_inc() here, as it will detect that
+		 * the reference count is zero and WARN().
+		 */
+		refcount_set(&map->users, 1);
+
+		/*
+		 * Unmap the grants.  This may or may not be asynchronous, so it
+		 * is possible that the reference count is 1 on return, but it
+		 * could also be greater than 1.
+		 */
+		unmap_grant_pages(map, 0, map->count);
+
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
 
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
@@ -302,6 +336,7 @@ static int set_grant_ptes_as_special(pte_t *pte, pgtable_t token,
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -350,87 +385,109 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 			map->pages, map->count);
 
 	for (i = 0; i < map->count; i++) {
-		if (map->map_ops[i].status == GNTST_okay)
+		if (map->map_ops[i].status == GNTST_okay) {
 			map->unmap_ops[i].handle = map->map_ops[i].handle;
-		else if (!err)
+			if (!use_ptemod)
+				alloced++;
+		} else if (!err)
 			err = -EINVAL;
 
 		if (map->flags & GNTMAP_device_map)
 			map->unmap_ops[i].dev_bus_addr = map->map_ops[i].dev_bus_addr;
 
 		if (use_ptemod) {
-			if (map->kmap_ops[i].status == GNTST_okay)
+			if (map->kmap_ops[i].status == GNTST_okay) {
+				if (map->map_ops[i].status == GNTST_okay)
+					alloced++;
 				map->kunmap_ops[i].handle = map->kmap_ops[i].handle;
-			else if (!err)
+			} else if (!err)
 				err = -EINVAL;
 		}
 	}
+	atomic_add(alloced, &map->live_grants);
 	return err;
 }
 
-static int __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			       int pages)
+static void __unmap_grant_pages_done(int result,
+		struct gntab_unmap_queue_data *data)
 {
-	int i, err = 0;
-	struct gntab_unmap_queue_data unmap_data;
+	unsigned int i;
+	struct gntdev_grant_map *map = data->data;
+	unsigned int offset = data->unmap_ops - map->unmap_ops;
 
+	for (i = 0; i < data->count; i++) {
+		WARN_ON(map->unmap_ops[offset+i].status);
+		pr_debug("unmap handle=%d st=%d\n",
+			map->unmap_ops[offset+i].handle,
+			map->unmap_ops[offset+i].status);
+		map->unmap_ops[offset+i].handle = -1;
+	}
+	/*
+	 * Decrease the live-grant counter.  This must happen after the loop to
+	 * prevent premature reuse of the grants by gnttab_mmap().
+	 */
+	atomic_sub(data->count, &map->live_grants);
+
+	/* Release reference taken by __unmap_grant_pages */
+	gntdev_put_map(NULL, map);
+}
+
+static void __unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			       int pages)
+{
 	if (map->notify.flags & UNMAP_NOTIFY_CLEAR_BYTE) {
 		int pgno = (map->notify.addr >> PAGE_SHIFT);
+
 		if (pgno >= offset && pgno < offset + pages) {
 			/* No need for kmap, pages are in lowmem */
 			uint8_t *tmp = pfn_to_kaddr(page_to_pfn(map->pages[pgno]));
+
 			tmp[map->notify.addr & (PAGE_SIZE-1)] = 0;
 			map->notify.flags &= ~UNMAP_NOTIFY_CLEAR_BYTE;
 		}
 	}
 
-	unmap_data.unmap_ops = map->unmap_ops + offset;
-	unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
-	unmap_data.pages = map->pages + offset;
-	unmap_data.count = pages;
+	map->unmap_data.unmap_ops = map->unmap_ops + offset;
+	map->unmap_data.kunmap_ops = use_ptemod ? map->kunmap_ops + offset : NULL;
+	map->unmap_data.pages = map->pages + offset;
+	map->unmap_data.count = pages;
+	map->unmap_data.done = __unmap_grant_pages_done;
+	map->unmap_data.data = map;
+	refcount_inc(&map->users); /* to keep map alive during async call below */
 
-	err = gnttab_unmap_refs_sync(&unmap_data);
-	if (err)
-		return err;
-
-	for (i = 0; i < pages; i++) {
-		if (map->unmap_ops[offset+i].status)
-			err = -EINVAL;
-		pr_debug("unmap handle=%d st=%d\n",
-			map->unmap_ops[offset+i].handle,
-			map->unmap_ops[offset+i].status);
-		map->unmap_ops[offset+i].handle = -1;
-	}
-	return err;
+	gnttab_unmap_refs_async(&map->unmap_data);
 }
 
-static int unmap_grant_pages(struct gntdev_grant_map *map, int offset,
-			     int pages)
+static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
+			      int pages)
 {
-	int range, err = 0;
+	int range;
+
+	if (atomic_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
 	pr_debug("unmap %d+%d [%d+%d]\n", map->index, map->count, offset, pages);
 
 	/* It is possible the requested range will have a "hole" where we
 	 * already unmapped some of the grants. Only unmap valid ranges.
 	 */
-	while (pages && !err) {
-		while (pages && map->unmap_ops[offset].handle == -1) {
+	while (pages) {
+		while (pages && map->being_removed[offset]) {
 			offset++;
 			pages--;
 		}
 		range = 0;
 		while (range < pages) {
-			if (map->unmap_ops[offset+range].handle == -1)
+			if (map->being_removed[offset + range])
 				break;
+			map->being_removed[offset + range] = true;
 			range++;
 		}
-		err = __unmap_grant_pages(map, offset, range);
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -500,7 +557,6 @@ static int unmap_if_in_range(struct gntdev_grant_map *map,
 			      bool blockable)
 {
 	unsigned long mstart, mend;
-	int err;
 
 	if (!in_range(map, start, end))
 		return 0;
@@ -514,10 +570,9 @@ static int unmap_if_in_range(struct gntdev_grant_map *map,
 			map->index, map->count,
 			map->vma->vm_start, map->vma->vm_end,
 			start, end, mstart, mend);
-	err = unmap_grant_pages(map,
+	unmap_grant_pages(map,
 				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
 				(mend - mstart) >> PAGE_SHIFT);
-	WARN_ON(err);
 
 	return 0;
 }
@@ -558,7 +613,6 @@ static void mn_release(struct mmu_notifier *mn,
 {
 	struct gntdev_priv *priv = container_of(mn, struct gntdev_priv, mn);
 	struct gntdev_grant_map *map;
-	int err;
 
 	mutex_lock(&priv->lock);
 	list_for_each_entry(map, &priv->maps, next) {
@@ -567,8 +621,7 @@ static void mn_release(struct mmu_notifier *mn,
 		pr_debug("map %d+%d (%lx %lx)\n",
 				map->index, map->count,
 				map->vma->vm_start, map->vma->vm_end);
-		err = unmap_grant_pages(map, /* offset */ 0, map->count);
-		WARN_ON(err);
+		unmap_grant_pages(map, /* offset */ 0, map->count);
 	}
 	list_for_each_entry(map, &priv->freeable_maps, next) {
 		if (!map->vma)
@@ -576,8 +629,7 @@ static void mn_release(struct mmu_notifier *mn,
 		pr_debug("map %d+%d (%lx %lx)\n",
 				map->index, map->count,
 				map->vma->vm_start, map->vma->vm_end);
-		err = unmap_grant_pages(map, /* offset */ 0, map->count);
-		WARN_ON(err);
+		unmap_grant_pages(map, /* offset */ 0, map->count);
 	}
 	mutex_unlock(&priv->lock);
 }
@@ -1113,6 +1165,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	}
 
+	if (atomic_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
