Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D39249D7D
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgHSMJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:09:51 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:58169 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728177AbgHSLrQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 07:47:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BDCAE1942279;
        Wed, 19 Aug 2020 07:47:11 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 07:47:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xleW6m
        PkBDillqVBKPoC0umcT3cxkxFIajS/pbK2bnE=; b=Ia7gvcuraxZAb7qiOA6La5
        lo6cbX3rjRBm468ymRJsfTdAeBiOl87miz9hPgEWFy9wPaejzMDFYnv1HSasrXRD
        hJlTX3FcN3bHmm4G4WXiVKIArplUkBN3DP/ul32Z2+aIMC9t8emDp7b3nqQSOHr3
        EHVfyq4nJj9X63xFHxt9lkL+NOZPRmukNav2EB1dEyQbN3qZYHoJe/m4QwRYXYHv
        5LAyRnRh89szKQ3GoL/drjN2VJzC0H8NljQ58N8OKrr7jg6j2UcYglK4N/UdQABo
        AxHtWVg0RoRh37jpn6SA6+e1v6bcbJMnSbkMosNQdDldjkOt+jc2y8nVQT/+zR9g
        ==
X-ME-Sender: <xms:PxE9X8D5CQDV83d6IkbNUjoicJ3e5d5uqHIYhXDfOI5tozeaeJj1IA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:PxE9X-jyl_-ZpgKQ5dVwPDhCJm5hw8HgDfRUlD5WYrb04Zd16bBtKQ>
    <xmx:PxE9X_k0L23qBPP3J_9hnBKdlh0q0ydzcN9zqMS-6c08Rgfs4IrJNA>
    <xmx:PxE9XyywIO9_jOgxfC15J4UYCAo_bVUHb8yHbjAZ95I3JQF380zJJQ>
    <xmx:PxE9Xy6YRtz_Cvhnnbv0m1y-Ic5EJzUzVC8WKuvZ5v_qvBmILNSCrg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52FF1328005A;
        Wed, 19 Aug 2020 07:47:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] powerpc: Allow 4224 bytes of stack expansion for the signal" failed to apply to 4.14-stable tree
To:     mpe@ellerman.id.au, dja@axtens.net, tgl@sss.pgh.pa.us
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 19 Aug 2020 13:47:34 +0200
Message-ID: <1597837654121190@kroah.com>
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

From 63dee5df43a31f3844efabc58972f0a206ca4534 Mon Sep 17 00:00:00 2001
From: Michael Ellerman <mpe@ellerman.id.au>
Date: Fri, 24 Jul 2020 19:25:25 +1000
Subject: [PATCH] powerpc: Allow 4224 bytes of stack expansion for the signal
 frame

We have powerpc specific logic in our page fault handling to decide if
an access to an unmapped address below the stack pointer should expand
the stack VMA.

The code was originally added in 2004 "ported from 2.4". The rough
logic is that the stack is allowed to grow to 1MB with no extra
checking. Over 1MB the access must be within 2048 bytes of the stack
pointer, or be from a user instruction that updates the stack pointer.

The 2048 byte allowance below the stack pointer is there to cover the
288 byte "red zone" as well as the "about 1.5kB" needed by the signal
delivery code.

Unfortunately since then the signal frame has expanded, and is now
4224 bytes on 64-bit kernels with transactional memory enabled. This
means if a process has consumed more than 1MB of stack, and its stack
pointer lies less than 4224 bytes from the next page boundary, signal
delivery will fault when trying to expand the stack and the process
will see a SEGV.

The total size of the signal frame is the size of struct rt_sigframe
(which includes the red zone) plus __SIGNAL_FRAMESIZE (128 bytes on
64-bit).

The 2048 byte allowance was correct until 2008 as the signal frame
was:

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1440 */
        /* --- cacheline 11 boundary (1408 bytes) was 32 bytes ago --- */
        long unsigned int          _unused[2];           /*  1440    16 */
        unsigned int               tramp[6];             /*  1456    24 */
        struct siginfo *           pinfo;                /*  1480     8 */
        void *                     puc;                  /*  1488     8 */
        struct siginfo     info;                         /*  1496   128 */
        /* --- cacheline 12 boundary (1536 bytes) was 88 bytes ago --- */
        char                       abigap[288];          /*  1624   288 */

        /* size: 1920, cachelines: 15, members: 7 */
        /* padding: 8 */
};

1920 + 128 = 2048

Then in commit ce48b2100785 ("powerpc: Add VSX context save/restore,
ptrace and signal support") (Jul 2008) the signal frame expanded to
2304 bytes:

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */	<--
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        long unsigned int          _unused[2];           /*  1696    16 */
        unsigned int               tramp[6];             /*  1712    24 */
        struct siginfo *           pinfo;                /*  1736     8 */
        void *                     puc;                  /*  1744     8 */
        struct siginfo     info;                         /*  1752   128 */
        /* --- cacheline 14 boundary (1792 bytes) was 88 bytes ago --- */
        char                       abigap[288];          /*  1880   288 */

        /* size: 2176, cachelines: 17, members: 7 */
        /* padding: 8 */
};

