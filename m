Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 638D03C8E1B
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237077AbhGNTqf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:46:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37098 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236558AbhGNTp4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:45:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F86261404;
        Wed, 14 Jul 2021 19:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291737;
        bh=1dAUiCV8RZ3na6Q4TsF8CKkJ/0h5oRkuovNOqnr14dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dskQIDVF1QzsL83SWSj7XxoZdw0khtUtM+YwgWCqsLgnR0J81VZRMJJafJdve5rZi
         WUPOVLRQ9LIKtmFuK2j2U9bZX/CJXhGGrvas/fUQ9Qe7cIImgxGFO5qvuPpgv1Tpvq
         HZdRK5frpl1yE0v9xiWQQnISgLlwfzA6eGGL6pleTeTxSZC/9rVNdRJFP0/Vp03GCC
         dgvIk4g00LZGWx+C+QtDeKuRzBMFh891I8Vn/i62JdzhEx+Wxprozy0ZVQ0AP5J9F1
         JjyYVLnud3L++8XVbIPozJ3i4C7Zzn+gS++lfN1D8FVz1FPqIqRA+33/XjPaqZ+GWW
         oc/ZyDUzZXSnQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grzegorz Szymaszek <gszymaszek@short.pl>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.12 071/102] ARM: dts: stm32: fix the Odyssey SoM eMMC VQMMC supply
Date:   Wed, 14 Jul 2021 15:40:04 -0400
Message-Id: <20210714194036.53141-71-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194036.53141-1-sashal@kernel.org>
References: <20210714194036.53141-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grzegorz Szymaszek <gszymaszek@short.pl>

[ Upstream commit f493162319788802b6a49634f7268e691b4c10ec ]

The Seeed SoM-STM32MP157C device tree had the eMMC’s (SDMMC2) VQMMC
supply set to v3v3 (buck4), the same as the VMMC supply. That was
incorrect, as on the SoM, the VQMMC supply is provided from vdd (buck3)
instead.

Signed-off-by: Grzegorz Szymaszek <gszymaszek@short.pl>
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
index 6cf49a0a9e69..b5601d270c8f 100644
--- a/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
+++ b/arch/arm/boot/dts/stm32mp157c-odyssey-som.dtsi
@@ -269,7 +269,7 @@ &sdmmc2 {
 	st,neg-edge;
 	bus-width = <8>;
 	vmmc-supply = <&v3v3>;
-	vqmmc-supply = <&v3v3>;
+	vqmmc-supply = <&vdd>;
 	mmc-ddr-3_3v;
 	status = "okay";
 };
-- 
2.30.2

