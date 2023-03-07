Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAF0C6AE5F0
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 17:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231239AbjCGQHl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 11:07:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231255AbjCGQHR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 11:07:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68ADC907AE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 08:06:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D7A6B81920
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 16:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0A2C433D2;
        Tue,  7 Mar 2023 16:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678205161;
        bh=lvZDqm9vWBsUBHZI+3BFGKznCmjoearMYMncyC1Ukh0=;
        h=Subject:To:Cc:From:Date:From;
        b=MXPpPPF+y2GatUUP0BWoDk1XZhiAgGTlf9fwbuz9OaYP8heY+T0lx5W7UaBCvZx1L
         cAkyAT+CT4D5+Q0RT5DkQqumaQoRo7fGxJ+AnQaKS5+3Z2lc3Ut5/Tfh6zs7nuttwC
         mxUIuG1eXVat6QH6/yrOBv5fIv7M1ZiG7dTRtygw=
Subject: FAILED: patch "[PATCH] vfio/type1: prevent underflow of locked_vm via exec()" failed to apply to 4.19-stable tree
To:     steven.sistare@oracle.com, alex.williamson@redhat.com,
        jgg@nvidia.com, kevin.tian@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Mar 2023 17:05:53 +0100
Message-ID: <167820515320650@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-4.19.y
git checkout FETCH_HEAD
git cherry-pick -x 046eca5018f8a5dd1dc2cedf87fb5843b9ea3026
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '167820515320650@kroah.com' --subject-prefix 'PATCH 4.19.y' HEAD^..

Possible dependencies:

046eca5018f8 ("vfio/type1: prevent underflow of locked_vm via exec()")
4ab4fcfce5b5 ("vfio/type1: fix vaddr_get_pfns() return in vfio_pin_page_external()")
4b6c33b32296 ("vfio/type1: Prepare for batched pinning with struct vfio_batch")
be16c1fd99f4 ("vfio/type1: Change success value of vaddr_get_pfn()")
aae7a75a821a ("vfio/type1: Add proper error unwind for vfio_iommu_replay()")
64019a2e467a ("mm/gup: remove task_struct pointer for all gup code")
bce617edecad ("mm: do page fault accounting in handle_mm_fault")
ed03d924587e ("mm/gup: use a standard migration target allocation callback")
bbe88753bd42 ("mm/hugetlb: make hugetlb migration callback CMA aware")
41b4dc14ee80 ("mm/gup: restrict CMA region by using allocation scope API")
19fc7bed252c ("mm/migrate: introduce a standard migration target allocation function")
d92bbc2719bd ("mm/hugetlb: unify migration callbacks")
b4b382238ed2 ("mm/migrate: move migration helper from .h to .c")
c7073bab5772 ("mm/page_isolation: prefer the node of the source page")
3e4e28c5a8f0 ("mmap locking API: convert mmap_sem API comments")
d8ed45c5dcd4 ("mmap locking API: use coccinelle to convert mmap_sem rwsem call sites")
ca5999fde0a1 ("mm: introduce include/linux/pgtable.h")
420c2091b65a ("mm/gup: introduce pin_user_pages_locked()")
5a36f0f3f518 ("Merge tag 'vfio-v5.8-rc1' of git://github.com/awilliam/linux-vfio")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 046eca5018f8a5dd1dc2cedf87fb5843b9ea3026 Mon Sep 17 00:00:00 2001
From: Steve Sistare <steven.sistare@oracle.com>
Date: Tue, 31 Jan 2023 08:58:04 -0800
Subject: [PATCH] vfio/type1: prevent underflow of locked_vm via exec()

When a vfio container is preserved across exec, the task does not change,
but it gets a new mm with locked_vm=0, and loses the count from existing
dma mappings.  If the user later unmaps a dma mapping, locked_vm underflows
to a large unsigned value, and a subsequent dma map request fails with
ENOMEM in __account_locked_vm.

To avoid underflow, grab and save the mm at the time a dma is mapped.
Use that mm when adjusting locked_vm, rather than re-acquiring the saved
task's mm, which may have changed.  If the saved mm is dead, do nothing.

locked_vm is incremented for existing mappings in a subsequent patch.

Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Steve Sistare <steven.sistare@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/1675184289-267876-3-git-send-email-steven.sistare@oracle.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 144f5bb20fb8..6b757d035457 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -420,8 +421,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
+	mm = dma->mm;
+	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
@@ -794,8 +795,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
@@ -805,7 +806,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vfio_lock_acct(dma, 1, false);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -1180,6 +1181,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1664,29 +1666,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 * against the locked memory limit and we need to be able to do both
 	 * outside of this call path as pinning can be asynchronous via the
 	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires a
-	 * task_struct and VM locked pages requires an mm_struct, however
-	 * holding an indefinite mm reference is not recommended, therefore we
-	 * only hold a reference to a task.  We could hold a reference to
-	 * current, however QEMU uses this call path through vCPU threads,
-	 * which can be killed resulting in a NULL mm and failure in the unmap
-	 * path when called via a different thread.  Avoid this problem by
-	 * using the group_leader as threads within the same group require
-	 * both CLONE_THREAD and CLONE_VM and will therefore use the same
-	 * mm_struct.
-	 *
-	 * Previously we also used the task for testing CAP_IPC_LOCK at the
-	 * time of pinning and accounting, however has_capability() makes use
-	 * of real_cred, a copy-on-write field, so we can't guarantee that it
-	 * matches group_leader, or in fact that it might not change by the
-	 * time it's evaluated.  If a process were to call MAP_DMA with
-	 * CAP_IPC_LOCK but later drop it, it doesn't make sense that they
-	 * possibly see different results for an iommu_mapped vfio_dma vs
-	 * externally mapped.  Therefore track CAP_IPC_LOCK in vfio_dma at the
-	 * time of calling MAP_DMA.
+	 * task_struct. Save the group_leader so that all DMA tracking uses
+	 * the same task, to make debugging easier.  VM locked pages requires
+	 * an mm_struct, so grab the mm in case the task dies.
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = current->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
@@ -3122,9 +3110,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
-
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -EPERM;
 
 	if (kthread)

