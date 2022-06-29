Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CEA8560880
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiF2SDj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232477AbiF2SDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:07 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AF163E0E6;
        Wed, 29 Jun 2022 11:02:56 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m14-20020a17090a668e00b001ee6ece8368so185913pjj.3;
        Wed, 29 Jun 2022 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kuD86jFb3TKSdkqqVpxORZ+r2W1//QrNCvfuXjuJX7I=;
        b=VU0EOBT1z8UjC/my1FIgmxgIZPtUlzozrQ5XiM2NgbpBkIAkG32pJZ2GztbIa+XV73
         AanOqf+GFl2GQEVRe6KTW7AHfL/11HlGU9PbziX6rGv+82KGwke7xSLmBGrY1uWuCgLc
         UWa1OBSzdaKyNZKQ3wQCfmjZP5MikSaBxzvwgc2EqLFInbvHuoUcjuBKdkDpw0YZ1ya1
         FxV0qKzVW2v5LW1QBiNoTCOc9yZjHR8To3MYHm8SJXWYg64Dry6jfT/arp7/uvCWipVn
         6m9CCO4SuQPJWrcwMzYUeVCnVHOP44LnnDcnN18aOzgvbeUpqryCoM4rELWDhGel7YsQ
         RTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kuD86jFb3TKSdkqqVpxORZ+r2W1//QrNCvfuXjuJX7I=;
        b=Lw/KJlAUvMn/+4URwZEkrKaJ9EynXCiAH7MTh4uRmxAM7tTSfNbYQqkjOMNAfWTZsk
         P/houxCOc9EhCDvQLrMzdYhyc8Db2zigCxeXSumvosCWRGt6yhWqGQ4bjsdf7xqiGKN/
         muH/tnqIdYCuHEQD6J/uub1sIavfGMQjoP7gmUovBjZkHAzkzv4VqfcF7+YK1XexscLH
         MiXaQGuswlHYk0PQFmowTQ2UoZXXY0jaWNyywxnDKBdf0OvjmfWr6qb6yiWuUmlQipu/
         RgIifWNpNWrQC+N6VZqRVDFuRur+HjDVnUkBr1Jl8Szb0exIQTudl0dVReTFD0ej/0Nl
         3mXA==
X-Gm-Message-State: AJIora8zjeplCRmAI9iOuuvdedFZxDBStVSmL2HxCs/ppffgAis38QyV
        z1KI1EOL/8cykw42UzeKsJr/fkNP38g=
X-Google-Smtp-Source: AGRyM1txCl7Zh3fQgcEChHw6w2Hw3+htYScLWITdrzmWPQCoHoc1FqMw3a5e3rQ7SxLpOKtDjjLVsg==
X-Received: by 2002:a17:902:e852:b0:16a:67d7:c427 with SMTP id t18-20020a170902e85200b0016a67d7c427mr10174423plg.154.1656525775301;
        Wed, 29 Jun 2022 11:02:55 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:54 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jian Cai <jiancai@google.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <caij2003@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-omap@vger.kernel.org (open list:OMAP2+ SUPPORT),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.4 09/11] ARM: 9029/1: Make iwmmxt.S support Clang's integrated assembler
Date:   Wed, 29 Jun 2022 11:02:25 -0700
Message-Id: <20220629180227.3408104-10-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220629180227.3408104-1-f.fainelli@gmail.com>
References: <20220629180227.3408104-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jian Cai <jiancai@google.com>

commit 3c9f5708b7aed6a963e2aefccbd1854802de163e upstream

This patch replaces 6 IWMMXT instructions Clang's integrated assembler
does not support in iwmmxt.S using macros, while making sure GNU
assembler still emit the same instructions. This should be easier than
providing full IWMMXT support in Clang.  This is one of the last bits of
kernel code that could be compiled but not assembled with clang. Once
all of it works with IAS, we no longer need to special-case 32-bit Arm
in Kbuild, or turn off CONFIG_IWMMXT when build-testing.

"Intel Wireless MMX Technology - Developer Guide - August, 2002" should
be referenced for the encoding schemes of these extensions.

Link: https://github.com/ClangBuiltLinux/linux/issues/975

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Suggested-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Jian Cai <jiancai@google.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/kernel/iwmmxt.S | 89 ++++++++++++++++++++--------------------
 arch/arm/kernel/iwmmxt.h | 47 +++++++++++++++++++++
 2 files changed, 92 insertions(+), 44 deletions(-)
 create mode 100644 arch/arm/kernel/iwmmxt.h

