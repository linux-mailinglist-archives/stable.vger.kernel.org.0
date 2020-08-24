Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5CDB2507E3
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726929AbgHXSgX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726531AbgHXSgS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:36:18 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5454AC061575;
        Mon, 24 Aug 2020 11:36:17 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id p37so4987044pgl.3;
        Mon, 24 Aug 2020 11:36:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=obhG8AJIVazsG1yWtHmg5cIFCtDuigRomXYssQ4Do2E=;
        b=jUJ9df3yj+pkvI1hq/HzPB7Bofb8F5DooHsNgSB8DGuKkqYlbXuvJhczfiw0LPcO5C
         XGCcOpS4QvB2EwjJwbRQ/TtRnzeXfW5IWH5JZue+YORh6OJF0xvJV4FTQ5Y1LoD57zLO
         d0DAVaggGwH5MPwzJNKBI/kuqC4EV5uR17VwIu2sUSSPO5kBjD0bG2oTKsJUUL0ncwJe
         hJPwD+dbMfOLb1ChQOhbLIRjRLptbjstQrcJ6lzp6BGCwkHKa9jWWltQ+YY/95nhtJbR
         e57v/mpiBl62YBgAjxWjnB+IOy/jYe5f9W3pw5Dcly63+MUAEjxnO0icywPteM4uh22L
         NreA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=obhG8AJIVazsG1yWtHmg5cIFCtDuigRomXYssQ4Do2E=;
        b=HBNkM7nrWSEZGSr4ytBDFwwLyuALIIeQ634BJeEAUcgjIo1IjI7LFL2tHNfRCLhkHM
         M5Dh6TUMcLxj4+8TLBBEdoVGdnmiJ6HHkeBQZQfBnLMm+0cG+0qX+TsMhlTW7KltdJkx
         QKuVdUdctZJzYasP/szaomLb42fr/0BzIhP2eJnZ3xv+ybhXYIbq0ZPCaOWeOiFABIyt
         qszjnNv/6TMH2KIvTXhangGFk+deZBpq2NlVStFJ7VazCwZWvb7hz5vbx01T8uF33jGy
         Z68Skpzm0+YQo4pX3czD4NJy5wnGFG8RCfv/tcT8hz4VFBPH7nqrN1qGEXNrcAcop7ab
         f3Ng==
X-Gm-Message-State: AOAM530HVpLJbBAmJKOAD4LDvvxrcpM5REJzj5weVc44nLa9azaVO0kJ
        8IoCHzmm91y/Q+9AJMW1NXLYmP4IyFk=
X-Google-Smtp-Source: ABdhPJw8UONw9SN2fq4ejwCcRr7xE74Tffx3QRdwXbcYFaiLe0qYtap+qKfXwjFXiJrChkElB9kUNA==
X-Received: by 2002:a17:902:cb91:: with SMTP id d17mr4496547ply.223.1598294176863;
        Mon, 24 Aug 2020 11:36:16 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n5sm10523099pgt.24.2020.08.24.11.36.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:36:16 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 2/2] arm64: entry: Place an SB sequence following an ERET instruction
Date:   Mon, 24 Aug 2020 11:36:10 -0700
Message-Id: <1598294170-24345-3-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
References: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
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
[florian: update arch/arm64/kvm/entry.S::__fpsimd_guest_restore]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/kernel/entry.S      | 2 ++
 arch/arm64/kvm/hyp/entry.S     | 2 ++
 arch/arm64/kvm/hyp/hyp-entry.S | 4 ++++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index c1ffa95c0ad2..f70e0893ba51 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -367,6 +367,7 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
 	.else
 	eret
 	.endif
+	sb
 	.endm
 
 	.macro	irq_stack_entry
@@ -1046,6 +1047,7 @@ alternative_insn isb, nop, ARM64_WORKAROUND_QCOM_FALKOR_E1003
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
index 3c283fd8c8f5..b4d6a6c6c6ce 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -96,6 +96,7 @@ el1_sync:				// Guest trapped into EL2
 	do_el2_call
 
 	eret
+	sb
 
 el1_hvc_guest:
 	/*
@@ -146,6 +147,7 @@ wa_epilogue:
 	mov	x0, xzr
 	add	sp, sp, #16
 	eret
+	sb
 
 el1_trap:
 	get_vcpu_ptr	x1, x0
@@ -204,6 +206,7 @@ el2_error:
 	b.ne	__hyp_panic
 	mov	x0, #(1 << ARM_EXIT_WITH_SERROR_BIT)
 	eret
+	sb
 
 ENTRY(__hyp_do_panic)
 	mov	lr, #(PSR_F_BIT | PSR_I_BIT | PSR_A_BIT | PSR_D_BIT |\
@@ -212,6 +215,7 @@ ENTRY(__hyp_do_panic)
 	ldr	lr, =panic
 	msr	elr_el2, lr
 	eret
+	sb
 ENDPROC(__hyp_do_panic)
 
 ENTRY(__hyp_panic)
-- 
2.7.4

