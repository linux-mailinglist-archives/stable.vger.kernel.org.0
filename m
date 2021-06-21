Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1283AE9AD
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 15:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFUNHc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 09:07:32 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:59445 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229949AbhFUNHb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Jun 2021 09:07:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7407F1940319;
        Mon, 21 Jun 2021 09:05:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 21 Jun 2021 09:05:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=szIRBr
        JEtCQC6yhz2fJw5RXclGlVoDCNLAtxEMoTI6E=; b=M2u/98ip+sI5HdawKDPuGu
        jImaPHA08Ki6ZyIWigv6rZ3E03IERPzWL4rOZSdzzsUoD6LG47YdYnmTI697s4jK
        ct0yzXE4flx1Q4q6IPA0BlJCtrKKuNmb8y+DzRS/wfBtj6U6/dr5ggviJP8sqIVw
        cEIT4sgl3ZQvNtPTKLznxAORqxE/2TQMxjYdcBZ5n3bBIpE3YkkMWGip7Ve294RW
        2PHOoXOm3Y53NQcEvgUsMbCCaDC7MpMh9EwgV7KnYQLwOQznwXxDHcAqLjb2k1Lj
        BAX3Z03Y6FaD7A6lRdKAg+bV5ZAjK0Ulu0n2CgNe0CYE/qtGgc6lHcMTD7e3HpJA
        ==
X-ME-Sender: <xms:jI7QYO_QoN80X7c0a1zAGj8ihnorpeXWtQ_G2EWHo7Irw0gBJZ_0hw>
    <xme:jI7QYOvLedn0k127Vl6-Duj95TOjlB5CN_fYzeWRTgPLLffcxl4959y5eYUBLT8Gi
    SQnc66KmsgSbw>
X-ME-Received: <xmr:jI7QYEBNFcRQ2RA0OtdPmITS_BIQ5KjWL8Aub_g-JIpQjegMJ_oTEQhl6XKbVIOwN56F7dhpnVbmkgwVLBWml4tuw7JEgEWm>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeefledgheelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:jI7QYGfQXJz0m7qKh52gHDd3PIR5UKbWPjI-UdlD9sQkwrQbVD4HFA>
    <xmx:jI7QYDMK-aPtrNjDL_5NJ3XFNiI5DTeX1rwVoy6WzObWCewXv2R1wA>
    <xmx:jI7QYAnGHbIwvggMwzhkVtgyWCRZUf0uWwgoHE9wVEJpHfIEBpVPww>
    <xmx:jI7QYOrY8pgCGoFeszo5XXDWNyER7U8gY6uk8_buR0RrvMfS2XsTizym7uw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 21 Jun 2021 09:05:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mm/hugetlb: expand restore_reserve_on_error functionality" failed to apply to 5.10-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org,
        almasrymina@google.com, axelrasmussen@google.com, mhocko@suse.com,
        naoya.horiguchi@nec.com, peterx@redhat.com,
        songmuchun@bytedance.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 21 Jun 2021 15:05:03 +0200
Message-ID: <162428070350111@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 846be08578edb81f02bc8534577e6c367ef34f41 Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Tue, 15 Jun 2021 18:23:29 -0700
Subject: [PATCH] mm/hugetlb: expand restore_reserve_on_error functionality

The routine restore_reserve_on_error is called to restore reservation
information when an error occurs after page allocation.  The routine
alloc_huge_page modifies the mapping reserve map and potentially the
reserve count during allocation.  If code calling alloc_huge_page
encounters an error after allocation and needs to free the page, the
reservation information needs to be adjusted.

Currently, restore_reserve_on_error only takes action on pages for which
the reserve count was adjusted(HPageRestoreReserve flag).  There is
nothing wrong with these adjustments.  However, alloc_huge_page ALWAYS
modifies the reserve map during allocation even if the reserve count is
not adjusted.  This can cause issues as observed during development of
this patch [1].

One specific series of operations causing an issue is:

 - Create a shared hugetlb mapping
   Reservations for all pages created by default

 - Fault in a page in the mapping
   Reservation exists so reservation count is decremented

 - Punch a hole in the file/mapping at index previously faulted
   Reservation and any associated pages will be removed

 - Allocate a page to fill the hole
   No reservation entry, so reserve count unmodified
   Reservation entry added to map by alloc_huge_page

 - Error after allocation and before instantiating the page
   Reservation entry remains in map

 - Allocate a page to fill the hole
   Reservation entry exists, so decrement reservation count

This will cause a reservation count underflow as the reservation count
was decremented twice for the same index.

