Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF2582ABA71
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732735AbgKINTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:19:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:46730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387704AbgKINTU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:19:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BF31206D8;
        Mon,  9 Nov 2020 13:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927959;
        bh=3jA+X4eawwUmyK0ONRZj1sgVPzj9BXzDyGc4hoede/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1EBfNupJl+BjOIL0ZeWUTJ7WiLn5Eepmk9MvOW8wHJ0AStMD9GasDrOOmuc8Ftzkf
         S0iShwb4INTwEcwsmpkNCoCfexajMJhuu7JCoy0DnxdC4omu0Fs04Yfmqdg9SP6RQl
         paMR5qKrc2XI4Pwg9WTAY3QdP6n+gPxXOAfZxSOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 080/133] ARM: dts: mmp3: Add power domain for the camera
Date:   Mon,  9 Nov 2020 13:55:42 +0100
Message-Id: <20201109125034.570357991@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lubomir Rintel <lkundrak@v3.sk>

[ Upstream commit 202f8e5c4975a95babf3bcdfb2c18952f06b030a ]

The camera interfaces on MMP3 are on a separate power island that needs
to be turned on for them to operate and, ideally, turned off when the
cameras are not in use.

This hooks the power island with the camera interfaces in the device
tree.

Link: https://lore.kernel.org/r/20200925234805.228251-2-lkundrak@v3.sk
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mmp3.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/mmp3.dtsi b/arch/arm/boot/dts/mmp3.dtsi
index cc4efd0efabd2..4ae630d37d094 100644
--- a/arch/arm/boot/dts/mmp3.dtsi
+++ b/arch/arm/boot/dts/mmp3.dtsi
@@ -296,6 +296,7 @@
 				interrupts = <GIC_SPI 42 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&soc_clocks MMP2_CLK_CCIC0>;
 				clock-names = "axi";
+				power-domains = <&soc_clocks MMP3_POWER_DOMAIN_CAMERA>;
 				#clock-cells = <0>;
 				clock-output-names = "mclk";
 				status = "disabled";
@@ -307,6 +308,7 @@
 				interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&soc_clocks MMP2_CLK_CCIC1>;
 				clock-names = "axi";
+				power-domains = <&soc_clocks MMP3_POWER_DOMAIN_CAMERA>;
 				#clock-cells = <0>;
 				clock-output-names = "mclk";
 				status = "disabled";
-- 
2.27.0



