Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07A2D225E78
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgGTMXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:23:24 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:51733 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728775AbgGTMXX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:23:23 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id CAB621940E21;
        Mon, 20 Jul 2020 08:23:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:23:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=2e3XRm
        q66r+cCuvfSajDNeJfV+8QHNGf0MqYKKSE+Xo=; b=joogaolPe186ONhiEzXKQw
        xho7mITEWq0gqaPIJKcHKjBCLkHSHujU7bmiM4hmxyfB3SdzHQ7Ib/1z+DMThLw0
        PJbcc42VJn3ENU/ccWBoNCFjuMGhrP5s6YiPcbTgbXB+6ywb0yhufbol8arHQTwB
        QJDjJFDll3bDPz8dxXtbwvD6/270EVvH0PgT/sdik+nW2f5921jsFRcc0yHDefdM
        cjRiMFv5ps99NN+mi2Q7BFGLQpvJ4h4yH7/lBAo11MhX98iiURSo1RNPSPyC2E6P
        P3i67FhzvyptdMImszdvsSzLTJ6i2F9iPq7vasuIUrD1KNDlytQFIQpQ8YXKg3Xg
        ==
X-ME-Sender: <xms:uowVX1B-2xsZWizGFxt71tcI-S0ikg1-Pz7IKP7J1f2YwtjlkEDzvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:uowVXzjEpimhgFAk0yVz0hsGFMkbNUEb7yKj7UIxFeJwDGvkaRrIzw>
    <xmx:uowVXwk0TPs-R4WhqEo83seFhvbsjYsE6xG6rtFf1H28yLKlEoTTHw>
    <xmx:uowVX_ypYYF6R10UC3IXccWmuzUaI5ew5GYIsqNldMilLF1NUOBgPw>
    <xmx:uowVX9J47YYRTPkxGxq3IQvSuNfGdWvS7qxLM-2qf2GwtUFGGyNJXA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C9743280059;
        Mon, 20 Jul 2020 08:23:22 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall" failed to apply to 4.9-stable tree
To:     will@kernel.org, keno@juliacomputing.com, luis.machado@linaro.org,
        mark.rutland@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:23:25 +0200
Message-ID: <159524780560165@kroah.com>
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
 

