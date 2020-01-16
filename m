Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0133013F813
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbgAPTOu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:14:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:42538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733207AbgAPQ4S (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:18 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 402FD24687;
        Thu, 16 Jan 2020 16:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193777;
        bh=pRkhybkngEnr4gOAuE3FOmVM9pUynr3Wp6eubVhRKl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=owHF4+pZgP2xm8he0tnCNYc8vYSXD9fi3zT5/06oLHat48aomyUhv+b48bXnayEvu
         Axs4P59TsIw53E5EGutBV8bToWh3zRsW9YMMyo/LTZcSyNU0Tyy3/rKo0qZFzmF+ym
         LEfMcT9NNRxUNqSMT6B0O/qBZSBdRceqIuwbgM3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 058/671] arm64: dts: renesas: r8a7795-es1: Add missing power domains to IPMMU nodes
Date:   Thu, 16 Jan 2020 11:44:49 -0500
Message-Id: <20200116165502.8838-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 41e30b515a003a90e336b7a456c7c82d8c3aa6a7 ]

While commit 3b7e7848f0e88b36 ("arm64: dts: renesas: r8a7795: Add IPMMU
device nodes") for R-Car H3 ES2.0 did include power-domains properties,
they were forgotten in the counterpart for older R-Car H3 ES1.x SoCs.

Fixes: e4b9a493df45075b ("arm64: dts: renesas: r8a7795-es1: Add IPMMU device nodes")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi b/arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi
index 7b2fbaec9aef..3dc61b7e1d08 100644
--- a/arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a7795-es1.dtsi
@@ -28,6 +28,7 @@
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xec680000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 5>;
+		power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
 		#iommu-cells = <1>;
 	};
 
@@ -35,6 +36,7 @@
 		compatible = "renesas,ipmmu-r8a7795";
 		reg = <0 0xe7730000 0 0x1000>;
 		renesas,ipmmu-main = <&ipmmu_mm 8>;
+		power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
 		#iommu-cells = <1>;
 	};
 
-- 
2.20.1

