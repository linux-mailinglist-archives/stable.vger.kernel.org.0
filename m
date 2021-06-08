Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7DA3A0150
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234960AbhFHSu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235649AbhFHSs0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:48:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4EC2461420;
        Tue,  8 Jun 2021 18:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177506;
        bh=alPiG3oO3ieF+/mwVevg6cMJgzPtbTOF1/swSLIfGMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VkFZ0ADBXQnV/p4DpQgKd3Qdfz1GU7PLpH+/LGcuFfwrwkzyrrCVE9pmyVVtr+MxD
         9i5/MduSkOO4iQX5NeUb+CH0MBEThvDVH1FJVQvJYZTau0ai3x5IrkPTzU+L4AR85S
         wqfjkENcK1d7xaAo36CKHNmI7ZzH1B+5HOrUkOBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/78] ARM: dts: imx7d-meerkat96: Fix the tuning-step property
Date:   Tue,  8 Jun 2021 20:27:01 +0200
Message-Id: <20210608175936.351549808@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175935.254388043@linuxfoundation.org>
References: <20210608175935.254388043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fabio Estevam <festevam@gmail.com>

[ Upstream commit 7c8f0338cdacc90fdf6468adafa8e27952987f00 ]

According to Documentation/devicetree/bindings/mmc/fsl-imx-esdhc.yaml, the
correct name of the property is 'fsl,tuning-step'.

Fix it accordingly.

Signed-off-by: Fabio Estevam <festevam@gmail.com>
Fixes: ae7b3384b61b ("ARM: dts: Add support for 96Boards Meerkat96 board")
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx7d-meerkat96.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx7d-meerkat96.dts b/arch/arm/boot/dts/imx7d-meerkat96.dts
index 5339210b63d0..dd8003bd1fc0 100644
--- a/arch/arm/boot/dts/imx7d-meerkat96.dts
+++ b/arch/arm/boot/dts/imx7d-meerkat96.dts
@@ -193,7 +193,7 @@
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_usdhc1>;
 	keep-power-in-suspend;
-	tuning-step = <2>;
+	fsl,tuning-step = <2>;
 	vmmc-supply = <&reg_3p3v>;
 	no-1-8-v;
 	broken-cd;
-- 
2.30.2



