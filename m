Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB133A5831
	for <lists+stable@lfdr.de>; Sun, 13 Jun 2021 14:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231736AbhFMMFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 08:05:33 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:52763 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231658AbhFMMFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Jun 2021 08:05:32 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id 60CA919406E6;
        Sun, 13 Jun 2021 08:03:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 13 Jun 2021 08:03:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ptNd++
        KO+fTY3gm1E2ff5q8Fd6ezC8e/RQ27mzzxKr8=; b=bgvsHxWUVILkOj0yiGJadH
        Wm7Gj2UAfvu1ql0UnGq/QZktDxo7JGIrTCls8JKjf3HNJP1sytChOaWoRc2TAa5g
        VJLhn77K41YOOYlCPUqOe8/00VeCvotxcQbTN40FfCpZmb3yJEbzbtDqAa512QHf
        2aab38YVvzy+lT5gA8zpltM/1qXnE0tH49BoCSC6FJgtVyGCAvhK13u1uSSn3DwP
        mvA+Bwd9eKZyE3JnYz/UYy+V/cBX4KxZUsFPCaRD3uyFDvoqzZNEdp5CTbrLHb80
        I/dHguL6tQOgIKmFWsKuFvRkC87R3fKqSj7hiJTSij9sVFd81Uzd48ZUox68u8zg
        ==
X-ME-Sender: <xms:E_TFYJUH3Q2_3uoGUaCrm7yZhwJuI-WtLIM0CUzMiBAgy7-pkYeYzw>
    <xme:E_TFYJk0PvdnT5SXLY8RwoYE7LL_Eh_9Pxc_fNjGEwcCimbHLbVV4K-1r6hUV-94M
    0GZs1dAaVqVew>
X-ME-Received: <xmr:E_TFYFYzKkvE9C77eHn4rctTfcs7uKdgxPu31NlB4A5GqTvJIdUGS3_zCcOFnKr-tXpaqxBzA_pVZ4rzoLhztfH28rTXaHuc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvfedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhu
    shhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhroh
    grhhdrtghomh
X-ME-Proxy: <xmx:E_TFYMWLQhfJhchNFCi1486T9Yl86R5pU3RRz5fHku3eL435OocNFA>
    <xmx:E_TFYDlFyJwdmFP_8Yq9drc_CZTk-_QJWFUnRDoP7VC1Y06ZS-bIzQ>
    <xmx:E_TFYJdL6W6_rA8CZKKpLUVzYinBbVHoRgVF1PjIofmhlcEeLpLs4g>
    <xmx:E_TFYLtqM_5rUf0pcP1yCpQdrLMp12rC9q8wDaNLJKEMqfxWbCFNzA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 13 Jun 2021 08:03:30 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ftrace: Do not blindly read the ip address in ftrace_bug()" failed to apply to 5.4-stable tree
To:     rostedt@goodmis.org, mark-pk.tsai@mediatek.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 13 Jun 2021 14:03:15 +0200
Message-ID: <1623585795198152@kroah.com>
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

