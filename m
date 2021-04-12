Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEE835CD82
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244780AbhDLQhQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:37:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:37286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343702AbhDLQfo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:35:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2805E613DB;
        Mon, 12 Apr 2021 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244827;
        bh=9b2V3+CRrNAQut/L4vZTItfFISREdW2EYAAO7ZLvY7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHcSiexQ4PubOHbSZo3pUEzMoqTbK4rSF5JYiQPCmbnIp7lUwknAvWQA+wBkYeHrM
         CvE1oASrn6m0lIquOnI2zbSuybYprgC5NX8UaOJEAgUhjVSCev4gCaCP1mhN1wO5/o
         uAU7clLoZkPl65ONd8DngFxRVjjRWmMz9WJ+l6AwRfYxCcIh+EVg4c6znFREPhdu11
         E4Ytm2GScMiXZHGvb8eR+ODQRzMyKyaTd1ZDTw+Z86+d+R/62pXFMVeZHiN5baH4JD
         hW43kcGyHgR0BnFki7Lh+dYi4xsv1k0rAWdW0k1ez8JVHSlZ++9xqEf94p76V8xYxj
         BiaB/32wwRQRg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 02/23] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 12 Apr 2021 12:26:43 -0400
Message-Id: <20210412162704.315783-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162704.315783-1-sashal@kernel.org>
References: <20210412162704.315783-1-sashal@kernel.org>
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
index 4d6584f15b17..7e5a09c3d2a6 100644
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
index a76266f242a1..586fe60b9921 100644
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

