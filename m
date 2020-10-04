Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D54282A39
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 12:36:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgJDKg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 06:36:29 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34609 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725825AbgJDKg2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 06:36:28 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 842121940232;
        Sun,  4 Oct 2020 06:36:27 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 04 Oct 2020 06:36:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=SQamb0
        IZfIbHd3dVqNpYsZUwsWy7OwiGWYZLRsWlMo8=; b=jCbec2cHR7nnBvLKrl47Y3
        mTC3olHd4r8xqDPvVAdzGBwccdpqyKG1UFo0/8PPkYtTDU4K087QizjOo8SRhw2x
        CYMqgdKFIirTebT0PJ8dlpfdkFuBJRpelJgI4t8Fz3T1mE/+AIBz/vVtoR9UZ5XC
        sEOa0oGLpKdKUJPoaCna7VEhbzoh5lSg8fBVj+x6fKMTAAVpLQ+CCTOeqJuFwVWt
        GheJ2OSvPtD6SRYYpQLHB8UM8PknEog1dJPTK/QB6a4fR91UmErCuwUPq+Jx6MsS
        XGFs8qTOQpo3QyuYh4dYdSQE4rqI1y4nlISs2jafpITWjfF+HLtAsD+OOq4Y1CMg
        ==
X-ME-Sender: <xms:q6V5X0Cb1ixvPTUPExd2S79L9SIlxzEnPhAMRAdUtwRN5M_LIYhHmQ>
    <xme:q6V5X2i20c3v22BPkieWfhmzZvL_EM6yu2RCbnioBkMt-UawBpLCc1ZqrTR6KnX05
    RIb5FzChOv9aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrgedtgdefvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeeiteevheeuvdfhtdfgvdeiieehheefleevveehjedute
    evueevledujeejgfetheenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtg
    homh
X-ME-Proxy: <xmx:q6V5X3lybFvMLMNTV-5WZP4rwLcrtwaDgfaFnJ7zIEVRCQ_TkmVHFg>
    <xmx:q6V5X6zfdBZPRcn9VQsbn4o4-Nh0KOxSs_M7S16ww6a6r0gNCOWP1A>
    <xmx:q6V5X5SIiyd6kF3Pd_aBigYvLOjQnCI6C_TL_6TEEG0Gk3HvpLPldw>
    <xmx:q6V5X64F3v4G2vfM4zqJdnn-4LjvGmrrXZa2l6ISJ-bU4vDCpUDmRw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BA258306467D;
        Sun,  4 Oct 2020 06:36:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] gpio: mockup: fix resource leak in error path" failed to apply to 4.14-stable tree
To:     bgolaszewski@baylibre.com, andriy.shevchenko@linux.intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 04 Oct 2020 12:37:11 +0200
Message-ID: <160180783111955@kroah.com>
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

From 1b02d9e770cd7087f34c743f85ccf5ea8372b047 Mon Sep 17 00:00:00 2001
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date: Tue, 8 Sep 2020 15:07:49 +0200
Subject: [PATCH] gpio: mockup: fix resource leak in error path

If the module init function fails after creating the debugs directory,
it's never removed. Add proper cleanup calls to avoid this resource
leak.

Fixes: 9202ba2397d1 ("gpio: mockup: implement event injecting over debugfs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

diff --git a/drivers/gpio/gpio-mockup.c b/drivers/gpio/gpio-mockup.c
index bc345185db26..1652897fdf90 100644
--- a/drivers/gpio/gpio-mockup.c
+++ b/drivers/gpio/gpio-mockup.c
@@ -552,6 +552,7 @@ static int __init gpio_mockup_init(void)
 	err = platform_driver_register(&gpio_mockup_driver);
 	if (err) {
 		gpio_mockup_err("error registering platform driver\n");
+		debugfs_remove_recursive(gpio_mockup_dbg_dir);
 		return err;
 	}
 
@@ -582,6 +583,7 @@ static int __init gpio_mockup_init(void)
 			gpio_mockup_err("error registering device");
 			platform_driver_unregister(&gpio_mockup_driver);
 			gpio_mockup_unregister_pdevs();
+			debugfs_remove_recursive(gpio_mockup_dbg_dir);
 			return PTR_ERR(pdev);
 		}
 

