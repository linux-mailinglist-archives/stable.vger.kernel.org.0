Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 383168C0E3
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 20:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfHMSkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 14:40:41 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:40215 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726094AbfHMSkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Aug 2019 14:40:41 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id BF841390;
        Tue, 13 Aug 2019 14:40:39 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 13 Aug 2019 14:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xKs7Cw
        QeocuBHxYF+/JY+YVCSroPc8e5GctiHpXh/AI=; b=ua68c5cCk/2nOUg2Ngd9+8
        lqB5hg77QvXz/n41TtFHrMtDZW0zstU0SAidL1xSIWbvP2SxrtaA2Jwkgid3ggbR
        MxX0dLJf8Hn5u3lDHv3nvqatbg0IPd29zqdziqJaMLNo/fjx/jrO6JFtHzr6lOLS
        EMAkrHvRv1xLvkp0AHd4/alhI4XarloI4uanaTuIDx7Vb9KwlHpSQ0TMU9rup/j/
        Llof1Qk1cz7S/8vYXR9RibkdB0ZeAoXyD9kD4RzUsV4J57gEpDX/nHEnNjVHedW8
        5G+zzhTA7YPnpAcBl3A1WlX0rLfMKhvMxl5MAdqz8u/4phGexMdzAgYdaPTDXQCA
        ==
X-ME-Sender: <xms:JwRTXY6H0R1Yo5a7Q8MgkCOiawRmb7AvwrU1k98By0ts627Y09fm5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddviedguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:JwRTXenEyFUaVqw_r4zWFjJxmn2JIrKB1oh-KAkQr3QSxqyoR9Pjlg>
    <xmx:JwRTXURJIUgMDdwICm4yDbnbQsqgZtA_cmOLjmMlLhk4DvE_fAcW2A>
    <xmx:JwRTXaC9KV7hMaKSY23oFUU_aKxaTtEq3eN5mqN1nF2Lfp-9_CBOlA>
    <xmx:JwRTXadfcQEHpkJq62iP2BmSvoavhSwba_yU2rIodE1l3wDb1n38pw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A68EF380079;
        Tue, 13 Aug 2019 14:40:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/purgatory: Use CFLAGS_REMOVE rather than reset" failed to apply to 4.14-stable tree
To:     ndesaulniers@google.com, peterz@infradead.org, tglx@linutronix.de,
        vaibhavrustagi@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 13 Aug 2019 20:40:29 +0200
Message-ID: <1565721629172250@kroah.com>
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

From b059f801a937d164e03b33c1848bb3dca67c0b04 Mon Sep 17 00:00:00 2001
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 7 Aug 2019 15:15:33 -0700
Subject: [PATCH] x86/purgatory: Use CFLAGS_REMOVE rather than reset
 KBUILD_CFLAGS

KBUILD_CFLAGS is very carefully built up in the top level Makefile,
particularly when cross compiling or using different build tools.
Resetting KBUILD_CFLAGS via := assignment is an antipattern.

The comment above the reset mentions that -pg is problematic.  Other
Makefiles use `CFLAGS_REMOVE_file.o = $(CC_FLAGS_FTRACE)` when
CONFIG_FUNCTION_TRACER is set. Prefer that pattern to wiping out all of
the important KBUILD_CFLAGS then manually having to re-add them. Seems
also that __stack_chk_fail references are generated when using
CONFIG_STACKPROTECTOR or CONFIG_STACKPROTECTOR_STRONG.

Fixes: 8fc5b4d4121c ("purgatory: core purgatory functionality")
Reported-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190807221539.94583-2-ndesaulniers@google.com

diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
index 91ef244026d2..8901a1f89cf5 100644
--- a/arch/x86/purgatory/Makefile
+++ b/arch/x86/purgatory/Makefile
@@ -20,11 +20,34 @@ KCOV_INSTRUMENT := n
 
 # Default KBUILD_CFLAGS can have -pg option set when FTRACE is enabled. That
 # in turn leaves some undefined symbols like __fentry__ in purgatory and not
-# sure how to relocate those. Like kexec-tools, use custom flags.
-
-KBUILD_CFLAGS := -fno-strict-aliasing -Wall -Wstrict-prototypes -fno-zero-initialized-in-bss -fno-builtin -ffreestanding -c -Os -mcmodel=large
-KBUILD_CFLAGS += -m$(BITS)
-KBUILD_CFLAGS += $(call cc-option,-fno-PIE)
+# sure how to relocate those.
+ifdef CONFIG_FUNCTION_TRACER
+CFLAGS_REMOVE_sha256.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_purgatory.o	+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_string.o		+= $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_kexec-purgatory.o	+= $(CC_FLAGS_FTRACE)
+endif
+
+ifdef CONFIG_STACKPROTECTOR
+CFLAGS_REMOVE_sha256.o		+= -fstack-protector
+CFLAGS_REMOVE_purgatory.o	+= -fstack-protector
+CFLAGS_REMOVE_string.o		+= -fstack-protector
+CFLAGS_REMOVE_kexec-purgatory.o	+= -fstack-protector
+endif
+
+ifdef CONFIG_STACKPROTECTOR_STRONG
+CFLAGS_REMOVE_sha256.o		+= -fstack-protector-strong
+CFLAGS_REMOVE_purgatory.o	+= -fstack-protector-strong
+CFLAGS_REMOVE_string.o		+= -fstack-protector-strong
+CFLAGS_REMOVE_kexec-purgatory.o	+= -fstack-protector-strong
+endif
+
+ifdef CONFIG_RETPOLINE
+CFLAGS_REMOVE_sha256.o		+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_purgatory.o	+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_string.o		+= $(RETPOLINE_CFLAGS)
+CFLAGS_REMOVE_kexec-purgatory.o	+= $(RETPOLINE_CFLAGS)
+endif
 
 $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
 		$(call if_changed,ld)

