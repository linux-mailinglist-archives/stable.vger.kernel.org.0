Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0D33A0305
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbhFHTLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:48710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237491AbhFHTJs (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E3A161453;
        Tue,  8 Jun 2021 18:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178099;
        bh=FZOgNyFYW71rj/Sd22iZOOneX91E65viA/dUBhiaIJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZIkzDDfBisY55MgD8Kxkf5LPB90dyiNVEEywwAVA2YWeC480TfQiGJZeQejmTwQL
         3k8ALzYBJIJ+KJvcXF+7epKiWXTZexYQT0Zsu2Vq7yyNbVqQeer54+PwX3v/WKdTRf
         BZvljh2bjvp8F9l1Qj9Nzwc7phvmYcxtjbhH81Z8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 075/161] ARM: dts: imx7d-pico: Fix the tuning-step property
Date:   Tue,  8 Jun 2021 20:26:45 +0200
Message-Id: <20210608175947.979670851@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 0e2fa4959c4f44815ce33e46e4054eeb0f346053 ]

According to Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml, the
correct name of the property is 'fsl,tuning-step'.

Fix it accordingly.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Fixes: f13f571ac8a1 ("ARM: dts: imx7d-pico: Extend peripherals support")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-pico.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-pico.dtsi b/arch/arm/boot/dts/imx7d-pico.dtsi
index e57da0d32b98..e519897fae08 100644
--- a/arch/arm/boot/dts/imx7d-pico.dtsi
+++ b/arch/arm/boot/dts/imx7d-pico.dtsi
@@ -351,7 +351,7 @@
 	pinctrl-2 = <&pinctrl_usdhc1_200mhz>;
 	cd-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
 	bus-width = <4>;
-	tuning-step = <2>;
+	fsl,tuning-step = <2>;
 	vmmc-supply = <&reg_3p3v>;
 	wakeup-source;
 	no-1-8-v;
-- 
2.30.2



