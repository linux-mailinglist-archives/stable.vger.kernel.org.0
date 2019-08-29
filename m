Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAA4A174B
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfH2Ky1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 06:54:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728021AbfH2Kua (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Aug 2019 06:50:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB7C02173E;
        Thu, 29 Aug 2019 10:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567075829;
        bh=9OwpUQxQjkGWdwWltlQKTGXWR2s8Zhgbq2LrY6GIs8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFvjoaEScbm2R6FOwxzrEGMFZoYfEgpa8b2+wAsTnEMKfv+FLgNhr3POwCdh7WHED
         PqZea4ufXFCibqlPG24V36t+b1fetVPXa3voyWAFmSSuN4RkJSH9J5ygTQuMR1KIXD
         o3NTkqgM1Lh1bsunIbO5ZHrlQaKB5UUwF49ch0dc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Voytik <voytikd@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 17/29] arm64: dts: rockchip: enable usb-host regulators at boot on rk3328-rock64
Date:   Thu, 29 Aug 2019 06:49:57 -0400
Message-Id: <20190829105009.2265-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829105009.2265-1-sashal@kernel.org>
References: <20190829105009.2265-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Voytik <voytikd@gmail.com>

[ Upstream commit 26e2d7b03ea7ff254bf78305aa44dda62e70b78e ]

After commit ef05bcb60c1a, boot from USB drives is broken.
Fix this problem by enabling usb-host regulators during boot time.

Fixes: ef05bcb60c1a ("arm64: dts: rockchip: fix vcc_host1_5v pin assign on rk3328-rock64")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328-rock64.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
index c142169a58fc5..e9147e35b7396 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3328-rock64.dts
@@ -40,6 +40,7 @@
 		pinctrl-0 = <&usb30_host_drv>;
 		regulator-name = "vcc_host_5v";
 		regulator-always-on;
+		regulator-boot-on;
 		vin-supply = <&vcc_sys>;
 	};
 
@@ -50,6 +51,7 @@
 		pinctrl-0 = <&usb20_host_drv>;
 		regulator-name = "vcc_host1_5v";
 		regulator-always-on;
+		regulator-boot-on;
 		vin-supply = <&vcc_sys>;
 	};
 
-- 
2.20.1

