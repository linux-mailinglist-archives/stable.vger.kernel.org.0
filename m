Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2BFFA218
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730773AbfKMCBa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:01:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:57416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730768AbfKMCB3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:01:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAB562247A;
        Wed, 13 Nov 2019 02:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610488;
        bh=/crUOwCOLDRvI/AH1z5HIHAZHy54kr4aKlH4Jtg9IJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1iVzG6IjvkQ0hgTQApNgdAWFFyVTp8/4Lm2O+EnOXxpkqWcYR4h1y2zyKTwQp0VpH
         ZSm9ot/84NifoY2Ng6dK1YmOiHnl1cCnKcTcncuYWg+WXTqWpTJIdrC4cZ5ZufTBn+
         9rCOwmoIDU1qct6byCbjD9qaFAQg037uA8NQtAbA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roger Quadros <rogerq@ti.com>,
        "H . Nikolaus Schaller" <hns@goldelico.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 68/68] ARM: dts: omap5: Fix dual-role mode on Super-Speed port
Date:   Tue, 12 Nov 2019 20:59:32 -0500
Message-Id: <20191113015932.12655-68-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

[ Upstream commit a763ecc15d0e37c3a15ff6825183061209832685 ]

OMAP5's Super-Speed USB port has a software mailbox register
that needs to be fed with VBUS and ID events from an external
VBUS/ID comparator.

Without this, Host role will not work correctly.

Fixes: 656c1a65ab55 ("ARM: dts: omap5: enable OTG role for DWC3 controller")
Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/omap5-board-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap5-board-common.dtsi b/arch/arm/boot/dts/omap5-board-common.dtsi
index 3e9e3d90f2b4f..e412373fe7bfd 100644
--- a/arch/arm/boot/dts/omap5-board-common.dtsi
+++ b/arch/arm/boot/dts/omap5-board-common.dtsi
@@ -695,6 +695,7 @@
 };
 
 &dwc3 {
+	extcon = <&extcon_usb3>;
 	dr_mode = "otg";
 };
 
-- 
2.20.1

