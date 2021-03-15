Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 593C433ADD8
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 09:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbhCOIqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 04:46:02 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:57111 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229687AbhCOIpp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Mar 2021 04:45:45 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id A9BD41941968;
        Mon, 15 Mar 2021 04:45:44 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 04:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IDwkKY
        mR42/5r6FodzPxh5Z4JKE0UGQCj2HUf16CY8U=; b=M0DI0WmIWY0Of64VnJLZzl
        RF12/HLEJxwk9dfpf+YSldU9OS5tgWQmoeghci9LNQCTWOAXEm6n/9D5RRoQ3fPx
        ZJbf7jBtjCGZXnygQZgdft/ecihNfuscPdhw5T5K/pYMOmVAOhFm9rzYcRXo3Mee
        c5LAJAF9wW/Iyhoqp6XV7fGpieHGhXJSDnw41Xosa/kfFICSqOtklLvIeQeEzjI6
        WD+wh0/FY5ug5xPZHR3nUbDAwleeqanIjV7yHu7gLbFxjMDDVHov7jJYkxdKHh+G
        NnX7xtyf/1K1yYuVBQRUINbPSX7E/6rBaCX96zq5kBtfhPb9sfhdwADcRZpd3C1A
        ==
X-ME-Sender: <xms:tx5PYDC0i6PsA6WpIMHa1VCMmffNsT37pz1j4I7Bjy0i7-HUOIWWqw>
    <xme:tx5PYJj0lCq9ggWzt1LadHf62r16wypzpeg-_YM0DF3KMM8o0kaB2CPH7tXeywzWh
    bX8vcWA49Xqjw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvkedguddvgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:tx5PYOkMrThUVG8LmrWD50q9Hw5Up02bhP8VIfADn88flQoUKtnXIw>
    <xmx:tx5PYFxB99Rh0VriMdR6Hul3OZWd6dVZo7jsopMcQA3NczXxCtYHmQ>
    <xmx:tx5PYIRAExc3uk_dRo_yprU5uwe-o_Mhbi6Pzl7YN0K23PNGLUWIwg>
    <xmx:uB5PYOfc4uQP01QP04_hezqJR-elcu_92-JkE0NaH27UNOlDfaf0OQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id A2A0A24005D;
        Mon, 15 Mar 2021 04:45:43 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/unwind/orc: Disable KASAN checking in the ORC unwinder," failed to apply to 4.14-stable tree
To:     jpoimboe@redhat.com, bp@suse.de, ivan@cloudflare.com,
        peterz@infradead.org, rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Mar 2021 09:45:42 +0100
Message-ID: <1615797942147223@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From e504e74cc3a2c092b05577ce3e8e013fae7d94e6 Mon Sep 17 00:00:00 2001
From: Josh Poimboeuf <jpoimboe@redhat.com>
Date: Fri, 5 Feb 2021 08:24:02 -0600
Subject: [PATCH] x86/unwind/orc: Disable KASAN checking in the ORC unwinder,
 part 2

KASAN reserves "redzone" areas between stack frames in order to detect
stack overruns.  A read or write to such an area triggers a KASAN
"stack-out-of-bounds" BUG.

Normally, the ORC unwinder stays in-bounds and doesn't access the
redzone.  But sometimes it can't find ORC metadata for a given
instruction.  This can happen for code which is missing ORC metadata, or
for generated code.  In such cases, the unwinder attempts to fall back
to frame pointers, as a best-effort type thing.

This fallback often works, but when it doesn't, the unwinder can get
confused and go off into the weeds into the KASAN redzone, triggering
the aforementioned KASAN BUG.

But in this case, the unwinder's confusion is actually harmless and
working as designed.  It already has checks in place to prevent
off-stack accesses, but those checks get short-circuited by the KASAN
BUG.  And a BUG is a lot more disruptive than a harmless unwinder
warning.

Disable the KASAN checks by using READ_ONCE_NOCHECK() for all stack
accesses.  This finishes the job started by commit 881125bfe65b
("x86/unwind: Disable KASAN checking in the ORC unwinder"), which only
partially fixed the issue.

Fixes: ee9f8fce9964 ("x86/unwind: Add the ORC unwinder")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/9583327904ebbbeda399eca9c56d6c7085ac20fe.1612534649.git.jpoimboe@redhat.com

diff --git a/arch/x86/kernel/unwind_orc.c b/arch/x86/kernel/unwind_orc.c
index 2a1d47f47eee..1bcc14c870ab 100644
--- a/arch/x86/kernel/unwind_orc.c
+++ b/arch/x86/kernel/unwind_orc.c
@@ -367,8 +367,8 @@ static bool deref_stack_regs(struct unwind_state *state, unsigned long addr,
 	if (!stack_access_ok(state, addr, sizeof(struct pt_regs)))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -380,8 +380,8 @@ static bool deref_stack_iret_regs(struct unwind_state *state, unsigned long addr
 	if (!stack_access_ok(state, addr, IRET_FRAME_SIZE))
 		return false;
 
-	*ip = regs->ip;
-	*sp = regs->sp;
+	*ip = READ_ONCE_NOCHECK(regs->ip);
+	*sp = READ_ONCE_NOCHECK(regs->sp);
 	return true;
 }
 
@@ -402,12 +402,12 @@ static bool get_reg(struct unwind_state *state, unsigned int reg_off,
 		return false;
 
 	if (state->full_regs) {
-		*val = ((unsigned long *)state->regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->regs)[reg]);
 		return true;
 	}
 
 	if (state->prev_regs) {
-		*val = ((unsigned long *)state->prev_regs)[reg];
+		*val = READ_ONCE_NOCHECK(((unsigned long *)state->prev_regs)[reg]);
 		return true;
 	}
 

