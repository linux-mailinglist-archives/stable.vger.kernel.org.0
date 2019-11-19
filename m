Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10612101757
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727714AbfKSGAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 01:00:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:40710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730919AbfKSFpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:45:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08682218BA;
        Tue, 19 Nov 2019 05:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142305;
        bh=pJGj7HwNlJeJIRu3mkf03IkdEkARpRHmioOZLUOcwtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KKrhxyXeXvmKQX9LiSjOcUrTmmwx/ZWVRdOn6xM2/OSnh9/Bs61DB3jlwOTvyrpux
         4tMVnjr9xPEaZNQZ16zKqqym/z8Of0v2jv9x/6YUiS1wqs5aNqRTyebiBNYck+EPoU
         WBPq37wPi5GcB119+4lJH72W90qpS4HBSocC2Fa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aapo Vienamo <avienamo@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 035/239] arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply
Date:   Tue, 19 Nov 2019 06:17:15 +0100
Message-Id: <20191119051304.241851770@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index f6e6f1e83ba89..be91873c08782 100644
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



