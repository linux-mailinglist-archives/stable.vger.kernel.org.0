Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86027499DCD
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1586259AbiAXW0D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381393AbiAXWRY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:17:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B04CC04A2EA;
        Mon, 24 Jan 2022 12:46:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33EE8B80CCF;
        Mon, 24 Jan 2022 20:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87CDC340E7;
        Mon, 24 Jan 2022 20:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057192;
        bh=60JLLZy+JtWGkK8II3PXJSB9hxxKXb/hbCzkUXWJsIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyygUE7b+XhenzhMK0EsIEdK+yUOTYP1X3e3HiHXZkS8KF1xnB8dOekK6Y8PYW1Hf
         q2d8ujRqmW54MrTMKKIU7St0Qlcjaa8aE8b41ealE2/gUtc5wFi659XlOoeo5Rwc2z
         KY4lGdUzMaaM5nw3iDgQlmbj7DnkyLZaS8162kSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.15 732/846] can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
Date:   Mon, 24 Jan 2022 19:44:09 +0100
Message-Id: <20220124184126.252521332@linuxfoundation.org>
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


