Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B7442B181
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:58:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237409AbhJMA6d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:41920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236943AbhJMA6L (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:58:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD1A360EB4;
        Wed, 13 Oct 2021 00:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086569;
        bh=/lypUK+SKxAOoXG2Sfj+3YECeu28G0qoc6C/fC+0yK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qVL00i6akDOIfqo/F4lxPIXCfpjfJOIkPRQ0EUCdpj9t+MPq9SL3GmdC9UqY9faHF
         1jmbsAOw0O3I+1szSJcVX8I/hI3i1ajnyZ6WUxJU6XpJ2SMcc4wN2FuzTOl3aQG0AN
         YJIEG97yuLdi9OoOzMErfI9rA3jQqAGd7c8psMVqXRS3b1Lrnl9qwoiE7VebYRhb0A
         aOe12dJR32EAdkqsr0Wt0CpERR9VMa6wzfcMsxcB3jbJTWms/VcJsmmLFE65llz0FB
         G8AzDHoqJkKCaMobJszcu5jDtMNNpupw5hlk/jGPv1BparSc5k/XHPvrfQd0qVNzDJ
         2wA9ujtcUJktw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 2/6] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Tue, 12 Oct 2021 20:55:58 -0400
Message-Id: <20211013005603.700363-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005603.700363-1-sashal@kernel.org>
References: <20211013005603.700363-1-sashal@kernel.org>
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
index 89f0c9979b89..4f63158d6b9b 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -69,7 +69,6 @@ apb {
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			qspi1: spi@f0024000 {
-- 
2.33.0

