Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2650B3A582F
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhFMMF2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:05:28 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:59141 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:05:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 008501940682;
        Sun, 13 Jun 2021 08:03:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 13 Jun 2021 08:03:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=JdcDp3
        GKoVyRBximQkUHKBo3kv3VCfqwzHJ26jfXOR0=; b=TQgvEX/QFM2yoGVZZFYYkG
        UUpSa38mSeL2g4a14KMrGJE8J8OyK46adcoKn2yN4Fe9N0Lmb3PU5AgLkP9xIbhC
        mukGsjqWqVzqkjx5F6j7Hfe/es1mmU7aQzwYuE8c6v20NtHJPvhSRs0jTA38szr+
        gdScqJ8rY8gxQu0Kb9qJ3+VO9qfaAqzkIhuyQPNE1k+LmAexTXcidWyLpA4pL1KJ
        /IU93Cd+RQfylsh/X8XK2stqHKJHEX6VYLjj37KTZAjvE3nXgFFbbMpZuWtbUdXj
        1eB5gZ8esCUCHMmoNWVOtro+L37OUScxcESge/eH+Zr3gWp3PMozUbia+dWghpYQ
        ==
X-ME-Sender: <xms:DvTFYLVBRXsRbpezOGmuThao6HIR41Ru_cMqylLwVZRSCmXQlexzVQ>
    <xme:DvTFYDm0V4bu8NQ7-FXfgS6lgCFbSFUvJYri3N5dAmJzfxelDnPOF6NmC2Rk-noyd
    wBezO76U_mXHQ>
X-ME-Received: <xmr:DvTFYHZKL4kpTO92niqY_gnjmcQuWN8DwohekDXzkFkmfw2KKVDVEis7TWr4IjotrJy3M5GvBg1rpDvRvS3aSBLHIcWWWOsz>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:DvTFYGUktCMHnu1Q_dRy2B_tdBZpH6M_pwDtFTMD8iYT3Z8hOc49mw>
    <xmx:DvTFYFkBxmsDcJT2ajXw49UelblPrub5tjcPI53OcaT3UZKXG9RDEA>
    <xmx:DvTFYDcld7WiRk9tjkBWrMon7cdNiRf0zDxzAOrq-KJAO9bk773ezg>
    <xmx:DvTFYFt3w5VHJO7TkhzYb7wpU9GqOROfW5wGT7BB4jQREs_4VkFfiQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:03:25 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()" failed to apply to 4.14-stable tree
To:     rostedt@goodmis.org, mark-pk.tsai@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:03:13 +0200
Message-ID: <16235857934371@kroah.com>
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

