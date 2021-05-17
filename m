Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7BA938276F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235456AbhEQItA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:49:00 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:47725 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232924AbhEQItA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:49:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B70489DD;
        Mon, 17 May 2021 04:47:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 17 May 2021 04:47:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=fdhM/7
        SiPeFf3RVo45DlpNoha4oV65QRWcMQm0XGj/Y=; b=rMabsWIsAIXx3tibgQprC8
        XA4LIAzCK+HgpDg9Jmb97PT+jY/aTbikS0JsHFRq3BuKAIBJC/HhE1VxEACUK/9r
        9cMMRhPpqTl3yf7ViXB0Nluu/1N7E59XPhCGW4RdBkHpPeYlmT8JH0lSYhM4ShmH
        oCceCP5oKiothezTKV0ysJBXBbWVQR/2I9q4PSpBa7d7Nu0NIWE0FBNuCEw2c+8w
        LHH1SJfMI8OfGni7vuzzXvX61Wj78rvgs8pgPH0Npi1jv8Rgh7dbM6sG6U1iqTY5
        ELPxpTR8aemySpca1qDSxQ6jHzKMuHL213DKsv98gocMp5TqHDXb5H5lh0Bp04Qw
        ==
X-ME-Sender: <xms:ry2iYPyiXmhka2MosEO0SjryP342bsHcw4LFJtuayO4nYZXkG-96Wg>
    <xme:ry2iYHTp_4Y0ZnNtvOzFm-F3Ha9CcVZx2A6gBkRRDei9zj5u0ueeYca15-0dmHHk2
    auqff4KIL9vVg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ry2iYJX2BC3hIqCjkX5hthcHeGm_bVan5rygkWn6ASs_Alml_03NtA>
    <xmx:ry2iYJhH5mz_E5-xlp1QqOrU92d8X9TnqvRp6DzsQVja27thAr7rlw>
    <xmx:ry2iYBDQwk6jUfmbUu-QR19HvZy_2oB2z6feJnabg0kvI1bQjx9V3w>
    <xmx:ry2iYEPPceUph4HQvyUzMVm8VVbcykNIplWGQDTp1-kL5J5DGygYYoF5AgM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:47:42 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Inject #UD on RDTSCP when it should be disabled in" failed to apply to 5.11-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com,
        reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:47:41 +0200
Message-ID: <16212412613228@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3b195ac9260235624b1c18f7bdaef184479c1d41 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:22 -0700
Subject: [PATCH] KVM: SVM: Inject #UD on RDTSCP when it should be disabled in
 the guest

Intercept RDTSCP to inject #UD if RDTSC is disabled in the guest.

Note, SVM does not support intercepting RDPID.  Unlike VMX's
ENABLE_RDTSCP control, RDTSCP interception does not apply to RDPID.  This
is a benign virtualization hole as the host kernel (incorrectly) sets
MSR_TSC_AUX if RDTSCP is supported, and KVM loads the guest's MSR_TSC_AUX
into hardware if RDTSCP is supported in the host, i.e. KVM will not leak
the host's MSR_TSC_AUX to the guest.

But, when the kernel bug is fixed, KVM will start leaking the host's
MSR_TSC_AUX if RDPID is supported in hardware, but RDTSCP isn't available
for whatever reason.  This leak will be remedied in a future commit.

Fixes: 46896c73c1a4 ("KVM: svm: add support for RDTSCP")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-4-seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index be5cf612ab1f..ebcb5849d69b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1100,7 +1100,9 @@ static u64 svm_write_l1_tsc_offset(struct kvm_vcpu *vcpu, u64 offset)
 	return svm->vmcb->control.tsc_offset;
 }
 
-static void svm_check_invpcid(struct vcpu_svm *svm)
+/* Evaluate instruction intercepts that depend on guest CPUID features. */
+static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
+					      struct vcpu_svm *svm)
 {
 	/*
 	 * Intercept INVPCID if shadow paging is enabled to sync/free shadow
@@ -1113,6 +1115,13 @@ static void svm_check_invpcid(struct vcpu_svm *svm)
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
 	}
+
+	if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP)) {
+		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
+		else
+			svm_set_intercept(svm, INTERCEPT_RDTSCP);
+	}
 }
 
 static void init_vmcb(struct kvm_vcpu *vcpu)
@@ -1248,7 +1257,7 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm_clr_intercept(svm, INTERCEPT_PAUSE);
 	}
 
-	svm_check_invpcid(svm);
+	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/*
 	 * If the host supports V_SPEC_CTRL then disable the interception
@@ -3084,6 +3093,7 @@ static int (*const svm_exit_handlers[])(struct kvm_vcpu *vcpu) = {
 	[SVM_EXIT_STGI]				= stgi_interception,
 	[SVM_EXIT_CLGI]				= clgi_interception,
 	[SVM_EXIT_SKINIT]			= skinit_interception,
+	[SVM_EXIT_RDTSCP]			= kvm_handle_invalid_op,
 	[SVM_EXIT_WBINVD]                       = kvm_emulate_wbinvd,
 	[SVM_EXIT_MONITOR]			= kvm_emulate_monitor,
 	[SVM_EXIT_MWAIT]			= kvm_emulate_mwait,
@@ -4007,8 +4017,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	svm->nrips_enabled = kvm_cpu_cap_has(X86_FEATURE_NRIPS) &&
 			     guest_cpuid_has(vcpu, X86_FEATURE_NRIPS);
 
-	/* Check again if INVPCID interception if required */
-	svm_check_invpcid(svm);
+	svm_recalc_instruction_intercepts(vcpu, svm);
 
 	/* For sev guests, the memory encryption bit is not reserved in CR3.  */
 	if (sev_guest(vcpu->kvm)) {

