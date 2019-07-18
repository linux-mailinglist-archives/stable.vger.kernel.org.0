Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05E1C6C6D9
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390765AbfGRDTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:45738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391314AbfGRDLu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:11:50 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A2BE2173E;
        Thu, 18 Jul 2019 03:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419510;
        bh=dAh+zuNthGs12/kWyN/jbJWspHyKM2RO7mBtFnSFE7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g6cGU7mot5OCHgujR9SSC6WFOzQNjmXH6n/xrvUXWOmJwEZa76qgo2f7IfL5bK4X2
         2Bw+xqynX9C+c8sPi4+njDHr5CVBFtNOaWjrUp01KjMTymScrD/1ysraBlLqE3jmCE
         T772avOMoLQXo2OUeiWd2XjjPNubnyhqglPZiaNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/54] dt-bindings: can: mcp251x: add mcp25625 support
Date:   Thu, 18 Jul 2019 12:01:40 +0900
Message-Id: <20190718030049.970434028@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030048.392549994@linuxfoundation.org>
References: <20190718030048.392549994@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 0df82dcd55832a99363ab7f9fab954fcacdac3ae ]

Fully compatible with mcp2515, the mcp25625 have integrated transceiver.

This patch add the mcp25625 to the device tree bindings documentation.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
index ee3723beb701..33b38716b77f 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
@@ -4,6 +4,7 @@ Required properties:
  - compatible: Should be one of the following:
    - "microchip,mcp2510" for MCP2510.
    - "microchip,mcp2515" for MCP2515.
+   - "microchip,mcp25625" for MCP25625.
  - reg: SPI chip select.
  - clocks: The clock feeding the CAN controller.
  - interrupt-parent: The parent interrupt controller.
-- 
2.20.1



