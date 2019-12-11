Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B1011B50E
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732523AbfLKPVv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:21:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:52326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732519AbfLKPVv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:21:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C12B24654;
        Wed, 11 Dec 2019 15:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077710;
        bh=AuO2UOvlPaxYHtlinuhycueMnHBJl4u9wwv8x9a8bHo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qhIKingFlRlSzYs2v3iEMMWqMnwV5y60rvQ1RjVI7YTGgdR4/nnCxlQtpGOO5LjEb
         O4tXXRlBqVCBiThhg0y1+PN15wtmkmxfNFPuHt/RHwEBqVSxTJzSIU33+jA6ufKPez
         dCMcWpVpNjc3gKLddmOfotrZ8/rDOCrVuPKRBKGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 140/243] arm64: dts: meson-gxbb-nanopi-k2: fix GPIO lines names
Date:   Wed, 11 Dec 2019 16:05:02 +0100
Message-Id: <20191211150348.611213827@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Neil Armstrong <narmstrong@baylibre.com>

[ Upstream commit f0783f5edb52af14ecaae6c5ce4f38e0a358f5d8 ]

The gpio line names were set in the pinctrl node instead of the gpio node,
at the time it was merged, it worked, but was obviously wrong.
This patch moves the properties to the gpio nodes.

Fixes: 12ada0513d7a ("ARM64: dts: meson-gxbb-nanopi-k2: Add GPIO lines names")
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
index cbe99bd4e06d2..8cd50b75171de 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-nanopi-k2.dts
@@ -191,7 +191,7 @@
 	pinctrl-names = "default";
 };
 
-&pinctrl_aobus {
+&gpio_ao {
 	gpio-line-names = "UART TX", "UART RX", "Power Control", "Power Key In",
 			  "VCCK En", "CON1 Header Pin31",
 			  "I2S Header Pin6", "IR In", "I2S Header Pin7",
@@ -201,7 +201,7 @@
 			  "";
 };
 
-&pinctrl_periphs {
+&gpio {
 	gpio-line-names = /* Bank GPIOZ */
 			  "Eth MDIO", "Eth MDC", "Eth RGMII RX Clk",
 			  "Eth RX DV", "Eth RX D0", "Eth RX D1", "Eth RX D2",
-- 
2.20.1



