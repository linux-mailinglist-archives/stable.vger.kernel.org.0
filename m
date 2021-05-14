Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6295D380D70
	for <lists+stable@lfdr.de>; Fri, 14 May 2021 17:38:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbhENPkC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 May 2021 11:40:02 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:33407 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234660AbhENPkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 May 2021 11:40:02 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8F39119406DA;
        Fri, 14 May 2021 11:38:50 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 14 May 2021 11:38:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=v0yxGF
        bB3DH5Z6bLR/uoxlDeS7WkN1EDaQiC/JPJ7t4=; b=eA8zmzzFIMepThOjY4Pqwc
        sJLLGa2et/MjjE+U0P6As8v7UbeA7gPs29ojSHoMa74GptZDdDCypKA4blbegZcB
        vW5nRLYQoAwfa9B1X5J3Vu251o8WMwd7mPtBFUMxu2aa3DjPMepVnQ+Uz8HXA1tD
        m06J6v/2nD4H47KMhHBjIkgM+IIMj40cXZv/yQjD5OmJJag3tNBqbw1JYhorI74F
        ZKwxs6/Hi44yfpkC4wwT+tKjWSapjJiWTIF8r3nx2YxCQ5z7NCyTMPhy6z+QUMew
        zikrgQg27sRP3/rPr8DqNbOapFoE0ddJErstwcVyi56goOQ72jqTLwXqG+9mJ3dA
        ==
X-ME-Sender: <xms:ipmeYM1t5s0rchxjEm3Mcx_TMI535QtvEWnZZrx73xNGJB669vrZHA>
    <xme:ipmeYHEKtfgU_05QCk0W1rZ2RkFpqRNOn-4-DDEj6bYhR2EnR7CM9FhK9BQL20tGQ
    tv1CTbmGvuPrA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehjedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ipmeYE5QAyK1Qic8RjD-gLVuUCHcuNGqn78ryYLK4HDPlb2xj7SGIQ>
    <xmx:ipmeYF2xWmaJeIaFM_5Q53Q-WzpbhaZ_4YpAiqPma-BOpIbIe4QOpA>
    <xmx:ipmeYPHW9nMESNfXgsjZBXHuE3uTinnJV4-siZbtFJEHUwsOtKjjbw>
    <xmx:ipmeYFOroQa09CXeO8Hma99AsRf3MiZ2ZWHJQHRX0_uJHI2e6GVs1Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 11:38:49 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Defer vtime accounting 'til after IRQ handling" failed to apply to 5.12-stable tree
To:     wanpengli@tencent.com, seanjc@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 14 May 2021 17:38:39 +0200
Message-ID: <162100671955130@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
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

