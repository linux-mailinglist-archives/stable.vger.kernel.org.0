Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5CAE42B127
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236110AbhJMA45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235868AbhJMA44 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:56:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B396160EB4;
        Wed, 13 Oct 2021 00:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086493;
        bh=hNKPR1W/BdbeYzaMSTdq90KGmz9/TnK9SOwxYNwWgnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gqfQsy6vAZnfwP59bRys764TsHEdA4pmi1Xs6cmuocXBonbHdkZ1JyIux1Qiy17MI
         lH2PSekpY7ug8uzBBwKKR41vMyFiQydR0toYiwFdVkziSPyXO7m2zt8F/S/l0wX262
         pGXtwO5oL5u8cGEzCSRySLwZgb1GORlO70z4h4O+uYAq6c0EBk7C61aHZWgJgXqBcc
         l0vd9utVJMMqsgLxl+wu1mx1kUq+nA4x+LlXlylo7TZU3w2wWq1vPxfz8Wn7umLO39
         Goz0ADoJi5BWZbxja/5p+J62NBaZszL3/oRbflPz9FScG/b7yIEvKwa3RN5242gm0k
         ywN3DEIcLruIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 04/17] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Tue, 12 Oct 2021 20:54:28 -0400
Message-Id: <20211013005441.699846-4-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005441.699846-1-sashal@kernel.org>
References: <20211013005441.699846-1-sashal@kernel.org>
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
index 8034e5dacc80..949df688c5f1 100644
--- a/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
+++ b/arch/arm/boot/dts/at91-sama5d27_som1_ek.dts
@@ -71,7 +71,6 @@ apb {
 			isc: isc@f0008000 {
 				pinctrl-names = "default";
 				pinctrl-0 = <&pinctrl_isc_base &pinctrl_isc_data_8bit &pinctrl_isc_data_9_10 &pinctrl_isc_data_11_12>;
-				status = "okay";
 			};
 
 			qspi1: spi@f0024000 {
-- 
2.33.0

