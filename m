Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DE0279B3
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbfEWJu3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:50:29 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47325 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729972AbfEWJu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:50:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 8A7FA350B8;
        Thu, 23 May 2019 05:50:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 05:50:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vPXYb+
        dQPu1PmLAsppSBBCsxX99YN2sLe8ibkLaPLj4=; b=WmhWP7S8StsnpVd7A31Sp4
        aZOvHNr0ephz4kN8DlHv66HX4Mz2dRSJ/WEt4ncDqYKLLtibH6pNcrbXWFIXXb9+
        phWa5qd39aDDuyYizw0XUBBbcu2QVbakK6p73FO6B0Vjqfi9FEIFlx7N44/kOIyP
        Bp4k0o1Xp9fZBzf3lzPkAowGNnOtAAlectWM2ofw6guJxy6YBTx01Cui+9/9ayMq
        strX8+Da3XSzIY6JSk4/2p/uEYP/WT4Rtw4f+TJSK6AwrdPrWMfRLgOWo5Hz+J/r
        WITwkWjd0NhcPNfeGhjDe7slVAIdGsw6sKLEQfq/jvMAQUta7FWbMzKb29hoxuVQ
        ==
X-ME-Sender: <xms:4WzmXKwvf4TcCW94yH3y4tqZNf7h5fuw98T51F56xfoiwHXQlXMcOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomh
    epghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:4WzmXNVq54lXViQ-fkYoMeLkzE8ET00QDUXR8n1EuLEeAMEIlaWGQQ>
    <xmx:4WzmXED8qd3eYqwjFzIpjgxrV69ETcyWviFGD9ArYUuxqfz_W2PFvg>
    <xmx:4WzmXG6bEO9pt6_-HXdMD337I4K3qGXVmcJuvJ-sWLtPerj22AYaew>
    <xmx:4WzmXO5OX6IChRnVWXvaDs1WzsXksBfPQGIKoYfUOG6JBoZH0zmuHw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 51BB480061;
        Thu, 23 May 2019 05:50:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86_64: Allow breakpoints to emulate call instructions" failed to apply to 4.4-stable tree
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
Date:   Thu, 23 May 2019 11:50:22 +0200
Message-ID: <1558605022149172@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4b33dadf37666c0860b88f9e52a16d07bf6d0b03 Mon Sep 17 00:00:00 2001
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed, 1 May 2019 15:11:17 +0200
Subject: [PATCH] x86_64: Allow breakpoints to emulate call instructions

In order to allow breakpoints to emulate call instructions, they need to push
the return address onto the stack. The x86_64 int3 handler adds a small gap
to allow the stack to grow some. Use this gap to add the return address to
be able to emulate a call instruction at the breakpoint location.

These helper functions are added:

  int3_emulate_jmp(): changes the location of the regs->ip to return there.

 (The next two are only for x86_64)
  int3_emulate_push(): to push the address onto the gap in the stack
  int3_emulate_call(): push the return address and change regs->ip

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
[ Modified to only work for x86_64 and added comment to int3_emulate_push() ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index e85ff65c43c3..05861cc08787 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -39,4 +39,32 @@ extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 
+static inline void int3_emulate_jmp(struct pt_regs *regs, unsigned long ip)
+{
+	regs->ip = ip;
+}
+
+#define INT3_INSN_SIZE 1
+#define CALL_INSN_SIZE 5
+
+#ifdef CONFIG_X86_64
+static inline void int3_emulate_push(struct pt_regs *regs, unsigned long val)
+{
+	/*
+	 * The int3 handler in entry_64.S adds a gap between the
+	 * stack where the break point happened, and the saving of
+	 * pt_regs. We can extend the original stack because of
+	 * this gap. See the idtentry macro's create_gap option.
+	 */
+	regs->sp -= sizeof(unsigned long);
+	*(unsigned long *)regs->sp = val;
+}
+
+static inline void int3_emulate_call(struct pt_regs *regs, unsigned long func)
+{
+	int3_emulate_push(regs, regs->ip - INT3_INSN_SIZE + CALL_INSN_SIZE);
+	int3_emulate_jmp(regs, func);
+}
+#endif
+
 #endif /* _ASM_X86_TEXT_PATCHING_H */

