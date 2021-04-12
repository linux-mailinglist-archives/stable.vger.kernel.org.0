Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D08035CB12
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 18:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243362AbhDLQXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 12:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243300AbhDLQXY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 12:23:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D34B6128E;
        Mon, 12 Apr 2021 16:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244586;
        bh=+1j+c9PZ4Q8nQmQDmwAp0GtCyqnFWmTRzUU2sEKVplc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pISdL64/WYnZ6RtP3IZN2d7a0cmY3Hi2DDs0qRw+XrwS4F8hD8LUS573ltSkXoIBY
         OfQhU5tHgeBiX2Ws1QeMYfz5EtNzo+Y27FSV9AtB6AFX2/2Wgc/WHWMn89Fle8Hlbr
         Zp+qL1CxqXqq2axWzQlWSUOIqFypD54Hx7b1HQ52O/Yy60GFz0D2T8O5kfmCaSFXej
         OTM9QhWLheE23bYUekIcbFxObLHyHgmvuOnmJkNR0DWYwUzFJYcXElSDgE+MJjYNo1
         +dZjHxcBKB06FtQ0j6oJnjGd7RrJ3gxuzRZKd6Y2yVke8QaXwm0454oOrbhKUmZ2S3
         VJn62+gtpl3Ug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>, Sasha Levin <sashal@kernel.org>,
        linux-omap@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 07/51] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 12 Apr 2021 12:22:12 -0400
Message-Id: <20210412162256.313524-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162256.313524-1-sashal@kernel.org>
References: <20210412162256.313524-1-sashal@kernel.org>
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
index 72e4f6481776..4a9f9496a867 100644
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
index 5f1a8bd13880..c303510dfa97 100644
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

