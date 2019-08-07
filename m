Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B475A85169
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388681AbfHGQsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 12:48:19 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:46275 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388400AbfHGQsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 12:48:19 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 52C6921FE5;
        Wed,  7 Aug 2019 12:48:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 07 Aug 2019 12:48:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hJR74T
        TBL+8bteVWb7tvBnTkfpaKfpdSGDQJhEdRzXE=; b=Tgfswdx8qJ8w/4zR+Fq/Yn
        +wpf9EfRlqRGEBgS1S8wgDLUCbXnMyUszZHPdq3fiKZohVZkkUDgqKxZb+8O9fjH
        1DpUqzBSkNMWGjkS04ze+eeBL7eDvH3yAUa8i1CxevqZlQ+kv0CIXHcEHizTyair
        6lNnMe+nh8kViPHy5EOWHnnILWI3hiF96xO5m0QzTDznt6GLLiznaIhQRkZk2HXz
        Ar/Wg9mBBKWxuXtcohmfq/iD7fzmcToUIsrhTQQriBnjYqQgpjO4TV4zHPIhhEvh
        ZqUylHujgVK2JB1sIYtfb9XAZk06nvmPvusS3tO69M6Dj2bT+ez8xxtUaG4f00Hw
        ==
X-ME-Sender: <xms:0gBLXSV3cFH_S11LNvg1O-yaRgr0EeeRgyu0iSQTscm1nqZB1EMJGg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepge
X-ME-Proxy: <xmx:0gBLXb_QJwBpTBNLW8fYmQxx5k0NFCT0asX6Sk0L9dE_O7NAcoMLRw>
    <xmx:0gBLXdvylcEAWTnawE60q9HRgiS3QV4zVzC4oaPa5sKY5b5NcZgQYA>
    <xmx:0gBLXT2SrYSx-K1IF3p28u9v0l5yz5Jjf4sEoGGl-HXRCbTJa8k3rg>
    <xmx:0gBLXUqGsIsS-yq7C7j3MclrErXr0Sjm2lWm9f2IdN11HshV51kVEg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B3B61380085;
        Wed,  7 Aug 2019 12:48:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is enabled" failed to apply to 4.4-stable tree
To:     lukas@wunner.de, broonie@kernel.org, kernel@martin.sperl.org,
        nuno.sa@analog.com, wahrenst@gmx.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Aug 2019 18:48:10 +0200
Message-ID: <15651964906685@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8d8bef50365847134b51c1ec46786bc2873e4e47 Mon Sep 17 00:00:00 2001
From: Lukas Wunner <lukas@wunner.de>
Date: Wed, 3 Jul 2019 12:29:31 +0200
Subject: [PATCH] spi: bcm2835: Fix 3-wire mode if DMA is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Commit 6935224da248 ("spi: bcm2835: enable support of 3-wire mode")
added 3-wire support to the BCM2835 SPI driver by setting the REN bit
(Read Enable) in the CS register when receiving data.  The REN bit puts
the transmitter in high-impedance state.  The driver recognizes that
data is to be received by checking whether the rx_buf of a transfer is
non-NULL.

Commit 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers
meeting certain conditions") subsequently broke 3-wire support because
it set the SPI_MASTER_MUST_RX flag which causes spi_map_msg() to replace
rx_buf with a dummy buffer if it is NULL.  As a result, rx_buf is
*always* non-NULL if DMA is enabled.

Reinstate 3-wire support by not only checking whether rx_buf is non-NULL,
but also checking that it is not the dummy buffer.

Fixes: 3ecd37edaa2a ("spi: bcm2835: enable dma modes for transfers meeting certain conditions")
Reported-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: stable@vger.kernel.org # v4.2+
Cc: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/328318841455e505370ef8ecad97b646c033dc8a.1562148527.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>

diff --git a/drivers/spi/spi-bcm2835.c b/drivers/spi/spi-bcm2835.c
index 6f243a90c844..840b1b8ff3dc 100644
--- a/drivers/spi/spi-bcm2835.c
+++ b/drivers/spi/spi-bcm2835.c
@@ -834,7 +834,8 @@ static int bcm2835_spi_transfer_one(struct spi_controller *ctlr,
 	bcm2835_wr(bs, BCM2835_SPI_CLK, cdiv);
 
 	/* handle all the 3-wire mode */
-	if ((spi->mode & SPI_3WIRE) && (tfr->rx_buf))
+	if (spi->mode & SPI_3WIRE && tfr->rx_buf &&
+	    tfr->rx_buf != ctlr->dummy_rx)
 		cs |= BCM2835_SPI_CS_REN;
 	else
 		cs &= ~BCM2835_SPI_CS_REN;

