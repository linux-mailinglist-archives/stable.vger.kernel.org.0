Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99CC13A582E
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhFMMF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:05:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:42365 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:05:25 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id 870F619406BB;
        Sun, 13 Jun 2021 08:03:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:03:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kDtYfJ
        2p1r/wWTWgzOMwIBW8ey1BBSY4iDbxQ/EvoZk=; b=vnn5dCUg+SzZ0xKg3rdXZp
        mHKjruE+rtdchhFxMa53fP6yh7zyHztkE7CWO1XRGfKHvBQlnfFmlPRrqYGSCGE+
        gFqeOEVxMkm+KwDtW335guARX0EMPNaez0gUDc1TUoQqzC6TphPzgNECCk6SnUs+
        gAmmtZmGaEoRBPRssWx6fCj6uZOwc+1oPpa+4LJy3acoAEBAQk/toC2pnkJTGhRx
        ciJhQz9lK56ULYWg4ovWGH7gtawZNP0vONAY0H4LhUE6hJgv7k5W0LR1cILWUakw
        c6xuuZdkwVkgaDgV/+8ajHiBJrvJnF71vVs42CrtCTCpuUFht/LU8FP+6/C10gdw
        ==
X-ME-Sender: <xms:DPTFYOdyi9H09c_zTa1YCsY5X63zQg64mLmILwhZQBHpO7uCBegOVA>
    <xme:DPTFYIOShQgSR88KtJEtSRa1dcHLJ2S6tonIyha2ynzEkBO8bW4zUTuUngON5xePB
    qfjJweYEOckqQ>
X-ME-Received: <xmr:DPTFYPhrpUTAipIMTyd59rhyDdOPfYZbF3vZFVDY7SnW-SJe5Qv3dewrC05T_3oCbOWG8kiow9i3wsBLH5t0MrEUpPnQSRcY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:DPTFYL8087YY-8ZeEVRN1G0PwEI7YpcoVrG8--NcbTAlZ_7cGrrLjA>
    <xmx:DPTFYKvTSOX5GdcXOO7se0PQ1HVkEiVu9_cVxcaPfau5L3tXVOx8cQ>
    <xmx:DPTFYCFeuPou2ziTtj69UFPw2FaXwwj8tFu12zx-0umtBr-0mgNz8A>
    <xmx:DPTFYPV4Dv_Y5vRKa-pVTfYxAjg87CM08cmIFO4xO7U5hdMmCmEmeg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:03:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()" failed to apply to 4.9-stable tree
To:     rostedt@goodmis.org, mark-pk.tsai@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:03:12 +0200
Message-ID: <16235857929077@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From 6c14133d2d3f768e0a35128faac8aa6ed4815051 Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Date: Mon, 7 Jun 2021 21:39:08 -0400
Subject: [PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()

It was reported that a bug on arm64 caused a bad ip address to be used for
updating into a nop in ftrace_init(), but the error path (rightfully)
returned -EINVAL and not -EFAULT, as the bug caused more than one error to
occur. But because -EINVAL was returned, the ftrace_bug() tried to report
what was at the location of the ip address, and read it directly. This
caused the machine to panic, as the ip was not pointing to a valid memory
address.

Instead, read the ip address with copy_from_kernel_nofault() to safely
access the memory, and if it faults, report that the address faulted,
otherwise report what was in that location.

Link: https://lore.kernel.org/lkml/20210607032329.28671-1-mark-pk.tsai@mediatek.com/

Cc: stable@vger.kernel.org
Fixes: 05736a427f7e1 ("ftrace: warn on failure to disable mcount callers")
Reported-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Tested-by: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 2e8a3fde7104..72ef4dccbcc4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1967,12 +1967,18 @@ static int ftrace_hash_ipmodify_update(struct ftrace_ops *ops,
 
 static void print_ip_ins(const char *fmt, const unsigned char *p)
 {
+	char ins[MCOUNT_INSN_SIZE];
 	int i;
 
+	if (copy_from_kernel_nofault(ins, p, MCOUNT_INSN_SIZE)) {
+		printk(KERN_CONT "%s[FAULT] %px\n", fmt, p);
+		return;
+	}
+
 	printk(KERN_CONT "%s", fmt);
 
 	for (i = 0; i < MCOUNT_INSN_SIZE; i++)
-		printk(KERN_CONT "%s%02x", i ? ":" : "", p[i]);
+		printk(KERN_CONT "%s%02x", i ? ":" : "", ins[i]);
 }
 
 enum ftrace_bug_type ftrace_bug_type;

