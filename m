Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1378F3CE5FE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349635AbhGSP7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:59:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349810AbhGSPuV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:50:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6890A61926;
        Mon, 19 Jul 2021 16:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712148;
        bh=tBr91gKLvuQJI1gJ1iOKDwtTdsZkQ/a3W+kNMd8SRIU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tZ9r8rEa8j+5MuFzgZCzXeA59CJ2R74XlzPx8uqk9kI747skG6Y4+sFkGOjj/ZaSd
         iwMWWkOVHiP3VbusXcAuDROM2u7RmMU7Sinyagei4xDNBIIVeyCugWHnhkYjM8/ehB
         rmufwUmNgBdxfWWgzMrnZ6s03hJfAEKsO/r2p7nw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christoph Niedermaier <cniedermaier@dh-electronics.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Marek Vasut <marex@denx.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        kernel@dh-electronics.com, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 269/292] ARM: dts: imx6q-dhcom: Fix ethernet plugin detection problems
Date:   Mon, 19 Jul 2021 16:55:31 +0200
Message-Id: <20210719144951.771658807@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit e2bdd3484890441b9cc2560413a86e8f2aa04157 ]

To make the ethernet cable plugin detection reliable the
power detection of the smsc phy has been disabled.

Fixes: 52c7a088badd ("ARM: dts: imx6q: Add support for the DHCOM iMX6 SoM and PDK2")
Signed-off-by: Christoph Niedermaier <cniedermaier@dh-electronics.com>
Cc: Shawn Guo <shawnguo@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>
Cc: Marek Vasut <marex@denx.de>
Cc: NXP Linux Team <linux-imx@nxp.com>
Cc: kernel@dh-electronics.com
To: linux-arm-kernel@lists.infradead.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index 921a277fc3b0..6043be73a1a8 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -98,6 +98,7 @@
 			reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <1000>;
 			reset-deassert-us = <1000>;
+			smsc,disable-energy-detect; /* Make plugin detection reliable */
 		};
 	};
 };
-- 
2.30.2



