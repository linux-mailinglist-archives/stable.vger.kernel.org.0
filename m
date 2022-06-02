Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A036953C119
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 00:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239834AbiFBWyR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 18:54:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239131AbiFBWyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 18:54:15 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2242A258;
        Thu,  2 Jun 2022 15:54:13 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 441855C023B;
        Thu,  2 Jun 2022 18:54:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 02 Jun 2022 18:54:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:message-id:mime-version:reply-to
        :sender:subject:subject:to:to; s=fm1; t=1654210450; x=
        1654296850; bh=MRGhsRZXeF/lnjLM/zzVqIm8xqV/+/8mPjK0qPm3CQw=; b=a
        g/TBKdA2UctNTjQ2euW+1J0DMxccU/toTBCoeCdlhI4E7r3RYs9O2QdO+D8umFiW
        /RbbgXwj+zE/X2GQjqJcdBH3Uaagp+TdrzdWMFCpFyYkE1LOwi6I3QiKc032e0IB
        DQv3huQlFPNw/gaiTLps3EDrIo0njdhdRvYDvkdo8dkZ8CMNhhmVpVj+Khf/Ad7h
        kzfrVP+hkF8H/xq/b5HGlqkP51y5V6+SLSMVYyzi8G/frNDExqjVpHuFaiRcakP8
        Ag8bjhkkCmKVuKcW34F9NP8sF8LsXrB5Ao4jqdefVm0wBcP5u1r5TMShHm0TSW/Z
        D05iKLQY1+Q9oMatsbFZA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1654210450; x=1654296850; bh=MRGhsRZXeF/lnjLM/zzVqIm8xqV/+/8mPjK
        0qPm3CQw=; b=LSEv6Dzkf7oNE3OFW6NUYG5sj1K0v2Nof3qim1YszUBX2kzpAN6
        GrjKm4Q44hQlTBqIBXmSSsFKycO3Wg9QeT5vU6TV20Q6jpsMBl+typg6xLgu5pK1
        A3weZcN/I56JRDzohGjfhL7szuog9qYAhjj25uYEiRA+5osgLDq2c/8HJKejmbNF
        mqf6X0foCRqgVIIZkT0QpKmkFpUU2OBG9wzNFTwqbzxR1c8QcsP3FNU+aMC48gmA
        L0dysPLKpQtjwyhV/EgzB6xdjGclxYbx8RdIPhk+0RCOVNeZfejPdK0mjUohd7dT
        BoGqqlnYwUBvIbR1W80HH1en/Z3xAfhmg0w==
X-ME-Sender: <xms:kT-ZYlRdfjIC7-XofoF2xBY_hsZHnGC2n7uNZpInUw3Sz7rmfAj-hg>
    <xme:kT-ZYuxQDTGQrVuj3ZzS8TEyWxfwyK35TmVwE5ltx2zvae9-CMymDkCaCpriSYP_K
    mcJnFYsGNPqkgg>
X-ME-Received: <xmr:kT-ZYq3UTxLN5_I0Li-aifoDPxW9nGyHNdB41TXdwLxiEeDzD4GDn8MRY6qRnopppEnXWddPGKcc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrleehgddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvfevufffkffoggfgsedtkeertdertddtnecuhfhrohhmpeffvghmihcuofgr
    rhhivgcuqfgsvghnohhurhcuoeguvghmihesihhnvhhishhisghlvghthhhinhhgshhlrg
    gsrdgtohhmqeenucggtffrrghtthgvrhhnpeeijeegudefueekieejudekgfeukedvgeei
    tddufefhtdffheffueevfedvgfelgfenucffohhmrghinhepghhithhhuhgsrdgtohhmne
    cuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepuggvmhhi
    sehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomh
X-ME-Proxy: <xmx:kT-ZYtBncN_-y1LVql4CO2Y8pBXTIAtzBPnJrUD4SRVA-U4T-w_biQ>
    <xmx:kT-ZYujXJHC4G6j22lIjPGNhp-5uOmRHMcrYxOuAikhvYIuBqGZ8KA>
    <xmx:kT-ZYhr6cJRXZQ6hXFusYsJ7RBqItRky7sxhpBijcc3czqqwdeMLdg>
    <xmx:kj-ZYgZQ9EeyEAcPpxWUWz8WbhjJ0Acu3-LM4wkJLHjfY8FMnjV8kw>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 2 Jun 2022 18:54:09 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Jennifer Herbert <jennifer.herbert@citrix.com>
Cc:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v3] xen/gntdev: Avoid blocking in unmap_grant_pages()
Date:   Thu,  2 Jun 2022 18:53:52 -0400
Message-Id: <20220602225352.3201-1-demi@invisiblethingslab.com>
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
---
 drivers/xen/gntdev-common.h |   7 ++
 drivers/xen/gntdev.c        | 153 ++++++++++++++++++++++++------------
 2 files changed, 109 insertions(+), 51 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 20d7d059dadb..15c2e3afcc2b 100644
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
+	atomic_long_t live_grants;
+	/* Needed to avoid allocation in __unmap_grant_pages */
+	struct gntab_unmap_queue_data unmap_data;
 };
 
 struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 59ffea800079..e8b83ea1eacd 100644
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
 
@@ -140,10 +143,13 @@ struct gntdev_grant_map *gntdev_alloc_map(struct gntdev_priv *priv, int count,
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
@@ -250,9 +256,34 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 	if (!refcount_dec_and_test(&map->users))
 		return;
 
-	if (map->pages && !use_ptemod)
+	if (map->pages && !use_ptemod) {
+		/*
+		 * Increment the reference count.  This ensures that the
+		 * subsequent call to unmap_grant_pages() will not wind up
+		 * re-entering itself.  It *can* wind up calling
+		 * gntdev_put_map() recursively, but such calls will be with a
+		 * nonzero reference count, so they will return before this code
+		 * is reached.  The recursion depth is thus limited to 1.
+		 */
+		refcount_inc(&map->users);
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
+		 * map.  FIXME: this is far too complex.
+		 */
+	}
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -283,6 +314,7 @@ static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 
 int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 {
+	size_t alloced = 0;
 	int i, err = 0;
 
 	if (!use_ptemod) {
@@ -331,97 +363,114 @@ int gntdev_map_grant_pages(struct gntdev_grant_map *map)
 			map->count);
 
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
+			} else if (!err) {
+				/* FIXME: should this be a WARN()? */
 				err = -EINVAL;
+			}
 		}
 	}
+	atomic_long_add(alloced, &map->live_grants);
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
+	atomic_long_sub(data->count, &map->live_grants);
 
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
 {
-	int range, err = 0;
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
+{
+	int range;
+
+	if (atomic_long_read(&map->live_grants) == 0)
+		return; /* Nothing to do */
 
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
+		if (range)
+			__unmap_grant_pages(map, offset, range);
 		offset += range;
 		pages -= range;
 	}
-
-	return err;
 }
 
 /* ------------------------------------------------------------------ */
@@ -473,7 +522,6 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
-	int err;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
@@ -494,10 +542,9 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
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
@@ -985,6 +1032,10 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		goto unlock_out;
 	if (use_ptemod && map->vma)
 		goto unlock_out;
+	if (atomic_long_read(&map->live_grants)) {
+		err = -EAGAIN;
+		goto unlock_out;
+	}
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
-- 
Sincerely,
Demi Marie Obenour (she/her/hers)
Invisible Things Lab
