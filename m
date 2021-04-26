Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E95336AD08
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232297AbhDZHcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232280AbhDZHcC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:32:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F7736105A;
        Mon, 26 Apr 2021 07:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422280;
        bh=cozPDNfZ1ilLtxabbov4dYohEi27shFb6gSZS/63Wfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDxj4sPVSXEMxy2yHbXsnhWpZ+HI4bzrX1duMqEOSYBCcWCwBZ2zJ9iZjUlicZQBk
         HQIke4+MMdtfJpwW1Po1JmWDl9GoFNArD+1z15JcYOa5MGYHdRvFM1+yEb4e4vLzm/
         2Z+zzCXGTgwMCZIIaXmQ2/mHgoVs/fcjjuQCrYdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 04/32] ARM: dts: Fix moving mmc devices with aliases for omap4 & 5
Date:   Mon, 26 Apr 2021 09:29:02 +0200
Message-Id: <20210426072816.749255331@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.574319312@linuxfoundation.org>
References: <20210426072816.574319312@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -21,6 +21,11 @@
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
@@ -26,6 +26,11 @@
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



