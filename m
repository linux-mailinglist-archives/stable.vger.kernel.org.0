Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 981193A5830
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231735AbhFMMFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:05:30 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35751 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:05:30 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailforward.nyi.internal (Postfix) with ESMTP id CD42019405EF;
        Sun, 13 Jun 2021 08:03:28 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 13 Jun 2021 08:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iLIwHs
        GaWsrY9MRhO1gB7YG/j7H/9StIS2oTQomnY6E=; b=i5OJ9WrN5wqAEC4hNXCGfK
        JXEA6dFr+0mIpdYrjWQz/xG9ahcrU/nQkkuebfmp+BpTHcIfIM1TSKSnGLuVRlc4
        8sFrdv2Jak2JGtNlOVlm/gn4YVmv7+E/M8l6nmGB8LI4kQTuj33AKcyclPkxPSaT
        ZuKoXHyLYqwEBRhpUpqgnASCqcqShKCaS/jB7IEDi8F9wbYXRxzvZqNvBHRpA+Ko
        GrMgMT5Sd2+maRRSE7+sRpx5uYYs61YuD2jh/Nr+oBtzgNqAYiKZIPyFY3Ly1obC
        hg4DdFGOxurJZYEqXwKcFUXAEgWximJeepYAFloGCvbcPGywWEVP3UjomwTSELog
        ==
X-ME-Sender: <xms:EPTFYBaUdXr5JUe_s370Gdth809fvWcmmza7H-PmOdaRuJeltVmijA>
    <xme:EPTFYIbtWacu94fz2cu2tUNeIjrmZy0f-ELgYNzK035sDDh_LQEgh-6ReqjsNRd7w
    OcKB88PvMxvYw>
X-ME-Received: <xmr:EPTFYD_emC9CqK8OBSTVtFpEZ1zWLcv_zF67D9JxSd4PtkUE6I6YBCODJkRn4-Md1yE2SDujRZyUH_xG3cZwvvNqeUkt2Wyk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:EPTFYPqmumSaXoDArTjumgleVe7z9WszasoPdemcvTTPHnM9VSaPsw>
    <xmx:EPTFYMp4OYyAludxD_FWc7ybQo4wbjbVs39QM5fhX2fK11dzAW31UA>
    <xmx:EPTFYFSGHF6YlUGUzIcJs8sa3pQA9Knw_KqqkyaKQC9b7ISx5_3ttg>
    <xmx:EPTFYJDXPW1Zg4Cn6fAH92V9mEb_efCNy_9ALgah029DChD_i_knzw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:03:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()" failed to apply to 4.19-stable tree
To:     rostedt@goodmis.org, mark-pk.tsai@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:03:14 +0200
Message-ID: <162358579470110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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

