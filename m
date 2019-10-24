Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 251BBE32D2
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 14:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfJXMtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 08:49:02 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43898 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729573AbfJXMtC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 08:49:02 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so20704783wrr.10
        for <stable@vger.kernel.org>; Thu, 24 Oct 2019 05:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pQHOE9je+o2KIZotzirVAqZyJOl8UTJpxGNddMrz2bc=;
        b=vSeTdskIfiiwLmYZADgabGz9Thax5o878HRmpnqnm84lfhnAW23aQKmGDyNIu98DPA
         i0KEYBBSPBvVY1hJoTaM7ogOHvyUfpJ8uJvfh03AEXIJ7z8WvSdPdkaoHjx86B7leY7K
         bRPVB1AdUWlaMXiyaOaeo2m31QzvD/5vv9uWm2RMRk0qT7CXWsd7QqAsk7q1FRNupWQx
         yhOiEBAccQegdxVHKEBVtKBl0t/rLOXExeKBF2zr8hSN2x6HwoDLgeRL1Nb1PjNi3nTO
         9eBuSrpxZ9lVwNwkeoYeNV4QXLwSUeXRV4zbw83xF+L/kqzmNZd9A0ozzNsea4HV5665
         DCnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pQHOE9je+o2KIZotzirVAqZyJOl8UTJpxGNddMrz2bc=;
        b=e26UgXYhoSgSN4ynuTKQx7HmVD9zZqB0mVQQqrsqQSpPy5MKQrxiZt0xj/216wAI2C
         dB/NWODGR2xKaSqX3oMX7c48fSr16y7xun9fG6kleHhuAVPqUxIHpaYzQ2M08x2955Qr
         k9wRjyL4At1t2PHIGV9ap1o9ClY6Lfeqcp+p5Yz9DSiAWdIHn/ZS3z40uAbDKwPl5J9x
         af7yOgukT/HIld9Lr4GUCZymUc2Eu/5WFq+cK8y5qlbHwjSH777V0urjd9DJQwgIluUb
         tmjSiuWdSK9N7gEYpzKm69j9d1XmSd19DHuDNfzYJLSUYKHLBgINpwdF7zdNTr6yZJv/
         y73Q==
X-Gm-Message-State: APjAAAWOW3+L26R7aa2UIGBL5zlyyZ7h2nszqtUB+qidcoanAdveIAbB
        THZXqpTat52VsnLanV1UWaBeAGzjeyPD4MzF
X-Google-Smtp-Source: APXvYqzJUox4l49fwqD2MX4Ncb1kEfl2HuJfR3JPF+OL5CDj9rUdhTJBjYck8esY/jzgcnwnH0MHyw==
X-Received: by 2002:adf:f04e:: with SMTP id t14mr3494051wro.106.1571921339610;
        Thu, 24 Oct 2019 05:48:59 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-126-126.w90-88.abo.wanadoo.fr. [90.88.7.126])
        by smtp.gmail.com with ESMTPSA id j22sm29111038wrd.41.2019.10.24.05.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 05:48:58 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH for-stable-4.14 08/48] arm64: add PSR_AA32_* definitions
Date:   Thu, 24 Oct 2019 14:47:53 +0200
Message-Id: <20191024124833.4158-9-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
References: <20191024124833.4158-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 25086263425641c74123f9387426c23072b299ea ]

The AArch32 CPSR/SPSR format is *almost* identical to the AArch64
SPSR_ELx format for exceptions taken from AArch32, but the two have
diverged with the addition of DIT, and we need to treat the two as
logically distinct.

This patch adds new definitions for the SPSR_ELx format for exceptions
taken from AArch32, with a consistent PSR_AA32_ prefix. The existing
COMPAT_PSR_ definitions will be used for the PSR format as seen from
AArch32.

Definitions of DIT are provided for both, and inline functions are
provided to map between the two formats. Note that for SPSR_ELx, the
(RES0) J bit has been re-allocated as the DIT bit.

