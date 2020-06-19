Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D176200ABA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731806AbgFSNvd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:51:33 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:50149 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731794AbgFSNvd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:51:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 4CBC41945397;
        Fri, 19 Jun 2020 09:51:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:51:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YOdajJ
        +im74s/hna4pWaXO4rF6QDfNP46V1HhjWWd1U=; b=Lc2vSeJEnMKAdVAwCw/5iC
        xPDQ2o8p7s2KFt/gUv4Sw+LSWbrLSYnT+vc+VS5QrKYS9m/3thlLreFqOHnF/jKI
        iBQuYqxAJWyQRsKFt3MKOgJ6fPK9bQPPIbLZHWEQSrKasbPTBXEZUhb+EkCOlwVh
        IuwWYYtWSeWqMOOBtoSm0gQlEzYSPHiY4DVT07A+yt5/L6n1ukFoLlg2lFB12fbo
        8jhrcK65060m5WMqpLHLQN+pejK0aBjBBlBfmucRe0bEvxsJdbDu+d7QbLyqcq3s
        NrjVaRqKf978bLwxYF7105uup+t79Cx/jkqrZrdQvIqkjHXxG7gF0cdiG1Tupbpg
        ==
X-ME-Sender: <xms:4cLsXssp0P3t-e7CW5SQB4sWS4rDWX7_UZrW-o1Ij6GGZfczsXe1KQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdeknecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:4cLsXpdJSPCr5qKR79znQVYNb1Wtb_RBS2-q7ERZoRfYFooXHvUM9w>
    <xmx:4cLsXnxXeQEqzTMI5D_CNxFoOe7nnFKDgTzK6zNmdNfhbRZRAHuvQQ>
    <xmx:4cLsXvMTdxhXYs0k25ZXwVfegIQTIDxUKzvLlqnGiB3EtdZqGWFYjg>
    <xmx:4cLsXvLica15d-l_cA5UuDjhP5k4gOsrX4CfwvrKbhYShA4WnyLr2Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C29243280063;
        Fri, 19 Jun 2020 09:51:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: mtk: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:51:18 +0200
Message-ID: <159257467827188@kroah.com>
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

From 8a82bbcadec877f5f938c54026278dfc1f05a332 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:00 +0200
Subject: [PATCH] mtd: rawnand: mtk: Fix the probe error path

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-28-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/mtk_nand.c b/drivers/mtd/nand/raw/mtk_nand.c
index e7ec30e784fd..9dad08bed2bb 100644
--- a/drivers/mtd/nand/raw/mtk_nand.c
+++ b/drivers/mtd/nand/raw/mtk_nand.c
@@ -1419,7 +1419,7 @@ static int mtk_nfc_nand_chip_init(struct device *dev, struct mtk_nfc *nfc,
 	ret = mtd_device_register(mtd, NULL, 0);
 	if (ret) {
 		dev_err(dev, "mtd parse partition error\n");
-		nand_release(nand);
+		nand_cleanup(nand);
 		return ret;
 	}
 

