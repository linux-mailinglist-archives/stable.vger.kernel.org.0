Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A044B66D
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344161AbhKIW1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:27:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:48846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344180AbhKIWZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:25:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D016061A3F;
        Tue,  9 Nov 2021 22:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496374;
        bh=qR8ttzQ+HcT95TOU3T643QpXnqN44D8DenWBQhzqmzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y+/hD3xWOBNymo1CV7MRODHoq+Whya6Kc/M1Tfq0+cOu0/9AXW0LNoGYdM5O3+Zwn
         vP0S0hGAsuINKO7A0Xgn9eJGkoWhpSZSs9568S9QdG04ZQ7BFnriOVmNAH5Q34DB8N
         3VRAiy0jdUqwB/LQ62j+npaP0GyWt1C94Yb/Ch0HuMLAlK36nc3Sja5HWuiHbxEjlR
         XoQ2ktSFMiTwNeWFKFAeNEGzarL1as5d899wLDqxMFJzcfRMiHp+m99kk55FeNBYDz
         5YBmhcirBNwDkBNYx44P2LGj+Hq1CedQ/ytCpkX/aX8BlWdEfhJ38BBvkD89sezAgM
         fIfXs4dkNbjiQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthias Brugger <mbrugger@suse.com>,
        Guillaume Gardet <guillaume.gardet@arm.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 14/75] arm64: dts: rockchip: Disable CDN DP on Pinebook Pro
Date:   Tue,  9 Nov 2021 17:18:04 -0500
Message-Id: <20211109221905.1234094-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221905.1234094-1-sashal@kernel.org>
References: <20211109221905.1234094-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Brugger <mbrugger@suse.com>

[ Upstream commit 2513fa5c25d42f55ca5f0f0ab247af7c9fbfa3b1 ]

The CDN DP needs a PHY and a extcon to work correctly. But no extcon is
provided by the device-tree, which leads to an error:
cdn-dp fec00000.dp: [drm:cdn_dp_probe [rockchipdrm]] *ERROR* missing extcon or phy
cdn-dp: probe of fec00000.dp failed with error -22

Disable the CDN DP to make graphic work on the Pinebook Pro.

Reported-by: Guillaume Gardet <guillaume.gardet@arm.com>
Signed-off-by: Matthias Brugger <mbrugger@suse.com>
Link: https://lore.kernel.org/r/20210715164101.11486-1-matthias.bgg@kernel.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
index 2b5f001ff4a61..9e5d07f5712e6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3399-pinebook-pro.dts
@@ -385,10 +385,6 @@
 	};
 };
 
-&cdn_dp {
-	status = "okay";
-};
-
 &cpu_b0 {
 	cpu-supply = <&vdd_cpu_b>;
 };
-- 
2.33.0

