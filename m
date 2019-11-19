Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6678710138A
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728310AbfKSFZF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:25:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728323AbfKSFZE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:25:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD56F21783;
        Tue, 19 Nov 2019 05:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141104;
        bh=di6FP3t2dGpX6xM3L7mS/22x0dtDKEQ8IHSmiLUVGBQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMFykn0Y9S0gdyNSgvwpmcxHzpqwSZfMSqzYKsrYcb+ZPjX/oeOG1nXvVzqmWn4jI
         RIOXtBsFQSmOHvrWGjJwwSB0Hbi/j9D/leTIYH4P/DCFtcsJkh147fve1Dw0tSqFHb
         qUZ7tZz78/qj8s58BaRzTEVVeNpbSpEx2Do16pGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aapo Vienamo <avienamo@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/422] arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply
Date:   Tue, 19 Nov 2019 06:14:02 +0100
Message-Id: <20191119051402.817575453@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
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



