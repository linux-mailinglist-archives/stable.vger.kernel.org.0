Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC9C3C8E0C
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbhGNTqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234622AbhGNTpU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DA541613F4;
        Wed, 14 Jul 2021 19:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291709;
        bh=liSe6McanGWa85HIg5Ho5nJWQTQVWy1aqtWDNjbkKxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gz/QwSOyp137vnWjXr3XXjT3727bjjSHQjrU4A0Xp7nj0n5CBCw++hurF2WkGXlKH
         zqW9sRZaPN/WbfffjCF0Bpt4R48Y79SWAk6ByJvz/I6L7wgBvhT4wHbc6qONB5cDS1
         CZGENH/ND1zf9/n8entxNPrT+kb3grl4Jy47BQS3eQesvmAh8aFLmDS8POXel9IzoO
         +SueYfIZGbebyT5LHeOCWieivxBA7ScjVdWDQdbUwDMntAmiewYRvojzHAqpEex+jE
         x7yQydryt41BLGNl0LD6FdwBaNrBggMBpdMFNxlb7CTuEfoBkA5sjOce3ftih680VY
         fCD6mRN4aMw7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Osipenko <digetx@gmail.com>,
        Svyatoslav Ryhel <clamor95@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 052/102] ARM: tegra: nexus7: Correct 3v3 regulator GPIO of PM269 variant
Date:   Wed, 14 Jul 2021 15:39:45 -0400
Message-Id: <20210714194036.53141-52-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
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
index bfc06b988781..215e497652d8 100644
--- a/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
+++ b/arch/arm/boot/dts/tegra30-asus-nexus7-grouper-ti-pmic.dtsi
@@ -143,7 +143,7 @@ vdd_core: core-regulator@60 {
 	};
 
 	vdd_3v3_sys: regulator@1 {
-		gpio = <&pmic 7 GPIO_ACTIVE_HIGH>;
+		gpio = <&pmic 6 GPIO_ACTIVE_HIGH>;
 		enable-active-high;
 	};
 };
-- 
2.30.2

