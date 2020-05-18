Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783CD1D7B53
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 16:33:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbgEROdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 10:33:18 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:33475 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726940AbgEROdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 May 2020 10:33:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id AE8601940211;
        Mon, 18 May 2020 10:33:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 18 May 2020 10:33:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2lx+s0
        S2CVd3ALl+cx4oHgGSAp+AayR6kRQO+KtVhbs=; b=0x4HNHnXJ7aRg8x95atP1Z
        pCnfELHMF/o0KHcrLDVmjUIYfYeCihYLU1mZZIgohc1Fe9iumyeeKgnnyPfK+BoE
        /r6lGoMdhk9XsT5ptu5AlSjLKt4BoNBAM+ef6RREFaBrr/d23hbzOwTCoPZyhznV
        3t2lMrPfHoF3SEL0i0xruPSKntWZ/KlFpMpVtU84o0PB1GaqF7YVA4arr2UJYFHg
        sHmLuBAQ3WevrHltBUneQcXhXnUAKw8TkZPYZQlNFLpByPhEYmxydilfNIq6g7vv
        1NL2BCJkYh9I2aBUTK8MZR8NnA7S/+QmCsiqsKDjsfUSo6oK0iDyywFJmAnYnDUQ
        ==
X-ME-Sender: <xms:rJzCXtkqNPqceArNXkOAoWBb0kz8_gi1IJ-VqVd0tArWEFS_lDrVpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddthedgjeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:rJzCXo1Qt1wniENfuRIAUSewCPoVeNuPpr_WTf5ikk6U4i4HRXt8bw>
    <xmx:rJzCXjpSyKvpIB8KpESoRwhaMqoxbbh4zPN18lA9-Nz1nv3qbaUi5w>
    <xmx:rJzCXtmKhnySPqF7WkzPwfg1Q4DqFhKDp48lC-9mT4bTdZrTOE22yg>
    <xmx:rJzCXggoznU6_xEmnamUHY67Y1uLSxTddi1UqdAZBY7dDK3cZN1Ynw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4057A30663E4;
        Mon, 18 May 2020 10:33:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: perf: RISCV_BASE_PMU should be independent" failed to apply to 4.19-stable tree
To:     wangkefeng.wang@huawei.com, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 18 May 2020 16:33:04 +0200
Message-ID: <1589812384166154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

