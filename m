Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5EB4279BD
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730272AbfEWJwE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:52:04 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:39189 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728277AbfEWJwE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:52:04 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id BCBED3489F;
        Thu, 23 May 2019 05:52:02 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 23 May 2019 05:52:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=iuGWWd
        txzYLyR42j3h191SP4rNqTlpMjuZC7Sjrrods=; b=rQSmMDy7umZX0wkqcWmqnu
        aKs7oVoTDMgl3amWFudICPrxV+Uimru3gIZRGxPeFEC+pLV9R1fVyr7AkDVOrZof
        iRdPIYt5lDbEpJYnwWp7PlsDIEge3oX+LmTA3y2x3FTpGn8iw9Fm4JwDDqoVwyhE
        bi6bt3K7COZVrwb3KiDwfElpUCzXGuX+lJ0fsoKoXj/HAiyWT3AMkRcoSBHXLgXu
        4WlkCSaFjgL9Sk1fuycZ0VZZIc4+mxzkIzjjKRnnkbRJaXVaKgj6chiJtqYjPT93
        i8o+XEdA7v4CXsvlpDxOdqDjs88g+KO/j0Va4OutNnVdOHoYVG0ZMBocsHWqYXkw
        ==
X-ME-Sender: <xms:PW3mXDFWiz6xqG7VmcviTBWpZjX5SjOBoSB3GvVpXAWPBRue_utlZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:PW3mXB3VtoWegW4erzsXlCHMTmtDUf8d4OuEZOMY6BZo_vi6_aRa3Q>
    <xmx:PW3mXNxZJYROTPpzlX5kQquZt5VjeZnCkJZ50tJBY3P_ntOx2xov3g>
    <xmx:PW3mXDH9y7Y53C96EqKWvmBPpOOPQxavPjPbTG7QFHT193RVNS4tUg>
    <xmx:Qm3mXB0vdPiNER97JRHIvH7v-QWe130AOudcNMWZVmLOPqnA42Gj6w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2226A380089;
        Thu, 23 May 2019 05:51:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace/x86_64: Emulate call function while updating in" failed to apply to 4.9-stable tree
To:     peterz@infradead.org, bigeasy@linutronix.de, bp@alien8.de,
        hpa@zytor.com, jgross@suse.com, jikos@kernel.org,
        joe.lawrence@redhat.com, jpoimboe@redhat.com, jroedel@suse.de,
        konrad.wilk@oracle.com, linux-kselftest@vger.kernel.org,
        luto@kernel.org, mbenes@suse.cz, mhiramat@kernel.org,
        mingo@redhat.com, nayna@linux.ibm.com, ndesaulniers@google.com,
        nstange@suse.de, pmladek@suse.com, rostedt@goodmis.org,
        shuah@kernel.org, tglx@linutronix.de, tim.c.chen@linux.intel.com,
        x86@kernel.org, yamada.masahiro@socionext.com, zohar@linux.ibm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 11:51:55 +0200
Message-ID: <1558605115220151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 9e298e8604088a600d8100a111a532a9d342af09 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 1 May 2019 15:11:17 +0200
Subject: [PATCH] ftrace/x86_64: Emulate call function while updating in
 breakpoint handler

Nicolai Stange discovered[1] that if live kernel patching is enabled, and the
function tracer started tracing the same function that was patched, the
conversion of the fentry call site during the translation of going from
calling the live kernel patch trampoline to the iterator trampoline, would
have as slight window where it didn't call anything.

As live kernel patching depends on ftrace to always call its code (to
prevent the function being traced from being called, as it will redirect
it). This small window would allow the old buggy function to be called, and
this can cause undesirable results.

Nicolai submitted new patches[2] but these were controversial. As this is
similar to the static call emulation issues that came up a while ago[3].
But after some debate[4][5] adding a gap in the stack when entering the
breakpoint handler allows for pushing the return address onto the stack to
easily emulate a call.

