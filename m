Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09E612898
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 08:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiJ3HN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 03:13:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiJ3HNX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 03:13:23 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F171026EE;
        Sun, 30 Oct 2022 00:13:21 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 6477E5C009A;
        Sun, 30 Oct 2022 03:13:21 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 30 Oct 2022 03:13:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        invisiblethingslab.com; h=cc:cc:content-transfer-encoding:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm3; t=
        1667114001; x=1667200401; bh=Mo8RRVU/BCqu317V/TpNAiSZ8pju9kQTzGf
        3AAdnqs4=; b=dfcMRjyrXKkQpQBS2ci3HT1FA9DjFGnBeJHxaHlC2YWMZyKXbcD
        u4gflN0UpK3yanFBNARtumJ2QSY4VUFaOqJqqcndU4OdfsVgXvUz8O12EJHpj3xN
        5YTs90DRWA0anrEVH6vRWr+mpzJ8KC0ieg+evYLhAwEkmt/tE16Jgnf8TQHmVB/M
        LpCZDu/wzaVHfLYuTX843kIMdVjOFYwRI+eCdgs1184yyqm+lTeyEFZse9IsQ+eC
        D1g9bXszG4JaO6eVP/2pr0Z2cXysBUDAkWcS3ZG5H8w1YN+9EVlnhH7EeiLiF7XA
        Kk2jc7BwrKsWeeWYBbeVmf+Ta6TF34a4mzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1667114001; x=1667200401; bh=Mo8RRVU/BCqu3
        17V/TpNAiSZ8pju9kQTzGf3AAdnqs4=; b=NvntkGDBdJs9WghcSChl7hqL8t+fR
        mSWTzvbiAn4NEPDaPwEz6hSPwP6o6byVOn5WN3RBfnqDwqHgbct9zVc8dyNmbPAP
        aZQBBSIrBKqwx/04AZe9KC8YBAseu+lUH9Ky526b6Mq3hJCsQYvJsHmlNvqpvYGd
        i+Mo5sotrWQfPAK2qDSQ2Ronm8DkUZ1iY4AvnAiRYfNLFOkxCwiqqUoXSpRU7tR0
        IAAuOTqlqC9oBPeHnMJyI8x5aRYS84zZioG5liJHF2lbyAwKyTF4HuG8gGjyuZzc
        a8ynS4nH2PsMw0FBZJfR+lpUYTDelfZS96M4eMdHvdcuFj3kbqKceObfg==
X-ME-Sender: <xms:ESReY3fmnVwL94JEkzhDwa65hRTPc2FaSdW87HTrTJV9efEEJ1DADg>
    <xme:ESReY9Mm9Dsm4FnNQTyM8B_qDv5jd7gJy1MOlOUPu043VCCULYJGK9UK0aHhPhhUs
    AsI8IzGJl9Y0o4>
X-ME-Received: <xmr:ESReYwhyup1UUjVCT3C5drltDC-tDoqHY2Jt0lXjdQRvwQz2QPzKG7R0U1nNCoVE0FvkFKOhs0mZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrtdelgdduudekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomhepffgvmhhi
    ucforghrihgvucfqsggvnhhouhhruceouggvmhhisehinhhvihhsihgslhgvthhhihhngh
    hslhgrsgdrtghomheqnecuggftrfgrthhtvghrnheptedtgeduleekleevjeehhfdvkefh
    veeuvdevtdduhffhvdeltdegtdfgkeduudegnecuffhomhgrihhnpehgihhthhhusgdrtg
    homhdpkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepuggvmhhisehinhhvihhsihgslhgvthhhihhnghhslhgrsgdrtg
    homh
