Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76FEE499ADB
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378963AbiAXVr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:47:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1456846AbiAXVkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:40:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BB8461489;
        Mon, 24 Jan 2022 21:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EE6BC340E5;
        Mon, 24 Jan 2022 21:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060413;
        bh=60JLLZy+JtWGkK8II3PXJSB9hxxKXb/hbCzkUXWJsIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIdFqgPO5yYSnNWdnpictXErJlbR1X0itFvbZutptjx1TyNxL6pF6jsyVy4YaUmAL
         XwrEcF+5BI4EUC+tCkSavpWf8P0ShWK+j8czm80xJhJtmjDdIctS+OzhcQ6Yr0Fw3W
         C8YzJOtci9e+cfZN9mMvsnU9SQfYERusvzegcnyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.16 0906/1039] can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
Date:   Mon, 24 Jan 2022 19:44:55 +0100
Message-Id: <20220124184155.752086501@linuxfoundation.org>
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

commit 99e7cc3b3f85d9a583ab83f386315c59443509ae upstream.

This patch fixes a typo in the error message in
mcp251xfd_tef_obj_read(), if trying to read too many objects.

Link: https://lore.kernel.org/all/20220105154300.1258636-3-mkl@pengutronix.de
Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1336,7 +1336,7 @@ mcp251xfd_tef_obj_read(const struct mcp2
 	     len > tx_ring->obj_num ||
 	     offset + len > tx_ring->obj_num)) {
 		netdev_err(priv->ndev,
-			   "Trying to read to many TEF objects (max=%d, offset=%d, len=%d).\n",
+			   "Trying to read too many TEF objects (max=%d, offset=%d, len=%d).\n",
 			   tx_ring->obj_num, offset, len);
 		return -ERANGE;
 	}


