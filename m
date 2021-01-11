Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52B9C2F0EA1
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728066AbhAKI7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:59:31 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47299 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727913AbhAKI7b (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:59:31 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 45916195BDC9;
        Mon, 11 Jan 2021 03:58:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Jan 2021 03:58:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=OyCPj+
        JqNDy15M9Hh3a/SsKiR/nKIR0OiAAr1DvF3Qo=; b=d/4v3bKZVh/jkeFKVCvfbk
        Lyl6mLldqcaEN2+7gtsW+aurQQq9ylQ6VjOx2HMwi6412yhp+cJQd4exMkAEs0XB
        ixKbJdxwIiXb0yaB7aeJhjTCzsaTbUu1reLg0cf8JWbBnK9DuD5I1SjBzjbP/1ab
        4phfiAo5WdaPzqoeJmaZbYMsrBCVe0xmkYLoDVw+58twaFr3faFcj4C8h77i3f5V
        o0o0cDqGpO6WZLE/XI1wWYbRlwXtcwaFkXeiW7Gd///qoebFayobeeMrOP6dL1VC
        kR8dTi8TYywWHl037SBNxl9U+xS+UGvCfyZXpxdeKX1GS7wgzUFP9xNgTpomX0aw
        ==
X-ME-Sender: <xms:RBP8Xy-CZWRsY29IRV-L5EAKXcW7SrY8e6j_JGZ6aWEbbdjRyUpZKg>
    <xme:RBP8XyvEeP_tJJaJnaOnFSZiuYOsHCZKNlahRW0q5TNNYlt0xiuq0_rdD21zKACyz
    eAl6KuI8JWa0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeefjeevheefudeftdekvdejteekvefhieeuudeiff
    fhhfettdejkeetgeefjeetteenucffohhmrghinhepkhgvrhhnvghltghirdhorhhgpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:RBP8X4CArl8_K5xrjJQBL29K0uffu8ri72emTq2daNzfKiDzvDdlGg>
    <xmx:RBP8X6cioz8tjdqvLd0-0V7ylDHvXnQhJLlgMH0YnM9HZ1P1lMeJ7Q>
    <xmx:RBP8X3OPz6nRSQjDpjSU88oRiz-0okI4lfGdVsIpjE4M7CQfsU5nQQ>
    <xmx:RRP8XzDRg5FfrTlcR6iuM14U1zji9x0CtexcYC8sqnqEDmhVcvAFNw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4BE57240062;
        Mon, 11 Jan 2021 03:58:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: link with -z norelro for LLD or aarch64-elf" failed to apply to 4.14-stable tree
To:     ndesaulniers@google.com, amodra@gmail.com, ardb@kernel.org,
        bot@kernelci.org, catalin.marinas@arm.com, maskray@google.com,
        natechancellor@gmail.com, qperret@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:59:57 +0100
Message-ID: <1610355597254166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 311bea3cb9ee20ef150ca76fc60a592bf6b159f5 Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Thu, 17 Dec 2020 16:24:32 -0800
Subject: [PATCH] arm64: link with -z norelro for LLD or aarch64-elf
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

With GNU binutils 2.35+, linking with BFD produces warnings for vmlinux:
aarch64-linux-gnu-ld: warning: -z norelro ignored

BFD can produce this warning when the target emulation mode does not
support RELRO program headers, and -z relro or -z norelro is passed.

Alan Modra clarifies:
  The default linker emulation for an aarch64-linux ld.bfd is
  -maarch64linux, the default for an aarch64-elf linker is
  -maarch64elf.  They are not equivalent.  If you choose -maarch64elf
  you get an emulation that doesn't support -z relro.

The ARCH=arm64 kernel prefers -maarch64elf, but may fall back to
-maarch64linux based on the toolchain configuration.

LLD will always create RELRO program header regardless of target
emulation.

To avoid the above warning when linking with BFD, pass -z norelro only
when linking with LLD or with -maarch64linux.

Fixes: 3b92fa7485eb ("arm64: link with -z norelro regardless of CONFIG_RELOCATABLE")
Fixes: 3bbd3db86470 ("arm64: relocatable: fix inconsistencies in linker script and options")
Cc: <stable@vger.kernel.org> # 5.0.x-
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Alan Modra <amodra@gmail.com>
Cc: Fāng-ruì Sòng <maskray@google.com>
Link: https://lore.kernel.org/r/20201218002432.788499-1-ndesaulniers@google.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 6be9b3750250..90309208bb28 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -10,7 +10,7 @@
 #
 # Copyright (C) 1995-2001 by Russell King
 
-LDFLAGS_vmlinux	:=--no-undefined -X -z norelro
+LDFLAGS_vmlinux	:=--no-undefined -X
 
 ifeq ($(CONFIG_RELOCATABLE), y)
 # Pass --no-apply-dynamic-relocs to restore pre-binutils-2.27 behaviour
@@ -115,16 +115,20 @@ KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
 # Prefer the baremetal ELF build target, but not all toolchains include
 # it so fall back to the standard linux version if needed.
-KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb)
+KBUILD_LDFLAGS	+= -EB $(call ld-option, -maarch64elfb, -maarch64linuxb -z norelro)
 UTS_MACHINE	:= aarch64_be
 else
 KBUILD_CPPFLAGS	+= -mlittle-endian
 CHECKFLAGS	+= -D__AARCH64EL__
 # Same as above, prefer ELF but fall back to linux target if needed.
-KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux)
+KBUILD_LDFLAGS	+= -EL $(call ld-option, -maarch64elf, -maarch64linux -z norelro)
 UTS_MACHINE	:= aarch64
 endif
 
+ifeq ($(CONFIG_LD_IS_LLD), y)
+KBUILD_LDFLAGS	+= -z norelro
+endif
+
 CHECKFLAGS	+= -D__aarch64__
 
 ifeq ($(CONFIG_DYNAMIC_FTRACE_WITH_REGS),y)

