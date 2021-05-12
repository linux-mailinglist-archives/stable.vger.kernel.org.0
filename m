Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 802DB37CC1D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243096AbhELQkS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:50408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242300AbhELQeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:34:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B35E261CB8;
        Wed, 12 May 2021 15:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835157;
        bh=czba1O3f8DdxdcMu9Ui51dC0kuE4KwmwKkpBArbdbMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YaLiOsmwNSTpwUJCYBAcsvUP5bdmEnw8OZqRXHUrsRnaEoAmelP+nTbkNoUvfE4js
         KbmJNqfkuf4Jf0UE6Bq+Dy870CPEbQvNRno0Z2QjRqx1JH2ZPa4UOnhBG11nxkNW1q
         n2dgQVccoGybFkVMnxLZph57fVKyAO37KKGOKt74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 232/677] arm64: dts: renesas: r8a779a0: Fix PMU interrupt
Date:   Wed, 12 May 2021 16:44:38 +0200
Message-Id: <20210512144844.947211723@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit bbbf6db5a0b56199702bb225132831bced2eee41 ]

Should use PPI No.7 for the PMU. Otherwise, the perf command didn't
show any information.

Fixes: 834c310f5418 ("arm64: dts: renesas: Add Renesas R8A779A0 SoC support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Link: https://lore.kernel.org/r/20210325041949.925777-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
index dfd6ae8b564f..86ac48e2c849 100644
--- a/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779a0.dtsi
@@ -60,10 +60,7 @@
 
 	pmu_a76 {
 		compatible = "arm,cortex-a76-pmu";
-		interrupts-extended = <&gic GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>,
-				      <&gic GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
-				      <&gic GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
-				      <&gic GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>;
+		interrupts-extended = <&gic GIC_PPI 7 IRQ_TYPE_LEVEL_LOW>;
 	};
 
 	/* External SCIF clock - to be overridden by boards that provide it */
-- 
2.30.2



