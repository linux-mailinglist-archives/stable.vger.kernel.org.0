Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEB2E68B1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgL1M7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbgL1M7v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:59:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4680224D2;
        Mon, 28 Dec 2020 12:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160350;
        bh=p1SBuvEuvOnE6F0Yhv0RPPh1j3jJpmrPEhHjsIXR10c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWRbKqKcYLyeeDHDR1+aM2oyTtt+oEiEBpY7WT9CfR6w1w7JxqMECq08gbeYhC4Nz
         OhwaQJZ7b7xb5XXX8rhzWGn/BORSAM5rPj0tCFeyTL4hTgez8pp3nlNmmfBZ7iFT8t
         htTFDjv3XTPU/Db/PA48ZRaTdVISRUbvD1j6HiNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Markus Reichl <m.reichl@fivetechno.de>,
        Douglas Anderson <dianders@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 004/175] arm64: dts: rockchip: Assign a fixed index to mmc devices on rk3399 boards.
Date:   Mon, 28 Dec 2020 13:47:37 +0100
Message-Id: <20201228124853.453748321@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
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
index 7afbfb0f96a3c..dd211dbdaaae0 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -65,6 +65,9 @@
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



