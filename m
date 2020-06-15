Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13EF81F98E5
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbgFONeJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:34:09 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:46531 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730642AbgFONeI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:34:08 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 8BF3767F;
        Mon, 15 Jun 2020 09:34:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:34:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UXJCle
        kXVZ8Hnw9rSlTM1YIauRdfMOuJcQbOt8Esqvg=; b=ebcnb3G8q9g2BXK9V//gCi
        J1vNELWXz5nqxDmuSGxrrHvOyqRZ5ET454ZVS8DZ9Cs7id/MEyIK359XfLkWDNto
        pJAqbJ7Jg+A7jX3UlMmNpPiug/QVsFiKnfdn0sWUMkX4+bKPhPlBIjn03JjClnLl
        tILpIBsu6fDnJUx7vCsxJpn+3+QLHGxTtCkua9WhMqcUigjd9eC2Z0VcvSqkWwUs
        5yqeBR+Uuqb0wRccpUFJ97kzMcsBimmtxUU9f0d0Xv19t8GWOQobn7vghxjcS8w7
        jYynNneGwKxwVGdmV+plBHB16xyNOhuiEZmS4In1HFULLITE1qTbhJijF8gaXzhA
        ==
X-ME-Sender: <xms:z3jnXk9DlVJSD47sNlZq45h081ymmSxcGflDKWZIyHd3AqQwD7qPpg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:z3jnXsu-0BoeJ_lV5o4hKO0VLSM80mNXrAB7yt54WEQJSrZxuwvM1A>
    <xmx:z3jnXqD2z9oCdmBdbzAEh49zhbTllXAuAG1lnhv_hkjzXlSPAi3-gQ>
    <xmx:z3jnXkcug2JJgMy4S-u19eDyM1iqnl-4daHJixTFPvejrR0CPWZAbw>
    <xmx:z3jnXgbggzOHtxI9OhEendhFHEKzYCT6dOaGV9E3ujN6tMpSPI-KDsMHFc0>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B33A430618B7;
        Mon, 15 Jun 2020 09:34:06 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for" failed to apply to 4.19-stable tree
To:     asteinhauser@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:33:55 +0200
Message-ID: <159222803512332@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

