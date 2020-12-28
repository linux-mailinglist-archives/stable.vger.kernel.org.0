Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA69E2E3D0F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439050AbgL1OKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:10:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:45000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439044AbgL1OKe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:10:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 06204207B7;
        Mon, 28 Dec 2020 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164593;
        bh=AHeC2XnYjWNKg8K5wEPHix8cw73+gJWpWYshIVbs6xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kJTrqk6BLBCoTOtY0m7hs9QfWLJerqcHwSk8wi8oVYk/b3jR47M3mBAdJNPywpSaZ
         LBN6RpPYOcfjOnA2utWPnWZF6LW20lUCuWHLAulMmH+sjpi6+OfGyY18NFuJySn3CU
         vWH2iYBgio4kQzaVKCCmttkjDCpW7sMR7gg+RqF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/717] arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
Date:   Mon, 28 Dec 2020 13:43:47 +0100
Message-Id: <20201228125031.960484440@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 4076a007bd0f6171434bdb119a0b8797749b0502 ]

The board has a standard USB A female port connected to the USB OTG
controller's data pins. Set dr_mode in the OTG controller node to
indicate this usage, instead of having the implementation guess.

Fixes: 2171f4fdac06 ("arm64: dts: rockchip: add roc-rk3328-cc board")
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Link: https://lore.kernel.org/r/20201126073336.30794-2-wens@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
index b70ffb1c6a630..b76282e704de1 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -334,6 +334,7 @@
 };
 
 &usb20_otg {
+	dr_mode = "host";
 	status = "okay";
 };
 
-- 
2.27.0



