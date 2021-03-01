Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE8E327C4F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 11:37:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234206AbhCAKgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 05:36:33 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:39489 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234517AbhCAKeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 05:34:36 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id E3ED01940956;
        Mon,  1 Mar 2021 05:33:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 01 Mar 2021 05:33:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=A3qrdw
        4n+mB/AD9tXIT0B3I+u7rOBfCs90JH3lkaCIc=; b=iULxywFLHeSNLyJ0KcPSuf
        IjOVgU+OlXyqKmP1Ej2N2PqVQaZvjDdJR0pRuhoUPHO/FR5aWP/X2p+1pZGYF8X8
        a567FqAwkz+eFuyoqDxF88gZs2xOhUzicktAKC0m43foIhW5dCpE3rMJuqjXcvJT
        dDCxsu6yVaIJO+q49+0rxvQhTkj+Nj7BIdq4pVzBsNVAxnbzksy3xYBKjRUhkYct
        ezQniAh+EvHrNTEJezOiiiv0sD9bC1KpL968l3PXkG9zxFVCWJFAFw/Vnlttgkgn
        hENpDVDQLkGsdPhHrFPxVOF8K4SxYbhiH4YURs6L1F2dJwTzQiEz5V20HPolNABw
        ==
X-ME-Sender: <xms:A8M8YJCchfrbd72QKv3SxB8kGTvZLOp6u3GpHPjDOg6EMSxsljCWpg>
    <xme:A8M8YJh0b2akqRc9w1jgc75UmWCbX4BML7NdzOJrwxIU2SYBQFcosm8J3C_baOj3b
    q4Dcxu0tweLYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdduhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:A8M8YN-1ynTnI5d1yeo0O9XMP75ACdaVGOCAZGkhiW92JKMtUcLYdQ>
    <xmx:A8M8YF-_boZDuXpGLYuE4yDkOpm1UxinKRlwo_bJgB0_HM6-wa7TTA>
    <xmx:A8M8YGDCVUzKq54hgQdWGJUqoCWdoICpaJR8HFUesbEu3uYMsyG4wA>
    <xmx:BMM8YOOzairvPlVmCPgL1tPcAhwIxAHkzZOcJmw-BaoC7DZnm8VkTA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C395240064;
        Mon,  1 Mar 2021 05:33:39 -0500 (EST)
Subject: FAILED: patch "[PATCH] arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)" failed to apply to 5.4-stable tree
To:     T.E.Baldwin99@members.leeds.ac.uk, catalin.marinas@arm.com,
        keescook@chromium.org, oleg@redhat.com, stable@vger.kernel.org,
        sudeep.holla@arm.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 11:33:37 +0100
Message-ID: <1614594817254209@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From df84fe94708985cdfb78a83148322bcd0a699472 Mon Sep 17 00:00:00 2001
From: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
Date: Sat, 16 Jan 2021 15:18:54 +0000
Subject: [PATCH] arm64: ptrace: Fix seccomp of traced syscall -1 (NO_SYSCALL)

Since commit f086f67485c5 ("arm64: ptrace: add support for syscall
emulation"), if system call number -1 is called and the process is being
traced with PTRACE_SYSCALL, for example by strace, the seccomp check is
skipped and -ENOSYS is returned unconditionally (unless altered by the
tracer) rather than carrying out action specified in the seccomp filter.

The consequence of this is that it is not possible to reliably strace
a seccomp based implementation of a foreign system call interface in
which r7/x8 is permitted to be -1 on entry to a system call.

Also trace_sys_enter and audit_syscall_entry are skipped if a system
call is skipped.

Fix by removing the in_syscall(regs) check restoring the previous
behaviour which is like AArch32, x86 (which uses generic code) and
everything else.

Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Catalin Marinas<catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Fixes: f086f67485c5 ("arm64: ptrace: add support for syscall emulation")
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Tested-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Timothy E Baldwin <T.E.Baldwin99@members.leeds.ac.uk>
Link: https://lore.kernel.org/r/90edd33b-6353-1228-791f-0336d94d5f8c@majoroak.me.uk
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 3d5c8afca75b..170f42fd6101 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1797,7 +1797,7 @@ int syscall_trace_enter(struct pt_regs *regs)
 
 	if (flags & (_TIF_SYSCALL_EMU | _TIF_SYSCALL_TRACE)) {
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_ENTER);
-		if (!in_syscall(regs) || (flags & _TIF_SYSCALL_EMU))
+		if (flags & _TIF_SYSCALL_EMU)
 			return NO_SYSCALL;
 	}
 

