Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDF75337C5E
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCKSV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:21:59 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:53949 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229490AbhCKSUl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:20:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 44D301C29;
        Thu, 11 Mar 2021 13:20:41 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:20:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=x8CoT/
        PdBzYWiMQej+hl0bppw0TDxHicicu5G66oZ5c=; b=MS7g3q3rL560rZmYVcFOdz
        seWtoBxchXbwuMpnwytiae2h6qCvDZ5diX7ytICATwX64JO6vJzjmHOP9tUEX3nF
        k5S+YaxfBBXgWk4dwJLPoacfiAqDlvIrhpKQq+bm2UeUd7RPwyTXmhlmKlIhvTMm
        ymqEuIgUkzKpdvlmnTFDhsfOzfDPSkjL5NPbfoORgBcysMOu4TrKqSp0Yie923Wd
        whyNi2mEkkLrdFTqoAUeJplBX9d81pnAliBIMqGmAoJeF+w/fZtGvq7ro4FS3FWU
        ZrLpOix7R2O+9in8IORkBltCHCgOBsKW+q3NnxQW4aSCcoTKYOc1R18nH19OpOIA
        ==
X-ME-Sender: <xms:eF9KYE834WnnEWftrKXyJPbCwLBvZ-46veVuLpP_2zTDpM1NuEyH8w>
    <xme:eF9KYMuiXzOnFBQ198zHW-2WOWA7_TkshziuUTYo0j3iLn26ff9jeOMkEk-y_Co7x
    3Nz3xaUgqiSLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:eF9KYKAKf-DZjQykGAgSdjlVvaG7jE2vtcpBMzFpfbgZa7_ug6QL9w>
    <xmx:eF9KYEeyBorIQEwitMSwDxp24Pi6GfJDDEYNfEH0cRCXj5UEE7ZFxA>
    <xmx:eF9KYJN2vfA5C0Xewf9xfalORN6RDgSv7qTPVfGZ8YfIXsyhWHQWvA>
    <xmx:eF9KYLXbZumrQD187Z1QTLZ8cusM06_Rbzw6CXtoMu-M-XaqePyrthYHBSc>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9FDD2240057;
        Thu, 11 Mar 2021 13:20:40 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: invoke flexcan_chip_freeze() to enter freeze" failed to apply to 4.14-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:20:30 +0100
Message-ID: <161548683012241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

