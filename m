Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B85120E76D
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404585AbgF2V5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:56792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726506AbgF2Sfa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C0AB2469D;
        Mon, 29 Jun 2020 15:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443995;
        bh=0J2d8kQPi0mkMtqbYwV3PWKAC3zG/6+wEzFKKm+edqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PkK/kVPUHslPQ8KatTHfXdadXwwqZzOjHW+SO5STDBlx4tC2WNtUTnMdDu9nF2D0u
         YExQQbG2yQUp7HpUNdsC07F9rGG9Frz94/yU6dhMjtGwRSeBV5wJe9BQJvGchuco8o
         7JlFzRSI4Ht1yrY9WCeoNMHAJkAvVtX7ByEHFs5c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Oskar Holmlund <oskar@ohdata.se>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 099/265] ARM: dts: Fix am33xx.dtsi USB ranges length
Date:   Mon, 29 Jun 2020 11:15:32 -0400
Message-Id: <20200629151818.2493727-100-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oskar Holmlund <oskar@ohdata.se>

[ Upstream commit 3f311e8993ed18fb7325373ec0f82a7f8e8be82e ]

AM335x TRM: Table 2-1 defines USBSS - USB Queue Manager in memory region
0x4740 0000 to 0x4740 7FFF.

Looks like the older TRM revisions list the range from 0x5000 to 0x8000
as reserved.

Fixes: 0782e8572ce4 ("ARM: dts: Probe am335x musb with ti-sysc")
Signed-off-by: Oskar Holmlund <oskar@ohdata.se>
[tony@atomide.com: updated comments]
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/am33xx.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
index a35f5052d76f6..be76ded7e4c0c 100644
--- a/arch/arm/boot/dts/am33xx.dtsi
+++ b/arch/arm/boot/dts/am33xx.dtsi
@@ -347,7 +347,7 @@
 			clock-names = "fck";
 			#address-cells = <1>;
 			#size-cells = <1>;
-			ranges = <0x0 0x47400000 0x5000>;
+			ranges = <0x0 0x47400000 0x8000>;
 
 			usb0_phy: usb-phy@1300 {
 				compatible = "ti,am335x-usb-phy";
-- 
2.25.1

