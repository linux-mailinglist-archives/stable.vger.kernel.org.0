Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C6F37BAD1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230019AbhELKi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:38:59 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:47239 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230247AbhELKi6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:38:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 7171A12AE;
        Wed, 12 May 2021 06:37:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 12 May 2021 06:37:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EeREsU
        kcryOShItPBSNIE/3sAX5Tp9FakfBksWkv9E4=; b=WkFz2TLGKncUob/KVkqqYE
        J/VxhhhV49hppeVDspg4XAWVol1ifKDBhMm1T8j3p4P6Fb1tStJ2y65mJTS7jn/R
        A8INF1zx5MDwP3eUihULCaDskU7rlHv1Gg4cIADyXly/gOF4GCFWYRMRimar58fg
        2N53vrZxjiZaC3hsaeStajks9DMNRRTA1yVDQr37saMH1E6HY4utTnOuYx1KArD6
        5qYyY5mHEkfJ4rWF1VyTDvTnkqk/jz2OuN6qlpOaDr/7jW8J7lK7DAlBmA77DgJ3
        8y+cWXIYAUE+5BvfX1jYTKbEmW6jBJvF4Noi/dxu1p0kFF09GlqUNqKgSlSXw30w
        ==
X-ME-Sender: <xms:-6-bYCJm1Cf-FhvEOqnNGNOd5v8IqyNeW0J_RFWy4W3_8l5hug5HmA>
    <xme:-6-bYKIkgLT5r7p7jmBgV8RBlwmS_cmM-QvYVMev2DjaA-h6u63PqNEI775k87068
    JwNa8zkrVaZKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:-6-bYCt9MTRo2_GqGzoJrylZMZj0enzI5SDBOp_rSIXkkOXdz6ajUw>
    <xmx:-6-bYHZZDqJih1tQyLejlBBSnk4LxGCzXzjxQ8OV_GjAr91IGyPM6g>
    <xmx:-6-bYJbfh-3uujQLK3Cyvi5F9_4sEUIov1d8bMYXpwvbopPo7j-NLQ>
    <xmx:_K-bYIzdziDYIqgkvHeWI_-ZY0bAknKZf9U8EYT0sviCuh5yBLwynUOAXWk>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:37:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT" failed to apply to 5.4-stable tree
To:     seanjc@google.com, bgardon@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:37:37 +0200
Message-ID: <162081585784212@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 04d45551a1eefbea42655da52f56e846c0af721a Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:46 -0800
Subject: [PATCH] KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT
 with 64-bit

Allocate the so called pae_root page on-demand, along with the lm_root
page, when shadowing 32-bit NPT with 64-bit NPT, i.e. when running a
32-bit L1.  KVM currently only allocates the page when NPT is disabled,
or when L0 is 32-bit (using PAE paging).

Note, there is an existing memory leak involving the MMU roots, as KVM
fails to free the PAE roots on failure.  This will be addressed in a
future commit.

Fixes: ee6268ba3a68 ("KVM: x86: Skip pae_root shadow allocation if tdp enabled")
Fixes: b6b80c78af83 ("KVM: x86/mmu: Allocate PAE root array when using SVM's 32-bit NPT")
Cc: stable@vger.kernel.org
Reviewed-by: Ben Gardon <bgardon@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index d75524bc8423..b52bd620d1e5 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3193,14 +3193,14 @@ void kvm_mmu_free_roots(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		if (mmu->shadow_root_level >= PT64_ROOT_4LEVEL &&
 		    (mmu->root_level >= PT64_ROOT_4LEVEL || mmu->direct_map)) {
 			mmu_free_root_page(kvm, &mmu->root_hpa, &invalid_list);
-		} else {
+		} else if (mmu->pae_root) {
 			for (i = 0; i < 4; ++i)
 				if (mmu->pae_root[i] != 0)
 					mmu_free_root_page(kvm,
 							   &mmu->pae_root[i],
 							   &invalid_list);
-			mmu->root_hpa = INVALID_PAGE;
 		}
+		mmu->root_hpa = INVALID_PAGE;
 		mmu->root_pgd = 0;
 	}
 
@@ -3312,9 +3312,23 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
 	pm_mask = PT_PRESENT_MASK;
-	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL)
+	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 
+		/*
+		 * Allocate the page for the PDPTEs when shadowing 32-bit NPT
+		 * with 64-bit only when needed.  Unlike 32-bit NPT, it doesn't
+		 * need to be in low mem.  See also lm_root below.
+		 */
+		if (!vcpu->arch.mmu->pae_root) {
+			WARN_ON_ONCE(!tdp_enabled);
+
+			vcpu->arch.mmu->pae_root = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+			if (!vcpu->arch.mmu->pae_root)
+				return -ENOMEM;
+		}
+	}
+
 	for (i = 0; i < 4; ++i) {
 		MMU_WARN_ON(VALID_PAGE(vcpu->arch.mmu->pae_root[i]));
 		if (vcpu->arch.mmu->root_level == PT32E_ROOT_LEVEL) {
@@ -3337,21 +3351,19 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	vcpu->arch.mmu->root_hpa = __pa(vcpu->arch.mmu->pae_root);
 
 	/*
-	 * If we shadow a 32 bit page table with a long mode page
-	 * table we enter this path.
+	 * When shadowing 32-bit or PAE NPT with 64-bit NPT, the PML4 and PDP
+	 * tables are allocated and initialized at MMU creation as there is no
+	 * equivalent level in the guest's NPT to shadow.  Allocate the tables
+	 * on demand, as running a 32-bit L1 VMM is very rare.  The PDP is
+	 * handled above (to share logic with PAE), deal with the PML4 here.
 	 */
 	if (vcpu->arch.mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		if (vcpu->arch.mmu->lm_root == NULL) {
-			/*
-			 * The additional page necessary for this is only
-			 * allocated on demand.
-			 */
-
 			u64 *lm_root;
 
 			lm_root = (void*)get_zeroed_page(GFP_KERNEL_ACCOUNT);
-			if (lm_root == NULL)
-				return 1;
+			if (!lm_root)
+				return -ENOMEM;
 
 			lm_root[0] = __pa(vcpu->arch.mmu->pae_root) | pm_mask;
 
@@ -5240,9 +5252,11 @@ static int __kvm_mmu_create(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu)
 	 * while the PDP table is a per-vCPU construct that's allocated at MMU
 	 * creation.  When emulating 32-bit mode, cr3 is only 32 bits even on
 	 * x86_64.  Therefore we need to allocate the PDP table in the first
-	 * 4GB of memory, which happens to fit the DMA32 zone.  Except for
-	 * SVM's 32-bit NPT support, TDP paging doesn't use PAE paging and can
-	 * skip allocating the PDP table.
+	 * 4GB of memory, which happens to fit the DMA32 zone.  TDP paging
+	 * generally doesn't use PAE paging and can skip allocating the PDP
+	 * table.  The main exception, handled here, is SVM's 32-bit NPT.  The
+	 * other exception is for shadowing L1's 32-bit or PAE NPT on 64-bit
+	 * KVM; that horror is handled on-demand by mmu_alloc_shadow_roots().
 	 */
 	if (tdp_enabled && kvm_mmu_get_tdp_level(vcpu) > PT32E_ROOT_LEVEL)
 		return 0;

