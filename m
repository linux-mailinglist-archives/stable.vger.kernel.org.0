Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291DD132275
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 10:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgAGJdb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 04:33:31 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:32851 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726485AbgAGJdb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 04:33:31 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 6487220E72;
        Tue,  7 Jan 2020 04:33:30 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 07 Jan 2020 04:33:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=2G7ABh
        0oKOeANbUW0BoSs8vrKrhP12scIr8BCCVGyUE=; b=EoqSvX9Ht7UF8mF/pNLHpk
        g6GhGWZsyDDRqejt3vKSWAVtwVPj9ik0kl//ewFdqyQnEE/0HBfsBVW+1Hf69r3h
        MomZElBGhvIb0VVckEnVJ5yYQOh4h/u2zGdqHUEqEav8eXw+bptKSmJiMVITcAVH
        swaLzVL8mA55gKqHBGqpfgiZ9dLRC+dyz6ftz+JmD35NmqhLNUMNYdKMzIf2KLhL
        HIpesnXu6jO4cK6WLK0zaxbHnQQu34N6h2/wWAfFks7VZeGUapbcpO/p3ILYSVTn
        skKMToDD0KCa6ngFaimyJjEE7PWj2IpI+mauRU4FyHNcGWah8TPVzsRNg6kBHNQA
        ==
X-ME-Sender: <xms:alAUXoDyq1xdAokNJHX1de6It4u8XZwYtg2d5GSGPk9ZeS-0tQSy0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvdehvddgtdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehlkhhmlhdrohhrghdpkhgvrhhnvghlrdhorhhgnecukfhppe
    ekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehk
    rhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:alAUXje-22h7Z6uhrBs8Fep4rx7fWuizpZMB50-qsrNrkNyxp8NKsA>
    <xmx:alAUXthSwbxR5oToqlCxatWTKJJgUz_E71xEYcq3pltlFWw3boXjgQ>
    <xmx:alAUXroIc5me9iK5tP1PDJg-8j7c5l97apP7fxcy5ucvQhtAhxiHFA>
    <xmx:alAUXpwBNB-UudyFHCcTw0LgvHAupqnNZuqOcBEYhZSx2JaI0emhLw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id D22C530607B0;
        Tue,  7 Jan 2020 04:33:29 -0500 (EST)
Subject: FAILED: patch "[PATCH] spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode" failed to apply to 4.19-stable tree
To:     olteanv@gmail.com, broonie@kernel.org, chuanhua.han@nxp.com,
        eha@deif.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jan 2020 10:33:27 +0100
Message-ID: <157838960715911@kroah.com>
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

From ca59d5a51690d5b9340343dc36792a252e9414ae Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <olteanv@gmail.com>
Date: Sat, 28 Dec 2019 15:55:36 +0200
Subject: [PATCH] spi: spi-fsl-dspi: Fix 16-bit word order in 32-bit XSPI mode

When used in Extended SPI mode on LS1021A, the DSPI controller wants to
have the least significant 16-bit word written first to the TX FIFO.

In fact, the LS1021A reference manual says:

33.5.2.4.2 Draining the TX FIFO

When Extended SPI Mode (DSPIx_MCR[XSPI]) is enabled, if the frame size
of SPI Data to be transmitted is more than 16 bits, then it causes two
Data entries to be popped from TX FIFO simultaneously which are
transferred to the shift register. The first of the two popped entries
forms the 16 least significant bits of the SPI frame to be transmitted.

So given the following TX buffer:

 +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
 | 0x0 | 0x1 | 0x2 | 0x3 | 0x4 | 0x5 | 0x6 | 0x7 | 0x8 | 0x9 | 0xa | 0xb |
 +-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
 |     32-bit word 1     |     32-bit word 2     |     32-bit word 3     |
 +-----------------------+-----------------------+-----------------------+

The correct way that a little-endian system should transmit it on the
wire when bits_per_word is 32 is:

0x03020100
0x07060504
0x0b0a0908

But it is actually transmitted as following, as seen with a scope:

0x01000302
0x05040706
0x09080b0a

It appears that this patch has been submitted at least once before:
https://lkml.org/lkml/2018/9/21/286
but in that case Chuanhua Han did not manage to explain the problem
clearly enough and the patch did not get merged, leaving XSPI mode
broken.

Fixes: 8fcd151d2619 ("spi: spi-fsl-dspi: XSPI FIFO handling (in TCFQ mode)")
Cc: Esben Haabendal <eha@deif.com>
Cc: Chuanhua Han <chuanhua.han@nxp.com>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20191228135536.14284-1-olteanv@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org

diff --git a/drivers/spi/spi-fsl-dspi.c b/drivers/spi/spi-fsl-dspi.c
index 9c3934efe2b1..8428b69c858b 100644
--- a/drivers/spi/spi-fsl-dspi.c
+++ b/drivers/spi/spi-fsl-dspi.c
@@ -587,21 +587,14 @@ static void dspi_tcfq_write(struct fsl_dspi *dspi)
 	dspi->tx_cmd |= SPI_PUSHR_CMD_CTCNT;
 
 	if (dspi->devtype_data->xspi_mode && dspi->bits_per_word > 16) {
-		/* Write two TX FIFO entries first, and then the corresponding
-		 * CMD FIFO entry.
+		/* Write the CMD FIFO entry first, and then the two
+		 * corresponding TX FIFO entries.
 		 */
 		u32 data = dspi_pop_tx(dspi);
 
-		if (dspi->cur_chip->ctar_val & SPI_CTAR_LSBFE) {
-			/* LSB */
-			tx_fifo_write(dspi, data & 0xFFFF);
-			tx_fifo_write(dspi, data >> 16);
-		} else {
-			/* MSB */
-			tx_fifo_write(dspi, data >> 16);
-			tx_fifo_write(dspi, data & 0xFFFF);
-		}
 		cmd_fifo_write(dspi);
+		tx_fifo_write(dspi, data & 0xFFFF);
+		tx_fifo_write(dspi, data >> 16);
 	} else {
 		/* Write one entry to both TX FIFO and CMD FIFO
 		 * simultaneously.

