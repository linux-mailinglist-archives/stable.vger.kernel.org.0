Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BC32507DC
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:36:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgHXSgm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:36:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726964AbgHXSga (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:36:30 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC465C061573;
        Mon, 24 Aug 2020 11:36:29 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id d19so4970625pgl.10;
        Mon, 24 Aug 2020 11:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3q7TgN3lxewyLqAIBfP9LryeeItLVKAQXHJvLwyIaWM=;
        b=DXXQnvZpQdBxWWuTfbWVY5FLOwytb0aSgYz9mPH9jwhVJ/ogBB2JP13Gr4jK7HM73T
         pc/bkX58u16w83O633eIk/waD+bT8E/aoCcgOOg01+1vouzqLJH0+zGQjpzQJFyg0FZM
         mauzJky23s4DKNw2+aNYSjn1sV7zZZvHGKo4/0BHmr5FKsNRLRZXrAxTyrW6tvy3xhDC
         /27GPtZ1Tm5+yzrDJZcaCnxIN0oRlJybvVM6DWCbdS2+r7BgXNLnHHCtzQ1epJHThmTq
         nuiTZWKKuwFHf58c5DAoL1PXrjj4dXftqHFIRq8jatyM8kSLLpJJ4ZP+WD0NdXeYZWYa
         7m1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3q7TgN3lxewyLqAIBfP9LryeeItLVKAQXHJvLwyIaWM=;
        b=H46rtuU/8qmPWTXcVQgZaWHLWvju3V+uO7LRrDpWpdtshqKDIvicPTkb77+D076M1m
         hGbIXRm7qyO7Hqvn1u04AWH2dCweMhU13YKPUckktuTCiDjhIW2CUVuTVUlBdi5QZOWI
         qv3w0RXFQMWBJ4cNdm7Hv7paSJw9z6QhWQLcfzohmzppzHV/ffzO8UA33DPwi7PSXsYf
         k6um9vGekupd09EG8GOYBwFfpneubA1M2DDhRIxeZ30vXamH32nHNEZF20G5UUFKWl/h
         neTO80IBbYy0oe3lG8gvWKR85LX7Fokw4W1R7/les18JRQQ23lDbuNMvJbvlz9KQgBXv
         09fA==
X-Gm-Message-State: AOAM532pM1W/GYEZwroIsB0OBqQI82NKtiTxMoFfsTCMdVKagJtQewFW
        ubLo1fFeDvn2lirIAE1KfW8=
X-Google-Smtp-Source: ABdhPJySaZYGlENv2qyFf9K7SCA9acModoq5qtLXOSnFpr5ZYYJUffRqri+Bu8C1bsjf+rWbXYMz0A==
X-Received: by 2002:a17:902:8690:: with SMTP id g16mr2883173plo.257.1598294189292;
        Mon, 24 Aug 2020 11:36:29 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u191sm10235065pgu.56.2020.08.24.11.36.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:36:28 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Will Deacon <will@kernel.org>, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mark Brown <broonie@kernel.org>,
        Kristina Martsenko <kristina.martsenko@arm.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Fangrui Song <maskray@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE FOR ARM64 (KVM/arm64)" 
        <kvmarm@lists.cs.columbia.edu>
Subject: [PATCH stable 4.9 v3 2/2] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 24 Aug 2020 11:36:22 -0700
Message-Id: <1598294182-34012-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
References: <1598294182-34012-1-git-send-email-f.fainelli@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit 679db70801da9fda91d26caf13bf5b5ccc74e8e8 upstream

Some CPUs can speculate past an ERET instruction and potentially perform
speculative accesses to memory before processing the exception return.
Since the register state is often controlled by a lower privilege level
at the point of an ERET, this could potentially be used as part of a
side-channel attack.

This patch emits an SB sequence after each ERET so that speculation is
held up on exception return.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[florian: Adjust hyp-entry.S to account for the label
 added change to hyp/entry.S]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index ca978d7d98eb..3408c782702c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -255,6 +255,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	get_thread_info, rd
@@ -945,6 +946,7 @@ __ni_sys_trace:
 	mrs	x30, far_el1
 	.endif
 	eret
+	sb
 	.endm
 
 	.align	11
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index a360ac6e89e9..93704e6894d2 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -83,6 +83,7 @@ ENTRY(__guest_enter)
 
 	// Do not touch any register after this!
 	eret
+	sb
 ENDPROC(__guest_enter)
 
 ENTRY(__guest_exit)
@@ -195,4 +196,5 @@ alternative_endif
 	ldp	x0, x1, [sp], #16
 
 	eret
+	sb
 ENDPROC(__fpsimd_guest_restore)
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index bf4988f9dae8..3675e7f0ab72 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -97,6 +97,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 2:	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -147,6 +148,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -198,6 +200,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -206,6 +209,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.7.4

