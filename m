Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6708A37BAE4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhELKk4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:56 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:53673 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKk4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:56 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2BD951940E44;
        Wed, 12 May 2021 06:39:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/B0Gtn
        Riidi4CJRKuYirisdpek3sp62uEg+Yi/G6ghA=; b=F7+WED+1ruwZmMT7D0aM9J
        GifTeTGkT40hJ6LpSirQRkrRvBH03pAGt1/91OnVnG1nXNVfuDelj6WcZmE+V9g3
        KbaaoaEtoFJXseGpExSx8fMGr1451/PfvbPGEbHFwmxcllfJTa0i7ff6eLuAVH8S
        YYS8eCNEmr2Dj7bhO//T09D0OY5xL28rbUgjmvrrA1cIOM3i1OcyQ9XmEah50xjR
        NiZS8i1g2GfMNiBjF1Ph0Gs/NMNfZNfbRWrZPMUrMelp0BPMIMBSLsLn2NGcDDan
        xC78mnmoFsxWrDCMvKWIri9SGfs/XfFQ2QIyLmo+U7WJ+LifIJpDMR8+7mi4hGLQ
        ==
X-ME-Sender: <xms:dLCbYBx86WVXA7KodNDv8qNuuCn6gxvdZnU9_9gAD6I_ADLjfBtLMg>
    <xme:dLCbYBQcsSNvXB7LdP-8dXg-PloHHdMkbZKg-LbXrfsGOwM4qFJUm_TjkDJZ_NFhW
    Ig_z9fIR02DHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:dLCbYLVEc4PO35QMG7qMNGs-yxZJ3rfnhOPp5IolrG4EpFzDOGDk5w>
    <xmx:dLCbYDhLjhnW7W1YN6qj1zcluIugAglyEbQY5huKQdYNI2j2xXbj3Q>
    <xmx:dLCbYDAbDt1C2oLgJnmt4vafzMv7fvmm9pdj0FsMDRt-Qj_pql516w>
    <xmx:dLCbYGNeb7w2DSiMDBi-8tN5z9z_zfiHEF9dHqsnkmTQ9Fdw-EkDVw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM" failed to apply to 4.19-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:43 +0200
Message-ID: <1620815983245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 17e368d94af77c1533bfd4136e080a33a6330282 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 4 Mar 2021 17:10:54 -0800
Subject: [PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM
 pseudo-PDPTRs

Set the C-bit in SPTEs that are set outside of the normal MMU flows,
specifically the PDPDTRs and the handful of special cased "LM root"
entries, all of which are shadow paging only.

Note, the direct-mapped-root PDPTR handling is needed for the scenario
where paging is disabled in the guest, in which case KVM uses a direct
mapped MMU even though TDP is disabled.

Fixes: d0ec49d4de90 ("kvm/x86/svm: Support Secure Memory Encryption within KVM")
Cc: stable@vger.kernel.org
Cc: Brijesh Singh <brijesh.singh@amd.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210305011101.3597423-11-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index da94734272db..ff7e050ba1ac 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -3261,7 +3261,8 @@ static int mmu_alloc_direct_roots(struct kvm_vcpu *vcpu)
 
 			root = mmu_alloc_root(vcpu, i << (30 - PAGE_SHIFT),
 					      i << 30, PT32_ROOT_LEVEL, true);
-			mmu->pae_root[i] = root | PT_PRESENT_MASK;
+			mmu->pae_root[i] = root | PT_PRESENT_MASK |
+					   shadow_me_mask;
 		}
 		mmu->root_hpa = __pa(mmu->pae_root);
 	} else
@@ -3314,7 +3315,7 @@ static int mmu_alloc_shadow_roots(struct kvm_vcpu *vcpu)
 	 * or a PAE 3-level page table. In either case we need to be aware that
 	 * the shadow page table may be a PAE or a long mode page table.
 	 */
-	pm_mask = PT_PRESENT_MASK;
+	pm_mask = PT_PRESENT_MASK | shadow_me_mask;
 	if (mmu->shadow_root_level == PT64_ROOT_4LEVEL) {
 		pm_mask |= PT_ACCESSED_MASK | PT_WRITABLE_MASK | PT_USER_MASK;
 

