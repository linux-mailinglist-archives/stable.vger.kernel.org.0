Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87DD1F9BCE
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730212AbgFOPVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 11:21:02 -0400
Received: from wforward5-smtp.messagingengine.com ([64.147.123.35]:41737 "EHLO
        wforward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730269AbgFOPVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jun 2020 11:21:00 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.west.internal (Postfix) with ESMTP id EB1EB768;
        Mon, 15 Jun 2020 11:20:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 15 Jun 2020 11:21:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=M6zD5H
        Waez5a9JQjvyRftAbaDThdl8y0lUux2QUMU3c=; b=t3CLfz+EsxfBgvaUJvTeK3
        Vj8m7r/b3JvFgazsguW3dh0bQW6h6x5NbAS4QFR7oCI+P2FwLldR97YU4H6kmfDU
        8lvB6eMGtQIYi+zjtb/eriWcw5m13SlyA1L3w5yLSVRoitxtv2Ynb0F7g/I6D5hm
        5jwzHXFal+8Gpc7b4VQd45/A5RMtHxMgd4ytN9y+HxeiApooMGgRDPqgjn9vFyn0
        Biu1saiyky2v55PRtQlBxepAszwvDMFE6ZOoBy5Ff8MbqTfl4THdRi0VFc8Mz/7g
        irFkwuvFVPDlUdKb2TjpragDVubE7oNAdgH7eCNiAWOmkrFe5hR+uTP+Mb98MKgA
        ==
X-ME-Sender: <xms:25HnXk7f4qtnBCUoi6wM7SLlyn4Aoyunz9E6yAtZ4E0Nx4P5haFgvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeikedgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:25HnXl5EF8zuhThVFPDNg7WnXrRA9sYenKTHtfgfiqCDeKAiQshHOA>
    <xmx:25HnXjfoXE8gufu685Djjxj7fIiyjf-lJ3Qf_Kjz6uSOnzMvLuZmHA>
    <xmx:25HnXpK1x0xghjjzpwrbkC4WMGOOj72HNvyL37ybgyu-txqyuNQb3A>
    <xmx:25HnXiw1dNBQqFstaU8mgdibg_bHBMyDENI6lc3BXJJow_owypeWTgvhFRo>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3330A3280066;
        Mon, 15 Jun 2020 11:20:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: Fix controller unregister order" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, linus.walleij@linaro.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Jun 2020 17:20:45 +0200
Message-ID: <1592234445175159@kroah.com>
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

