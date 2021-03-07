Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3905833014C
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:43:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhCGNml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:42:41 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51309 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230272AbhCGNmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 08:42:11 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 5EAEE186F;
        Sun,  7 Mar 2021 08:42:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 07 Mar 2021 08:42:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8OuWvN
        dH7EKNunbJFbRk8uTP+NOBEviH8W3ucKH+ZPQ=; b=ea5AHSvu8iSvrYK4/qokIN
        L5gPXLF0dea3uZscpqLiW7rpm7R3aV9XB0N9LZ1z6KPL8D8VOMf3OzwZqCnsSyfK
        fzVmVC6Ua3c7ypIGckeakmZwcKUx96smfziHjatereenFondZiQuitsiaGIlZfjc
        6kjPIB4B6tKDjJTAC3LzAyYDDfiCRLPzNvMHsDanzXi7/YnYBxzSfB7VtTiboNhd
        OEBnNiQr1mBdOoJn+7LbODH7PyLSI+pza6I0jmwpcHakXdVywTDtgZ+8HX1GY5ZE
        YPG44F8rpiE0b4X7Ml84LvmxdNE0dHuWU+yHFaz/gOf4UiIfk2Fsf8aFaOKFR+iA
        ==
X-ME-Sender: <xms:MthEYPhvjxmedswEJCEvxtAKgheQQnuFuQuCwqG3J1DBRhaU1DHvxA>
    <xme:MthEYMCYQVE_lvE6LNon1-GmUdiFgHdUQ52VckyHVdqBuLYYtAUiWNeoqkmfWZ74e
    ut_VNsdJW2G3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddutddggeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:MthEYPHhitBVXgr85zCC291LMelyjNCp7tVqJVD0hqJNlyhpMD9K2A>
    <xmx:MthEYMQlMB8B0MU9h5ChachfWuGgCS0ft7IFRAbVBvTM_Em-zdOBnw>
    <xmx:MthEYMzwYY7h2dwf-YIkhuLqDEpxBv--JwRqtMIweqnoR7_Prb5JNA>
    <xmx:M9hEYCbsXaPtrYYhksNmzSuYhInvyL9SYu6DMDerFNNc_5AIOpSBykBWkBg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9D7F824005A;
        Sun,  7 Mar 2021 08:42:10 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86/mmu: Set SPTE_AD_WRPROT_ONLY_MASK if and only if PML" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 07 Mar 2021 14:41:59 +0100
Message-ID: <161512451917754@kroah.com>
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

