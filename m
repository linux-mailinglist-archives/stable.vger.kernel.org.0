Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C385499392
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385912AbiAXUep (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383767AbiAXU1q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:27:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37174B8122D;
        Mon, 24 Jan 2022 20:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66ADDC340E5;
        Mon, 24 Jan 2022 20:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056064;
        bh=6Pwq7Qmz+CXAMR/zefiggxTOBO3q2PQ/Mc2rClt1aTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UB1j8EhWrr/5o4W5BBD8jsEMxsYycUBcokd1PQpQIAXucWio54MFU2L5H4a9j1Q0D
         JQpmrV4EuEiMFzX7vAPCocJFZBOX6RuSffYBb70EPJeBAYftqqH4yvLwiaik4AG6s8
         fMDD3bioRp6Id7E4Qg7RH+FEweM4Jsg6ma09HEUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 357/846] can: mcp251xfd: add missing newline to printed strings
Date:   Mon, 24 Jan 2022 19:37:54 +0100
Message-Id: <20220124184113.250710133@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 3bd9d8ce6f8c5c43ee2f1106021db0f98882cc75 ]

This patch adds the missing newline to printed strings.

Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Link: https://lore.kernel.org/all/20220105154300.1258636-4-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index e16dc482f3270..63613c186f173 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2625,7 +2625,7 @@ static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 	if (!mcp251xfd_is_251X(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {
 		netdev_info(ndev,
-			    "Detected %s, but firmware specifies a %s. Fixing up.",
+			    "Detected %s, but firmware specifies a %s. Fixing up.\n",
 			    __mcp251xfd_get_model_str(devtype_data->model),
 			    mcp251xfd_get_model_str(priv));
 	}
@@ -2662,7 +2662,7 @@ static int mcp251xfd_register_check_rx_int(struct mcp251xfd_priv *priv)
 		return 0;
 
 	netdev_info(priv->ndev,
-		    "RX_INT active after softreset, disabling RX_INT support.");
+		    "RX_INT active after softreset, disabling RX_INT support.\n");
 	devm_gpiod_put(&priv->spi->dev, priv->rx_int);
 	priv->rx_int = NULL;
 
-- 
2.34.1



