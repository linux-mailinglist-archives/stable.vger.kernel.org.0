Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A081200A9D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgFSNsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:48:53 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:47219 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNsw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 357441945791;
        Fri, 19 Jun 2020 09:48:51 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=X6FNlq
        ue9bjn0HkULIcIuxChkb42q+sjlRZvyBvC4Lo=; b=s0k4E86hGmZHaWnx3wd362
        5pcy9q6IP8DxY2kmcC8TwuyzQWpCl3vWhPXPfge5LwTTjG22lslahkpWvUvq+U5b
        NCdiNfNm7pblnH9kuT1RKVzhI9MZ0ulSTO0VYbe/WFbxVwtfRyxmrZjaI6LCmSI/
        upUUhZOKvKv8f5WLgDAgb3bsPuFUqQI+/175AWWoqenI62s2UIZkVnygOw/DDhG1
        kYkEQWyeybFX874i1tyhb43JRD7tFH8Ni/IgJ17gFGT2ECqnn5yDNWoK6jgVtfCX
        03UFmtojT8n1Lb/oMqYCPPjTQz6cB2SBxpNNpSlw8ZWW9I7LSYjIEkhMUOkjIPyA
        ==
X-ME-Sender: <xms:Q8LsXjbFoouWBJjkcqqH3SZ8I4H77WwSABZDnz19IcgACR-AYCwm1A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Q8LsXiaYOptbuQFFxSlrEIfsFxO5yBt1wbuZIEFJtWzTvdw8V4A4lw>
    <xmx:Q8LsXl9EDeu1woxPmbTp_OWQNZoKX9iGFq2mKRERPe0rpTK4-Nd0iw>
    <xmx:Q8LsXpriiq4K65RugdVky8aMN6ysYgzcqf8BSo1BmvNxqZNo_LarIA>
    <xmx:Q8LsXlTuNJWyE0HMkvvspbsd-AuyoV7j7FI6tD6hFdgNAuo4nbaN6A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A8DB3328005A;
        Fri, 19 Jun 2020 09:48:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: ingenic: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com, harveyhuntnexus@gmail.com,
        paul@crapouillou.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:39 +0200
Message-ID: <159257451912572@kroah.com>
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

From de17cade0e034e9b721a6db9b488014effac1e5a Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 14:59:54 +0200
Subject: [PATCH] mtd: rawnand: ingenic: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. Hence, pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Cc: Paul Cercueil <paul@crapouillou.net>
Cc: Harvey Hunt <harveyhuntnexus@gmail.com>
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-22-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
index e7bd845fdbf5..3bfb6fa8bad9 100644
--- a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
@@ -376,7 +376,7 @@ static int ingenic_nand_init_chip(struct platform_device *pdev,
 
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
-		nand_release(chip);
+		nand_cleanup(chip);
 		return ret;
 	}
 

