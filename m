Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D36C33ADE9
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbhCOIv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:51:29 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:45631 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhCOIvC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:51:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B3A70194197F;
        Mon, 15 Mar 2021 04:51:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=qnKEmd
        wIkb/3fnWZ4xzc/5zKf/qAG6lIX5z0qB/sYZ8=; b=WBKPPk930mVrWl9s7eSlwm
        roR4s2ygu2IwhsXuAn5CithXFox7NgmZPY4vTtfUgNK/FUyBTiMH/LLcsjNKJ2zt
        D8EwksdsjaZ6pSf9HyNRgclnreSfrb9s70vHkItMf9NXQk7WfKMLJXnuNHnhnMu2
        bQU31OYlIyIe5RoK2BRnz1+f2my93WyeCCx+TpfObzPcTuDi/ojuXR1tbQDeRoN0
        hT7IY8W9R0I0V39js1lB2uzKFvX4ZA5DaVVtV7WC37tESHGFPvPIm/BrnTvBL9d1
        mlZ9cdRF/dHoJC2hkofy8GKXGXD3l+QtZxdKnlivOWRWBXglhoGanpYW7VUPqloQ
        ==
X-ME-Sender: <xms:9R9PYHwDS9JtKVde4VtKrILbUOsjgbo_cLpfTbiZA-MLEuIcers-Yg>
    <xme:9R9PYPT_V_U4oLND5J6N-LR7lbe-esk5dcWE-7e3HCMX_4pHnE7PwhheMz64TJHEV
    A4OwCaqwmyjhw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepkeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:9R9PYBWLvQoDQ-pHvNQ1c9Ke0YDoKADAaR3Rfkq4escgMmxJpARWUw>
    <xmx:9R9PYBiC6I_t7WEhNv9_IXSik6sRY34b-fpagqn63h-Q6a3UIpqHRA>
    <xmx:9R9PYJC4RCX2B--uzXjl33EtmMTG9eIDaS8vVV6SXmnGUllPEVJqfQ>
    <xmx:9R9PYG64lMZO8ApgkXe13s2pePKPsOM45dnVhk3ULl9mp62I33eDFA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 36E88108005F;
        Mon, 15 Mar 2021 04:51:01 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix nVHE hyp panic host context restore" failed to apply to 5.10-stable tree
To:     ascull@google.com, maz@kernel.org, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:58 +0100
Message-ID: <161579825823529@kroah.com>
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

From c4b000c3928d4f20acef79dccf3a65ae3795e0b0 Mon Sep 17 00:00:00 2001
From: Andrew Scull <ascull@google.com>
Date: Fri, 5 Mar 2021 18:52:49 +0000
Subject: [PATCH] KVM: arm64: Fix nVHE hyp panic host context restore

When panicking from the nVHE hyp and restoring the host context, x29 is
expected to hold a pointer to the host context. This wasn't being done
so fix it to make sure there's a valid pointer the host context being
used.

Rather than passing a boolean indicating whether or not the host context
should be restored, instead pass the pointer to the host context. NULL
is passed to indicate that no context should be restored.

Fixes: a2e102e20fd6 ("KVM: arm64: nVHE: Handle hyp panics")
Cc: stable@vger.kernel.org
Signed-off-by: Andrew Scull <ascull@google.com>
[maz: partial rewrite to fit 5.12-rc1]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20210219122406.1337626-1-ascull@google.com
Message-Id: <20210305185254.3730990-4-maz@kernel.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 385bd7dd3d39..32ae676236b6 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -102,7 +102,8 @@ bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
 void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+			       u64 elr, u64 par);
 #endif
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/host.S b/arch/arm64/kvm/hyp/nvhe/host.S
index 6585a7cbbc56..5d94584840cc 100644
--- a/arch/arm64/kvm/hyp/nvhe/host.S
+++ b/arch/arm64/kvm/hyp/nvhe/host.S
@@ -71,7 +71,8 @@ SYM_FUNC_START(__host_enter)
 SYM_FUNC_END(__host_enter)
 
 /*
- * void __noreturn __hyp_do_panic(bool restore_host, u64 spsr, u64 elr, u64 par);
+ * void __noreturn __hyp_do_panic(struct kvm_cpu_context *host_ctxt, u64 spsr,
+ * 				  u64 elr, u64 par);
  */
 SYM_FUNC_START(__hyp_do_panic)
 	/* Prepare and exit to the host's panic funciton. */
@@ -82,9 +83,11 @@ SYM_FUNC_START(__hyp_do_panic)
 	hyp_kimg_va lr, x6
 	msr	elr_el2, lr
 
-	/* Set the panic format string. Use the, now free, LR as scratch. */
-	ldr	lr, =__hyp_panic_string
-	hyp_kimg_va lr, x6
+	mov	x29, x0
+
+	/* Load the format string into x0 and arguments into x1-7 */
+	ldr	x0, =__hyp_panic_string
+	hyp_kimg_va x0, x6
 
 	/* Load the format arguments into x1-7. */
 	mov	x6, x3
@@ -94,9 +97,7 @@ SYM_FUNC_START(__hyp_do_panic)
 	mrs	x5, hpfar_el2
 
 	/* Enter the host, conditionally restoring the host context. */
-	cmp	x0, xzr
-	mov	x0, lr
-	b.eq	__host_enter_without_restoring
+	cbz	x29, __host_enter_without_restoring
 	b	__host_enter_for_panic
 SYM_FUNC_END(__hyp_do_panic)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 59aa1045fdaf..68ab6b4d5141 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -266,7 +266,6 @@ void __noreturn hyp_panic(void)
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg_par();
-	bool restore_host = true;
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
 
@@ -280,7 +279,7 @@ void __noreturn hyp_panic(void)
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
 
-	__hyp_do_panic(restore_host, spsr, elr, par);
+	__hyp_do_panic(host_ctxt, spsr, elr, par);
 	unreachable();
 }
 

