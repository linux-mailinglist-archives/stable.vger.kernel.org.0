Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFC937BAD8
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhELKkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:08 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:54171 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhELKkI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:08 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id DFDAC12D5;
        Wed, 12 May 2021 06:38:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 12 May 2021 06:39:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hwsEMN
        ZN0SPNJASufiQEUk2L9GIQ74jgCsaJc3CKot8=; b=LvIZB08+CRpXbJGxIFFMvq
        mbe4wv8/RqK+7Dyrx9tP+plQL10EhnftHll9VfHoBSjuSeOf5T70Cl22KeItBimJ
        CSEHPFo8MqTy6UkxfUTsayPRCsHoRYWgCR4n1EjPsWpLioLbLoDOJyL9pv+m1XrO
        spmmzHj4rM6wMjru023kqRz+8GtGLK9mJaPyVunJpb9+ce9PpFiV7MXGee1OGzrF
        PvAmwijzUiYW9oPGV+upxl2Lc44r/yY59llxL3vivmvlPfI8o5rLOasXqbxgCdls
        Ma/b5WUPo8b6LWcJTqL/tXAs8FNGOnrDXPWjX1X9pi6yFkSL1Vm36JbNsiJq6WXw
        ==
X-ME-Sender: <xms:Q7CbYJScIXVDrgT0Rw-o_UBuFYdvYGmfAvJtY5tkKcrZ132N6PyXpg>
    <xme:Q7CbYCy_YgqeyVqicWRaot-tSA0BmC_JkRjwPpxW4Hk_XTtHqQsVzCvcbh8Db6pOh
    cSKkUco67BbEw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Q7CbYO1FvX-YvC6S94tvyUNujC-uImdFTvWfnQ7rbiLdwhWCVq0M1Q>
    <xmx:Q7CbYBAgybEu4KxXo7biEjnDCVCW0FMjfxgV4yHR26imxRI5RFE1bg>
    <xmx:Q7CbYCjLdBBd4da4grjZ71fwezFIOYNmF75gBiLPHAiTTx5-wV9MmQ>
    <xmx:Q7CbYKJTYnxuysBdHZar5x_v9E4T0VkGSVSPy8sZ_Wk8HSg8LD_Im5zV_YY>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:38:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:38:45 +0200
Message-ID: <162081592515888@kroah.com>
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

From 886bbcc7a523b8d4fac60f1015d2e0fcad50db82 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Wed, 21 Apr 2021 19:21:21 -0700
Subject: [PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode

Check CR3 for an invalid GPA even if the vCPU isn't in long mode.  For
bigger emulation flows, notably RSM, the vCPU mode may not be accurate
if CR0/CR4 are loaded after CR3.  For MOV CR3 and similar flows, the
caller is responsible for truncating the value.

Fixes: 660a5d517aaa ("KVM: x86: save/load state on SMM switch")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210422022128.3464144-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4c9c9592a437..3010284dc59b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1077,10 +1077,15 @@ int kvm_set_cr3(struct kvm_vcpu *vcpu, unsigned long cr3)
 		return 0;
 	}
 
-	if (is_long_mode(vcpu) && kvm_vcpu_is_illegal_gpa(vcpu, cr3))
+	/*
+	 * Do not condition the GPA check on long mode, this helper is used to
+	 * stuff CR3, e.g. for RSM emulation, and there is no guarantee that
+	 * the current vCPU mode is accurate.
+	 */
+	if (kvm_vcpu_is_illegal_gpa(vcpu, cr3))
 		return 1;
-	else if (is_pae_paging(vcpu) &&
-		 !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
+
+	if (is_pae_paging(vcpu) && !load_pdptrs(vcpu, vcpu->arch.walk_mmu, cr3))
 		return 1;
 
 	kvm_mmu_new_pgd(vcpu, cr3, skip_tlb_flush, skip_tlb_flush);

