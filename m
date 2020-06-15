Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBFED1F9BCB
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730186AbgFOPU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:20:58 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:45013 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730147AbgFOPU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:20:57 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 372617B8;
        Mon, 15 Jun 2020 11:20:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:20:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=HOC0Sa
        NyH+ZrWYbK5NZ+L0WuCpG8zjGqyEA5s7IWeb4=; b=NMJBK1blHfIObnrUrZ94ZZ
        ysYT1NR+av/OLHHSEnmzhDtXE0+lKYUfg1ELEfiFfgrEziC40Q6cp0xQjBk3f6zM
        IwhfyVLaJyhEvoP3QL9Icrg1J9yQqnEVp826+PMXgqxLqH5Ez6vKSxKQqNJTpF2a
        eJ9W4Bd5T0EOf2MPHrJOVrYwoaUX0RWQ6vZe0OmifIh50VQ1fIozK4kwptuZBO4J
        8T6XryqPTUHLSf5Iz1m7F40VQFqh9wIzjRNq2JDtvMGCcXcC6JTLY4tCtepAiDkH
        UtLXsOfS0bVtK1n/eTHdvbG5C1APG3iZ/pr23YWfjZxvjrkYDUMGIk7senwT2B4Q
        ==
X-ME-Sender: <xms:15HnXtVCqSGHauqiEi8BLL4cGQjFXLaKkNtNk-mLi7dtiaN9ffnoQA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:15HnXtnubgHjyxSxievGvFeXH8lYnm8F449UMdwr-Qx1mbMM6bYi1g>
    <xmx:15HnXpYAP5yby8zAzUr4934yOcnoyDDx09qprnk49bgSstzy_ufDaA>
    <xmx:15HnXgVwhQSbyeB2acqnrsob1ZT1PK5e57ubiT0Lfo5oV6VLfzdggQ>
    <xmx:15HnXmtad63qSHrl8y_l_O7yqpAerct5Pm6dVbEz855u7iAxUI74s60nGoQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 504D23280066;
        Mon, 15 Jun 2020 11:20:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: Fix controller unregister order" failed to apply to 4.19-stable tree
To:     lukas@wunner.de, broonie@kernel.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:20:44 +0200
Message-ID: <159223444415976@kroah.com>
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

From 84855678add8aba927faf76bc2f130a40f94b6f7 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Fri, 15 May 2020 17:58:01 +0200
Subject: [PATCH] spi: Fix controller unregister order

When an SPI controller unregisters, it unbinds all its slave devices.
For this, their drivers may need to access the SPI bus, e.g. to quiesce
interrupts.

However since commit ffbbdd21329f ("spi: create a message queueing
infrastructure"), spi_destroy_queue() is executed before unbinding the
slaves.  It sets ctlr->running = false, thereby preventing SPI bus
access and causing unbinding of slave devices to fail.

Fix by unbinding slaves before calling spi_destroy_queue().

Fixes: ffbbdd21329f ("spi: create a message queueing infrastructure")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v3.4+
Cc: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/8aaf9d44c153fe233b17bc2dec4eb679898d7e7b.1589557526.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 531d1de85f7f..25eb96d329ab 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2763,6 +2763,8 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	struct spi_controller *found;
 	int id = ctlr->bus_num;
 
+	device_for_each_child(&ctlr->dev, NULL, __unregister);
+
 	/* First make sure that this controller was ever added */
 	mutex_lock(&board_lock);
 	found = idr_find(&spi_master_idr, id);
@@ -2775,7 +2777,6 @@ void spi_unregister_controller(struct spi_controller *ctlr)
 	list_del(&ctlr->list);
 	mutex_unlock(&board_lock);
 
-	device_for_each_child(&ctlr->dev, NULL, __unregister);
 	device_unregister(&ctlr->dev);
 	/* free bus id */
 	mutex_lock(&board_lock);

