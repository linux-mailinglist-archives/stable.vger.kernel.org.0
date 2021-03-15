Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E1333ADDF
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhCOIsL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:48:11 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:39275 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhCOIsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:48:03 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B5C9E19404AC;
        Mon, 15 Mar 2021 04:48:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:48:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=cesjVf
        lp/A2h3cc872Pr/dVaumSOuYyTGtzQ455WDRU=; b=K7wHqqzug7GVg3irS64QLr
        2b4uQfyWfF5t5mUZwi+UJNHutAiq1z6rJi4pURnkR3GoxfXMgr2WPG9b1B0Q0RGV
        kGRkaYK/s56i0fi611890RJNTdxmqu6c8rEmRzlB0Mmjn2EIsTkh0B5DbQPIFDA+
        Ep0sjauqbOSR0+zuA1SVDNC4mY9iG2zEN73HRxu9fN5RCFV4mj47LhbAySElt36p
        htEbFPQbprvVEA+x07hubB4TnBDD3V1li43b7Yavg7c8Apxz/ZR3mqgYa23Adfc0
        Jk/s46hTrXlzlNdPgmsUMsqWj99FbK0aTS0siANuhTqygUvh7tXqGh54wUNMVO/Q
        ==
X-ME-Sender: <xms:Qh9PYPq_71tfgRRVJxSdyu95pfay_0UKNDR-GBswr1dLs-hutU-ebA>
    <xme:Qh9PYJp1_ZkNiXkTJjV8MHDxSJkrOAnq3ZMtFiXylsyQvACi31zUKNZ1hFRG2Blhl
    6KGZp9OUYnxNA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Qh9PYMPG6zVKsxWb4QhOMM8kEzLly5eq8tdrPrjR0a161Zwa728Teg>
    <xmx:Qh9PYC4_nmTaAdMeGr-IKUNlUUtcYJXtip19q6CWbyjkbcBWm8ctsg>
    <xmx:Qh9PYO7-z2IrMddyFl2OU6VvxdSpMI1eaA-aKRMp91IzEnnh8o-DHQ>
    <xmx:Qh9PYETCoBDDmfwpamiOSe3sMNezAol84j5YACwwfSAP0x31HOryQA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3878C240054;
        Mon, 15 Mar 2021 04:48:02 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a same" failed to apply to 5.10-stable tree
To:     maz@kernel.org, catalin.marinas@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:47:52 +0100
Message-ID: <1615798072186167@kroah.com>
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

From 01dc9262ff5797b675c32c0c6bc682777d23de05 Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Wed, 3 Mar 2021 16:45:05 +0000
Subject: [PATCH] KVM: arm64: Ensure I-cache isolation between vcpus of a same
 VM

It recently became apparent that the ARMv8 architecture has interesting
rules regarding attributes being used when fetching instructions
if the MMU is off at Stage-1.

In this situation, the CPU is allowed to fetch from the PoC and
allocate into the I-cache (unless the memory is mapped with
the XN attribute at Stage-2).

If we transpose this to vcpus sharing a single physical CPU,
it is possible for a vcpu running with its MMU off to influence
another vcpu running with its MMU on, as the latter is expected to
fetch from the PoU (and self-patching code doesn't flush below that
level).

In order to solve this, reuse the vcpu-private TLB invalidation
code to apply the same policy to the I-cache, nuking it every time
the vcpu runs on a physical CPU that ran another vcpu of the same
VM in the past.

This involve renaming __kvm_tlb_flush_local_vmid() to
__kvm_flush_cpu_context(), and inserting a local i-cache invalidation
there.

Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
Acked-by: Will Deacon <will@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20210303164505.68492-1-maz@kernel.org

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 9c0e396dd03f..a7ab84f781f7 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -47,7 +47,7 @@
 #define __KVM_HOST_SMCCC_FUNC___kvm_flush_vm_context		2
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid_ipa		3
 #define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_vmid		4
