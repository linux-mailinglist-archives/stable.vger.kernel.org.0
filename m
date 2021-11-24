Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C75845D07B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 23:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352310AbhKXWxk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 17:53:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:47542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352275AbhKXWxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 17:53:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6B81610A6;
        Wed, 24 Nov 2021 22:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637794226;
        bh=GtJkvQgjDgLOOPw+F+h4DFhcP/QEVAzW4Ph/OYWKSYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BsshYugqY56SqrHsBkPwEPcO9six0dEJtCdPRVijdrBKzWLRcZ+g6QXoAUUudh73Q
         Auj/186MnJgcaU5uyp2bhfnmsEhbOA5BkEhdF93GgIRsxtRUp0zLSoVMrpn6gibQ1s
         0Gji7+AdpTXKJ8Bbs/wIqJy3Til11tntd44t0yNOb6550EOFW3/ZLvT7tVTeWM1I3q
         B7OE1ROSCvkXUMXYluoc5NjkSNFlmBxq52DZjcQE6dcHZdrxUea3MBq9O3x2aCp3zm
         uWPLSFndr0NUXBOfKgQc4jBmOIernfXF5WtqozjtWc2qbQ7WClrVf03GA5RDIqD3Mi
         xGfehdfrTpmqA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 23/24] arm64: dts: marvell: armada-37xx: declare PCIe reset pin
Date:   Wed, 24 Nov 2021 23:49:32 +0100
Message-Id: <20211124224933.24275-24-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124224933.24275-1-kabel@kernel.org>
References: <20211124224933.24275-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit a5470af981a0cc14a650af8da5186668971a4fc8 upstream.

One pin can be muxed as PCIe endpoint card reset.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Marek Behún <kabel@kernel.org>
---
 arch/arm64/boot/dts/marvell/armada-37xx.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index 257bfa811fe8..a4c81a1c77b7 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -239,6 +239,15 @@
 					function = "mii";
 				};
 
+				pcie_reset_pins: pcie-reset-pins {
+					groups = "pcie1";
+					function = "pcie";
+				};
+
+				pcie_clkreq_pins: pcie-clkreq-pins {
+					groups = "pcie1_clkreq";
+					function = "pcie";
+				};
 			};
 
 			eth0: ethernet@30000 {
-- 
2.32.0

