Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A62C312FD2
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 11:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhBHKzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 05:55:12 -0500
Received: from wforward2-smtp.messagingengine.com ([64.147.123.31]:50675 "EHLO
        wforward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230034AbhBHKwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 05:52:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 02DA294F;
        Mon,  8 Feb 2021 05:50:54 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 08 Feb 2021 05:50:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UiKylQ
        LAF2qzmLc2+gkEwGKL28/RWdRKS/ggdz0yQAw=; b=OI4JFsp+HAEB9bxu1SBU8H
        6BypkaLzDI6QnWvv5HHkmvlxPE4qwcW34G534JtjKEslDnTPlZbgqgesREp8wc7Z
        FXtovzZPZdZpz0dUelSeAH0Cs8r/YGp72SO/0TYDGCTVtnFhzzhSjjJn1AjFY8qr
        YjoB2SXqpT4r0glWS76qIFiMWotDyphbyY19MCq29LIaFhG6QsCD7j3taX99u01G
        moUR3T/NxPBG1hFc8u8j1tllCxVm3NIECZIG0mnECPJANBqgobS9iNyB+VfZteGr
        tydplB9O5u68mhXomW+7FZIFxRS8lTjp0+rhqhmZ8l80rzdcggPC3MmZX1jTpRXg
        ==
X-ME-Sender: <xms:jhchYDI3guLNwm6qZfo0J3mkyaiadsTn-wyKBsIoOpXztB2ooi7J_A>
    <xme:jhchYHKIFvV0nZEBRxHqcGst5ugYI09eVq0w3a4HBTvmkI3d5kPgCVR72DhebIA2_
    B5DyWy6pxqOuw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrheefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:jhchYLvcpjWtU4MyNq4iAKDiRv_koqt8uGVdREa2j0uoIrvYc6F_GA>
    <xmx:jhchYMZpo63M8Gi149dDxVmDv7INapmilMh8XJHAfYXyI4EOt5L2nQ>
    <xmx:jhchYKaxZzJevCCyBfwcOM4CwuRn4FCGAyzd0aU0eFy-pkrkZuyqcw>
    <xmx:jhchYDC27sH8SoZsXrwX2Jh8T35trOBi3C-lySAY0z7Ca7DEd7Ru56ZiQzg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1CE67240066;
        Mon,  8 Feb 2021 05:50:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: cleanup CR3 reserved bits checks" failed to apply to 5.10-stable tree
To:     pbonzini@redhat.com, seanjc@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 08 Feb 2021 11:50:51 +0100
Message-ID: <1612781451187139@kroah.com>
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

From c1c35cf78bfab31b8cb455259524395c9e4c7cd6 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 13 Nov 2020 08:30:38 -0500
Subject: [PATCH] KVM: x86: cleanup CR3 reserved bits checks

If not in long mode, the low bits of CR3 are reserved but not enforced to
be zero, so remove those checks.  If in long mode, however, the MBZ bits
extend down to the highest physical address bit of the guest, excluding
the encryption bit.

Make the checks consistent with the above, and match them between
nested_vmcb_checks and KVM_SET_SREGS.

Cc: stable@vger.kernel.org
Fixes: 761e41693465 ("KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests")
Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 7a605ad8254d..db30670dd8c4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -231,6 +231,7 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 
 static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool vmcb12_lma;
 
 	if ((vmcb12->save.efer & EFER_SVME) == 0)
@@ -244,18 +245,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 
 	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
 
-	if (!vmcb12_lma) {
-		if (vmcb12->save.cr4 & X86_CR4_PAE) {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
-				return false;
-		} else {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
-				return false;
-		}
-	} else {
+	if (vmcb12_lma) {
 		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
 		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
-		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
+		    (vmcb12->save.cr3 & vcpu->arch.cr3_lm_rsvd_bits))
 			return false;
 	}
 	if (!kvm_is_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 0fe874ae5498..6e7d070f8b86 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -403,9 +403,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
-#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
 extern int sev;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 42b28d0f0311..c1650e26715b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9624,6 +9624,8 @@ static bool kvm_is_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		 */
 		if (!(sregs->cr4 & X86_CR4_PAE) || !(sregs->efer & EFER_LMA))
 			return false;
+		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
+			return false;
 	} else {
 		/*
 		 * Not in 64-bit mode: EFER.LMA is clear and the code

