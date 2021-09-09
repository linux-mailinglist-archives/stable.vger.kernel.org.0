Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69023404F58
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350282AbhIIMSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:18:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352894AbhIIMPU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:15:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C8E2561A4F;
        Thu,  9 Sep 2021 11:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188169;
        bh=coTEE2e2se+Ci9VeyJk1DGFCnuhSlS+Wd/wPEjybggM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HO3a0Xd9NE5MQaRC954jm3yWAkdcvQTYO9wORBeFhBjChbZj6O9f7RjpgxvVDWElm
         gWzgV2hJNbWsl/aBrS7FWhOpsQccIaIT5/MA5eTXyN2VsfYXB+r231SF6JArOgPFv2
         8E3suqEhqQG3QX8vHYqmpaBs+Hxl9NYGetHTykDjhC3AmUU1DhEZ++oGA75mOicZ5f
         hpqT17eM+QQ75lmTMDrZl8zm5o9KiGciFKDVeytjpASccUI7gNejiNnvz18Bt9iY5u
         YFOOdK4WiDlFQBmLSujA6r+NpFtD7XsHf3sQa8xK7HPB5xlGNHmbwnQHZD0xgriG04
         GRUGCI8L7Hm4w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 134/219] arm64: tegra: Fix compatible string for Tegra132 CPUs
Date:   Thu,  9 Sep 2021 07:45:10 -0400
Message-Id: <20210909114635.143983-134-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

[ Upstream commit f865d0292ff3c0ca09414436510eb4c815815509 ]

The documented compatible string for the CPUs found on Tegra132 is
"nvidia,tegra132-denver", rather than the previously used compatible
string "nvidia,denver".

Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra132.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra132.dtsi b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
index 9928a87f593a..b0bcda8cc51f 100644
--- a/arch/arm64/boot/dts/nvidia/tegra132.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra132.dtsi
@@ -1227,13 +1227,13 @@ cpus {
 
 		cpu@0 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <0>;
 		};
 
 		cpu@1 {
 			device_type = "cpu";
-			compatible = "nvidia,denver";
+			compatible = "nvidia,tegra132-denver";
 			reg = <1>;
 		};
 	};
-- 
2.30.2

