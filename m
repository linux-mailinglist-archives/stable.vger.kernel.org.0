Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED9DA47ADC8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235843AbhLTOzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:46 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42606 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238026AbhLTOxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:53:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51D0261183;
        Mon, 20 Dec 2021 14:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36061C36AE7;
        Mon, 20 Dec 2021 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011991;
        bh=hlTTvAs0sIiiN+T8VNFyOM2sQLM1gvTbq+ODXeB63fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WoaSm9dAme/XRYC+2Rj8IyM98NMu3p8pga7mMBC+sSp8j1YLh5/yf2jTUAKfWoqkt
         AqBY2nyV9EYrKPSl4qTxdat9QRKdJQ4VHn2uU1PYcNIT1uHaGUdfEVr5k+PySAOXEZ
         Ken5KEn45SCwZazz5rs7JKkiuFLBfTH06RrKkiIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Klink <flokli@flokli.de>,
        Dennis Gilmore <dgilmore@redhat.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/177] arm64: dts: rockchip: fix poweroff on helios64
Date:   Mon, 20 Dec 2021 15:33:12 +0100
Message-Id: <20211220143041.521706721@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Klink <flokli@flokli.de>

[ Upstream commit aef4b9a89a376a9cabe5e744729914e7766c59bb ]

Adding the rockchip,system-power-controller property here will use the
rk808 to power off the system.

Fixes: 09e006cfb43e ("arm64: dts: rockchip: Add basic support for Kobol's Helios64")
Signed-off-by: Florian Klink <flokli@flokli.de>
Tested-by: Dennis Gilmore <dgilmore@redhat.com>
Link: https://lore.kernel.org/r/20211020095926.735938-2-flokli@flokli.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts b/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts
index 738cfd21df3ef..354f54767bad8 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-kobol-helios64.dts
@@ -269,6 +269,7 @@ rk808: pmic@1b {
 		clock-output-names = "xin32k", "rk808-clkout2";
 		pinctrl-names = "default";
 		pinctrl-0 = <&pmic_int_l>;
+		rockchip,system-power-controller;
 		vcc1-supply = <&vcc5v0_sys>;
 		vcc2-supply = <&vcc5v0_sys>;
 		vcc3-supply = <&vcc5v0_sys>;
-- 
2.33.0



