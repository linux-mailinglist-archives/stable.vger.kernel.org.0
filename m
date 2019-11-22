Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDB581070C7
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbfKVKjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728762AbfKVKjX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:39:23 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DCE920707;
        Fri, 22 Nov 2019 10:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419162;
        bh=dAPt4graksuksjvv/o+AlSO91d3Zkvj/R95vatbllrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1LEwHlNcb+fpuDnq4aVSSD5fiYqMejEzrLg4jing1eBOazoO4FntG0s+UnGHiqQXH
         CeONG/N/50TjHlRx4zj6Zmr+tazAQGVivrPwPjW9YgVGwQ5REJ9e/MKvywuv+BarNY
         fxXhHYoDtiQhU/HlHqrMtRKxa3BEbQONnFXTjtL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aapo Vienamo <avienamo@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 019/222] arm64: dts: tegra210-p2180: Correct sdmmc4 vqmmc-supply
Date:   Fri, 22 Nov 2019 11:25:59 +0100
Message-Id: <20191122100836.382858807@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
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
index 6a51d282ec636..d1e687b4911f5 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -281,6 +281,7 @@
 		status = "okay";
 		bus-width = <8>;
 		non-removable;
+		vqmmc-supply = <&vdd_1v8>;
 	};
 
 	clocks {
-- 
2.20.1