Once users of the COMPAT_PSR definitions have been migrated over to the
PSR_AA32 definitions, the (majority of) the former will be removed, so
no efforts is made to avoid duplication until then.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/include/asm/ptrace.h | 57 +++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/ptrace.h b/arch/arm64/include/asm/ptrace.h
index 6069d66e0bc2..1b2a253de6a1 100644
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -35,7 +35,37 @@
 #define COMPAT_PTRACE_GETHBPREGS	29
 #define COMPAT_PTRACE_SETHBPREGS	30
 
-/* AArch32 CPSR bits */
+/* SPSR_ELx bits for exceptions taken from AArch32 */
+#define PSR_AA32_MODE_MASK	0x0000001f
+#define PSR_AA32_MODE_USR	0x00000010
+#define PSR_AA32_MODE_FIQ	0x00000011
+#define PSR_AA32_MODE_IRQ	0x00000012
+#define PSR_AA32_MODE_SVC	0x00000013
+#define PSR_AA32_MODE_ABT	0x00000017
+#define PSR_AA32_MODE_HYP	0x0000001a
+#define PSR_AA32_MODE_UND	0x0000001b
+#define PSR_AA32_MODE_SYS	0x0000001f
+#define PSR_AA32_T_BIT		0x00000020
+#define PSR_AA32_F_BIT		0x00000040
+#define PSR_AA32_I_BIT		0x00000080
+#define PSR_AA32_A_BIT		0x00000100
+#define PSR_AA32_E_BIT		0x00000200
+#define PSR_AA32_DIT_BIT	0x01000000
+#define PSR_AA32_Q_BIT		0x08000000
+#define PSR_AA32_V_BIT		0x10000000
+#define PSR_AA32_C_BIT		0x20000000
+#define PSR_AA32_Z_BIT		0x40000000
+#define PSR_AA32_N_BIT		0x80000000
+#define PSR_AA32_IT_MASK	0x0600fc00	/* If-Then execution state mask */
+#define PSR_AA32_GE_MASK	0x000f0000
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define PSR_AA32_ENDSTATE	PSR_AA32_E_BIT
+#else
+#define PSR_AA32_ENDSTATE	0
+#endif
+
+/* AArch32 CPSR bits, as seen in AArch32 */
 #define COMPAT_PSR_MODE_MASK	0x0000001f
 #define COMPAT_PSR_MODE_USR	0x00000010
 #define COMPAT_PSR_MODE_FIQ	0x00000011
@@ -50,6 +80,7 @@
 #define COMPAT_PSR_I_BIT	0x00000080
 #define COMPAT_PSR_A_BIT	0x00000100
 #define COMPAT_PSR_E_BIT	0x00000200
+#define COMPAT_PSR_DIT_BIT	0x00200000
 #define COMPAT_PSR_J_BIT	0x01000000
 #define COMPAT_PSR_Q_BIT	0x08000000
 #define COMPAT_PSR_V_BIT	0x10000000
@@ -111,6 +142,30 @@
 #define compat_sp_fiq	regs[29]
 #define compat_lr_fiq	regs[30]
 
+static inline unsigned long compat_psr_to_pstate(const unsigned long psr)
+{
+	unsigned long pstate;
+
+	pstate = psr & ~COMPAT_PSR_DIT_BIT;
+
+	if (psr & COMPAT_PSR_DIT_BIT)
+		pstate |= PSR_AA32_DIT_BIT;
+
+	return pstate;
+}
+
+static inline unsigned long pstate_to_compat_psr(const unsigned long pstate)
+{
+	unsigned long psr;
+
+	psr = pstate & ~PSR_AA32_DIT_BIT;
+
+	if (pstate & PSR_AA32_DIT_BIT)
+		psr |= COMPAT_PSR_DIT_BIT;
+
+	return psr;
+}
+
 /*
  * This struct defines the way the registers are stored on the stack during an
  * exception. Note that sizeof(struct pt_regs) has to be a multiple of 16 (for
-- 
2.20.1

