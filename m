Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB379299F5F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:22:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410934AbgJZXzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:55:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:60836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2410551AbgJZXyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:54:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E453121655;
        Mon, 26 Oct 2020 23:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756484;
        bh=BTFZbT/olhQ0xBQLQGyhSfj2UwUl36oNSO7HV/MXHx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0WbdFZqTIOUL4tHDqmvh0t2tjKaVlxTLI1BYSgKB7BW1ziaVsIwSL6s569OpOksm
         vEVgFPvky3aP8fGMPvSYy/iTtDow9j+jI/RqYEClOwbLuVFnkdHNiUiG6TZSjZHpiH
         cT4mzU1GnnGqh526NmbtViPwgKQ5XRE4xm/dftkQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzk@kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 127/132] ARM: dts: s5pv210: align SPI GPIO node name with dtschema in Aries
Date:   Mon, 26 Oct 2020 19:51:59 -0400
Message-Id: <20201026235205.1023962-127-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235205.1023962-1-sashal@kernel.org>
References: <20201026235205.1023962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 1ed7f6d0bab2f1794f1eb4ed032e90575552fd21 ]

The device tree schema expects SPI controller to be named "spi",
otherwise dtbs_check complain with a warning like:

  spi-gpio-0: $nodename:0: 'spi-gpio-0' does not match '^spi(@.*|-[0-9a-f])*$'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Tested-by: Jonathan Bakker <xc-racer2@live.ca>
Link: https://lore.kernel.org/r/20200907161141.31034-25-krzk@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-aries.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/s5pv210-aries.dtsi b/arch/arm/boot/dts/s5pv210-aries.dtsi
index cf858029292ed..aa2138048165c 100644
--- a/arch/arm/boot/dts/s5pv210-aries.dtsi
+++ b/arch/arm/boot/dts/s5pv210-aries.dtsi
@@ -507,7 +507,7 @@ poweroff: syscon-poweroff {
 		value = <0x5200>;
 	};
 
-	spi_lcd: spi-gpio-0 {
+	spi_lcd: spi-2 {
 		compatible = "spi-gpio";
 		#address-cells = <1>;
 		#size-cells = <0>;
-- 
2.25.1

