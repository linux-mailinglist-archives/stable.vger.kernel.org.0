Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AE021DB1A
	for <lists+stable@lfdr.de>; Mon, 13 Jul 2020 18:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729946AbgGMQCn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jul 2020 12:02:43 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:52765 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729659AbgGMQCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jul 2020 12:02:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id DA51C3CF;
        Mon, 13 Jul 2020 12:02:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 13 Jul 2020 12:02:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mvLSDl
        kMBIYMp7T+DfKXqtGQkCMIs38djAb/YXsHkss=; b=NF+Me0mdTRwexrLb3X3y0z
        ir1At7UNR/xYvQatoLUmfC5n5xjQ3+d+CbZllH9fH3YwNeHUQEb7U/7R/j+GjZe7
        Yg8xTw6bZYsB3xwQ1iw2vwgIW9DM1QCO8DrtBAIIwVc0XQIAkYfQ5zlvpqzSCcJq
        2pXbWlD0m3qJrp+Rl8Ae1OaNgw9luiUnvJkydKuJfUy51AYZVMSYjWfOY6jSkKbM
        3wnc7OsBmPl+D61GCyP0EV2DOO9Uclj3YDBbjWVfWRrGEXVt8p8BvvyFcAwNkqIz
        bx11+AJhtiBaQmr+Htpm0boMQSGYl3CL1YdRlha7q4XC3WPtzmSqIc2c+CnUJCPA
        ==
X-ME-Sender: <xms:oIUMX8GCbYEmJc-ZQ6FF3rgwLetKM6K_t31XBt3dHqxk_RCZZFFCwQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvdekgdelkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:oIUMX1Uu_K5_qGr0Mwe1gUK_0aI_0qBRJSuxnrZwQsmP0IATWNgB2Q>
    <xmx:oIUMX2JwvHaFQeAWDAAfqzT3yhcSvrRRUfOw0KBj4D9x2gEGEIw04w>
    <xmx:oIUMX-FRb7YdjT2w9PW8CgsEUqEIn4-SbsDJgiWGTlQTSzI5YDUQlQ>
    <xmx:oYUMX9D2VRy5PXb3B7clgHqeVmesy9zo-LC7CMtyA2R8C3WZ2Luubm-uStc>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 98B8830600B2;
        Mon, 13 Jul 2020 12:02:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Mark CR4.TSD as being possibly owned by the guest" failed to apply to 4.9-stable tree
To:     sean.j.christopherson@intel.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jul 2020 18:02:38 +0200
Message-ID: <1594656158131135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 7c83d096aed055a7763a03384f92115363448b71 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Thu, 2 Jul 2020 21:04:21 -0700
Subject: [PATCH] KVM: x86: Mark CR4.TSD as being possibly owned by the guest

Mark CR4.TSD as being possibly owned by the guest as that is indeed the
case on VMX.  Without TSD being tagged as possibly owned by the guest, a
targeted read of CR4 to get TSD could observe a stale value.  This bug
is benign in the current code base as the sole consumer of TSD is the
emulator (for RDTSC) and the emulator always "reads" the entirety of CR4
when grabbing bits.

Add a build-time assertion in to ensure VMX doesn't hand over more CR4
bits without also updating x86.

Fixes: 52ce3c21aec3 ("x86,kvm,vmx: Don't trap writes to CR4.TSD")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200703040422.31536-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index ff2d0e9ca3bc..cfe83d4ae625 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb22f33bf1d8..5c9bfc0b9ab9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4034,6 +4034,8 @@ void vmx_set_constant_host_state(struct vcpu_vmx *vmx)
 
 void set_cr4_guest_host_mask(struct vcpu_vmx *vmx)
 {
+	BUILD_BUG_ON(KVM_CR4_GUEST_OWNED_BITS & ~KVM_POSSIBLE_CR4_GUEST_BITS);
+
 	vmx->vcpu.arch.cr4_guest_owned_bits = KVM_CR4_GUEST_OWNED_BITS;
 	if (enable_ept)
 		vmx->vcpu.arch.cr4_guest_owned_bits |= X86_CR4_PGE;

