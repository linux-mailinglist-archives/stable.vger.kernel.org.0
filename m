Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D99297BBC
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1756672AbgJXJvw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:51:52 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:51631 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755344AbgJXJvv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:51:51 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 229105E3;
        Sat, 24 Oct 2020 05:51:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:51:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=uTF+46
        cVdGFluh4uQbJh3d9aUchtZr+wi8FmosQHcFU=; b=jdmvZCUKt3nQZhQt7xd1ox
        ld6FL1VL1fLGaYpXww8nwFjh4BPCfecPWRg72AxCATwK/zn68zkfruiYwlkbYnmx
        8INovSc3H0FgGuQnZJf5aVXxaYoAzm5rSSW4nUSofY3/DrYdcL1XjTRnSLtrq7lI
        U6q+XzcjD9mwWXvZP6212wI7JIqE59zVr8nhXfZLVy3be6NqjR//EaxswYbp85T3
        T7kb44TP8kEs3c9MP//9kv65qe4lsefEU9LkUNvYJ8JUOzQrBIjdr7TqQmCOv2xW
        Ra0nxkYCX88SXdMwFpuY58k/8MJICq8JheYRjDbHtfU1Hegj0ai6ienn53h7S5QQ
        ==
X-ME-Sender: <xms:NfmTXy5-ga3WGXPaFHZhbzYwiLEJzWF7Tifq_RGA_ZKKLF09uqYZZQ>
    <xme:NfmTX74p3rUAIhtlD6mYfxMolIOG2R6U-jYy3l2oT-oSX402G-nI53O0qmvcGBPZq
    -pwBC5VqOrB7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddvudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:NfmTXxfSoD-4x7Bjgqb5t2DuZEeJTFxQEopGyDQXwg0c0Bv9nNIn8Q>
    <xmx:NfmTX_KJUXg6iOMApYKqZUxkj0FKr1AcY1AtWZ0_nKVkszCh45QF6w>
    <xmx:NfmTX2LsAsCrwHPH6pGqy2turyPeBHeeHfIQdnySIfpwkVPP3HNQgw>
    <xmx:NfmTX9VjJlb89-mpk6BdOXXmhBF08VBaBcI81xFZDczIV418Ut2Pcqfgfzg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4FB323064674;
        Sat, 24 Oct 2020 05:51:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Intercept LA57 to inject #GP fault when it's" failed to apply to 5.4-stable tree
To:     laijs@linux.alibaba.com, jiangshanlai@gmail.com,
        pbonzini@redhat.com, sean.j.christopherson@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:52:24 +0200
Message-ID: <1603533144245176@kroah.com>
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

From 6e1d849fa3296526e64b75fa227b6377cd0fd3da Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@linux.alibaba.com>
Date: Tue, 29 Sep 2020 21:16:55 -0700
Subject: [PATCH] KVM: x86: Intercept LA57 to inject #GP fault when it's
 reserved

Unconditionally intercept changes to CR4.LA57 so that KVM correctly
injects a #GP fault if the guest attempts to set CR4.LA57 when it's
supported in hardware but not exposed to the guest.

Long term, KVM needs to properly handle CR4 bits that can be under guest
control but also may be reserved from the guest's perspective.  But, KVM
currently sets the CR4 guest/host mask only during vCPU creation, and
reworking flows to change that will take a bit of elbow grease.

Even if/when generic support for intercepting reserved bits exists, it's
probably not worth letting the guest set CR4.LA57 directly.  LA57 can't
be toggled while long mode is enabled, thus it's all but guaranteed to
be set once (maybe twice, e.g. by BIOS and kernel) during boot and never
touched again.  On the flip side, letting the guest own CR4.LA57 may
incur extra VMREADs.  In other words, this temporary "hack" is probably
also the right long term fix.

Fixes: fd8cb433734e ("KVM: MMU: Expose the LA57 feature to VM.")
Cc: stable@vger.kernel.org
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
[sean: rewrote changelog]
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200930041659.28181-2-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/kvm_cache_regs.h b/arch/x86/kvm/kvm_cache_regs.h
index cfe83d4ae625..ca0781b41df9 100644
--- a/arch/x86/kvm/kvm_cache_regs.h
+++ b/arch/x86/kvm/kvm_cache_regs.h
@@ -7,7 +7,7 @@
 #define KVM_POSSIBLE_CR0_GUEST_BITS X86_CR0_TS
 #define KVM_POSSIBLE_CR4_GUEST_BITS				  \
 	(X86_CR4_PVI | X86_CR4_DE | X86_CR4_PCE | X86_CR4_OSFXSR  \
-	 | X86_CR4_OSXMMEXCPT | X86_CR4_LA57 | X86_CR4_PGE | X86_CR4_TSD)
+	 | X86_CR4_OSXMMEXCPT | X86_CR4_PGE | X86_CR4_TSD)
 
 #define BUILD_KVM_GPR_ACCESSORS(lname, uname)				      \
 static __always_inline unsigned long kvm_##lname##_read(struct kvm_vcpu *vcpu)\

