Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEA5560882
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 20:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232634AbiF2SDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 14:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232524AbiF2SDJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 14:03:09 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 063DC3EA81;
        Wed, 29 Jun 2022 11:03:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id i8-20020a17090aee8800b001ecc929d14dso1683557pjz.0;
        Wed, 29 Jun 2022 11:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XIpnrguJEOYbKZ/v8Ohl00ltB40XiJTO7XeAlWHCLZU=;
        b=EFhfK5fl6aJsuSEIcibs1IuZPmDn92r/vQdES53J3+85yqk5ieLBCuem/gCxhqDBO8
         OlyOtiuosuifGLOOE+NtKKBb+ri2UQpPkQr8WGAZ6MakibRX9Jxm0iT9fKbuQWvB6t+a
         1TQHB6/NAj7VyHwMjty0bvXraLl3StzkvduCg9mDVnw+aXfXNaGX2zImJvPbCueja+2H
         63F9RtCUxyPlYwnOMRNEtmA/m1JiVk/0nAvGSqkuVgiudRnRBdlK5J3Yr0u9Y3bwiao5
         +Fl5ofb+S1x+xvyI0OBXNF/U1igKRlMsesYwBsOC0xUXz69K4EIbd14KP1TKuose0zRO
         BrIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XIpnrguJEOYbKZ/v8Ohl00ltB40XiJTO7XeAlWHCLZU=;
        b=dAPoK/ajRqJJ0zbLFjiwxnIXLn7RWL/YlTYJfFD38mp9C78yWGpxaj7WUq5Lns1omb
         oG9yFN9h1vfPlm3kcJpFSrRmi9oav7LR7Z2R84pXU3O4IML1Kw8GJxY0N6RBZx44NNVO
         +60pivEEhcL+08Jzcj0zI2FsNQfpxrxhjL5Vbf/8bYltperKqTiJODZ5H4LQvQreW7yH
         KwxfTsngWufV3YnCs3S9qtHaWpPRLTWYkOjHzQ8paP+svZeL1v+F6kvOOriqAkkw8VA+
         lLAoEocZR4TczzMdaCQHeag2eyjqWSY4u7RC2XRGJRu/xuJCQl+xFOjMjBiy3zNAw86Q
         8V0A==
X-Gm-Message-State: AJIora/rNvcZK9BpHQOkwsPvkDEp3jb5WU9XdmtJ7HN7rHd1ItUuyyoZ
        ZSXN/MPImRuOS1v7PrOtrkMWQiMaDAI=
X-Google-Smtp-Source: AGRyM1vyCTkFgmXF12mnOiBHZeYMSiqKsWZgCTEodWOkPVE2BBWtmZcyCSUyLjU6zi2W79i9BoPDTA==
X-Received: by 2002:a17:90b:4f41:b0:1ed:712:fd80 with SMTP id pj1-20020a17090b4f4100b001ed0712fd80mr6895890pjb.224.1656525779089;
        Wed, 29 Jun 2022 11:02:59 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s7-20020a17090302c700b00168e83eda56sm11736371plk.3.2022.06.29.11.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 11:02:58 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     stable@vger.kernel.org
Cc:     Stefan Agner <stefan@agner.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Tony Lindgren <tony@atomide.com>,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>,
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
Subject: [PATCH stable 5.4 11/11] crypto: arm/ghash-ce - define fpu before fpu registers are referenced
Date:   Wed, 29 Jun 2022 11:02:27 -0700
Message-Id: <20220629180227.3408104-12-f.fainelli@gmail.com>
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

commit 7548bf8c17d84607c106bd45d81834afd95a2edb upstream

Building ARMv7 with Clang's integrated assembler leads to errors such
as:
arch/arm/crypto/ghash-ce-core.S:34:11: error: register name expected
 t3l .req d16
          ^

Since no FPU has selected yet Clang considers d16 not a valid register.
Moving the FPU directive on-top allows Clang to parse the registers and
allows to successfully build this file with Clang's integrated assembler.

Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/crypto/ghash-ce-core.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/crypto/ghash-ce-core.S b/arch/arm/crypto/ghash-ce-core.S
index 534c9647726d..9f51e3fa4526 100644
--- a/arch/arm/crypto/ghash-ce-core.S
+++ b/arch/arm/crypto/ghash-ce-core.S
@@ -8,6 +8,9 @@
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 
+	.arch		armv8-a
+	.fpu		crypto-neon-fp-armv8
+
 	SHASH		.req	q0
 	T1		.req	q1
 	XL		.req	q2
@@ -88,8 +91,6 @@
 	T3_H		.req	d17
 
 	.text
-	.arch		armv8-a
-	.fpu		crypto-neon-fp-armv8
 
 	.macro		__pmull_p64, rd, rn, rm, b1, b2, b3, b4
 	vmull.p64	\rd, \rn, \rm
-- 
2.25.1

