Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8E8A35CE66
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243397AbhDLQnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:38904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344016AbhDLQge (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:36:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8350961365;
        Mon, 12 Apr 2021 16:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244860;
        bh=43ByTj1TtA9C7uUQIQgAE+yxiQ5TBqLuQvRWbJLOK7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsdNmJAR2ln9GGAqBkRFChQRcK8HqiCNF0LAztMT0r3KtDpwKw7zZ0UQpS2brNZ25
         +l8kpS72RJdFP74U/CEtms+2tw5pGsbfJyz1GenayT5/d3eUVShepz8URlaLqOmIrr
         o7YEdhRdPVMSolY5TNfG4kx9x3KC7mnJuUU5pH8dlKLyBCAg/qaKsqRIFCMyuy4+6v
         v8vem2g9jEjkFRVWNmkDzagOmW+Y/yvaneFLoP3I2aXnC8s22QApUIeMEMqutEK1aV
         GziqvMpRudRdDeDAp3q8CjDwrUczlVDKkpO+OLFWoYqLfxcDo667zeAmo9ea0/T0+O
         a3reJkrpUv3hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/23] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 12 Apr 2021 12:27:15 -0400
Message-Id: <20210412162736.316026-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162736.316026-1-sashal@kernel.org>
References: <20210412162736.316026-1-sashal@kernel.org>
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
index 8a5628c4b135..656e35ec037d 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -21,6 +21,11 @@ aliases {
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
index 4c04389dab32..b61ea6ca59b3 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -26,6 +26,11 @@ aliases {
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

