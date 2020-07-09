Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E666321A830
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 21:52:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgGITwN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 15:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbgGITvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 15:51:01 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7A95C08C5DC;
        Thu,  9 Jul 2020 12:51:00 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k5so1235100plk.13;
        Thu, 09 Jul 2020 12:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RwIQJPyP7UHlF/ZGGKtcnGZyKRkZA3pCBcfEq7K/2Ho=;
        b=AznY960+pK6TOErT6DuUqz4G4vZlBkddYOl5d2OHe7pG00Y0HIPRjgSEb5zEauhq3u
         RKM6boUHn3SMWeCJDchdIobej2f1kSt+RZnspd8DsOp/HbooshTkDo+M00AmnvDD6yXH
         07OtQgi8r6ZPSJ0Eky6PU/dhvo8seV9KaGEOORqVmXVD95zxKP5jR5wAtjB3sN2Ew/hy
         194wpp1EWZyhMIKvI8Zcwi+hxgj5t/ag+Ch9C2Q9Lsq4+u6xoosUVdcMXrVlxNwX4KnF
         b4SSBTNB108RFRlXcVo67ObtTCVjwrxgMaYcHYZ4WSWCa1aEhdNOPddPq475+qFl6uyO
         X/fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RwIQJPyP7UHlF/ZGGKtcnGZyKRkZA3pCBcfEq7K/2Ho=;
        b=pWplp87076ZuJPqIPv8cq5dCsBCIwxIJRCRSG+aX/J+Jrjvfwhrwjkvm8vVET6weGj
         aTx5pbCrw4yXY4o3fF7SenrXRR8iD028NLvAxLu7yx/VJKpSLdZr01ZXfXj5P7DJp20p
         12HfPkeIRhYt/89hku/5SQLT43vDIUFf6XsXO8oZ1+HbwMUS/GoH9ZD0ZE/YDTk/zDnF
         7NNxg7k4W8NXKaVnTCaaVJInf1rEGLeMmS+JzOx60cc5822dEQs6RbDc0zCRayWzVb1U
         P9S7xXEQqWxGiGtqDZzWFuU3LbQQShwN0Dq0nlbkW8rYrPMYoFQv0Csbft6GW1YvFEwE
         A74Q==
X-Gm-Message-State: AOAM533YSkLsX/8sV5Mdnb+F0lZIgwWSvRmlu6MklxOHh9q3M+BFDzWM
        7x8eau5+b2a06ip+SyJIEQE=
X-Google-Smtp-Source: ABdhPJwDJxkzz3kgTcJCu9/JCf8HhRsvChMEW+U2cgrMgNAOBN45sP1bW6XPDT8vS97J11EP5enArQ==
X-Received: by 2002:a17:902:820a:: with SMTP id x10mr4938403pln.135.1594324260334;
        Thu, 09 Jul 2020 12:51:00 -0700 (PDT)
Received: from localhost.localdomain ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id f2sm3694941pfb.184.2020.07.09.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 12:50:59 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-arm-kernel@lists.infradead.org
Cc:     stable@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
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
        linux-kernel@vger.kernel.org (open list),
        kvmarm@lists.cs.columbia.edu (open list:KERNEL VIRTUAL MACHINE FOR
        ARM64 (KVM/arm64))
Subject: [PATCH stable v4.9 v2] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Thu,  9 Jul 2020 12:50:23 -0700
Message-Id: <20200709195034.15185-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
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
Changes in v2:

- added missing hunk in hyp/entry.S per Will's feedback

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
2.17.1

