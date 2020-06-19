Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 049C8200AA8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:50:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732954AbgFSNuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:50:01 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:36149 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732885AbgFSNuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:50:01 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 05C2A1945783;
        Fri, 19 Jun 2020 09:50:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:50:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=j4UDVv
        qs9WQszHF6p7xcqlp0l3cn2cn71gJd6dTc38s=; b=Hv8tISV/FKLD+MYUN7MV5P
        SsIGIeMIiDKJOAViO3JA1vga4GopaQmULrP+NHZ5ie5B8QdhNktnJ6JfvtAzDDuE
        jbmEKVa7T4nalOxFllsDT3d93lZfYPA3yUqbBdCqLMQif53K2PQMsMjTeN+gRMSg
        ClbAFgj2YjVtcMJD0t/crhOsjaSYZaYCn2aDjobaJxtd27q93Fw5BqY8vz+9a8uH
        eRuQp0VlYUJg50FnsFvPpMYu5a+5nLhiESfbd7Iu43+HKnCUi9ZD7TP5wJBrOnw/
        NxuVLWvPFR/LKf7QutkR4IiRxa+EPNc51NPX8m4v2Z8U8qRAIwoXgCoklz1Aj7Xg
        ==
X-ME-Sender: <xms:h8LsXsMxH1gxTYd24KmuXZdzG0Jvdi9Yq-WsDrt789J_Gz_9ex5uBg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudeinecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:h8LsXi9-t83HSMJ34IcOJZF0wNrrbZJXqnGA_xgY26TccI7suE4NFA>
    <xmx:h8LsXjRMM39VBpsWEss48lNzc8kuKJJVsyhe4kgn9VkPeNnK39AOuQ>
    <xmx:h8LsXkuWIdwT3yoi95QB2Ca8cz6eOAhEXzYh6Al_HaATYxUh-wlluQ>
    <xmx:iMLsXurxbJYhj5ZDgn29hoNBexJfl6UjpiIs6Zab12iKHyyyQAYPUQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7A7723280060;
        Fri, 19 Jun 2020 09:49:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: oxnas: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:49:49 +0200
Message-ID: <1592574589185107@kroah.com>
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

