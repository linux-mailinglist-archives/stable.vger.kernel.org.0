Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E7D3D27CF
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 18:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhGVPxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 11:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230198AbhGVPwy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 11:52:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0258C6135C;
        Thu, 22 Jul 2021 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626971608;
        bh=9bDJHo/tbUob7FbJ8et6dojhK5vB9CjDQyeRHuWrhYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cbdzhdIHPbuTVExhk1+RdwCFy5v6F8CSolA84pjqwnlv5nRAFCeyFzEnesZy4pT43
         /xi0aTVVs/XEwtNuBXlHHhAh8zftOpDXn7r89xLLP0DkTiWG6Yz9tbZksB3YCno7wW
         HKO2Z3S3ikBx200k3eIJh6cWGGz1ju+UovmgzAtY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Jonker <jbx6244@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 03/71] ARM: dts: rockchip: fix pinctrl sleep nodename for rk3036-kylin and rk3288
Date:   Thu, 22 Jul 2021 18:30:38 +0200
Message-Id: <20210722155617.978149140@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155617.865866034@linuxfoundation.org>
References: <20210722155617.865866034@linuxfoundation.org>
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
index fb3cf005cc90..2ef47ebeb0cb 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -390,7 +390,7 @@
 		};
 	};
 
-	sleep {
+	suspend {
 		global_pwroff: global-pwroff {
 			rockchip,pins = <2 RK_PA7 1 &pcfg_pull_none>;
 		};
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index cc893e154fe5..a452d4ea3938 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1575,7 +1575,7 @@
 			drive-strength = <12>;
 		};
 
-		sleep {
+		suspend {
 			global_pwroff: global-pwroff {
 				rockchip,pins = <0 RK_PA0 1 &pcfg_pull_none>;
 			};
-- 
2.30.2



