Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 668E1F6466
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729576AbfKJC7h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:59:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:47202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfKJC4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:47 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7A8E222C6;
        Sun, 10 Nov 2019 02:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354071;
        bh=AVsTff8XYCIJMMJe5wlggyX8gJLBRn9KGyjOJ6ZA1Ag=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wq47mZndz/A59aCp+uLJnHdsWjoe9kIQh77oGzwLFrmznZoZUyKmlZfeBT6Yg99zn
         qA7g1JRpB8rbCjDKPwU998FnCKpcP/xrdIfwAAhFZR1WudAO4yGia/0V1InkwtHLrR
         EcOVcymZdX1xeZWcW7TB/b9g7lQQFb2AmlynS+TA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 074/109] ARM: tegra: apalis_t30: fix mmc1 cmd pull-up
Date:   Sat,  9 Nov 2019 21:45:06 -0500
Message-Id: <20191110024541.31567-74-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcel Ziswiler <marcel.ziswiler@toradex.com>

[ Upstream commit 1c997fe4becdc6fcbc06e23982ceb65621e6572a ]

Fix MMC1 cmd pin pull-up causing issues on carrier boards without
external pull-up.

Signed-off-by: Marcel Ziswiler <marcel.ziswiler@toradex.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/tegra30-apalis.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
index faa8cd2914e8b..b9368d40bc6fb 100644
--- a/arch/arm/boot/dts/tegra30-apalis.dtsi
+++ b/arch/arm/boot/dts/tegra30-apalis.dtsi
@@ -166,14 +166,14 @@
 
 			/* Apalis MMC1 */
 			sdmmc3_clk_pa6 {
-				nvidia,pins = "sdmmc3_clk_pa6",
-					      "sdmmc3_cmd_pa7";
+				nvidia,pins = "sdmmc3_clk_pa6";
 				nvidia,function = "sdmmc3";
 				nvidia,pull = <TEGRA_PIN_PULL_NONE>;
 				nvidia,tristate = <TEGRA_PIN_DISABLE>;
 			};
 			sdmmc3_dat0_pb7 {
-				nvidia,pins = "sdmmc3_dat0_pb7",
+				nvidia,pins = "sdmmc3_cmd_pa7",
+					      "sdmmc3_dat0_pb7",
 					      "sdmmc3_dat1_pb6",
 					      "sdmmc3_dat2_pb5",
 					      "sdmmc3_dat3_pb4",
-- 
2.20.1

