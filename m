Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6BBB30321A
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:48:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbhAYOs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:48:56 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:50519 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729767AbhAYOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:48:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 78C9BF49;
        Mon, 25 Jan 2021 09:47:15 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:47:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=xUzn0Z
        9Tlsezh3jvmoQ1VFF6Wen4hVsEQWR5iDmqu8Y=; b=QCzPCryziSqrMZ8avsvcOR
        sXCF/S4jf0UXlzWZIquUqVrgmyTD8RJKmtmQMORH37DLwouEJysh9/rWTHh3roPG
        3mt0UEi/nJtMkgv29oApdRF2GKVBKpsS7wgLBviHsCwacZBsgbyvil7slcmVpB1X
        JAf67IWeNCE1/Uja/kf5oxl7RsajJj/k1DWGiitcYdnYUwQRLggTHevj/uYey4is
        HrYMVRB0XxdYjblsBfVaGTH2pF8XKpK4ETITS3cUxXXUweZKT1GVIZ+YzMGKTuxU
        nDP2ubG3xN4eVNpYPhMOslP8qBpTqxFW0yFj6rliezJmanM8QVo7V8+220A0IpoQ
        ==
X-ME-Sender: <xms:89kOYBKiWJaiYM_EDUxkNMLyOQuBUPLF3mMMAUm8cZ0CtfPxLDv2MQ>
    <xme:89kOYNJJ5_HDPlACtQFzQrb5ZeizwgtnR7uDt6lq7WE2gljxAPe7QhFyMkStLcRMg
    wNi1IKPPyWgag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:89kOYJtyxexkytnKqkgSbQoU3yCHEX85WAbHJt4ydWO5YY-nuVdhvA>
    <xmx:89kOYCZ60Iq1cn5zzNo1T-HatAYYqRpi8vjs56QKUDS5Pvk6xUn-Aw>
    <xmx:89kOYIbqzTMRg0JUIuSVbGLkbJrgm0tl0wILN6wRU89YuDNwebO6kQ>
    <xmx:89kOYBAoViXuEKCq2dXdLUz1JLWq9iFmnFkXNkB2OhS3tOHbn7mlm0wOWsw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id AEAC9240066;
        Mon, 25 Jan 2021 09:47:14 -0500 (EST)
Subject: FAILED: patch "[PATCH] mtd: spinand: Fix MTD_OPS_AUTO_OOB requests" failed to apply to 5.10-stable tree
To:     miquel.raynal@bootlin.com, nbd@nbd.name
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:47:05 +0100
Message-ID: <161158602523135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e708789c4a87989faff1131ccfdc465a1c1eddbc Mon Sep 17 00:00:00 2001
From: Miquel Raynal <miquel.raynal@bootlin.com>
Date: Thu, 7 Jan 2021 09:38:13 +0100
Subject: [PATCH] mtd: spinand: Fix MTD_OPS_AUTO_OOB requests

The initial change breaking the logic is
commit 3d1f08b032dc ("mtd: spinand: Use the external ECC engine logic")
It inadvertently dropped proper OOB support while doing something
else.

Shortly later, half of it got re-integrated by
commit 868cbe2a6dce ("mtd: spinand: Fix OOB read")
(pointing by the way to a  more early change which had nothing to do
with the issue). Problem is, this commit failed to revert the faulty
change entirely and missed the logic handling MTD_OPS_AUTO_OOB
requests.

Let's fix this mess by re-inserting the missing part now.

Fixes: 868cbe2a6dce ("mtd: spinand: Fix OOB read")
Reported-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210107083813.24283-1-miquel.raynal@bootlin.com

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 8ea545bb924d..61d932c1b718 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -343,6 +343,7 @@ static int spinand_read_from_cache_op(struct spinand_device *spinand,
 				      const struct nand_page_io_req *req)
 {
 	struct nand_device *nand = spinand_to_nand(spinand);
+	struct mtd_info *mtd = spinand_to_mtd(spinand);
 	struct spi_mem_dirmap_desc *rdesc;
 	unsigned int nbytes = 0;
 	void *buf = NULL;
@@ -382,9 +383,16 @@ static int spinand_read_from_cache_op(struct spinand_device *spinand,
 		memcpy(req->databuf.in, spinand->databuf + req->dataoffs,
 		       req->datalen);
 
-	if (req->ooblen)
-		memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
-		       req->ooblen);
+	if (req->ooblen) {
+		if (req->mode == MTD_OPS_AUTO_OOB)
+			mtd_ooblayout_get_databytes(mtd, req->oobbuf.in,
+						    spinand->oobbuf,
+						    req->ooboffs,
+						    req->ooblen);
+		else
+			memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
+			       req->ooblen);
+	}
 
 	return 0;
 }