A user would observe a very large number for HugePages_Rsvd in
/proc/meminfo.  This would also likely cause subsequent allocations of
hugetlb pages to fail as it would 'appear' that all pages are reserved.

This sequence of operations is unlikely to happen, however they were
easily reproduced and observed using hacked up code as described in [1].

Address the issue by having the routine restore_reserve_on_error take
action on pages where HPageRestoreReserve is not set.  In this case, we
need to remove any reserve map entry created by alloc_huge_page.  A new
helper routine vma_del_reservation assists with this operation.

There are three callers of alloc_huge_page which do not currently call
restore_reserve_on error before freeing a page on error paths.  Add
those missing calls.

[1] https://lore.kernel.org/linux-mm/20210528005029.88088-1-almasrymina@google.com/

Link: https://lkml.kernel.org/r/20210607204510.22617-1-mike.kravetz@oracle.com
Fixes: 96b96a96ddee ("mm/hugetlb: fix huge page reservation leak in private mapping error paths"
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 55efd3dd04f6..30dee68458c7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -735,6 +735,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		__SetPageUptodate(page);
 		error = huge_add_to_page_cache(page, mapping, index);
 		if (unlikely(error)) {
+			restore_reserve_on_error(h, &pseudo_vma, addr, page);
 			put_page(page);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			goto out;
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 790ae618548d..6504346a1947 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -610,6 +610,8 @@ struct page *alloc_huge_page_vma(struct hstate *h, struct vm_area_struct *vma,
 				unsigned long address);
 int huge_add_to_page_cache(struct page *page, struct address_space *mapping,
 			pgoff_t idx);
+void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
+				unsigned long address, struct page *page);
 
 /* arch callback */
 int __init __alloc_bootmem_huge_page(struct hstate *h);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 85f42ec1a927..e0a5f9cbbece 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2121,12 +2121,18 @@ static void return_unused_surplus_pages(struct hstate *h,
  * be restored when a newly allocated huge page must be freed.  It is
  * to be called after calling vma_needs_reservation to determine if a
  * reservation exists.
+ *
+ * vma_del_reservation is used in error paths where an entry in the reserve
+ * map was created during huge page allocation and must be removed.  It is to
+ * be called after calling vma_needs_reservation to determine if a reservation
+ * exists.
  */
 enum vma_resv_mode {
 	VMA_NEEDS_RESV,
 	VMA_COMMIT_RESV,
 	VMA_END_RESV,
 	VMA_ADD_RESV,
+	VMA_DEL_RESV,
 };
 static long __vma_reservation_common(struct hstate *h,
 				struct vm_area_struct *vma, unsigned long addr,
@@ -2170,11 +2176,21 @@ static long __vma_reservation_common(struct hstate *h,
 			ret = region_del(resv, idx, idx + 1);
 		}
 		break;
+	case VMA_DEL_RESV:
+		if (vma->vm_flags & VM_MAYSHARE) {
+			region_abort(resv, idx, idx + 1, 1);
+			ret = region_del(resv, idx, idx + 1);
+		} else {
+			ret = region_add(resv, idx, idx + 1, 1, NULL, NULL);
+			/* region_add calls of range 1 should never fail. */
+			VM_BUG_ON(ret < 0);
+		}
+		break;
 	default:
 		BUG();
 	}
 
-	if (vma->vm_flags & VM_MAYSHARE)
+	if (vma->vm_flags & VM_MAYSHARE || mode == VMA_DEL_RESV)
 		return ret;
 	/*
 	 * We know private mapping must have HPAGE_RESV_OWNER set.
@@ -2222,25 +2238,39 @@ static long vma_add_reservation(struct hstate *h,
 	return __vma_reservation_common(h, vma, addr, VMA_ADD_RESV);
 }
 
+static long vma_del_reservation(struct hstate *h,
+			struct vm_area_struct *vma, unsigned long addr)
+{
+	return __vma_reservation_common(h, vma, addr, VMA_DEL_RESV);
+}
+
 /*
- * This routine is called to restore a reservation on error paths.  In the
- * specific error paths, a huge page was allocated (via alloc_huge_page)
- * and is about to be freed.  If a reservation for the page existed,
- * alloc_huge_page would have consumed the reservation and set
- * HPageRestoreReserve in the newly allocated page.  When the page is freed
- * via free_huge_page, the global reservation count will be incremented if
- * HPageRestoreReserve is set.  However, free_huge_page can not adjust the
- * reserve map.  Adjust the reserve map here to be consistent with global
- * reserve count adjustments to be made by free_huge_page.
+ * This routine is called to restore reservation information on error paths.
+ * It should ONLY be called for pages allocated via alloc_huge_page(), and
+ * the hugetlb mutex should remain held when calling this routine.
+ *
+ * It handles two specific cases:
+ * 1) A reservation was in place and the page consumed the reservation.
+ *    HPageRestoreReserve is set in the page.
+ * 2) No reservation was in place for the page, so HPageRestoreReserve is
+ *    not set.  However, alloc_huge_page always updates the reserve map.
+ *
+ * In case 1, free_huge_page later in the error path will increment the
+ * global reserve count.  But, free_huge_page does not have enough context
+ * to adjust the reservation map.  This case deals primarily with private
+ * mappings.  Adjust the reserve map here to be consistent with global
+ * reserve count adjustments to be made by free_huge_page.  Make sure the
+ * reserve map indicates there is a reservation present.
+ *
+ * In case 2, simply undo reserve map modifications done by alloc_huge_page.
  */
-static void restore_reserve_on_error(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address,
-			struct page *page)
+void restore_reserve_on_error(struct hstate *h, struct vm_area_struct *vma,
+			unsigned long address, struct page *page)
 {
-	if (unlikely(HPageRestoreReserve(page))) {
-		long rc = vma_needs_reservation(h, vma, address);
+	long rc = vma_needs_reservation(h, vma, address);
 
-		if (unlikely(rc < 0)) {
+	if (HPageRestoreReserve(page)) {
+		if (unlikely(rc < 0))
 			/*
 			 * Rare out of memory condition in reserve map
 			 * manipulation.  Clear HPageRestoreReserve so that
@@ -2253,16 +2283,57 @@ static void restore_reserve_on_error(struct hstate *h,
 			 * accounting of reserve counts.
 			 */
 			ClearHPageRestoreReserve(page);
-		} else if (rc) {
-			rc = vma_add_reservation(h, vma, address);
-			if (unlikely(rc < 0))
+		else if (rc)
+			(void)vma_add_reservation(h, vma, address);
+		else
+			vma_end_reservation(h, vma, address);
+	} else {
+		if (!rc) {
+			/*
+			 * This indicates there is an entry in the reserve map
+			 * added by alloc_huge_page.  We know it was added
+			 * before the alloc_huge_page call, otherwise
+			 * HPageRestoreReserve would be set on the page.
+			 * Remove the entry so that a subsequent allocation
+			 * does not consume a reservation.
+			 */
+			rc = vma_del_reservation(h, vma, address);
+			if (rc < 0)
 				/*
-				 * See above comment about rare out of
-				 * memory condition.
+				 * VERY rare out of memory condition.  Since
+				 * we can not delete the entry, set
+				 * HPageRestoreReserve so that the reserve
+				 * count will be incremented when the page
+				 * is freed.  This reserve will be consumed
+				 * on a subsequent allocation.
 				 */
-				ClearHPageRestoreReserve(page);
+				SetHPageRestoreReserve(page);
+		} else if (rc < 0) {
+			/*
+			 * Rare out of memory condition from
+			 * vma_needs_reservation call.  Memory allocation is
+			 * only attempted if a new entry is needed.  Therefore,
+			 * this implies there is not an entry in the
+			 * reserve map.
+			 *
+			 * For shared mappings, no entry in the map indicates
+			 * no reservation.  We are done.
+			 */
+			if (!(vma->vm_flags & VM_MAYSHARE))
+				/*
+				 * For private mappings, no entry indicates
+				 * a reservation is present.  Since we can
+				 * not add an entry, set SetHPageRestoreReserve
+				 * on the page so reserve count will be
+				 * incremented when freed.  This reserve will
+				 * be consumed on a subsequent allocation.
+				 */
+				SetHPageRestoreReserve(page);
 		} else
-			vma_end_reservation(h, vma, address);
+			/*
+			 * No reservation present, do nothing
+			 */
+			 vma_end_reservation(h, vma, address);
 	}
 }
 
@@ -4037,6 +4108,8 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 				entry = huge_ptep_get(src_pte);
 				if (!pte_same(src_pte_old, entry)) {
+					restore_reserve_on_error(h, vma, addr,
+								new);
 					put_page(new);
 					/* dst_entry won't change as in child */
 					goto again;
@@ -5006,6 +5079,7 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 	if (vm_shared || is_continue)
 		unlock_page(page);
 out_release_nounlock:
+	restore_reserve_on_error(h, dst_vma, dst_addr, page);
 	put_page(page);
 	goto out;
 }

