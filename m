Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E7B333014A
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhCGNmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:42:10 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:41607 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231395AbhCGNmJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:42:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 68BDF1A13;
        Sun,  7 Mar 2021 08:42:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:42:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KqIgUD
        DQ6cOdhlRTKkD71G/azk5Hw30aStxkAS4yWxo=; b=iIqddB9Iax9GCmxafcj5QW
        gKfLzphEE9N/SvCjLAfcUtp2MzmF99dAG/8hwc3ygTonAafPft+uriSlBHcLdqdW
        6Jsy8vjHLHJD6ZqfHwHsRrVCl10gi1YhiqybW3TmjwbqN3z4SA2N9HqFl11ztbyu
        8I447zGarp/u6D9iJIBIcXUHkTXVnerxV11nMGVyP7Kdlp44wCq5JXRPjp6HXSoH
        XXFpTy1l6m5R6wd1Wpyggr8y9rzzZjOCKMtJbVUMEmPgIP94Du/ph3Ob2+AwvEPy
        zG/So0Rmsi65/W73ACyPOTT7ODnGM6G2n7fgyCzHiwzDaIy3lmMqYrx4lHkTj0Vw
        ==
X-ME-Sender: <xms:MNhEYIRAa9HHkbjNJWUN5BTLXPSnUFRU3bHzBJD4jQRq9705bAWM9A>
    <xme:MNhEYFwsR8DaYFihZJ6PP2zESm6IqSJKRpNmtepB6DacFfSnQh9dfLw8DdcplWpjI
    4NeHZlv_G3DgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MNhEYF3jWHTh-N5WUIRGskQvK21xq497ysW4hqrsTwb18rbwXeY-HQ>
    <xmx:MNhEYMDIveobhdmPYy1oBOjxbTgY_IrBWxyuHBuv3ckEvN38XAXxTw>
    <xmx:MNhEYBi-bkLmThJpq6Hkp5pe6d4vZSkSEpKYMT6tT12rIinFgW4_ng>
    <xmx:MdhEYBIvavyHGmzDcAHePxstLq5mInl6zLe2O7j4iO_PnPoVsexgXeHLaOI>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A1E851080064;
        Sun,  7 Mar 2021 08:42:08 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML" failed to apply to 5.11-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:41:59 +0100
Message-ID: <1615124519250189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 44ac5958a6c1fd91ac8810fbb37194e377d78db5 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Thu, 25 Feb 2021 12:47:26 -0800
Subject: [PATCH] KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML
 is enabled

Check that PML is actually enabled before setting the mask to force a
SPTE to be write-protected.  The bits used for the !AD_ENABLED case are
in the upper half of the SPTE.  With 64-bit paging and EPT, these bits
are ignored, but with 32-bit PAE paging they are reserved.  Setting them
for L2 SPTEs without checking PML breaks NPT on 32-bit KVM.

Fixes: 1f4e5fc83a42 ("KVM: x86: fix nested guest live migration with PML")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210225204749.1512652-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
index 72b0928f2b2d..ec4fc28b325a 100644
--- a/arch/x86/kvm/mmu/mmu_internal.h
+++ b/arch/x86/kvm/mmu/mmu_internal.h
@@ -81,15 +81,15 @@ static inline struct kvm_mmu_page *sptep_to_sp(u64 *sptep)
 static inline bool kvm_vcpu_ad_need_write_protect(struct kvm_vcpu *vcpu)
 {
 	/*
-	 * When using the EPT page-modification log, the GPAs in the log
-	 * would come from L2 rather than L1.  Therefore, we need to rely
-	 * on write protection to record dirty pages.  This also bypasses
-	 * PML, since writes now result in a vmexit.  Note, this helper will
-	 * tag SPTEs as needing write-protection even if PML is disabled or
-	 * unsupported, but that's ok because the tag is consumed if and only
-	 * if PML is enabled.  Omit the PML check to save a few uops.
+	 * When using the EPT page-modification log, the GPAs in the CPU dirty
+	 * log would come from L2 rather than L1.  Therefore, we need to rely
+	 * on write protection to record dirty pages, which bypasses PML, since
+	 * writes now result in a vmexit.  Note, the check on CPU dirty logging
+	 * being enabled is mandatory as the bits used to denote WP-only SPTEs
+	 * are reserved for NPT w/ PAE (32-bit KVM).
 	 */
-	return vcpu->arch.mmu == &vcpu->arch.guest_mmu;
+	return vcpu->arch.mmu == &vcpu->arch.guest_mmu &&
+	       kvm_x86_ops.cpu_dirty_log_size;
 }
 
 bool is_nx_huge_page_enabled(void);

