Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9DF8328E26
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:26:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241299AbhCATYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:24:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240859AbhCATSz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:18:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 26F73652D0;
        Mon,  1 Mar 2021 17:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620295;
        bh=sl9LTFd+dzLv/KbZzkIEB1l7ZlNuwkz0u9AYDhqsqsQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p8JcJ80z/TLeJFotLSnrxDbWusbh101MhofLjBgZRpcIBLTmEtzb3BqN/mfB5dr6V
         LgQiRBrQuaCjDVxjYDC/qUMcqFCZ4GlSEDj9XleadvOPtTq9IjL9Qx/d0FkMFyFMt0
         jmHYkeaM+ToHYRgSyGIcaheNc7OACWcPh54Q7K3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 071/775] can: mcp251xfd: mcp251xfd_probe(): fix errata reference
Date:   Mon,  1 Mar 2021 17:03:59 +0100
Message-Id: <20210301161205.190323227@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

[ Upstream commit 28eb119c042e8d3420b577b5b3ea851a111e7b2d ]

This patch fixes the reference to the errata for both the mcp2517fd
and the mcp2518fd.

Fixes: f5b84dedf7eb ("can: mcp25xxfd: mcp25xxfd_probe(): add SPI clk limit related errata information")
Link: https://lore.kernel.org/r/20210128104644.2982125-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index f07e8b737d31e..ee39e79927efb 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -2901,7 +2901,7 @@ static int mcp251xfd_probe(struct spi_device *spi)
 			spi_get_device_id(spi)->driver_data;
 
 	/* Errata Reference:
-	 * mcp2517fd: DS80000789B, mcp2518fd: DS80000792C 4.
+	 * mcp2517fd: DS80000792C 5., mcp2518fd: DS80000789C 4.
 	 *
 	 * The SPI can write corrupted data to the RAM at fast SPI
 	 * speeds:
-- 
2.27.0



