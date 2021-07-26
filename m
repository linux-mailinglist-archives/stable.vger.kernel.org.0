Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2FC3D5E28
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235784AbhGZPFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:05:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236147AbhGZPFd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:05:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816C260525;
        Mon, 26 Jul 2021 15:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314361;
        bh=x7AnP59tamq2nS+jX1Iz7R6/R+kcJINBnt+Cvbcymbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B6Pu3DjDluQVe8aV88vMW+pBFESeEyszAnTz3t11Kk/PQ8zfmXyAePVohWTiZI2Mt
         MrIGIVCU3FW9aWgXj2Zsq0j+6RwX10Wuoz17CprP3SFcfJ8Ckzxwju5g5cA86EiPVi
         cOVwmA8ERLDl+7kPSK7GI7EQdd4aKVq4Wtl1UZE4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 02/82] ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
Date:   Mon, 26 Jul 2021 17:38:02 +0200
Message-Id: <20210726153828.226709984@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index fdb1570bc7d3..3371bc921aef 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -424,7 +424,7 @@
 		};
 	};
 
-	sleep {
+	suspend {
 		global_pwroff: global-pwroff {
 			rockchip,pins = <2 7 RK_FUNC_1 &pcfg_pull_none>;
 		};
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 23907d9ce89a..5dd37d09c1f1 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1453,7 +1453,7 @@
 			drive-strength = <12>;
 		};
 
-		sleep {
+		suspend {
 			global_pwroff: global-pwroff {
 				rockchip,pins = <0 0 RK_FUNC_1 &pcfg_pull_none>;
 			};
-- 
2.30.2



