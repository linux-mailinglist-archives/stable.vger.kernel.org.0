Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F13279AE
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 11:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729797AbfEWJuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 05:50:07 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53613 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728109AbfEWJuG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 05:50:06 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 305F33551F;
        Thu, 23 May 2019 05:50:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 23 May 2019 05:50:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mL1GU5
        rTq/7RYs6Kp+TmJT6j1LYqwmpRPl/cPZdXPQ0=; b=rEr6KzHWZrnj8AiALMNTfw
        NP4LoyJDkOCH8Cq6nLoz6uapdzwdmucFiPACcirY4FsIiWy7sUM9BZHl6/BlSVu8
        WqDm4T4FFMEMcQvlOkkBqiR9KaM+Y6ghqBdsURUZR7sPVsl5sv/faMjKpfvw90ca
        gWUtSo1NLOF30SvZowSHv7QBw3h55FxH6miKoX9C+ZOCs2FvH+bRnAX2kEjaHESi
        DR8CFEuq3hXX8470hgAt7oXl4bOl+rGgRiG73ZipdgD1CWgJxHZxwKaA/tNMLeRY
        lrTvU2bFueHcc+8UJwmVANrO2sl0JW8xUMVewaFzJOUf6i4m9XqnveAKv3Qnm9EQ
        ==
X-ME-Sender: <xms:zWzmXAfdJMJDww_R5CYlpSu0A961bIG2-tt21Uz_ZNGDSXzHFx3EXA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddugedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdpieegrdhssgenucfkphepkeefrd
    ekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgr
    hhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:zWzmXMc4i0Y0WrXlzvWHtSv0oQi8wD3jF05fVZeNdXz96at3kSQOkg>
    <xmx:zWzmXOWv1UeN4Vog9uyKnNcyPYv8Uz87AaG0z-0J7BC8eHcTUKTLIw>
    <xmx:zWzmXNyvwpseHwh8lY7Y6hK08e9JmmGlZhDoa8injpqOF0dm_BcKPA>
    <xmx:zmzmXGbKvW5wJTBzu0vanbftPC2Z4cDQziuPYTO80IqxrvfJYpVtLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19F458005C;
        Thu, 23 May 2019 05:50:04 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86_64: Add gap to int3 to allow for call emulation" failed to apply to 4.9-stable tree
To:     jpoimboe@redhat.com, mhiramat@kernel.org, nstange@suse.de,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 23 May 2019 11:50:02 +0200
Message-ID: <1558605002251172@kroah.com>
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

From 2700fefdb2d9751c416ad56897e27d41e409324a Mon Sep 17 00:00:00 2001
From: Josh Poimboeuf <jpoimboe@redhat.com>
Date: Fri, 30 Nov 2018 12:39:17 -0600
Subject: [PATCH] x86_64: Add gap to int3 to allow for call emulation

To allow an int3 handler to emulate a call instruction, it must be able to
push a return address onto the stack. Add a gap to the stack to allow the
int3 handler to push the return address and change the return from int3 to
jump straight to the emulated called function target.

Link: http://lkml.kernel.org/r/20181130183917.hxmti5josgq4clti@treble
Link: http://lkml.kernel.org/r/20190502162133.GX2623@hirez.programming.kicks-ass.net

[
  Note, this is needed to allow Live Kernel Patching to not miss calling a
  patched function when tracing is enabled. -- Steven Rostedt
]

Cc: stable@vger.kernel.org
Fixes: b700e7f03df5 ("livepatch: kernel: add support for live patching")
Tested-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Nicolai Stange <nstange@suse.de>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 1f0efdb7b629..27fcc6fbdd52 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -879,7 +879,7 @@ apicinterrupt IRQ_WORK_VECTOR			irq_work_interrupt		smp_irq_work_interrupt
  * @paranoid == 2 is special: the stub will never switch stacks.  This is for
  * #DF: if the thread stack is somehow unusable, we'll still get a useful OOPS.
  */
-.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1
+.macro idtentry sym do_sym has_error_code:req paranoid=0 shift_ist=-1 create_gap=0
 ENTRY(\sym)
 	UNWIND_HINT_IRET_REGS offset=\has_error_code*8
 
@@ -899,6 +899,20 @@ ENTRY(\sym)
 	jnz	.Lfrom_usermode_switch_stack_\@
 	.endif
 
+	.if \create_gap == 1
+	/*
+	 * If coming from kernel space, create a 6-word gap to allow the
+	 * int3 handler to emulate a call instruction.
+	 */
+	testb	$3, CS-ORIG_RAX(%rsp)
+	jnz	.Lfrom_usermode_no_gap_\@
+	.rept	6
+	pushq	5*8(%rsp)
+	.endr
+	UNWIND_HINT_IRET_REGS offset=8
+.Lfrom_usermode_no_gap_\@:
+	.endif
+
 	.if \paranoid
 	call	paranoid_entry
 	.else
@@ -1130,7 +1144,7 @@ apicinterrupt3 HYPERV_STIMER0_VECTOR \
 #endif /* CONFIG_HYPERV */
 
 idtentry debug			do_debug		has_error_code=0	paranoid=1 shift_ist=DEBUG_STACK
-idtentry int3			do_int3			has_error_code=0
+idtentry int3			do_int3			has_error_code=0	create_gap=1
 idtentry stack_segment		do_stack_segment	has_error_code=1
 
 #ifdef CONFIG_XEN_PV

