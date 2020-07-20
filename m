Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC81E225E76
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 14:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgGTMXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 08:23:15 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:56107 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728791AbgGTMXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 08:23:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 03AC71940C70;
        Mon, 20 Jul 2020 08:23:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 20 Jul 2020 08:23:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=vogK9e
        4gUReigabeGWe5o58Xu4txblPTc0qv0xwo3/Q=; b=lfUWpyoBbpa+F0lhX3gmep
        +eOVU2vWMoxIa9hTgExjl5CHdPY2if+nv55mleccFMuhOgdUuQMQDBAfk+c/1RKT
        x0bq8ZNeF5cPsw3OeMdEtw44UbeMOhZ7aeP8UD0L4O5B7eAo9na9hh5gPfee4Idd
        Oy4s1UNWlnEWloLuBQLtyxZywV/v1SG05L4UBv6Ixx/TZ69OmO98oFbSSgeJPGAi
        v2rqbJlHArG2pZN0fhguQbNfR7B63NBIgeWBWzkFHPUjsaX+8k5kLeTpsXUZw+RL
        C+u6R1HkZMZgwPxCWVE57/LSYKJTDXfj2ON3LEBj8uaKOgummj3M9UZQ/aHyzsdQ
        ==
X-ME-Sender: <xms:sYwVX0eh2wXB6GchVBvZWP5IJS8ADzMkiPyrBGJtbJ5Im768vFl20A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrgeeggddviecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrkeelrddutdejnecuvehluhhsthgv
    rhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:sYwVX2OR01itvTJUxz8DrEWLV7yZRPDnt2zu4F87TztqmhnYVFqOPA>
    <xmx:sYwVX1gxWL-bagIt85u5lw_Sodkum80NkFbkV_TUQ4B_MZujglRAIA>
    <xmx:sYwVX59-5cb41ZFU9yeCOPsHjQlo3KKn1Yxwl45QZF6axvgjJj4_4g>
    <xmx:sowVX9UejFae9FKw8e2G9VCdK13cqxF8IgkFcw3ufnAxZ6LEtB9Kmw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4CFE03280060;
        Mon, 20 Jul 2020 08:23:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] arm64: compat: Ensure upper 32 bits of x0 are zero on syscall" failed to apply to 4.4-stable tree
To:     will@kernel.org, keno@juliacomputing.com, luis.machado@linaro.org,
        mark.rutland@arm.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 20 Jul 2020 14:23:24 +0200
Message-ID: <159524780445118@kroah.com>
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
 

