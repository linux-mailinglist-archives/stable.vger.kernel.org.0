Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A3F2E3567
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgL1JUk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:20:40 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52801 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:20:39 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id E5A6B75A;
        Mon, 28 Dec 2020 04:19:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:19:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=33Fnj9
        MDdEwTZcYpLUxPdffh8hIkTmEqdKjPvQShIgg=; b=Wt3sZfkoOPZq2Qb7cThYvQ
        UWU/Nc5fFDRl54Nh/xKRT4UFtw1BpHAqwDQe5HAmFYdf+wCcC/ndMKpk1vpVpu8Q
        9cur0MjDaDZtFSXKM5YQBfmMD/CzcrBDnJz6e6IpMeFS+P0hM8t130EIUjNPp+v4
        e1tD2fdToo/sFdKfquS6y2druIBsCujuEeYJ1ea5LjBGWMLzJlq2VB6nasGKSLNZ
        yOv15gRQgwn5gyHnIuA0zjjUHoz7W6+QVmWfcl5uzgyNNRaXkF/c9fPzdCPuRzlr
        ZuKVfAOCuIWi3ysEKtfrdr22vDlQINuEwk80zaa1dMx3IXwr82q8CGA261yR8Pdg
        ==
X-ME-Sender: <xms:OaPpX8JS0EHfnDFoS8tQPfcw2w1o48mD52FdgfNzFYqCQfLRNfCtOw>
    <xme:OaPpX8Kk2_7rVrCIqewkTiLgwX0X6xifylY4bw2TV0ZZ0WZGG0Wji438Mj99fgBBT
    PLcNcF8oJzMxA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:OaPpX8vKw--v5nfOOak7S0MjdAdYLZuIlVntAh8z7zLfDiPETV5BsQ>
    <xmx:OaPpX5Yml0CCf3O7J6-U2tNTuJhQEiz0MdtQPajazzAjH8UfA012Lw>
    <xmx:OaPpXzb2kS84SB33gbP-e-PbUWMjwZAQRp0W2L1A_dG6m1a6fk3woQ>
    <xmx:OaPpX0BW1Q9Wbxoye7XapDPx-bRs93aPOTpJ8SI68fXmEGCEVTaFB--LMuw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3DCB024005B;
        Mon, 28 Dec 2020 04:19:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid" failed to apply to 4.9-stable tree
To:     pbonzini@redhat.com, den@openvz.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:19:06 +0100
Message-ID: <1609147146238226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 39485ed95d6b83b62fa75c06c2c4d33992e0d971 Mon Sep 17 00:00:00 2001
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 3 Dec 2020 09:40:15 -0500
Subject: [PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid
 bits

Until commit e7c587da1252 ("x86/speculation: Use synthetic bits for
IBRS/IBPB/STIBP"), KVM was testing both Intel and AMD CPUID bits before
allowing the guest to write MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.
Testing only Intel bits on VMX processors, or only AMD bits on SVM
processors, fails if the guests are created with the "opposite" vendor
as the host.

While at it, also tweak the host CPU check to use the vendor-agnostic
feature bit X86_FEATURE_IBPB, since we only care about the availability
of the MSR on the host here and not about specific CPUID bits.

Fixes: e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP")
Cc: stable@vger.kernel.org
Reported-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index f7a6e8f83783..dc921d76e42e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -264,6 +264,20 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
 	return x86_stepping(best->eax);
 }
 
+static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+}
+
+static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB));
+}
+
 static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 6dc337b9c231..0e52fac4f5ae 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2545,10 +2545,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		msr_info->data = svm->spec_ctrl;
@@ -2632,10 +2629,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (kvm_spec_ctrl_test_value(data))
@@ -2660,12 +2654,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
+		    !guest_has_pred_cmd_msr(vcpu))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index c3441e7e5a87..4b854a197e44 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1826,7 +1826,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		msr_info->data = to_vmx(vcpu)->spec_ctrl;
@@ -2028,7 +2028,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (kvm_spec_ctrl_test_value(data))
@@ -2063,12 +2063,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		goto find_uret_msr;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_pred_cmd_msr(vcpu))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;

