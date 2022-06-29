Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60FFA56087A
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232614AbiF2SDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiF2SDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:08 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 161643E5E0;
        Wed, 29 Jun 2022 11:02:58 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id x20so9209523plx.6;
        Wed, 29 Jun 2022 11:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c/BfwV7Ac7O3/FvU9C6xy5mbVDril5zWZAhGx2T5vDU=;
        b=nJd/VOvuz2RvLCkEoVJGcqnv1ngy1rCy2exAGhm3soFXlIk2KfDQjEI21RZcLMVLqb
         tToZTTc6g2NRNW3I1npqOcPAIs0r9NMR04zxgVMteGRBeV2e9ZFNaYdd5H0CNStP2QOy
         KFg0N9zCnteD45vXHvn0JOl9O7Uz7DN6VITY9NBxtvBh/eqAkbmEkaB9L8OZIw3pr5xi
         mBE43fPOYgrSASVm7W39XlehlZk4Y19tKxPeSI15is28Aoz3R9LJ8arqOG+BjIUsO+Cq
         vaTtkqtfA8BP3SfLe7TcRbQgN9iUm48ICalwLnQEmGeNMQm/lHfdJ4IhH+SAv6FJJ4Lb
         YLVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c/BfwV7Ac7O3/FvU9C6xy5mbVDril5zWZAhGx2T5vDU=;
        b=Z1m4KLBhNIkJJCQNYqvP36LMCYLG4oMUOC+XMB3CuMwr8BtJkLDH33LuEcqVDgb071
         z8q1M0zcfnng7Tx7qDBEkn1V0QZp1BswAHap8Wm6OcbrZK1CfDsf7YqEJgFyaFH/PwSg
         pgHqaTCfFNSd8j2siZmzIRishgN4LP6XMpH4KclDMXgdlFAUY3FifAR3Oq+f1SJYrPbz
         aVpyZoVtxYNb9S9W4wKZ9GwFS4nRa9lCS/+yON+/rXdjP+79aTsidSdIoRcEyFePg18A
         3xwxbSCwAPR+cYy1g5XiW8QYuI9B6EDg4HN9u4+Df3ruqeVLIVxRKV/LIY3ozLXo0Qko
         Vrgw==
X-Gm-Message-State: AJIora8JQeyIAp9CVqGeJKc1UpNrvCDPJjhpEFa8cCLXm7JyLy4psMCJ
        XTuA3MDv89ULgwnPH1WzhXWRvCLuzpY=
X-Google-Smtp-Source: AGRyM1uS02w0E1KpCyQ1rfXaaEJivgCWE7hgDc48G0m9HB4CZyKa0jakl8sp64fnJPnKEazNaCdfDw==
X-Received: by 2002:a17:902:dac1:b0:16a:7560:2ac4 with SMTP id q1-20020a170902dac100b0016a75602ac4mr10236587plx.55.1656525777103;
        Wed, 29 Jun 2022 11:02:57 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nicolas Pitre <nico@fluxnic.net>,
        Andre Przywara <andre.przywara@arm.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jian Cai <caij2003@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list),
        linux-crypto@vger.kernel.org (open list:CRYPTO API),
        linux-omap@vger.kernel.org (open list:OMAP2+ SUPPORT),
        clang-built-linux@googlegroups.com (open list:CLANG/LLVM BUILD SUPPORT),
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 5.4 10/11] crypto: arm - use Kconfig based compiler checks for crypto opcodes
Date:   Wed, 29 Jun 2022 11:02:26 -0700
Message-Id: <20220629180227.3408104-11-f.fainelli@gmail.com>
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

From: Ard Biesheuvel <ard.biesheuvel@linaro.org>

commit b4d0c0aad57ac3bd1b5141bac5ab1ab1d5e442b3 upstream

Instead of allowing the Crypto Extensions algorithms to be selected when
using a toolchain that does not support them, and complain about it at
build time, use the information we have about the compiler to prevent
them from being selected in the first place. Users that are stuck with
a GCC version <4.8 are unlikely to care about these routines anyway, and
it cleans up the Makefile considerably.

While at it, add explicit 'armv8-a' CPU specifiers to the code that uses
the 'crypto-neon-fp-armv8' FPU specifier so we don't regress Clang, which
will complain about this in version 10 and later.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/crypto/Kconfig             | 14 +++++++------
 arch/arm/crypto/Makefile            | 32 ++++++-----------------------
 arch/arm/crypto/crct10dif-ce-core.S |  2 +-
 arch/arm/crypto/ghash-ce-core.S     |  1 +
 arch/arm/crypto/sha1-ce-core.S      |  1 +
 arch/arm/crypto/sha2-ce-core.S      |  1 +
 6 files changed, 18 insertions(+), 33 deletions(-)

