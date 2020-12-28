Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E692E3A94
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391487AbgL1Nis (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:39148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391211AbgL1Nis (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D89CB2064B;
        Mon, 28 Dec 2020 13:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162687;
        bh=RUQ6/a/KD6+eMtUrSnB4E38U6LQ3EDElnSgw3JLvZag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ULkpfdd6JFCMn1wDuA5FryO4Ty3JSEId29JDmR4C/qFOYPQPXiVNsH4Zh1WeDjKjR
         LUcLVH6uwm3FzrsKfeq09FODh+ALukR/M/3c8cKQvHHkBCty2YI/yJuQ3XgqjNBg4G
         oObioMXZiGgE8J/nd5vB/lVMo3eIK2BLOmSOHsIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 008/453] ARM: dts: imx6qdl-wandboard-revd1: Remove PAD_GPIO_6 from enetgrp
Date:   Mon, 28 Dec 2020 13:44:04 +0100
Message-Id: <20201228124937.645247729@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 58d6bca5efc73235b0f84c0d53321737177c651e ]

Since commit 8ad2d1dcce54 ("ARM: dts: imx6qdl-wandboard: Add OV5645 camera
support") the PAD_GPIO_6 is used for providing the camera sensor clock.

Remove it from the enetgrp to fix the following IOMXU conflict:

[    9.972414] imx6q-pinctrl 20e0000.pinctrl: pin MX6Q_PAD_GPIO_6 already requested by 2188000.ethernet; cannot claim for 1-003c
[    9.983857] imx6q-pinctrl 20e0000.pinctrl: pin-140 (1-003c) status -22
[    9.990514] imx6q-pinctrl 20e0000.pinctrl: could not request pin 140 (MX6Q_PAD_GPIO_6) from group ov5645grp  on device 20e0000.pinctrl

Fixes: 8ad2d1dcce54 ("ARM: dts: imx6qdl-wandboard: Add OV5645 camera support")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi b/arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi
index 93909796885a0..b9b698f72b261 100644
--- a/arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-wandboard-revd1.dtsi
@@ -166,7 +166,6 @@
 				MX6QDL_PAD_RGMII_RD2__RGMII_RD2		0x1b030
 				MX6QDL_PAD_RGMII_RD3__RGMII_RD3		0x1b030
 				MX6QDL_PAD_RGMII_RX_CTL__RGMII_RX_CTL	0x1b030
-				MX6QDL_PAD_GPIO_6__ENET_IRQ		0x000b1
 			>;
 		};
 
-- 
2.27.0



