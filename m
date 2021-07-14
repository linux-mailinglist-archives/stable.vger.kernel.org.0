Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA5893C9033
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237355AbhGNTyE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240992AbhGNTuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 531FE613FE;
        Wed, 14 Jul 2021 19:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291991;
        bh=HBrpdTLMUb3gw4Hb05JbUoDmSi5bkPdEmc3UNDbVtDU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f3C0ufJzYHqcuQFZrMstk00MxqHnCNsQ7YuHHPQGrpa3v+naZMQJUQP0Q6omu+E9n
         h/1VL7zJo63F0vZrURg+c8beW7pVxcIdvD0YVoRohWUjEufSy2uJJ6T5J9cmBKo1k/
         CZGmSkJqROrE5G+f8BFpuxiKjWT4yVD5ZPrEkUjsFxeEm1ffuxN//7ADPkaSr+dY6R
         xs9swMJNfG/7UzvmWdG0qTIuu25n9WFnnY58U10AOBFpdsvETf/J0ldfUd/51WG+Ya
         XiNAcFwKdnerClzslPymj7qpcW0GccyXmxmLZ7WQ+lSYUkoq1KP+CmuyCLdsTuYThd
         gCLJL0k30GuMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 04/39] arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
Date:   Wed, 14 Jul 2021 15:45:49 -0400
Message-Id: <20210714194625.55303-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
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
index b1c1a88a1c20..f70c05332686 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2253,7 +2253,7 @@ sdmmc_wp: sdmmc-wp {
 			};
 		};
 
-		sleep {
+		suspend {
 			ap_pwroff: ap-pwroff {
 				rockchip,pins = <1 5 RK_FUNC_1 &pcfg_pull_none>;
 			};
-- 
2.30.2

