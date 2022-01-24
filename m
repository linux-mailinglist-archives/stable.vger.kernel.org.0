Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425A049A074
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377971AbiAXXHg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1843345AbiAXXDv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:03:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D05C06C5A1;
        Mon, 24 Jan 2022 13:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 778BE61471;
        Mon, 24 Jan 2022 21:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E01AC340E5;
        Mon, 24 Jan 2022 21:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058874;
        bh=6Pwq7Qmz+CXAMR/zefiggxTOBO3q2PQ/Mc2rClt1aTc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SXRj0KwkBcPLDB07F+/cHb8ObWH1WybNTmNzhiQ0EiYsorcZg7A2bhiDGkz9ZMhNr
         24HUW4teBFPDuo3JnTvbIMNV1ofSeGxZBORHw5KJbhVojf8d9S3lvvHFPmgNv3hwAl
         LQQ/cz521HrWGeRKaEy9MVrZ2uPZIX0pupCb0EsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0430/1039] can: mcp251xfd: add missing newline to printed strings
Date:   Mon, 24 Jan 2022 19:36:59 +0100
Message-Id: <20220124184139.748366175@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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



