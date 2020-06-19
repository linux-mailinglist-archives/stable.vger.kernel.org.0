Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FF0200A99
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgFSNsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:48:18 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:32937 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgFSNsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:18 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id F04F71945783;
        Fri, 19 Jun 2020 09:48:16 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=em+5cQ
        6g3gaQeTNxCjFnL5AF+2vD9lQ9N1B9refGLac=; b=Na6Op3LogI1wG4h/USgRV9
        SApLX4QODAjlQIZY1MjZcnm8FT1TrqVhlgioKE83CqbcrL2kXyp+EcTvAxwgpauM
        wWp58a3D+53roIoittTHg6yJwb5dclSK32205dcZIk7uQGA2gy7UoAG+Pqt7fkgF
        eLWX5KLupzYLvIOB/vQ75fTS/BWuRphXGe1h0447C3qNtE4x4BxfDyBNUzSCQN7s
        hQ3yR/jBsJSBVkTJBrLnPcXBTGSCkJO+WNSWs55igTgcWv9PWH9q8Elinq+pMrRK
        Rubb9r7TnSMyR7V1gitXIXhaWH70WpplhenRK920PxiZZeNnqdsGpkruLg5AUURQ
        ==
X-ME-Sender: <xms:IMLsXmWWi2yHE1reUACqHam6COtyZMbChxMVeBk8lvZGmUznoP6Vvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IMLsXinjnyNJV0MaoUw8sOarH4NSy6H7I2lpP61OjLylAlpYivsk5g>
    <xmx:IMLsXqbmVsArJHo3yTgWm2Wx_gdc46p-ctG4dZ5UARUQeUPk-2vldA>
    <xmx:IMLsXtXEJNKcFkWcSdGz3Xe4Sw3FjoD7ryuXpwnL3e6MNvmajqilBQ>
    <xmx:IMLsXsyIULTyzVLGxzdHGHxJ_HEIeQ-QRP6TZds6s87frk-WwhxxXg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 76EE0328005E;
        Fri, 19 Jun 2020 09:48:16 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sharpsl: Fix the probe error path" failed to apply to 4.14-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:05 +0200
Message-ID: <1592574485129103@kroah.com>
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

From 0f44b3275b3798ccb97a2f51ac85871c30d6fbbc Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:21 +0200
Subject: [PATCH] mtd: rawnand: sharpsl: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-49-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/sharpsl.c b/drivers/mtd/nand/raw/sharpsl.c
index b47a9eaff89b..d8c52a016080 100644
--- a/drivers/mtd/nand/raw/sharpsl.c
+++ b/drivers/mtd/nand/raw/sharpsl.c
@@ -183,7 +183,7 @@ static int sharpsl_nand_probe(struct platform_device *pdev)
 	return 0;
 
 err_add:
-	nand_release(this);
+	nand_cleanup(this);
 
 err_scan:
 	iounmap(sharpsl->io);

