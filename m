Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0593C8F38
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239750AbhGNTwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238259AbhGNTse (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 365F9613F5;
        Wed, 14 Jul 2021 19:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291829;
        bh=2SMvNzDwbWYDA2QYXZSquSh2lGytU7Rk4zv4kAQMPOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohLSZKcq05mAG48WywFARYRDnYGWn9ETD2lvQebz3RknJS/25vFmw9aool6rv49q+
         KUdYYIk+/kx02HSx+728vdHhol+7fvi3lWSydAhC08yM7b8/OJKivF5M/8Gto2vZ1+
         uBcuhMWYKGEU04b6lfUTDWVdvZBvOCd/TRqspN7ROdWGaz4Tb+V1CZ233FPz/avbuT
         UKzyQ0UGAFAgvkfhZv/0TD+ogpzhkUaoIJr1NEYOIsu9u+lxVdWu8qUXXF7RDruQmq
         kAf6goXbgJQo+PwJLzM79w7tBKC5PV6gAQS4UkLBbYfQjNNNyE5bUDSUeIBCVkajqF
         RgsDChtTIpEHw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>, Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 28/88] ARM: dts: imx6dl-riotboard: configure PHY clock and set proper EEE value
Date:   Wed, 14 Jul 2021 15:42:03 -0400
Message-Id: <20210714194303.54028-28-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
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

