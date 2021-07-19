Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8EF3CDF04
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245713AbhGSPHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:58644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345718AbhGSPE4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 41CFD60FE7;
        Mon, 19 Jul 2021 15:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709506;
        bh=8tRsXTV6Z+VTJTcpq+arqcMVBsTWKamCkYIdBK/+HX8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rt7WAsfMIMfUGl1mAORvA6bhBjR41KwUgoroIKawBMI2Kdz4jZsx2Zoxv3FenC4N4
         jD2XLNzEdGfYNmm3dE3KfLBnEonDP6LWPo0Xqy+obwQ/3d9w7igbpbtqbWRyGnfeDb
         LntxqkWFoJ5glgyI5Mux+Kw6E1EiDT574Z5CiH74=
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
Subject: [PATCH 4.19 412/421] ARM: dts: imx6q-dhcom: Fix ethernet reset time properties
Date:   Mon, 19 Jul 2021 16:53:43 +0200
Message-Id: <20210719145000.599084295@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Niedermaier <cniedermaier@dh-electronics.com>

[ Upstream commit c016c26c1631f539c652b5d82242a3ca402545c1 ]

Fix ethernet reset time properties as described in
Documentation/devicetree/bindings/net/ethernet-phy.yaml

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
 arch/arm/boot/dts/imx6q-dhcom-som.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
index 8d4a4cd01e07..b158e530a796 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -97,8 +97,8 @@
 			reg = <0>;
 			max-speed = <100>;
 			reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
-			reset-delay-us = <1000>;
-			reset-post-delay-us = <1000>;
+			reset-assert-us = <1000>;
+			reset-deassert-us = <1000>;
 		};
 	};
 };
-- 
2.30.2



