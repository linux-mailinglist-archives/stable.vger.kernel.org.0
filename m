Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD8F72E63C6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405363AbgL1Pme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:42:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:47940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405186AbgL1Nql (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:46:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8655B2064B;
        Mon, 28 Dec 2020 13:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163161;
        bh=F8Ql1MnqnnF5nekGaStQ9wgNbbXsmQEjiQPj92dadQE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJsLQ6GVpBCGPHOMLc3PL5hACukYHEdIZdWGGI03oU54+C8Nq4OS1p+EEuWF9PBZJ
         cB04z0WMZg2ZDBwSqZAY0HUWbTVcWrD1u8JOrow2JNQgIoex86a860p+H0uRPpl8vm
         3wNpFMKsq+WnmR1MWFhLcW/KH3oVzh9GphIGC8XQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Artem Lapkin <art@khadas.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/453] arm64: dts: meson: fix spi-max-frequency on Khadas VIM2
Date:   Mon, 28 Dec 2020 13:47:07 +0100
Message-Id: <20201228124946.402955107@linuxfoundation.org>
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
index 3f43716d5c453..fa8bd0690e89a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -395,7 +395,7 @@
 		#size-cells = <1>;
 		compatible = "winbond,w25q16", "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <3000000>;
+		spi-max-frequency = <104000000>;
 	};
 };
 
-- 
2.27.0



