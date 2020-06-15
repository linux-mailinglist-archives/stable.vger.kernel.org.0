Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E389D1F98EA
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730639AbgFONeQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:34:16 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:51475 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730650AbgFONeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:34:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 737355EC;
        Mon, 15 Jun 2020 09:34:12 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:34:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IXvU88
        Dvk672dAbyClzh5lDhCUCF6XXjSIYLkjdcEvs=; b=NxIFZgDnJD5x6opf4dAhPw
        eQo8thI9oHOSZ6fziavumkZkWDET6QA7PoLDfAhfovoPA9y76gacvS5AUvmY27c2
        cMGEK1VVPSLK7ZvbTtDrdwxtXx++9GokXfTKaAPiW7rDvkDkuiPVqg2IR1SgsevU
        7GWRNmhMGfdZdXq/GkWNwItYyL7L/ynoDfEprhSsETtlU2g83pRgNuWrLFtWtD+e
        N/tBSKVlJCu3n42fRa8iWdko7fSdbGbA7UYwMaCB3CtWYdK6ywRSmTmPnZUQXj/J
        1zGuk+uOpJu/+TP2LvR0zVieR+gpTbwG9FUkpj4h0cKNE99juRpesJJYBLP5WcCw
        ==
X-ME-Sender: <xms:03jnXhyNrQLLpifOYHFo7GUwEVkS_RYOAoX0ATCwmFJ7esOsj_EanA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:1HjnXhRZcraa5rp058GHTkQXKtlTxWP-OV8gm2ufNpxBsGwqX5Xagw>
    <xmx:1HjnXrU9iNixR9VjjD560dnpTeHZHoaocxfAsW_Ybg5itOr9tfkOLA>
    <xmx:1HjnXjhQMrdcw3JvQwVWpqim2E7cHdhfQbsCSjGDZNqGZvxHCWGUVg>
    <xmx:1HjnXm8auUUo0iqqyoLXak2OE3x6wQSg94B9eTRtdjUbVKN5217tEZo6Dx8>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADAB830618BF;
        Mon, 15 Jun 2020 09:34:11 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for" failed to apply to 4.4-stable tree
To:     asteinhauser@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:33:56 +0200
Message-ID: <15922280366520@kroah.com>
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

From 4d8df8cbb9156b0a0ab3f802b80cb5db57acc0bf Mon Sep 17 00:00:00 2001
From: Anthony Steinhauser <asteinhauser@google.com>
Date: Sun, 7 Jun 2020 05:44:19 -0700
Subject: [PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for
 indirect branches.

Currently, it is possible to enable indirect branch speculation even after
it was force-disabled using the PR_SPEC_FORCE_DISABLE option. Moreover, the
PR_GET_SPECULATION_CTRL command gives afterwards an incorrect result
(force-disabled when it is in fact enabled). This also is inconsistent
vs. STIBP and the documention which cleary states that
PR_SPEC_FORCE_DISABLE cannot be undone.

Fix this by actually enforcing force-disabled indirect branch
speculation. PR_SPEC_ENABLE called after PR_SPEC_FORCE_DISABLE now fails
with -EPERM as described in the documentation.

Fixes: 9137bb27e60e ("x86/speculation: Add prctl() control for indirect branch speculation")
Signed-off-by: Anthony Steinhauser <asteinhauser@google.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 8d57562b1d2c..56f573aa764f 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1175,11 +1175,14 @@ static int ib_prctl_set(struct task_struct *task, unsigned long ctrl)
 			return 0;
 		/*
 		 * Indirect branch speculation is always disabled in strict
-		 * mode.
+		 * mode. It can neither be enabled if it was force-disabled
+		 * by a  previous prctl call.
+
 		 */
 		if (spectre_v2_user_ibpb == SPECTRE_V2_USER_STRICT ||
 		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT ||
-		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED)
+		    spectre_v2_user_stibp == SPECTRE_V2_USER_STRICT_PREFERRED ||
+		    task_spec_ib_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ib_disable(task);
 		task_update_spec_tif(task);

