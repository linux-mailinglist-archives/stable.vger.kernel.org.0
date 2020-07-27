Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBB922ED01
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbgG0NSI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:18:08 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40111 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727809AbgG0NSH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:18:07 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AA8271941FF3;
        Mon, 27 Jul 2020 09:18:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:18:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y2X0vw
        vez5xgfCUPh0YCs8OJM86EZ2xroRjHoe1HU2o=; b=meHa5eiJDx0w/HiJYOQOMp
        RbcBDKxoVvjmBdaSPU6TZ1nBrYw/cxqQ33lxbEPFxI85eTM22WNaeZSz0F5fLR8y
        B4dVPPKg7LNUGBKulh6CBtIgicil0u1OWiJ1dt6QtdugCEJXcTptvwrBEFIrwCh/
        Eln8MGmmbjLNcmDMvJy23lWnhCkRbaxqFAO2QWzWmsB6ooVlNXvdA7kUMz4lRZQU
        gKeHB+eu6BIKC7oYOrqgtGJcu7DRqJJ4Co+r0g5Lsf217F2MWhHAXjZ/l4NE2EPX
        IbxBewhYocZ1LIVB1dd8Vd3d2hJmfMKYicgbJMQ6eBOTJ6fHUL/42flh+hflbTcA
        ==
X-ME-Sender: <xms:DtQeXxj7EgyiVEFVpIYJS3BOma45-aUXK2gsJc-EYsA5zdfJpUfsqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedtueevueduhfdtffdtvdeiteetkeeggfeuveetgfeffe
    euteffgedvieeludevkeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgv
    lhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DtQeX2CVwsOJJF4nyjj6zWwG0U4CWke0pPUYzz_y2pTP0TRXYZ51Kg>
    <xmx:DtQeXxEy7hd0AO5x9zMYV47qkU7mwPVpxHmT9gctyQR9gTcjrf-3zw>
    <xmx:DtQeX2QD9ls0eTLPpbPY95H2MR0yTfw-jaeR_My-NgS8mAj12C7K3w>
    <xmx:DtQeXzsUgL2oXIo0MO5X1ALc_xEUpDEKBefCKSKvJBfogEUph9kSXg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4A0223280059;
        Mon, 27 Jul 2020 09:18:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions of" failed to apply to 4.14-stable tree
To:     natechancellor@gmail.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:18:01 +0200
Message-ID: <159585588154180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 7b7891c7bdfd61fc9ed6747a0a05efe2394dddc6 Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <natechancellor@gmail.com>
Date: Wed, 22 Jul 2020 21:15:10 -0700
Subject: [PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions of
 clang

Newer versions of clang only look for $(COMPAT_GCC_TOOLCHAIN_DIR)as [1],
rather than $(COMPAT_GCC_TOOLCHAIN_DIR)$(CROSS_COMPILE_COMPAT)as,
resulting in the following build error:

$ make -skj"$(nproc)" ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_COMPAT=arm-linux-gnueabi- LLVM=1 O=out/aarch64 distclean \
defconfig arch/arm64/kernel/vdso32/
...
/home/nathan/cbl/toolchains/llvm-binutils/bin/as: unrecognized option '-EL'
clang-12: error: assembler command failed with exit code 1 (use -v to see invocation)
make[3]: *** [arch/arm64/kernel/vdso32/Makefile:181: arch/arm64/kernel/vdso32/note.o] Error 1
...

Adding the value of CROSS_COMPILE_COMPAT (adding notdir to account for a
full path for CROSS_COMPILE_COMPAT) fixes this issue, which matches the
solution done for the main Makefile [2].

[1]: https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90
[2]: https://lore.kernel.org/lkml/20200721173125.1273884-1-maskray@google.com/

Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Cc: stable@vger.kernel.org
Link: https://github.com/ClangBuiltLinux/linux/issues/1099
Link: https://lore.kernel.org/r/20200723041509.400450-1-natechancellor@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/vdso32/Makefile b/arch/arm64/kernel/vdso32/Makefile
index d88148bef6b0..5139a5f19256 100644
--- a/arch/arm64/kernel/vdso32/Makefile
+++ b/arch/arm64/kernel/vdso32/Makefile
@@ -14,7 +14,7 @@ COMPAT_GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE_COMPAT)elfedit))
 COMPAT_GCC_TOOLCHAIN := $(realpath $(COMPAT_GCC_TOOLCHAIN_DIR)/..)
 
 CC_COMPAT_CLANG_FLAGS := --target=$(notdir $(CROSS_COMPILE_COMPAT:%-=%))
-CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)
+CC_COMPAT_CLANG_FLAGS += --prefix=$(COMPAT_GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE_COMPAT))
 CC_COMPAT_CLANG_FLAGS += -no-integrated-as -Qunused-arguments
 ifneq ($(COMPAT_GCC_TOOLCHAIN),)
 CC_COMPAT_CLANG_FLAGS += --gcc-toolchain=$(COMPAT_GCC_TOOLCHAIN)

