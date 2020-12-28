Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A78E62E645F
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390488AbgL1Niv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:38:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:39182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391269AbgL1Niu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:38:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98672207B2;
        Mon, 28 Dec 2020 13:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162690;
        bh=NkE/kTcoyyNVJvEcF1TJi+71Rb+4SByiLlhXS8urmCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iXrXKuk1FD1q0SPul6+fJnfEcBIsbh1TK0ZMdFguf3q4AORFI2PJVOdYrdOjM+ddF
         u8khj9U/2T6Tp9b/h1I/xsUs2klE5ZCwF7C0yztJYbrzEw+CrSxilwk8WQNndzCbEA
         jyLiwz1/l+C2ESVwDasLGJC9UoB46MVRTgbN+aNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Bauer <bernd.bauer@anton-paar.com>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 009/453] ARM: dts: imx6qdl-kontron-samx6i: fix I2C_PM scl pin
Date:   Mon, 28 Dec 2020 13:44:05 +0100
Message-Id: <20201228124937.693783925@linuxfoundation.org>
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

From: Bernd Bauer <bernd.bauer@anton-paar.com>

[ Upstream commit 19ba8fb810c60b46869acc9f455613de454e0fca ]

Use the correct pin for the i2c scl signal else we can't access the
SoM eeprom.

Fixes: 2a51f9dae13d ("ARM: dts: imx6qdl-kontron-samx6i: Add iMX6-based Kontron SMARC-sAMX6i module")
Signed-off-by: Bernd Bauer <bernd.bauer@anton-paar.com>
[m.felsch@pengutronix.de: Adapt commit message]
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index 81c7ebb4b3fbe..6acc8591219a7 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -551,7 +551,7 @@
 
 	pinctrl_i2c3: i2c3grp {
 		fsl,pins = <
-			MX6QDL_PAD_GPIO_3__I2C3_SCL		0x4001b8b1
+			MX6QDL_PAD_GPIO_5__I2C3_SCL		0x4001b8b1
 			MX6QDL_PAD_GPIO_16__I2C3_SDA		0x4001b8b1
 		>;
 	};
-- 
2.27.0



