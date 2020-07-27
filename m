Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8BF622ED02
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgG0NSN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:18:13 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57639 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728179AbgG0NSN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:18:13 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 730B51942010;
        Mon, 27 Jul 2020 09:18:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:18:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=3LyBnk
        /zyor2PuG14xzGkSjdh6HBm/iL5HNu1qzcz98=; b=EhsfPhfUWyiC5fw5MTA9Wg
        q5Wv+jCyfPTWnIDDjfCIx+TFGdXS+xUtejihSFIg//AzgqkmnumUSnyko5OBIQBg
        V5nh8i4W8qybh5hN+P+svBJOmCwPynVSydPeDcM6dojOeTxjmrgf8IO8hDZbc600
        HkHpe3u81rSUA93CfYRAKRIOss7JPg1NkzVeNYuefhG6TywZv9vanZGy5z87nOu/
        zno91RI8T3+s8tjI1xFSAO3hr2nr644Z+5gfqafNHMh+DwMYS6AdPdAsSOp3n1iF
        8OOalmHwiDY4UDP7g+1HMLcqKrmRcotE1v4QjBRAnnrOxw1H+AISXrtfyT+oQxuA
        ==
X-ME-Sender: <xms:FNQeX8vZnqckOMdDdRdkcdNzVpgdJqyWMzAfNB9XbhPWmxiuvzsk6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedtueevueduhfdtffdtvdeiteetkeeggfeuveetgfeffe
    euteffgedvieeludevkeenucffohhmrghinhepghhithhhuhgsrdgtohhmpdhkvghrnhgv
    lhdrohhrghenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivg
    epfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:FNQeX5c5aS_ibgaKWEYl2G-rGI6NDSv8nmOD7uhGepe9FgFb7oF6RQ>
    <xmx:FNQeX3yHH7qAJ_Cov4zJv5D9wk8_76W-oSDe7o4s6AoDFOg2AOfGig>
    <xmx:FNQeX_ODWUZkf-UKDJBYzEdNdhzMZNuqxRBco0buBQDhSmqakr-udQ>
    <xmx:FNQeX1Jo7AIBKgPY9tVbUCyqj66MAVXfRU3DlRhLwJpp3ySWnya5ig>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1590230600B2;
        Mon, 27 Jul 2020 09:18:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: vdso32: Fix '--prefix=' value for newer versions of" failed to apply to 4.9-stable tree
To:     natechancellor@gmail.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:18:02 +0200
Message-ID: <159585588299157@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

