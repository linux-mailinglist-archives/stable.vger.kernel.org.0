Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D976F2F0EA2
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbhAKI7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:59:34 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60853 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbhAKI7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:59:34 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 6ED60195C75F;
        Mon, 11 Jan 2021 03:58:48 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 03:58:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VbR7nO
        ZBbtU/quvw80zECfrDKTbCNG3YOtdU6R3gn4M=; b=YwJyUcJ96ljE26tnzZYSXI
        bZXu0mmhiLfAe3QqFS1kAtdAu5cQtMgAVTo97yIcJR8OJW6yRxc9OIPDsNQd0y1O
        kkwSbYWBAedFVI4LrGTaF8k5GHSMPywEKGnwIz2uWPmLd/S6bdYSxNYgd4Z/KErS
        jay+UCvXzm4HvZAnHXNVRf7ODjW6B0wwtUqVNPpDPL3bi6b8gowIjs1ghd0IIlb4
        WQ7X3LHgpbQ3Qp9T53CAQWlkxsJJDK3nUoCGKCHlHk/94OY5SKe4TMd26Gr/6gVC
        zpv+85YJLuyoWavUS24S2dHKZiDkakhNaz4pk55c4LwcLCSScheFYw31uC3CTdgg
        ==
X-ME-Sender: <xms:SBP8X1QxFPq_ZllcdgLGI5N752bynmlWN8RNd5Usok7eA23dnyDDhA>
    <xme:SBP8X2NwLKIPIzEcl34o9UZBYA3hwrdHYLykGhXIFDPfZRDDoLN4xP7PxMgyjmSH4
    gBAxOdFKYwjdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeefjeevheefudeftdekvdejteekvefhieeuudeiff
    fhhfettdejkeetgeefjeetteenucffohhmrghinhepkhgvrhhnvghltghirdhorhhgpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:SBP8X4PUpqPw9gOIFYhrS3I9J2hPMbkFOTzMRweFCUbBJCDyJTrQBg>
    <xmx:SBP8X2uxhPyQsGZWg4L8TLfwOpc51aI2GG-CuwIS9L2zmSXUDHZcGQ>
    <xmx:SBP8XyUo637Bq_vky7zjnmeAVdoAx-fG9I5e2dxPHXzN_166NIzYVg>
    <xmx:SBP8X7_c9yqyF2g8lWO5_jzB2Ps4yJ4exr7vjuI8EVUFxJ282h_hvg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2037C24005D;
        Mon, 11 Jan 2021 03:58:48 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: link with -z norelro for LLD or aarch64-elf" failed to apply to 5.4-stable tree
To:     ndesaulniers@google.com, amodra@gmail.com, ardb@kernel.org,
        bot@kernelci.org, catalin.marinas@arm.com, maskray@google.com,
        natechancellor@gmail.com, qperret@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:59:59 +0100
Message-ID: <161035559958166@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

