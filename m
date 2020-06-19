Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBB5200A95
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 15:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731661AbgFSNru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 09:47:50 -0400
Received: from forward5-smtp.messagingengine.com ([66.111.4.239]:48085 "EHLO
        forward5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729509AbgFSNru (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jun 2020 09:47:50 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 53038194576C;
        Fri, 19 Jun 2020 09:47:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 19 Jun 2020 09:47:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=U7uyXD
        YqZko1yJPaiac3WVzGyCJwLtKjWckbS7Wo/IU=; b=mH/U+zrsl8Bed4YZ8X5cEY
        r3lfSJDcfUAby4YWL9cgLXmseW/oPu2jhoce4RThFBrNzitzDs77DyP4Y+w56k3L
        vA7QZqQbITsNcJXtxmioiAtdMvfO3kiOxR95UmFYxEsq5P2UpOeQVLJWBVkK8cCg
        Z5d0xXSNQXZtsvc0BQOVZX7FQqn3Y2mswMYQYxsOq0dnAs+SGlugmXo2sd9y5NhA
        /pLqsaz38Isx+vRfsij+x0F8foYbuYRNpROUz7MVUpbYZ0rydEkKG+YTEwtVGVTY
        mKvdOFNSNfYyQq/pC8C31kzkcyoaDgkvAvREmUuE9q/h0HUYSaRLsASnNKwPwEpA
        ==
X-ME-Sender: <xms:BcLsXuVSjiMl-ihqTglXjp8oWb097aela-3evFtDvR2nvKBJ1bxbAA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejiedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BcLsXqklJUuy6z_RPGS7l1GqiDmJVfNICRd7VFvtHHGql5vUmtS8KQ>
    <xmx:BcLsXiY305uG8BmxWqRuftSWHA8zecgo25vjeSgQRKvVrTjAfEId6Q>
    <xmx:BcLsXlULZixBzHlRKUPblwZce3xP2C3-EdwetvAF0kRQGtmsrZuz7w>
    <xmx:BcLsXkxVPr1-rD__zcBeH_M5opL4APdMHkuVIS5Nl4_U3xfeq5M27Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9B12F3060FE7;
        Fri, 19 Jun 2020 09:47:48 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mtd: rawnand: diskonchip: Fix the probe error path" failed to apply to 4.19-stable tree
To:     miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 19 Jun 2020 15:47:46 +0200
Message-ID: <159257446611107@kroah.com>
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

From c5be12e45940f1aa1b5dfa04db5d15ad24f7c896 Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Tue, 19 May 2020 14:59:45 +0200
Subject: [PATCH] mtd: rawnand: diskonchip: Fix the probe error path

Not sure nand_cleanup() is the right function to call here but in any
case it is not nand_release(). Indeed, even a comment says that
calling nand_release() is a bit of a hack as there is no MTD device to
unregister. So switch to nand_cleanup() for now and drop this
comment.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if it did not intruce
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-13-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/raw/diskonchip.c b/drivers/mtd/nand/raw/diskonchip.c
index 97f0b05b47c1..f8ccee797645 100644
--- a/drivers/mtd/nand/raw/diskonchip.c
+++ b/drivers/mtd/nand/raw/diskonchip.c
@@ -1482,13 +1482,10 @@ static int __init doc_probe(unsigned long physadr)
 		numchips = doc2001_init(mtd);
 
 	if ((ret = nand_scan(nand, numchips)) || (ret = doc->late_init(mtd))) {
-		/* DBB note: i believe nand_release is necessary here, as
+		/* DBB note: i believe nand_cleanup is necessary here, as
 		   buffers may have been allocated in nand_base.  Check with
 		   Thomas. FIX ME! */
-		/* nand_release will call mtd_device_unregister, but we
-		   haven't yet added it.  This is handled without incident by
-		   mtd_device_unregister, as far as I can tell. */
-		nand_release(nand);
+		nand_cleanup(nand);
 		goto fail;
 	}
 

