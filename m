Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D082FA45C
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfKMCQh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:16:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727725AbfKMB41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:56:27 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 362E52245C;
        Wed, 13 Nov 2019 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610187;
        bh=t0LGKsLAIPhyIH2YHKRCrKEsmfB6YyBV3i4SCbgDs0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JfeUayxg1T72Nxabgp03UhBlY2d6feFqhJfVay7ycnCQHKt45qeImd0Sp0sj8nFe6
         ECVnT85OmyDHv+Tw6eGosEiU1G91zWMWo0FgDgZFmo+Pa6cEuJfP+KGqDuk1rX+35Z
         mrPS01GryQvwcYLNBcYUdWvvUxtAPpNmOmsAdmA4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vignesh R <vigneshr@ti.com>, Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 003/115] ARM: dts: dra7: Enable workaround for errata i870 in PCIe host mode
Date:   Tue, 12 Nov 2019 20:54:30 -0500
Message-Id: <20191113015622.11592-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh R <vigneshr@ti.com>

[ Upstream commit b830526f304764753fcb8b4a563a94080e982a6c ]

Add ti,syscon-unaligned-access property to PCIe RC nodes to set
appropriate bits in CTRL_CORE_SMA_SW_7 register to enable workaround for
errata i870.

Signed-off-by: Vignesh R <vigneshr@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/dra7.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index 0bf354024ef55..3af1aa7a3213d 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -314,6 +314,7 @@
 						<0 0 0 2 &pcie1_intc 2>,
 						<0 0 0 3 &pcie1_intc 3>,
 						<0 0 0 4 &pcie1_intc 4>;
+				ti,syscon-unaligned-access = <&scm_conf1 0x14 1>;
 				status = "disabled";
 				pcie1_intc: interrupt-controller {
 					interrupt-controller;
@@ -367,6 +368,7 @@
 						<0 0 0 2 &pcie2_intc 2>,
 						<0 0 0 3 &pcie2_intc 3>,
 						<0 0 0 4 &pcie2_intc 4>;
+				ti,syscon-unaligned-access = <&scm_conf1 0x14 2>;
 				pcie2_intc: interrupt-controller {
 					interrupt-controller;
 					#address-cells = <0>;
-- 
2.20.1