-#define __KVM_HOST_SMCCC_FUNC___kvm_tlb_flush_local_vmid	5
+#define __KVM_HOST_SMCCC_FUNC___kvm_flush_cpu_context		5
 #define __KVM_HOST_SMCCC_FUNC___kvm_timer_set_cntvoff		6
 #define __KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs			7
 #define __KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config		8
@@ -183,10 +183,10 @@ DECLARE_KVM_HYP_SYM(__bp_harden_hyp_vecs);
 #define __bp_harden_hyp_vecs	CHOOSE_HYP_SYM(__bp_harden_hyp_vecs)
 
 extern void __kvm_flush_vm_context(void);
+extern void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
 				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
-extern void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu);
 
 extern void __kvm_timer_set_cntvoff(u64 cntvoff);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index bb85da1d5880..a391b984dd05 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -385,11 +385,16 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	last_ran = this_cpu_ptr(mmu->last_vcpu_ran);
 
 	/*
+	 * We guarantee that both TLBs and I-cache are private to each
+	 * vcpu. If detecting that a vcpu from the same VM has
+	 * previously run on the same physical CPU, call into the
+	 * hypervisor code to nuke the relevant contexts.
+	 *
 	 * We might get preempted before the vCPU actually runs, but
 	 * over-invalidation doesn't affect correctness.
 	 */
 	if (*last_ran != vcpu->vcpu_id) {
-		kvm_call_hyp(__kvm_tlb_flush_local_vmid, mmu);
+		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
 		*last_ran = vcpu->vcpu_id;
 	}
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 8f129968204e..936328207bde 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -46,11 +46,11 @@ static void handle___kvm_tlb_flush_vmid(struct kvm_cpu_context *host_ctxt)
 	__kvm_tlb_flush_vmid(kern_hyp_va(mmu));
 }
 
-static void handle___kvm_tlb_flush_local_vmid(struct kvm_cpu_context *host_ctxt)
+static void handle___kvm_flush_cpu_context(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(struct kvm_s2_mmu *, mmu, host_ctxt, 1);
 
-	__kvm_tlb_flush_local_vmid(kern_hyp_va(mmu));
+	__kvm_flush_cpu_context(kern_hyp_va(mmu));
 }
 
 static void handle___kvm_timer_set_cntvoff(struct kvm_cpu_context *host_ctxt)
@@ -115,7 +115,7 @@ static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),
-	HANDLE_FUNC(__kvm_tlb_flush_local_vmid),
+	HANDLE_FUNC(__kvm_flush_cpu_context),
 	HANDLE_FUNC(__kvm_timer_set_cntvoff),
 	HANDLE_FUNC(__kvm_enable_ssbs),
 	HANDLE_FUNC(__vgic_v3_get_gic_config),
diff --git a/arch/arm64/kvm/hyp/nvhe/tlb.c b/arch/arm64/kvm/hyp/nvhe/tlb.c
index fbde89a2c6e8..229b06748c20 100644
--- a/arch/arm64/kvm/hyp/nvhe/tlb.c
+++ b/arch/arm64/kvm/hyp/nvhe/tlb.c
@@ -123,7 +123,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -131,6 +131,7 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 
diff --git a/arch/arm64/kvm/hyp/vhe/tlb.c b/arch/arm64/kvm/hyp/vhe/tlb.c
index fd7895945bbc..66f17349f0c3 100644
--- a/arch/arm64/kvm/hyp/vhe/tlb.c
+++ b/arch/arm64/kvm/hyp/vhe/tlb.c
@@ -127,7 +127,7 @@ void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_host(&cxt);
 }
 
-void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
+void __kvm_flush_cpu_context(struct kvm_s2_mmu *mmu)
 {
 	struct tlb_inv_context cxt;
 
@@ -135,6 +135,7 @@ void __kvm_tlb_flush_local_vmid(struct kvm_s2_mmu *mmu)
 	__tlb_switch_to_guest(mmu, &cxt);
 
 	__tlbi(vmalle1);
+	asm volatile("ic iallu");
 	dsb(nsh);
 	isb();
 

