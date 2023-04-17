Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B686E4EDA
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 19:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbjDQRJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 13:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjDQRJx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 13:09:53 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F23F93C4
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 10:09:24 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 82F8D3200928;
        Mon, 17 Apr 2023 13:09:23 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 17 Apr 2023 13:09:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1681751363; x=
        1681837763; bh=HpcsSLuR2dAn8/4y6Y1uPl276dIa4EkBHGBe0u88dqs=; b=P
        TfFprCcmjKqJts7e1YaeWLjsuXu3y6RZRy7racI8Uy+SW0YZApkxRrHn7BibXvuH
        ++MZHFPEpwMREXQ1fu9CalM3LtWkU7yrvPK8s9CV2jDyfu2pALr8T58krGsBFuwi
        OjSiM8rBnDVKtocUM1qT41iINRVYjlQ5TKjJRvG1Ot/btnoh6jzAjG9ZrG91a1ip
        kiewRw7ICLPcyYDkSXAEQvAjKfHJWKPoCcpy6eCc7zQix8YcU8mPPTTymzyf3BDY
        7z9Vw38OgsB/s3PmA6DTQPuU+X2i3sVcU5qmWlyodrEppzeOWUQzI6Cg3C6wPBJz
        R8Fn7RWFjP35ZZsNRUMJg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1681751363; x=
        1681837763; bh=HpcsSLuR2dAn8/4y6Y1uPl276dIa4EkBHGBe0u88dqs=; b=a
        rSpNWrcbEqi7FhqXpTbwCF8xZkmBA3uhJwFytEP5djmlHWFeMWaHl+Lm+jHTsZoz
        Rs/2dZMWcuH9HIxNj9+jgEeT/X6+IBiV9ez1tthztEtneuuoTzp976S5IfnHu0ZP
        pRsKcZnkn5t8h0AxknMJfuVKAJKajDtMKwcEYmXqB6xihwKBRhWRuXslF3iOb0DF
        yQvIslcUMURmozMzNc8m8vmSOaNeLifLlsDeKCbjqCzOqbG0gT1fkkTwQ7NnsWDv
        b1zOBZOj6fWJj5chP5FDwJRuqjaAT27VfkMvUaYrCyAPLSPDmxcG8TtOr3AMOUFq
        Ggn98Jj+Bgu2ZAjEXvfUA==
X-ME-Sender: <xms:QX09ZPVtSPccWpNTlTbwJdb5O6oCQPQU5rBsaFls3Mm5O3XRafC0-Q>
    <xme:QX09ZHkLc3jRPK39PvpR4uuxcnhsSec8vofx-viSkX_Vd1aLS8kYfXSKjD2_fcBoT
    FR3FR_vJniLikzDOg>
X-ME-Received: <xmr:QX09ZLbwNh5j7DUdUzz0SAlTd9NpOXTZMqKlJU9anY40rrEaZUE0O6OI5EegfKPpRss>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedguddtkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeetlhih
    shhsrgcutfhoshhsuceohhhisegrlhihshhsrgdrihhsqeenucggtffrrghtthgvrhhnpe
    egueeiudeukeekiedvteffgeekudfhudevvdelvdekhfefieetkeduudejffefgeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehhihesrghlhi
    hsshgrrdhish
X-ME-Proxy: <xmx:QX09ZKVtUzqlwDKaQ89r4Jfx_raDmBOi7Jejy172mg_tQhKt2Ss34g>
    <xmx:QX09ZJmxZzAspz5EEYu8K4hyH7OOO5Jj6jSHQTOISfUF7My5ykDemw>
    <xmx:QX09ZHewqK3baXJ78SyPAtkmcsSuAueVz_XcLv8ew61t9sCI6LJ_8g>
    <xmx:Q309ZOz4kxP0X7N_a4LDmVKip4cdFNFV0PL_DSo9cCixnUaQTusVyg>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 13:09:21 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 9BD5F31BE; Mon, 17 Apr 2023 15:32:36 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org
Cc:     Nick Cao <nickcao@nichi.co>, Alyssa Ross <hi@alyssa.is>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.1.y] purgatory: fix disabling debug info
Date:   Mon, 17 Apr 2023 15:31:47 +0000
Message-Id: <20230417153147.1915266-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <2023041747-monogram-playpen-8e77@gregkh>
References: <2023041747-monogram-playpen-8e77@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
-Wa versions of both of those if building with Clang and GNU as.  As a
result, debug info was being generated for the purgatory objects, even
though the intention was that it not be.

Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
Signed-off-by: Alyssa Ross <hi@alyssa.is>
Cc: stable@vger.kernel.org
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
(cherry picked from commit d83806c4c0cccc0d6d3c3581a11983a9c186a138)
Signed-off-by: Alyssa Ross <hi@alyssa.is>
---
 arch/riscv/purgatory/Makefile | 4 +---
 arch/x86/purgatory/Makefile   | 3 +--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index dd58e1d99397..659e21862077 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -74,9 +74,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..82fec66d46d2 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-remove-y		+= $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x))
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)

base-commit: 0102425ac76bd184704c698cab7cb4fe37997556
-- 
2.37.1

