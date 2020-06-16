Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997B91FAE79
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgFPKsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:48:17 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34239 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728259AbgFPKsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:48:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2F85D1940878;
        Tue, 16 Jun 2020 06:48:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 06:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=mM4P4Y
        Yh6x/1+wBXhGIwVLQAxPQI8JYIimRo0TA4cIk=; b=YW0LMwmLnSGzHLaL4un/xp
        Wj3Q2nmxUTK+Eq1MM3zauMai3BU/wh9KEXQyAuDx0ZaYHLpOKWX1Gvi7lA2yMEi0
        v3aDkjbj7RqBIFpKMNBxTILat2Ga5neXCzyqN3kxgxXLXD/HUEuewomq9j/qDv+T
        2x9txLFCphZ9TqNbu7mIczJmcc20DR49yiUsPUc9rS44dex8ZYh2Z1RXFBzTNrzA
        zp76wXnKZ6HM2oaYi3BRjrsZ3h4RYxjd2H6Kb1QDkzhDilLodnABLKDCVRU2QvCQ
        vyRKKM313Bzgir2MON16NRek2/LOEJMur4ghlddN7+BCwM5S2adCJmK5D66viVGw
        ==
X-ME-Sender: <xms:b6PoXrgqA-yseiFw2c0e-O7kyrnE-w_moFrZdBg-tEkfnqEKFCjOsA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:b6PoXoCcUI_GdkCMKrEraQ12BSNwVMwHNorMkBjxWov5XhJlfO_A8w>
    <xmx:b6PoXrH6Ta8cqnQaq3yqmWI1dlM8-jnAuLFULY_5cYps0vDLcZlKXg>
    <xmx:b6PoXoQvfpFSQMSlkURR-6ORgD_9L88FFzIcfvZfy3H1gfAPr1wQNw>
    <xmx:b6PoXlvf2xj6sb6HHb3Tl3t5j9lagvyAP-15RksBZMNzJF5fg6VZfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A7502328005A;
        Tue, 16 Jun 2020 06:48:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Synchronize sysreg state on injecting an AArch32" failed to apply to 4.19-stable tree
To:     maz@kernel.org, james.morse@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 12:48:03 +0200
Message-ID: <159230448371245@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 0370964dd3ff7d3d406f292cb443a927952cbd05 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Tue, 9 Jun 2020 08:50:29 +0100
Subject: [PATCH] KVM: arm64: Synchronize sysreg state on injecting an AArch32
 exception

On a VHE system, the EL1 state is left in the CPU most of the time,
and only syncronized back to memory when vcpu_put() is called (most
of the time on preemption).

Which means that when injecting an exception, we'd better have a way
to either:
(1) write directly to the EL1 sysregs
(2) synchronize the state back to memory, and do the changes there

For an AArch64, we already do (1), so we are safe. Unfortunately,
doing the same thing for AArch32 would be pretty invasive. Instead,
we can easily implement (2) by calling the put/load architectural
backends, and keep preemption disabled. We can then reload the
state back into EL1.

Cc: stable@vger.kernel.org
Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/arch/arm64/kvm/aarch32.c b/arch/arm64/kvm/aarch32.c
index 0a356aa91aa1..40a62a99fbf8 100644
--- a/arch/arm64/kvm/aarch32.c
+++ b/arch/arm64/kvm/aarch32.c
@@ -33,6 +33,26 @@ static const u8 return_offsets[8][2] = {
 	[7] = { 4, 4 },		/* FIQ, unused */
 };
 
+static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
+{
+	preempt_disable();
+	if (vcpu->arch.sysregs_loaded_on_cpu) {
+		kvm_arch_vcpu_put(vcpu);
+		return true;
+	}
+
+	preempt_enable();
+	return false;
+}
+
+static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
+{
+	if (loaded) {
+		kvm_arch_vcpu_load(vcpu, smp_processor_id());
+		preempt_enable();
+	}
+}
+
 /*
  * When an exception is taken, most CPSR fields are left unchanged in the
  * handler. However, some are explicitly overridden (e.g. M[4:0]).
@@ -155,7 +175,10 @@ static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 
 void kvm_inject_undef32(struct kvm_vcpu *vcpu)
 {
+	bool loaded = pre_fault_synchronize(vcpu);
+
 	prepare_fault32(vcpu, PSR_AA32_MODE_UND, 4);
+	post_fault_synchronize(vcpu, loaded);
 }
 
 /*
@@ -168,6 +191,9 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 	u32 vect_offset;
 	u32 *far, *fsr;
 	bool is_lpae;
+	bool loaded;
+
+	loaded = pre_fault_synchronize(vcpu);
 
 	if (is_pabt) {
 		vect_offset = 12;
@@ -191,6 +217,8 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
 		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
 		*fsr = DFSR_FSC_EXTABT_nLPAE;
 	}
+
+	post_fault_synchronize(vcpu, loaded);
 }
 
 void kvm_inject_dabt32(struct kvm_vcpu *vcpu, unsigned long addr)

