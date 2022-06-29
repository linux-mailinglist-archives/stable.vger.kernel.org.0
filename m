Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF4F560867
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbiF2SDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbiF2SDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:06 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D7B13DDEB;
        Wed, 29 Jun 2022 11:02:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id bo5so15831835pfb.4;
        Wed, 29 Jun 2022 11:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKeg97WBqSrHg/vFckVR4dCqjwAhqI/IXZ1Q/lkCmf8=;
        b=ISwwkFSMXNmwihh0c/UJaP/xtQP9g31ma35ZrrNn/SoIzpnxwQXjOjZNdjxTlC33+c
         Vk1Cf/zt0ug5TlLGzU8ZK2EFGoKRYPHAb1dKXaTKiRgPoC6/SYotnx6gOj6l8qMc5XHZ
         9o2im0w4Yykeuey2NfE43x+g/xb6o574AjFM9SHsWdLvj2L30rcLSBAHvvuwD9lvxkMa
         Bl6oqdYClyVww87YK9KUCRoTqIZNIfFSfGCHaU+tjw2c/z3HPQVUbDue7DzUwERRG+Z0
         DekxBb6QT/sNrYGgzddrLKVD8Mn/2CTJVu8/tSomsTS3eBcEpPpCpY4oX4C2wGQahbkF
         lsCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKeg97WBqSrHg/vFckVR4dCqjwAhqI/IXZ1Q/lkCmf8=;
        b=5pZIe+e6Vdfn6pCnCq1ty7nlDJUHnmmBTGcavnAxrCgndwtVHyBjTuJiVpXIFg1GAt
         32yp9FrdmTeWMTc/YARkC3tIEUTgFjCIaX1ggPWE9c+0eX+liMeL7A1D8d0h7Nhpf/NV
         u7jbRygI9I8qP79axdWh64DUiLfbTnhk3dDonFMF4q9XBDk8dS2kxAeqSe7EG/mihR00
         ar/yz7R1eQQgYawzVLlLX9dKzxQYg67oyEcsRwO8Pf+d10X/TbMtxaHXz1LW9Wqs2djA
         XvYZJYYyJQFqtT1EtVajBxnSITe3Hoc8hW/QBox6hM7wE98i7n6bvleuRyRqihhSeEm/
         Wa7A==
X-Gm-Message-State: AJIora9HVQkbjoieQzjPw9YCoJlAeexYeFkVfp32YnIyD4Y9n892W6Cq
        wkXl2eTLRuMEwcvwqMF27X4GbjpbI/0=
X-Google-Smtp-Source: AGRyM1tCReeMqjHifXi7iL0KQsSMeJXK+z+t9nI6L7nrRR+iaxD3DpoYzkksQnrrD8SyZ5p6yZICNg==
X-Received: by 2002:a63:91c1:0:b0:40d:33cb:3d57 with SMTP id l184-20020a6391c1000000b0040d33cb3d57mr4038974pge.10.1656525771628;
        Wed, 29 Jun 2022 11:02:51 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:51 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
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
Subject: [PATCH stable 5.4 07/11] ARM: 8929/1: use APSR_nzcv instead of r15 as mrc operand
Date:   Wed, 29 Jun 2022 11:02:23 -0700
Message-Id: <20220629180227.3408104-8-f.fainelli@gmail.com>
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

From: Stefan Agner <stefan@agner.ch>

commit 9f1984c6ae30e2a379751339ce3375a21099b5d4 upstream

LLVM's integrated assembler does not accept r15 as mrc operand.
  arch/arm/boot/compressed/head.S:1267:16: error: operand must be a register in range [r0, r14] or apsr_nzcv
  1: mrc p15, 0, r15, c7, c14, 3 @ test,clean,invalidate D cache
                 ^

Use APSR_nzcv instead of r15. The GNU assembler supports this
syntax since binutils 2.21 [0].

[0] https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commit;h=db472d6ff0f438a21b357249a9b48e4b74498076

Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/boot/compressed/head.S | 2 +-
 arch/arm/mm/proc-arm1026.S      | 4 ++--
 arch/arm/mm/proc-arm926.S       | 4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed/head.S
index cdaf94027d3b..17f87f4c74f5 100644
--- a/arch/arm/boot/compressed/head.S
+++ b/arch/arm/boot/compressed/head.S
@@ -1274,7 +1274,7 @@ iflush:
 __armv5tej_mmu_cache_flush:
 		tst	r4, #1
 		movne	pc, lr
-1:		mrc	p15, 0, r15, c7, c14, 3	@ test,clean,invalidate D cache
+1:		mrc	p15, 0, APSR_nzcv, c7, c14, 3	@ test,clean,invalidate D cache
 		bne	1b
 		mcr	p15, 0, r0, c7, c5, 0	@ flush I cache
 		mcr	p15, 0, r0, c7, c10, 4	@ drain WB
diff --git a/arch/arm/mm/proc-arm1026.S b/arch/arm/mm/proc-arm1026.S
index 10e21012380b..0bdf25a95b10 100644
--- a/arch/arm/mm/proc-arm1026.S
+++ b/arch/arm/mm/proc-arm1026.S
@@ -138,7 +138,7 @@ ENTRY(arm1026_flush_kern_cache_all)
 	mov	ip, #0
 __flush_whole_cache:
 #ifndef CONFIG_CPU_DCACHE_DISABLE
-1:	mrc	p15, 0, r15, c7, c14, 3		@ test, clean, invalidate
+1:	mrc	p15, 0, APSR_nzcv, c7, c14, 3		@ test, clean, invalidate
 	bne	1b
 #endif
 	tst	r2, #VM_EXEC
@@ -363,7 +363,7 @@ ENTRY(cpu_arm1026_switch_mm)
 #ifdef CONFIG_MMU
 	mov	r1, #0
 #ifndef CONFIG_CPU_DCACHE_DISABLE
-1:	mrc	p15, 0, r15, c7, c14, 3		@ test, clean, invalidate
+1:	mrc	p15, 0, APSR_nzcv, c7, c14, 3		@ test, clean, invalidate
 	bne	1b
 #endif
 #ifndef CONFIG_CPU_ICACHE_DISABLE
diff --git a/arch/arm/mm/proc-arm926.S b/arch/arm/mm/proc-arm926.S
index 3188ab2bac61..1ba253c2bce1 100644
--- a/arch/arm/mm/proc-arm926.S
+++ b/arch/arm/mm/proc-arm926.S
@@ -131,7 +131,7 @@ __flush_whole_cache:
 #ifdef CONFIG_CPU_DCACHE_WRITETHROUGH
 	mcr	p15, 0, ip, c7, c6, 0		@ invalidate D cache
 #else
-1:	mrc	p15, 0, r15, c7, c14, 3 	@ test,clean,invalidate
+1:	mrc	p15, 0, APSR_nzcv, c7, c14, 3 	@ test,clean,invalidate
 	bne	1b
 #endif
 	tst	r2, #VM_EXEC
@@ -358,7 +358,7 @@ ENTRY(cpu_arm926_switch_mm)
 	mcr	p15, 0, ip, c7, c6, 0		@ invalidate D cache
 #else
 @ && 'Clean & Invalidate whole DCache'
-1:	mrc	p15, 0, r15, c7, c14, 3 	@ test,clean,invalidate
+1:	mrc	p15, 0, APSR_nzcv, c7, c14, 3 	@ test,clean,invalidate
 	bne	1b
 #endif
 	mcr	p15, 0, ip, c7, c5, 0		@ invalidate I cache
-- 
2.25.1

