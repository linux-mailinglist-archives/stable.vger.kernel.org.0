Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 488D0200AB2
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732979AbgFSNue (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:34 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:60917 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732879AbgFSNuc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B7D5419457B0;
        Fri, 19 Jun 2020 09:50:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=iJVqJN
        3wYMovpCcVTbX7GjVK2Cs6kRzqlthtu15Tkao=; b=qltWSryRTNGuaWvhm7+vHo
        KqqgfoF63BpL7MFVCgUo9fIq+LFP0UeuM8EgtQiIMpVIXrQLLaPB06QpjdPbgQpd
        CsBwrGd84J9bZsN5LKMC/WMktWL2OplIpC8J3wyRlwHSsqsmAbCy3RPCoPDNcy4Z
        BRZ/8nnvM7dk9QPL3CfH6qCvOm2Z1Jn+0CpyfOVGJAdQugF+NPPWtCwrz1CHlEvn
        6WV68HkH1kF3gASyVedOppqxA25EcCLggBzz41NsoDNt1MWQ4ZeUnl8GkNqN77kA
        12mrslq22Ba+Iub11pB5D0nSE09CE1B2vwtmFw0wCSzyCbstxTvelc0vLbMcYnPg
        ==
X-ME-Sender: <xms:p8LsXhguEEiBDP7S9e_LEr0tZiGD9iLdSRpmv8yClx2DjfC896wbuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepvddvnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:p8LsXmBMY86bikbelQr6m18EblEbWEbX_M0A2sOQY9l5B-3gYwZsag>
    <xmx:p8LsXhEdxrYdzgfvIXmrPhmgKmxo09p4toifyjTV6dtkuBgjc7SJhQ>
    <xmx:p8LsXmQSB59yd9mrSqZCt8YoPjaLdVgnbOa9qm4AguXl3hLvjqi_xg>
    <xmx:p8LsXt9Df3QofBryh7seOrKtl9ihZD5pqKZtd-UnDR33d0aLplt-XQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5581D3061856;
        Fri, 19 Jun 2020 09:50:31 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: socrates: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:50:20 +0200
Message-ID: <1592574620172161@kroah.com>
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

From 9c6c2e5cc77119ce0dacb4f9feedb73ce0354421 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 15:00:23 +0200
Subject: [PATCH] mtd: rawnand: socrates: Fix the probe error path

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
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-51-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/socrates_nand.c b/drivers/mtd/nand/raw/socrates_nand.c
index 20f40c0e812c..7c94fc51a611 100644
--- a/drivers/mtd/nand/raw/socrates_nand.c
+++ b/drivers/mtd/nand/raw/socrates_nand.c
@@ -169,7 +169,7 @@ static int socrates_nand_probe(struct platform_device *ofdev)
 	if (!res)
 		return res;
 
-	nand_release(nand_chip);
+	nand_cleanup(nand_chip);
 
 out:
 	iounmap(host->io_base);

