Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42E5560862
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiF2SDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbiF2SDE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:04 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A533DA5F;
        Wed, 29 Jun 2022 11:02:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id w1-20020a17090a6b8100b001ef26ab992bso237860pjj.0;
        Wed, 29 Jun 2022 11:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RlIVn4KhgWNNVucL/eFDrRsCrhfeAFEgYpOovza+X8U=;
        b=kYtBq9zRlHyBtNkjaB6WwfnYXMPQEXZTfzXGBCHaq3Z/eFaaMq5a1qSgKow3h0Gmma
         AZwnHDMrMe569ca3/KFlQNG/7bInw5fg+iRDKTb9oNNQCgl0mfZ+S5LqiIPheZaHJJqp
         TrNcVTGUv0a1tDL2PHv13aJ7jjRoauL0NaVPW0IdeXWBD5t54uD6z5clvSIEhD4a2C0O
         mTobjdUPMnXIjn/3TxWz0xcno84Jo1Jkpw7Tse7pEextxJPxgr7UsLfR9RIK6xUriD2y
         SKQ0BUbPG9LQiIsAU9fWhkZLr57mKGSFPVozO1/SnMy9s9qIctQwWvdVU+8zXbzWwWEj
         Pu9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlIVn4KhgWNNVucL/eFDrRsCrhfeAFEgYpOovza+X8U=;
        b=xVACBJzQhKPDvJ5042erwVincbFns8cUU1IbDkiBkUBeUjci1PsgBoJX9FipNYGGQL
         jYDA/j+NDyxE9KvSmSBjM0pWoyFjyqDcfkdYcdzFN596eqEaCHf/SeNG0FyAkY/6ZEQg
         bJEWgnGyDmmFxtFTsuHd+kTyXGKPz9tm6i8DPC9JEbg7fO33tAKSAMkyiv+YZ6Fs+oB6
         GGi8gQ4gY/eKU9GRnvjMCG58fLbaNpaJa62vi7lTeYbcgLB+dRUeuxzrJJDr/PLKojb4
         5DjGVrJcECDVMRVHWXKif6RXvcheSzVoK20kegQONgFpJ0zd8JbYSVoBmpT/fmedZcrb
         YEaQ==
X-Gm-Message-State: AJIora/1Crlk6Wd4PUfKuRvN8MP+UYCm0GCDSyjfNLoSbshI+aEI+43J
        rfReORSbOXI5W/8USTiA+ZSZAhAbVvs=
X-Google-Smtp-Source: AGRyM1u0wL+H1cKe+iE7XnYuazmb8EbuO12Eql59TWho68AKJN4v4wc3YyU7wN3nHHctRB7j3mZCgw==
X-Received: by 2002:a17:903:40c9:b0:16a:2d26:5553 with SMTP id t9-20020a17090340c900b0016a2d265553mr11235357pld.31.1656525767568;
        Wed, 29 Jun 2022 11:02:47 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:47 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
        Stefan Agner <stefan@agner.ch>,
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
Subject: [PATCH stable 5.4 05/11] crypto: arm/sha512-neon - avoid ADRL pseudo instruction
Date:   Wed, 29 Jun 2022 11:02:21 -0700
Message-Id: <20220629180227.3408104-6-f.fainelli@gmail.com>
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

From: Ard Biesheuvel <ardb@kernel.org>

commit 0f5e8323777bfc1c1d2cba71242db6a361de03b6 upstream

The ADRL pseudo instruction is not an architectural construct, but a
convenience macro that was supported by the ARM proprietary assembler
and adopted by binutils GAS as well, but only when assembling in 32-bit
ARM mode. Therefore, it can only be used in assembler code that is known
to assemble in ARM mode only, but as it turns out, the Clang assembler
does not implement ADRL at all, and so it is better to get rid of it
entirely.

So replace the ADRL instruction with a ADR instruction that refers to
a nearer symbol, and apply the delta explicitly using an additional
instruction.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/crypto/sha512-armv4.pl       | 4 ++--
 arch/arm/crypto/sha512-core.S_shipped | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/crypto/sha512-armv4.pl b/arch/arm/crypto/sha512-armv4.pl
index 788c17b56ecc..2a0bdf7dd87c 100644
--- a/arch/arm/crypto/sha512-armv4.pl
+++ b/arch/arm/crypto/sha512-armv4.pl
@@ -212,7 +212,6 @@ $code=<<___;
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -602,7 +601,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	$len,$inp,$len,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	$Ktbl,K512
+	adr	$Ktbl,.Lsha512_block_data_order
+	sub	$Ktbl,$Ktbl,.Lsha512_block_data_order-K512
 	vldmia	$ctx,{$A-$H}		@ load context
 .Loop_neon:
 ___
diff --git a/arch/arm/crypto/sha512-core.S_shipped b/arch/arm/crypto/sha512-core.S_shipped
index 710ea309769e..cf5a7a70ff00 100644
--- a/arch/arm/crypto/sha512-core.S_shipped
+++ b/arch/arm/crypto/sha512-core.S_shipped
@@ -79,7 +79,6 @@
 #else
 .syntax unified
 # ifdef __thumb2__
-#  define adrl adr
 .thumb
 # else
 .code   32
@@ -543,7 +542,8 @@ sha512_block_data_order_neon:
 	dmb				@ errata #451034 on early Cortex A8
 	add	r2,r1,r2,lsl#7	@ len to point at the end of inp
 	VFP_ABI_PUSH
-	adrl	r3,K512
+	adr	r3,.Lsha512_block_data_order
+	sub	r3,r3,.Lsha512_block_data_order-K512
 	vldmia	r0,{d16-d23}		@ load context
 .Loop_neon:
 	vshr.u64	d24,d20,#14	@ 0
-- 
2.25.1

