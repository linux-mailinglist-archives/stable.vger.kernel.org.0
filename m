Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97531200AA4
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFSNtZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:49:25 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:40229 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732901AbgFSNtZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:49:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1780A1945783;
        Fri, 19 Jun 2020 09:49:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:49:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=pNQ4Hx
        mW28dCdQGNjGagGIiDVwyUyytUo8zv7UEYnUg=; b=VIgPqclTFetsq7i9sd+Ki7
        wvmPQz+Sxzih1TOT3NGnwrOKP9gSY+xwvLL1g/FKsm48O0aTGS9fzTu8XvNb0VVa
        Pnv8Aa9YkrRBfnhMWxKbcg06p2vtOJp+RwjbZ+tkumUhadqfRDBbCvLStS4BdVqq
        T3c4pI+YDJs2aGSSeoo6SxsLVPctuJTDUM8k3xuW4ahvNaFgfv1kzMZ5Cxu/VfLy
        cLPrGLDKuRY4D9d2eX+vbVA1HRVg0g1+q9FfNRU7zqo59ZL1gaB5+s2RuvZdPypz
        f74XSg5Uxf2Ck9eURfCux6bnWvrVMZPvUWQ/CWfpOHfuIakwBDKyvLvAczAXsuyg
        ==
X-ME-Sender: <xms:ZMLsXmxz5vKguuA3o19ryYiyitHH5oIAcVzTwEzSe_TlhuTwbqwrKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudegnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ZMLsXiRJWM9NbwcW46JUdf2Lpud8w8WRrWkF3T1Ii4S9VP0NxsZ5Iw>
    <xmx:ZMLsXoXU3TY40qgojcWM7nFj4AXNUmaPSIIIA0AHMYAItwMpHEUuAg>
    <xmx:ZMLsXshm4i4pbEa4sR51I0SKHjZ2Uyt2eimYYTdiFEZeKHXTGdFe7w>
    <xmx:ZMLsXrNfUcCfggvCWgWaKob2WT1sbLlMmCWW4HINkw5mLzmFWmtyYg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id A583130618C1;
        Fri, 19 Jun 2020 09:49:23 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: orion: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:49:13 +0200
Message-ID: <159257455316814@kroah.com>
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

From be238fbf78e4c7c586dac235ab967d3e565a4d1a Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:06 +0200
Subject: [PATCH] mtd: rawnand: orion: Fix the probe error path

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
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-34-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/orion_nand.c b/drivers/mtd/nand/raw/orion_nand.c
index d27b39a7223c..a3dcdf25f5f2 100644
--- a/drivers/mtd/nand/raw/orion_nand.c
+++ b/drivers/mtd/nand/raw/orion_nand.c
@@ -180,7 +180,7 @@ static int __init orion_nand_probe(struct platform_device *pdev)
 	mtd->name = "orion_nand";
 	ret = mtd_device_register(mtd, board->parts, board->nr_parts);
 	if (ret) {
-		nand_release(nc);
+		nand_cleanup(nc);
 		goto no_dev;
 	}
 

