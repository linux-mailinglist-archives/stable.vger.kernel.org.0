Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF0D337C5F
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:22:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbhCKSWK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:22:10 -0500
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:40713 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229483AbhCKSUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:20:45 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 105901941930;
        Thu, 11 Mar 2021 13:20:45 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:20:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Tr/i9F
        OX74cVoV5gemcyG70Q8R987UffrM7rYj7joDQ=; b=Q1pwAnkV9kZ0ZwtT5pE686
        aUeXoXHSfROoh4NXu/H8lS6QaF6M0nnRwSEfZwOCopH7OD9X0Ph/jBvyIh2h/Vib
        CcE3qiSnEpws9W/ErxG0uZi4xh00jTCNIm5fsSaR3nGPSAVKQjNfWfag4kIgteOm
        jrsgzfmcSdYzDhkXtBYcrCGd51POIxXErrsy3w/nUpOQClK5+6hr750rgSNAzn7x
        FkWnWFYm+tripRCUo86ueq7wqn+bYXy3t/YGMXAhjQljya53OwHS4Ej9EndmIOFR
        pwhMj+yIrso1l3YUc3GiTOcy9vSulk1L71Ajg8KPG5VthDpqOCMj8WXO9mC3aUqA
        ==
X-ME-Sender: <xms:fF9KYM1G9YUdJIC-4oPaIlH8nbFplnh6sYLEftnnBxGPqGZ01YNPVw>
    <xme:fF9KYHFv_bmlZ5kFAoLjpvN06y0G1xUHhlfxdKvKk8Fdlq9nuIvjaxJiruzdJtque
    kzRxu6jf0RP4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:fF9KYE5RlJRJ3K0qCCAqh036mhLP1ycBlvjOvHOo2dr7vN6TtegPyQ>
    <xmx:fF9KYF0e_mC71smXU4f-hjNCl7zdmZrC25L9ub_MZe_dZ-Z35YlJ5g>
    <xmx:fF9KYPE_ensZ9aAcSxC87HSYrD5P0J4EUteTkK5BevdPJcFziJZMSA>
    <xmx:fV9KYCMKMaDooPvNgNgcitMB3K86w7EBMDKYOZo6fYorXu8DjB-sNA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id BACB8240057;
        Thu, 11 Mar 2021 13:20:43 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: invoke flexcan_chip_freeze() to enter freeze" failed to apply to 4.4-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:20:31 +0100
Message-ID: <161548683116553@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From c63820045e2000f05657467a08715c18c9f490d9 Mon Sep 17 00:00:00 2001
From: Joakim Zhang <qiangqing.zhang@nxp.com>
Date: Thu, 18 Feb 2021 19:00:37 +0800
Subject: [PATCH] can: flexcan: invoke flexcan_chip_freeze() to enter freeze
 mode

Invoke flexcan_chip_freeze() to enter freeze mode, since need poll
freeze mode acknowledge.

Fixes: e955cead03117 ("CAN: Add Flexcan CAN controller driver")
Link: https://lore.kernel.org/r/20210218110037.16591-4-qiangqing.zhang@nxp.com
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index e66a51dbea0a..134c05757a3b 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1480,10 +1480,13 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	flexcan_set_bittiming(dev);
 
+	/* set freeze, halt */
+	err = flexcan_chip_freeze(priv);
+	if (err)
+		goto out_chip_disable;
+
 	/* MCR
 	 *
-	 * enable freeze
-	 * halt now
 	 * only supervisor access
 	 * enable warning int
 	 * enable individual RX masking
@@ -1492,9 +1495,8 @@ static int flexcan_chip_start(struct net_device *dev)
 	 */
 	reg_mcr = priv->read(&regs->mcr);
 	reg_mcr &= ~FLEXCAN_MCR_MAXMB(0xff);
-	reg_mcr |= FLEXCAN_MCR_FRZ | FLEXCAN_MCR_HALT | FLEXCAN_MCR_SUPV |
-		FLEXCAN_MCR_WRN_EN | FLEXCAN_MCR_IRMQ | FLEXCAN_MCR_IDAM_C |
-		FLEXCAN_MCR_MAXMB(priv->tx_mb_idx);
+	reg_mcr |= FLEXCAN_MCR_SUPV | FLEXCAN_MCR_WRN_EN | FLEXCAN_MCR_IRMQ |
+		FLEXCAN_MCR_IDAM_C | FLEXCAN_MCR_MAXMB(priv->tx_mb_idx);
 
 	/* MCR
 	 *

