Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B0933CE376
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343968AbhGSPii (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:38:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:57422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348739AbhGSPf3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5960061026;
        Mon, 19 Jul 2021 16:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711270;
        bh=6zMoGvdyRiAdL1Rr8Y7Ml0iP5yrtB+TvFUDRV33Trqg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6KmrfY5K6/E5vnM7OGHlPJ7xRnn5mIqfsz+zq4RdmzhWe/0K3IbeilqhlsHpM2wU
         fYee2v93r8a3RyogO1ExWZHndA8EKc0K5eFlRuCsqg3nWJBI8wc9deovXX2lVOT2h3
         0muZcz7v+6XOW8jGYUcol78Q6LVR2/aLk6kLJ2kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aswath Govindraju <a-govindraju@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 292/351] arm64: dts: ti: k3-j7200: Remove "#address-cells" property from GPIO DT nodes
Date:   Mon, 19 Jul 2021 16:53:58 +0200
Message-Id: <20210719144954.697535435@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aswath Govindraju <a-govindraju@ti.com>

[ Upstream commit 6ec8ba764165f6ecb6f6f7efbfd2ec7ad76dedcb ]

GPIO device tree nodes do not have child nodes. Therefore, "#address-cells"
property should not be added.

Fixes: e0b2e6af39ea ("arm64: dts: ti: k3-j7200: Add gpio nodes")
Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
Reviewed-by: Lokesh  Vutla <lokeshvutla@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20210423064758.25520-1-a-govindraju@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j7200-main.dtsi       | 4 ----
 arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi | 2 --
 2 files changed, 6 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
index 19fea8adbcff..7e7169195902 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-main.dtsi
@@ -696,7 +696,6 @@
 			     <149>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <69>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 105 TI_SCI_PD_EXCLUSIVE>;
@@ -714,7 +713,6 @@
 			     <158>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <69>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 107 TI_SCI_PD_EXCLUSIVE>;
@@ -732,7 +730,6 @@
 			     <167>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <69>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 109 TI_SCI_PD_EXCLUSIVE>;
@@ -750,7 +747,6 @@
 			     <176>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <69>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 111 TI_SCI_PD_EXCLUSIVE>;
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index 5663fe3ea466..343449af53fb 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -117,7 +117,6 @@
 		interrupts = <103>, <104>, <105>, <106>, <107>, <108>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <85>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 113 TI_SCI_PD_EXCLUSIVE>;
@@ -134,7 +133,6 @@
 		interrupts = <112>, <113>, <114>, <115>, <116>, <117>;
 		interrupt-controller;
 		#interrupt-cells = <2>;
-		#address-cells = <0>;
 		ti,ngpio = <85>;
 		ti,davinci-gpio-unbanked = <0>;
 		power-domains = <&k3_pds 114 TI_SCI_PD_EXCLUSIVE>;
-- 
2.30.2



