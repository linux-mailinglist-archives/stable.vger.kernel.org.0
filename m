Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 141CE200AB6
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732879AbgFSNut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:49 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:56973 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732996AbgFSNut (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:49 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 049AD19457BD;
        Fri, 19 Jun 2020 09:50:48 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=I96QXE
        ABp2yKgfhZKXIcRdyjAXwJd+TTR6L+eC74Xcc=; b=Vgzf03ueqdBHAhNQrdVKsH
        ShMKozcj9GezUYjAczLQaQcmh//TB6hMF433HVCUgh6FtloHxI1yCx1qYi1f+3ce
        gM8Qg+qJuOX9BHJmIG3S5jOy2WOd/Z8m7QWSsBub3/yD4gCImm6HAEceuF4sjGzZ
        sDmx4k7k7ucq5PWskgxQC9JMXuyUbr/b1wcRLmFiXyicYqWLkSw4GM3sujgW/lsy
        PGtOLoQNio5wsueXap3FQboC9URRL6YzebTcpg9lxkprEjjDd1aM0xU6Z3tIU1z8
        hJWzU6fhVZymqprXXTQxkAECJctDnIU+3IvcsYbpcwjCa+bClrpeyaIMUUuPQHlw
        ==
X-ME-Sender: <xms:t8LsXq1zl_uQk3uC3GUdpmQOoOUIIHEMmyLQGceh9m1CnhJQsdWEgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdehnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:t8LsXtHK2yI2sxSDGZR1c89nrOCyL0Vd17_z014Ms30y_uA2Uv5izg>
    <xmx:t8LsXi552X16Qcl4TOdQhwwyrC1Xcx3Z0XwY4kJ59Gv4ffCCQg4Hfg>
    <xmx:t8LsXr1Yw9e_GJ3fFCx38uW2zE6yTbdiSXGFBqFSMkZEOYAlAtqXTg>
    <xmx:uMLsXhTHrzZb1KQP4LsJr63SYHdQBY-3JtyJXB0XrDuIM4dBTQPTDw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9996A3061856;
        Fri, 19 Jun 2020 09:50:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: plat_nand: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:37 +0200
Message-ID: <159257463777181@kroah.com>
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

From 5284024b4dac5e94f7f374ca905c7580dbc455e9 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:15 +0200
Subject: [PATCH] mtd: rawnand: plat_nand: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible, hence pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-43-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/plat_nand.c b/drivers/mtd/nand/raw/plat_nand.c
index dc0f3074ddbf..3a495b233443 100644
--- a/drivers/mtd/nand/raw/plat_nand.c
+++ b/drivers/mtd/nand/raw/plat_nand.c
@@ -92,7 +92,7 @@ static int plat_nand_probe(struct platform_device *pdev)
 	if (!err)
 		return err;
 
-	nand_release(&data->chip);
+	nand_cleanup(&data->chip);
 out:
 	if (pdata->ctrl.remove)
 		pdata->ctrl.remove(pdev);

