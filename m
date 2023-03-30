Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E12B6D0E29
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 20:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjC3Szs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 14:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3Szs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 14:55:48 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6D2DE;
        Thu, 30 Mar 2023 11:55:46 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.nyi.internal (Postfix) with ESMTP id 796255C0140;
        Thu, 30 Mar 2023 14:55:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 30 Mar 2023 14:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1680202543; x=1680288943; bh=TDo5jZQU9I
        C6sywgEGOqzPOxZ7aUBvX49rI+0P5qm4M=; b=YUUnIRZLMok8GCi4FocI0W8ffH
        OCnwU3bxzlbM5/7WDWYUo45uJ1bg8XOdyeuze5G16V52Aww+hYfVu1D0PKbBAgH4
        zkQXOQaKQu0SXIqtObwFme1g4B4Vbp8uEdBqnFseJxGS4n1MLuwtaP6waWwLfOXr
        KgxghKpkpR2g622ml3kXoBaZj0/vFGdIaERQxhoy8oQOtb7TcNlxFQ0140bFdmeq
        q4qRzIJFVyzlV1TUN9sSIOyC/GtalhQKMWBKU4gZi/m/RE6N9Syg55ZRBglmvZIg
        wxsNmk4zolUakgbsBB/gI5bRS/PGP/PFGwZY4n4CHSnGq4agNBujAg5iFgOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680202543; x=1680288943; bh=TDo5jZQU9IC6s
        ywgEGOqzPOxZ7aUBvX49rI+0P5qm4M=; b=ajTGmETHYzYFDrstGf22x7WNZofkA
        NT8vzSXDCiLD64FmeN/IdTu7WOv2vl2NLzFTlpGQgZMavTYMrp2CRo5a2/mWZPWO
        qz6v3pqocDBXEFJs+6Oxckah37XAJmfcHedQpQ2cpoL/2pqwuEhYyXWr76IEIkBK
        iQJYf+7jIxDyPDZn1bPB6kq6thoItnnyGI9cmckDzjFM6hk1SLoCgzByblbLUfH2
        mAxGgmqKJRnGOhZiPfMqh7/HcZqV9/+hgmF0RKwMR3qIqrLftdCDznRDzwL0FEDv
        Ep39owL9m34YQLVXatTtxG/szBiYeRit+YG5WJWnpQ/qDpmnBtFMZaJ1Q==
X-ME-Sender: <xms:LtslZH6_F25VBTpOAFRk0gSKxli1GSUkbbQWyUndO95RF6Y56khtWA>
    <xme:LtslZM7YRUqU_xB5XRYRQo5T3gPE1pkQiR2XdfMRzIbA4b72YjFqW8shok9IKKd7y
    dN5u-9Dr9V45t3r1w>
X-ME-Received: <xmr:LtslZOe7ztlwA7GxRLBUrrirh73AZD4Sv3XAqDKBNh1LVp3_5Tda48DjHBMLL84JHgIF028L9UExtIG1wqtC6UO3ut-_uwwK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehledgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepueefie
    dvheffveegieejjeevgfejjeduveekffeiveeuvedvtedvhfelieeutdfgnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehhihesrghlhihsshgrrdhish
X-ME-Proxy: <xmx:LtslZIL3rkl7TX1GDdSypybenFWILqzROWAeeos8jvsYoI13L-PK-Q>
    <xmx:LtslZLLy-bW9CXCjyB7dTbzS5NpayGemdVvygt9DAykZGpggMXaKaw>
    <xmx:LtslZBzedqTWGZ0FoZ-wkJLpp6DPC74p5DUGlfrYSGHSm1oc7aTIgA>
    <xmx:L9slZAdMAkfdHmY_WUtkjG1bTdRT_nNFH5DIHtHYZPftdRVLemcgPw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 30 Mar 2023 14:55:42 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 3BF532412; Thu, 30 Mar 2023 18:55:41 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Nick Cao <nickcao@nichi.co>, linux-kbuild@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        linux-riscv@lists.infradead.org, Tom Rix <trix@redhat.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Alyssa Ross <hi@alyssa.is>, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v3] purgatory: fix disabling debug info
Date:   Thu, 30 Mar 2023 18:22:24 +0000
Message-Id: <20230330182223.181775-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
v2: https://lore.kernel.org/r/20230326182120.194541-1-hi@alyssa.is

Difference from v2: replaced asflags-remove-y with every possible
debug flag with asflags-y += -g0, as suggested by Nick Desaulniers.

Additionally, I've CCed the x86 maintainers this time, since Masahiro
said he would like acks from subsystem maintainers, and
get_maintainer.pl didn't pick them the first time around.

 arch/riscv/purgatory/Makefile | 7 +------
 arch/x86/purgatory/Makefile   | 3 +--
 2 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index d16bf715a586..9c1e71853ee7 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -84,12 +84,7 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
+asflags-y			+= -g0
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..8e6c81b1c8f7 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,7 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+asflags-y			+= -g0
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
-- 
2.37.1

