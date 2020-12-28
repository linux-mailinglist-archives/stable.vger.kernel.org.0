Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A75502E39FD
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390458AbgL1Nas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390446AbgL1Nar (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C87D02072C;
        Mon, 28 Dec 2020 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162206;
        bh=0Boy5FralNc27aZjEOGGzSmX0dPwbwntgLO8TFCgHnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=diJytPoN9e3pFmIi2vQd/dV5sDqhu06Unvzw+Ct78sPrANcCSY0uGRIttUtfpXBmF
         dfLpvuOp2AOBHelFSuWjZnfZHV6q2lod2kyC+3bYeN8pVzDSEuxZD1H49+ciRE78MM
         usCC0l3HfHjBRWzson0UtCVaNvpXF59IRef+1NVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/346] arm64: dts: meson: fix spi-max-frequency on Khadas VIM2
Date:   Mon, 28 Dec 2020 13:48:22 +0100
Message-Id: <20201228124928.631747900@linuxfoundation.org>
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

From: Artem Lapkin <art@khadas.com>

[ Upstream commit b6c605e00ce8910d7ec3d9a54725d78b14db49b9 ]

The max frequency for the w25q32 (VIM v1.2) and w25q128 (VIM v1.4) spifc
chip should be 104Mhz not 30MHz.

Fixes: b8b74dda3908 ("ARM64: dts: meson-gxm: Add support for Khadas VIM2")
Signed-off-by: Artem Lapkin <art@khadas.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20201125024001.19036-1-christianshewitt@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
index bdf7c6c5983ce..30fa9302a4dc8 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -399,7 +399,7 @@
 		#size-cells = <1>;
 		compatible = "winbond,w25q16", "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <3000000>;
+		spi-max-frequency = <104000000>;
 	};
 };
 
-- 
2.27.0



