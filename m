Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F5929BAF6
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:29:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802762AbgJ0PvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:51:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:44368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802377AbgJ0PrD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:47:03 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0534A22202;
        Tue, 27 Oct 2020 15:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813623;
        bh=zKn65NvLbXuq7tEvC8RI2olC402QV2uiSbc0aKmQQ/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fl4j/xZjoEHeYvMFGRM06w2vd4MSI7p15Eu2rNnPtNNFh0+Lv/pW8EIg7OEHFchjK
         nkKe1W9NNQNHTL3sq5heko3sjb2LpO4nFzYz2dKqktOwf98phou0t7gHxdKlm/LwEn
         1XjPOW8CeDzXftwsr9W6UwKJowVFcCsFwH8pxiCI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Brunet <jbrunet@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 583/757] arm64: dts: meson: vim3: correct led polarity
Date:   Tue, 27 Oct 2020 14:53:53 +0100
Message-Id: <20201027135517.875063898@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 94f75b4465044..73783692e30ee 100644
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



