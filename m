Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0882249916A
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379218AbiAXUKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:10:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48852 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377567AbiAXUFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:05:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BC5AB811F9;
        Mon, 24 Jan 2022 20:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCE5C340E5;
        Mon, 24 Jan 2022 20:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643054739;
        bh=UL7NgZpa8VCGf7E/EWje0rN+0VhXwC7Rboytk2AhmGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WXbSi43mUA6EVdtJy7GGvM7lr/P+V37f9Tlen7IQS9RECosBhUbdjzuVgIyVG/H3w
         DBlQ7NIfn2rkfVgTtmtpMvhg17rZU4aBYyOzIb5bqR4gdSBUouclkBAxK40UvZ2kP3
         LpbBGzvv270JCSa4xqqU39nEf/JaxsDkIYDbnBlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 487/563] can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
Date:   Mon, 24 Jan 2022 19:44:12 +0100
Message-Id: <20220124184041.291417050@linuxfoundation.org>
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
@@ -1288,7 +1288,7 @@ mcp251xfd_tef_obj_read(const struct mcp2
 	     len > tx_ring->obj_num ||
 	     offset + len > tx_ring->obj_num)) {
 		netdev_err(priv->ndev,
-			   "Trying to read to many TEF objects (max=%d, offset=%d, len=%d).\n",
+			   "Trying to read too many TEF objects (max=%d, offset=%d, len=%d).\n",
 			   tx_ring->obj_num, offset, len);
 		return -ERANGE;
 	}


