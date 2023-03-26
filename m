Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3D7F6C962B
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 17:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjCZPfg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 11:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCZPff (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 11:35:35 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F493C03;
        Sun, 26 Mar 2023 08:35:27 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E8DA35C0097;
        Sun, 26 Mar 2023 11:35:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sun, 26 Mar 2023 11:35:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alyssa.is; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1679844919; x=1679931319; bh=yoT/5dYYqL
        s4VW9DjOm5vJu5zkmQqNSHt74uigodyG0=; b=DcZ8FFH+ZKH5Cc/KPXyQ6095+J
        FZRtvDPa/cwFzEybbsCEo67TJTLbJjKI32Agk+2/Ta7JP1bVMjB6H6pQuYL1YYGe
        OM7+8hHmWdvcCNnAQE8CqEh9VcTjJ0iajDhMkDKsb5aKsAcz8m3oLevEmSfmRtJx
        vXtw3tKwrNi+Q6upRcWR4TLDKAQ8r4OxsgC8bEfz078fMl4kBFiknFa2xqYE7Knp
        gy2fB9SJvq78kd6bTwrw7j6kPZDc7LiFvY/UjyjfvBWu1LLwCHoiAXZNsUsYnPOP
        vIZh+d7vcSs/KhwF7irakcBe08zzoeduyAeId4rgcs44WUYrDuvrRBKOge/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1679844919; x=1679931319; bh=yoT/5dYYqLs4V
        W9DjOm5vJu5zkmQqNSHt74uigodyG0=; b=mhZV1XekrPJxvBxD+08qQSkVdeuHR
        S6BLfD8jUebaNfB/6llIvVPeE+iVnyc+8i0ZrUISs9EGu3FEhDc9tXfbbiDg6/Rp
        t7Cn82Z9jTTNrKuBE65KTl4sedDz2sbHCW2KWC7oOV4ccZ7er1pKGXX/0kZ6JuLE
        phrZpaorSOV7tFazWTLIWhvoq4vAEwK8kE89kb1ZVvkxstNRGtqy4YUQ4g7AhDTc
        sipaGzN+dOV63OWWAUGdRIaEgxHBe8U5Vdd8GTgt3UrVrbwgTYJX5DB4jtd0b6lT
        c+5BPvcCm4lcd9mmTPIBApSqYbAZaLyN8GJs9/tHci8u6L/N45yQgwYzA==
X-ME-Sender: <xms:NmYgZAM8DwGMN29GdqG2obCVpaousxTdJZa6vkygu7TjX902y_UrIQ>
    <xme:NmYgZG9bIVhl6RlvVfKGXSiUp2XKl1W7jBH30f9LUUXKeycGjahB1tQdThnWsNNgV
    uBmN3Tn6ETHuUZOtA>
X-ME-Received: <xmr:NmYgZHQADgJ9KkqK31FnxV0-RBbzBDE3czPXOKHDuYSNYD5XClVJaTpJvxw3qT2VPdIa60q8kgUM_CHHhlEWHSGFbVN-yFdrIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehtddgleduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomheptehlhihsshgr
    ucftohhsshcuoehhihesrghlhihsshgrrdhisheqnecuggftrfgrthhtvghrnhepheekgf
    dtveettdekuddugeeugfdujeehuefgleegtedthfffudfhheduhfduuefhnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhephhhisegrlhihshhsrg
    drihhs
X-ME-Proxy: <xmx:NmYgZIvVMbyCHcHQxKTyvg8vqLI4GiwVwP7PATduFkE3bs1DW-ltag>
    <xmx:NmYgZIeSeol3dytw8tE4J0nI_2MO4_sd3JolAgVRPukBHgA8Attc8Q>
    <xmx:NmYgZM1JMFDh7Ug-WGuZ-l_VeLkZvoe9YaSntQwKbDxl7NnIO8HrtQ>
    <xmx:N2YgZM1pUExcWP24azkIfCk7vwjrJZspEDwALDyH0_ShsoBlT4Foyw>
Feedback-ID: i12284293:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 26 Mar 2023 11:35:18 -0400 (EDT)
Received: by x220.qyliss.net (Postfix, from userid 1000)
        id 8850F1FD0; Sun, 26 Mar 2023 15:35:16 +0000 (UTC)
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
        Alyssa Ross <hi@alyssa.is>, stable@vger.kernel.org
Subject: [PATCH] purgatory: fix disabling debug info
Date:   Sun, 26 Mar 2023 15:34:12 +0000
Message-Id: <20230326153412.63128-1-hi@alyssa.is>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
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
---
 arch/riscv/purgatory/Makefile | 12 ++++++------
 arch/x86/purgatory/Makefile   |  4 ++--
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
index d16bf715a586..97001798fa19 100644
--- a/arch/riscv/purgatory/Makefile
+++ b/arch/riscv/purgatory/Makefile
@@ -84,12 +84,12 @@ CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_ctype.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_ctype.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_entry.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memcpy.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_memset.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strcmp.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strlen.o		+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_strncmp.o		+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_entry.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_memcpy.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_memset.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_strcmp.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_strlen.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_strncmp.o		+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)
diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 17f09dc26381..f1b1ef6c4cbf 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -69,8 +69,8 @@ CFLAGS_sha256.o			+= $(PURGATORY_CFLAGS)
 CFLAGS_REMOVE_string.o		+= $(PURGATORY_CFLAGS_REMOVE)
 CFLAGS_string.o			+= $(PURGATORY_CFLAGS)
 
-AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -Wa,-gdwarf-2
-AFLAGS_REMOVE_entry64.o			+= -Wa,-gdwarf-2
+AFLAGS_REMOVE_setup-x86_$(BITS).o	+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
+AFLAGS_REMOVE_entry64.o			+= -g -gdwarf-4 -gdwarf-5 -Wa,-g -Wa,-gdwarf4 -Wa,-gdwarf-5
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)

base-commit: da8e7da11e4ba758caf4c149cc8d8cd555aefe5f
-- 
2.37.1

