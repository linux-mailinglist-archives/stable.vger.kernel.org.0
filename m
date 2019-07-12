Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D33266F08
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfGLMUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:20:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727246AbfGLMUL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:20:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDBFD21670;
        Fri, 12 Jul 2019 12:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934011;
        bh=2PGtoNThi1wmNK2eDCwm4czO2PFAuK2r3v/tdgqCp+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v4rfNxqXm183YYet9PXZHdP4mCcVJpLDl40M6KY6oojMDsRqcaevJGh99BBG05SY1
         u1cacX09SjebHm/W1nqDUFRQ6r7AiXaMOIVUVLRwfXRqZSOA2Xz8Zh1I567oQp0SFL
         BVLztyBreBUpAHO6tJw9VFw5u/T3573itrYIQr6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Nyekjaer <sean@geanix.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/91] dt-bindings: can: mcp251x: add mcp25625 support
Date:   Fri, 12 Jul 2019 14:18:21 +0200
Message-Id: <20190712121622.365085777@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121621.422224300@linuxfoundation.org>
References: <20190712121621.422224300@linuxfoundation.org>
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
index 188c8bd4eb67..5a0111d4de58 100644
--- a/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
+++ b/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt
@@ -4,6 +4,7 @@ Required properties:
  - compatible: Should be one of the following:
    - "microchip,mcp2510" for MCP2510.
    - "microchip,mcp2515" for MCP2515.
+   - "microchip,mcp25625" for MCP25625.
  - reg: SPI chip select.
  - clocks: The clock feeding the CAN controller.
  - interrupts: Should contain IRQ line for the CAN controller.
-- 
2.20.1



