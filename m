Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30C53C8E90
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238072AbhGNTsW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:48:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:45102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238215AbhGNTrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:47:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51BE7613F7;
        Wed, 14 Jul 2021 19:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291793;
        bh=pT7esBQsT/AwV7sJCURNF1Uz2tAgSL8Xdc3fSReQXjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=npr+OooeIGEQ8sOBldZR7PFRMqheujoNnrrm+yYpf6WqwyaUNjbf+a8QgLVI/n30I
         UjL7l7+OhcR9fR0C/0f5gslc9dCt3fGLOYgbRFI2jXqbPjBagprLmps37cFdTm2gg/
         TGaM1LdEsty7BccyIT6ThIoMeP9rLgDirnmTKI19RQU5mMu0pE2Rncd+YlCKzTxN1x
         4zdnd36EwVW1hmjWq1WQxGGGVskHszM3UxG3kXoESsyduJCtTofY3MtmZD1fHlWK9p
         LDeSPuE7U+uDYT5/rzpET8SMPbEM6erwJZy80pkm63F34FlvFQW5VsyqBGOkDNGxSC
         23jBXYSMg+w4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johan Jonker <jbx6244@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 05/88] arm64: dts: rockchip: fix pinctrl sleep nodename for rk3399.dtsi
Date:   Wed, 14 Jul 2021 15:41:40 -0400
Message-Id: <20210714194303.54028-5-sashal@kernel.org>
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
index 7e69603fb41c..ee6287b872db 100644
--- a/arch/arm64/boot/dts/rockchip/rk3399.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3399.dtsi
@@ -2342,7 +2342,7 @@ sdmmc_wp: sdmmc-wp {
 			};
 		};
 
-		sleep {
+		suspend {
 			ap_pwroff: ap-pwroff {
 				rockchip,pins = <1 RK_PA5 1 &pcfg_pull_none>;
 			};
-- 
2.30.2

