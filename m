Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD7113E473
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388814AbgAPRI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:08:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:42202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389417AbgAPRI3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:08:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79DA6217F4;
        Thu, 16 Jan 2020 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194508;
        bh=bT2x6OCeUenHIkUtd4svhUWmcGCenjYn9mnruQlTmak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QXUT9fN9EmIm3S5PsC4Dq61CNjYPIWUY0Fc+vtacAsMcTUxYfOSgDKqgmXF7xb+aQ
         PMscmgK6qlHIJDOD+e3ZIPy8GxL73jqTjWkuQvaE+r9pFk39JYzuF0QX9rrCJBmsty
         QyPvQdhWKx7bWaQYGc+mL9nHwhLdxSRWFKcNVhSA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Hewitt <christianshewitt@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 403/671] arm64: dts: meson-gxm-khadas-vim2: fix gpio-keys-polled node
Date:   Thu, 16 Jan 2020 12:00:41 -0500
Message-Id: <20200116170509.12787-140-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit 0afd24c2fb61bd5163bab08ea1ee54d60d3ea37e ]

Fix DTC warnings:

meson-gxm-khadas-vim2.dtb: Warning (avoid_unnecessary_addr_size):
   /gpio-keys-polled: unnecessary #address-cells/#size-cells
	without "ranges" or child "reg" property

Fixes: b8b74dda3908 ("ARM64: dts: meson-gxm: Add support for Khadas VIM2")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Tested-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
index 782e9edac805..bfd3a510ff16 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxm-khadas-vim2.dts
@@ -63,11 +63,9 @@
 
 	gpio-keys-polled {
 		compatible = "gpio-keys-polled";
-		#address-cells = <1>;
-		#size-cells = <0>;
 		poll-interval = <100>;
 
-		button@0 {
+		power-button {
 			label = "power";
 			linux,code = <KEY_POWER>;
 			gpios = <&gpio_ao GPIOAO_2 GPIO_ACTIVE_LOW>;
-- 
2.20.1

