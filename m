Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6191D7B52
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgEROdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:33:09 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:53391 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbgEROdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:33:09 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E5A381940F71;
        Mon, 18 May 2020 10:33:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 18 May 2020 10:33:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=jw5auJ
        X5F8yiRzblBZS1oRy9kapVh7hzjGx+rf0ryNY=; b=CV1eUOW3li687dg3TNK6/S
        /8u/FBQo97kxCrcetJQtknwqH9kU/xqBfsFkh0ztdK89osMNV/p7Ilk9oi9oNCm9
        gzCVSXhGYZ7Vcd1IhR7NFrV85GNJJEUqdVl7WKlWyHTZs0L+t2EkRM5dETh2IEMx
        hxEZyoVS42BFDTDijrErncCdR31/AwbG816Ebf27pFf2n+oP45AgLb+6yxBCLKfC
        U8aQt6afw2VdasTOqu6aVnUBKFwO3eVXu0ZtSp8/uH3C8nlDYbElpxnNGZCVWnUG
        TkRAWt5uARcSB+6sj+gvk/ufReEcnHr4egWu2QO/X5jgwDmGCfC1JLPvy48p5oKQ
        ==
X-ME-Sender: <xms:o5zCXiajNCSv2-V8VzVaKxUVT1KDsFgfGWmVylWBnBE8hgh30belFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:o5zCXla3-1fIntuvdqbbfxfGOpV-fXkd3jalHSuI6OJbP5SJBeYgyQ>
    <xmx:o5zCXs-rjCvdDEhzvoz8m5wyFe2v_vdJcT99HLPAfgWfyDKT6Gw4Lw>
    <xmx:o5zCXkqN-Bb21JRIkKZuNuPGc7NAr9RB5YcjCKrCX0qiN6MMPr3Cqg>
    <xmx:o5zCXvE-gwdqE-RG3vhE3ZZvg55UqeE__K11scHEhxEHImcAhIi2cg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0E67A328006B;
        Mon, 18 May 2020 10:33:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: perf: RISCV_BASE_PMU should be independent" failed to apply to 5.4-stable tree
To:     wangkefeng.wang@huawei.com, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 16:33:04 +0200
Message-ID: <1589812384215115@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 48084c3595cb7429f6ba734cfea1313573b9a7fa Mon Sep 17 00:00:00 2001
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Date: Thu, 7 May 2020 23:04:45 +0800
Subject: [PATCH] riscv: perf: RISCV_BASE_PMU should be independent

Selecting PERF_EVENTS without selecting RISCV_BASE_PMU results in a build
error.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
[Palmer: commit text]
Fixes: 178e9fc47aae("perf: riscv: preliminary RISC-V support")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/include/asm/perf_event.h b/arch/riscv/include/asm/perf_event.h
index 0234048b12bc..062efd3a1d5d 100644
--- a/arch/riscv/include/asm/perf_event.h
+++ b/arch/riscv/include/asm/perf_event.h
@@ -12,19 +12,14 @@
 #include <linux/ptrace.h>
 #include <linux/interrupt.h>
 
+#ifdef CONFIG_RISCV_BASE_PMU
 #define RISCV_BASE_COUNTERS	2
 
 /*
  * The RISCV_MAX_COUNTERS parameter should be specified.
  */
 
-#ifdef CONFIG_RISCV_BASE_PMU
 #define RISCV_MAX_COUNTERS	2
-#endif
-
-#ifndef RISCV_MAX_COUNTERS
-#error "Please provide a valid RISCV_MAX_COUNTERS for the PMU."
-#endif
 
 /*
  * These are the indexes of bits in counteren register *minus* 1,
@@ -82,6 +77,7 @@ struct riscv_pmu {
 	int		irq;
 };
 
+#endif
 #ifdef CONFIG_PERF_EVENTS
 #define perf_arch_bpf_user_pt_regs(regs) (struct user_regs_struct *)regs
 #endif
diff --git a/arch/riscv/kernel/Makefile b/arch/riscv/kernel/Makefile
index 86c83081044f..d8bbd3207100 100644
--- a/arch/riscv/kernel/Makefile
+++ b/arch/riscv/kernel/Makefile
@@ -43,7 +43,7 @@ obj-$(CONFIG_MODULE_SECTIONS)	+= module-sections.o
 obj-$(CONFIG_FUNCTION_TRACER)	+= mcount.o ftrace.o
 obj-$(CONFIG_DYNAMIC_FTRACE)	+= mcount-dyn.o
 
-obj-$(CONFIG_PERF_EVENTS)	+= perf_event.o
+obj-$(CONFIG_RISCV_BASE_PMU)	+= perf_event.o
 obj-$(CONFIG_PERF_EVENTS)	+= perf_callchain.o
 obj-$(CONFIG_HAVE_PERF_REGS)	+= perf_regs.o
 obj-$(CONFIG_RISCV_SBI)		+= sbi.o

