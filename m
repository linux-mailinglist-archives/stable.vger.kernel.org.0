Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557D3327B69
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234459AbhCAKBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:01:35 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58001 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234364AbhCAJ7X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 04:59:23 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9C8341940B80;
        Mon,  1 Mar 2021 04:58:08 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 04:58:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=gDJkMS
        VLXUHQEvlTLLKZ3wmeGmTYlmELeY8hl68Cou0=; b=dm4jBpCfZBOCr8km1mwfTh
        yiCDfmmxy3oBsMtfeOUCtHnTH3+Pz8HhpuV0oEdTxUGHFZZYMjA20eKDXDn75YD+
        t6YnBvmpiRsVuy86AqgbqrGmUV9MaK7H3/aR4Zg7H7PLqlSgYVcEOFpid+SY0Plk
        EeM15SvtHOKEFSmnUKp5xFraHX95ZIrSifuBsfKTUMMxEumcER/TJ8SYvN2UZbQo
        9EEBe9SHeYCdehCRSHLQOj3pqr7iNQf01cmuoCflysfgUSTGy0pwMshfEvT6EERy
        C9S3+YHAs2G0cgDXUDTG6gdnkYVtLKYXK35PSrLVGusEaqCPTa6KjRq5QrINz8Sw
        ==
X-ME-Sender: <xms:sLo8YGgFYZFmLA7eRLTqeLHwNd5Bn4OwVj2xDx1sIC7Hgp8DEz9Z9A>
    <xme:sLo8YHDZAIWehMm-Rrrxlir5u7HrZCfJwYztvnPZogs3Nh3CpAq2cKU2hYdfQqpAW
    PklsDRO7s8Adw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeitdffteffuddvgfekvefgtdeikeeuudffhefffedtge
    dvjeeuvddugeduledtieenucffohhmrghinhepghhithhhuhgsrdgtohhmnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:sLo8YOGMV-97KInErIyfR4lLoKy0cL5cJaijuDqSs-seWk6rWX8CUQ>
    <xmx:sLo8YPSNKNNnjtgI_AESyR5LGnUGiHvwBE01UijyL0ko-RNyp3dK2g>
    <xmx:sLo8YDxtAQlCyM_SCke0z-ACOHYIgk6pVMvKPWCY8hAsJ5A9XYV8qA>
    <xmx:sLo8YO9lftZwe0t36cv4JSi13KwKmfn4oj9IexpQGkvyyO8np2vdQg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id EA96C24005D;
        Mon,  1 Mar 2021 04:58:07 -0500 (EST)
Subject: FAILED: patch "[PATCH] MIPS: VDSO: Use CLANG_FLAGS instead of filtering out" failed to apply to 4.19-stable tree
To:     nathan@kernel.org, anders.roxell@linaro.org,
        natechancellor@gmail.com, tsbogend@alpha.franken.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 10:58:06 +0100
Message-ID: <16145926867137@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

