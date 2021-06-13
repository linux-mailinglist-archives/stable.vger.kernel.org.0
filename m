Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0283A5805
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 13:41:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFMLn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 07:43:57 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:49431 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMLn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 07:43:57 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 8BBD710CE;
        Sun, 13 Jun 2021 07:41:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 07:41:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=LVQByx
        rQHOsCUK9cz+gHS/NFH8tPYQYVUKijltOcrAA=; b=aR6Npmte+hyViRu/Ro/6EE
        OjUNsGclWJNuMkdeSpuSlG8RCbpK/ELa9l6sYjwc0Y9EH/XdAjTHp2aThii91Tyd
        NTupZXtrrPZ5PwZvFBoPUwA9VAmv32MeDW2Xfy81NM+sntw3lo/ACTDot4xk2dk1
        1gchbOykhwPc26HCbIL2UchiJUWLTVCh/fgrGDhdYKy3XSYYNZzz0oILRzo5R7ei
        Prkc+lAhcpJyYg4/qWPOit7pNSWJapk9irUNwS9tReIyA44xrXfaax5sLmjdCQfX
        aBg1xY5FZpu7ml16WVSOWfJ19eMJnXkjiTz1e7PIxMXRblqMqyDF+b9gAV7S9r3g
        ==
X-ME-Sender: <xms:A-_FYHC_nYmSz8mvcqh18Uu_nurfoSY0sPWGK_bx6u34Lpcr8TBAwA>
    <xme:A-_FYNg-XzWju7nDBS0Uz4odx8gVWPnZ3DZfceFJqbd0c3-Fpk567E3h65iovDHG7
    cceeRin2Q2DIw>
X-ME-Received: <xmr:A-_FYCkqhILPDvF8JweTUdknj7J1mtQcNC9wSLh13se6ZEurd3HxHuCadfg7ZCHkWJ80_3QzK-lQAfHEOmDK6Ypv9zu99wP_>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:A-_FYJw11gCn3KguodH13U8dMVyLa1F7P6vUgNG-oFsdjeotsUdmBw>
    <xmx:A-_FYMS_cr8dxe6Ju7wHljWqvZabL-b9P8S76TpipDBVaHLMEs04dw>
    <xmx:A-_FYMZavN2KCPFN3G--VjNB0S3l9ZjBdmCm3xRnXbSgkK6WaFMyvQ>
    <xmx:A-_FYHLYy-V_w6GCQuQjyuYPZR3uLMJtugGWOs49Fwi0s9wbb9BHD2ph9MQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 07:41:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: X86: MMU: Use the correct inherited permissions to get" failed to apply to 4.9-stable tree
To:     laijs@linux.alibaba.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 13:41:51 +0200
Message-ID: <162358451118176@kroah.com>
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

From b1bd5cba3306691c771d558e94baa73e8b0b96b7 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Thu, 3 Jun 2021 13:24:55 +0800
Subject: [PATCH] KVM: X86: MMU: Use the correct inherited permissions to get
 shadow page

When computing the access permissions of a shadow page, use the effective
permissions of the walk up to that point, i.e. the logic AND of its parents'
permissions.  Two guest PxE entries that point at the same table gfn need to
be shadowed with different shadow pages if their parents' permissions are
different.  KVM currently uses the effective permissions of the last
non-leaf entry for all non-leaf entries.  Because all non-leaf SPTEs have
full ("uwx") permissions, and the effective permissions are recorded only
in role.access and merged into the leaves, this can lead to incorrect
reuse of a shadow page and eventually to a missing guest protection page
fault.

For example, here is a shared pagetable:

   pgd[]   pud[]        pmd[]            virtual address pointers
                     /->pmd1(u--)->pte1(uw-)->page1 <- ptr1 (u--)
        /->pud1(uw-)--->pmd2(uw-)->pte2(uw-)->page2 <- ptr2 (uw-)
   pgd-|           (shared pmd[] as above)
        \->pud2(u--)--->pmd1(u--)->pte1(uw-)->page1 <- ptr3 (u--)
                     \->pmd2(uw-)->pte2(uw-)->page2 <- ptr4 (u--)

  pud1 and pud2 point to the same pmd table, so:
  - ptr1 and ptr3 points to the same page.
  - ptr2 and ptr4 points to the same page.

(pud1 and pud2 here are pud entries, while pmd1 and pmd2 here are pmd entries)

- First, the guest reads from ptr1 first and KVM prepares a shadow
  page table with role.access=u--, from ptr1's pud1 and ptr1's pmd1.
  "u--" comes from the effective permissions of pgd, pud1 and
  pmd1, which are stored in pt->access.  "u--" is used also to get
  the pagetable for pud1, instead of "uw-".

- Then the guest writes to ptr2 and KVM reuses pud1 which is present.
  The hypervisor set up a shadow page for ptr2 with pt->access is "uw-"
  even though the pud1 pmd (because of the incorrect argument to
  kvm_mmu_get_page in the previous step) has role.access="u--".

