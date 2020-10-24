Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA26297BAF
	for <lists+stable@lfdr.de>; Sat, 24 Oct 2020 11:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1760493AbgJXJmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Oct 2020 05:42:20 -0400
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:34923 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756717AbgJXJmU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Oct 2020 05:42:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 96D73B44;
        Sat, 24 Oct 2020 05:42:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 24 Oct 2020 05:42:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NFmf6n
        OHqdHeOIxS/AUC938L5NmqdWFLIMhJ68Oyaww=; b=NgCj4WAIKlNP/gtjLMhzOs
        pRJySl0XGZUtTaeozfqSYCRfw2pSGUYG/ghiwsWU1Rd6SaSEimHubZweMzjWRaQ/
        4HgyeML2kC6U842LSCig0UOBlYb0CRJruITh4XHKA3OBrhA4fb1+Idn0p7Fv3ID9
        RPPJgJYWLp0m6ZnhWdGg5SQ17EVL9WYhP2lVyI6yobLLvzfbbnj06FrXoAYMWvFb
        wD4sxGSF9pWimXOhMcBE2103FUDS62nwOdbYLo+9PqWqrJUEukNAzs8jaQMhX5jP
        miurWMoLQrNPE+Zw2acdf5xMmOGBOqG/T7ZPHqtes/QQ5Z00UwEhHzSgvrMeEEPw
        ==
X-ME-Sender: <xms:-_aTX323A9Q1aHNiShycQjgWJPjQZI7jQhuo4fYdAQ3d-ljAhEC36w>
    <xme:-_aTX2GKoXHlUlWOi4mnqImtASDqlbcherOuzTTc5vUIy360Dc2reIDksC5Go-NRy
    sAZ2e0vn9cGdw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrkedvgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:-_aTX35p5yoydchdJrSslCcn5nLrh_A67uRhLPlm2FwkPAa1ykaMNw>
    <xmx:-_aTX82KWvagakUHrhIC8OSn3QMkgIQ7MTwJnpvYuUZHtxLwjHHqgQ>
    <xmx:-_aTX6ELgTTbp2LoLcIM7X_usfOMJj0ci7z6py3o8_KiKa9hoOWM5A>
    <xmx:-_aTX8NC2XsfsnJRMznb9n-nFHWKO5_BCzMXNvtNlTkQoLEulR2-9oq1pD4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCFD83064674;
        Sat, 24 Oct 2020 05:42:18 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: nVMX: Morph notification vector IRQ on nested VM-Enter" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, liran.alon@oracle.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 24 Oct 2020 11:42:51 +0200
Message-ID: <160353257163174@kroah.com>
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

From 25bb2cf97139f81e3bb8910d26016a529019528e Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Wed, 12 Aug 2020 10:51:29 -0700
Subject: [PATCH] KVM: nVMX: Morph notification vector IRQ on nested VM-Enter
 to pending PI

On successful nested VM-Enter, check for pending interrupts and convert
the highest priority interrupt to a pending posted interrupt if it
matches L2's notification vector.  If the vCPU receives a notification
interrupt before nested VM-Enter (assuming L1 disables IRQs before doing
VM-Enter), the pending interrupt (for L1) should be recognized and
processed as a posted interrupt when interrupts become unblocked after
VM-Enter to L2.

This fixes a bug where L1/L2 will get stuck in an infinite loop if L1 is
trying to inject an interrupt into L2 by setting the appropriate bit in
L2's PIR and sending a self-IPI prior to VM-Enter (as opposed to KVM's
method of manually moving the vector from PIR->vIRR/RVI).  KVM will
observe the IPI while the vCPU is in L1 context and so won't immediately
morph it to a posted interrupt for L2.  The pending interrupt will be
seen by vmx_check_nested_events(), cause KVM to force an immediate exit
after nested VM-Enter, and eventually be reflected to L1 as a VM-Exit.
After handling the VM-Exit, L1 will see that L2 has a pending interrupt
in PIR, send another IPI, and repeat until L2 is killed.

Note, posted interrupts require virtual interrupt deliveriy, and virtual
interrupt delivery requires exit-on-interrupt, ergo interrupts will be
unconditionally unmasked on VM-Enter if posted interrupts are enabled.

Fixes: 705699a13994 ("KVM: nVMX: Enable nested posted interrupt processing")
Cc: stable@vger.kernel.org
Cc: Liran Alon <liran.alon@oracle.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Message-Id: <20200812175129.12172-1-sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 51ed4f0b1390..105e7859d1f2 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -494,6 +494,12 @@ static inline void apic_clear_irr(int vec, struct kvm_lapic *apic)
 	}
 }
 
+void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec)
+{
+	apic_clear_irr(vec, vcpu->arch.apic);
+}
+EXPORT_SYMBOL_GPL(kvm_apic_clear_irr);
+
 static inline void apic_set_isr(int vec, struct kvm_lapic *apic)
 {
 	struct kvm_vcpu *vcpu;
@@ -2465,6 +2471,7 @@ int kvm_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	__apic_update_ppr(apic, &ppr);
 	return apic_has_interrupt_for_ppr(apic, ppr);
 }
+EXPORT_SYMBOL_GPL(kvm_apic_has_interrupt);
 
 int kvm_apic_accept_pic_intr(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 754f29beb83e..4fb86e3a9dd3 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -89,6 +89,7 @@ int kvm_lapic_reg_read(struct kvm_lapic *apic, u32 offset, int len,
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
+void kvm_apic_clear_irr(struct kvm_vcpu *vcpu, int vec);
 bool __kvm_apic_update_irr(u32 *pir, void *regs, int *max_irr);
 bool kvm_apic_update_irr(struct kvm_vcpu *vcpu, u32 *pir, int *max_irr);
 void kvm_apic_update_ppr(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 9861179d9a8c..f39491cc92c7 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3531,6 +3531,14 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
 		goto vmentry_failed;
 
+	/* Emulate processing of posted interrupts on VM-Enter. */
+	if (nested_cpu_has_posted_intr(vmcs12) &&
+	    kvm_apic_has_interrupt(vcpu) == vmx->nested.posted_intr_nv) {
+		vmx->nested.pi_pending = true;
+		kvm_make_request(KVM_REQ_EVENT, vcpu);
+		kvm_apic_clear_irr(vcpu, vmx->nested.posted_intr_nv);
+	}
+
 	/* Hide L1D cache contents from the nested guest.  */
 	vmx->vcpu.arch.l1tf_flush_l1d = true;
 