diff --git a/arch/arm/kernel/iwmmxt.S b/arch/arm/kernel/iwmmxt.S
index 0dcae787b004..d2b4ac06e4ed 100644
--- a/arch/arm/kernel/iwmmxt.S
+++ b/arch/arm/kernel/iwmmxt.S
@@ -16,6 +16,7 @@
 #include <asm/thread_info.h>
 #include <asm/asm-offsets.h>
 #include <asm/assembler.h>
+#include "iwmmxt.h"
 
 #if defined(CONFIG_CPU_PJ4) || defined(CONFIG_CPU_PJ4B)
 #define PJ4(code...)		code
@@ -113,33 +114,33 @@ concan_save:
 
 concan_dump:
 
-	wstrw	wCSSF, [r1, #MMX_WCSSF]
-	wstrw	wCASF, [r1, #MMX_WCASF]
-	wstrw	wCGR0, [r1, #MMX_WCGR0]
-	wstrw	wCGR1, [r1, #MMX_WCGR1]
-	wstrw	wCGR2, [r1, #MMX_WCGR2]
-	wstrw	wCGR3, [r1, #MMX_WCGR3]
+	wstrw	wCSSF, r1, MMX_WCSSF
+	wstrw	wCASF, r1, MMX_WCASF
+	wstrw	wCGR0, r1, MMX_WCGR0
+	wstrw	wCGR1, r1, MMX_WCGR1
+	wstrw	wCGR2, r1, MMX_WCGR2
+	wstrw	wCGR3, r1, MMX_WCGR3
 
 1:	@ MUP? wRn
 	tst	r2, #0x2
 	beq	2f
 
-	wstrd	wR0,  [r1, #MMX_WR0]
-	wstrd	wR1,  [r1, #MMX_WR1]
-	wstrd	wR2,  [r1, #MMX_WR2]
-	wstrd	wR3,  [r1, #MMX_WR3]
-	wstrd	wR4,  [r1, #MMX_WR4]
-	wstrd	wR5,  [r1, #MMX_WR5]
-	wstrd	wR6,  [r1, #MMX_WR6]
-	wstrd	wR7,  [r1, #MMX_WR7]
-	wstrd	wR8,  [r1, #MMX_WR8]
-	wstrd	wR9,  [r1, #MMX_WR9]
-	wstrd	wR10, [r1, #MMX_WR10]
-	wstrd	wR11, [r1, #MMX_WR11]
-	wstrd	wR12, [r1, #MMX_WR12]
-	wstrd	wR13, [r1, #MMX_WR13]
-	wstrd	wR14, [r1, #MMX_WR14]
-	wstrd	wR15, [r1, #MMX_WR15]
+	wstrd	wR0,  r1, MMX_WR0
+	wstrd	wR1,  r1, MMX_WR1
+	wstrd	wR2,  r1, MMX_WR2
+	wstrd	wR3,  r1, MMX_WR3
+	wstrd	wR4,  r1, MMX_WR4
+	wstrd	wR5,  r1, MMX_WR5
+	wstrd	wR6,  r1, MMX_WR6
+	wstrd	wR7,  r1, MMX_WR7
+	wstrd	wR8,  r1, MMX_WR8
+	wstrd	wR9,  r1, MMX_WR9
+	wstrd	wR10, r1, MMX_WR10
+	wstrd	wR11, r1, MMX_WR11
+	wstrd	wR12, r1, MMX_WR12
+	wstrd	wR13, r1, MMX_WR13
+	wstrd	wR14, r1, MMX_WR14
+	wstrd	wR15, r1, MMX_WR15
 
 2:	teq	r0, #0				@ anything to load?
 	reteq	lr				@ if not, return
@@ -147,30 +148,30 @@ concan_dump:
 concan_load:
 
 	@ Load wRn
-	wldrd	wR0,  [r0, #MMX_WR0]
-	wldrd	wR1,  [r0, #MMX_WR1]
-	wldrd	wR2,  [r0, #MMX_WR2]
-	wldrd	wR3,  [r0, #MMX_WR3]
-	wldrd	wR4,  [r0, #MMX_WR4]
-	wldrd	wR5,  [r0, #MMX_WR5]
-	wldrd	wR6,  [r0, #MMX_WR6]
-	wldrd	wR7,  [r0, #MMX_WR7]
-	wldrd	wR8,  [r0, #MMX_WR8]
-	wldrd	wR9,  [r0, #MMX_WR9]
-	wldrd	wR10, [r0, #MMX_WR10]
-	wldrd	wR11, [r0, #MMX_WR11]
-	wldrd	wR12, [r0, #MMX_WR12]
-	wldrd	wR13, [r0, #MMX_WR13]
-	wldrd	wR14, [r0, #MMX_WR14]
-	wldrd	wR15, [r0, #MMX_WR15]
+	wldrd	wR0,  r0, MMX_WR0
+	wldrd	wR1,  r0, MMX_WR1
+	wldrd	wR2,  r0, MMX_WR2
+	wldrd	wR3,  r0, MMX_WR3
+	wldrd	wR4,  r0, MMX_WR4
+	wldrd	wR5,  r0, MMX_WR5
+	wldrd	wR6,  r0, MMX_WR6
+	wldrd	wR7,  r0, MMX_WR7
+	wldrd	wR8,  r0, MMX_WR8
+	wldrd	wR9,  r0, MMX_WR9
+	wldrd	wR10, r0, MMX_WR10
+	wldrd	wR11, r0, MMX_WR11
+	wldrd	wR12, r0, MMX_WR12
+	wldrd	wR13, r0, MMX_WR13
+	wldrd	wR14, r0, MMX_WR14
+	wldrd	wR15, r0, MMX_WR15
 
 	@ Load wCx
-	wldrw	wCSSF, [r0, #MMX_WCSSF]
-	wldrw	wCASF, [r0, #MMX_WCASF]
-	wldrw	wCGR0, [r0, #MMX_WCGR0]
-	wldrw	wCGR1, [r0, #MMX_WCGR1]
-	wldrw	wCGR2, [r0, #MMX_WCGR2]
-	wldrw	wCGR3, [r0, #MMX_WCGR3]
+	wldrw	wCSSF, r0, MMX_WCSSF
+	wldrw	wCASF, r0, MMX_WCASF
+	wldrw	wCGR0, r0, MMX_WCGR0
+	wldrw	wCGR1, r0, MMX_WCGR1
+	wldrw	wCGR2, r0, MMX_WCGR2
+	wldrw	wCGR3, r0, MMX_WCGR3
 
 	@ clear CUP/MUP (only if r1 != 0)
 	teq	r1, #0
diff --git a/arch/arm/kernel/iwmmxt.h b/arch/arm/kernel/iwmmxt.h
new file mode 100644
index 000000000000..fb627286f5bb
--- /dev/null
+++ b/arch/arm/kernel/iwmmxt.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __IWMMXT_H__
+#define __IWMMXT_H__
+
+.irp b, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15
+.set .LwR\b, \b
+.set .Lr\b, \b
+.endr
+
+.set .LwCSSF, 0x2
+.set .LwCASF, 0x3
+.set .LwCGR0, 0x8
+.set .LwCGR1, 0x9
+.set .LwCGR2, 0xa
+.set .LwCGR3, 0xb
+
+.macro wldrd, reg:req, base:req, offset:req
+.inst 0xedd00100 | (.L\reg << 12) | (.L\base << 16) | (\offset >> 2)
+.endm
+
+.macro wldrw, reg:req, base:req, offset:req
+.inst 0xfd900100 | (.L\reg << 12) | (.L\base << 16) | (\offset >> 2)
+.endm
+
+.macro wstrd, reg:req, base:req, offset:req
+.inst 0xedc00100 | (.L\reg << 12) | (.L\base << 16) | (\offset >> 2)
+.endm
+
+.macro wstrw, reg:req, base:req, offset:req
+.inst 0xfd800100 | (.L\reg << 12) | (.L\base << 16) | (\offset >> 2)
+.endm
+
+#ifdef __clang__
+
+#define wCon c1
+
+.macro tmrc, dest:req, control:req
+mrc p1, 0, \dest, \control, c0, 0
+.endm
+
+.macro tmcr, control:req, src:req
+mcr p1, 0, \src, \control, c0, 0
+.endm
+#endif
+
+#endif
-- 
2.25.1

