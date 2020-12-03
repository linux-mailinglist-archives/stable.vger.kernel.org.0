Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368B32CD6C0
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 14:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730778AbgLCN3X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 08:29:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728067AbgLCN3W (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 08:29:22 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Markus Reichl <m.reichl@fivetechno.de>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 04/39] arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.
Date:   Thu,  3 Dec 2020 08:27:58 -0500
Message-Id: <20201203132834.930999-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201203132834.930999-1-sashal@kernel.org>
References: <20201203132834.930999-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Markus Reichl <m.reichl@fivetechno.de>

[ Upstream commit 0011c6d182774fc781fb9e115ebe8baa356029ae ]

Recently introduced async probe on mmc devices can shuffle block IDs.
Pin them to fixed values to ease booting in environments where UUIDs
are not practical. Use newly introduced aliases for mmcblk devices from [1].

[1]
https://patchwork.kernel.org/patch/11747669/

Signed-off-by: Markus Reichl <m.reichl@fivetechno.de>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20201104162356.1251-1-m.reichl@fivetechno.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index ada724b12f014..7a9a7aca86c6a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -29,6 +29,9 @@ aliases {
 		i2c6 = &i2c6;
 		i2c7 = &i2c7;
 		i2c8 = &i2c8;
+		mmc0 = &sdio0;
+		mmc1 = &sdmmc;
+		mmc2 = &sdhci;
 		serial0 = &uart0;
 		serial1 = &uart1;
 		serial2 = &uart2;
-- 
2.27.0

