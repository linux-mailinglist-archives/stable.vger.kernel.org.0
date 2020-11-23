Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B71552C0278
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 10:46:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbgKWJqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 04:46:24 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:53879 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726618AbgKWJqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 04:46:24 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 4329DEA1;
        Mon, 23 Nov 2020 04:46:23 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 23 Nov 2020 04:46:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=5c5pEM
        rzMN6JD4C5RfLP6iVB4ub9nxtdUuBbBgfJ+ec=; b=SpluWMnxv+mQv55ZLQofE5
        Xm5pJ5xQyKgp9j8MZxd9LCPkVMaJhjx9qHNaxbE/ZBcv+pHMbR6URjT8NE/qgdjF
        Awh3NtC73KA+6oWT1dnZUB7LYCTaz1RR9UeD/C4cU0ocb79EqCuXm7DY9VoyAR3s
        KE13wfhb+f4Fv+SRb5oeHk57GKM49BiKETwfnzb1UIgvYzneRXr5crubhahcRjWy
        dbLYR9jGnfoq/0jGcHr2psbUpcVMcieKMaWE9mpnOH+/cjaJfYIb4v9reVpxXY11
        flN5iLx4JkJf4XW/UcPFC8m6c4AD4vRotRLOR5OHxq4KoxfwN3R3wHGldHmQvzwA
        ==
X-ME-Sender: <xms:7oS7XwS7NPWTYozj8_08ya4eHWHWrOGzm5qsSufEmCj0jqgzLmbnbg>
    <xme:7oS7X9xUH-8FXYNQSY1YchaJ5v7tyjny6NxtoUWb7MfUb592T9wFkQRFn-67Wr7GB
    IFMidYmw6Sjjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:7oS7X90hxfCfC-MxjxXZgfawjCJotw653722j2u_FK4poOS3nk3Obw>
    <xmx:7oS7X0Bl-8IQ1r91gvSDuYbp57YoAyFviIRCrUZcV_23Xx9qwveDSA>
    <xmx:7oS7X5hgRfVM4uTYv-YNnyll8hIDrfc2njsfLAcp0a1GL_cBJVgVOQ>
    <xmx:7oS7X5d6mdn643ABjGr0XqQf5O1ZAKkaqPlDZoRzGz1vJ1lugisL3OksfbI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7CF0D3280059;
        Mon, 23 Nov 2020 04:46:22 -0500 (EST)
Subject: FAILED: patch "[PATCH] mm/userfaultfd: do not access vma->vm_mm after calling" failed to apply to 4.9-stable tree
To:     gerald.schaefer@linux.ibm.com, aarcange@redhat.com,
        akpm@linux-foundation.org, egorenar@linux.ibm.com,
        hca@linux.ibm.com, stable@vger.kernel.org,
        torvalds@linux-foundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 23 Nov 2020 10:47:33 +0100
Message-ID: <1606124853158191@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From bfe8cc1db02ab243c62780f17fc57f65bde0afe1 Mon Sep 17 00:00:00 2001
From: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Date: Sat, 21 Nov 2020 22:17:15 -0800
Subject: [PATCH] mm/userfaultfd: do not access vma->vm_mm after calling
 handle_userfault()

Alexander reported a syzkaller / KASAN finding on s390, see below for
complete output.

In do_huge_pmd_anonymous_page(), the pre-allocated pagetable will be
freed in some cases.  In the case of userfaultfd_missing(), this will
happen after calling handle_userfault(), which might have released the
mmap_lock.  Therefore, the following pte_free(vma->vm_mm, pgtable) will
access an unstable vma->vm_mm, which could have been freed or re-used
already.

For all architectures other than s390 this will go w/o any negative
impact, because pte_free() simply frees the page and ignores the
passed-in mm.  The implementation for SPARC32 would also access
mm->page_table_lock for pte_free(), but there is no THP support in
SPARC32, so the buggy code path will not be used there.

For s390, the mm->context.pgtable_list is being used to maintain the 2K
pagetable fragments, and operating on an already freed or even re-used
mm could result in various more or less subtle bugs due to list /
pagetable corruption.

Fix this by calling pte_free() before handle_userfault(), similar to how
it is already done in __do_huge_pmd_anonymous_page() for the WRITE /
non-huge_zero_page case.

