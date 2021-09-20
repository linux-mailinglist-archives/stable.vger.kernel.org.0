Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED834121C0
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347718AbhITSIx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:08:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358452AbhITSGn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:06:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7876C61A09;
        Mon, 20 Sep 2021 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158277;
        bh=OSdMAULjlmnN/jT+nXnh2Xtyn15yJLPU363d9rLYq7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lj6DcLltyZxdnMkFpvRgS8r1KsWDSOFCEcLI+MvdkcmHecdYRoIEvAvWxdz2Sam8e
         2x3iaq76qiJZ9+ndEhfj4h/duXq7AP/fBXopiObuqBJkldDwKoq/73GZob5Zl/s7mN
         oA46m0DP72zJF5S4BC9YhEFQyQrz/1sxW0sn3qOM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Masney <masneyb@onstation.org>,
        David Heidelberg <david@ixit.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/260] ARM: dts: qcom: apq8064: correct clock names
Date:   Mon, 20 Sep 2021 18:41:39 +0200
Message-Id: <20210920163933.889894822@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Heidelberg <david@ixit.cz>

[ Upstream commit 0dc6c59892ead17a9febd11202c9f6794aac1895 ]

Since new code doesn't take old clk names in account, it does fixes
error:

msm_dsi 4700000.mdss_dsi: dev_pm_opp_set_clkname: Couldn't find clock: -2

and following kernel oops introduced by
b0530eb1191 ("drm/msm/dpu: Use OPP API to set clk/perf state").

Also removes warning about deprecated clock names.

Tested against linux-5.10.y LTS on Nexus 7 2013.

Reviewed-by: Brian Masney <masneyb@onstation.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Link: https://lore.kernel.org/r/20210707131453.24041-1-david@ixit.cz
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-apq8064.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/qcom-apq8064.dtsi b/arch/arm/boot/dts/qcom-apq8064.dtsi
index 8b79b4112ee1..2b075e287610 100644
--- a/arch/arm/boot/dts/qcom-apq8064.dtsi
+++ b/arch/arm/boot/dts/qcom-apq8064.dtsi
@@ -1261,9 +1261,9 @@ dsi0: mdss_dsi@4700000 {
 				<&mmcc DSI1_BYTE_CLK>,
 				<&mmcc DSI_PIXEL_CLK>,
 				<&mmcc DSI1_ESC_CLK>;
-			clock-names = "iface_clk", "bus_clk", "core_mmss_clk",
-					"src_clk", "byte_clk", "pixel_clk",
-					"core_clk";
+			clock-names = "iface", "bus", "core_mmss",
+					"src", "byte", "pixel",
+					"core";
 
 			assigned-clocks = <&mmcc DSI1_BYTE_SRC>,
 					<&mmcc DSI1_ESC_SRC>,
-- 
2.30.2



