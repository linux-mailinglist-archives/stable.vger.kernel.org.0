Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D4D327FAE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 14:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235859AbhCANif (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 08:38:35 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:50469 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235695AbhCANic (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 08:38:32 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailforward.nyi.internal (Postfix) with ESMTP id A4E5F194201C;
        Mon,  1 Mar 2021 08:37:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Mon, 01 Mar 2021 08:37:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=MDF10t
        iPUZzW+R1OMWHzyIUKfm0eKPCKHnER/q60c2M=; b=tTLgNcibIIx4aNnLTxHZ3O
        zn/rY6jHCx5splhM3D+J4e5HSSRRi4P/WOXl7yw3yPby3QnltEQ2xByA805SwBJH
        UjIWk+j/QLijemJuPHVTvLpTA3+RKURbLQSp0buJq/3vHGrd/6FHFRhGLx1SWDOR
        CoCKXg8Nv+8M7DWKjfWwuSvn83qgc7OV2hlv9wqEhgG1o3mULjFZEnEkAeO7nIAd
        obgdVaElspgEUkvSBD5eVo+ljUVXzHws5TGEc3mRK24ZWqc9zbDu6jjftHzfZfSB
        tDTwikW5JLos8p8/mkA0+0A+9r+DBqNFfR/4xftZsBKlh/DDc9ZuEah1f43UddrA
        ==
X-ME-Sender: <xms:Ke48YPDI94zoIZipd-QWmEj_tBIFWlFNi5vmvA6DHs2LGW5mKD0mrg>
    <xme:Ke48YPLg3NwxTVHSx1Ozpeazr6RGd9nknXyW972q4-u-QfBBqlM1IrrRBzS9pbtty
    IHGxpWvSF_ZiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrleekgdehfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:Ke48YKkqD2lIL9Mtwrn9rb4g-juFkwsmMgjie2_eAKA_65knfQwL5g>
    <xmx:Ke48YFEIE3IPj73D-dU4w1CNeDB0NwVZBmHtI-t3pO3F4TnnALZ3Pw>
    <xmx:Ke48YCHUCX3P3HJxanBp1dmAkrrwaDeWO8pP5H9K4SZP0V58zlAyXw>
    <xmx:Ke48YElopXi6PQbwGDsdmCw2EB1hl2CXsVUG1NQ7-ub6wbr3mEmNew>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9E70240054;
        Mon,  1 Mar 2021 08:37:44 -0500 (EST)
Subject: FAILED: patch "[PATCH] um: defer killing userspace on page table update failures" failed to apply to 4.4-stable tree
To:     johannes.berg@intel.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 01 Mar 2021 14:37:43 +0100
Message-ID: <161460586313746@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

