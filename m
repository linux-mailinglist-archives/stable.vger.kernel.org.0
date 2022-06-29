Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F0B56084C
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiF2SCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231689AbiF2SCm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:02:42 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E0F6FCF;
        Wed, 29 Jun 2022 11:02:41 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id b12-20020a17090a6acc00b001ec2b181c98so179912pjm.4;
        Wed, 29 Jun 2022 11:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h7YLJWWkgB25vR4MQko7hOy0PQM4fsrLtI5uxh2dVRg=;
        b=B3Gq/KiJEVC1ZFW/lJCBrIbv/9xn3OBum1E5ddgB64Ak3vJzpHWY4A1t/SnPG8ujf/
         bSNfKQHoI1ya0hHRfTFK8IC+0JJi/KVfFCBytUci+coKhtMedC2eXvQw4rQKKBWnPtCO
         AobOImQhM7+GuQ2RkOg6aoB7viQYGDN46V45WQ23wAPRCDEJMhItdL5liovHV0wAsGRZ
         6yKbWOR7bhT4iy5Bg8yA2IceYcYBgX3U/xSzjGBpiazGC/X/EodrVMeU7ZBZpY3ccRzC
         TSiLys7z98M2S1y0Meeb0HrT80qHNGBDq0R/XEXxOFCqOoq/88mkFLNJ0R5Aq5jRaYO6
         cr5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h7YLJWWkgB25vR4MQko7hOy0PQM4fsrLtI5uxh2dVRg=;
        b=pwREmYvwgATTRDM48TuM6avP+vJ0DFYZIPoUXEYnY0xZaKkztsK3l0ojn7RNdB1nfC
         k59GFRjvnuGfigTVdJZcHNjxWL0rc+IS55Q1gxL7kM00y1uLB499jlJUjPKMUrfTRojt
         rKh9q5xmU4q/QJFBKxRi0IKlURRlqpHJoPwr3cBBtEj7frGO9ywN/qhrXUAHbuGb4M0n
         lOHpuLfD42QehP3dQGhbDIJ3rbez8Y4bry4vSqBuOjoF8I0knB5i0N8G22rpbULuCv3b
         D2G/ikrm6vk14W/i9QbZzWLkejLBNYpVS5IBfIa9iYWEYAK9EkGphThzFfRay9FgjZzy
         OiuA==
X-Gm-Message-State: AJIora+BseCre0kXEb57kt4hWFjN0Fp/6XfZbhn4DnAfX8WrtL81J4qh
        vzdzxVOnB6YAcmNxSatFWsSpePTh98Q=
X-Google-Smtp-Source: AGRyM1t4UW55ivDXRC1neqSdOrOVvLvtYgYW04qhW14ukrfA+CBSk1S/FVxduPbp7kr6fjA2COfE4w==
X-Received: by 2002:a17:902:7604:b0:16a:f36d:73f3 with SMTP id k4-20020a170902760400b0016af36d73f3mr10509893pll.170.1656525760588;
        Wed, 29 Jun 2022 11:02:40 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:40 -0700 (PDT)
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
Subject: [PATCH stable 5.4 01/11] ARM: 8989/1: use .fpu assembler directives instead of assembler arguments
Date:   Wed, 29 Jun 2022 11:02:17 -0700
Message-Id: <20220629180227.3408104-2-f.fainelli@gmail.com>
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

commit a6c30873ee4a5cc0549c1973668156381ab2c1c4 upstream

Explicit FPU selection has been introduced in commit 1a6be26d5b1a
("[ARM] Enable VFP to be built when non-VFP capable CPUs are selected")
to make use of assembler mnemonics for VFP instructions.

However, clang currently does not support passing assembler flags
like this and errors out with:
clang-10: error: the clang compiler does not support '-Wa,-mfpu=softvfp+vfp'

Make use of the .fpu assembler directives to select the floating point
hardware selectively. Also use the new unified assembler language
mnemonics. This allows to build these procedures with Clang.

