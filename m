Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E312E3B1C
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404900AbgL1Npt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:46016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404928AbgL1Nps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA03322B37;
        Mon, 28 Dec 2020 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163133;
        bh=GmKuwiXazNMZNr5xazk8D9WwTK/OqUPIL1IVpCS/mFs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDpPjDEb70f6lv641kH7smfJGQ2zADRNqfD5TmrBSJ/i6a70iaW2/5BOLSIoT89i9
         gMNPyPMp+qL8BqPsHz2OfBE/zOU+5FcFVBzb0kOotLZZqs3ileoM5LAaMgL62CIC2l
         +Puc6Hhl4hkeZ8n/yltiyxxS6CDDrGy9o2ag/BC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/453] arm64: dts: rockchip: Set dr_mode to "host" for OTG on rk3328-roc-cc
Date:   Mon, 28 Dec 2020 13:46:58 +0100
Message-Id: <20201228124945.964649064@linuxfoundation.org>
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
index bb40c163b05dc..6c3368f795ca3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-roc-cc.dts
@@ -333,6 +333,7 @@
 };
 
 &usb20_otg {
+	dr_mode = "host";
 	status = "okay";
 };
 
-- 
2.27.0



