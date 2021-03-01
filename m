Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50304327FB5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhCANjE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:39:04 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:53277 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235879AbhCANjC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:39:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9B8081942022;
        Mon,  1 Mar 2021 08:37:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 01 Mar 2021 08:37:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=UwEBoV
        SG5hBiOxA+P7k/q4mO2FLgnxhPnbmKRpTr3VM=; b=pUeHTveJmzT4GEh5edn+2a
        BLVXLgCSsU5mqoK52FWIOp6Bx7RRAvXVkLj7AU6FivxdXPXLP/VUShAifMgSt/OI
        4MzBI6kY2wjmeCakHkNk3kqhFwv/g1wrCej+i5hBf4plIJeIwkKw+MtUJWyNOtWD
        usKNw4JbflSbp6jl9+bZq7i+Nm9IijuLQr36vYAOZiB1uKcPRsfdB/0h+PhKcBK/
        GlehrG2odt2byoLpibxI7jSO3fe3FtZhHxq1Lc6MqyM9I2svGQd9hjkWCSaMpuuW
        vFLXFKLcFKOOGuyXFcHxJAicEZ0D1SP0elqkYBJMWWGs9QvIjBEEE8HnxJA7yjdw
        ==
X-ME-Sender: <xms:Mu48YEBZeHE17ouiyTI-HqtqBgV_hBbT79EfFUF3Vt7UMLZ2-QGfuQ>
    <xme:Mu48YAIzAhPpeSk_L1d1qazFOymsZRztTacLb7E8TWxYZvw-y0SuYZcT2HZ4-Cg3L
    7aBqbhsxqv_dA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Mu48YHl7bYWzu1FuHG_cQAm1U-aY2T3ALbYYW7KegEj7KKBAdW3cgg>
    <xmx:Mu48YOFQliKC6Fa06ahf-3sNLESxz5QC6opKp9g8R6FZ1asac7WNcg>
    <xmx:Mu48YHEZ4VzhA0GjN2_Wt3cfKPpZA9wwB5CP83zvZdsA-PTAJa9Z5Q>
    <xmx:M-48YBkDD5MBnEmdxxodMOU7AIblUWAKefgKhdNqe5sqDxapM91NYg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4B6B6240054;
        Mon,  1 Mar 2021 08:37:54 -0500 (EST)
Subject: FAILED: patch "[PATCH] um: defer killing userspace on page table update failures" failed to apply to 5.4-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:37:46 +0100
Message-ID: <16146058665070@kroah.com>
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

