Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EF53826F2
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:25:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235636AbhEQI1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:27:04 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53801 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235599AbhEQI1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:27:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 2D22A9C0;
        Mon, 17 May 2021 04:25:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 17 May 2021 04:25:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ZWM0tG
        6Bmt7R+gf3CEJo4qonPhCyEQzV8HFV6pf0Fvk=; b=Lp/B7RJpsGTLk76tz9VUdL
        6yGzjynwC8f0qIU9eYaPcYDZPCkwxgaSbq0n5tjxT26uTVsLJCOQthYnr2wk1Cah
        EprMP7C6z9X8JQ4K7GVz0CVtK5o3mWHuLnXoi454Ug1jNiPdkMpfulTKxJpZhG+5
        aZo0BHOgkKmFLAOaowcp9wq8ym7ueqXFCCSqVcBKhdJlM5xfXPhjFLJg7zSg0Nom
        Ptq3pVwmiytdcX40sUfB+kd3a/zIFaU+atPNzsuEX00Sn3HQRB69Bf0vQllZFVq1
        0ea0ArVoUwnKglLaXjlNW4bepjp/aonPvSHpPhcL4bTuCYcWrITSHHGduk4dJ52w
        ==
X-ME-Sender: <xms:iiiiYA5FS1MUDSj-CVprE6pfV43ENUjP5uYw3hOgediF3DMTYaH5mQ>
    <xme:iiiiYB4X9SsB5X1VleAlbz9xBRuKku8o1qEg6M6OmR3hL0EZNCjl-Ivv8pKl3yhDo
    SFEoxVMy-e6xA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:iiiiYPcjKDVEcY6O3OKSk3OfigrXFytCvL7sdVIfaCu1e-evS_WS5g>
    <xmx:iiiiYFKm_lAyOQzlUHF2qmrrSZXrw1rU1SHrpj9AP4x0co_yQfK8BA>
    <xmx:iiiiYEJBtvHejY2k3dc6MWBJ3LxNb6mZ69LYgBhMj5_2LfmtUnIlPQ>
    <xmx:iiiiYOhpUa0IkeqLXopwa6fDL7zArVGTfvY5WAbsbv5L5B0g84YO--F2-eE>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:25:46 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: x86: Add support for RDPID without RDTSCP" failed to apply to 5.4-stable tree
To:     seanjc@google.com, pbonzini@redhat.com, reijiw@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:25:45 +0200
Message-ID: <162123994571197@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 36fa06f9ff39f23e03cd8206dc6bbb7711c23be6 Mon Sep 17 00:00:00 2001
From: Sean Christopherson <seanjc@google.com>
Date: Tue, 4 May 2021 10:17:26 -0700
Subject: [PATCH] KVM: x86: Add support for RDPID without RDTSCP

Allow userspace to enable RDPID for a guest without also enabling RDTSCP.
Aside from checking for RDPID support in the obvious flows, VMX also needs
to set ENABLE_RDTSCP=1 when RDPID is exposed.

For the record, there is no known scenario where enabling RDPID without
RDTSCP is desirable.  But, both AMD and Intel architectures allow for the
condition, i.e. this is purely to make KVM more architecturally accurate.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 13e4dd128177..0ba0a00f8dc6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2669,7 +2669,8 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (tsc_aux_uret_slot < 0)
 			return 1;
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2891,7 +2892,8 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 			return 1;
 
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 11ff9c3d95d5..b304e372aab3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1788,7 +1788,8 @@ static void setup_msrs(struct vcpu_vmx *vmx)
 	if (update_transition_efer(vmx))
 		vmx_setup_uret_msr(vmx, MSR_EFER);
 
-	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
+	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
 		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
 
 	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
@@ -1994,7 +1995,8 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
@@ -2314,7 +2316,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		/* Check reserved bit, higher 32 bits should be zero */
 		if ((data >> 32) != 0)
@@ -4368,7 +4371,23 @@ static void vmx_compute_secondary_exec_control(struct vcpu_vmx *vmx)
 						  xsaves_enabled, false);
 	}
 
-	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
+	/*
+	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
+	 * feature is exposed to the guest.  This creates a virtualization hole
+	 * if both are supported in hardware but only one is exposed to the
+	 * guest, but letting the guest execute RDTSCP or RDPID when either one
+	 * is advertised is preferable to emulating the advertised instruction
+	 * in KVM on #UD, and obviously better than incorrectly injecting #UD.
+	 */
+	if (cpu_has_vmx_rdtscp()) {
+		bool rdpid_or_rdtscp_enabled =
+			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		vmx_adjust_secondary_exec_control(vmx, &exec_control,
+						  SECONDARY_EXEC_ENABLE_RDTSCP,
+						  rdpid_or_rdtscp_enabled, false);
+	}
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index bd90c73c37b4..0856636efc44 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5941,7 +5941,8 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_TSC_AUX:
-			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
+			    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
 				continue;
 			break;
 		case MSR_IA32_UMWAIT_CONTROL:

