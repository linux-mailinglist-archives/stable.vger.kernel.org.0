Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3404A6E4B77
	for <lists+stable@lfdr.de>; Mon, 17 Apr 2023 16:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbjDQO32 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Apr 2023 10:29:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjDQO31 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Apr 2023 10:29:27 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2A46E8C
        for <stable@vger.kernel.org>; Mon, 17 Apr 2023 07:29:07 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 79BF1320095B;
        Mon, 17 Apr 2023 10:29:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 17 Apr 2023 10:29:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1681741745; x=
        1681828145; bh=YU2GkcVdE7CtKrNEufYc04onHakx66HiPk8kLbiw3FY=; b=t
        f4TCIqrsXLjOAW1raPz4pHbqYMqb4ZzyDZHjj3wCWqKaa4OhnFXrQpiYBGszPf9F
        PUU6YUPiyvsdHzyCN0607N5m9pIQcRbb8uyG1mJTPPXt5oaPIS5dLFQwbDEfB74j
        S6gJhgJTWm9gBNREKWTu4OxywhRwWOVY85snaqjYj08MSVSevPNp5xiPyEWKKvZ0
        xs4kvgUrViEELp84DAwz0mK146I8kjvqhq9vyQfMhNcQ3pO54zKxGlI2QTFYkFUX
        NICK12mDm/0WxKmSm1oX8WW6IXkiiK5K8S+siCkdeK9/0cP/MmBPdue2wGcejfW0
        3n4MqW+1G66VnIZnPTt4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1681741745; x=
        1681828145; bh=YU2GkcVdE7CtKrNEufYc04onHakx66HiPk8kLbiw3FY=; b=T
        2Rb8Vc/9cR1++HcdZdy1ccSDHOJRamVbX1DSiQ+srUb33QlrvPnvnzMGPNv9jcet
        PUwwsi6rPbMfxXyio2DgQDMRWZwXiGecvO1yDZbnMgBGgeYXLcR+O+r+yfit2gDT
        qR0YPwnQPSiOUpHYxTR+SfGMH8HPx35u1JJfYvu0pENPLoWPgCHnybFJYe9PVugj
        2j28n2rI/+01H+FrRvZFtuLZw1Ql7WIz2QImzLQBD9TJNDWelYpG+TNJwgxYG28I
        dLdXHDSxC0GKB7x98ln9U+xgYKcDMsUGZ3Oxj+aRFJiPgIb1jp6wctrojtp2k/Af
        0PfAo9XyiFxxA6VZK5iFg==
X-ME-Sender: <xms:sFc9ZJFdxZBVO1engoMMi8XZRi_VRuX5zh0sphbJHWF6-CKVWSfqFQ>
    <xme:sFc9ZOU4uz1Zp10KqWfd4WU5MeyAfl3y2GZXIPxgmxgPaREGI-Fj3x0nBNdD-zWya
    o8u3G7HPIGbXL262w>
X-ME-Received: <xmr:sFc9ZLJPUX4D6_j8cKaQO3Txr_Ax9E9-ljGhH3PZmv9yJ6XfQ6kR43kwxJOJgRPl78w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdeliedgjeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgjfhgggfestdekredtredttdenucfhrhhomheptehlhihs
    shgrucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepge
    euieduueekkeeivdetffegkeduhfduvedvledvkefhfeeiteekuddujefffeegnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihsh
    hsrgdrihhs
X-ME-Proxy: <xmx:sFc9ZPFGNO-ZxjayduSjGq8ZEeUAws0J7tNXZ6BvW7GAJZxNOXu1-A>
    <xmx:sFc9ZPV-bnEDmuAI_7-03whUZF4_ON2Dgx1o9KVVgAGNay2zlR34iQ>
    <xmx:sFc9ZKPI3pKUrITkbVqwOExVwehAG_jpeA6_ONVUNdSf-KOZYBsIyw>
    <xmx:sVc9ZMiVTIFrWTUc-6SOAaCIT4tcf13ed1_ZvQ_M1p2ZMqLdJeBg2A>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 17 Apr 2023 10:29:04 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id F2F9E3196; Mon, 17 Apr 2023 13:41:31 +0000 (UTC)
From:   Alyssa Ross <hi@alyssa.is>
To:     stable@vger.kernel.org
Cc:     Nick Cao <nickcao@nichi.co>, Alyssa Ross <hi@alyssa.is>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 6.2.y] purgatory: fix disabling debug info
Date:   Mon, 17 Apr 2023 13:40:44 +0000
Message-Id: <20230417134044.1821014-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <2023041746-daybed-posing-b660@gregkh>
References: <2023041746-daybed-posing-b660@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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

base-commit: cdc7aff9ed012801e62eedd99e4a5573eccac4db
-- 
2.37.1

