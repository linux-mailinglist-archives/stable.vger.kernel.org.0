Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A372200AB8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgFSNv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:51:26 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:39897 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731756AbgFSNvZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:51:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 9B9D31945260;
        Fri, 19 Jun 2020 09:51:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:51:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=1QMkNQ
        ZpteGmbhNXMLwCUrTMd9i1sdiwvSjoCYbBdjQ=; b=gs6HA0OIYomfQ7r36WMOqJ
        71TwO9uHehvp4BWzRPTRn0CBRvp3uVRH69tXmWS3qZSIjqm/ZiW6w9RL6JmcwYrO
        Q5ilF9bY77SieR4gjVSTYILs15ivXWG7ODsy4mW5pjgzdSTGWh8d9Y6rc+QsyTP7
        AZDb8HwdMHLBNZEVL4foC16KlzoE2rRW9R2334TZ7tzucpCqkoEZNmEqDnny5v1V
        K8mbCPwE7Yz1ftnWoc30+6SumQC557Wc3duwa25fROHb14ukY6Bu8p2TaYSdYa1K
        +gNe32uZNI81HOdpZFoSk8WXQXp1ZuVNY/z+fEJ/JDR/K/IQ6IAFvHljp/SFikhg
        ==
X-ME-Sender: <xms:2sLsXtJ-iSIhvClUMOGVm_Qt1y80y9FOuPjnDVCO_FlKKsufHxuoIQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvdejnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:2sLsXpLHCYp4MTTdIk4SLCWBOKrXQEAOUp1-fIZcweowoTYqt8lveQ>
    <xmx:2sLsXlt9bx3JI-yworQ-ugUSy88_W_gzQ0x8zhkTLgDvf0kkNMrS_Q>
    <xmx:2sLsXuaN33F1L7UjDzGxJ7GsuRaODSx12gEUzyh1CYTlnQUGMZsfLw>
    <xmx:2sLsXtkxKCh3pcvC_ebYZRXJu6Al84EUwyXL9OG4AKn-djwPkihw6A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 093583280066;
        Fri, 19 Jun 2020 09:51:21 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: mtk: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:51:16 +0200
Message-ID: <159257467627204@kroah.com>
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
 

