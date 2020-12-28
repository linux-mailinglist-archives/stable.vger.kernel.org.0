Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 922D62E665D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:14:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733118AbgL1NUJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:20:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733110AbgL1NUI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:20:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D7E207F7;
        Mon, 28 Dec 2020 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161593;
        bh=ioT6EB0DR9OhI6mzGbumfULpL1uJQLrcRH3BNclv2mg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0sD8XxaSVmfJ3n1QlA6oakooxklEji/+3U34ZfMMutylXY9JCG54MIMJvWjbOGSR
         09yJ7PolLawOoIWJDfOSigzDp8FTeFR/lPGeNu9irsr+ew9b06TGb7T5oEDNSzHSzh
         wz51H7iqPKELGTH7tMp0eaPlLD1WkW1A/W4AnM+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Reichl <m.reichl@fivetechno.de>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 006/346] arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.
Date:   Mon, 28 Dec 2020 13:45:25 +0100
Message-Id: <20201228124920.064345592@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f14e8c5c41acc..f4ee7c4f83b8b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -29,6 +29,9 @@
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



