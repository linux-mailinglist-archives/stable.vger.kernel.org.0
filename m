Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A227522ECDD
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 15:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbgG0NIC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 09:08:02 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:33741 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728141AbgG0NIC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 09:08:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 281B61941E76;
        Mon, 27 Jul 2020 09:08:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 27 Jul 2020 09:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=exg+Yx
        gmNEhgmFvUEd6JhBkreBfrVMcHtz5akqdER8w=; b=iIRMbD06EZpJEdynMEXVHA
        vQI0RN1nsHTHLFLsIMOlIR9zaCXQJYSG6pcIppmb/LXOxb01gqt18OQjdO9W+Hx4
        VzwxWHzhNhxBKnGBhxWeD59KmBNcn2iD+jPTG+JhXg/lKcKXGx2MblJH2v+H/fWA
        Bs9oXZtHcrrpE1hQ9L6tNqwYlHvL1D8Q4//MXQwVQA2JlHxmvVZcm0EQ5CJcQPbB
        pe4gNlfb/DdDG0J8a0W8/qSmDec8wOkI7sCFT9mNH87e8sEEuLWP0QVwt5S1ZGdb
        sjLEhbzRxFoqb/m1hPucogzCn3cY17oepwcDHZCuFGTciObJJ9afhob8PuquRU7w
        ==
X-ME-Sender: <xms:sNEeXz7gv4I3ZE4ZJWq0USLN2YB-Go2xvYIEHX-1En4-qELkj9ochg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedriedtgdeiudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffedtge
    dvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeek
    fedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:sNEeX45KSNQGogy-ikLMZY8e7U0KTml-pArvOzv2Ech-XTRN6NMGBQ>
    <xmx:sNEeX6eqCyyXWC1mLAoMaRz2roybZzGPHMYjn5XF1M0ftIrykDsoZA>
    <xmx:sNEeX0IfIaW1lTLQtb7HiJM2HEvjXb7EHeEUV3u2NzNCDJu9NqZDqQ>
    <xmx:sdEeX9gQkHk_I82VaJgsQM2gpV3bpUNWPDbYcidplJWbvLYcacH0cg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A9EE730600A6;
        Mon, 27 Jul 2020 09:08:00 -0400 (EDT)
Subject: FAILED: patch "[PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross" failed to apply to 4.4-stable tree
To:     maskray@google.com, masahiroy@kernel.org, natechancellor@gmail.com,
        ndesaulniers@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Jul 2020 15:07:57 +0200
Message-ID: <159585527713469@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ca9b31f6bb9c6aa9b4e5f0792f39a97bbffb8c51 Mon Sep 17 00:00:00 2001
From: Fangrui Song <maskray@google.com>
Date: Tue, 21 Jul 2020 10:31:23 -0700
Subject: [PATCH] Makefile: Fix GCC_TOOLCHAIN_DIR prefix for Clang cross
 compilation

When CROSS_COMPILE is set (e.g. aarch64-linux-gnu-), if
$(CROSS_COMPILE)elfedit is found at /usr/bin/aarch64-linux-gnu-elfedit,
GCC_TOOLCHAIN_DIR will be set to /usr/bin/.  --prefix= will be set to
/usr/bin/ and Clang as of 11 will search for both
$(prefix)aarch64-linux-gnu-$needle and $(prefix)$needle.

GCC searchs for $(prefix)aarch64-linux-gnu/$version/$needle,
$(prefix)aarch64-linux-gnu/$needle and $(prefix)$needle. In practice,
$(prefix)aarch64-linux-gnu/$needle rarely contains executables.

To better model how GCC's -B/--prefix takes in effect in practice, newer
Clang (since
https://github.com/llvm/llvm-project/commit/3452a0d8c17f7166f479706b293caf6ac76ffd90)
only searches for $(prefix)$needle. Currently it will find /usr/bin/as
instead of /usr/bin/aarch64-linux-gnu-as.

Set --prefix= to $(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
(/usr/bin/aarch64-linux-gnu-) so that newer Clang can find the
appropriate cross compiling GNU as (when -no-integrated-as is in
effect).

Cc: stable@vger.kernel.org
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/1099
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

diff --git a/Makefile b/Makefile
index 676f1cfb1d56..9d9d4166c0be 100644
--- a/Makefile
+++ b/Makefile
@@ -567,7 +567,7 @@ ifneq ($(shell $(CC) --version 2>&1 | head -n 1 | grep clang),)
 ifneq ($(CROSS_COMPILE),)
 CLANG_FLAGS	+= --target=$(notdir $(CROSS_COMPILE:%-=%))
 GCC_TOOLCHAIN_DIR := $(dir $(shell which $(CROSS_COMPILE)elfedit))
-CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)
+CLANG_FLAGS	+= --prefix=$(GCC_TOOLCHAIN_DIR)$(notdir $(CROSS_COMPILE))
 GCC_TOOLCHAIN	:= $(realpath $(GCC_TOOLCHAIN_DIR)/..)
 endif
 ifneq ($(GCC_TOOLCHAIN),)

