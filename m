Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41263404E52
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbhIIMLE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350367AbhIIMHr (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:07:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73D9161205;
        Thu,  9 Sep 2021 11:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188071;
        bh=p+sAzM/XDE2JhZloIqQUgcKpO2Gb1o+zgmF5bat62yk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Va78L2sd5Havz0l0xX2cwATyYBcJAka7SOJlwDUVtdwLVLxvCGaZU66hrwtpZIiz7
         CIivdZS8Z31NHrHqTPByy8FlOOxLpDH2r6xcfuCntxTTv8uQNjf8P1Nl8FFqS9Ct1d
         vYLzh+V0b+P0BY9J05/LiqhmXn+GXDWyoy75WFfjt6xLQTV3sADe0rWgpGzg/pkY+P
         XC3tH9c13CO1dfLhB6ujsc7I7VKPTXtAfzchzP6/3HEfQN91TABlp4SOaLy6PJjwe6
         mprjbnWHYMJweWMxze3YAPaKD8QIfl/ieXi/+VvP+YLwOaE1nGP4P8+wWAnv3yno1S
         OqlI0caKpF08Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jernej Skrabec <jernej.skrabec@gmail.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev
Subject: [PATCH AUTOSEL 5.13 058/219] arm64: dts: allwinner: h6: tanix-tx6: Fix regulator node names
Date:   Thu,  9 Sep 2021 07:43:54 -0400
Message-Id: <20210909114635.143983-58-sashal@kernel.org>
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

From: Jernej Skrabec <jernej.skrabec@gmail.com>

[ Upstream commit 7ab1f6539762946de06ca14d7401ae123821bc40 ]

Regulator node names don't reflect class of the device. Fix that by
prefixing names with "regulator-".

Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://lore.kernel.org/r/20210722161220.51181-2-jernej.skrabec@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
index be81330db14f..02641191682e 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
+++ b/arch/arm64/boot/dts/allwinner/sun50i-h6-tanix-tx6.dts
@@ -32,14 +32,14 @@ hdmi_con_in: endpoint {
 		};
 	};
 
-	reg_vcc3v3: vcc3v3 {
+	reg_vcc3v3: regulator-vcc3v3 {
 		compatible = "regulator-fixed";
 		regulator-name = "vcc3v3";
 		regulator-min-microvolt = <3300000>;
 		regulator-max-microvolt = <3300000>;
 	};
 
-	reg_vdd_cpu_gpu: vdd-cpu-gpu {
+	reg_vdd_cpu_gpu: regulator-vdd-cpu-gpu {
 		compatible = "regulator-fixed";
 		regulator-name = "vdd-cpu-gpu";
 		regulator-min-microvolt = <1135000>;
-- 
2.30.2