X-ME-Proxy: <xmx:ESReY48pGf_ssKyBeNnYBMA2IrJa7vPuyIBPHzhkIT5niEWQu655hQ>
    <xmx:ESReYzvwJMdFOUzjAkTtidZ2I19TJKQwZyHjxYMNIdry76jBRiXuKA>
    <xmx:ESReY3Hn2RsQhwTur-d0KjuR2S2CjAgQOkIWie59HsGro6btMgwfmQ>
    <xmx:ESReY88LUcu9mvwZJ2Milelj5pQ2__0c3F7RVk4IsH-hmW04sjmx4Q>
Feedback-ID: iac594737:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Oct 2022 03:13:20 -0400 (EDT)
From:   Demi Marie Obenour <demi@invisiblethingslab.com>
To:     Juergen Gross <jgross@suse.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        =?UTF-8?q?Marek=20Marczykowski-G=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>
Cc:     "M. Vefa Bicakci" <m.v.b@runbox.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 3/3] xen/gntdev: Accommodate VMA splitting
Date:   Sun, 30 Oct 2022 03:12:43 -0400
Message-Id: <20221030071243.1580-4-demi@invisiblethingslab.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221030071243.1580-1-demi@invisiblethingslab.com>
References: <20221030071243.1580-1-demi@invisiblethingslab.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "M. Vefa Bicakci" <m.v.b@runbox.com>

Prior to this commit, the gntdev driver code did not handle the
following scenario correctly with paravirtualized (PV) Xen domains:

* User process sets up a gntdev mapping composed of two grant mappings
  (i.e., two pages shared by another Xen domain).
* User process munmap()s one of the pages.
* User process munmap()s the remaining page.
* User process exits.

In the scenario above, the user process would cause the kernel to log
the following messages in dmesg for the first munmap(), and the second
munmap() call would result in similar log messages:

  BUG: Bad page map in process doublemap.test  pte:... pmd:...
  page:0000000057c97bff refcount:1 mapcount:-1 \
    mapping:0000000000000000 index:0x0 pfn:...
  ...
  page dumped because: bad pte
  ...
  file:gntdev fault:0x0 mmap:gntdev_mmap [xen_gntdev] readpage:0x0
  ...
  Call Trace:
   <TASK>
   dump_stack_lvl+0x46/0x5e
   print_bad_pte.cold+0x66/0xb6
   unmap_page_range+0x7e5/0xdc0
   unmap_vmas+0x78/0xf0
   unmap_region+0xa8/0x110
   __do_munmap+0x1ea/0x4e0
   __vm_munmap+0x75/0x120
   __x64_sys_munmap+0x28/0x40
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x61/0xcb
   ...

For each munmap() call, the Xen hypervisor (if built with CONFIG_DEBUG)
would print out the following and trigger a general protection fault in
the affected Xen PV domain:

  (XEN) d0v... Attempt to implicitly unmap d0's grant PTE ...
  (XEN) d0v... Attempt to implicitly unmap d0's grant PTE ...

As of this writing, gntdev_grant_map structure's vma field (referred to
as map->vma below) is mainly used for checking the start and end
addresses of mappings. However, with split VMAs, these may change, and
there could be more than one VMA associated with a gntdev mapping.
Hence, remove the use of map->vma and rely on map->pages_vm_start for
the original start address and on (map->count << PAGE_SHIFT) for the
original mapping size. Let the invalidate() and find_special_page()
hooks use these.

Also, given that there can be multiple VMAs associated with a gntdev
mapping, move the "mmu_interval_notifier_remove(&map->notifier)" call to
the end of gntdev_put_map, so that the MMU notifier is only removed
after the closing of the last remaining VMA.

Finally, use an atomic to prevent inadvertent gntdev mapping re-use,
instead of using the map->live_grants atomic counter and/or the map->vma
pointer (the latter of which is now removed). This prevents the
userspace from mmap()'ing (with MAP_FIXED) a gntdev mapping over the
same address range as a previously set up gntdev mapping. This scenario
can be summarized with the following call-trace, which was valid prior
to this commit:

  mmap
    gntdev_mmap
  mmap (repeat mmap with MAP_FIXED over the same address range)
    gntdev_invalidate
      unmap_grant_pages (sets 'being_removed' entries to true)
        gnttab_unmap_refs_async
    unmap_single_vma
    gntdev_mmap (maps the shared pages again)
  munmap
    gntdev_invalidate
      unmap_grant_pages
        (no-op because 'being_removed' entries are true)
    unmap_single_vma (For PV domains, Xen reports that a granted page
      is being unmapped and triggers a general protection fault in the
      affected domain, if Xen was built with CONFIG_DEBUG)

