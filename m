Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494D0A8B00
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733004AbfIDQB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:36858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733000AbfIDQB2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B79523402;
        Wed,  4 Sep 2019 16:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612887;
        bh=vXaRYenn3fpJc/5HchT0ZUQjlU+0iYGXGNJoMVlceuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XiG42G0OTzEeiW3O/eRBV2sCSu3m8KfdpYqilH9YgzRyZ3hHAgvzdX3mUMUky/CWf
         jY38EPifdZMEc193QcMywJ7QHZoWuZU96i8NpvJA7/lKdJM1tzyQU67ZLJscc5EfzJ
         vDRw4foAfOTmUlki6lhrveim+05I52qZLS5mMv7A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Faiz Abbas <faiz_abbas@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 04/36] ARM: dts: dra74x: Fix iodelay configuration for mmc3
Date:   Wed,  4 Sep 2019 12:00:50 -0400
Message-Id: <20190904160122.4179-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160122.4179-1-sashal@kernel.org>
References: <20190904160122.4179-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Faiz Abbas <faiz_abbas@ti.com>

[ Upstream commit 07f9a8be66a9bd86f9eaedf8f8aeb416195adab8 ]

According to the latest am572x[1] and dra74x[2] data manuals, mmc3
default, hs, sdr12 and sdr25 modes use iodelay values given in
MMC3_MANUAL1. Set the MODE_SELECT bit for these so that manual mode is
selected and correct iodelay values can be configured.

[1] http://www.ti.com/lit/ds/symlink/am5728.pdf
[2] http://www.ti.com/lit/ds/symlink/dra746.pdf

Signed-off-by: Faiz Abbas <faiz_abbas@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi | 50 +++++++++++------------
 1 file changed, 25 insertions(+), 25 deletions(-)

diff --git a/arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi b/arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi
index 28ebb4eb884a9..214b9e6de2c35 100644
--- a/arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi
+++ b/arch/arm/boot/dts/dra74x-mmc-iodelay.dtsi
@@ -32,7 +32,7 @@
  *
  * Datamanual Revisions:
  *
- * AM572x Silicon Revision 2.0: SPRS953B, Revised November 2016
+ * AM572x Silicon Revision 2.0: SPRS953F, Revised May 2019
  * AM572x Silicon Revision 1.1: SPRS915R, Revised November 2016
  *
  */
@@ -229,45 +229,45 @@
 
 	mmc3_pins_default: mmc3_pins_default {
 		pinctrl-single,pins = <
-			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
-			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
-			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
-			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
-			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
-			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
+			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
+			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
+			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
+			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
+			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
+			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
 		>;
 	};
 
 	mmc3_pins_hs: mmc3_pins_hs {
 		pinctrl-single,pins = <
-			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
-			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
-			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
-			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
-			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
-			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
+			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
+			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
+			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
+			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
+			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
+			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
 		>;
 	};
 
 	mmc3_pins_sdr12: mmc3_pins_sdr12 {
 		pinctrl-single,pins = <
-			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
-			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
-			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
-			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
-			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
-			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
+			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
+			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
+			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
+			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
+			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
+			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
 		>;
 	};
 
 	mmc3_pins_sdr25: mmc3_pins_sdr25 {
 		pinctrl-single,pins = <
-			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
-			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
-			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
-			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
-			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
-			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
+			DRA7XX_CORE_IOPAD(0x377c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_clk.mmc3_clk */
+			DRA7XX_CORE_IOPAD(0x3780, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_cmd.mmc3_cmd */
+			DRA7XX_CORE_IOPAD(0x3784, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat0.mmc3_dat0 */
+			DRA7XX_CORE_IOPAD(0x3788, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat1.mmc3_dat1 */
+			DRA7XX_CORE_IOPAD(0x378c, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat2.mmc3_dat2 */
+			DRA7XX_CORE_IOPAD(0x3790, (PIN_INPUT_PULLUP | MODE_SELECT | MUX_MODE0)) /* mmc3_dat3.mmc3_dat3 */
 		>;
 	};
 
-- 
2.20.1

