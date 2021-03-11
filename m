Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDA1337C5C
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbhCKSUm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:20:42 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58757 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229553AbhCKSUe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:20:34 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 8D4831C27;
        Thu, 11 Mar 2021 13:20:33 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:20:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4BZGFO
        vMOtD+y+x+j0Awtk/n8FELnWMlFuokLMGsXTY=; b=sVO9l1I5HpnYOGDFr1sLv/
        Ij41NZhI5045Ut131Bw4/hvGoAH9DZguh+w44uaFP+iAxKXAV0gclCDK+5nhXaMO
        Yy5bEix1Ijtpbf0pgDAfNYa1lNemOXjTGUI23MSTaCfgdKbo4vWKZPdzzkM0sJVA
        kKRJbbyWAyr6mvcU4RrV+SknRdYrU6UzXC4/dWsYmQpjK2FQNZPKzjMHoBfoVwav
        /hCvFZkKXz3dHzSkF2EnY2NZoA0830zpZXGnQgJto1ACy4kXVr5TvieyuNBo8WCk
        wfILuoj536/jG7NbPGeCRDdaM4hlCPpz8reYiX6XmHbZP2fP3Q9sYtuthpcsnbwQ
        ==
X-ME-Sender: <xms:cF9KYJqO5W98fI24B08mZ5C8APXFsCKAcaoogpIDcOkmV1cyoWxKWg>
    <xme:cF9KYLovyizyKYKbaXS0ZlFN-935NVG8b-tpeDThcQa69uS-ezDPEhSe9p6UsLwaI
    o9tKrYltoYuTw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:cF9KYGPGz_s94y932rIDDChEPZ6IsDj_7zCkq-0-uyO80YwbRhzHwQ>
    <xmx:cF9KYE7W2-U1SKVS6d6Q2TelGqUvqtv6vF1mhHu2s1G_939rHdJ6xQ>
    <xmx:cF9KYI4XUNFlW908ieeMF-4QpA0vZ1jH4cK9kYodUALhsF-JpMxXAQ>
    <xmx:cV9KYNgsnNMSBMAaBkb21Vfbzf7bCUrKXfPtveXDRvhW7hEdMZCeh95FRg8>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5AA35108005C;
        Thu, 11 Mar 2021 13:20:32 -0500 (EST)
Subject: FAILED: patch "[PATCH] can: flexcan: invoke flexcan_chip_freeze() to enter freeze" failed to apply to 4.19-stable tree
To:     qiangqing.zhang@nxp.com, mkl@pengutronix.de
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:20:30 +0100
Message-ID: <1615486830234219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

