Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F83D3CE418
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242383AbhGSPmH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:42:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348990AbhGSPfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08E460FD7;
        Mon, 19 Jul 2021 16:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711354;
        bh=wq4ZZtUm7EFvZAjpJHS806vzHeGv9agH7iwJwPRfhek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ex0VlJ69WMDB4foSXJe/S5shU6D8X4Wxjz01sIq4eENMbyVS/vAMIE2P/VP3cHbCI
         tJENh1E2Z7AqY6hPvKyW5rsVOl/leCwf3+pBQ5ZXfrC6RDMmRFXy1/qdJkfZPiassb
         V4G0nmdG6rNS0KmbXwBwUiq2DitTOTXm8/Ww1OuY=
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
Subject: [PATCH 5.13 323/351] ARM: dts: imx6q-dhcom: Fix ethernet reset time properties
Date:   Mon, 19 Jul 2021 16:54:29 +0200
Message-Id: <20210719144955.734889507@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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



