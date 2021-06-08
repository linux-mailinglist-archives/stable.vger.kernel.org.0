Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533693A0300
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbhFHTLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237399AbhFHTJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:09:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7CE561418;
        Tue,  8 Jun 2021 18:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178094;
        bh=alPiG3oO3ieF+/mwVevg6cMJgzPtbTOF1/swSLIfGMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OzMabDMElXz9Dv9r6iqHEj1sCfpeQzkxEAGEv8QnlEyExDppU5Ad+9iWGMRX+QetE
         6a1ZHP6VIHDA96TRYlYgfWFeqlbLWnhjq0zcgsTVAVyb0p55LMAcr32cITNTQudA8c
         q+uiIS5pZOH3byiI4GJMjDFlMk44xAUHDIX33m1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 074/161] ARM: dts: imx7d-meerkat96: Fix the tuning-step property
Date:   Tue,  8 Jun 2021 20:26:44 +0200
Message-Id: <20210608175947.948536368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
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



