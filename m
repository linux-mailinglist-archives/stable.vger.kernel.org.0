Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3488D44B5C2
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 23:19:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236159AbhKIWWg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 17:22:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:41388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343621AbhKIWVH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Nov 2021 17:21:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D581661241;
        Tue,  9 Nov 2021 22:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636496286;
        bh=dTPb2kXkqqZHHUU/5EsT1jSVWNxZwUWDpuzJjesggv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2GsNNO4McAiDKEGS9M/3CbPCYKX+FQBcJaS/Yb+gaUsOW2W0kmglNU3G9cOI+NN3
         4XDRS41pZIDIv+uUSde420Yb6PQ5jl8SUQZGJm5CiHtAvCHFkVSCsYtfW3fNoBByLd
         LgUGldAscjRUuQAZ3XTka5CI0i8yvtcwq2GPgoyBlxdGKhK5954VbrxB04FeSlor0Q
         3Di6X9vME4wAXQYtqj+NtQNh6S6THgs2HxZ+3POv/k8QBEMbKRryoyZPczKdH276qw
         7ph3CPaAQMFpzUEsIiFI5jpf6jnrxhR31udmRaTmZDBNP93k8gpLPXo8f1sHdOO/1p
         S2Bf/7BeVrd8g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Frieder Schrempf <frieder.schrempf@kontron.de>,
        Heiko Thiery <heiko.thiery@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 45/82] arm64: dts: imx8mm-kontron: Fix reset delays for ethernet PHY
Date:   Tue,  9 Nov 2021 17:16:03 -0500
Message-Id: <20211109221641.1233217-45-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211109221641.1233217-1-sashal@kernel.org>
References: <20211109221641.1233217-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit 315e7b884190a6c9c28e95ad3b724dde9e922b99 ]

According to the datasheet the VSC8531 PHY expects a reset pulse of 100 ns
and a delay of 15 ms after the reset has been deasserted. Set the matching
values in the devicetree.

Reported-by: Heiko Thiery <heiko.thiery@gmail.com>
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
index e99e7644ff392..49d7470812eef 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mm-kontron-n801x-s.dts
@@ -123,8 +123,8 @@
 
 		ethphy: ethernet-phy@0 {
 			reg = <0>;
-			reset-assert-us = <100>;
-			reset-deassert-us = <100>;
+			reset-assert-us = <1>;
+			reset-deassert-us = <15000>;
 			reset-gpios = <&gpio4 27 GPIO_ACTIVE_LOW>;
 		};
 	};
-- 
2.33.0

