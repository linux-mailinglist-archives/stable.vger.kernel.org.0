Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1083C8FBF
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240227AbhGNTxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240422AbhGNTtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBD6D600D4;
        Wed, 14 Jul 2021 19:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291919;
        bh=tkhs2oleCy29LgoRLJeVYpcFY3jAEXYINZ8XP1zCpXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jrv5T15KG5Hi08G2vBF0mqLi36DfHJUQ4f86b/zVwcK+lRkwwj6o37YV8kG7ULzF0
         G3uEh0uiSyUKbTryOHIC/EXw9ep4+9pvHGFs4EsG4Kb5RCKvTrmBMZJlmSORgdwmwi
         gj5XCn39io5avdMbByKmJK/ogvwEh1f8teZIzeLc01Qh1wf3hXHilwKb1V36ciU4lN
         6sDYg19Iak8O7Md6Mz4/xFZE+CANd/c2wpNR+MVJJhZy61wcLFHIdCdwiboPqWAROZ
         nHcKRwvzl8fQQuWkfcOB9JtSmuZjzytq8OfXJIHgH8H64N3jafyB1ocznfP4y4SKgO
         FNF+3KbxXOLYg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 04/51] arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
Date:   Wed, 14 Jul 2021 15:44:26 -0400
Message-Id: <20210714194513.54827-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit a7ecfad495f8af63a5cb332c91f60ab2018897f5 ]

A test with the command below aimed at powerpc generates
notifications in the Rockchip arm64 tree.

Fix pinctrl "sleep" nodename by renaming it to "suspend"
for rk3399.dtsi

make ARCH=arm64 dtbs_check
DT_SCHEMA_FILES=Documentation/devicetree/bindings/powerpc/sleep.yaml

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/20210126110221.10815-2-jbx6244@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3399.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3399.dtsi b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
index 9d6ed8cda2c8..750dad0d1740 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2317,7 +2317,7 @@ sdmmc_wp: sdmmc-wp {
 			};
 		};
 
-		sleep {
+		suspend {
 			ap_pwroff: ap-pwroff {
 				rockchip,pins = <1 RK_PA5 1 &pcfg_pull_none>;
 			};
-- 
2.30.2

