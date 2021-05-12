Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3738837BADB
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 12:39:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbhELKkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 06:40:18 -0400
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:53827 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhELKkR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 06:40:17 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 6784C1264;
        Wed, 12 May 2021 06:39:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 06:39:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AIwhQi
        /qmSXMu3Fdvo5M3F/rME0dOw7QHvZHh+mZRz4=; b=X9n/SNtVA9HDkrIkk8R47R
        kg2+F5cuD+Hj6KxSWQcGXlIWU3NvRo3d6EqHucpymM4xJzW0bZSDUDG4v+Kj05us
        dHyS3zNKrz6t82oIb/yFxes+VpG0fI5P01mKY27JOVxNbgMGSzTcu4RSf3qY0gER
        IdHJNGXcGNIonrHO8FgB6DkD05xZ9CQ9tlHWi6CLwPb/F2fzf4jX2mWN3L0Xd8iC
        fUlAuAY854sZgZfWLa5WIkjhFGb+K5Qv13hXS9Z5JS8VwzxZjSgVZ32itbZKVE+l
        bL7dutaFWRg6E314Qzz53hUWe1x87JGzKT+lLuKi8shcnc1myd8swfWxn/hBFDjg
        ==
X-ME-Sender: <xms:S7CbYDABZknz7JwUzYpSvBXDX7PXHDPeKoC9uEjH-Cc8BsXUJ2TlDQ>
    <xme:S7CbYJi9teWlpVdkU5WEhr9dmkdDdV8UxbaaWfeMLp8m0SlcgWn0hgDRZG6b-1bpE
    vCRXKF742IwcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:S7CbYOmhOKYueCSbT4Z_UiaAXk_LQrEWAJq5hftg5eU5Dp26Umxndg>
    <xmx:S7CbYFyyQz2xPu9sufZFZuxr82fjRFe5PiiJTzP4KpcwXdKMRz9uaQ>
    <xmx:S7CbYIRdJVksR5BivwKdJnny8skauqYSOJUTgU5SS6btUeAG68w5AA>
    <xmx:TLCbYB6z1t86dMT2A4X6hZ0I65yBs9IQIxDZ6k5dBZLytnsSyiwyVJmbx3A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 06:39:07 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Check CR3 GPA for validity regardless of vCPU mode" failed to apply to 5.10-stable tree
To:     seanjc@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 12 May 2021 12:38:46 +0200
Message-ID: <16208159264688@kroah.com>
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

