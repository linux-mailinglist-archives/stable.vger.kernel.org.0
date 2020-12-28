Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79192E3568
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 10:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgL1JU4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 04:20:56 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:44609 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgL1JU4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 04:20:56 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id B3B4377B;
        Mon, 28 Dec 2020 04:19:50 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 28 Dec 2020 04:19:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OcNQJs
        ooQYU4HXDbwJ+sisM2r2xUB0lgko5+lUoNwoc=; b=YueaXXZtGdBegLaz02vGtw
        Q3ionJO8mzpTGJZfxcKrUQ4+c+5K10+VPfEMuI521K0n1219li9Vx0SPfsXaKCiC
        MhZDVaaxx8qe/suNZc0k4vauoCvbbYwDy3PF9R1bt76kxDDQPyAfLuzkoiS/ejQZ
        sRKnGdVR5nYZpueGqjNGffBhbth3cTwP0yM6gXVbL6r/4A9TTstB7+W2Gy5LSIgQ
        vbNvdMy05dY1G3motlcxi0Fv47f8Ja6auTKN/3t4k/oFOKkTPKF4bQiECmJEDa8F
        MNg/DWnFf6ZYtqgoWUBizuQY1EuSxLXzCBMRaeh7pclk9BSCbvyz+9M2DaL0jo6Q
        ==
X-ME-Sender: <xms:NaPpXzn5bV6Q2w-Y7thcY7RBUL3XVeg0Mavfy4mi2fLFRRoJ2OVyZg>
    <xme:NaPpX-RKGuM_WKfIgElhHUD8UajAC-T0MvE5Ig4dEpfBxzb2Nn0sJYK8k6354fDhw
    sFwW8OoExaLtw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdduledgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:NaPpX3DDKEjPwaS_lgXUdPox3tEMHxgg_6Fv8nFuqmAYmfm6wmW4og>
    <xmx:NaPpX1Ra_IzeKjFhGMyPIiKN2nRBgkroMyXBcPtVGZKVTQzkKvGhJQ>
    <xmx:NaPpX1ppa0iGLqEfVltC_7WPESqF7nzyqXvHTmO7VwMvNGa76Lx5Ng>
    <xmx:NqPpX9OSLH2mm3cJ7I7X46IU9VGe-XD2tzarYo05D9uIOH0gLvJB3pHwW3I>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 855D6240064;
        Mon, 28 Dec 2020 04:19:49 -0500 (EST)
Subject: FAILED: patch "[PATCH] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid" failed to apply to 4.19-stable tree
To:     pbonzini@redhat.com, den@openvz.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 28 Dec 2020 10:19:08 +0100
Message-ID: <16091471482430@kroah.com>
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

