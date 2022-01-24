Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B9C499506
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:08:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392059AbiAXUuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:50:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389571AbiAXUmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:42:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C36C04964D;
        Mon, 24 Jan 2022 11:52:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC360B81188;
        Mon, 24 Jan 2022 19:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7FAEC340E5;
        Mon, 24 Jan 2022 19:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053951;
        bh=VCiTbnnjte9C+5Tux5ffEglBv+5ZTbI2UNk5iaPeTpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=apVw3TQE9jZwQ7UBFZKrq2B5ZJuxVXW0esTvPrRiGaddwZAUSEqJEyvre16nrDcCT
         zEeuqkMR4w4ENYDXHWgnOsdpiCrx1wt0KRXyY+2rilhl/xf9Gpa57icyYJD5SLEufa
         xTroy20jSLvh7IyeXIlPAa0VMgqjolDdsHUQf51w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/563] can: mcp251xfd: add missing newline to printed strings
Date:   Mon, 24 Jan 2022 19:39:55 +0100
Message-Id: <20220124184032.404070396@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index 4e13f6dfb91a2..e0b322ab03628 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2497,7 +2497,7 @@ static int mcp251xfd_register_chip_detect(struct mcp251xfd_priv *priv)
 	if (!mcp251xfd_is_251X(priv) &&
 	    priv->devtype_data.model != devtype_data->model) {
 		netdev_info(ndev,
-			    "Detected %s, but firmware specifies a %s. Fixing up.",
+			    "Detected %s, but firmware specifies a %s. Fixing up.\n",
 			    __mcp251xfd_get_model_str(devtype_data->model),
 			    mcp251xfd_get_model_str(priv));
 	}
@@ -2534,7 +2534,7 @@ static int mcp251xfd_register_check_rx_int(struct mcp251xfd_priv *priv)
 		return 0;
 
 	netdev_info(priv->ndev,
-		    "RX_INT active after softreset, disabling RX_INT support.");
+		    "RX_INT active after softreset, disabling RX_INT support.\n");
 	devm_gpiod_put(&priv->spi->dev, priv->rx_int);
 	priv->rx_int = NULL;
 
-- 
2.34.1



