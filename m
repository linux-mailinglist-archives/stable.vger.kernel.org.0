Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78A8DF6577
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728781AbfKJCpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:46308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728776AbfKJCpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FD3021848;
        Sun, 10 Nov 2019 02:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353916;
        bh=jIFlpl/wQMGI9GNYRcwXiD1YCvrHp52FADOVP/p53Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Sdd0Q9RBFFJ+ZB/2YF0wEo2t3U7YWTRaq7LFgkOhgzvH8LO0qsExsZcmkDJza/jj
         ZqCqt97qvHlExFcQxdaPm0qmuR4l/9GYMgBkCSGEdNZbGBzBIuDXBFTegaTICDejoj
         bUZCcuxnjlBGn/X7EIv9RIxHkqNCa0ZH1qkdoLRA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 179/191] ARM: dts: lpc32xx: Fix SPI controller node names
Date:   Sat,  9 Nov 2019 21:40:01 -0500
Message-Id: <20191110024013.29782-179-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 11236ef582b8d66290bb3b3710e03ca1d85d8ad8 ]

SPI controller nodes should be named 'spi' rather than 'ssp'. Fixing the
name enables dtc SPI bus checks.

Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: Sylvain Lemieux <slemieux.tyco@gmail.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/lpc32xx.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/lpc32xx.dtsi b/arch/arm/boot/dts/lpc32xx.dtsi
index 4981741377f3a..ed0d6fb20122a 100644
--- a/arch/arm/boot/dts/lpc32xx.dtsi
+++ b/arch/arm/boot/dts/lpc32xx.dtsi
@@ -179,7 +179,7 @@
 			 * ssp0 and spi1 are shared pins;
 			 * enable one in your board dts, as needed.
 			 */
-			ssp0: ssp@20084000 {
+			ssp0: spi@20084000 {
 				compatible = "arm,pl022", "arm,primecell";
 				reg = <0x20084000 0x1000>;
 				interrupts = <20 IRQ_TYPE_LEVEL_HIGH>;
@@ -199,7 +199,7 @@
 			 * ssp1 and spi2 are shared pins;
 			 * enable one in your board dts, as needed.
 			 */
-			ssp1: ssp@2008c000 {
+			ssp1: spi@2008c000 {
 				compatible = "arm,pl022", "arm,primecell";
 				reg = <0x2008c000 0x1000>;
 				interrupts = <21 IRQ_TYPE_LEVEL_HIGH>;
-- 
2.20.1

