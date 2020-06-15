Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B15D1F9BCC
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgFOPU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:20:59 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:36241 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728326AbgFOPU7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:20:59 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id 80B4F7DB;
        Mon, 15 Jun 2020 11:20:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:20:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=9el1SR
        YEzz+qDgjsH+hge8brZZQ5UMbf8ClAYpG/Cro=; b=ARP+u96O7urG62oz/oOdwj
        N10EGAms0jGQnK4WBPIcNMk3LuikcdwfW6qQzCAm52beKdkfqrL2K3c8/ZGWtbRI
        NilFuNqvuGlcS9opytz8FQCzCNvEw8UKueDJTREB6hjaQVCMXJGtNiRHcdK0eVvx
        HJuQZYpSRjuLDbvxdAo2vElXtXlBXc68B+umjjMxj59iwmOXwvWkh3iyEWt5nuXK
        lsWggPL4gJ9gv1+U12hWl/MOfkRaNrobvX1jLNLI+vLqRWGKlqbhTfv2cjRsJsVd
        q0OUEKu1FWpUhpuCEmZYCXEsJlIj/u+9guLtwmC6nABHYXHNa5CJPHgFyAWCMpAA
        ==
X-ME-Sender: <xms:2pHnXvosc74b4gi-Ws1woUHhxhQerQ4bej6BoXVPumL-PNjd9VVZbQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2pHnXpre4BsbzcuAMJs4SyuJGetG7VaeMd2uRPY0o-osP25XaDETHA>
    <xmx:2pHnXsN7FaAzwQYpanGgLhmTlp0JORLTDcrKMvBuV-G9oq9VZJx_pg>
    <xmx:2pHnXi5Q_uwmKYSYhb9Ri5h2GDdeXJdBIZaONstbVxUjzFvE3qv-9g>
    <xmx:2pHnXjguHyNjPOjiS1tXRpCghgnrvsno6fp78cmv8fKJ5Uvn83k5brcR77U>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A40563280063;
        Mon, 15 Jun 2020 11:20:57 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: Fix controller unregister order" failed to apply to 4.14-stable tree
To:     lukas@wunner.de, broonie@kernel.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:20:44 +0200
Message-ID: <159223444414194@kroah.com>
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

