Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF4413C8D43
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236850AbhGNToS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234818AbhGNTnk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:43:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00ADB613D4;
        Wed, 14 Jul 2021 19:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291640;
        bh=o8tw/oDkyZ61RXVcQdr/5fUikWBnf/u/8USTlQ6NBKA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbI1Vr1A22lAZ4mfj1pU4KzSuI96c5i6Tr59miS6IKuXIVasrp9xhkxWYRZxEzQgw
         zG0pty8wsUzPQIw/bOT9TQRJ67b4fARXRXZ5G07oTqQPstUhR+fm7nISgiIOG8BaPU
         ttp9yWwVT/lDXqjTUZQ+Z6ge0TJbi2olC2xFRkZAPpTbKifxvtLOxkbpkST/MnmpwA
         WsKduX3Ut5Arp2xPpJ624+WmLzdVh1D9nLI4gTvYSf/xKdrKk/tjTRXtN/uW2SVLoL
         mRfzwFZC4IVbQzcbiuoibCp5MmvzCezeA0yoEMWvgBoZJuDyjFZTuJZ3EQgOkWK2uo
         zqfYH9Js9lBUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ezequiel Garcia <ezequiel@collabora.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 003/102] ARM: dts: rockchip: Fix thermal sensor cells o rk322x
Date:   Wed, 14 Jul 2021 15:38:56 -0400
Message-Id: <20210714194036.53141-3-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ezequiel Garcia <ezequiel@collabora.com>

[ Upstream commit d5c24e20daf09587cbc221d40be1ba92673e8d94 ]

The number of cells to be used with a thermal sensor specifier
must be "1". Fix this.

Signed-off-by: Ezequiel Garcia <ezequiel@collabora.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20210506175514.168365-2-ezequiel@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk322x.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk322x.dtsi b/arch/arm/boot/dts/rk322x.dtsi
index a4dd50aaf3fc..799c9bfde4c9 100644
--- a/arch/arm/boot/dts/rk322x.dtsi
+++ b/arch/arm/boot/dts/rk322x.dtsi
@@ -520,7 +520,7 @@ tsadc: tsadc@11150000 {
 		pinctrl-0 = <&otp_pin>;
 		pinctrl-1 = <&otp_out>;
 		pinctrl-2 = <&otp_pin>;
-		#thermal-sensor-cells = <0>;
+		#thermal-sensor-cells = <1>;
 		rockchip,hw-tshut-temp = <95000>;
 		status = "disabled";
 	};
-- 
2.30.2

