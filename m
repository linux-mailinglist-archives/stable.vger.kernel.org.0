Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED882225E6E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbgGTMXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:23:08 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:40357 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728651AbgGTMXI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:23:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id D57651940AEB;
        Mon, 20 Jul 2020 08:23:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:23:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PzhQ41
        N4I9uNXVB6VGcEYlNim6mGRhu3fWqKfu/CfGE=; b=pAOturNr2SxfKHM4ANcKiI
        g9TJYBvAWPuDy+hmVW7n1xIkmFBTK7GWRD6KQ9ZHAD6IaXeX9omxrE4Wsh4Czzzr
        dYO/WbclE5MS62Yu890mp1mdnZ3fHpgHo4iV+fTrACJrdqqNhHZKE0S4CX5QkJgd
        vreg3c7HmTvutNSUi/4ZbBTOiUmc29QE3AYu6LycpaXNZdjClyKDdKPEByK5VG9j
        QpHQt0lNMP8Exz/K4IJ9pdLLSEkrx5xscnO50l25kITHU8UJqQpk4ek/hMcBVfou
        Nj9AGiTIvHoYUaXhAjPUoPqzP+H03J1OY1wzeRudOpeqRXRx9vTPgCbTg8aSDTYg
        ==
X-ME-Sender: <xms:qowVXwnhKnwbNI0MlVoLb99Z56tIaKw4JoBAX0UavTG0NxG8zrskOw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:qowVX_0Csu4n67mi5czNUUEoO5Eq0lSYeCZ7t1cG0e4W_UyiHoLx1A>
    <xmx:qowVX-rrFq8MWtA_XC1Ts0PVtBK7d4Sp9nSpRUoOj0KYcX0kim-7LA>
    <xmx:qowVX8kaUtGGf5IShka_g2hMyU2sJn5OFbuIVIaQkPUJrv_bXFShIw>
    <xmx:qowVXz9WnMuM2FZ5jac7VUe7ZfAUTSnA5LNvzlbRwRHkKfbtzhP1qg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22738328005E;
        Mon, 20 Jul 2020 08:23:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: ptrace: Consistently use pseudo-singlestep exceptions" failed to apply to 4.9-stable tree
To:     will@kernel.org, keno@juliacomputing.com, luis.machado@linaro.org,
        mark.rutland@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:23:17 +0200
Message-ID: <15952477979991@kroah.com>
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

From ac2081cdc4d99c57f219c1a6171526e0fa0a6fff Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Thu, 2 Jul 2020 21:16:20 +0100
Subject: [PATCH] arm64: ptrace: Consistently use pseudo-singlestep exceptions

Although the arm64 single-step state machine can be fast-forwarded in
cases where we wish to generate a SIGTRAP without actually executing an
instruction, this has two major limitations outside of simply skipping
an instruction due to emulation.

1. Stepping out of a ptrace signal stop into a signal handler where
   SIGTRAP is blocked. Fast-forwarding the stepping state machine in
   this case will result in a forced SIGTRAP, with the handler reset to
   SIG_DFL.

2. The hardware implicitly fast-forwards the state machine when executing
   an SVC instruction for issuing a system call. This can interact badly
   with subsequent ptrace stops signalled during the execution of the
   system call (e.g. SYSCALL_EXIT or seccomp traps), as they may corrupt
   the stepping state by updating the PSTATE for the tracee.

Resolve both of these issues by injecting a pseudo-singlestep exception
on entry to a signal handler and also on return to userspace following a
system call.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Tested-by: Luis Machado <luis.machado@linaro.org>
Reported-by: Keno Fischer <keno@juliacomputing.com>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 6ea8b6a26ae9..5e784e16ee89 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -93,6 +93,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define _TIF_SYSCALL_EMU	(1 << TIF_SYSCALL_EMU)
 #define _TIF_UPROBE		(1 << TIF_UPROBE)
 #define _TIF_FSCHECK		(1 << TIF_FSCHECK)
+#define _TIF_SINGLESTEP		(1 << TIF_SINGLESTEP)
 #define _TIF_32BIT		(1 << TIF_32BIT)
 #define _TIF_SVE		(1 << TIF_SVE)
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 68b7f34a08f5..057d4aa1af4d 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -1818,12 +1818,23 @@ static void tracehook_report_syscall(struct pt_regs *regs,
 	saved_reg = regs->regs[regno];
 	regs->regs[regno] = dir;
 
-	if (dir == PTRACE_SYSCALL_EXIT)
+	if (dir == PTRACE_SYSCALL_ENTER) {
+		if (tracehook_report_syscall_entry(regs))
+			forget_syscall(regs);
+		regs->regs[regno] = saved_reg;
+	} else if (!test_thread_flag(TIF_SINGLESTEP)) {
 		tracehook_report_syscall_exit(regs, 0);
-	else if (tracehook_report_syscall_entry(regs))
-		forget_syscall(regs);
+		regs->regs[regno] = saved_reg;
+	} else {
+		regs->regs[regno] = saved_reg;
 
-	regs->regs[regno] = saved_reg;
+		/*
+		 * Signal a pseudo-step exception since we are stepping but
+		 * tracer modifications to the registers may have rewound the
+		 * state machine.
+		 */
+		tracehook_report_syscall_exit(regs, 1);
+	}
 }
 
 int syscall_trace_enter(struct pt_regs *regs)
@@ -1851,12 +1862,14 @@ int syscall_trace_enter(struct pt_regs *regs)
 
 void syscall_trace_exit(struct pt_regs *regs)
 {
+	unsigned long flags = READ_ONCE(current_thread_info()->flags);
+
 	audit_syscall_exit(regs);
 
-	if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
+	if (flags & _TIF_SYSCALL_TRACEPOINT)
 		trace_sys_exit(regs, regs_return_value(regs));
 
-	if (test_thread_flag(TIF_SYSCALL_TRACE))
+	if (flags & (_TIF_SYSCALL_TRACE | _TIF_SINGLESTEP))
 		tracehook_report_syscall(regs, PTRACE_SYSCALL_EXIT);
 
 	rseq_syscall(regs);
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 801d56cdf701..3b4f31f35e45 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -800,7 +800,6 @@ static void setup_restart_syscall(struct pt_regs *regs)
  */
 static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 {
-	struct task_struct *tsk = current;
 	sigset_t *oldset = sigmask_to_save();
 	int usig = ksig->sig;
 	int ret;
@@ -824,14 +823,8 @@ static void handle_signal(struct ksignal *ksig, struct pt_regs *regs)
 	 */
 	ret |= !valid_user_regs(&regs->user_regs, current);
 
-	/*
-	 * Fast forward the stepping logic so we step into the signal
-	 * handler.
-	 */
-	if (!ret)
-		user_fastforward_single_step(tsk);
-
-	signal_setup_done(ret, ksig, 0);
+	/* Step into the signal handler if we are stepping */
+	signal_setup_done(ret, ksig, test_thread_flag(TIF_SINGLESTEP));
 }
 
 /*
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 5f5b868292f5..7c14466a12af 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -139,7 +139,7 @@ static void el0_svc_common(struct pt_regs *regs, int scno, int sc_nr,
 	if (!has_syscall_work(flags) && !IS_ENABLED(CONFIG_DEBUG_RSEQ)) {
 		local_daif_mask();
 		flags = current_thread_info()->flags;
-		if (!has_syscall_work(flags)) {
+		if (!has_syscall_work(flags) && !(flags & _TIF_SINGLESTEP)) {
 			/*
 			 * We're off to userspace, where interrupts are
 			 * always enabled after we restore the flags from

