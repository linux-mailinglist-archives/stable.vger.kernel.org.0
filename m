Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC76380D6C
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 17:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234944AbhENPj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 11:39:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:41287 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234951AbhENPjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 11:39:12 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id E4B0319406BA;
        Fri, 14 May 2021 11:37:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 14 May 2021 11:37:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EnSiz9
        e/PTQrITVA4lCYryT3PjkV7kk3V3V8ZoGYMoc=; b=PrHN5BtJ6yRLAjYLbh2JxN
        gIbCoTI2UcuQgJjUSsvjEp8tdJ+gPMWbHjm2XuVqEOXJyblpmkAa8AnVVEngUAca
        vxE5s0HflEPZCy1lMjUkJzam+zsULrFUopP9YeJjR34zHxkIlMJ8xqybhn6gOU3o
        ov5JIzN2utQN93/s8Eo6eRkgfz+8pa4pxq5w7xCIlrO5cRegCmYGco74Rg7DcgrO
        yPwXgriV1DlBEkV6qW3qQdju4ycpYKBz6Qrulqh5FW6bzh15uR3H0Hhcpc5oegOj
        NTNWIbPIVfOoQNeIZf4IzfYqczU5ZNv/fBCPNiQX/adfjrzX0It6dp0WO0E3U1/w
        ==
X-ME-Sender: <xms:V5meYMneLB8ZbFIYv4c7wPVocMttUZgHHa7FqtagrVR_jd3qHvEarQ>
    <xme:V5meYL2NhY1GykoYLVMNzr7gvtWrL_YgTyF3O9JtHL74hxQk1xBAwAS3t4Z9s9N4d
    9TWNvffc4AdOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgvdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:V5meYKp_0cYLPlSW_nncFV-fd9QZh0APsUUPbmj4nb6w0eNauRLEug>
    <xmx:V5meYImDgUExlI0NR4kO6lNo0Zb1GHKyui_MlyV7GlrjqFOXFUuCDA>
    <xmx:V5meYK3b4YwYDEsUgEH39zxSLC7aLQ4szCRpHdyGRnS44Mu9B17MLQ>
    <xmx:V5meYP8WiBd5xMdaNsPM1T0CigIwNLlgg9pFf2rJDMsNRSPoPldGCg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 11:37:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til after IRQ handling" failed to apply to 5.10-stable tree
To:     wanpengli@tencent.com, seanjc@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 17:37:56 +0200
Message-ID: <1621006676203106@kroah.com>
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

From 160457140187c5fb127b844e5a85f87f00a01b14 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpengli@tencent.com>
Date: Tue, 4 May 2021 17:27:30 -0700
Subject: [PATCH] KVM: x86: Defer vtime accounting 'til after IRQ handling

Defer the call to account guest time until after servicing any IRQ(s)
that happened in the guest or immediately after VM-Exit.  Tick-based
accounting of vCPU time relies on PF_VCPU being set when the tick IRQ
handler runs, and IRQs are blocked throughout the main sequence of
vcpu_enter_guest(), including the call into vendor code to actually
enter and exit the guest.

This fixes a bug where reported guest time remains '0', even when
running an infinite loop in the guest:

  https://bugzilla.kernel.org/show_bug.cgi?id=209831

Fixes: 87fa7f3e98a131 ("x86/kvm: Move context tracking where it belongs")
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210505002735.1684165-4-seanjc@google.com

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9790c73f2a32..c400def6220b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3753,15 +3753,15 @@ static noinstr void svm_vcpu_enter_exit(struct kvm_vcpu *vcpu)
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b21d751407b5..e108fb47855b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6703,15 +6703,15 @@ static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 	 * have them in state 'on' as recorded before entering guest mode.
 	 * Same as enter_from_user_mode().
 	 *
-	 * guest_exit_irqoff() restores host context and reinstates RCU if
-	 * enabled and required.
+	 * context_tracking_guest_exit() restores host context and reinstates
+	 * RCU if enabled and required.
 	 *
 	 * This needs to be done before the below as native_read_msr()
 	 * contains a tracepoint and x86_spec_ctrl_restore_host() calls
 	 * into world and some more.
 	 */
 	lockdep_hardirqs_off(CALLER_ADDR0);
-	guest_exit_irqoff();
+	context_tracking_guest_exit();
 
 	instrumentation_begin();
 	trace_hardirqs_off_finish();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index cebdaa1e3cf5..6eda2834fc05 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9315,6 +9315,15 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	local_irq_disable();
 	kvm_after_interrupt(vcpu);
 
+	/*
+	 * Wait until after servicing IRQs to account guest time so that any
+	 * ticks that occurred while running the guest are properly accounted
+	 * to the guest.  Waiting until IRQs are enabled degrades the accuracy
+	 * of accounting via context tracking, but the loss of accuracy is
+	 * acceptable for all known use cases.
+	 */
+	vtime_account_guest_exit();
+
 	if (lapic_in_kernel(vcpu)) {
 		s64 delta = vcpu->arch.apic->lapic_timer.advance_expire_delta;
 		if (delta != S64_MIN) {

