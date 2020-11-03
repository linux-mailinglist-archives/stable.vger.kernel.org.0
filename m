Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47DA72A47F4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 15:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729330AbgKCOW3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 09:22:29 -0500
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59317 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729263AbgKCOW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 09:22:29 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 1DA4919425D9;
        Tue,  3 Nov 2020 09:22:28 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 03 Nov 2020 09:22:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=H3ojhG
        el9HpFZI1GVP4kU/uXkyfh+x52fDCm950OnSg=; b=YUiNs+r6c2whlpPS999WLc
        HPcZWt09r69LvMgBJqeVJN1sC80LnZgxZw6gkNMJU/VTMoWvnZbl8TFp91ZSmIOv
        U/KTIDnl3feqXfEnIev52Cw32JFAgyjPb6jxsSuIP+RcZxMwwPxPqrDnks0yJDmx
        7/1W4f6S4b4yKjCshc9qCb2SsPJsj5dlgs8Cpf+Zj8LcGomtIIz1XuNLS9zSULor
        uPvBda/StnENZ8q1EKA1l7onGMzbGEU1gxsQJ5buorfQ9mlhN4WhMdGIEk+js+hx
        8lDav4YvK9ovI1qZysmVqHDmj0ESPLfW+UcxjqAgFvrsEKs5zTVQ2llGSSU0FSmw
        ==
X-ME-Sender: <xms:o2ehXydyxSvJx0LBl90QCsz_u5Jgj-irn20GaQtI77TQIMZ_6N5K4w>
    <xme:o2ehX8PAil2FKtqiPXDTHLTbCUUxKxYYmleZDub_tbR07f1pORlxlfM4BJjMcoNZV
    X7ndlu1egSt8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtfedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucgfrhhlucfvnfffucdluddtmdenucfjughrpefuvf
    fhfffkgggtgfesthekredttddtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihf
    ohhunhgurghtihhonhdrohhrgheqnecuggftrfgrthhtvghrnhepkeejgffftefgveegge
    ehudfgleehkedthedtiefhieelieetveejvdfgvdeljeelnecuffhomhgrihhnpehkvghr
    nhgvlhdrohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:o2ehXzidZ0LJMfkE0UHRj8ujxfkN2nJcwAHxLl0vG3UPxBa_40hE9g>
    <xmx:o2ehX_-s4SHi_JNRVaGmI57QsxCBW9I4tc5ZdfN1IgPXj0RfNKPrMQ>
    <xmx:o2ehX-uG2weIhvASlEoTPl8oZCO6eGaMIu8xmwWN3AnmpdUqwsV2Rw>
    <xmx:pGehX35m2o2J6zKTe3b0IqsVyP4seto4lzLpkw4w15DpKOeN9UbJeg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 326DA3280059;
        Tue,  3 Nov 2020 09:22:27 -0500 (EST)
Subject: FAILED: patch "[PATCH] tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words," failed to apply to 5.4-stable tree
To:     vladimir.oltean@nxp.com, fugang.duan@nxp.com,
        gregkh@linuxfoundation.org, michael@walle.cc,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Nov 2020 15:23:20 +0100
Message-ID: <160441340011200@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From c97f2a6fb3dfbfbbc88edc8ea62ef2b944e18849 Mon Sep 17 00:00:00 2001
From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Fri, 23 Oct 2020 04:34:29 +0300
Subject: [PATCH] tty: serial: fsl_lpuart: LS1021A has a FIFO size of 16 words,
 like LS1028A
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Prior to the commit that this one fixes, the FIFO size was derived from
the read-only register LPUARTx_FIFO[TXFIFOSIZE] using the following
formula:

TX FIFO size = 2 ^ (LPUARTx_FIFO[TXFIFOSIZE] - 1)

The documentation for LS1021A is a mess. Under chapter 26.1.3 LS1021A
LPUART module special consideration, it mentions TXFIFO_SZ and RXFIFO_SZ
being equal to 4, and in the register description for LPUARTx_FIFO, it
shows the out-of-reset value of TXFIFOSIZE and RXFIFOSIZE fields as "011",
even though these registers read as "101" in reality.

And when LPUART on LS1021A was working, the "101" value did correspond
to "16 datawords", by applying the formula above, even though the
documentation is wrong again (!!!!) and says that "101" means 64 datawords
(hint: it doesn't).

So the "new" formula created by commit f77ebb241ce0 has all the premises
of being wrong for LS1021A, because it relied only on false data and no
actual experimentation.

Interestingly, in commit c2f448cff22a ("tty: serial: fsl_lpuart: add
LS1028A support"), Michael Walle applied a workaround to this by manually
setting the FIFO widths for LS1028A. It looks like the same values are
used by LS1021A as well, in fact.

When the driver thinks that it has a deeper FIFO than it really has,
getty (user space) output gets truncated.

Many thanks to Michael for pointing out where to look.

Fixes: f77ebb241ce0 ("tty: serial: fsl_lpuart: correct the FIFO depth size")
Suggested-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20201023013429.3551026-1-vladimir.oltean@nxp.com
Reviewed-by：Fugang Duan <fugang.duan@nxp.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index ff4b88c637d0..bd047e1f9bea 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -314,9 +314,10 @@ MODULE_DEVICE_TABLE(of, lpuart_dt_ids);
 /* Forward declare this for the dma callbacks*/
 static void lpuart_dma_tx_complete(void *arg);
 
-static inline bool is_ls1028a_lpuart(struct lpuart_port *sport)
+static inline bool is_layerscape_lpuart(struct lpuart_port *sport)
 {
-	return sport->devtype == LS1028A_LPUART;
+	return (sport->devtype == LS1021A_LPUART ||
+		sport->devtype == LS1028A_LPUART);
 }
 
 static inline bool is_imx8qxp_lpuart(struct lpuart_port *sport)
@@ -1701,11 +1702,11 @@ static int lpuart32_startup(struct uart_port *port)
 					    UARTFIFO_FIFOSIZE_MASK);
 
 	/*
-	 * The LS1028A has a fixed length of 16 words. Although it supports the
-	 * RX/TXSIZE fields their encoding is different. Eg the reference manual
-	 * states 0b101 is 16 words.
+	 * The LS1021A and LS1028A have a fixed FIFO depth of 16 words.
+	 * Although they support the RX/TXSIZE fields, their encoding is
+	 * different. Eg the reference manual states 0b101 is 16 words.
 	 */
-	if (is_ls1028a_lpuart(sport)) {
+	if (is_layerscape_lpuart(sport)) {
 		sport->rxfifo_size = 16;
 		sport->txfifo_size = 16;
 		sport->port.fifosize = sport->txfifo_size;