Link: https://github.com/ClangBuiltLinux/linux/issues/762

Signed-off-by: Stefan Agner <stefan@agner.ch>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/vfp/Makefile |  2 --
 arch/arm/vfp/vfphw.S  | 30 ++++++++++++++++++++----------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/arm/vfp/Makefile b/arch/arm/vfp/Makefile
index 9975b63ac3b0..749901a72d6d 100644
--- a/arch/arm/vfp/Makefile
+++ b/arch/arm/vfp/Makefile
@@ -8,6 +8,4 @@
 # ccflags-y := -DDEBUG
 # asflags-y := -DDEBUG
 
-KBUILD_AFLAGS	:=$(KBUILD_AFLAGS:-msoft-float=-Wa,-mfpu=softvfp+vfp -mfloat-abi=soft)
-
 obj-y		+= vfpmodule.o entry.o vfphw.o vfpsingle.o vfpdouble.o
diff --git a/arch/arm/vfp/vfphw.S b/arch/arm/vfp/vfphw.S
index b530db8f2c6c..772c6a3b1f72 100644
--- a/arch/arm/vfp/vfphw.S
+++ b/arch/arm/vfp/vfphw.S
@@ -253,11 +253,14 @@ vfp_current_hw_state_address:
 
 ENTRY(vfp_get_float)
 	tbl_branch r0, r3, #3
+	.fpu	vfpv2
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	mrc	p10, 0, r0, c\dr, c0, 0	@ fmrs	r0, s0
+1:	vmov	r0, s\dr
 	ret	lr
 	.org	1b + 8
-1:	mrc	p10, 0, r0, c\dr, c0, 4	@ fmrs	r0, s1
+	.endr
+	.irp	dr,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+1:	vmov	r0, s\dr
 	ret	lr
 	.org	1b + 8
 	.endr
@@ -265,11 +268,14 @@ ENDPROC(vfp_get_float)
 
 ENTRY(vfp_put_float)
 	tbl_branch r1, r3, #3
+	.fpu	vfpv2
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	mcr	p10, 0, r0, c\dr, c0, 0	@ fmsr	r0, s0
+1:	vmov	s\dr, r0
 	ret	lr
 	.org	1b + 8
-1:	mcr	p10, 0, r0, c\dr, c0, 4	@ fmsr	r0, s1
+	.endr
+	.irp	dr,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+1:	vmov	s\dr, r0
 	ret	lr
 	.org	1b + 8
 	.endr
@@ -277,15 +283,17 @@ ENDPROC(vfp_put_float)
 
 ENTRY(vfp_get_double)
 	tbl_branch r0, r3, #3
+	.fpu	vfpv2
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	fmrrd	r0, r1, d\dr
+1:	vmov	r0, r1, d\dr
 	ret	lr
 	.org	1b + 8
 	.endr
 #ifdef CONFIG_VFPv3
 	@ d16 - d31 registers
-	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	mrrc	p11, 3, r0, r1, c\dr	@ fmrrd	r0, r1, d\dr
+	.fpu	vfpv3
+	.irp	dr,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+1:	vmov	r0, r1, d\dr
 	ret	lr
 	.org	1b + 8
 	.endr
@@ -299,15 +307,17 @@ ENDPROC(vfp_get_double)
 
 ENTRY(vfp_put_double)
 	tbl_branch r2, r3, #3
+	.fpu	vfpv2
 	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	fmdrr	d\dr, r0, r1
+1:	vmov	d\dr, r0, r1
 	ret	lr
 	.org	1b + 8
 	.endr
 #ifdef CONFIG_VFPv3
+	.fpu	vfpv3
 	@ d16 - d31 registers
-	.irp	dr,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15
-1:	mcrr	p11, 3, r0, r1, c\dr	@ fmdrr	r0, r1, d\dr
+	.irp	dr,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31
+1:	vmov	d\dr, r0, r1
 	ret	lr
 	.org	1b + 8
 	.endr
-- 
2.25.1

