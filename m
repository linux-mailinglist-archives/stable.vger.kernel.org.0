Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4638200A9A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732235AbgFSNsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:48:19 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:34825 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729134AbgFSNsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:48:19 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 81404194575F;
        Fri, 19 Jun 2020 09:48:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=Ldzz+0
        mLB/9hPJYOftB7x8KD6uO6rPiJ2NciPZo+8pc=; b=lvqmalNPjxtbPYu0imIvA8
        mrNtALqY9ihkMLlatRaa1RYNlibE996AB3Pek68Du9hYiM0YywbiTefE8Wf8HvkF
        h5IdWblwC3yLA3G6lXtdpUfj+qhMcSquoTSm7CKT/p0WSIajTNFj2JQe18inhK5q
        +Yymi2ZUljOwV5yDDOEmNSFct3cHqY+yGhudnx0NrM7zTHn73wFV9QgfgjKRWslq
        gbgOFfF64/4JL+TpcT+F4QgmgPh2xLhCEak+WTL8pyH1b8ZBsFjMNIPbOCmbFl54
        zIYG6SczQG5nIpG5RSPk0Q7b27+WoMAtjKLnNKKzAn9ypWEJbHt6YBFfHIjvujkw
        ==
X-ME-Sender: <xms:IsLsXvFJOZ_QHmPa0wT-GJwpWtZRMkCgNrixaesnNj2u7xQpOGT7mw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:IsLsXsUd9bNohCXZYKqLjdxFkdLOJOYSUqu0nyr6iyt51IJMuDTQEQ>
    <xmx:IsLsXhIDGRfK5iQFen6BzQDWnkRlthed5HN6uPmHzAP-LCDgKDrmWQ>
    <xmx:IsLsXtHm4wM1mtMfuql_fcMRuPf_W-lbZSAmFWOseBry8-Pip5qQkg>
    <xmx:IsLsXtihdAYusur3eBpb--ZN2JaArLfYQFW4WdB9d2INp4E-2rxEcg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 06FA33060FE7;
        Fri, 19 Jun 2020 09:48:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: sharpsl: Fix the probe error path" failed to apply to 4.9-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:48:06 +0200
Message-ID: <15925744865023@kroah.com>
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

