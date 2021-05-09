Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E5D377627
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhEIKHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:07:11 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:40125 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhEIKHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 06:07:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 1387E19EB;
        Sun,  9 May 2021 06:06:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 09 May 2021 06:06:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=m28DCZ
        KkLIGuGbCn9BhHLjxXl/UsAyn1yNMTWiOtkbU=; b=IYHomR/LE3lNNe0NTp5eeR
        3LB2Y4ROlzMuvA/xMLk92arEuRkAL51WmMyyAnmF3HLHkMN1allkt8fiAFB+Wf56
        b4H+TCQtmFFst7uZPJMgFaDOTK67A4mqE506MXN7xWYuM8vU68olOzRlpUn25yYQ
        gL3VdupxniU80s+7h3GZDT24B90+rjzWvk9Cot/QGmb81t2m4Qk//JH4wjYYWSdL
        Y/HnH9/YwUmU3AwTm+1mwU5ORLzh0NU0YwKtFpIXTKP8O351O4Ps0UA5ORdKCOrr
        yR7ALo03NjnJnPvJV3nyDmRQT0evx5b9d9L3xtbaF1X2L4PKA5SmNDpN/Y0CMssA
        ==
X-ME-Sender: <xms:DrSXYK-l0bkn0SPkhWPpLKhPCBk5oZI2OU3vp-RIbFvoDwuzIYJ_kw>
    <xme:DrSXYKvhaEA3KZmGbu4ORi8QR9FWNmj5FRVCPQNxGCLQSrKvGYAkjsiglgDWl-t-N
    wXC-vaa862E1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DrSXYAAQbPK5DugLPb2ommMDpGrcZzTgHGx7rK1u3l2XHZfEmg63Lw>
    <xmx:DrSXYCc8RlMujbIdw9UuJmpo_I5D9u0YvgIC6QJr9zXOPFMy6i82Uw>
    <xmx:DrSXYPNqKhGdk7Ki3Gxy8lH5lfxxMYt3v32RXV0AN2BOAJ95EYwHPA>
    <xmx:DrSXYBUtK9YoKiOu2-KuHAPtWKLRG5CfB1RKYGhHLDncjebGeWmTT55CPSM>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 06:06:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: vdso: fix and clean-up Makefile" failed to apply to 5.12-stable tree
To:     jszhang@kernel.org, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 12:05:55 +0200
Message-ID: <162055475514919@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 772d7891e8b3b0baae7bb88a294d61fd07ba6d15 Mon Sep 17 00:00:00 2001
From: Jisheng Zhang <jszhang@kernel.org>
Date: Fri, 2 Apr 2021 21:29:08 +0800
Subject: [PATCH] riscv: vdso: fix and clean-up Makefile

Running "make" on an already compiled kernel tree will rebuild the
kernel even without any modifications:

  CALL    linux/scripts/checksyscalls.sh
  CALL    linux/scripts/atomic/check-atomics.sh
  CHK     include/generated/compile.h
  SO2S    arch/riscv/kernel/vdso/vdso-syms.S
  AS      arch/riscv/kernel/vdso/vdso-syms.o
  AR      arch/riscv/kernel/vdso/built-in.a
  AR      arch/riscv/kernel/built-in.a
  AR      arch/riscv/built-in.a
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o

The reason is "Any target that utilizes if_changed must be listed in
$(targets), otherwise the command line check will fail, and the target
will always be built" as explained by Documentation/kbuild/makefiles.rst

Fix this build bug by adding vdso-syms.S to $(targets)

At the same time, there are two trivial clean up modifications:

- the vdso-dummy.o is not needed any more after so remove it.

- vdso.lds is a generated file, so it should be prefixed with
  $(obj)/ instead of $(src)/

Fixes: c2c81bb2f691 ("RISC-V: Fix the VDSO symbol generaton for binutils-2.35+")
Cc: stable@vger.kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index ca2b40dfd24b..24d936c147cd 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -23,7 +23,7 @@ ifneq ($(c-gettimeofday-y),)
 endif
 
 # Build rules
-targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds vdso-dummy.o
+targets := $(obj-vdso) vdso.so vdso.so.dbg vdso.lds vdso-syms.S
 obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 obj-y += vdso.o vdso-syms.o
@@ -41,7 +41,7 @@ KASAN_SANITIZE := n
 $(obj)/vdso.o: $(obj)/vdso.so
 
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso.so.dbg: $(src)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.dbg: $(obj)/vdso.lds $(obj-vdso) FORCE
 	$(call if_changed,vdsold)
 LDFLAGS_vdso.so.dbg = -shared -s -soname=linux-vdso.so.1 \
 	--build-id=sha1 --hash-style=both --eh-frame-hdr

