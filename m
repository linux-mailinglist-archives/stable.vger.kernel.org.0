Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEAC42B15F
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236807AbhJMA6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:58:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236762AbhJMA5l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F57A60F38;
        Wed, 13 Oct 2021 00:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086539;
        bh=RAlTcrrh6ECao7vjCfEHNrurnPEzRHur7FO57gL5C+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ut91XyQ24PRYweSPEvPZK53yAJ3uFj0OHbuXV+j8KDQQ6YA0gRV4T8NEfwmUQZQ/h
         MxE5nUTo1WB0KhK7o40r8wH2yZqSI7xzvHNRel4MOQxoIhvKY5ic+YR5PuoH0wI7Zo
         k2uIs1A77gCwO83jNhTnFIBYKePf5FAsNtQxrt4Gb5Lj1ChBunnwoThmpbBkYMcdXu
         dogZ/7Vo4vKKD1JpkRkMQJkXw/t46jX06CS8jWSH9pNZtmhk60S14y0uIyu9dawO4p
         REF+nMl8+WF8cfuOAV8F81TY6F6Gj//JD2i/g3v+NKvkNfLEZSohrbhgX5DlNiKlz7
         f+/elA60BsUTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eugen Hristev <eugen.hristev@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 03/11] ARM: dts: at91: sama5d2_som1_ek: disable ISC node by default
Date:   Tue, 12 Oct 2021 20:55:23 -0400
Message-Id: <20211013005532.700190-3-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211013005532.700190-1-sashal@kernel.org>
References: <20211013005532.700190-1-sashal@kernel.org>
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
index 9a18453d7842..0a53f21a8903 100644
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

