Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C5BE2E3563
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:20:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgL1JUL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:20:11 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:52393 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726509AbgL1JUK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:20:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id C38AB6F3;
        Mon, 28 Dec 2020 04:19:04 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 28 Dec 2020 04:19:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=rQm2+4
        vfV9w9MnkAihqiNT0TA4EjdsAs7h+ADda1dHA=; b=MBHL8CJkMLmLrzk+dMInUi
        +VWfgUe3cThkkE8BYSsLsPQL0lQCXag617cjgvNg97sSJeCGdgrx3Aa6p37VeN6M
        49JqzJuZB//M6ruTljMk95Jib4zLK2MAFYfL6cD2tPn974AN4ALAUbuKi5qUrx5z
        sVgd7m4KvL2rJUDnnYlekjDBZR1MAyMeqEr+GCqZf7s6EfT+dYPwrD9HYv53xFXK
        jz6IxkUXh7AgCbU4FxTXgD2+Dt6q2T87gMrvNA5/jBrTAvdUqxO+LWRaWziYXJZB
        +kYjOw1WRGzJe/7FOTkB90vYr7Oe65QWfRX/oj53+XBSGsToB9wJPhscYsJ42f/Q
        ==
X-ME-Sender: <xms:B6PpX2BGqnCNac8CFNdlso4V3OC4PZ5x-iJABcOloymLqSlekOv8WA>
    <xme:B6PpXwhTMFxEBmTfUEofVCDWjbcsMQ-QqY9nd7NMKW2jliK2qKi46x0nDHvxMHObX
    Iog0pd8sPAINg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:B6PpX5ni7B30Lq7vhJWax5AnbiEnkfJ1WN3DnJl0ppcOxCENWRoq2A>
    <xmx:B6PpX0xdYWnvFtH0QNbOyXcvYqoyH5S-CBOHfn85ZCY5satQ3VBeMg>
    <xmx:B6PpX7TFmn7_yxOToOiooy6iZvwECUCaFC9fycNvyNdBbhVXZpBK-A>
    <xmx:CKPpX85ZsOsLK6WCO1Tx5ac6MuTtLZbrvOqGKpyoN-w6s5NcD7UlfRWjDEo>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1A6FE24005D;
        Mon, 28 Dec 2020 04:19:03 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid" failed to apply to 4.4-stable tree
To:     pbonzini@redhat.com, den@openvz.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:19:06 +0100
Message-ID: <160914714610512@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
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

