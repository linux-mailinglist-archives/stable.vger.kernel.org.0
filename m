Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7FD7327B70
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:03:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234352AbhCAKCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:02:09 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:45255 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234397AbhCAJ73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:59:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 348BB1940C2B;
        Mon,  1 Mar 2021 04:58:17 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 04:58:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4+H58o
        MzQbYlUp55FMrSlhhqtOR0FqtpgwoZ5pt+08k=; b=VWSbryBGi9HsM1YL1v17a+
        Sax3HrtqSwgxK7O2D4p2UY7tam96yBxJ8mcty0LcbAM81g9KE22ZWfd0QCXxxWvm
        0csbYOuMx/YMOUOjFjmK+ghK/ptGrd6IKROqACenkerfvTBkR09X7jBOCg7JKy7D
        S/UeaJo9pEgOnA751PgoXySbwcM9YYtegYOnCMjFb0FvJPvgtJTzI4cgeXPqsJ3L
        MHwQ/A1+EwEV68wsMwUQl8+tHgAnN6Fl9Kj2x6qkPCPXw1/nohPUiG8EgjTgNykf
        37ttM3gPFsnBP7rO0N0jUa2IZscdM42JflQIPjTurtZ4rsgWCdUi7MRU74RetQGw
        ==
X-ME-Sender: <xms:ubo8YCzS4MSHrnJChw3oyyoCtoyyCtwCwHCGsloTiK3OSth4QmODdg>
    <xme:ubo8YOQgEwHtlDEYLsber1Q-dWSbGjHBbM5fG1IzsnfC5JsdnsEgsQzBSBcnRG6Z4
    j57n-rkpb7XFQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffedtge
    dvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ubo8YEUxQqbAKYrzDFvBLUTUGM0cojPij2Ag1c8-dxww7ruLNuNQkA>
    <xmx:ubo8YIhk8sj-hBghheMAMw5YVTOwKVfmKu7RjERq2ixtUVVvb50Seg>
    <xmx:ubo8YEDCKi_I5LUzVraKR1uc7mjNIXPBtEUTOc6_2uDdO1LYOUF_NA>
    <xmx:ubo8YHPXMzNi7iuQVB2GEZfegefDSu0vWaNzBHK7sCJ5oDulpqL4gA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C4A4D24005C;
        Mon,  1 Mar 2021 04:58:16 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out" failed to apply to 5.4-stable tree
To:     nathan@kernel.org, anders.roxell@linaro.org,
        natechancellor@gmail.com, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:58:07 +0100
Message-ID: <1614592687119110@kroah.com>
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

From 76d7fff22be3e4185ee5f9da2eecbd8188e76b2c Mon Sep 17 00:00:00 2001
From: Nathan Chancellor <nathan@kernel.org>
Date: Fri, 15 Jan 2021 12:26:22 -0700
Subject: [PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out
 '--target='

Commit ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO
cflags") allowed the '--target=' flag from the main Makefile to filter
through to the vDSO. However, it did not bring any of the other clang
specific flags for controlling the integrated assembler and the GNU
tools locations (--prefix=, --gcc-toolchain=, and -no-integrated-as).
Without these, we will get a warning (visible with tinyconfig):

arch/mips/vdso/elf.S:14:1: warning: DWARF2 only supports one section per
compilation unit
.pushsection .note.Linux, "a",@note ; .balign 4 ; .long 2f - 1f ; .long
4484f - 3f ; .long 0 ; 1:.asciz "Linux" ; 2:.balign 4 ; 3:
^
arch/mips/vdso/elf.S:34:2: warning: DWARF2 only supports one section per
compilation unit
 .section .mips_abiflags, "a"
 ^

All of these flags are bundled up under CLANG_FLAGS in the main Makefile
and exported so that they can be added to Makefiles that set their own
CFLAGS. Use this value instead of filtering out '--target=' so there is
no warning and all of the tools are properly used.

Cc: stable@vger.kernel.org
Fixes: ee67855ecd9d ("MIPS: vdso: Allow clang's --target flag in VDSO cflags")
Link: https://github.com/ClangBuiltLinux/linux/issues/1256
Reported-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Anders Roxell <anders.roxell@linaro.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>

diff --git a/arch/mips/vdso/Makefile b/arch/mips/vdso/Makefile
index 5810cc12bc1d..2131d3fd7333 100644
--- a/arch/mips/vdso/Makefile
+++ b/arch/mips/vdso/Makefile
@@ -16,16 +16,13 @@ ccflags-vdso := \
 	$(filter -march=%,$(KBUILD_CFLAGS)) \
 	$(filter -m%-float,$(KBUILD_CFLAGS)) \
 	$(filter -mno-loongson-%,$(KBUILD_CFLAGS)) \
+	$(CLANG_FLAGS) \
 	-D__VDSO__
 
 ifndef CONFIG_64BIT
 ccflags-vdso += -DBUILD_VDSO32
 endif
 
-ifdef CONFIG_CC_IS_CLANG
-ccflags-vdso += $(filter --target=%,$(KBUILD_CFLAGS))
-endif
-
 #
 # The -fno-jump-tables flag only prevents the compiler from generating
 # jump tables but does not prevent the compiler from emitting absolute

