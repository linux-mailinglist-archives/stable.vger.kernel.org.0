Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E430030321B
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729788AbhAYOsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 09:48:47 -0500
Received: from wforward4-smtp.messagingengine.com ([64.147.123.34]:41429 "EHLO
        wforward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729764AbhAYOsJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 09:48:09 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 799CEEAD;
        Mon, 25 Jan 2021 09:47:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 25 Jan 2021 09:47:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=A4iuBu
        vJTIgz/t2JKzGUAS54wPF/7U07dtwaBz+fCOM=; b=KCxi1BMYAR+iXSQHiqZ3vk
        PKtLC5DQkVU3bunOqLQa3CqhKUsZflm26hnroX2kjgEMWnAbzInqqvGn6CJNP49b
        EukuZauSHFq55vz8Mdkp8ZCiQgopUcmK4QK4nUkQibAGo2gB3pYZVJwA70uxZqAf
        DP1dwn5EaMp2GgZqZmQj6iaMNRcHCD+CdyGnkCk0aERj/FVzfTlx9fmNMzPEYvSe
        jMbrJh7zlbTc6dRzTwZBASu/qWwySedvqgGisF72HExTfG/uBU+2+TkyPepwWxkw
        EjGJcwACYKrdO1J7+ORCCCUxauM2rPuP0EwsDdb9Hly0zJOYLnarY82UCARPK4nw
        ==
X-ME-Sender: <xms:6tkOYPJajjR94COwxAldYfAQYYFcmk_FdhaIEdP0oHkDz2anGMESzw>
    <xme:6tkOYBFto09zx2iFfml3Mgis157vpqBcRNtgLMX-vs7Fd9DTs8ld5W3o-0ZCofr_M
    YhfHS1G7O04uw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:6tkOYKD3r_02m8gLp3FaDGm1RTiiXTH4JGysmf0svI_R1_rAax7w_Q>
    <xmx:6tkOYM-JqWwGUHpq0AfgUvfQdRoYOeSiqtFn_NDFTAa8K2R6IInuFg>
    <xmx:6tkOYOAWwQbEV1pS_159BX8lXv-GhbVIWsroDcERhpEFpyaCsKJQAg>
    <xmx:69kOYA0mjfOqyxbt8b5b1oIsTc663YBf4vTx0Ae0Qesyzw3ycJPXjRsNisA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 19141108005F;
        Mon, 25 Jan 2021 09:47:06 -0500 (EST)
Subject: FAILED: patch "[PATCH] mtd: spinand: Fix MTD_OPS_AUTO_OOB requests" failed to apply to 5.4-stable tree
To:     miquel.raynal@bootlin.com, nbd@nbd.name
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 25 Jan 2021 15:47:04 +0100
Message-ID: <1611586024229193@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
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

