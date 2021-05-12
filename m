Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B909237BAE9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbhELKlD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:41:03 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48823 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKlD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:41:03 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 0F7871940E38;
        Wed, 12 May 2021 06:39:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/GXRgn
        c3yBGIgobFhs7sEmgehFj6Tq0LEQfsk2Heb2k=; b=J61Ac6JOx8UkslxKyNtlE1
        H3QpbgzGdFXXowzByTxqPOCtyM6W/AxzBBu8hjSITtiOfDA7T4SrjAusr0q/b3/z
        9LAFC1ymTIdKOpAbk0PFeHDYN0Wk0v+FeR97E7lrueuqy6cy0yfFW0xzNUkDFFny
        i81o9OVfFLdcePIyWXp2iA60/d6e0gcEq59WrcV5/v91K4W1/hUdDTlQYFpGsoXY
        mi8wSPTOBSjpE7u1MoXQ4Tm29LiyeY70U7lAjnlQp+5nidt2H7c5OEkSO4+p+0ar
        I8fzGjEjumM3Bj7T/twCBGYe9Fb12Dh/nmkVZ8Kp1MXweNlHaqKoP4Aa1aoz1Kug
        ==
X-ME-Sender: <xms:erCbYKbyTZ0oemDG9qeVUuCeL6c-K0tqJYebGU5YFgUlyv2nNKqOAA>
    <xme:erCbYNaQL-_ykz50F-dgZTkuECtTmslppbyI77kAAcS2CS5i1GlIRIB5wVckZeB_Q
    CSx_5ONOCU1aw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:erCbYE9HCaQFMbqfcco6ka2h9ybkv5fPzmvNoRSt3sPWG8zTU7DGiA>
    <xmx:erCbYMrCu7EgWbO3W7L7uJ5C_Yuj5ZWTt5RvBYTCrP025OxijumEqQ>
    <xmx:erCbYFowb1gyNSrQ9_7SbdnPlC90T6IM4saBRUIF9xEWBvVIEBolPQ>
    <xmx:e7CbYM0uKhUoM21wg6ijkQOXd6qg4p_94bbHa2-USX7q0BMsNTetJA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:54 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Mark the PAE roots as decrypted for shadow" failed to apply to 4.14-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:52 +0200
Message-ID: <1620815992245177@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4a98623d5d90175c0f99d185171e60807391e487 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 9 Mar 2021 14:42:07 -0800
Subject: [PATCH] KVM: x86/mmu: Mark the PAE roots as decrypted for shadow
 paging

Set the PAE roots used as decrypted to play nice with SME when KVM is
using shadow paging.  Explicitly skip setting the C-bit when loading
CR3 for PAE shadow paging, even though it's completely ignored by the
CPU.  The extra documentation is nice to have.

Note, there are several subtleties at play with NPT.  In addition to
legacy shadow paging, the PAE roots are used for SVM's NPT when either
KVM is 32-bit (uses PAE paging) or KVM is 64-bit and shadowing 32-bit
NPT.  However, 32-bit Linux, and thus KVM, doesn't support SME.  And
64-bit KVM can happily set the C-bit in CR3.  This also means that
keeping __sme_set(root) for 32-bit KVM when NPT is enabled is
conceptually wrong, but functionally ok since SME is 64-bit only.
Leave it as is to avoid unnecessary pollution.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210309224207.1218275-5-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 6b0576ff2846..c6ed633594a2 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -48,6 +48,7 @@
 #include <asm/memtype.h>
 #include <asm/cmpxchg.h>
 #include <asm/io.h>
+#include <asm/set_memory.h>
 #include <asm/vmx.h>
 #include <asm/kvm_page_track.h>
 #include "trace.h"
@@ -3388,7 +3389,10 @@ static int mmu_alloc_special_roots(struct kvm_vcpu *vcpu)
 	if (WARN_ON_ONCE(!tdp_enabled || mmu->pae_root || mmu->lm_root))
 		return -EIO;
 
-	/* Unlike 32-bit NPT, the PDP table doesn't need to be in low mem. */
+	/*
+	 * Unlike 32-bit NPT, the PDP table doesn't need to be in low mem, and
+	 * doesn't need to be decrypted.
+	 */
 	pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
 	if (!pae_root)
 		return -ENOMEM;
@@ -5274,6 +5278,8 @@ slot_handle_leaf(struct kvm *kvm, struct kvm_memory_slot *memslot,
 
 static void free_mmu_pages(struct kvm_mmu *mmu)
 {
+	if (!tdp_enabled && mmu->pae_root)
+		set_memory_encrypted((unsigned long)mmu->pae_root, 1);
 	free_page((unsigned long)mmu->pae_root);
 	free_page((unsigned long)mmu->lm_root);
 }
@@ -5308,6 +5314,20 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 		return -ENOMEM;
 
 	mmu->pae_root = page_address(page);
+
+	/*
+	 * CR3 is only 32 bits when PAE paging is used, thus it's impossible to
+	 * get the CPU to treat the PDPTEs as encrypted.  Decrypt the page so
+	 * that KVM's writes and the CPU's reads get along.  Note, this is
+	 * only necessary when using shadow paging, as 64-bit NPT can get at
+	 * the C-bit even when shadowing 32-bit NPT, and SME isn't supported
+	 * by 32-bit kernels (when KVM itself uses 32-bit NPT).
+	 */
+	if (!tdp_enabled)
+		set_memory_decrypted((unsigned long)mmu->pae_root, 1);
+	else
+		WARN_ON_ONCE(shadow_me_mask);
+
 	for (i = 0; i < 4; ++i)
 		mmu->pae_root[i] = INVALID_PAE_ROOT;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 58f4dc0e7864..271196400495 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3907,9 +3907,8 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 	struct vcpu_svm *svm = to_svm(vcpu);
 	unsigned long cr3;
 
-	root_hpa = __sme_set(root_hpa);
 	if (npt_enabled) {
-		svm->vmcb->control.nested_cr3 = root_hpa;
+		svm->vmcb->control.nested_cr3 = __sme_set(root_hpa);
 		vmcb_mark_dirty(svm->vmcb, VMCB_NPT);
 
 		/* Loading L2's CR3 is handled by enter_svm_guest_mode.  */
@@ -3917,7 +3916,7 @@ static void svm_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa,
 			return;
 		cr3 = vcpu->arch.cr3;
 	} else if (vcpu->arch.mmu->shadow_root_level >= PT64_ROOT_4LEVEL) {
-		cr3 = root_hpa | kvm_get_active_pcid(vcpu);
+		cr3 = __sme_set(root_hpa) | kvm_get_active_pcid(vcpu);
 	} else {
 		/* PCID in the guest should be impossible with a 32-bit MMU. */
 		WARN_ON_ONCE(kvm_get_active_pcid(vcpu));

