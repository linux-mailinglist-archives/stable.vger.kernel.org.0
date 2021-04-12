Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4F935CCA3
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244322AbhDLQay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243406AbhDLQ1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:27:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 335F461390;
        Mon, 12 Apr 2021 16:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244711;
        bh=i1Wx5hmIaR7cNqdJ9tSqagyL5Pa9hXX/UqDudDLyz24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGe8Vug2zFETyEAEYkl+yfNLHNlVu9htUz90SGRF/TpUChdQ8nvakEkjjDU+yjhB/
         LjjUwFSyUK1yv/KG6UOZ4xoyOBaiI4eW3B3Iy1Kde0ZV355WPGcKdmQuvFMk1trHyU
         C2DO4Nn1c5rRrCi+SOzV1qtDGQpMTEE4vVPAlinJBSXQoJDIAbSZUE1VHX0kXB3hdS
         llUeFVcbJEy+XjOLhfgq9lndVt9vxPioW0RXlZ/ckR/YIKZZirnS0V5o3hK2i8PQzb
         Vpj4JrAKZ50kVWflAx9yuP1FhM/yqjjsWWYooTsK+KHyyPdCMgG/kO5RYFsTddnjvC
         A4cQ2o91J+Opw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/39] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 12 Apr 2021 12:24:29 -0400
Message-Id: <20210412162502.314854-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162502.314854-1-sashal@kernel.org>
References: <20210412162502.314854-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 77335a040178a0456d4eabc8bf17a7ca3ee4a327 ]

Fix moving mmc devices with dts aliases as discussed on the lists.
Without this we now have internal eMMC mmc1 show up as mmc2 compared
to the earlier order of devices.

Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap4.dtsi | 5 +++++
 arch/arm/boot/dts/omap5.dtsi | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index 904852006b9b..0a36b8fe3fa9 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -22,6 +22,11 @@ aliases {
 		i2c1 = &i2c2;
 		i2c2 = &i2c3;
 		i2c3 = &i2c4;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
+		mmc3 = &mmc4;
+		mmc4 = &mmc5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 041646fabb2d..3b56e993326d 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -25,6 +25,11 @@ aliases {
 		i2c2 = &i2c3;
 		i2c3 = &i2c4;
 		i2c4 = &i2c5;
+		mmc0 = &mmc1;
+		mmc1 = &mmc2;
+		mmc2 = &mmc3;
+		mmc3 = &mmc4;
+		mmc4 = &mmc5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
2.30.2

