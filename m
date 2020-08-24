Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577CA2507E2
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgHXSgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 14:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgHXSgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 14:36:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8540FC061574;
        Mon, 24 Aug 2020 11:36:15 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id f193so5289170pfa.12;
        Mon, 24 Aug 2020 11:36:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qtv1SaQn3rXE6ZivxxbxripRsxeqEd0OWFpGW/UQyeU=;
        b=E60MoPw3+I9e9NLNKm9q/qSfK4lZwmDpzpXBfpkixSP5a/fN9fKC5cXnaowZPFHDae
         KIcxpMKX3iKaZx/Y/3q0o+sfKLLy3MAmlOCQNJKRWzCkNTbrRUD3gmj0q3k/XC7fm2/2
         jM+rcDHIUOULjs+D64YupGoBPkjv5m+uKiVXnv/8pRD4DDtOsSfEjY81aST53iM6+l/E
         TJqMCYkmxoY6t33qf38Y5fWMF51ZNRsQB8r7fwQeXP1UPqe0s0nwvCwMsGC9hK+BNZDh
         7e1XbnO89rRswfxowtLVACBWeOgeH+x0ZP1yHqavKi/vS37vNaJ6kaWIzK5t9RrWY11N
         VyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qtv1SaQn3rXE6ZivxxbxripRsxeqEd0OWFpGW/UQyeU=;
        b=tvTq1xIIG5FokzEhI78dn8wnnggV2dwFD8pDYaQIL0EA8nyWe6kThnEBPu0r+VzkaE
         tSUQFWSBq5R7DjduMKvFFf+Cjnf5yFdQFjSXsJ0m04sC/RN4DQ9s8MDKHq0JAP1GT40F
         30viF1Y8c8QYCUkLYcDVZ7fvLEhXvJjsf0O2S5nmmlDq4XY95EBiCzBVz49Fi4v7lRjH
         3yHe/5qwnUShkU4UgLJoZMj19LFaTi22lJkGKXRDi+O6lXEPQLF6WXFceKMwa1j20M72
         sMHvQb1Dak6uI9Q25V2bDK+rLGERI/p+l/VOf6F9nhCy22RpobzplKrbHZiusTxzVuxa
         qjnw==
X-Gm-Message-State: AOAM532MtQDRGsO20TCTe/8AJpp6T8lnV2s+Kw8xSU26jWBky2u0tckK
        gICGT2DzJqsOBGiYd9DBIaE=
X-Google-Smtp-Source: ABdhPJxfkoaNpcKxsvJqfuUmYzK4W+u/TP9TkMq6mfEXSPbbuhzfqYnkc9yMi+c5tIIRtv6FSWubZg==
X-Received: by 2002:a17:902:bf01:: with SMTP id bi1mr4706045plb.118.1598294175002;
        Mon, 24 Aug 2020 11:36:15 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n5sm10523099pgt.24.2020.08.24.11.36.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 11:36:14 -0700 (PDT)
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
Subject: [PATCH stable 4.14 v2 1/2] arm64: Add support for SB barrier and patch in over DSB; ISB sequences
Date:   Mon, 24 Aug 2020 11:36:09 -0700
Message-Id: <1598294170-24345-2-git-send-email-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
References: <1598294170-24345-1-git-send-email-f.fainelli@gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

commit bd4fb6d270bc423a9a4098108784f7f9254c4e6d upstream

We currently use a DSB; ISB sequence to inhibit speculation in set_fs().
Whilst this works for current CPUs, future CPUs may implement a new SB
barrier instruction which acts as an architected speculation barrier.

On CPUs that support it, patch in an SB; NOP sequence over the DSB; ISB
sequence and advertise the presence of the new instruction to userspace.

Signed-off-by: Will Deacon <will.deacon@arm.com>
[florian: adjust conflicts for cpucaps.h and cpufeature.c]
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm64/include/asm/assembler.h  | 13 +++++++++++++
 arch/arm64/include/asm/barrier.h    |  4 ++++
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/sysreg.h     |  6 ++++++
 arch/arm64/include/asm/uaccess.h    |  3 +--
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 8 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 02d73d83f0de..d98fb3f52ee3 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -104,6 +104,19 @@
 	.endm
 
 /*
+ * Speculation barrier
+ */
+	.macro	sb
+alternative_if_not ARM64_HAS_SB
+	dsb	nsh
+	isb
+alternative_else
+	SB_BARRIER_INSN
+	nop
+alternative_endif
+	.endm
+
+/*
  * Sanitise a 64-bit bounded index wrt speculation, returning zero if out
  * of bounds.
  */
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 0b0755c961ac..159329160fb4 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -33,6 +33,10 @@
 
 #define csdb()		asm volatile("hint #20" : : : "memory")
 