- Then the guest reads from ptr3.  The hypervisor reuses pud1's
  shadow pmd for pud2, because both use "u--" for their permissions.
  Thus, the shadow pmd already includes entries for both pmd1 and pmd2.

- At last, the guest writes to ptr4.  This causes no vmexit or pagefault,
  because pud1's shadow page structures included an "uw-" page even though
  its role.access was "u--".

Any kind of shared pagetable might have the similar problem when in
virtual machine without TDP enabled if the permissions are different
from different ancestors.

In order to fix the problem, we change pt->access to be an array, and
any access in it will not include permissions ANDed from child ptes.

The test code is: https://lore.kernel.org/kvm/20210603050537.19605-1-jiangshanlai@gmail.com/
Remember to test it with TDP disabled.

The problem had existed long before the commit 41074d07c78b ("KVM: MMU:
Fix inherited permissions for emulated guest pte updates"), and it
is hard to find which is the culprit.  So there is no fixes tag here.

Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
Message-Id: <20210603052455.21023-1-jiangshanlai@gmail.com>
Cc: stable@vger.kernel.org
Fixes: cea0f0e7ea54 ("[PATCH] KVM: MMU: Shadow page table caching")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/Documentation/virt/kvm/mmu.rst b/Documentation/virt/kvm/mmu.rst
index 5bfe28b0728e..20d85daed395 100644
--- a/Documentation/virt/kvm/mmu.rst
+++ b/Documentation/virt/kvm/mmu.rst
@@ -171,8 +171,8 @@ Shadow pages contain the following information:
     shadow pages) so role.quadrant takes values in the range 0..3.  Each
     quadrant maps 1GB virtual address space.
   role.access:
-    Inherited guest access permissions in the form uwx.  Note execute
-    permission is positive, not negative.
+    Inherited guest access permissions from the parent ptes in the form uwx.
+    Note execute permission is positive, not negative.
   role.invalid:
     The page is invalid and should not be used.  It is a root page that is
     currently pinned (by a cpu hardware register pointing to it); once it is
diff --git a/arch/x86/kvm/mmu/paging_tmpl.h b/arch/x86/kvm/mmu/paging_tmpl.h
index 70b7e44e3035..823a5919f9fa 100644
--- a/arch/x86/kvm/mmu/paging_tmpl.h
+++ b/arch/x86/kvm/mmu/paging_tmpl.h
@@ -90,8 +90,8 @@ struct guest_walker {
 	gpa_t pte_gpa[PT_MAX_FULL_LEVELS];
 	pt_element_t __user *ptep_user[PT_MAX_FULL_LEVELS];
 	bool pte_writable[PT_MAX_FULL_LEVELS];
-	unsigned pt_access;
-	unsigned pte_access;
+	unsigned int pt_access[PT_MAX_FULL_LEVELS];
+	unsigned int pte_access;
 	gfn_t gfn;
 	struct x86_exception fault;
 };
@@ -418,13 +418,15 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 		}
 
 		walker->ptes[walker->level - 1] = pte;
+
+		/* Convert to ACC_*_MASK flags for struct guest_walker.  */
+		walker->pt_access[walker->level - 1] = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	} while (!is_last_gpte(mmu, walker->level, pte));
 
 	pte_pkey = FNAME(gpte_pkeys)(vcpu, pte);
 	accessed_dirty = have_ad ? pte_access & PT_GUEST_ACCESSED_MASK : 0;
 
 	/* Convert to ACC_*_MASK flags for struct guest_walker.  */
-	walker->pt_access = FNAME(gpte_access)(pt_access ^ walk_nx_mask);
 	walker->pte_access = FNAME(gpte_access)(pte_access ^ walk_nx_mask);
 	errcode = permission_fault(vcpu, mmu, walker->pte_access, pte_pkey, access);
 	if (unlikely(errcode))
@@ -463,7 +465,8 @@ static int FNAME(walk_addr_generic)(struct guest_walker *walker,
 	}
 
 	pgprintk("%s: pte %llx pte_access %x pt_access %x\n",
-		 __func__, (u64)pte, walker->pte_access, walker->pt_access);
+		 __func__, (u64)pte, walker->pte_access,
+		 walker->pt_access[walker->level - 1]);
 	return 1;
 
 error:
@@ -643,7 +646,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 	bool huge_page_disallowed = exec && nx_huge_page_workaround_enabled;
 	struct kvm_mmu_page *sp = NULL;
 	struct kvm_shadow_walk_iterator it;
-	unsigned direct_access, access = gw->pt_access;
+	unsigned int direct_access, access;
 	int top_level, level, req_level, ret;
 	gfn_t base_gfn = gw->gfn;
 
@@ -675,6 +678,7 @@ static int FNAME(fetch)(struct kvm_vcpu *vcpu, gpa_t addr,
 		sp = NULL;
 		if (!is_shadow_present_pte(*it.sptep)) {
 			table_gfn = gw->table_gfn[it.level - 2];
+			access = gw->pt_access[it.level - 2];
 			sp = kvm_mmu_get_page(vcpu, table_gfn, addr, it.level-1,
 					      false, access);
 		}

