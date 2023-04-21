Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B5646EB49C
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 00:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232286AbjDUWVt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 18:21:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDUWVs (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 18:21:48 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3D29C
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 15:21:46 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 70FE33200B52;
        Fri, 21 Apr 2023 18:21:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Fri, 21 Apr 2023 18:21:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1682115703; x=1682202103; bh=aNaKZWZqcP
        1mgR737J1C1Uhoipi+ssCjzHB/2HrpYa8=; b=ctcAwwQu/wQB1V7WepIj4l9pEo
        JuDb10j2pbFgaXGZLt/HqZCJc1dixfchBYlpJhxRriNxC9smunzMCjUhHpA54V9R
        64zEVWTIseZXp2XA7ER1yv9JmybKV/CHSYNZnTbqgM+r2FffqwWb6i0tmCueXfeA
        bk3Nq9lreqDGm3tnoWi7J240/Wzpqn7zwNqkogz5oVzFHwVhFU2+W7nqwWoUZtOR
        YRbHDGgfxk6Sog1I/MPF0onyj+pBj4IbR+C8eL5Cd7eHlXJBOLdxijZZD4RkrfXU
        c98H0qXMSKmhrXFymmjlssh7rS52NCV92p0sbSxPSMYtMCcBMigIJidmmfjQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1682115703; x=1682202103; bh=aNaKZWZqcP1mg
        R737J1C1Uhoipi+ssCjzHB/2HrpYa8=; b=JWRAWVxQ2Z7N/v+8YVXEtH8AcQe2Z
        C6nqL6WwhkhgXvfqlg/damCYkSfBoY14XPPXcT2yBIkPZxw7lnNN/xuWQJ6OzMCv
        YoOtEoT+UjtiPh5iBI5krQkbjV+vY9BSxWHuQR8ky9M7RMN/2zx/xx4xyFrrYkb1
        5rg83JKdepdgZ9DrWxgVJAQ7/AYI0RYTo+wwDPFIvmmKqzIZ25tYMQtLQcOuPHes
        oRnusZg/YqkW+nau4dXxv3Ln4/OHLljU+2lFdRPpzoajTtVh3gFV22AJEz8DLudq
        HLl5eeotRDLxe/BwZUGoJuv5bzVx3SC9+dIviwC9HSotO4tnB9oGp1ldg==
X-ME-Sender: <xms:dgxDZIIi2UABL1vycobwQq371IpJaEI3HGAx6C51E7nNwRGM-RUfOw>
    <xme:dgxDZIKZQoVFt8nIw0rKzMIQoI1pOT-NN5TKNb_emR4UXXonmB6Wv5T3kKt5MkaIV
    W6l04mG4pWBLsIFMg>
X-ME-Received: <xmr:dgxDZIuAfsqLtP7ga4_wDd5s_JB5It0PgNjy2Dwtv31TbhxI8qimy63o3gHwfdsKwkQkak52IfrDTG1Vy4jWcvs4OFsogSc90A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfedthedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepheekgf
    dtveettdekuddugeeugfdujeehuefgleegtedthfffudfhheduhfduuefhnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrg
    drihhs
X-ME-Proxy: <xmx:dgxDZFYJYS6geXhAtXegFjnGAk2CGtMDpf55ddLXfqMsanhaXg0OfA>
    <xmx:dgxDZPYBQFlD9UWbGHvUWCyhMIHrZgVHvBBUhYUPG_2pi6xIBE0jEw>
    <xmx:dgxDZBB2siVJcMeYVDU4x0D2CnotPn-OTEQ0HzhGEQEbkh2soCyS5Q>
    <xmx:dwxDZOX5Een6TGvgkBc6F1A-zSAWh0IgsqJSvA3mLFOjXhnzngYMCg>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 21 Apr 2023 18:21:42 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 4F3533592; Fri, 21 Apr 2023 22:21:39 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     Alyssa Ross <hi@alyssa.is>, Nick Cao <nickcao@nichi.co>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Conor.Dooley@microchip.com
Subject: [PATCH RESEND 6.1.y,6.2.y] purgatory: fix disabling debug info
Date:   Fri, 21 Apr 2023 22:20:56 +0000
Message-Id: <20230421222056.1213099-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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

base-commit: cdc7aff9ed012801e62eedd99e4a5573eccac4db
-- 
2.37.1

