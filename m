Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E841B200ABC
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbgFSNvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:51:35 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:35559 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731794AbgFSNvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:51:35 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 2FF5D1945453;
        Fri, 19 Jun 2020 09:51:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:51:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Y+xwRZ
        o38U5zr+40xQHhw9GjrHvTAEnAfdoIQKVi43k=; b=NSSr2N02lcSME/kOH59bHp
        8rBJiD7XkpogMf35gAFAfzIEMOuVlWmr6eqQFuCoONYRVR2m51tDKCFMFvRqi/qS
        jwh4I/6JTKbDyYtnOLOD3oZDWgPOFgQwVgdwjtiAOniu51juY7QcbOXRtVkL9c5D
        icu+7sgStsjlinou2JlHWQ/YdDHa8mm0NK/53XMePl8aIWSTrSqdATyITzM+ElqP
        Wyl8ZQfJQEDz4uCTpmLBmwXdVtfLv1+LMk4k2ZnlS8EqkUDTlgS52S0v/USIyLDd
        683j/EfAjC6tdbbMm3IxMgnfepTNI6ihZN+FoOT20xvDrRTdR8WPiFUVGH3tdT3A
        ==
X-ME-Sender: <xms:5cLsXsdSFUtMZupAX0_Om_FqB4dCbflWYct7xhxzeg6N2OQacQDfXQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepfedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:5cLsXuMk3Unrzlq0jmO2jyX8gTnZDta7aVVAXLDO8v2h2aKRs4VJlA>
    <xmx:5cLsXtj-8PQOuG8dPHS88ENHXFxYsAQk-chvFiiOcvh8wBeO-BHIUw>
    <xmx:5cLsXh_-lVPQEaIlt9r2w6C7deqsojUEYWiPlbgxmlufQbulRYnW8g>
    <xmx:5cLsXm6vPAgZCgfJ7tc4qgvLsveeMDHQ7HoPLIZ0jiJnUkxDpBFlvA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A86253280064;
        Fri, 19 Jun 2020 09:51:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: tmio: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:51:30 +0200
Message-ID: <159257469019340@kroah.com>
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

From 75e9a330a9bd48f97a55a08000236084fe3dae56 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:29 +0200
Subject: [PATCH] mtd: rawnand: tmio: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-57-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/tmio_nand.c b/drivers/mtd/nand/raw/tmio_nand.c
index db030f1701ee..4e9a6d94f6e8 100644
--- a/drivers/mtd/nand/raw/tmio_nand.c
+++ b/drivers/mtd/nand/raw/tmio_nand.c
@@ -448,7 +448,7 @@ static int tmio_probe(struct platform_device *dev)
 	if (!retval)
 		return retval;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);

