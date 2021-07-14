Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E1B93C8C97
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233582AbhGNTmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234258AbhGNTly (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:41:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AED7C61370;
        Wed, 14 Jul 2021 19:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291541;
        bh=tkbnrYTRku90PmRyB2CpW7EvmcO8ivAcS/EzWo9+h1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBMyxmHeB7e2v7TtM3TnucAi32aPKEpRTjMnPAm0prtjCPM7h22xAFb0rShL3God8
         4FIWHFnKMyij7lHDej7IUlhSUfX+1g56chUoppqkxbrgE0C+uQE4/nuH+qpS2LA4R+
         WqZ4Lu9lJhz007TwXbH8qth3ub+XnyIVJH2yJrmUpU5CbHMdC8PLqeRuU4m91TCRhr
         xoi2SEPAWFFiEMhFh3GKkoe0C9rI2UtuVtqr7G9BGuZd2iShDtvsqZN+IBxMyHziAd
         ZaMP4dKp3U5EpoQ9xrS/RZyWYrfVBJrfrL7NHY5fEQdKz8CQZw+HIvbgW7OLpvuWcT
         Y4BZmDNREqvLQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 042/108] ARM: dts: omap3: align gpio hog names with dt-schema
Date:   Wed, 14 Jul 2021 15:36:54 -0400
Message-Id: <20210714193800.52097-42-sashal@kernel.org>
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

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit cfb4ab3b5df86c6001127346d8331f5e87012f91 ]

The GPIO Hog dt-schema node naming convention expect GPIO hogs node names
to end with a 'hog' suffix.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap3-evm-processor-common.dtsi | 2 +-
 arch/arm/boot/dts/omap3-gta04a5.dts               | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/omap3-evm-processor-common.dtsi b/arch/arm/boot/dts/omap3-evm-processor-common.dtsi
index b4109f48ec18..e6ba30a21166 100644
--- a/arch/arm/boot/dts/omap3-evm-processor-common.dtsi
+++ b/arch/arm/boot/dts/omap3-evm-processor-common.dtsi
@@ -195,7 +195,7 @@ &uart3 {
  * for bus switch SN74CB3Q3384A, level-shifter SN74AVC16T245DGGR, and 1.8V.
  */
 &gpio2 {
-	en_usb2_port {
+	en-usb2-port-hog {
 		gpio-hog;
 		gpios = <29 GPIO_ACTIVE_HIGH>;	/* gpio_61 */
 		output-low;
diff --git a/arch/arm/boot/dts/omap3-gta04a5.dts b/arch/arm/boot/dts/omap3-gta04a5.dts
index fd84bbf3b9cc..9ce8d81250aa 100644
--- a/arch/arm/boot/dts/omap3-gta04a5.dts
+++ b/arch/arm/boot/dts/omap3-gta04a5.dts
@@ -37,7 +37,7 @@ pps {
 };
 
 &gpio5 {
-	irda_en {
+	irda-en-hog {
 		gpio-hog;
 		gpios = <(175-160) GPIO_ACTIVE_HIGH>;
 		output-high;	/* activate gpio_175 to disable IrDA receiver */
-- 
2.30.2

