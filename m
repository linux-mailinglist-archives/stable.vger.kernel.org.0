Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DA333ADEA
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbhCOIv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:51:29 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:42045 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhCOIu7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:50:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 51A371941984;
        Mon, 15 Mar 2021 04:50:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 Mar 2021 04:50:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=uSxQ4S
        XyVoJAm6btoqMPPCwxXAqgCZ8qvGmUggeH6Yg=; b=ua2fsrcXK98XiIkTfPguoE
        68ALKh9Dyriso0xFk7NpcedEzQQu1ew8FKH/yAWfTGfG6u+yldVh7hKEVoCk7por
        EjYGp78VjoqlZSecoozM38aY9OU5MJOvG5FZMJMEeMVh08RPxvyWekBwiXNk/zFM
        E8/UC83pEFgacpEmm7qjZ5I0TwhSndkAWfl6GQXV2VbWBY+xIRyW7g2vaPr56v1M
        YsqNq1PEFa928A3sOEORc5sxN/ksDtLKgcvaA31lTmeWr9QZ/d3LGpcgV1ilvRpQ
        riT+GifLmK+kBxLkdpqE3cpmIWA6uQDlKfn0VSyRi01XQD/cUf4WrFMjLNRTvItA
        ==
X-ME-Sender: <xms:8x9PYB7hhEtiCa0qGKbsM_x_2T9hDZDQWlA21HVxNFDG5PAgsDtIkw>
    <xme:8x9PYJj9_JaYvckxDGesClYSK3NnAB6JvCzuUGNNcT8O9v9mhZgT5LgHsJrr64ERv
    m73FLSG0m3FTg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:8x9PYOc_UD_88n4GWSSxMgVeECCNwGmokpbuabD65pEEt4oOdu8-Vg>
    <xmx:8x9PYJy7jxLzX2i7FseSxbZ6aHVbDEthhI8l9Q7iAivtcXOSdG141A>
    <xmx:8x9PYF3wXL146ki9MQeD8j8TO5jsEwl1xaF3q23MvNqu2YimBjlVKA>
    <xmx:8x9PYPdSxYbZzxK8ZyMktgwXJcn8celltXLgNl3ah6Rw76d2JJWZ-w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id DF8BC240054;
        Mon, 15 Mar 2021 04:50:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] KVM: arm64: Fix nVHE hyp panic host context restore" failed to apply to 5.11-stable tree
To:     ascull@google.com, maz@kernel.org, pbonzini@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:50:57 +0100
Message-ID: <161579825796178@kroah.com>
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
 

