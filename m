Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C7F3CE3BB
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245330AbhGSPkY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:40:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349260AbhGSPfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 694B061002;
        Mon, 19 Jul 2021 16:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711388;
        bh=SD6KaOdEE72yoPpha/X39Wyc5nelJ721zGP6f5rdehc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ySKom2UB3ahw5KCDb1825RPLjKb/NLG7cYFL5j5b9AlXKr6OwDg2NUtWKqBp88hO
         wtxGzv2faUsMhRXRym3hANf3XNeGC0tFOhO5wmBaudFHjPUeNslkuGx3uP127fFJgU
         50NMxVJ3fYVUo23uTAf1te5y3A/rTZM/s6+QzpOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 335/351] arm64: dts: rockchip: Re-add regulator-boot-on, regulator-always-on for vdd_gpu on rk3399-roc-pc
Date:   Mon, 19 Jul 2021 16:54:41 +0200
Message-Id: <20210719144956.151292336@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit 06b2818678d9b35102c9816ffaf6893caf306ed0 ]

This might be a limitation of either the current panfrost driver
devfreq implementation or how the gpu is implemented in RK3399 SoC.
The gpu regulator must never get disabled or the registers get
(randomly?) inaccessable by the driver. (see all other RK3399 boards)

Fixes: ec7d731d81e7 ("arm64: dts: rockchip: Add node for gpu on rk3399-roc-pc")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Link: https://lore.kernel.org/r/20210619121446.7802-1-knaerzche@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
index c172f5a803e7..3d5eb0b235b4 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -493,6 +493,8 @@
 		regulator-min-microvolt = <712500>;
 		regulator-max-microvolt = <1500000>;
 		regulator-ramp-delay = <1000>;
+		regulator-always-on;
+		regulator-boot-on;
 		vin-supply = <&vcc3v3_sys>;
 
 		regulator-state-mem {
-- 
2.30.2



