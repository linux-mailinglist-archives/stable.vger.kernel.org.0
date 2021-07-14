Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B27603C8CA9
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234978AbhGNTma (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234603AbhGNTmI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 44200613D6;
        Wed, 14 Jul 2021 19:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291556;
        bh=rXWkPXBg4LUBXWPmKfZQEWc7QHNFNsYsoQEmj6nhgbU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iRLe4oajfoce+6POBEQcxlfO7h6JRCqIWMUyECYjPebRqXGfdODn3opTERj09gekV
         LtorLTt0+rI5/c7Onzklf/WrLLaElMRwexnxXOf9XBqksH207cKe6v3E5CuTJS8SEh
         hwbTIEytBaV3tdc+W+0eX4bB4oqGQuSlidihIK9CtYLR+lJFw62qUv7KPIIuQEWM9F
         4g6nkBFa0H0fYnLzlFRT37ENSzkUsHo+ho6dKbo44dCPT3opsogG8yjrnRxfP5mjo+
         8he67pX2dhllLP94xBBLjxMnxMHCrB6vDDN3/O3msLAR2GlhF778gBE4sVIdaEwIiW
         UU+Ov6iXk81/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Svyatoslav Ryhel <clamor95@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 052/108] ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant
Date:   Wed, 14 Jul 2021 15:37:04 -0400
Message-Id: <20210714193800.52097-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit c4dd6066bc304649e3159f1c7a08ece25d537e00 ]

The 3v3 regulator GPIO is GP6 and not GP7, which is the DDR regulator.
Both regulators are always-on, nevertheless the DT model needs to be
corrected, fix it.

Reported-by: Svyatoslav Ryhel <clamor95@gmail.com>
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
index b97da45ebdb4..e1325ee0a3c4 100644
--- a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
@@ -144,7 +144,7 @@ vdd_core: core-regulator@60 {
 	};
 
 	vdd_3v3_sys: regulator@1 {
-		gpio = <&pmic 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.30.2

