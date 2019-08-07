Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3920585168
	for <lists+stable@lfdr.de>; Wed,  7 Aug 2019 18:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbfHGQsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Aug 2019 12:48:16 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:38057 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388400AbfHGQsQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Aug 2019 12:48:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 783D321FE2;
        Wed,  7 Aug 2019 12:48:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Wed, 07 Aug 2019 12:48:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=lp0jKc
        fsDWxNkDPpnAKpORXzDIis+MnjSY7KEN95nQc=; b=wlFDJrWRyNuH9f6J04sIyt
        /v+a3924dy8RCACICJfWpynyQhXjeVfgK/xA5+ls/rUDn6AwNGkitTgmHX39GYxF
        JSoQJ3P+H809MqasHQVurbHjoZCl1GKP9gQjzAKrz4lkkuHOIV3KSQ1U7tXJG5U1
        +L80Pyd4aoZOPgzjzCYGWlieeSUxg2wMyZBAx6g3yH3R7RZsJTXo6SKhMZPTuAu7
        iH/1w2SuZLt48toj54+6LjUsrydq7c0tNHCvfVH87PtT6HcgBCnhVCB9t9ZTWPzO
        dJIr8IKJcdxViR921KRvNSGUA9FKzAJTJ5YN4la5huwHMmV7+G5lbbqLVGF0q8lQ
        ==
X-ME-Sender: <xms:zwBLXeoLIOMX8ReCHI32CnJH-hrwZBvkmmQ0saOsZyzlUXY6PJNj0w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudduvddguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekle
    druddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
    necuvehluhhsthgvrhfuihiivgepud
X-ME-Proxy: <xmx:zwBLXSOuxBpyC184Vvn6rxDq-8ZaBdc4KmbRfQ4U9gR8um2dKib_rw>
    <xmx:zwBLXcwexxARJQOnWNea8-daBMej0ujhls5CcLrGttQtzThtxppEQg>
    <xmx:zwBLXeyiCTawwDgmShKqolhBACu2kSfT7AmnIHR-KiyXA8N7K2jCgw>
    <xmx:zwBLXQ9yoMsVX4LyTenSWV3mX7e13d-IZZB0KBHDbnjeQVJ2IdxwOw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E39E2380075;
        Wed,  7 Aug 2019 12:48:14 -0400 (EDT)
Subject: FAILED: patch "[PATCH] spi: bcm2835: Fix 3-wire mode if DMA is enabled" failed to apply to 4.9-stable tree
To:     lukas@wunner.de, broonie@kernel.org, kernel@martin.sperl.org,
        nuno.sa@analog.com, wahrenst@gmx.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 07 Aug 2019 18:48:10 +0200
Message-ID: <156519649068107@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