[1] http://lkml.kernel.org/r/20180726104029.7736-1-nstange@suse.de
[2] http://lkml.kernel.org/r/20190427100639.15074-1-nstange@suse.de
[3] http://lkml.kernel.org/r/3cf04e113d71c9f8e4be95fb84a510f085aa4afa.1541711457.git.jpoimboe@redhat.com
[4] http://lkml.kernel.org/r/CAHk-=wh5OpheSU8Em_Q3Hg8qw_JtoijxOdPtHru6d+5K8TWM=A@mail.gmail.com
[5] http://lkml.kernel.org/r/CAHk-=wjvQxY4DvPrJ6haPgAa6b906h=MwZXO6G8OtiTGe=N7_w@mail.gmail.com

[
  Live kernel patching is not implemented on x86_32, thus the emulate
  calls are only for x86_64.
]

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Nicolai Stange <nstange@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: the arch/x86 maintainers <x86@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Miroslav Benes <mbenes@suse.cz>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Mimi Zohar <zohar@linux.ibm.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Cc: stable@vger.kernel.org
Fixes: b700e7f03df5 ("livepatch: kernel: add support for live patching")
Tested-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
[ Changed to only implement emulated calls for x86_64 ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ef49517f6bb2..bd553b3af22e 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -29,6 +29,7 @@
 #include <asm/kprobes.h>
 #include <asm/ftrace.h>
 #include <asm/nops.h>
+#include <asm/text-patching.h>
 
 #ifdef CONFIG_DYNAMIC_FTRACE
 
@@ -231,6 +232,7 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 }
 
 static unsigned long ftrace_update_func;
+static unsigned long ftrace_update_func_call;
 
 static int update_ftrace_func(unsigned long ip, void *new)
 {
@@ -259,6 +261,8 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	unsigned char *new;
 	int ret;
 
+	ftrace_update_func_call = (unsigned long)func;
+
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = update_ftrace_func(ip, new);
 
@@ -294,13 +298,28 @@ int ftrace_int3_handler(struct pt_regs *regs)
 	if (WARN_ON_ONCE(!regs))
 		return 0;
 
-	ip = regs->ip - 1;
-	if (!ftrace_location(ip) && !is_ftrace_caller(ip))
-		return 0;
+	ip = regs->ip - INT3_INSN_SIZE;
 
-	regs->ip += MCOUNT_INSN_SIZE - 1;
+#ifdef CONFIG_X86_64
+	if (ftrace_location(ip)) {
+		int3_emulate_call(regs, (unsigned long)ftrace_regs_caller);
+		return 1;
+	} else if (is_ftrace_caller(ip)) {
+		if (!ftrace_update_func_call) {
+			int3_emulate_jmp(regs, ip + CALL_INSN_SIZE);
+			return 1;
+		}
+		int3_emulate_call(regs, ftrace_update_func_call);
+		return 1;
+	}
+#else
+	if (ftrace_location(ip) || is_ftrace_caller(ip)) {
+		int3_emulate_jmp(regs, ip + CALL_INSN_SIZE);
+		return 1;
+	}
+#endif
 
-	return 1;
+	return 0;
 }
 NOKPROBE_SYMBOL(ftrace_int3_handler);
 
@@ -859,6 +878,8 @@ void arch_ftrace_update_trampoline(struct ftrace_ops *ops)
 
 	func = ftrace_ops_get_func(ops);
 
+	ftrace_update_func_call = (unsigned long)func;
+
 	/* Do a safe modify in case the trampoline is executing */
 	new = ftrace_call_replace(ip, (unsigned long)func);
 	ret = update_ftrace_func(ip, new);
@@ -960,6 +981,7 @@ static int ftrace_mod_jmp(unsigned long ip, void *func)
 {
 	unsigned char *new;
 
+	ftrace_update_func_call = 0UL;
 	new = ftrace_jmp_replace(ip, (unsigned long)func);
 
 	return update_ftrace_func(ip, new);

