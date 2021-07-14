Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D59FB3C8C62
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbhGNTlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:41:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:36452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233876AbhGNTlo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E90ED613DA;
        Wed, 14 Jul 2021 19:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291530;
        bh=2SMvNzDwbWYDA2QYXZSquSh2lGytU7Rk4zv4kAQMPOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdiQ6aeITTVuXml90Lp11fxn78icEcuFKBanzyP4D3qF6DchVKooHeXAP9b33HRAh
         exBY0fg/EEPi3RhZN7AfIRqlrtDUF+IvAcUMblIQt2HiUEXWHBjbSvXIOBBuNITM/t
         KnQrF07fCoM3U7NM2jkOWF03rB0sbgC3O5JZ+wO9XsZ3YdyltpmulzJBYVQrHABtyD
         JJAc2b0MH5qck4NXW2PHHMrelzl3M8TP8qBSsrwCRPa+NbTIOPwuHjdceW1dTZCsGz
         Td7zx0LqKuKYMPlAb6pIZ8pqf8ayvTgAJw930nlxqrD0cnyRBgNWYIsDKMQzAlN4XW
         EKvdMQ8fhnarw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 034/108] ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE value
Date:   Wed, 14 Jul 2021 15:36:46 -0400
Message-Id: <20210714193800.52097-34-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -106,6 +106,8 @@ rgmii_phy: ethernet-phy@4 {
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

