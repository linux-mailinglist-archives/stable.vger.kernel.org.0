Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 046F533ADE0
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCOItP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:49:15 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57507 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229494AbhCOItH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:49:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 076721941968;
        Mon, 15 Mar 2021 04:49:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:49:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=hClvI5
        vJeYAONT/OEkkaiHSvVSmFVvr3ZFpr8L/Qgtk=; b=fNYj7N90phmlJx6TpSZMMG
        yBXQRg2zZhcFk6jOoIXTGH2MTFDtXOAg2PRtv/sJL/V3SzGhsLDX+aoeUAgXQcX0
        e5cqsZGFUBI70y1skB+hxFmQQJpyT4jXtHT25JkSH+taIBQ/N1dSWwNnnjrDoeGX
        w0euQnb9WuWhiDujLKN8ARvbAN88VnnXn4VN//B9UMZ8vrq2YPiBubNedfB+/7j1
        Bk5+0/YD8YABjq80PkJsDwozoKlCjqWyN03ylZTlEbZ97WGki5zsGcbO5XclSmSx
        Xf6LCsbj+jXRmOwYClVMUwoEkoUbt/r6PE+n9MQ/iCbO3UiAHMRyRlvbacknDz7Q
        ==
X-ME-Sender: <xms:gh9PYHAds_OanlqHxD1qwJG3RMZ4Cjvcfz6YAdqt6nHxtvQcmef6Sw>
    <xme:gh9PYNhE7DrGPIqKovJ55dz7J7bHDvUj3InB-_66obbfuL67kiVD6nDXsXsmoU-bJ
    p7Ts792j2wFfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gh9PYCm48xp8D_Hj5KLW25pQ_3yVhQtEaFdL4FwK4Mz_Lu0QB42Qyg>
    <xmx:gh9PYJyr6Ql4-bSioOREf3jNR3BIe6Kw2octDcC8mrx2FDgddfzRrA>
    <xmx:gh9PYMT9v-CI7k0lvB6E8CCud2pMk2_qthar1_K4lMbh4dmlM1FLNQ>
    <xmx:gx9PYLG-4kjPojSkxPlFW5glRmNrwm7f3wMwztQc0cznJxuSFb3FLQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3FDE1080057;
        Mon, 15 Mar 2021 04:49:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: nvhe: Save the SPE context early" failed to apply to 4.19-stable tree
To:     suzuki.poulose@arm.com, alexandru.elisei@arm.com,
        catalin.marinas@arm.com, christoffer.dall@arm.com,
        mark.rutland@arm.com, maz@kernel.org, pbonzini@redhat.com,
        will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:49:04 +0100
Message-ID: <161579814447215@kroah.com>
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

From b96b0c5de685df82019e16826a282d53d86d112c Mon Sep 17 00:00:00 2001
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Date: Fri, 5 Mar 2021 18:52:47 +0000
Subject: [PATCH] KVM: arm64: nvhe: Save the SPE context early

The nVHE KVM hyp drains and disables the SPE buffer, before
entering the guest, as the EL1&0 translation regime
is going to be loaded with that of the guest.

But this operation is performed way too late, because :
  - The owning translation regime of the SPE buffer
    is transferred to EL2. (MDCR_EL2_E2PB == 0)
  - The guest Stage1 is loaded.

Thus the flush could use the host EL1 virtual address,
but use the EL2 translations instead of host EL1, for writing
out any cached data.

Fix this by moving the SPE buffer handling early enough.
The restore path is doing the right thing.

Fixes: 014c4c77aad7 ("KVM: arm64: Improve debug register save/restore flow")
Cc: stable@vger.kernel.org
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210302120345.3102874-1-suzuki.poulose@arm.com
Message-Id: <20210305185254.3730990-2-maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index c0450828378b..385bd7dd3d39 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -83,6 +83,11 @@ void sysreg_restore_guest_state_vhe(struct kvm_cpu_context *ctxt);
 void __debug_switch_to_guest(struct kvm_vcpu *vcpu);
 void __debug_switch_to_host(struct kvm_vcpu *vcpu);
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu);
+#endif
+
 void __fpsimd_save_state(struct user_fpsimd_state *fp_regs);
 void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
 
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 91a711aa8382..f401724f12ef 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -58,16 +58,24 @@ static void __debug_restore_spe(u64 pmscr_el1)
 	write_sysreg_s(pmscr_el1, SYS_PMSCR_EL1);
 }
 
-void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
+{
 	__debug_switch_to_guest_common(vcpu);
 }
 
-void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
+}
+
+void __debug_switch_to_host(struct kvm_vcpu *vcpu)
+{
 	__debug_switch_to_host_common(vcpu);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f3d0e9eca56c..59aa1045fdaf 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -192,6 +192,14 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
 
 	__sysreg_save_state_nvhe(host_ctxt);
+	/*
+	 * We must flush and disable the SPE buffer for nVHE, as
+	 * the translation regime(EL1&0) is going to be loaded with
+	 * that of the guest. And we must do this before we change the
+	 * translation regime to EL2 (via MDCR_EL2_E2PB == 0) and
+	 * before we load guest Stage1.
+	 */
+	__debug_save_host_buffers_nvhe(vcpu);
 
 	__adjust_pc(vcpu);
 
@@ -234,11 +242,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
+	__debug_switch_to_host(vcpu);
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
 	 */
-	__debug_switch_to_host(vcpu);
+	__debug_restore_host_buffers_nvhe(vcpu);
 
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(host_ctxt);

