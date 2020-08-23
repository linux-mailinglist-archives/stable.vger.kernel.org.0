Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ABA24ED2B
	for <lists+stable@lfdr.de>; Sun, 23 Aug 2020 14:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727829AbgHWM0S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Aug 2020 08:26:18 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:46367 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727822AbgHWM0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Aug 2020 08:26:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 13CB019405B5;
        Sun, 23 Aug 2020 08:26:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 23 Aug 2020 08:26:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WJ0o/9
        a6/PJuIe6ycvtfJ19C7JrN4KLttXehM/Z3OAI=; b=VWfH60w4smESTXjpm9dCaH
        kqVqr01T5Pnao0P7Igzhk6hs3xKQdXLktS0sCAIGpblhWdFU0HYwpS1D3grB9azc
        HmrUVie8Dh4EPr3mlOs3B4ltjZYwBZ0lf7Qfk+kZ7exrtT1HGBNtLcLNerALIS+W
        6HPT7ICvkyKCXeBh0mBrzr+RkmM4/V+T2NiPtF164W3G38GR4wLyuzdR2G85B/bf
        TEot4HyfgEEqxJaNpBoQCVEKn7vdXtlecqMbLC0KJhtR5/gnuHcFBCkCLE+tGHwP
        51s6wx2fVYF+kdQhbPqchyOEhRg7xHq7QzQY27mdFywUKtueFb+EyHLes8xzPjEg
        ==
X-ME-Sender: <xms:ZWBCX_BuldxGVCjHXyD2uyc1IloihT6KA69YBEz65P2eNYc6GY2OPg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudduiedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:ZWBCX1j4gdruM3VsbsoaUoGx4Vb22fsDnJKSoHoDctbQlqn81EVcIg>
    <xmx:ZWBCX6kl9gbx2BtL5dX2EuaF7PNlBi1sBox9HQIkhRq6E0YsFMBh9Q>
    <xmx:ZWBCXxxLU6fALg4esCiYTpn09NYZ2MrzC-LziZDFy9LAMQWSs3qiYg>
    <xmx:ZmBCX_cYBaeOz5Shv4q6_uG-MCWBiz38ZPYj9laB3YBnuFZLW57g1g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A67173280059;
        Sun, 23 Aug 2020 08:26:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()" failed to apply to 5.4-stable tree
To:     will@kernel.org, james.morse@arm.com, maz@kernel.org,
        pbonzini@redhat.com, stable@vger.kernel.org, suzuki.poulose@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Aug 2020 14:26:26 +0200
Message-ID: <159818558652190@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From fdfe7cbd58806522e799e2a50a15aee7f2cbb7b6 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Tue, 11 Aug 2020 11:27:24 +0100
Subject: [PATCH] KVM: Pass MMU notifier range flags to kvm_unmap_hva_range()

The 'flags' field of 'struct mmu_notifier_range' is used to indicate
whether invalidate_range_{start,end}() are permitted to block. In the
case of kvm_mmu_notifier_invalidate_range_start(), this field is not
forwarded on to the architecture-specific implementation of
kvm_unmap_hva_range() and therefore the backend cannot sensibly decide
whether or not to block.

Add an extra 'flags' parameter to kvm_unmap_hva_range() so that
architectures are aware as to whether or not they are permitted to block.

Cc: <stable@vger.kernel.org>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: James Morse <james.morse@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20200811102725.7121-2-will@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65568b23868a..e52c927aade5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -473,7 +473,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, unsigned flags);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0121ef2c7c8d..dc351802ff18 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2213,7 +2213,7 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *dat
 }
 
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end)
+			unsigned long start, unsigned long end, unsigned flags)
 {
 	if (!kvm->arch.mmu.pgd)
 		return 0;
diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
index d35eaed1668f..825d337a505a 100644
--- a/arch/mips/include/asm/kvm_host.h
+++ b/arch/mips/include/asm/kvm_host.h
@@ -969,7 +969,7 @@ enum kvm_mips_fault_result kvm_trap_emul_gva_fault(struct kvm_vcpu *vcpu,
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 int kvm_unmap_hva_range(struct kvm *kvm,
-			unsigned long start, unsigned long end);
+			unsigned long start, unsigned long end, unsigned flags);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index 87fa8d8a1031..28c366d307e7 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -486,7 +486,8 @@ static int kvm_unmap_hva_handler(struct kvm *kvm, gfn_t gfn, gfn_t gfn_end,
 	return 1;
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	handle_hva_to_gpa(kvm, start, end, &kvm_unmap_hva_handler, NULL);
 
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index e020d269416d..10ded83414de 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -58,7 +58,8 @@
 #define KVM_ARCH_WANT_MMU_NOTIFIER
 
 extern int kvm_unmap_hva_range(struct kvm *kvm,
-			       unsigned long start, unsigned long end);
+			       unsigned long start, unsigned long end,
+			       unsigned flags);
 extern int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 extern int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 extern int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index 41fedec69ac3..49db50d1db04 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -834,7 +834,8 @@ void kvmppc_core_commit_memory_region(struct kvm *kvm,
 	kvm->arch.kvm_ops->commit_memory_region(kvm, mem, old, new, change);
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	return kvm->arch.kvm_ops->unmap_hva_range(kvm, start, end);
 }
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index d6c1069e9954..ed0c9c43d0cf 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -734,7 +734,8 @@ static int kvm_unmap_hva(struct kvm *kvm, unsigned long hva)
 	return 0;
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	/* kvm_unmap_hva flushes everything anyways */
 	kvm_unmap_hva(kvm, start);
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5ab3af7275d8..5303dbc5c9bc 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1596,7 +1596,8 @@ asmlinkage void kvm_spurious_fault(void);
 	_ASM_EXTABLE(666b, 667b)
 
 #define KVM_ARCH_WANT_MMU_NOTIFIER
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end);
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags);
 int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
 int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
 int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 4e03841f053d..a5d0207e7189 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1916,7 +1916,8 @@ static int kvm_handle_hva(struct kvm *kvm, unsigned long hva,
 	return kvm_handle_hva_range(kvm, hva, hva + 1, data, handler);
 }
 
-int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end)
+int kvm_unmap_hva_range(struct kvm *kvm, unsigned long start, unsigned long end,
+			unsigned flags)
 {
 	return kvm_handle_hva_range(kvm, start, end, 0, kvm_unmap_rmapp);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 2c2c0254c2d8..4eaa4e46c7d0 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -482,7 +482,8 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 	 * count is also read inside the mmu_lock critical section.
 	 */
 	kvm->mmu_notifier_count++;
-	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end);
+	need_tlb_flush = kvm_unmap_hva_range(kvm, range->start, range->end,
+					     range->flags);
 	need_tlb_flush |= kvm->tlbs_dirty;
 	/* we've to flush the tlb before the pages can be freed */
 	if (need_tlb_flush)

