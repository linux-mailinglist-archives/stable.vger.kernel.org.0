Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB3591F98EC
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730436AbgFONeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:34:19 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:53499 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730636AbgFONeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:34:16 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id A5FDB621;
        Mon, 15 Jun 2020 09:34:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:34:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zCLdOC
        KJDG8lJSqHtuVWkvGL249d1wqucOV3eW3vwNw=; b=Pk9JKXMQZtgjKHAI2ozNTW
        zLVVB0BQoObo+JUEZlZg6+6qbIN6tUI/5D61hDl85iIaJtCrP5ufbSOeHL6M8s8O
        7rmFdtmjCzYIGHuezcf3IWpIpKqbp60KmXzqJdkQJ/kVwYtxeOqz5IMDAXBGq5UH
        kYwCRczP26pLFA5a15OZu3cXS+BgUG9mSPO+3N/jeOhjGWhimj8/gkU/He5BaqLh
        4ZnEMAhHb7wdgOnuFI5ihYxAOL1eMkaxhNvkiRkeLYjgbx/EG6AZhgqQcL1TBI21
        CvoBF8tsKakgbbbZCpZQX1ynaMeSLHcjgjAhT4ReJWtpHBKDD/RXtK2tUQEDEYWg
        ==
X-ME-Sender: <xms:13jnXn6bJd-h8CvoLiSUHLQqBZ20Rtb5NiAN5objgzMBTO1KIKQX5w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:13jnXs6E1LBuBM99Y5P09ptY6DxH8pQfC0G445jbiOpRhQAWTTNkHg>
    <xmx:13jnXuf3FUPj3Tra9UPGbEgv3YAFXe97AHe55jF8wXp49RLjxFh_hQ>
    <xmx:13jnXoKD62yRispPY1RmJkSqT0NMptJFm-0bMzKMux31fGW4Zx2dLw>
    <xmx:13jnXmlDa118qxW2lDFzyqf5vtC33W7Eg_Z2QAQ6xvMDRIEiL_R49LthlMQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE76A3280059;
        Mon, 15 Jun 2020 09:34:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for" failed to apply to 4.9-stable tree
To:     asteinhauser@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:33:57 +0200
Message-ID: <1592228037105197@kroah.com>
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

