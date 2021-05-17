Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3768738275D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbhEQIsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:48:09 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:44317 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235621AbhEQIsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:48:09 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.west.internal (Postfix) with ESMTP id 9BD029DD;
        Mon, 17 May 2021 04:46:52 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 17 May 2021 04:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=kDkK4G
        tvcQ4N495TpheUOKZCAftYqzpXx8pPU9jtbM0=; b=iybld63xD5L0LKxaMba0BH
        l1OPUtpkimTljFk56bXO+oFEnCXYEW6Yr8bjb7kap7h8nsr3SPXPT2qZl/0XGnBz
        zh9tT93/g0pt7D4JOSQc6BVBDeyhZtY4N8YKa8WgshaCRGTBMTFIBjOS4nX8eW5q
        QwvnhGUTsv19kgLFREnUHgff83XcMZMGt6S771YamU6PkhMKRwjdVUXPKdKay9Q1
        1y7eaelXpLDMlF3CsKEooFxU68KFi7M5uwZMUhZ6ZOgpmSH5BZckqj6e8mctJFa9
        LeaO7SbKECw2J3p+KkgJUODpFL90bABk/E4LrNrA7b78XJQH5qHxubttYIJJzOfQ
        ==
X-ME-Sender: <xms:fC2iYJYIccYRrusBKS-RBJY2h4HEgAFs0Mus7xG8w8gaAfeJncuNkw>
    <xme:fC2iYAaIFVJbGGEMWZTZirce02-ya5SPMZFFR7Zw30fiOOPrHOL_PC7_1qXS-ueet
    MwcEbLC3yls2w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:fC2iYL-mSNx1XF_dzpuFKlUrS__RB_-LpNXJfXDL77nogWxfhWlI0A>
    <xmx:fC2iYHoFtq-PvnsXXsSYrEQogGkmr_PZMuiuQ4bne56v_sdaF7EkJg>
    <xmx:fC2iYEq1J24etbp_kCu607xjFrC5nq6jueh0qOojavqQfZKYFNR5ig>
    <xmx:fC2iYL1hNMPpiMJCDR5-EykpZMwAm-0vjzfl6snb9_qHQLqa-qiRI4tQpDs>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:46:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: SVM: Inject #UD on RDTSCP when it should be disabled in" failed to apply to 4.14-stable tree
To:     seanjc@google.com, jmattson@google.com, pbonzini@redhat.com,
        reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:46:42 +0200
Message-ID: <1621241202156252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

