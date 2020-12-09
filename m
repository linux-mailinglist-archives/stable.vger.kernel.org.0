Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A332D4607
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 16:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727389AbgLIPyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 10:54:52 -0500
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:38715 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731291AbgLIPyw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 10:54:52 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 7C22419439D7;
        Wed,  9 Dec 2020 04:03:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Wed, 09 Dec 2020 04:03:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=87HNsj
        qQSmKaY4GweLWrmcW9PgDXisj5lecmDb5cbu4=; b=o6MvNLawxN9ETUSBYFQ6fX
        7RkCoe2aYJby/VRp+KbpLmkmh9Ehogf6PTqzG/qKekdiu7A8CNAkUVuAy2Q+vR6J
        RDqblau0PLg8ihzYprtAfAZcYj6HbrItYEYObntNUwmTZbUpbCLe0642rusBlfjJ
        P8UpzY7IPCsOe52Xo7KMEmcCBD535ckNeSTh8Ge5RoHiXsd8Q0gvyPU1mFRJzmZG
        Ukoh4UfPe7zUSd6fj0O01VKI+REAj0TAKcVjnVGRhUSCWXLLjk/zZXkVQ9+Md6G+
        BFncTcoluj91ShyR+qL2UwEikRR6ODfQPa8BqqjO0syGoo/Klp2IPC5gafi+cCHg
        ==
X-ME-Sender: <xms:-ZLQX9jor9mgyPVQcmfOOI5ex84JwQ-zrLHsB7Y-8TD9cqjUSiTwVg>
    <xme:-ZLQXyBQLvrzgcCRrjrefM1pKKj6TsRduAwTTOxxQYumBJX_gnSy793x7qk3tT44w
    Xbw_K9OLxTacg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejkecutefuodetggdotefrodftvfcurf
    hrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttdflne
    cuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhgqeen
    ucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffedtgedvje
    euvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:-ZLQX9E1lbbdHq2bs694mAJxQoqpuDdtByrQjhctejuMV0T7vwqF_Q>
    <xmx:-ZLQXyQccevkc-l1MhNUPWAFS6GDRV7wQ3GUt-oFRaB7P8wTUNOaGw>
    <xmx:-ZLQX6wX5UMVvUHwruOHbggXLGJjpIrqy8AIyyNVe3d3XZFplVXROg>
    <xmx:-ZLQX0uMA4R-emvWlTuG1mfy8ipO5PJQg7fBwEt7t8MHyf7_Om94-g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22ECB24005A;
        Wed,  9 Dec 2020 04:03:53 -0500 (EST)
Subject: FAILED: patch "[PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1" failed to apply to 5.4-stable tree
To:     ndesaulniers@google.com, dima@golovin.in, masahiroy@kernel.org,
        maskray@google.com, natechancellor@gmail.com,
        sedat.dilek@gmail.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 09 Dec 2020 10:04:21 +0100
Message-ID: <160750466162135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From b8a9092330da2030496ff357272f342eb970d51b Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 9 Nov 2020 10:35:28 -0800
Subject: [PATCH] Kbuild: do not emit debug info for assembly with LLVM_IAS=1

Clang's integrated assembler produces the warning for assembly files:

warning: DWARF2 only supports one section per compilation unit

If -Wa,-gdwarf-* is unspecified, then debug info is not emitted for
assembly sources (it is still emitted for C sources).  This will be
re-enabled for newer DWARF versions in a follow up patch.

Enables defconfig+CONFIG_DEBUG_INFO to build cleanly with
LLVM=1 LLVM_IAS=1 for x86_64 and arm64.

Cc: <stable@vger.kernel.org>
Link: https://github.com/ClangBuiltLinux/linux/issues/716
Reported-by: Dmitry Golovin <dima@golovin.in>
Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Dmitry Golovin <dima@golovin.in>
Suggested-by: Nathan Chancellor <natechancellor@gmail.com>
Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
Reviewed-by: Fangrui Song <maskray@google.com>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

diff --git a/Makefile b/Makefile
index 87d659d3c8de..ae1592c1f5d6 100644
--- a/Makefile
+++ b/Makefile
@@ -828,7 +828,9 @@ else
 DEBUG_CFLAGS	+= -g
 endif
 
+ifneq ($(LLVM_IAS),1)
 KBUILD_AFLAGS	+= -Wa,-gdwarf-2
+endif
 
 ifdef CONFIG_DEBUG_INFO_DWARF4
 DEBUG_CFLAGS	+= -gdwarf-4

