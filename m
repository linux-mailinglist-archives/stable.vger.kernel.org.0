Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 079A81D7A2D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 15:39:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgERNji (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 09:39:38 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:46149 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726775AbgERNjh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 09:39:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id C903019405A2;
        Mon, 18 May 2020 09:39:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 09:39:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=0czYku
        aGaqhCJhOj7TkFW5w5Yyedxv1Qu68D37Q6Jns=; b=JB5pltGGmGjfA8atA4SQtB
        vFyBbTPshZsFObequwyyxu+Q97Z/bLBqp+y7eFNYw+uB05YqjTtPdwI8M/28kABA
        SwCHkb8GF66OteK/ilBDhRqjbydqksOgxgkpJXNjo5O+11SM+SSJeKbrBT0ZqHRy
        sF41EvDM9ONSCvnuLMCWzlmmms108osevur27V8a262gjDJ4pzL7CSUKWIZqW57X
        HEAFPEx24jctB7FoHCr76xvJU6vV3pNs3wEgbVocSHkIR8dl8A4EFmkoFlaPZEFo
        QL9+n4BVy7laI30v1ogHh15GPtH7mU/ZFaMH9QAYOyQ4mku2QSLQPufoQg48Mypg
        ==
X-ME-Sender: <xms:GJDCXpByuR_Ps0iJUUUkVlvYr0bDM2104My4TpvAupqIesyaI7K6cA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:GJDCXnhDmeNKtQc1wKxH0v1JH7nqk00wVeij2Pk_R0813y7Gs0f8sA>
    <xmx:GJDCXkni39RAxmY0QlI31cebirgMRdo4LjexBp5d7aZVsnwQ7gL0NQ>
    <xmx:GJDCXjxb0Pbx0h42lSc4S3u3nhgLHVJhIpset1W9KOCCEYEohQqagQ>
    <xmx:GJDCXn6fQbJ6toJa2wKvpMc4IDh4w_F0CLOKqReSlpZMb96ZElzY4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1F78D30663ED;
        Mon, 18 May 2020 09:39:36 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it" failed to apply to 5.4-stable tree
To:     babu.moger@amd.com, jmattson@google.com, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 15:39:34 +0200
Message-ID: <158980917424929@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 37486135d3a7b03acc7755b63627a130437f066a Mon Sep 17 00:00:00 2001
From: Babu Moger <babu.moger@amd.com>
Date: Tue, 12 May 2020 18:59:06 -0500
Subject: [PATCH] KVM: x86: Fix pkru save/restore when guest CR4.PKE=0, move it
 to x86.c

Though rdpkru and wrpkru are contingent upon CR4.PKE, the PKRU
resource isn't. It can be read with XSAVE and written with XRSTOR.
So, if we don't set the guest PKRU value here(kvm_load_guest_xsave_state),
the guest can read the host value.

In case of kvm_load_host_xsave_state, guest with CR4.PKE clear could
potentially use XRSTOR to change the host PKRU value.

While at it, move pkru state save/restore to common code and the
host_pkru field to kvm_vcpu_arch.  This will let SVM support protection keys.

Cc: stable@vger.kernel.org
Reported-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Message-Id: <158932794619.44260.14508381096663848853.stgit@naples-babu.amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9e8263b1e6fe..0a6b35353fc7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -578,6 +578,7 @@ struct kvm_vcpu_arch {
 	unsigned long cr4;
 	unsigned long cr4_guest_owned_bits;
 	unsigned long cr8;
+	u32 host_pkru;
 	u32 pkru;
 	u32 hflags;
 	u64 efer;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e45cf89c5821..89c766fad889 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1372,7 +1372,6 @@ void vmx_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vmx_vcpu_pi_load(vcpu, cpu);
 
-	vmx->host_pkru = read_pkru();
 	vmx->host_debugctlmsr = get_debugctlmsr();
 }
 
@@ -6564,11 +6563,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	kvm_load_guest_xsave_state(vcpu);
 
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
-	    vcpu->arch.pkru != vmx->host_pkru)
-		__write_pkru(vcpu->arch.pkru);
-
 	pt_guest_enter(vmx);
 
 	if (vcpu_to_pmu(vcpu)->version)
@@ -6658,18 +6652,6 @@ static void vmx_vcpu_run(struct kvm_vcpu *vcpu)
 
 	pt_guest_exit(vmx);
 
-	/*
-	 * eager fpu is enabled if PKEY is supported and CR4 is switched
-	 * back on host, so it is safe to read guest PKRU from current
-	 * XSAVE.
-	 */
-	if (static_cpu_has(X86_FEATURE_PKU) &&
-	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE)) {
-		vcpu->arch.pkru = rdpkru();
-		if (vcpu->arch.pkru != vmx->host_pkru)
-			__write_pkru(vmx->host_pkru);
-	}
-
 	kvm_load_host_xsave_state(vcpu);
 
 	vmx->nested.nested_run_pending = 0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 98176b80c481..d11eba8b85c6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -837,11 +837,25 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
+
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU)) &&
+	    vcpu->arch.pkru != vcpu->arch.host_pkru)
+		__write_pkru(vcpu->arch.pkru);
 }
 EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
 
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 {
+	if (static_cpu_has(X86_FEATURE_PKU) &&
+	    (kvm_read_cr4_bits(vcpu, X86_CR4_PKE) ||
+	     (vcpu->arch.xcr0 & XFEATURE_MASK_PKRU))) {
+		vcpu->arch.pkru = rdpkru();
+		if (vcpu->arch.pkru != vcpu->arch.host_pkru)
+			__write_pkru(vcpu->arch.host_pkru);
+	}
+
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE)) {
 
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -3549,6 +3563,9 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_x86_ops.vcpu_load(vcpu, cpu);
 
+	/* Save host pkru register if supported */
+	vcpu->arch.host_pkru = read_pkru();
+
 	/* Apply any externally detected TSC adjustments (due to suspend) */
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);

