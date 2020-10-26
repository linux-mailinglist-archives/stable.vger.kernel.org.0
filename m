Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43338299CC5
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 01:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437351AbgJ0ABo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 20:01:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2411049AbgJZX4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 19:56:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18B2A20B1F;
        Mon, 26 Oct 2020 23:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603756582;
        bh=cWeSsh3qN4L40RKXSAhIjwG++878JP/Vd+vcjn7wHko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n/IDBpwB3AcnAcRS/53emNsurWkvwHxZDSjhGTyJUcYZZjckQVaB7zOjnSvYZDtHH
         fc48a5nu2IHKlxkMKsWEL4c5+cW9A5p2mCsn4HKUAHJXWOtpVBP+QEhUIgn1+Ca4c1
         tkixf0Uo+ylTs1Wewc2PDj1ga0cznqnN3m4PSwGY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhen Lei <thunder.leizhen@huawei.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-snps-arc@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 55/80] ARC: [dts] fix the errors detected by dtbs_check
Date:   Mon, 26 Oct 2020 19:54:51 -0400
Message-Id: <20201026235516.1025100-55-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026235516.1025100-1-sashal@kernel.org>
References: <20201026235516.1025100-1-sashal@kernel.org>
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
index 6ec1fcdfc0d7f..92247288d0562 100644
--- a/arch/arc/boot/dts/axc001.dtsi
+++ b/arch/arc/boot/dts/axc001.dtsi
@@ -85,7 +85,7 @@ arcpct0: pct {
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

