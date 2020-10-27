Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4C1329BEE5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:01:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1805776AbgJ0Q4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 12:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794347AbgJ0PLW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:11:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44DBA21D24;
        Tue, 27 Oct 2020 15:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811481;
        bh=H8KO2Vr0ynMmy6/cHaYfRbtO4pIOzHLMPtplgIa2pJg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u/6htaUfRl05fwULkLPMPZofqY2kstJrdznmlw/FN0qvFh/G3TPe044YtfKrQSbiq
         KMoAXvI2nZs07FSkqRaeVaEzqIwOyIb/BwlhZ0ue+4POtJuWpVVQRpp8JKLax6LmVO
         PaJjO/X2DA0kNWbWDzaPVlZ77b9Y9Lliexaikt7E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 481/633] arm64: dts: meson: vim3: correct led polarity
Date:   Tue, 27 Oct 2020 14:53:44 +0100
Message-Id: <20201027135545.298630883@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 1f9d87d08e4a2299e86f8a1600aedf87ecd3b636 ]

The LEDs on the vim3 are active when the gpio is high, not low.

Fixes: c6d29c66e582 ("arm64: dts: meson-g12b-khadas-vim3: add initial device-tree")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Link: https://lore.kernel.org/r/20200803141850.172704-1-jbrunet@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi b/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
index ff5ba85b7562e..833bbc3359c44 100644
--- a/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-khadas-vim3.dtsi
@@ -41,13 +41,13 @@ leds {
 
 		led-white {
 			label = "vim3:white:sys";
-			gpios = <&gpio_ao GPIOAO_4 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio_ao GPIOAO_4 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
 		};
 
 		led-red {
 			label = "vim3:red";
-			gpios = <&gpio_expander 5 GPIO_ACTIVE_LOW>;
+			gpios = <&gpio_expander 5 GPIO_ACTIVE_HIGH>;
 		};
 	};
 
-- 
2.25.1



