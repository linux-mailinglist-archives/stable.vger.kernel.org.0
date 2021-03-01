Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56406327FB3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235871AbhCANi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:38:56 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:47949 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235814AbhCANiy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:38:54 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id EC59D1941F3F;
        Mon,  1 Mar 2021 08:37:47 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:37:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mTjqmc
        WZ5LEx5MgBng7Vq2cKzqnpA/2WCk0+6WvNfr4=; b=LCn5Y7FCR2vcvoAk9t+kDU
        upINi8rJ2S4tTD/fXLgjzKphF7s4HomaXoUxRH+Lj5xZxmtfDFcWYYWZ38qgV3x1
        Cz3+w+Ld6fwYxvs0FjUQfd+Ol4Iql3FLOGxqnyf3gz5ajGMoYnamnMrstRdOsJZz
        9oW1F7Mr3z4AmBeHzmctEq2zDkJRyXD1WLE22Z9n9XaSdKMhPiZM+Kzbff2+pcAQ
        zTkCHrr5mkZzbVmsnAVjGqLF15lL35lgDjRCpP7D1euJ4h5q1miNtSzspGekPw4c
        dsaaZB+tpJj+aP2ChmmtCJNXIuMTsI8i0/xPbRofm4XVwWF0eWPWTnmNbLS0jVRA
        ==
X-ME-Sender: <xms:K-48YBhYk4rYs5txFo3vxfPdobXLaGWE6E0TCRM3oINXHp2PBZkvCA>
    <xme:K-48YGAu-K8uj4X8m7SyUAxNsxp1ddxewU0-DCcE8VrcuVbc4iXiy9Q-ASWthYiOV
    -ACnQB4KL_V6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:K-48YBFXNt6uFchAqpwZebjC9fVcabgbRiyyUxy3IyflEwtv8FONdg>
    <xmx:K-48YGTE67WPHFIP8DkirEdSj1zJtqv45KiDOLj-DoF2_exHgSjfOg>
    <xmx:K-48YOw6SEjKcCrONj64bffifduLy99EEzFsiyKQapua89tVAPf-JQ>
    <xmx:K-48YEbl1rFF3hSaPSykCHCTcH6DFYyo6ZW-OYW48OXjSrTVkBA6Sw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9046B1080059;
        Mon,  1 Mar 2021 08:37:47 -0500 (EST)
Subject: FAILED: patch "[PATCH] um: defer killing userspace on page table update failures" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:37:44 +0100
Message-ID: <161460586440155@kroah.com>
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

From a7d48886cacf8b426e0079bca9639d2657cf2d38 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Wed, 13 Jan 2021 22:08:03 +0100
Subject: [PATCH] um: defer killing userspace on page table update failures

In some cases we can get to fix_range_common() with mmap_sem held,
and in others we get there without it being held. For example, we
get there with it held from sys_mprotect(), and without it held
from fork_handler().

Avoid any issues in this and simply defer killing the task until
it runs the next time. Do it on the mm so that another task that
shares the same mm can't continue running afterwards.

Cc: stable@vger.kernel.org
Fixes: 468f65976a8d ("um: Fix hung task in fix_range_common()")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/arch/um/include/shared/skas/mm_id.h b/arch/um/include/shared/skas/mm_id.h
index 4337b4ced095..e82e203f5f41 100644
--- a/arch/um/include/shared/skas/mm_id.h
+++ b/arch/um/include/shared/skas/mm_id.h
@@ -12,6 +12,7 @@ struct mm_id {
 		int pid;
 	} u;
 	unsigned long stack;
+	int kill;
 };
 
 #endif
diff --git a/arch/um/kernel/tlb.c b/arch/um/kernel/tlb.c
index 89468da6bf88..5be1b0da9f3b 100644
--- a/arch/um/kernel/tlb.c
+++ b/arch/um/kernel/tlb.c
@@ -352,12 +352,11 @@ void fix_range_common(struct mm_struct *mm, unsigned long start_addr,
 
 	/* This is not an else because ret is modified above */
 	if (ret) {
+		struct mm_id *mm_idp = &current->mm->context.id;
+
 		printk(KERN_ERR "fix_range_common: failed, killing current "
 		       "process: %d\n", task_tgid_vnr(current));
-		/* We are under mmap_lock, release it such that current can terminate */
-		mmap_write_unlock(current->mm);
-		force_sig(SIGKILL);
-		do_signal(&current->thread.regs);
+		mm_idp->kill = 1;
 	}
 }
 
diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index ed4bbffe8d7a..d910e25c273e 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -300,6 +300,7 @@ static int userspace_tramp(void *stack)
 }
 
 int userspace_pid[NR_CPUS];
+int kill_userspace_mm[NR_CPUS];
 
 /**
  * start_userspace() - prepare a new userspace process
@@ -393,6 +394,8 @@ void userspace(struct uml_pt_regs *regs, unsigned long *aux_fp_regs)
 	interrupt_end();
 
 	while (1) {
+		if (kill_userspace_mm[0])
+			fatal_sigsegv();
 
 		/*
 		 * This can legitimately fail if the process loads a
@@ -714,4 +717,5 @@ void reboot_skas(void)
 void __switch_mm(struct mm_id *mm_idp)
 {
 	userspace_pid[0] = mm_idp->u.pid;
+	kill_userspace_mm[0] = mm_idp->kill;
 }

