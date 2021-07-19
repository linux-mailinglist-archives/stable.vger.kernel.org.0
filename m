Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA6E43CE5EB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348712AbhGSPzi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:55:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350565AbhGSPvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B98F613B7;
        Mon, 19 Jul 2021 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712229;
        bh=wq4ZZtUm7EFvZAjpJHS806vzHeGv9agH7iwJwPRfhek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2ftgjNe6768DPi1BjviPcmXyrWo/3uKKFIPxycgk+aiBb2tRU3oRwr5yzGAid3qd
         +lx2r3MC3mtu3xCrul/3JDLXHO1BnY7NlWshC4IPllOKtozCrAyfHiOiRt7ZgQ8/NU
         09WbSeboumUIlNXgciIu85gDbhQsIT/KLMAsQ61k=
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
Subject: [PATCH 5.12 268/292] ARM: dts: imx6q-dhcom: Fix ethernet reset time properties
Date:   Mon, 19 Jul 2021 16:55:30 +0200
Message-Id: <20210719144951.731643121@linuxfoundation.org>
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
index d0768ae429fa..921a277fc3b0 100644
--- a/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
+++ b/arch/arm/boot/dts/imx6q-dhcom-som.dtsi
@@ -96,8 +96,8 @@
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



