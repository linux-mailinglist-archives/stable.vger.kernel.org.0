Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA12E3634A6
	for <lists+stable@lfdr.de>; Sun, 18 Apr 2021 12:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhDRKho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Apr 2021 06:37:44 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:40917 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229652AbhDRKhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Apr 2021 06:37:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1713519401B0;
        Sun, 18 Apr 2021 06:37:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 18 Apr 2021 06:37:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ehVAGD
        oxV9h4KqpthjqiRwGuJyuH+zKN5lIF4obGdDM=; b=DWr+B9SkStnVmuVMw4jFz/
        apB7zqXKQvyvPgX2N2WfpUXSLyVj0dbXKhrxNE+uuydVnL/Cdzzi4r7aCCGM57UW
        tEviF1hZZYkcvyL8+ixYO9iMtvwSVvJa1xQ2ZYb6fQLI6YdowYC9At51uMDynm/R
        0lK60svTESPdJVNTAajRymVA0Tuy/oojOuxs+uYSgofpRlMTzp4suxlFI7yasNyD
        JfS7l4nKEDhu/TIRI6ijZSWWiu9gxwcHYgIOIJ/HEk9aeWDk/Ayx83p5znAg1Li3
        C3MMDAqjo6B7Dr1siXv/MU7nWyEekv+hvSHIJYiRFwZ1UjbKq5Mc1qeMI2rYN5MQ
        ==
X-ME-Sender: <xms:2Qt8YN_S5slTNTAsWFcKpgPlLkHBUhZ4scmsngQgvuUDVuchZov52w>
    <xme:2Qt8YBs_RmjO8xpkVWQIqZojYa1SG4VpLVz0nuIsx4NnDauIMsBvXvWUkebcMGr6Y
    4d1PFRs1Jibcg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudelkedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnheptdeihedtieehudfgffdtgeevveegfeeffffgffegtd
    ehtdeukeekgeffhfffffefnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpvghnthhr
    hidrshgsnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptd
    enucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2Qt8YLB43xABlqeb0yX8yw9veBUOHCmvMBjexoXo74bb7-lygG43pQ>
    <xmx:2Qt8YBfvtxyLcfC85c_fcKM-zeCQFXb1mSKRVFp6Vh8F2I326U4CIA>
    <xmx:2Qt8YCM7lxIjMcROcZgXT1vhrpt-SpOmQV5lIP0VS-XXZphL-Mqijw>
    <xmx:2gt8YLZpE1nQeteyAY8pOVfzqf6PjHg-ZKcqn_Le8XO9ESXrrwoDZA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7D479240057;
        Sun, 18 Apr 2021 06:37:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is set atomically" failed to apply to 5.10-stable tree
To:     catalin.marinas@arm.com, mark.rutland@arm.com,
        stable@vger.kernel.org, vincenzo.frascino@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 18 Apr 2021 12:37:12 +0200
Message-ID: <161874223215712@kroah.com>
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

From 2decad92f4731fac9755a083fcfefa66edb7d67d Mon Sep 17 00:00:00 2001
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 9 Apr 2021 18:37:10 +0100
Subject: [PATCH] arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is set atomically

The entry from EL0 code checks the TFSRE0_EL1 register for any
asynchronous tag check faults in user space and sets the
TIF_MTE_ASYNC_FAULT flag. This is not done atomically, potentially
racing with another CPU calling set_tsk_thread_flag().

Replace the non-atomic ORR+STR with an STSET instruction. While STSET
requires ARMv8.1 and an assembler that understands LSE atomics, the MTE
feature is part of ARMv8.5 and already requires an updated assembler.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 637ec831ea4f ("arm64: mte: Handle synchronous and asynchronous tag check faults")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Will Deacon <will@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210409173710.18582-1-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e4e1b6550115..dfdc3e0af5e1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1406,10 +1406,13 @@ config ARM64_PAN
 config AS_HAS_LDAPR
 	def_bool $(as-instr,.arch_extension rcpc)
 
+config AS_HAS_LSE_ATOMICS
+	def_bool $(as-instr,.arch_extension lse)
+
 config ARM64_LSE_ATOMICS
 	bool
 	default ARM64_USE_LSE_ATOMICS
-	depends on $(as-instr,.arch_extension lse)
+	depends on AS_HAS_LSE_ATOMICS
 
 config ARM64_USE_LSE_ATOMICS
 	bool "Atomic instructions"
@@ -1666,6 +1669,7 @@ config ARM64_MTE
 	default y
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
 	depends on AS_HAS_ARMV8_5
+	depends on AS_HAS_LSE_ATOMICS
 	# Required for tag checking in the uaccess routines
 	depends on ARM64_PAN
 	select ARCH_USES_HIGH_VMA_FLAGS
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index a31a0a713c85..6acfc5e6b5e0 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -148,16 +148,18 @@ alternative_cb_end
 	.endm
 
 	/* Check for MTE asynchronous tag check faults */
-	.macro check_mte_async_tcf, flgs, tmp
+	.macro check_mte_async_tcf, tmp, ti_flags
 #ifdef CONFIG_ARM64_MTE
+	.arch_extension lse
 alternative_if_not ARM64_MTE
 	b	1f
 alternative_else_nop_endif
 	mrs_s	\tmp, SYS_TFSRE0_EL1
 	tbz	\tmp, #SYS_TFSR_EL1_TF0_SHIFT, 1f
 	/* Asynchronous TCF occurred for TTBR0 access, set the TI flag */
-	orr	\flgs, \flgs, #_TIF_MTE_ASYNC_FAULT
-	str	\flgs, [tsk, #TSK_TI_FLAGS]
+	mov	\tmp, #_TIF_MTE_ASYNC_FAULT
+	add	\ti_flags, tsk, #TSK_TI_FLAGS
+	stset	\tmp, [\ti_flags]
 	msr_s	SYS_TFSRE0_EL1, xzr
 1:
 #endif
@@ -244,7 +246,7 @@ alternative_else_nop_endif
 	disable_step_tsk x19, x20
 
 	/* Check for asynchronous tag check faults in user space */
-	check_mte_async_tcf x19, x22
+	check_mte_async_tcf x22, x23
 	apply_ssbd 1, x22, x23
 
 	ptrauth_keys_install_kernel tsk, x20, x22, x23

