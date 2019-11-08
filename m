Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2118F4B2C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732223AbfKHLiJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 06:38:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:51012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732217AbfKHLiI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:08 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8C220869;
        Fri,  8 Nov 2019 11:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213088;
        bh=di6FP3t2dGpX6xM3L7mS/22x0dtDKEQ8IHSmiLUVGBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6SCAxeeIh7IrIlo/noD7LkohzBwwByjk5OQtc0LjZKEOZG49WnsKdQnp6NQXmywy
         XKImO9aUyuCahTzyctfp0ulm72ihoBnGjpL17FMgk97PdB7B5fGsz1psPjCb8eBCDh
         ZXmcuvBCdd0zb3//9UtBsXYYWuO2c82K243zb1to=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aapo Vienamo <avienamo@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 013/205] arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply
Date:   Fri,  8 Nov 2019 06:34:40 -0500
Message-Id: <20191108113752.12502-13-sashal@kernel.org>
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

From: Aapo Vienamo <avienamo@nvidia.com>

[ Upstream commit 6ff7705da8806de45ca1490194f0b4eb07725804 ]

On p2180 sdmmc4 is powered from a fixed 1.8 V regulator.

Signed-off-by: Aapo Vienamo <avienamo@nvidia.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index 7398ae8856dc0..ccaa555180dc0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -282,6 +282,7 @@
 		status = "okay";
 		bus-width = <8>;
 		non-removable;
+		vqmmc-supply = <&vdd_1v8>;
 	};
 
 	clocks {
-- 
2.20.1