+#define spec_bar()	asm volatile(ALTERNATIVE("dsb nsh\nisb\n",		\
+						 SB_BARRIER_INSN"nop\n",	\
+						 ARM64_HAS_SB))
+
 #define mb()		dsb(sy)
 #define rmb()		dsb(ld)
 #define wmb()		dsb(st)
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2f8bd0388905..cf8588560b78 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -45,7 +45,8 @@
 #define ARM64_SSBD				25
 #define ARM64_MISMATCHED_CACHE_TYPE		26
 #define ARM64_SSBS				27
+#define ARM64_HAS_SB				28
 
-#define ARM64_NCAPS				28
+#define ARM64_NCAPS				29
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 2564dd429ab6..fe6ffceaf27f 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -97,6 +97,11 @@
 #define SET_PSTATE_SSBS(x) __emit_inst(0xd5000000 | REG_PSTATE_SSBS_IMM | \
 				       (!!x)<<8 | 0x1f)
 
+#define __SYS_BARRIER_INSN(CRm, op2, Rt) \
+	__emit_inst(0xd5000000 | sys_insn(0, 3, 3, (CRm), (op2)) | ((Rt) & 0x1f))
+
+#define SB_BARRIER_INSN			__SYS_BARRIER_INSN(0, 7, 31)
+
 #define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
 #define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
 #define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
@@ -398,6 +403,7 @@
 #define ID_AA64ISAR0_AES_SHIFT		4
 
 /* id_aa64isar1 */
+#define ID_AA64ISAR1_SB_SHIFT		36
 #define ID_AA64ISAR1_LRCPC_SHIFT	20
 #define ID_AA64ISAR1_FCMA_SHIFT		16
 #define ID_AA64ISAR1_JSCVT_SHIFT	12
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index fad8c1b2ca3e..b6392026e27b 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -46,8 +46,7 @@ static inline void set_fs(mm_segment_t fs)
 	 * Prevent a mispredicted conditional call to set_fs from forwarding
 	 * the wrong address limit to access_ok under speculation.
 	 */
-	dsb(nsh);
-	isb();
+	spec_bar();
 
 	/* On user-mode return, check fs is correct */
 	set_thread_flag(TIF_FSCHECK);
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 2bcd6e4f3474..7784f7cba16c 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -49,5 +49,6 @@
 #define HWCAP_ILRCPC		(1 << 26)
 #define HWCAP_FLAGM		(1 << 27)
 #define HWCAP_SSBS		(1 << 28)
+#define HWCAP_SB		(1 << 29)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6b3bb67596ae..0bb0c627ec25 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -122,6 +122,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_SB_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_LRCPC_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_FCMA_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_JSCVT_SHIFT, 4, 0),
@@ -1129,6 +1130,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_ssbs,
 	},
 #endif
+	{
+		.desc = "Speculation barrier (SB)",
+		.capability = ARM64_HAS_SB,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64ISAR1_EL1,
+		.field_pos = ID_AA64ISAR1_SB_SHIFT,
+		.sign = FTR_UNSIGNED,
+		.min_field_value = 1,
+	},
 	{},
 };
 
@@ -1183,6 +1194,7 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 2, CAP_HWCAP, HWCAP_ILRCPC),
+	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_SB_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_SB),
 	HWCAP_CAP(SYS_ID_AA64MMFR2_EL1, ID_AA64MMFR2_AT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_USCAT),
 	HWCAP_CAP(SYS_ID_AA64PFR1_EL1, ID_AA64PFR1_SSBS_SHIFT, FTR_UNSIGNED, ID_AA64PFR1_SSBS_PSTATE_INSNS, CAP_HWCAP, HWCAP_SSBS),
 	{},
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 9ff64e04e63d..c45b488d2564 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -81,6 +81,7 @@ static const char *const hwcap_str[] = {
 	"ilrcpc",
 	"flagm",
 	"ssbs",
+	"sb",
 	NULL
 };
 
-- 
2.7.4

