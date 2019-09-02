Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8D8A5D16
	for <lists+stable@lfdr.de>; Mon,  2 Sep 2019 22:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbfIBUYe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 16:24:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54021 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726518AbfIBUYe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Sep 2019 16:24:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id DCF9B21C4D;
        Mon,  2 Sep 2019 16:24:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 02 Sep 2019 16:24:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YeCJAU
        qyeZ2+/WunPDP/6iO0TuMZwhGltsF+gAbzeBM=; b=yGogoRH0AK9Ue4DUt7Irqf
        WEN5HpdXzOlJhVmDfQYV7EaNU/mZ66wBso2VH+4HrFlrbqk4RcXdf0B5yI7Xq/3/
        PIeb8GQncBv0enqCtDzYIlyB+j9kssZEJ4H6fnGQZOHTcMFstqm/nWxnEeO0n9//
        5i1Yu9xv0Q23Qp6ngUqvzI9AN9obkrzyZse09XZJ/AvcmlIe8FwvZPnVvV6okKCT
        zZ32ujJZo8Z52GwOAaIqDRM1YilDvLRbhq4FvbnzJjPPw0iQByY7atc1Ue77r2XK
        JfD04Cz9VVZe9VXWPRdywCvnlc/HO004XTVHdo1ThBhLcsLrM7bElnAPlyaN2nyw
        ==
X-ME-Sender: <xms:gXptXerDJVNiOiyLas2dyPEIqdDLj4-6RGkX1weJAV54FOPeVgEaiA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejtddgudeglecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:gXptXT4Tqp6FwdzBZpPvKcP8CXQ1ewrBj3Y7okMUsAhVwXr9w9HdZA>
    <xmx:gXptXSuqOwlHXEv9fUuhe-My1RKfSZ-FvieMZvARHMYOFLzlf8jZtA>
    <xmx:gXptXXCeT7-p1vCtJxmi6w690cacCpjTTOzoaQLw1WVI3JcdPgbLcQ>
    <xmx:gXptXYwjZHs_1d28XLFm7zLAjhL5mtG2pZSnyc6X4loEC-9YpsBBRQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5C89A8005A;
        Mon,  2 Sep 2019 16:24:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] uprobes/x86: Fix detection of 32-bit user mode" failed to apply to 4.9-stable tree
To:     me@sam.st, dsafonov@virtuozzo.com, mhiramat@kernel.org,
        oleg@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 02 Sep 2019 22:24:30 +0200
Message-ID: <15674558707513@kroah.com>
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

From 9212ec7d8357ea630031e89d0d399c761421c83b Mon Sep 17 00:00:00 2001
From: Sebastian Mayr <me@sam.st>
Date: Sun, 28 Jul 2019 17:26:17 +0200
Subject: [PATCH] uprobes/x86: Fix detection of 32-bit user mode

32-bit processes running on a 64-bit kernel are not always detected
correctly, causing the process to crash when uretprobes are installed.

The reason for the crash is that in_ia32_syscall() is used to determine the
process's mode, which only works correctly when called from a syscall.

In the case of uretprobes, however, the function is called from a exception
and always returns 'false' on a 64-bit kernel. In consequence this leads to
corruption of the process's return address.

Fix this by using user_64bit_mode() instead of in_ia32_syscall(), which
is correct in any situation.

[ tglx: Add a comment and the following historical info ]

This should have been detected by the rename which happened in commit

  abfb9498ee13 ("x86/entry: Rename is_{ia32,x32}_task() to in_{ia32,x32}_syscall()")

which states in the changelog:

    The is_ia32_task()/is_x32_task() function names are a big misnomer: they
    suggests that the compat-ness of a system call is a task property, which
    is not true, the compatness of a system call purely depends on how it
    was invoked through the system call layer.
    .....

and then it went and blindly renamed every call site.

Sadly enough this was already mentioned here:

   8faaed1b9f50 ("uprobes/x86: Introduce sizeof_long(), cleanup adjust_ret_addr() and
arch_uretprobe_hijack_return_addr()")

where the changelog says:

    TODO: is_ia32_task() is not what we actually want, TS_COMPAT does
    not necessarily mean 32bit. Fortunately syscall-like insns can't be
    probed so it actually works, but it would be better to rename and
    use is_ia32_frame().

and goes all the way back to:

    0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")

Oh well. 7+ years until someone actually tried a uretprobe on a 32bit
process on a 64bit kernel....

Fixes: 0326f5a94dde ("uprobes/core: Handle breakpoint and singlestep exceptions")
Signed-off-by: Sebastian Mayr <me@sam.st>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dmitry Safonov <dsafonov@virtuozzo.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20190728152617.7308-1-me@sam.st

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index d8359ebeea70..8cd745ef8c7b 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -508,9 +508,12 @@ struct uprobe_xol_ops {
 	void	(*abort)(struct arch_uprobe *, struct pt_regs *);
 };
 
-static inline int sizeof_long(void)
+static inline int sizeof_long(struct pt_regs *regs)
 {
-	return in_ia32_syscall() ? 4 : 8;
+	/*
+	 * Check registers for mode as in_xxx_syscall() does not apply here.
+	 */
+	return user_64bit_mode(regs) ? 8 : 4;
 }
 
 static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
@@ -521,9 +524,9 @@ static int default_pre_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 
 static int emulate_push_stack(struct pt_regs *regs, unsigned long val)
 {
-	unsigned long new_sp = regs->sp - sizeof_long();
+	unsigned long new_sp = regs->sp - sizeof_long(regs);
 
-	if (copy_to_user((void __user *)new_sp, &val, sizeof_long()))
+	if (copy_to_user((void __user *)new_sp, &val, sizeof_long(regs)))
 		return -EFAULT;
 
 	regs->sp = new_sp;
@@ -556,7 +559,7 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
 		long correction = utask->vaddr - utask->xol_vaddr;
 		regs->ip += correction;
 	} else if (auprobe->defparam.fixups & UPROBE_FIX_CALL) {
-		regs->sp += sizeof_long(); /* Pop incorrect return address */
+		regs->sp += sizeof_long(regs); /* Pop incorrect return address */
 		if (emulate_push_stack(regs, utask->vaddr + auprobe->defparam.ilen))
 			return -ERESTART;
 	}
@@ -675,7 +678,7 @@ static int branch_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs)
 	 * "call" insn was executed out-of-line. Just restore ->sp and restart.
 	 * We could also restore ->ip and try to call branch_emulate_op() again.
 	 */
-	regs->sp += sizeof_long();
+	regs->sp += sizeof_long(regs);
 	return -ERESTART;
 }
 
@@ -1056,7 +1059,7 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
 unsigned long
 arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
 {
-	int rasize = sizeof_long(), nleft;
+	int rasize = sizeof_long(regs), nleft;
 	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
 
 	if (copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize))

