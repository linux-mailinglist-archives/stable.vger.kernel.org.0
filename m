Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0711E21A34
	for <lists+stable@lfdr.de>; Fri, 17 May 2019 17:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbfEQPAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 May 2019 11:00:18 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54841 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728968AbfEQPAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 May 2019 11:00:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 26F3037D;
        Fri, 17 May 2019 11:00:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 17 May 2019 11:00:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=afMHcv
        uKvHqXJQhrV2W++0fxKXGv+HcFeSVcCOgvUd0=; b=PrOXIKOrv6OEIhUoSsZ+lZ
        FThhkjAtMokGmL647c0to0rUzl9+YnUweGHYJ4CGfM00gazK9u8x0ua8wqaNT4+O
        IwgvxWm4YXSNK5MPQGpK9lLsYnU2gzdQhaEIbLL2FWD+hB9vKf0vXY6qPcKOXhSx
        gzBLIsT4KLkg7Oeg56U/DmJfFs5qubFupBzDlaQi5mc+yz57vnYRBsQ5tPNHL/3W
        T4iQGDmcz2gBC2dGIW/CZKN796ZkXfvHJUdWLncpN1i17CW1/ZSE9U2o5HODsVyt
        BFvmppzUC9fJurdRKJiDcW8YnzHpYnkhb6bkPORmZ2B5O8sks10X9AY/CFcPreiA
        ==
X-ME-Sender: <xms:gMzeXExEhcCxlcD0-kPWgjUOPG9ftOBeHi_ZDBAKRM1dgGVxDF_H4w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddtvddgkeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:gMzeXBD4Ui-cdUIP31aJsKoPMocLqIXIBLOy2JnB9bQmskF8Qqa2yQ>
    <xmx:gMzeXFAekYopTEssx6PfZiMJp2_JwIYXE5IotZtYCvLgGIyU-eNOhw>
    <xmx:gMzeXE5f4BSB-KxSVwMlSxh7v3kXGoXXoyd27i5oDKBNO6Rx20j5vg>
    <xmx:gMzeXLJavE_S9toQjq0HwkEDfya3QsHrMofF5WVTuZxRCfzAeVOG4w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0F27780069;
        Fri, 17 May 2019 11:00:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] hugetlb: use same fault hash key for shared and private" failed to apply to 4.4-stable tree
To:     mike.kravetz@oracle.com, akpm@linux-foundation.org, dbueso@suse.de,
        iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com,
        mhocko@kernel.org, n-horiguchi@ah.jp.nec.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 17 May 2019 17:00:05 +0200
Message-ID: <1558105205227215@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1b426bac66e6cc83c9f2d92b96e4e72acf43419a Mon Sep 17 00:00:00 2001
From: Mike Kravetz <mike.kravetz@oracle.com>
Date: Mon, 13 May 2019 17:19:41 -0700
Subject: [PATCH] hugetlb: use same fault hash key for shared and private
 mappings

hugetlb uses a fault mutex hash table to prevent page faults of the
same pages concurrently.  The key for shared and private mappings is
different.  Shared keys off address_space and file index.  Private keys
off mm and virtual address.  Consider a private mappings of a populated
hugetlbfs file.  A fault will map the page from the file and if needed
do a COW to map a writable page.

Hugetlbfs hole punch uses the fault mutex to prevent mappings of file
pages.  It uses the address_space file index key.  However, private
mappings will use a different key and could race with this code to map
the file page.  This causes problems (BUG) for the page cache remove
code as it expects the page to be unmapped.  A sample stack is:

page dumped because: VM_BUG_ON_PAGE(page_mapped(page))
kernel BUG at mm/filemap.c:169!
...
RIP: 0010:unaccount_page_cache_page+0x1b8/0x200
...
Call Trace:
__delete_from_page_cache+0x39/0x220
delete_from_page_cache+0x45/0x70
remove_inode_hugepages+0x13c/0x380
? __add_to_page_cache_locked+0x162/0x380
hugetlbfs_fallocate+0x403/0x540
? _cond_resched+0x15/0x30
? __inode_security_revalidate+0x5d/0x70
? selinux_file_permission+0x100/0x130
vfs_fallocate+0x13f/0x270
ksys_fallocate+0x3c/0x80
__x64_sys_fallocate+0x1a/0x20
do_syscall_64+0x5b/0x180
entry_SYSCALL_64_after_hwframe+0x44/0xa9

