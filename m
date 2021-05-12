Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A0537BAE5
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhELKk6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:58 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:52539 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230184AbhELKk5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id D46571940E38;
        Wed, 12 May 2021 06:39:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 12 May 2021 06:39:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gxsPOx
        8u4RZ7xdyXnTlmJXFxMH+llld01qeHF920p4Y=; b=wPXYf4h5KOL7d5UUTA5hzz
        pRJEInnBS750i93zu4bn9+E3OBQP9Y9BKGoH8oaZwUl0V40S/2ZcDCVBfSrb2JEk
        ngiLTzQ2Ik243ijEoTZ2GBwHsHonv9mPQlsX/o+2ZJ0hJBU6OIrLji8aCG7FVbzK
        t5386Bd+crKBpeq48oBsHvQndinYrQ3IWArCyrDG5ns1jepWK1Ktx8/4sUoAPS84
        n9UPZfLsYzBy/LGliw3jdxysCBVZVm1kJdGcXraZt7BOEpVS0zpe7AiayVVyDU16
        X96n0CZjgXqIbGyf+uSSkru/ZZay5vtZ9Wo0mM1PxsWGmQaKmfRKov785e/ssEfg
        ==
X-ME-Sender: <xms:dbCbYAFOC5j724t4oDPFlECCzmS0VXBO30YLpYLX8Y8IELJKA1-3ew>
    <xme:dbCbYJU4x_Ow1PSQbwAUJyreOAwrFulLLJNJ2TuOBIDIGfZ-zRewTg91DWy5rVvDB
    k-m1Pj0VLefUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:dbCbYKJNZR--6LwKx48ZqWr3CHVtBBPVLYEQEiC5VADx476GfoBj7g>
    <xmx:dbCbYCEGHbQZYi9pvLpD15ZtXYeIbS8Y6GqVWPp2cnpBymoLYc2nsg>
    <xmx:dbCbYGUGjUQB0HjGyDhAio-ZWdILoNalwS7pxJOv_GXhxoYCIgXd9A>
    <xmx:dbCbYDibitF8qU4mgfarPlEKPODqmCpMQRyv-Q0k0DMAHYERFCYz8A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set the C-bit in the PDPTRs and LM" failed to apply to 5.10-stable tree
To:     seanjc@google.com, brijesh.singh@amd.com, pbonzini@redhat.com,
        thomas.lendacky@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:39:44 +0200
Message-ID: <162081598414282@kroah.com>
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
 

