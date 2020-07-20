Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42273225E79
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728697AbgGTMXZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:23:25 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:59577 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728720AbgGTMXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:23:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 8461C1940E46;
        Mon, 20 Jul 2020 08:23:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:23:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=CkujCQ
        NPsZQt557lWzE0z97ebjUvVkPyh0PIUSjdK4E=; b=oRSU/mAS3y/W7Er5nefh4/
        nC9lxF5rdj1Nu0GUxFDMK5CyPZ74emy331JelpLuh9i1VsK3s6Zaqg2G+lnXP71J
        hY8gHX/tSbKMAluc0zGlYxmO6tR+wrkk8PMjF3ZfZUfW9q5mf0uID11ZthbI4lND
        9+M4Y9kPbk6XJ/5c3xymkJjrTyd0m2Oq6QC1d5HBkRQXVE6dMsmr0Cd0pK/NQXeA
        tg8FFUMlizGqhk7hhwJAz1BNvG1bGnakKQyXrzrLgrLQqhDz/uRwC+Agwwe6rRrX
        J4bCEG4v8YCrJ6lWHKpDwKiA7G0V/7tPAzSVuZCOzQofYHKbC2ggqMLHsbJ7ksBg
        ==
X-ME-Sender: <xms:vIwVX6D3vyuSWkr8Ys70bIhOP5vc_be6f7rdC9IXfsNhvM9lcF-7pg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:vIwVX0hLrGjS_edrHtdPbJ5SKYdPcM5HvVh_-XWQBx4sM1gB3shfWw>
    <xmx:vIwVX9kVvyq5jMjBXM6ULuKeFv_NunU9FSoi-D34prmxQ8rk2ybSGw>
    <xmx:vIwVX4yv7HcmIWH5eRK9Ifx3CrbZ4NvrDxpUoBtpWjAYmUJo056RxQ>
    <xmx:vIwVX2KgHeUGuC46VXPYgdZxC_mj4-VDzRXP2q9_ZLAV5WX0ywENOA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 246C530600B2;
        Mon, 20 Jul 2020 08:23:24 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall" failed to apply to 4.14-stable tree
To:     will@kernel.org, keno@juliacomputing.com, luis.machado@linaro.org,
        mark.rutland@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:23:26 +0200
Message-ID: <1595247806108220@kroah.com>
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

From 15956689a0e60aa0c795174f3c310b60d8794235 Mon Sep 17 00:00:00 2001
From: Will Deacon <will@kernel.org>
Date: Fri, 3 Jul 2020 12:08:42 +0100
Subject: [PATCH] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall
 return

Although we zero the upper bits of x0 on entry to the kernel from an
AArch32 task, we do not clear them on the exception return path and can
therefore expose 64-bit sign extended syscall return values to userspace
via interfaces such as the 'perf_regs' ABI, which deal exclusively with
64-bit registers.

Explicitly clear the upper 32 bits of x0 on return from a compat system
call.

Cc: <stable@vger.kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Keno Fischer <keno@juliacomputing.com>
Cc: Luis Machado <luis.machado@linaro.org>
Signed-off-by: Will Deacon <will@kernel.org>

diff --git a/arch/arm64/include/asm/syscall.h b/arch/arm64/include/asm/syscall.h
index 65299a2dcf9c..cfc0672013f6 100644
--- a/arch/arm64/include/asm/syscall.h
+++ b/arch/arm64/include/asm/syscall.h
@@ -34,6 +34,10 @@ static inline long syscall_get_error(struct task_struct *task,
 				     struct pt_regs *regs)
 {
 	unsigned long error = regs->regs[0];
+
+	if (is_compat_thread(task_thread_info(task)))
+		error = sign_extend64(error, 31);
+
 	return IS_ERR_VALUE(error) ? error : 0;
 }
 
@@ -47,7 +51,13 @@ static inline void syscall_set_return_value(struct task_struct *task,
 					    struct pt_regs *regs,
 					    int error, long val)
 {
-	regs->regs[0] = (long) error ? error : val;
+	if (error)
+		val = error;
+
+	if (is_compat_thread(task_thread_info(task)))
+		val = lower_32_bits(val);
+
+	regs->regs[0] = val;
 }
 
 #define SYSCALL_MAX_ARGS 6
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index 7c14466a12af..98a26d4e7b0c 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -50,6 +50,9 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 		ret = do_ni_syscall(regs, scno);
 	}
 
+	if (is_compat_task())
+		ret = lower_32_bits(ret);
+
 	regs->regs[0] = ret;
 }
 

