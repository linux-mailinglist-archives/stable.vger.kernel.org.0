Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C211200AA7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732681AbgFSNty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:54 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:57515 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732007AbgFSNtw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:49:52 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 62B1A194575A;
        Fri, 19 Jun 2020 09:49:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:49:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ziOgnx
        zutxk+giliO8A56Yl8outj88b1gjEJMCHag2Y=; b=FTtQLg5OuxYoQfQlbcgZaU
        G28UKK9uYeFgmxv/OMl2tMHg4yEasCoI9TKCmSYGOn3xqlpYKOqkfMzzH5Vffppl
        275ew2N4DHgci5taoSAZ6Znd/UyelkRxlRq6WDUHwnTq5XcrLOdGZXOUEWAzwwS8
        2g5SRUV+roNzJM6f0VFVw9OqBTueEkI9sK132d/BpEYFtkUsLNY1JU7mdDNioW2P
        tdYIvHavQ8z+PqfCsAGHvGNshIRnkwITgxNRj9AJ/pUYHbam38Swa9NBrs8AKFh6
        o3Mv/J/Y0IJmj5v/zbMI4odL5hSRCbcM7GqIaort6MTtnrO5ICi0VTUhyx+q8JUA
        ==
X-ME-Sender: <xms:f8LsXsAY6hZlwEaDkrNJsVRkkRtTTmNRBJJCTd9p7Rp5IkIhs__P0Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudehnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:f8LsXugl36zwu9oCGqX-LaaUOUWMyrWQnYGRYEPrRvZcXw6iQm5c9A>
    <xmx:f8LsXvnrUTDqx8nzKQ4lXXrvNA2PbOEWQ6Hk-CefZBUHfqpUlEzMbQ>
    <xmx:f8LsXiybUumopI1dA_sR1G66bN122JHJ9gFSP-ZYxj7ZarVt9PjlDA>
    <xmx:f8LsXofbnLnphsn139Ek1tW1cCqt1sMVOKXS-dSMFez5uTr_Vrsv3w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DBA843061856;
        Fri, 19 Jun 2020 09:49:50 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: oxnas: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:49:49 +0200
Message-ID: <159257458912643@kroah.com>
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

From 154298e2a3f6c9ce1d76cdb48d89fd5b107ea1a3 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:09 +0200
Subject: [PATCH] mtd: rawnand: oxnas: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

While at it, be consistent and move the function call in the error
path thanks to a goto statement.

Fixes: 668592492409 ("mtd: nand: Add OX820 NAND Support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-37-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/oxnas_nand.c b/drivers/mtd/nand/raw/oxnas_nand.c
index bead5ac70160..4fadfa118582 100644
--- a/drivers/mtd/nand/raw/oxnas_nand.c
+++ b/drivers/mtd/nand/raw/oxnas_nand.c
@@ -140,10 +140,8 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 			goto err_release_child;
 
 		err = mtd_device_register(mtd, NULL, 0);
-		if (err) {
-			nand_release(chip);
-			goto err_release_child;
-		}
+		if (err)
+			goto err_cleanup_nand;
 
 		oxnas->chips[oxnas->nchips] = chip;
 		++oxnas->nchips;
@@ -159,6 +157,8 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_cleanup_nand:
+	nand_cleanup(chip);
 err_release_child:
 	of_node_put(nand_np);
 err_clk_unprepare:

