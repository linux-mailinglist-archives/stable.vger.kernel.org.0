Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4539C3D2976
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234007AbhGVQEI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:04:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233171AbhGVQDM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7248061976;
        Thu, 22 Jul 2021 16:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972227;
        bh=9IwYoUA+yMUatCe2pkiZs9l8aiWjuGy0g91qBmcRMRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XguSdecR0sSfB2E7o2+YvkWmzv0u/SwtehaOlU8Eb7Zi5X2YWIL5Tsszn5PL9rDMp
         B/8XMLsQfDLgbUwm/lqUh6UsOLD2hFd04raXxnaIXPmxyEgpCEYr4Qpm1rVsdo7+/C
         crh10ZwwCmqUXlu4yRxYTxz6CNetq2Gx0BA4cN7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 032/156] ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE value
Date:   Thu, 22 Jul 2021 18:30:07 +0200
Message-Id: <20210722155629.449870399@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit 723de6a4126b2474a8106e943749e1554012dad6 ]

Without SoC specific PHY fixups the network interface on this board will
fail to work. Provide missing DT properties to make it work again.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6dl-riotboard.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/imx6dl-riotboard.dts b/arch/arm/boot/dts/imx6dl-riotboard.dts
index 065d3ab0f50a..e7d9bfbfd0e4 100644
--- a/arch/arm/boot/dts/imx6dl-riotboard.dts
+++ b/arch/arm/boot/dts/imx6dl-riotboard.dts
@@ -106,6 +106,8 @@
 			reset-gpios = <&gpio3 31 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
 			reset-deassert-us = <1000>;
+			qca,smarteee-tw-us-1g = <24>;
+			qca,clk-out-frequency = <125000000>;
 		};
 	};
 };
-- 
2.30.2



