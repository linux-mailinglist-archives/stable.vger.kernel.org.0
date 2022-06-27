Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45D8555C1F8
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 14:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbiF0SKY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 14:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236927AbiF0SKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 14:10:23 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E52A29FCC
        for <stable@vger.kernel.org>; Mon, 27 Jun 2022 11:10:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 9CED25C017C;
        Mon, 27 Jun 2022 14:10:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 27 Jun 2022 14:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm2; t=1656353419; x=
        1656439819; bh=XZWK+bw9iY+oAJN0Z4Vfay10wlsKWP9yZKGtDt1PJP4=; b=T
        JqByFNGRD/9fBh5O/htScTScPxK+rsdaHV1yGzCNInah2OFXA/fdtaizdHzYtAEM
        DS3c/2xZVhK4JO6iHWFfVaPZ9v1xDqckC4uXsBQW88P7aAskYuq5fasbE61rrvlZ
        zjewboZAzDCWtFR6kXlS/Sl31UvfwhXM6OZSyCHUdJJ2SU9Re7grITot1bWxZmPN
        gwOQsKBtAw04/fvryivMWrtLOSlMOvMrWxjiMUkIgsR18gPV9xF6ynD/LbqC35WR
        bzF/OBCNJ0sOzfwUf16OuVSynedG8PdS8M6TxC/+xUDYyb6uqP2IQnTzDR4zzbtf
        DTttukg9G6Br20P5eWmyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1656353419; x=1656439819; bh=XZWK+bw9iY+oAJN0Z4Vfay10wlsKWP9yZKG
        tDt1PJP4=; b=oCwdZDCN0J7MeBl3MsZLKkZyzSbHUQKF3qe77yTZ8b2cRUCrB61
        4FDl9m/iqBNVOr5IkWV2K85aFbw5cwVr8hahrv3smJ60x8AR4G+hmrWIp1CQTLpM
        3w6RycdHc2uZjDZXGR5XemzDl7lYqfhYVvwDENYsNkDN0hardCei9lfVrv+Oyqfp
        k9CJG6XbJCu4VOZbKpaW5UgSf+8EUw/dW82oH0SWoDF0pwtifXuUZz/QKwfFRqCi
        L2AbLAJKhFOqrjx0U6nmij7ihR+8eqaXMubeGumDTRBvIYeWZP4JKQGKawbiWaUf
        mvO0n2ZCwHkqjp2CfKfqzYWDxx88AwcIDKw==
X-ME-Sender: <xms:i_K5YsnU2K0hf72eRh6cuU4-AnBowEieiAjsKii0Es_Yshj7A-V2Iw>
    <xme:i_K5Yr1LwZOocD-WYVuKxyZiFLHGWPQ0FslH-YNiXd3aFN86eBLeRBH0ux97HFug2
    gHCb_Xb-boRZZc>
X-ME-Received: <xmr:i_K5Yqpl9UI09Bx4w4u3XdXOUMfHEOi0ecGcxgIaYjN5qLwk-1pE36jLT20jIP_lJdeJncBUNn-q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeghedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffvghmihcu
    ofgrrhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgsh
    hlrggsrdgtohhmqeenucggtffrrghtthgvrhhnpeeiudeggfelhfeludeuffeifeegleef
    vdehvdduvdeiteefteekueeuuefhteeileenucffohhmrghinhepghhithhhuhgsrdgtoh
    hmpdhkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpeguvghmihesihhnvhhishhisghlvghthhhinhhgshhlrggsrdgtoh
    hm
X-ME-Proxy: <xmx:i_K5YolxbmX71E8kDT9-FD2a8BmY_AOl5OXe_lYWMbTiHTpEqdClrA>
    <xmx:i_K5Yq0xlx6S9tIvKkxFR_qOXg7ZmhGWIv1knEPnmPLY35ZE27Nt0g>
    <xmx:i_K5YvswZC9ZrFvlVavnPzupBajC2LYFtZa38RheCMfWktOzCoOuDw>
    <xmx:i_K5Yv_E5EYyEsCPPcug7VSSTGyj3dafMGc0AUxv1_acNAAJlzQ06g>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Jun 2022 14:10:18 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>,
        Juergen Gross <jgross@suse.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>
Subject: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
Date:   Mon, 27 Jun 2022 14:10:02 -0400
Message-Id: <20220627181006.1954-1-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.35.3
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
 drivers/xen/gntdev-common.h |   7 ++
 drivers/xen/gntdev.c        | 142 +++++++++++++++++++++++++-----------
 2 files changed, 106 insertions(+), 43 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 20d7d059dadb..40ef379c28ab 100644
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
 
@@ -73,6 +75,11 @@ struct gntdev_grant_map {
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
index 54778aadf618..a631a453eb57 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -35,6 +35,7 @@
 #include <linux/slab.h>
 #include <linux/highmem.h>
 #include <linux/refcount.h>
+#include <linux/workqueue.h>
 
 #include <xen/xen.h>
 #include <xen/grant_table.h>
@@ -60,10 +61,11 @@ module_param(limit, uint, 0644);
 MODULE_PARM_DESC(limit,
 	"Maximum number of grants that may be mapped by one mapping request");
 
+/* True in PV mode, false otherwise */
 static int use_ptemod;
 
-static int unmap_grant_pages(struct gntdev_grant_map *map,
-			     int offset, int pages);
+static void unmap_grant_pages(struct gntdev_grant_map *map,
+			      int offset, int pages);
 
 static struct miscdevice gntdev_miscdev;
 
@@ -120,6 +122,7 @@ static void gntdev_free_map(struct gntdev_grant_map *map)
 	kvfree(map->unmap_ops);
 	kvfree(map->kmap_ops);
 	kvfree(map->kunmap_ops);
+	kvfree(map->being_removed);
 	kfree(map);
 }
 
@@ -140,12 +143,13 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
 	add->kunmap_ops = kvcalloc(count,
 				   sizeof(add->kunmap_ops[0]), GFP_KERNEL);
 	add->pages     = kvcalloc(count, sizeof(add->pages[0]), GFP_KERNEL);
+	add->being_removed =
+		kvcalloc(count, sizeof(add->being_removed[0]), GFP_KERNEL);
 	if (NULL == add->grants    ||
-	    NULL == add->map_ops   ||
-	    NULL == add->unmap_ops ||
 	    NULL == add->kmap_ops  ||
 	    NULL == add->kunmap_ops ||
-	    NULL == add->pages)
+	    NULL == add->pages     ||
+	    NULL == add->being_removed)
 		goto err;
 
 #ifdef CONFIG_XEN_GRANT_DMA_ALLOC
@@ -240,9 +244,36 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
-	if (map->pages && !use_ptemod)
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
 		unmap_grant_pages(map, 0, map->count);
 
+		/* Check if the memory now needs to be freed */
+		if (!refcount_dec_and_test(&map->users))
+			return;
+
+		/*
+		 * All pages have been returned to the hypervisor, so free the
+		 * map.
+		 */
+	}
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -288,6 +319,7 @@ static int set_grant_ptes_as_special(pte_t *pte, unsigned long addr, void *data)
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -336,87 +368,109 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
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
@@ -468,7 +522,6 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -489,10 +542,9 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
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
@@ -980,6 +1032,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	if (use_ptemod && map->vma)
 		goto unlock_out;
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
