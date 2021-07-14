Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C7B3C8E81
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236624AbhGNTsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237014AbhGNTrF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8033C613E7;
        Wed, 14 Jul 2021 19:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291791;
        bh=3sGvKxr5umJsvdXKJt3uodQv3pGzGKg29UYbOv9asqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R2r7FW7jdxzB3zYtD6G7rxKGJVwhcOBcXsSHPynRKTWoPyqIT82HIQGWonpSRu5oM
         4zSOGa3tXdp93r9u523UvMVIusnlpc0yB+4nBvsYUXmcRyqV823BWYUEHj0CiYiKWl
         LHjWvCP5nBcAagPrNabOvMjhtD1Q0QEZQ13LnOX7QrtsAtX7nxCU4lQNYXSSHNecAe
         gZAlYMF1hp6OvSNdWLqoKn8rA9QDu4Z2BTNhDWC5rMWTgzqfz7XQJCrcdVh9UXxyKi
         2C5DFyjUkwYZ781SdUeV1tgDrmop+Liqkf67wTImlCuaXFTC4xHjLZq4/ymZIn6mCs
         KDjBJN5idqG6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 04/88] ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
Date:   Wed, 14 Jul 2021 15:41:39 -0400
Message-Id: <20210714194303.54028-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit dfbfb86a43f9a5bbd166d88bca9e07ee4e1bff31 ]

A test with the command below aimed at powerpc generates
notifications in the Rockchip ARM tree.

Fix pinctrl "sleep" nodename by renaming it to "suspend"
for rk3036-kylin and rk3288

make ARCH=arm dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/powerpc/sleep.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210126110221.10815-1-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036-kylin.dts | 2 +-
 arch/arm/boot/dts/rk3288.dtsi      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-kylin.dts b/arch/arm/boot/dts/rk3036-kylin.dts
index 7154b827ea2f..e817eba8c622 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -390,7 +390,7 @@ sdmmc_pwr: sdmmc-pwr {
 		};
 	};
 
-	sleep {
+	suspend {
 		global_pwroff: global-pwroff {
 			rockchip,pins = <2 RK_PA7 1 &pcfg_pull_none>;
 		};
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 68d5a58cfe88..fb2e89aa71c9 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1593,7 +1593,7 @@ pcfg_pull_none_12ma: pcfg-pull-none-12ma {
 			drive-strength = <12>;
 		};
 
-		sleep {
+		suspend {
 			global_pwroff: global-pwroff {
 				rockchip,pins = <0 RK_PA0 1 &pcfg_pull_none>;
 			};
-- 
2.30.2

