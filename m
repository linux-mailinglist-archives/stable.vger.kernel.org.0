Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E869729A0ED
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409333AbgJZXvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409146AbgJZXvK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:51:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FF98218AC;
        Mon, 26 Oct 2020 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756270;
        bh=B9H6nK9D552MIy0BT6AhHHXsPhBe/o6i0H01te9IGSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w3w7KOI+x+hkvSDClbTMEMtQ5M7a+MVBd64tNQ7EFHZwu+oVdvClRTLDuMCnMc9Mx
         vv8EuxLBJQ78AfOcORIpXzNjVcaccnTk7TPFTHhAeHSGyzfd7duyf58jAArO1AVzZC
         qiauBicP3b5ibJNnegJB2Sns6G3F02AGi2vhhebs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.9 102/147] ARC: [dts] fix the errors detected by dtbs_check
Date:   Mon, 26 Oct 2020 19:48:20 -0400
Message-Id: <20201026234905.1022767-102-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026234905.1022767-1-sashal@kernel.org>
References: <20201026234905.1022767-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 05b1be68c4d6d76970025e6139bfd735c2256ee5 ]

xxx/arc/boot/dts/axs101.dt.yaml: dw-apb-ictl@e0012000: $nodename:0: \
'dw-apb-ictl@e0012000' does not match '^interrupt-controller(@[0-9a-f,]+)*$'
 From schema: xxx/interrupt-controller/snps,dw-apb-ictl.yaml

The node name of the interrupt controller must start with
"interrupt-controller" instead of "dw-apb-ictl".

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/boot/dts/axc001.dtsi         | 2 +-
 arch/arc/boot/dts/axc003.dtsi         | 2 +-
 arch/arc/boot/dts/axc003_idu.dtsi     | 2 +-
 arch/arc/boot/dts/vdk_axc003.dtsi     | 2 +-
 arch/arc/boot/dts/vdk_axc003_idu.dtsi | 2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arc/boot/dts/axc001.dtsi b/arch/arc/boot/dts/axc001.dtsi
index 79ec27c043c1d..2a151607b0805 100644
--- a/arch/arc/boot/dts/axc001.dtsi
+++ b/arch/arc/boot/dts/axc001.dtsi
@@ -91,7 +91,7 @@ arcpct0: pct {
 	 * avoid duplicating the MB dtsi file given that IRQ from
 	 * this intc to cpu intc are different for axs101 and axs103
 	 */
-	mb_intc: dw-apb-ictl@e0012000 {
+	mb_intc: interrupt-controller@e0012000 {
 		#interrupt-cells = <1>;
 		compatible = "snps,dw-apb-ictl";
 		reg = < 0x0 0xe0012000 0x0 0x200 >;
diff --git a/arch/arc/boot/dts/axc003.dtsi b/arch/arc/boot/dts/axc003.dtsi
index ac8e1b463a709..cd1edcf4f95ef 100644
--- a/arch/arc/boot/dts/axc003.dtsi
+++ b/arch/arc/boot/dts/axc003.dtsi
@@ -129,7 +129,7 @@ mmc@15000 {
 	 * avoid duplicating the MB dtsi file given that IRQ from
 	 * this intc to cpu intc are different for axs101 and axs103
 	 */
-	mb_intc: dw-apb-ictl@e0012000 {
+	mb_intc: interrupt-controller@e0012000 {
 		#interrupt-cells = <1>;
 		compatible = "snps,dw-apb-ictl";
 		reg = < 0x0 0xe0012000 0x0 0x200 >;
diff --git a/arch/arc/boot/dts/axc003_idu.dtsi b/arch/arc/boot/dts/axc003_idu.dtsi
index 9da21e7fd246f..70779386ca796 100644
--- a/arch/arc/boot/dts/axc003_idu.dtsi
+++ b/arch/arc/boot/dts/axc003_idu.dtsi
@@ -135,7 +135,7 @@ mmc@15000 {
 	 * avoid duplicating the MB dtsi file given that IRQ from
 	 * this intc to cpu intc are different for axs101 and axs103
 	 */
-	mb_intc: dw-apb-ictl@e0012000 {
+	mb_intc: interrupt-controller@e0012000 {
 		#interrupt-cells = <1>;
 		compatible = "snps,dw-apb-ictl";
 		reg = < 0x0 0xe0012000 0x0 0x200 >;
diff --git a/arch/arc/boot/dts/vdk_axc003.dtsi b/arch/arc/boot/dts/vdk_axc003.dtsi
index f8be7ba8dad49..c21d0eb07bf67 100644
--- a/arch/arc/boot/dts/vdk_axc003.dtsi
+++ b/arch/arc/boot/dts/vdk_axc003.dtsi
@@ -46,7 +46,7 @@ debug_uart: dw-apb-uart@5000 {
 
 	};
 
-	mb_intc: dw-apb-ictl@e0012000 {
+	mb_intc: interrupt-controller@e0012000 {
 		#interrupt-cells = <1>;
 		compatible = "snps,dw-apb-ictl";
 		reg = < 0xe0012000 0x200 >;
diff --git a/arch/arc/boot/dts/vdk_axc003_idu.dtsi b/arch/arc/boot/dts/vdk_axc003_idu.dtsi
index 0afa3e53a4e39..4d348853ac7c5 100644
--- a/arch/arc/boot/dts/vdk_axc003_idu.dtsi
+++ b/arch/arc/boot/dts/vdk_axc003_idu.dtsi
@@ -54,7 +54,7 @@ debug_uart: dw-apb-uart@5000 {
 
 	};
 
-	mb_intc: dw-apb-ictl@e0012000 {
+	mb_intc: interrupt-controller@e0012000 {
 		#interrupt-cells = <1>;
 		compatible = "snps,dw-apb-ictl";
 		reg = < 0xe0012000 0x200 >;
-- 
2.25.1

