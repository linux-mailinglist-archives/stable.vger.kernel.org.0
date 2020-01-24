Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7874147C1F
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:49:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387528AbgAXJtU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387436AbgAXJtT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:49:19 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A577206D5;
        Fri, 24 Jan 2020 09:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859359;
        bh=4Y0FKpr75T4XiG+iehXJb+1P28xeBxWab08mWO88C7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dGRIAJlrY4bvXU7zOYw/sd5q73G2fNkH2uqMk3p1hqFBQeZxTfhFYG96dFTnDYfsc
         yaDupiKRaKZ/AiULvUB302eRAjaVo4VbbQGDT89lMy7c0q7CoD/R9dDkkPQ8LT2Gn3
         vvUxHlJlMCZk/W9OUxZZZH6ErDDwW2eZ78z4FkUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 086/343] ARM: dts: lpc32xx: phy3250: fix SD card regulator voltage
Date:   Fri, 24 Jan 2020 10:28:24 +0100
Message-Id: <20200124092931.379466178@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Zapolskiy <vz@mleia.com>

[ Upstream commit dc141b99fc36cf910a1d8d5ee30f43f2442fd1bd ]

The fixed voltage regulator on Phytec phyCORE-LPC3250 board, which
supplies SD/MMC card's power, has a constant output voltage level
of either 3.15V or 3.3V, the actual value depends on JP4 position,
the power rail is referenced as VCC_SDIO in the board hardware manual.

Fixes: d06670e96267 ("arm: dts: phy3250: add SD fixed regulator")
Signed-off-by: Vladimir Zapolskiy <vz@mleia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc3250-phy3250.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/lpc3250-phy3250.dts b/arch/arm/boot/dts/lpc3250-phy3250.dts
index b7bd3a110a8dd..dd0bdf765599d 100644
--- a/arch/arm/boot/dts/lpc3250-phy3250.dts
+++ b/arch/arm/boot/dts/lpc3250-phy3250.dts
@@ -49,8 +49,8 @@
 		sd_reg: regulator@2 {
 			compatible = "regulator-fixed";
 			regulator-name = "sd_reg";
-			regulator-min-microvolt = <1800000>;
-			regulator-max-microvolt = <1800000>;
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3300000>;
 			gpio = <&gpio 5 5 0>;
 			enable-active-high;
 		};
-- 
2.20.1



