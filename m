Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B912F0EA3
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 10:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbhAKI7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 03:59:33 -0500
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:51341 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727623AbhAKI7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jan 2021 03:59:33 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2A0E4195C5D7;
        Mon, 11 Jan 2021 03:58:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 11 Jan 2021 03:58:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=3idM5K
        erRyfT6ntrtOyZ0bqr02AGuiT+SEM+2zeK47k=; b=K9806VCG360d00uolWNICi
        cf2jgH4x5jA1LVLD3HHhGwIX+Ln3vPYd58K8DIJtJ1J/+rV18AU+rZsf56jMOpZS
        va8/VuAwJbcurLxjsGh9AKgL3clZJpqCQvPgBt+H4+4JhrY13NH94Ffe6X3GDvOk
        aQamyFyrqlwQM3M4MZnNpk3KbniGI9HxLn7c51EwPxzFnPs+RGvrxDBNGXeefhS+
        OhZYaNfpEmo0M1LuXxZa52iuR6/i7y7/qtbZpkflohK3KvMW1v+6d44IoGf0oyIH
        iFOe/jORQkTU0Mezhjcj0dX/z042MFgJqPob1ZyuChS9w5ehOBGVJ8LTjHzWYobg
        ==
X-ME-Sender: <xms:RxP8X-P8s-4KN17nTE3y9GSC2y32HMgEpw_gwwCW_Y-aYpJCJHeWgg>
    <xme:RxP8X-8JPc97YCXwX5LAivy8BvQUCA1qCTqULHESNmKy-JHkPh_sL99rVSP2xq6-1
    dggnVZ0gY9hHg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdehtddguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeefjeevheefudeftdekvdejteekvefhieeuudeiff
    fhhfettdejkeetgeefjeetteenucffohhmrghinhepkhgvrhhnvghltghirdhorhhgpdhk
    vghrnhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghruf
    hiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mh
X-ME-Proxy: <xmx:RxP8X-p1s-bTXVvEretPGcvhNeqqM27zgsFEtZUpfBxQ0UR7PmQXiA>
    <xmx:RxP8Xw5mNrfGjYGTUfdohUaNtBeqUj04fefyLwBh2k66-kls9g5OrA>
    <xmx:RxP8X-P0bNyKXpT_kzN2yQ7nUkg_-oqVT9BcQuOlPWpIHuiSNq22TQ>
    <xmx:RxP8XzalcbEJNAOa1ZkQNUT6xs5gwPMmB4uwK7SBxKrTd-TIgVgfyw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C5CEE108005C;
        Mon, 11 Jan 2021 03:58:46 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: link with -z norelro for LLD or aarch64-elf" failed to apply to 4.19-stable tree
To:     ndesaulniers@google.com, amodra@gmail.com, ardb@kernel.org,
        bot@kernelci.org, catalin.marinas@arm.com, maskray@google.com,
        natechancellor@gmail.com, qperret@google.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Jan 2021 09:59:58 +0100
Message-ID: <16103555987935@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