diff --git a/arch/arm/crypto/Kconfig b/arch/arm/crypto/Kconfig
index 043b0b18bf7e..f747caea10ff 100644
--- a/arch/arm/crypto/Kconfig
+++ b/arch/arm/crypto/Kconfig
@@ -30,7 +30,7 @@ config CRYPTO_SHA1_ARM_NEON
 
 config CRYPTO_SHA1_ARM_CE
 	tristate "SHA1 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA1_ARM
 	select CRYPTO_HASH
 	help
@@ -39,7 +39,7 @@ config CRYPTO_SHA1_ARM_CE
 
 config CRYPTO_SHA2_ARM_CE
 	tristate "SHA-224/256 digest algorithm (ARM v8 Crypto Extensions)"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_SHA256_ARM
 	select CRYPTO_HASH
 	help
@@ -96,7 +96,7 @@ config CRYPTO_AES_ARM_BS
 
 config CRYPTO_AES_ARM_CE
 	tristate "Accelerated AES using ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_LIB_AES
 	select CRYPTO_SIMD
@@ -106,7 +106,7 @@ config CRYPTO_AES_ARM_CE
 
 config CRYPTO_GHASH_ARM_CE
 	tristate "PMULL-accelerated GHASH using NEON/ARMv8 Crypto Extensions"
-	depends on KERNEL_MODE_NEON
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
 	select CRYPTO_HASH
 	select CRYPTO_CRYPTD
 	select CRYPTO_GF128MUL
@@ -118,12 +118,14 @@ config CRYPTO_GHASH_ARM_CE
 
 config CRYPTO_CRCT10DIF_ARM_CE
 	tristate "CRCT10DIF digest algorithm using PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC_T10DIF
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC_T10DIF
 	select CRYPTO_HASH
 
 config CRYPTO_CRC32_ARM_CE
 	tristate "CRC32(C) digest algorithm using CRC and/or PMULL instructions"
-	depends on KERNEL_MODE_NEON && CRC32
+	depends on KERNEL_MODE_NEON && (CC_IS_CLANG || GCC_VERSION >= 40800)
+	depends on CRC32
 	select CRYPTO_HASH
 
 config CRYPTO_CHACHA20_NEON
diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 4180f3a13512..c0d36771a693 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -12,32 +12,12 @@ obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
 
-ce-obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
-ce-obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
-crc-obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
-
-ifneq ($(crc-obj-y)$(crc-obj-m),)
-ifeq ($(call as-instr,.arch armv8-a\n.arch_extension crc,y,n),y)
-ce-obj-y += $(crc-obj-y)
-ce-obj-m += $(crc-obj-m)
-else
-$(warning These CRC Extensions modules need binutils 2.23 or higher)
-$(warning $(crc-obj-y) $(crc-obj-m))
-endif
-endif
-
-ifneq ($(ce-obj-y)$(ce-obj-m),)
-ifeq ($(call as-instr,.fpu crypto-neon-fp-armv8,y,n),y)
-obj-y += $(ce-obj-y)
-obj-m += $(ce-obj-m)
-else
-$(warning These ARMv8 Crypto Extensions modules need binutils 2.23 or higher)
-$(warning $(ce-obj-y) $(ce-obj-m))
-endif
-endif
+obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
+obj-$(CONFIG_CRYPTO_SHA2_ARM_CE) += sha2-arm-ce.o
+obj-$(CONFIG_CRYPTO_GHASH_ARM_CE) += ghash-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRCT10DIF_ARM_CE) += crct10dif-arm-ce.o
+obj-$(CONFIG_CRYPTO_CRC32_ARM_CE) += crc32-arm-ce.o
 
 aes-arm-y	:= aes-cipher-core.o aes-cipher-glue.o
 aes-arm-bs-y	:= aes-neonbs-core.o aes-neonbs-glue.o
diff --git a/arch/arm/crypto/crct10dif-ce-core.S b/arch/arm/crypto/crct10dif-ce-core.S
index 86be258a803f..46c02c518a30 100644
--- a/arch/arm/crypto/crct10dif-ce-core.S
+++ b/arch/arm/crypto/crct10dif-ce-core.S
@@ -72,7 +72,7 @@
 #endif
 
 	.text
-	.arch		armv7-a
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	init_crc	.req	r0
diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index c47fe81abcb0..534c9647726d 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -88,6 +88,7 @@
 	T3_H		.req	d17
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
diff --git a/arch/arm/crypto/sha1-ce-core.S b/arch/arm/crypto/sha1-ce-core.S
index 49a74a441aec..8a702e051738 100644
--- a/arch/arm/crypto/sha1-ce-core.S
+++ b/arch/arm/crypto/sha1-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q0
diff --git a/arch/arm/crypto/sha2-ce-core.S b/arch/arm/crypto/sha2-ce-core.S
index 4ad517577e23..b6369d2440a1 100644
--- a/arch/arm/crypto/sha2-ce-core.S
+++ b/arch/arm/crypto/sha2-ce-core.S
@@ -10,6 +10,7 @@
 #include <asm/assembler.h>
 
 	.text
+	.arch		armv8-a
 	.fpu		crypto-neon-fp-armv8
 
 	k0		.req	q7
-- 
2.25.1