Commit 6b251fc96cf2c ("userfaultfd: call handle_userfault() for
userfaultfd_missing() faults") actually introduced both, the
do_huge_pmd_anonymous_page() and also __do_huge_pmd_anonymous_page()
changes wrt to calling handle_userfault(), but only in the latter case
it put the pte_free() before calling handle_userfault().

  BUG: KASAN: use-after-free in do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
  Read of size 8 at addr 00000000962d6988 by task syz-executor.0/9334

  CPU: 1 PID: 9334 Comm: syz-executor.0 Not tainted 5.10.0-rc1-syzkaller-07083-g4c9720875573 #0
  Hardware name: IBM 3906 M04 701 (KVM/Linux)
  Call Trace:
    do_huge_pmd_anonymous_page+0xcda/0xd90 mm/huge_memory.c:744
    create_huge_pmd mm/memory.c:4256 [inline]
    __handle_mm_fault+0xe6e/0x1068 mm/memory.c:4480
    handle_mm_fault+0x288/0x748 mm/memory.c:4607
    do_exception+0x394/0xae0 arch/s390/mm/fault.c:479
    do_dat_exception+0x34/0x80 arch/s390/mm/fault.c:567
    pgm_check_handler+0x1da/0x22c arch/s390/kernel/entry.S:706
    copy_from_user_mvcos arch/s390/lib/uaccess.c:111 [inline]
    raw_copy_from_user+0x3a/0x88 arch/s390/lib/uaccess.c:174
    _copy_from_user+0x48/0xa8 lib/usercopy.c:16
    copy_from_user include/linux/uaccess.h:192 [inline]
    __do_sys_sigaltstack kernel/signal.c:4064 [inline]
    __s390x_sys_sigaltstack+0xc8/0x240 kernel/signal.c:4060
    system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

  Allocated by task 9334:
    slab_alloc_node mm/slub.c:2891 [inline]
    slab_alloc mm/slub.c:2899 [inline]
    kmem_cache_alloc+0x118/0x348 mm/slub.c:2904
    vm_area_dup+0x9c/0x2b8 kernel/fork.c:356
    __split_vma+0xba/0x560 mm/mmap.c:2742
    split_vma+0xca/0x108 mm/mmap.c:2800
    mlock_fixup+0x4ae/0x600 mm/mlock.c:550
    apply_vma_lock_flags+0x2c6/0x398 mm/mlock.c:619
    do_mlock+0x1aa/0x718 mm/mlock.c:711
    __do_sys_mlock2 mm/mlock.c:738 [inline]
    __s390x_sys_mlock2+0x86/0xa8 mm/mlock.c:728
    system_call+0xe0/0x28c arch/s390/kernel/entry.S:415

  Freed by task 9333:
    slab_free mm/slub.c:3142 [inline]
    kmem_cache_free+0x7c/0x4b8 mm/slub.c:3158
    __vma_adjust+0x7b2/0x2508 mm/mmap.c:960
    vma_merge+0x87e/0xce0 mm/mmap.c:1209
    userfaultfd_release+0x412/0x6b8 fs/userfaultfd.c:868
    __fput+0x22c/0x7a8 fs/file_table.c:281
    task_work_run+0x200/0x320 kernel/task_work.c:151
    tracehook_notify_resume include/linux/tracehook.h:188 [inline]
    do_notify_resume+0x100/0x148 arch/s390/kernel/signal.c:538
    system_call+0xe6/0x28c arch/s390/kernel/entry.S:416

  The buggy address belongs to the object at 00000000962d6948 which belongs to the cache vm_area_struct of size 200
  The buggy address is located 64 bytes inside of 200-byte region [00000000962d6948, 00000000962d6a10)
  The buggy address belongs to the page: page:00000000313a09fe refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x962d6 flags: 0x3ffff00000000200(slab)
  raw: 3ffff00000000200 000040000257e080 0000000c0000000c 000000008020ba00
  raw: 0000000000000000 000f001e00000000 ffffffff00000001 0000000096959501
  page dumped because: kasan: bad access detected
  page->mem_cgroup:0000000096959501

  Memory state around the buggy address:
   00000000962d6880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
   00000000962d6900: 00 fc fc fc fc fc fc fc fc fa fb fb fb fb fb fb
  >00000000962d6980: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                        ^
   00000000962d6a00: fb fb fc fc fc fc fc fc fc fc 00 00 00 00 00 00
   00000000962d6a80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  ==================================================================

Fixes: 6b251fc96cf2c ("userfaultfd: call handle_userfault() for userfaultfd_missing() faults")
Reported-by: Alexander Egorenkov <egorenar@linux.ibm.com>
Signed-off-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: <stable@vger.kernel.org>	[4.3+]
Link: https://lkml.kernel.org/r/20201110190329.11920-1-gerald.schaefer@linux.ibm.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9474dbc150ed..ec2bb93f7431 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -710,7 +710,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 			transparent_hugepage_use_zero_page()) {
 		pgtable_t pgtable;
 		struct page *zero_page;
-		bool set;
 		vm_fault_t ret;
 		pgtable = pte_alloc_one(vma->vm_mm);
 		if (unlikely(!pgtable))
@@ -723,25 +722,25 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
 		}
 		vmf->ptl = pmd_lock(vma->vm_mm, vmf->pmd);
 		ret = 0;
-		set = false;
 		if (pmd_none(*vmf->pmd)) {
 			ret = check_stable_address_space(vma->vm_mm);
 			if (ret) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 			} else if (userfaultfd_missing(vma)) {
 				spin_unlock(vmf->ptl);
+				pte_free(vma->vm_mm, pgtable);
 				ret = handle_userfault(vmf, VM_UFFD_MISSING);
 				VM_BUG_ON(ret & VM_FAULT_FALLBACK);
 			} else {
 				set_huge_zero_page(pgtable, vma->vm_mm, vma,
 						   haddr, vmf->pmd, zero_page);
 				spin_unlock(vmf->ptl);
-				set = true;
 			}
-		} else
+		} else {
 			spin_unlock(vmf->ptl);
-		if (!set)
 			pte_free(vma->vm_mm, pgtable);
+		}
 		return ret;
 	}
 	gfp = alloc_hugepage_direct_gfpmask(vma);

