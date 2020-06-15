Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8EB1F98EB
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 15:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730638AbgFONeR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 09:34:17 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:60897 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730651AbgFONeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 09:34:15 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id E85B763B;
        Mon, 15 Jun 2020 09:34:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 09:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DigOSz
        b/TBo2lIPWNjMEMhskGxq3oGhwv75eYQ5bveI=; b=hSHKxXacYtiiIzbRAAvSl2
        qir8amP38+fuPByCmrK1J75jYx6nZDO52e2yJb+uWlOj775OfFT9CAJaqowxK9cF
        AyKeWUEPmg9xqoCPoXIpXB75Fzm6n1VVsxHNllQo5yM/51c28XqFZd/f1IXrxQaE
        nR+SGdFf0Nc4IAA4vl+ysJUnlE+Tql0TE7osDVTqcBsCRFcvAin+i25OKPbwQ204
        9Gl9nM5S1THJtYWxxmBYabogUKJjD8fviYxPej3ZnKie8+n5Gs4nByAM/QxPobOH
        sGsYM9moHT059sbIASiPzvS96cJ/scQbTTrgeFYCfvUZu2MAxMS9GwjEWlnY3zkQ
        ==
X-ME-Sender: <xms:1XjnXuDEmquJJLsG-mMvjLkcv4p8tRl_I8cYjD3QcNZ51Sp2rroWIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgieeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushht
    vghrufhiiigvpedunecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:1XjnXogvPSThITgLX4F75FrFlxEuBpz5vqugmkqjUqfSJj2ZK2G26g>
    <xmx:1XjnXhnFgR8roL4r5asPK0iZQ3A4x7w0m_IGQhzrBemgdh8DTLW8qg>
    <xmx:1XjnXszNRKezRXSWB-TUarJgEEf1eVrgR7vjBfEhw_VRmZ_wk3fbtA>
    <xmx:1XjnXmPL1HIt45_UeDgPMetAR5Yu3mU62GJz5HoV0nD2qEoeIgtTO09ko08>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3379930618BF;
        Mon, 15 Jun 2020 09:34:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] x86/speculation: PR_SPEC_FORCE_DISABLE enforcement for" failed to apply to 4.14-stable tree
To:     asteinhauser@google.com, tglx@linutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 15:33:56 +0200
Message-ID: <159222803619199@kroah.com>
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

