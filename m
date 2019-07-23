Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB1A17162B
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 12:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388008AbfGWKgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 06:36:03 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:37977 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732540AbfGWKgD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 06:36:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id F2F8B520;
        Tue, 23 Jul 2019 06:36:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 06:36:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=X9LaDL
        w9Zu7h8c/jax9m8lLIIKMwMPRh01JR5pzvmZE=; b=l2Rh36BOP2zXaRqVvyqurM
        J/sScoP/YrdJ6w/2vnLGsyekt5CN3goFAFqYhPwZsKhXjKdSi4LPkyrccoiybT/w
        L7pNY4qmKLUhAG1SAuxtO+I6JvWJY3Oac4c9uHrOKkIEa/t5XaCObf2NHQwjEGh4
        6Wd5E02BNh23N//qdp007jE2IGgbAX9RITROgfLJyxCvqN3B8x2yVOcKSQvlmxYN
        jZpHl3qQ9+0iu5TAXrUvd8n94/6Z6WiTjQRKMfDG5hpLtCmathyL+EIJZH8v3oQI
        ssH8E4NbeGg0nau7E4DiGm6+Ihcga1PVxuVz4Uq5AS5XUh3hGlj6KYF9X+w4EK4w
        ==
X-ME-Sender: <xms:EeM2XYTTKUrNgI84VORG-rPOh7zBQ0s6Z5hdQCTz7FXAXI6eo5PFJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdefudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinheprghpfhdrhhhoshhtnecukfhppeekfedrkeeirdekledruddtje
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehl
    uhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:EeM2XTInHPie91yiBcq1kUM9J1puKkm1TlfSeEey97wIp0reoW7gBQ>
    <xmx:EeM2XbBWSXmn3OxknVEwxDgDI7c2vZUUiFzDjF7cLBdm01sOXDk0rg>
    <xmx:EeM2XZYjMWU7m9Uv5h-FKPVRJBQRyNE45hTRr6RoPrmg3iZfL9NHMg>
    <xmx:EeM2XZ3lzoXt9yQL-fEMcbTkxeuPIGfgpsjs_ZbzNQH0gQ-CPJIdmA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DD83380076;
        Tue, 23 Jul 2019 06:36:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: VMX: Fix handling of #MC that occurs during VM-Entry" failed to apply to 4.19-stable tree
To:     sean.j.christopherson@intel.com, jmattson@google.com,
        pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 12:33:26 +0200
Message-ID: <156387800610585@kroah.com>
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

From beb8d93b3e423043e079ef3dda19dad7b28467a8 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <sean.j.christopherson@intel.com>
Date: Fri, 19 Apr 2019 22:50:55 -0700
Subject: [PATCH] KVM: VMX: Fix handling of #MC that occurs during VM-Entry

A previous fix to prevent KVM from consuming stale VMCS state after a
failed VM-Entry inadvertantly blocked KVM's handling of machine checks
that occur during VM-Entry.

Per Intel's SDM, a #MC during VM-Entry is handled in one of three ways,
depending on when the #MC is recognoized.  As it pertains to this bug
fix, the third case explicitly states EXIT_REASON_MCE_DURING_VMENTRY
is handled like any other VM-Exit during VM-Entry, i.e. sets bit 31 to
indicate the VM-Entry failed.

If a machine-check event occurs during a VM entry, one of the following occurs:
 - The machine-check event is handled as if it occurred before the VM entry:
        ...
 - The machine-check event is handled after VM entry completes:
        ...
 - A VM-entry failure occurs as described in Section 26.7. The basic
   exit reason is 41, for "VM-entry failure due to machine-check event".

Explicitly handle EXIT_REASON_MCE_DURING_VMENTRY as a one-off case in
vmx_vcpu_run() instead of binning it into vmx_complete_atomic_exit().
Doing so allows vmx_vcpu_run() to handle VMX_EXIT_REASONS_FAILED_VMENTRY
in a sane fashion and also simplifies vmx_complete_atomic_exit() since
VMCS.VM_EXIT_INTR_INFO is guaranteed to be fresh.

Fixes: b060ca3b2e9e7 ("kvm: vmx: Handle VMLAUNCH/VMRESUME failure properly")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5d903f8909d1..1b3ca0582a0c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -6107,28 +6107,21 @@ static void vmx_apicv_post_state_restore(struct kvm_vcpu *vcpu)
 
 static void vmx_complete_atomic_exit(struct vcpu_vmx *vmx)
 {
-	u32 exit_intr_info = 0;
-	u16 basic_exit_reason = (u16)vmx->exit_reason;
-
-	if (!(basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY
-	      || basic_exit_reason == EXIT_REASON_EXCEPTION_NMI))
+	if (vmx->exit_reason != EXIT_REASON_EXCEPTION_NMI)
 		return;
 
-	if (!(vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
-		exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
-	vmx->exit_intr_info = exit_intr_info;
+	vmx->exit_intr_info = vmcs_read32(VM_EXIT_INTR_INFO);
 
 	/* if exit due to PF check for async PF */
-	if (is_page_fault(exit_intr_info))
+	if (is_page_fault(vmx->exit_intr_info))
 		vmx->vcpu.arch.apf.host_apf_reason = kvm_read_and_reset_pf_reason();
 
 	/* Handle machine checks before interrupts are enabled */
-	if (basic_exit_reason == EXIT_REASON_MCE_DURING_VMENTRY ||
-	    is_machine_check(exit_intr_info))
+	if (is_machine_check(vmx->exit_intr_info))
 		kvm_machine_check();
 
 	/* We need to handle NMIs before interrupts are enabled */
-	if (is_nmi(exit_intr_info)) {
+	if (is_nmi(vmx->exit_intr_info)) {
 		kvm_before_interrupt(&vmx->vcpu);
 		asm("int $2");
 		kvm_after_interrupt(&vmx->vcpu);
@@ -6535,6 +6528,9 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	vmx->idt_vectoring_info = 0;
 
 	vmx->exit_reason = vmx->fail ? 0xdead : vmcs_read32(VM_EXIT_REASON);
+	if ((u16)vmx->exit_reason == EXIT_REASON_MCE_DURING_VMENTRY)
+		kvm_machine_check();
+
 	if (vmx->fail || (vmx->exit_reason & VMX_EXIT_REASONS_FAILED_VMENTRY))
 		return;
 

