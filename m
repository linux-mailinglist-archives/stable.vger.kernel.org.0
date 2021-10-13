Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C03BB42B15B
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 02:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhJMA57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Oct 2021 20:57:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237025AbhJMA5h (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Oct 2021 20:57:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A000E6101B;
        Wed, 13 Oct 2021 00:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634086534;
        bh=WGqMSi+X9Tn4TusslFHMIc2W1zMw8LvoUwt9bs/CBEg=;
        h=From:To:Cc:Subject:Date:From;
        b=ttNCf5PiALrk4vy4lJ/p/7EzGq9fmPuNBudhvAB+jkfzdXyziH8MWr7tZYJ33QOxD
         yOXCDNWV6SXMXF0s/zujTruEUuRnShpaEImQSh5teiZMdlWegd0ejJrpwRlWDEHT/w
         B+OvNk+1eybrRfeboY+VY7XVtbzAs96LSRahA8BkkEBKB7SG3lCpQHr/cTqoTOjAzo
         aaDGLJpu+vURoyH6ajRi4DP7PmrjSU7PFWfhEei8rVGMpZHY3NF2bWtWMPeeqsD48R
         JBkwXr5RFwShkTQ3RtFOcmXy5d+tUwdKInJAUN4P5gEhAbQNdr30+qjH4wihPRg/aj
         Tii/PnBNf9NQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rob Herring <robh@kernel.org>,
        Andre Przywara <andre.przywara@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, liviu.dudau@arm.com,
        lorenzo.pieralisi@arm.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 01/11] arm: dts: vexpress-v2p-ca9: Fix the SMB unit-address
Date:   Tue, 12 Oct 2021 20:55:21 -0400
Message-Id: <20211013005532.700190-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rob Herring <robh@kernel.org>

[ Upstream commit 2e9edc07df2ec6f835222151fa4e536e9e54856a ]

Based on 'ranges', the 'bus@4000000' node unit-address is off by 1 '0'.

Link: https://lore.kernel.org/r/20210819184239.1192395-5-robh@kernel.org
Cc: Andre Przywara <andre.przywara@arm.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/vexpress-v2m.dtsi    | 2 +-
 arch/arm/boot/dts/vexpress-v2p-ca9.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/vexpress-v2m.dtsi b/arch/arm/boot/dts/vexpress-v2m.dtsi
index 2ac41ed3a57c..659dcf4004b4 100644
--- a/arch/arm/boot/dts/vexpress-v2m.dtsi
+++ b/arch/arm/boot/dts/vexpress-v2m.dtsi
@@ -19,7 +19,7 @@
  */
 
 / {
-	bus@4000000 {
+	bus@40000000 {
 		motherboard {
 			model = "V2M-P1";
 			arm,hbi = <0x190>;
diff --git a/arch/arm/boot/dts/vexpress-v2p-ca9.dts b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
index 4c5847955856..1317f0f58d53 100644
--- a/arch/arm/boot/dts/vexpress-v2p-ca9.dts
+++ b/arch/arm/boot/dts/vexpress-v2p-ca9.dts
@@ -295,7 +295,7 @@ power-vd10-s3 {
 		};
 	};
 
-	smb: bus@4000000 {
+	smb: bus@40000000 {
 		compatible = "simple-bus";
 
 		#address-cells = <2>;
-- 
2.33.0

