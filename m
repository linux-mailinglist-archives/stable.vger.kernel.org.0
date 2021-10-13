Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8491942B18D
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237538AbhJMA6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237542AbhJMA6Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A611A60F38;
        Wed, 13 Oct 2021 00:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086581;
        bh=oyWauy+tc0KLvvRNVX7G7Hax8nxbvwY67QOUuRJXty0=;
        h=From:To:Cc:Subject:Date:From;
        b=F0T+dxxNkOijObpQPPbQ20EjgpR8ZpK4n4RwRUZ68zD+LPg4O3TKjoNj6E33xbrhU
         7xwCzgVPExqF3T7WHmA/hL8B44kyhvRozbBH08zdgA8hzHsQjV0TIu6hS9GWn1z92E
         rLe6gB22AkV/M8kaHSjXb9oSeLy7lv2epv3uSH///ZqlvJd15IkFkNyiesPLh/1Eam
         CVDw88qMx7g2+EaHsnhs7Ae1AZiX/L2IH7osmh6nYoF5UWJV0vKVIeceYu1B0vBzT6
         9oEqUd+2n1+pbNb7R4SWw30VH5kaWJNRhx6AdWMQPTqWMAGsJhQrSuR0hD4b8APauy
         him880dAPbjyg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 1/5] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Tue, 12 Oct 2021 20:56:14 -0400
Message-Id: <20211013005619.700553-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eugen Hristev <eugen.hristev@microchip.com>

[ Upstream commit 4348cc10da6377a86940beb20ad357933b8f91bb ]

Without a sensor node, the ISC will simply fail to probe, as the
corresponding port node is missing.
It is then logical to disable the node in the devicetree.
If we add a port with a connection to a sensor endpoint, ISC can be enabled.

Signed-off-by: Eugen Hristev <eugen.hristev@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20210902121358.503589-1-eugen.hristev@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/at91-sama5d27_som1_ek.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
index e86e0c00eb6b..f37af915a37e 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -106,7 +106,6 @@ apb {
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			spi0: spi@f8000000 {
-- 
2.33.0

