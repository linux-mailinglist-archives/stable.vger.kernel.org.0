Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE1BF4999
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389780AbfKHLmG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:42:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389769AbfKHLmF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:42:05 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4752F21D82;
        Fri,  8 Nov 2019 11:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213325;
        bh=xOtDzkhUjWvNRIE+cw+dW0K6vbxuhfoT/WYH8izDoCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yzM/i+MRIwzcICvMcwgFRTgXnXpO2xsvxP4dSMXYynyzfszjb0JR3pkdhOQhTgyY9
         7hO4Uo++sXZuoB9CpMu4cUZEqPbo+roeIcPI0Z8EQQ6Ba3UNWoD19R2NaZIVAFmzTr
         TWB05034Rf9JEcNfPBygR6LRg4LVZuPKPNFdOpUM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Magnus Damm <damm+renesas@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 167/205] arm64: dts: renesas: r8a77965: Attach the SYS-DMAC to the IPMMU
Date:   Fri,  8 Nov 2019 06:37:14 -0500
Message-Id: <20191108113752.12502-167-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Damm <damm+renesas@opensource.se>

[ Upstream commit 4d76ad7d9de05506f1ee9a7b22416440468be090 ]

For R-Car M3-N hook up SYS-DMAC0, SYS-DMAC1 and SYS-DMAC2 to
IPMMU-DS0 and IPMMU-DS1 in same way as for R-Car M3-W.
This follows the R-Car Gen3 Rev.1.00 (April 2018) datasheet.

Signed-off-by: Magnus Damm <damm+renesas@opensource.se>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77965.dtsi | 24 +++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a77965.dtsi b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
index f60f08ba1a6f9..0da4841162610 100644
--- a/arch/arm64/boot/dts/renesas/r8a77965.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77965.dtsi
@@ -634,6 +634,14 @@
 			resets = <&cpg 219>;
 			#dma-cells = <1>;
 			dma-channels = <16>;
+			iommus = <&ipmmu_ds0 0>, <&ipmmu_ds0 1>,
+			       <&ipmmu_ds0 2>, <&ipmmu_ds0 3>,
+			       <&ipmmu_ds0 4>, <&ipmmu_ds0 5>,
+			       <&ipmmu_ds0 6>, <&ipmmu_ds0 7>,
+			       <&ipmmu_ds0 8>, <&ipmmu_ds0 9>,
+			       <&ipmmu_ds0 10>, <&ipmmu_ds0 11>,
+			       <&ipmmu_ds0 12>, <&ipmmu_ds0 13>,
+			       <&ipmmu_ds0 14>, <&ipmmu_ds0 15>;
 		};
 
 		dmac1: dma-controller@e7300000 {
@@ -668,6 +676,14 @@
 			resets = <&cpg 218>;
 			#dma-cells = <1>;
 			dma-channels = <16>;
+			iommus = <&ipmmu_ds1 0>, <&ipmmu_ds1 1>,
+			       <&ipmmu_ds1 2>, <&ipmmu_ds1 3>,
+			       <&ipmmu_ds1 4>, <&ipmmu_ds1 5>,
+			       <&ipmmu_ds1 6>, <&ipmmu_ds1 7>,
+			       <&ipmmu_ds1 8>, <&ipmmu_ds1 9>,
+			       <&ipmmu_ds1 10>, <&ipmmu_ds1 11>,
+			       <&ipmmu_ds1 12>, <&ipmmu_ds1 13>,
+			       <&ipmmu_ds1 14>, <&ipmmu_ds1 15>;
 		};
 
 		dmac2: dma-controller@e7310000 {
@@ -702,6 +718,14 @@
 			resets = <&cpg 217>;
 			#dma-cells = <1>;
 			dma-channels = <16>;
+			iommus = <&ipmmu_ds1 16>, <&ipmmu_ds1 17>,
+			       <&ipmmu_ds1 18>, <&ipmmu_ds1 19>,
+			       <&ipmmu_ds1 20>, <&ipmmu_ds1 21>,
+			       <&ipmmu_ds1 22>, <&ipmmu_ds1 23>,
+			       <&ipmmu_ds1 24>, <&ipmmu_ds1 25>,
+			       <&ipmmu_ds1 26>, <&ipmmu_ds1 27>,
+			       <&ipmmu_ds1 28>, <&ipmmu_ds1 29>,
+			       <&ipmmu_ds1 30>, <&ipmmu_ds1 31>;
 		};
 
 		ipmmu_ds0: mmu@e6740000 {
-- 
2.20.1

