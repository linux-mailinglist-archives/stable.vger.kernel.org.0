Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F8C395072
	for <lists+stable@lfdr.de>; Sun, 30 May 2021 12:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbhE3KpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 May 2021 06:45:23 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:39881 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhE3KpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 May 2021 06:45:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 71B1519403F7;
        Sun, 30 May 2021 06:43:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 30 May 2021 06:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=geY5q+
        ZqoZF3yI7gFyNnNaV3FEp7qBpSW6NrWDGTF1A=; b=u6vKUygZwBoX6k/xyjcyB3
        6yZNZaMTH1jQe4Sis8nKcVaQ8veAONVbFRjPGAX1oQhXEjdcRx40iPXmPL1hvycB
        /6kJ7F/U3gY4Xk0yWWU61ZUSW9SU7XKmXOsHDUhtNkeNW6qeLwE+lM6HkCYRF1cV
        8jtPEC0E9Y34qHDcDnDQY5lN/wxNrS+hPrDLp4lPjY0gyKpSyTSFKosvLQEtf5tw
        YESEdGsQj6M5e+kj9LKI7LNYrnyDiWGNHrzd+yAmQrgcCzGdKlAprfOa14TO9t9E
        CZYikBXzZD5ao9Xi4T2OGDJxA0rjLaYSKOGjfj0ek1DyCRxGv38+pua1A4F+lJtw
        ==
X-ME-Sender: <xms:YGyzYBOySRWXMeVTPfOXyMeFL04f-oYOMb6bN4DVZK5qlS0odabh1w>
    <xme:YGyzYD8A2DG0tVVclVNPuLQNCjip9cHQ5VhM12IQwso5NXiFMUP8r8PVkt3IrNhLq
    fitLzXNdEpn4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeluddgfeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:YGyzYAQNpRwdms7m7GqRSKkj-ltfCjMHItWnJYuw0DBUCzmciVoTmQ>
    <xmx:YGyzYNuOiziyFzo09Zc3df2XCBhl3ze4k2Uh3vTw1G2bfk82nFl-9w>
    <xmx:YGyzYJdZ7E3KRBrAAoeSCvzFGeiS6uBAeGq1GCQT7IQQ3rk61P911w>
    <xmx:YGyzYJlGPboExDZeG-o8pYchoTByLtHjNA9d4btR3yiaMiTiaRqNGA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sun, 30 May 2021 06:43:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] riscv: stacktrace: fix the riscv stacktrace when" failed to apply to 5.10-stable tree
To:     chenhuang5@huawei.com, palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 30 May 2021 12:43:41 +0200
Message-ID: <1622371421178138@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From eac2f3059e02382d91f8c887462083841d6ea2a3 Mon Sep 17 00:00:00 2001
From: Chen Huang <chenhuang5@huawei.com>
Date: Thu, 29 Apr 2021 07:03:48 +0000
Subject: [PATCH] riscv: stacktrace: fix the riscv stacktrace when
 CONFIG_FRAME_POINTER enabled

As [1] and [2] said, the arch_stack_walk should not to trace itself, or it will
leave the trace unexpectedly when called. The example is when we do "cat
/sys/kernel/debug/page_owner", all pages' stack is the same.

arch_stack_walk+0x18/0x20
stack_trace_save+0x40/0x60
register_dummy_stack+0x24/0x5e
init_page_owner+0x2e

So we use __builtin_frame_address(1) as the first frame to be walked. And mark
the arch_stack_walk() noinline.

We found that pr_cont will affact pages' stack whose task state is RUNNING when
testing "echo t > /proc/sysrq-trigger". So move the place of pr_cont and mark
the function dump_backtrace() noinline.

Also we move the case when task == NULL into else branch, and test for it in
"echo c > /proc/sysrq-trigger".

[1] https://lore.kernel.org/lkml/20210319184106.5688-1-mark.rutland@arm.com/
[2] https://lore.kernel.org/lkml/20210317142050.57712-1-chenjun102@huawei.com/

Signed-off-by: Chen Huang <chenhuang5@huawei.com>
Fixes: 5d8544e2d007 ("RISC-V: Generic library routines and assembly")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 2b3e0cb90d78..bde85fc53357 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -27,10 +27,10 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		fp = frame_pointer(regs);
 		sp = user_stack_pointer(regs);
 		pc = instruction_pointer(regs);
-	} else if (task == NULL || task == current) {
-		fp = (unsigned long)__builtin_frame_address(0);
-		sp = sp_in_global;
-		pc = (unsigned long)walk_stackframe;
+	} else if (task == current) {
+		fp = (unsigned long)__builtin_frame_address(1);
+		sp = (unsigned long)__builtin_frame_address(0);
+		pc = (unsigned long)__builtin_return_address(0);
 	} else {
 		/* task blocked in __switch_to */
 		fp = task->thread.s[0];
@@ -106,15 +106,15 @@ static bool print_trace_address(void *arg, unsigned long pc)
 	return true;
 }
 
-void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
+noinline void dump_backtrace(struct pt_regs *regs, struct task_struct *task,
 		    const char *loglvl)
 {
-	pr_cont("%sCall Trace:\n", loglvl);
 	walk_stackframe(task, regs, print_trace_address, (void *)loglvl);
 }
 
 void show_stack(struct task_struct *task, unsigned long *sp, const char *loglvl)
 {
+	pr_cont("%sCall Trace:\n", loglvl);
 	dump_backtrace(NULL, task, loglvl);
 }
 
@@ -139,7 +139,7 @@ unsigned long get_wchan(struct task_struct *task)
 
 #ifdef CONFIG_STACKTRACE
 
-void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
+noinline void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 		     struct task_struct *task, struct pt_regs *regs)
 {
 	walk_stackframe(task, regs, consume_entry, cookie);