There seems to be another potential COW issue/race with this approach
of different private and shared keys as noted in commit 8382d914ebf7
("mm, hugetlb: improve page-fault scalability").

Since every hugetlb mapping (even anon and private) is actually a file
mapping, just use the address_space index key for all mappings.  This
results in potentially more hash collisions.  However, this should not
be the common case.

Link: http://lkml.kernel.org/r/20190328234704.27083-3-mike.kravetz@oracle.com
Link: http://lkml.kernel.org/r/20190412165235.t4sscoujczfhuiyt@linux-r8p5
Fixes: b5cec28d36f5 ("hugetlbfs: truncate_hugepages() takes a range of pages")
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index c74ef4426282..f23237135163 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -440,9 +440,7 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			u32 hash;
 
 			index = page->index;
-			hash = hugetlb_fault_mutex_hash(h, current->mm,
-							&pseudo_vma,
-							mapping, index, 0);
+			hash = hugetlb_fault_mutex_hash(h, mapping, index, 0);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 			/*
@@ -639,8 +637,7 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		addr = index * hpage_size;
 
 		/* mutex taken here, fault path and hole punch */
-		hash = hugetlb_fault_mutex_hash(h, mm, &pseudo_vma, mapping,
-						index, addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, index, addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		/* See if already present in mapping to avoid alloc/free */
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 11943b60f208..edf476c8cfb9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -123,9 +123,7 @@ void move_hugetlb_state(struct page *oldpage, struct page *newpage, int reason);
 void free_huge_page(struct page *page);
 void hugetlb_fix_reserve_counts(struct inode *inode);
 extern struct mutex *hugetlb_fault_mutex_table;
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-				struct vm_area_struct *vma,
-				struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 				pgoff_t idx, unsigned long address);
 
 pte_t *huge_pmd_share(struct mm_struct *mm, unsigned long addr, pud_t *pud);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c33c5cbb67ff..98a3c7c224cb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3824,8 +3824,7 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 			 * handling userfault.  Reacquire after handling
 			 * fault to make calling code simpler.
 			 */
-			hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping,
-							idx, haddr);
+			hash = hugetlb_fault_mutex_hash(h, mapping, idx, haddr);
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			ret = handle_userfault(&vmf, VM_UFFD_MISSING);
 			mutex_lock(&hugetlb_fault_mutex_table[hash]);
@@ -3933,21 +3932,14 @@ static vm_fault_t hugetlb_no_page(struct mm_struct *mm,
 }
 
 #ifdef CONFIG_SMP
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	unsigned long key[2];
 	u32 hash;
 
-	if (vma->vm_flags & VM_SHARED) {
-		key[0] = (unsigned long) mapping;
-		key[1] = idx;
-	} else {
-		key[0] = (unsigned long) mm;
-		key[1] = address >> huge_page_shift(h);
-	}
+	key[0] = (unsigned long) mapping;
+	key[1] = idx;
 
 	hash = jhash2((u32 *)&key, sizeof(key)/sizeof(u32), 0);
 
@@ -3958,9 +3950,7 @@ u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
  * For uniprocesor systems we always use a single mutex, so just
  * return 0 and avoid the hashing overhead.
  */
-u32 hugetlb_fault_mutex_hash(struct hstate *h, struct mm_struct *mm,
-			    struct vm_area_struct *vma,
-			    struct address_space *mapping,
+u32 hugetlb_fault_mutex_hash(struct hstate *h, struct address_space *mapping,
 			    pgoff_t idx, unsigned long address)
 {
 	return 0;
@@ -4005,7 +3995,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
 	 * get spurious allocation failures if two CPUs race to instantiate
 	 * the same page in the page cache.
 	 */
-	hash = hugetlb_fault_mutex_hash(h, mm, vma, mapping, idx, haddr);
+	hash = hugetlb_fault_mutex_hash(h, mapping, idx, haddr);
 	mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 	entry = huge_ptep_get(ptep);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d59b5a73dfb3..9932d5755e4c 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -271,8 +271,7 @@ static __always_inline ssize_t __mcopy_atomic_hugetlb(struct mm_struct *dst_mm,
 		 */
 		idx = linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
-		hash = hugetlb_fault_mutex_hash(h, dst_mm, dst_vma, mapping,
-								idx, dst_addr);
+		hash = hugetlb_fault_mutex_hash(h, mapping, idx, dst_addr);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
 
 		err = -ENOMEM;