2176 + 128 = 2304

At this point we should have been exposed to the bug, though as far as
I know it was never reported. I no longer have a system old enough to
easily test on.

Then in 2010 commit 320b2b8de126 ("mm: keep a guard page below a
grow-down stack segment") caused our stack expansion code to never
trigger, as there was always a VMA found for a write up to PAGE_SIZE
below r1.

That meant the bug was hidden as we continued to expand the signal
frame in commit 2b0a576d15e0 ("powerpc: Add new transactional memory
state to the signal context") (Feb 2013):

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        struct ucontext    uc_transact;                  /*  1696  1696 */	<--
        /* --- cacheline 26 boundary (3328 bytes) was 64 bytes ago --- */
        long unsigned int          _unused[2];           /*  3392    16 */
        unsigned int               tramp[6];             /*  3408    24 */
        struct siginfo *           pinfo;                /*  3432     8 */
        void *                     puc;                  /*  3440     8 */
        struct siginfo     info;                         /*  3448   128 */
        /* --- cacheline 27 boundary (3456 bytes) was 120 bytes ago --- */
        char                       abigap[288];          /*  3576   288 */

        /* size: 3872, cachelines: 31, members: 8 */
        /* padding: 8 */
        /* last cacheline: 32 bytes */
};

3872 + 128 = 4000

And commit 573ebfa6601f ("powerpc: Increase stack redzone for 64-bit
userspace to 512 bytes") (Feb 2014):

struct rt_sigframe {
        struct ucontext    uc;                           /*     0  1696 */
        /* --- cacheline 13 boundary (1664 bytes) was 32 bytes ago --- */
        struct ucontext    uc_transact;                  /*  1696  1696 */
        /* --- cacheline 26 boundary (3328 bytes) was 64 bytes ago --- */
        long unsigned int          _unused[2];           /*  3392    16 */
        unsigned int               tramp[6];             /*  3408    24 */
        struct siginfo *           pinfo;                /*  3432     8 */
        void *                     puc;                  /*  3440     8 */
        struct siginfo     info;                         /*  3448   128 */
        /* --- cacheline 27 boundary (3456 bytes) was 120 bytes ago --- */
        char                       abigap[512];          /*  3576   512 */	<--

        /* size: 4096, cachelines: 32, members: 8 */
        /* padding: 8 */
};

4096 + 128 = 4224

Then finally in 2017, commit 1be7107fbe18 ("mm: larger stack guard
gap, between vmas") exposed us to the existing bug, because it changed
the stack VMA to be the correct/real size, meaning our stack expansion
code is now triggered.

Fix it by increasing the allowance to 4224 bytes.

Hard-coding 4224 is obviously unsafe against future expansions of the
signal frame in the same way as the existing code. We can't easily use
sizeof() because the signal frame structure is not in a header. We
will either fix that, or rip out all the custom stack expansion
checking logic entirely.

Fixes: ce48b2100785 ("powerpc: Add VSX context save/restore, ptrace and signal support")
Cc: stable@vger.kernel.org # v2.6.27+
Reported-by: Tom Lane <tgl@sss.pgh.pa.us>
Tested-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200724092528.1578671-2-mpe@ellerman.id.au

diff --git a/arch/powerpc/mm/fault.c b/arch/powerpc/mm/fault.c
index 641fc5f3d7dd..3ebb1792e636 100644
--- a/arch/powerpc/mm/fault.c
+++ b/arch/powerpc/mm/fault.c
@@ -267,6 +267,9 @@ static bool bad_kernel_fault(struct pt_regs *regs, unsigned long error_code,
 	return false;
 }
 
+// This comes from 64-bit struct rt_sigframe + __SIGNAL_FRAMESIZE
+#define SIGFRAME_MAX_SIZE	(4096 + 128)
+
 static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 				struct vm_area_struct *vma, unsigned int flags,
 				bool *must_retry)
@@ -274,7 +277,7 @@ static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 	/*
 	 * N.B. The POWER/Open ABI allows programs to access up to
 	 * 288 bytes below the stack pointer.
-	 * The kernel signal delivery code writes up to about 1.5kB
+	 * The kernel signal delivery code writes a bit over 4KB
 	 * below the stack pointer (r1) before decrementing it.
 	 * The exec code can write slightly over 640kB to the stack
 	 * before setting the user r1.  Thus we allow the stack to
@@ -299,7 +302,7 @@ static bool bad_stack_expansion(struct pt_regs *regs, unsigned long address,
 		 * between the last mapped region and the stack will
 		 * expand the stack rather than segfaulting.
 		 */
-		if (address + 2048 >= uregs->gpr[1])
+		if (address + SIGFRAME_MAX_SIZE >= uregs->gpr[1])
 			return false;
 
 		if ((flags & FAULT_FLAG_WRITE) && (flags & FAULT_FLAG_USER) &&

