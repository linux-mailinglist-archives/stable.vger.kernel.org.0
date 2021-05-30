Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40561395076
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 12:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhE3KsR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 06:48:17 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52321 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229579AbhE3KsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 06:48:17 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 28D491940104;
        Sun, 30 May 2021 06:46:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sun, 30 May 2021 06:46:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9HWV6l
        KThoH2knO3lBYY8xkXwWeIpe7qWHzxAnlVQLI=; b=rgRDhp/pp3U/05TYqQy8LJ
        7c51tGcwGso/uBIIgMNv65q//6nYM11rT00SyRFfQN16Z52Gy1xOkeNXQ8SQSpBR
        s7btA2Hrb4nmnKZlM+DVHlwntZ0o62jeETEL2ZhyW/+t5Cok04Kf3xpxS5v5xZq3
        heROl/MPoAXPMBKTFF4ny+YsIMKYVRRFKr1EuSq9zEyPcF/Rsm6xkwKJPa/WCIq+
        xMGkV5NocbQbx253bs1UCNUy3/9ryfYpnFe3UW/5Is8B8Y/a7GyWv6LYWchVg1br
        duHbj2hWfEOYUJvc7vPSHjBNhNdDPFGHWCF1XYnVX9HMQ0MdTGWyaOLPodV2Davg
        ==
X-ME-Sender: <xms:Dm2zYN6zFWB05WANxYcGgOgp-ttTPLRU8orDEIhy4mRtpnhNYGycmA>
    <xme:Dm2zYK4ldQVl1Vsiac8nLAReeFo88Ac2WpUJy74xshrLQz3c-UMbq_X16zBHdwIN9
    OW2-DFnV3qTIg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:Dm2zYEe3gypLblLDulBJNw_57K6MrJefu24qkolhFXzlbLlc7FUrXQ>
    <xmx:Dm2zYGI_Fj1Ep97rih3bv_V_MB30GTKXg5_py43qKofvU7Hb18ba1g>
    <xmx:Dm2zYBLNBqZFGgF2ahDgU2NUGX_QO_diiGEC0pQktiHHyjfGFhLY4Q>
    <xmx:D22zYPgUvdOWpZqi7zCAQWhnGSZm_hx-uIUNKSib0Kc5Y8rgHMbWxw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 06:46:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Commit pending PC adjustemnts before returning to" failed to apply to 5.12-stable tree
To:     maz@kernel.org, alexandru.elisei@arm.com, yuzenghui@huawei.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 12:46:36 +0200
Message-ID: <162237159654109@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 26778aaa134a9aefdf5dbaad904054d7be9d656d Mon Sep 17 00:00:00 2001
From: Marc Zyngier <maz@kernel.org>
Date: Thu, 6 May 2021 15:20:12 +0100
Subject: [PATCH] KVM: arm64: Commit pending PC adjustemnts before returning to
 userspace

KVM currently updates PC (and the corresponding exception state)
using a two phase approach: first by setting a set of flags,
then by converting these flags into a state update when the vcpu
is about to enter the guest.

However, this creates a disconnect with userspace if the vcpu thread
returns there with any exception/PC flag set. In this case, the exposed
context is wrong, as userspace doesn't have access to these flags
(they aren't architectural). It also means that these flags are
preserved across a reset, which isn't expected.

To solve this problem, force an explicit synchronisation of the
exception state on vcpu exit to userspace. As an optimisation
for nVHE systems, only perform this when there is something pending.

Reported-by: Zenghui Yu <yuzenghui@huawei.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org # 5.11

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index d5b11037401d..5e9b33cbac51 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -63,6 +63,7 @@
 #define __KVM_HOST_SMCCC_FUNC___pkvm_cpu_set_vector		18
 #define __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize		19
 #define __KVM_HOST_SMCCC_FUNC___pkvm_mark_hyp			20
+#define __KVM_HOST_SMCCC_FUNC___kvm_adjust_pc			21
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1cb39c0803a4..1126eae27400 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -897,6 +897,17 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 
 	kvm_sigset_deactivate(vcpu);
 
+	/*
+	 * In the unlikely event that we are returning to userspace
+	 * with pending exceptions or PC adjustment, commit these
+	 * adjustments in order to give userspace a consistent view of
+	 * the vcpu state. Note that this relies on __kvm_adjust_pc()
+	 * being preempt-safe on VHE.
+	 */
+	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
+					 KVM_ARM64_INCREMENT_PC)))
+		kvm_call_hyp(__kvm_adjust_pc, vcpu);
+
 	vcpu_put(vcpu);
 	return ret;
 }
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0812a496725f..11541b94b328 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -331,8 +331,8 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Adjust the guest PC on entry, depending on flags provided by EL1
- * for the purpose of emulation (MMIO, sysreg) or exception injection.
+ * Adjust the guest PC (and potentially exception state) depending on
+ * flags provided by the emulation code.
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f36420a80474..1632f001f4ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -28,6 +28,13 @@ static void handle___kvm_vcpu_run(struct kvm_cpu_context *host_ctxt)
 	cpu_reg(host_ctxt, 1) =  __kvm_vcpu_run(kern_hyp_va(vcpu));
 }
 
+static void handle___kvm_adjust_pc(struct kvm_cpu_context *host_ctxt)
+{
+	DECLARE_REG(struct kvm_vcpu *, vcpu, host_ctxt, 1);
+
+	__kvm_adjust_pc(kern_hyp_va(vcpu));
+}
+
 static void handle___kvm_flush_vm_context(struct kvm_cpu_context *host_ctxt)
 {
 	__kvm_flush_vm_context();
@@ -170,6 +177,7 @@ typedef void (*hcall_t)(struct kvm_cpu_context *);
 
 static const hcall_t host_hcall[] = {
 	HANDLE_FUNC(__kvm_vcpu_run),
+	HANDLE_FUNC(__kvm_adjust_pc),
 	HANDLE_FUNC(__kvm_flush_vm_context),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid_ipa),
 	HANDLE_FUNC(__kvm_tlb_flush_vmid),

