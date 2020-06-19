Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5826200AB3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732993AbgFSNul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:41 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:33309 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732879AbgFSNuk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:40 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id E6ECE19457C2;
        Fri, 19 Jun 2020 09:50:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=FrK6/a
        kK6Sd2FIk6DIZe0G1LNidgzQOl571NgaRlbmU=; b=kfvW1FPZ/d0jHkyztMPajX
        a7nmn0OjEmrWR9WcOfULxOlwpVM26wXd9jz2/a+DI62Vsnd5crKEFP8aGsoSIGg+
        IR0CKlfwkQT+PjXEyEIihy1Efd+YtlJRMZu9PBRw09jWlou3kg1D7D3xgTMVNmCu
        2wVSZIBrKhj0ix4oeFahahABp86naJz4mTFbTrjX5D2bZ9L1QgWts4jb9LuvNgUe
        aD1H/IavtBeIFNINfOqY6gBAYoocP8tIzSmRxEb8PI2twXipijbAaXO2aVRKgkYj
        ZjW6tWANV5TGh+uT3b8JnNMWtxZdu3AjsJFxK6RM7WcaVb4XA/PWRaNHvf0+gdLw
        ==
X-ME-Sender: <xms:rsLsXmj2iQbwJP2B4i0XcmvR6WdvcwleQylOcthiO-6p8bFjvSm07A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdegnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:rsLsXnB29VuNzLBEGsTEOIfvrTZNQ2wJAyrKsF3qLUMKNwqdam4QHQ>
    <xmx:rsLsXuFljPYvQJiNw9GQJ5WBKaIAxb7Dsc5LtvwzCUleTyEPmIQoQA>
    <xmx:rsLsXvTynmvlTF8FTn_J3eD6v60Hsj9FqNN9s-GLfQLynqEF39d95g>
    <xmx:rsLsXi_GK0kw7hibQU4ErKcY-t0MzgX2UDtsJVIYvf5DDOwYYNTEWw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7DFC6328005A;
        Fri, 19 Jun 2020 09:50:38 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: plat_nand: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:36 +0200
Message-ID: <15925746364223@kroah.com>
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