The fix for this last scenario could be worth its own commit, but we
opted for a single commit, because removing the gntdev_grant_map
structure's vma field requires guarding the entry to gntdev_mmap(), and
the live_grants atomic counter is not sufficient on its own to prevent
the mmap() over a pre-existing mapping.

Link: https://github.com/QubesOS/qubes-issues/issues/7631
Fixes: ab31523c2fca ("xen/gntdev: allow usermode to map granted pages")
Cc: stable@vger.kernel.org
Signed-off-by: M. Vefa Bicakci <m.v.b@runbox.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://lore.kernel.org/r/20221002222006.2077-3-m.v.b@runbox.com
Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/xen/gntdev-common.h |  3 +-
 drivers/xen/gntdev.c        | 58 ++++++++++++++++---------------------
 2 files changed, 27 insertions(+), 34 deletions(-)

diff --git a/drivers/xen/gntdev-common.h b/drivers/xen/gntdev-common.h
index 40ef379c28ab01a3a11008cb0f85a1b3fde134ca..9c286b2a19001616ae0e9986be13905891b5f5ff 100644
--- a/drivers/xen/gntdev-common.h
+++ b/drivers/xen/gntdev-common.h
@@ -44,9 +44,10 @@ struct gntdev_unmap_notify {
 };
 
 struct gntdev_grant_map {
+	atomic_t in_use;
 	struct mmu_interval_notifier notifier;
+	bool notifier_init;
 	struct list_head next;
-	struct vm_area_struct *vma;
 	int index;
 	int count;
 	int flags;
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 62a65122c73fbfe673405ce90a53c5f364b75082..862de00cfe89209cf28f7e7e87cf325e40f1fc4b 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -276,6 +276,9 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 		 */
 	}
 
+	if (use_ptemod && map->notifier_init)
+		mmu_interval_notifier_remove(&map->notifier);
+
 	if (map->notify.flags & UNMAP_NOTIFY_SEND_EVENT) {
 		notify_remote_via_evtchn(map->notify.event);
 		evtchn_put(map->notify.event);
@@ -288,7 +291,7 @@ void gntdev_put_map(struct gntdev_priv *priv, struct gntdev_grant_map *map)
 static int find_grant_ptes(pte_t *pte, unsigned long addr, void *data)
 {
 	struct gntdev_grant_map *map = data;
-	unsigned int pgnr = (addr - map->vma->vm_start) >> PAGE_SHIFT;
+	unsigned int pgnr = (addr - map->pages_vm_start) >> PAGE_SHIFT;
 	int flags = map->flags | GNTMAP_application_map | GNTMAP_contains_pte;
 	u64 pte_maddr;
 
@@ -513,11 +516,7 @@ static void gntdev_vma_close(struct vm_area_struct *vma)
 	struct gntdev_priv *priv = file->private_data;
 
 	pr_debug("gntdev_vma_close %p\n", vma);
-	if (use_ptemod) {
-		WARN_ON(map->vma != vma);
-		mmu_interval_notifier_remove(&map->notifier);
-		map->vma = NULL;
-	}
+
 	vma->vm_private_data = NULL;
 	gntdev_put_map(priv, map);
 }
@@ -545,29 +544,30 @@ static bool gntdev_invalidate(struct mmu_interval_notifier *mn,
 	struct gntdev_grant_map *map =
 		container_of(mn, struct gntdev_grant_map, notifier);
 	unsigned long mstart, mend;
+	unsigned long map_start, map_end;
 
 	if (!mmu_notifier_range_blockable(range))
 		return false;
 
+	map_start = map->pages_vm_start;
+	map_end = map->pages_vm_start + (map->count << PAGE_SHIFT);
+
 	/*
 	 * If the VMA is split or otherwise changed the notifier is not
 	 * updated, but we don't want to process VA's outside the modified
 	 * VMA. FIXME: It would be much more understandable to just prevent
 	 * modifying the VMA in the first place.
 	 */
-	if (map->vma->vm_start >= range->end ||
-	    map->vma->vm_end <= range->start)
+	if (map_start >= range->end || map_end <= range->start)
 		return true;
 
-	mstart = max(range->start, map->vma->vm_start);
-	mend = min(range->end, map->vma->vm_end);
+	mstart = max(range->start, map_start);
+	mend = min(range->end, map_end);
 	pr_debug("map %d+%d (%lx %lx), range %lx %lx, mrange %lx %lx\n",
-			map->index, map->count,
-			map->vma->vm_start, map->vma->vm_end,
-			range->start, range->end, mstart, mend);
-	unmap_grant_pages(map,
-				(mstart - map->vma->vm_start) >> PAGE_SHIFT,
-				(mend - mstart) >> PAGE_SHIFT);
+		 map->index, map->count, map_start, map_end,
+		 range->start, range->end, mstart, mend);
+	unmap_grant_pages(map, (mstart - map_start) >> PAGE_SHIFT,
+			  (mend - mstart) >> PAGE_SHIFT);
 
 	return true;
 }
@@ -1047,18 +1047,15 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		return -EINVAL;
 
 	pr_debug("map %d+%d at %lx (pgoff %lx)\n",
-			index, count, vma->vm_start, vma->vm_pgoff);
+		 index, count, vma->vm_start, vma->vm_pgoff);
 
 	mutex_lock(&priv->lock);
 	map = gntdev_find_map_index(priv, index, count);
 	if (!map)
 		goto unlock_out;
-	if (use_ptemod && map->vma)
+	if (!atomic_add_unless(&map->in_use, 1, 1))
 		goto unlock_out;
-	if (atomic_read(&map->live_grants)) {
-		err = -EAGAIN;
-		goto unlock_out;
-	}
+
 	refcount_inc(&map->users);
 
 	vma->vm_ops = &gntdev_vmops;
@@ -1079,15 +1076,16 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 			map->flags |= GNTMAP_readonly;
 	}
 
+	map->pages_vm_start = vma->vm_start;
+
 	if (use_ptemod) {
-		map->vma = vma;
 		err = mmu_interval_notifier_insert_locked(
 			&map->notifier, vma->vm_mm, vma->vm_start,
 			vma->vm_end - vma->vm_start, &gntdev_mmu_ops);
-		if (err) {
-			map->vma = NULL;
+		if (err)
 			goto out_unlock_put;
-		}
+
+		map->notifier_init = true;
 	}
 	mutex_unlock(&priv->lock);
 
@@ -1104,7 +1102,6 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 		 */
 		mmu_interval_read_begin(&map->notifier);
 
-		map->pages_vm_start = vma->vm_start;
 		err = apply_to_page_range(vma->vm_mm, vma->vm_start,
 					  vma->vm_end - vma->vm_start,
 					  find_grant_ptes, map);
@@ -1150,13 +1147,8 @@ static int gntdev_mmap(struct file *flip, struct vm_area_struct *vma)
 out_unlock_put:
 	mutex_unlock(&priv->lock);
 out_put_map:
-	if (use_ptemod) {
+	if (use_ptemod)
 		unmap_grant_pages(map, 0, map->count);
-		if (map->vma) {
-			mmu_interval_notifier_remove(&map->notifier);
-			map->vma = NULL;
-		}
-	}
 	gntdev_put_map(priv, map);
 	return err;
 }
-- 
2.38.1
