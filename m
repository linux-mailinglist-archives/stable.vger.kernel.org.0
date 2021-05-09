Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACDD0377626
	for <lists+stable@lfdr.de>; Sun,  9 May 2021 12:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbhEIKHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 May 2021 06:07:09 -0400
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:45279 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229555AbhEIKHI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 May 2021 06:07:08 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.west.internal (Postfix) with ESMTP id 9D65B19D5;
        Sun,  9 May 2021 06:06:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 09 May 2021 06:06:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vBj74J
        fIrDdENOGPSOIOyra+inB1TX86rqsQwq/a6RA=; b=c7rwq9Cl64Tw0Pz9AmH57f
        muKHAGlyuvOqSkGeS83A79huN8j3lK2waaozF+VakuIjqg1Ukdzz5nb4h4Xd646y
        6ALqqoefvPQgej3qSuwqSOT500Dy+2/w2RR+sdz7IL0ef2LJELie7W/Zw0ZzlVUg
        hCHORqhs1Gor/Qgw6cpoiL2QOaVFntK035xJ4CGrqLuia71sgq9l9TJ1WwG4Cwkb
        7ZWrYfPaJW/OatuX3qrChYPQYH5vYukBpJBQbhYD2W5Rke580ur+F5cNR3Ko7/dY
        L441/ho06f8vw9BfRMmY/G2uTGbM45Tvt7m7ppYWW+r8Kxcdr8ZQ/koR1XMesXEg
        ==
X-ME-Sender: <xms:DLSXYDxIAP_UBKESSj97BKIXEnWdCv6eIq_aDmQaVTasjIdrWq3R0A>
    <xme:DLSXYLTFSruzKW9MnNCEvro--ecGTJpbaSsg-i-PXh-hjgki_hyuuTV_h50c4Exfo
    tnTT1IeuqebXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegiedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:DLSXYNU9xj0cnsYaWrIey4b9u96SMRfTHo8T9E-FmPyx57IwhfQFrA>
    <xmx:DLSXYNgdNWRld7cPSxaNrC7iJhfUekS9__rDhABqamcucyrWks15WA>
    <xmx:DLSXYFCJ0XImpteo0mTbGhG11qDkXuOTwV8NOO5AAOweBGQHyw9zKw>
    <xmx:DLSXYIpgC3o8dL3M5rLDe_Exn1p-ASvOxtc4HBKEdBLCQOsTrLSKYhJK2K4>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun,  9 May 2021 06:06:03 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: vdso: fix and clean-up Makefile" failed to apply to 5.11-stable tree
To:     jszhang@kernel.org, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 09 May 2021 12:05:54 +0200
Message-ID: <162055475443170@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
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

