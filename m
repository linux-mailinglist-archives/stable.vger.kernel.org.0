Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADBEB40E7F8
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348658AbhIPRge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353613AbhIPRea (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:34:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE83560FA0;
        Thu, 16 Sep 2021 16:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810927;
        bh=COzna+AUvS9AjH9VMQTRotAp6F8lPQK/nnKVsWvii1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IK4vcY6tMSWy+F/EEM059mkbNhw0b1H/ophWBi53HmJj47SAf9MwO/6KkwvgQP28U
         j1TenK1j6IIqa2znA5qQqB6TIRG/Zn18J+B2ICAt9J1oe9ldiBJ1P6RO7RlLY/vYlh
         wjz0BNvtPrZ3bpyertMggO7GJ6gNv6fC4gTyAHZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Harvey <tharvey@gateworks.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 302/432] arm64: dts: imx8mm-venice-gw700x: fix invalid pmic pin config
Date:   Thu, 16 Sep 2021 18:00:51 +0200
Message-Id: <20210916155821.061645761@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Harvey <tharvey@gateworks.com>

[ Upstream commit 500659f3b401fe6ffd1d63f2449d16d8a4204db7 ]

The GW700x PMIC does not have an interrupt. Remove the invalid pin
config.

Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
index 11dda79cc46b..00f86cada30d 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-venice-gw700x.dtsi
@@ -278,8 +278,6 @@ rtc@68 {
 
 	pmic@69 {
 		compatible = "mps,mp5416";
-		pinctrl-names = "default";
-		pinctrl-0 = <&pinctrl_pmic>;
 		reg = <0x69>;
 
 		regulators {
@@ -444,12 +442,6 @@ MX8MM_IOMUXC_I2C2_SDA_I2C2_SDA		0x400001c3
 		>;
 	};
 
-	pinctrl_pmic: pmicgrp {
-		fsl,pins = <
-			MX8MM_IOMUXC_GPIO1_IO03_GPIO1_IO3	0x41
-		>;
-	};
-
 	pinctrl_uart2: uart2grp {
 		fsl,pins = <
 			MX8MM_IOMUXC_UART2_RXD_UART2_DCE_RX	0x140
-- 
2.30.2



