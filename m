Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D681FAE71
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 12:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgFPKrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 06:47:46 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56015 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728259AbgFPKrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 06:47:46 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4865D1940845;
        Tue, 16 Jun 2020 06:47:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 16 Jun 2020 06:47:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=QROZPS
        AgXlgrHm5Za9arPXL8lyLLi+lPTffLNb/ZlL8=; b=FxOuZM+Mpdbv3Zud+XUW+9
        hgg2BrI7PSnOd5djiOKWOJkVUBpWlHEj6hznqI59FbXVnZi69+zEtGXaWLKt+DHH
        ymAPQEprSupdohLBgoxpWLXoFOz3wsZRNcstJFcsP/voljC2jzyZs/ezA1aWBMpV
        RhdjNbxSx/z8Q056cC+dVL4SQjzC0rscjzBLI5af+tEF8sIuTwNKnI2pYbjj9LEA
        3ZbvuwrAVuq1evLDWPni/ti/MyHNf2KhiM3IxgOWuTWe2hHGPzSkBpzGcGypYcVM
        6yW9IBBjUypdR6IoMdg1L9dhG/snMPNaCZ69s/lZKmvK+ZP4YE/5apiad+/3bEqw
        ==
X-ME-Sender: <xms:UaPoXqXhz2Dsaq1lMTcAHXNjKFJxF_xmhp21pKJXWYtuXdJeH3jAzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejtddgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:UaPoXmltT186K-MPerpxuNsHZ83QipeEIcfA8fgUkkgktcnGO5K76A>
    <xmx:UaPoXuZDStOIjJIAhC7nzfSr77wbt9jhIJnTzuTw8K_PvCjcIcHKng>
    <xmx:UaPoXhX5igALqmeC64UmHFANxwDANSKrg1e5zVfNaGhyAJfQmLo79w>
    <xmx:UaPoXmSEIhVBbSIt7NGv-7YmeI2hF8bdL4GSt4hJlm3SGwjxmMbxLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D8945328005A;
        Tue, 16 Jun 2020 06:47:44 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Save the host's PtrAuth keys in non-preemptible" failed to apply to 5.7-stable tree
To:     maz@kernel.org, mark.rutland@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 16 Jun 2020 12:47:39 +0200
Message-ID: <15923044597415@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.7-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ef3e40a7ea8dbe2abd0a345032cd7d5023b9684f Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 3 Jun 2020 18:24:01 +0100
Subject: [PATCH] KVM: arm64: Save the host's PtrAuth keys in non-preemptible
 context

When using the PtrAuth feature in a guest, we need to save the host's
keys before allowing the guest to program them. For that, we dump
them in a per-CPU data structure (the so called host context).

But both call sites that do this are in preemptible context,
which may end up in disaster should the vcpu thread get preempted
before reentering the guest.

Instead, save the keys eagerly on each vcpu_load(). This has an
increased overhead, but is at least safe.

Cc: stable@vger.kernel.org
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index a30b4eec7cb4..977843e4d5fb 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -112,12 +112,6 @@ static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
 	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
 }
 
-static inline void vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
-{
-	if (vcpu_has_ptrauth(vcpu))
-		vcpu_ptrauth_disable(vcpu);
-}
-
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.vsesr_el2;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d6988401c22a..152049c5055d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -337,6 +337,12 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 	preempt_enable();
 }
 
+#define __ptrauth_save_key(regs, key)						\
+({										\
+	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
+	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
+})
+
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	int *last_ran;
@@ -370,7 +376,17 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	else
 		vcpu_set_wfx_traps(vcpu);
 
-	vcpu_ptrauth_setup_lazy(vcpu);
+	if (vcpu_has_ptrauth(vcpu)) {
+		struct kvm_cpu_context *ctxt = vcpu->arch.host_cpu_context;
+
+		__ptrauth_save_key(ctxt->sys_regs, APIA);
+		__ptrauth_save_key(ctxt->sys_regs, APIB);
+		__ptrauth_save_key(ctxt->sys_regs, APDA);
+		__ptrauth_save_key(ctxt->sys_regs, APDB);
+		__ptrauth_save_key(ctxt->sys_regs, APGA);
+
+		vcpu_ptrauth_disable(vcpu);
+	}
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index eb194696ef62..065251efa2e6 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -162,31 +162,16 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
 	return 1;
 }
 
-#define __ptrauth_save_key(regs, key)						\
-({										\
-	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
-	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
-})
-
 /*
  * Handle the guest trying to use a ptrauth instruction, or trying to access a
  * ptrauth register.
  */
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
 {
-	struct kvm_cpu_context *ctxt;
-
-	if (vcpu_has_ptrauth(vcpu)) {
+	if (vcpu_has_ptrauth(vcpu))
 		vcpu_ptrauth_enable(vcpu);
-		ctxt = vcpu->arch.host_cpu_context;
-		__ptrauth_save_key(ctxt->sys_regs, APIA);
-		__ptrauth_save_key(ctxt->sys_regs, APIB);
-		__ptrauth_save_key(ctxt->sys_regs, APDA);
-		__ptrauth_save_key(ctxt->sys_regs, APDB);
-		__ptrauth_save_key(ctxt->sys_regs, APGA);
-	} else {
+	else
 		kvm_inject_undefined(vcpu);
-	}
 }
 
 /*

