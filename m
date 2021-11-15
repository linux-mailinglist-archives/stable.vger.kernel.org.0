Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A2945145F
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348508AbhKOUEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:04:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:45224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344245AbhKOTYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CD5D63644;
        Mon, 15 Nov 2021 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002468;
        bh=J6l0DlpCZfI9G40C6WfG9y6zcsW0JyIaRgL1BsmpmP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NXpo0nxpFz+DbNphalEebZeU+yPkoThnvhqXutocfTjqYnVmWNYDg1MXP3EZGjBSY
         d/uuWxLpu9eUnqJCYi++vRv9WSWPpZtGJszQTirR4ryZCENRG5EJ7/DPmDbFIv7w0X
         YGO1CmfvVPuAWFA4T35Hvv3u7qu0ZOJXPY3m/YSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 578/917] ARM: dts: qcom: msm8974: Add xo_board reference clock to DSI0 PHY
Date:   Mon, 15 Nov 2021 18:01:13 +0100
Message-Id: <20211115165448.371775708@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marijn Suijten <marijn.suijten@somainline.org>

[ Upstream commit 8ccecf6c710b8c048eecc65709640642e5357d6e ]

According to YAML validation, and for a future patchset putting this
xo_board reference clock to use as VCO reference parent, add the missing
clock to dsi_phy0.

Fixes: 5a9fc531f6ec ("ARM: dts: msm8974: add display support")
Signed-off-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210830175739.143401-1-marijn.suijten@somainline.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-msm8974.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-msm8974.dtsi b/arch/arm/boot/dts/qcom-msm8974.dtsi
index 78ec496d5bc30..2b01bc29ddf23 100644
--- a/arch/arm/boot/dts/qcom-msm8974.dtsi
+++ b/arch/arm/boot/dts/qcom-msm8974.dtsi
@@ -1589,8 +1589,8 @@
 				#phy-cells = <0>;
 				qcom,dsi-phy-index = <0>;
 
-				clocks = <&mmcc MDSS_AHB_CLK>;
-				clock-names = "iface";
+				clocks = <&mmcc MDSS_AHB_CLK>, <&xo_board>;
+				clock-names = "iface", "ref";
 			};
 		};
 
-- 
2.33.0



