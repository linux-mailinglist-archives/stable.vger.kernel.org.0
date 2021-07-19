Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61C1E3CE5C9
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348162AbhGSPx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350410AbhGSPvC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:51:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7AACE606A5;
        Mon, 19 Jul 2021 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626712165;
        bh=tyoEZuOIayPlpo4emVkw+vdqX5DcqfQ95gjQbIXD1cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6bkYAi6znct08IwonOYbvdrOmlD7prtIZ0G5W6oRAp42KSur4YvkkbSSUfEPSNKY
         rvJvNX/sNMZmkwdE2KXLuVsSAhDvGdD/bZdVI2VhxjJ4LN9Gkx6mCQQvRK8vyfn2rU
         ORS8P9mtz+fH2rbljpjIPAaPysTCQmKL+FMPCljs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 276/292] arm64: dts: rockchip: Re-add regulator-boot-on, regulator-always-on for vdd_gpu on rk3399-roc-pc
Date:   Mon, 19 Jul 2021 16:55:38 +0200
Message-Id: <20210719144951.990140156@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index 20309076dbac..e4345e5bdfb6 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399-roc-pc.dtsi
@@ -488,6 +488,8 @@
 		regulator-min-microvolt = <712500>;
 		regulator-max-microvolt = <1500000>;
 		regulator-ramp-delay = <1000>;
+		regulator-always-on;
+		regulator-boot-on;
 		vin-supply = <&vcc3v3_sys>;
 
 		regulator-state-mem {
-- 
2.30.2



