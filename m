Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707DF24B484
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:08:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730658AbgHTKIW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:08:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:40248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729652AbgHTKIV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:08:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0CF72067C;
        Thu, 20 Aug 2020 10:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918100;
        bh=MN5EgeoI4ccyyJSmPxzesSCVCG8knB0bfsW7JeAjl2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pb7eb52JGJ6CKtklosgg84WbcCfWUGAbzaT6fV9s/iKfg9rDHmx9V2JvbeIQmmRSm
         DWEfPdv9jsTXTsRQF+jPMB87IGfFYj5ii0PGBDiugXp8YookVM+9+jMBNspEaT+gc9
         fEA1dUesIrBUP69ufZMcYRuu9ZPp872zy7mn2ljI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stephan Gerhold <stephan@gerhold.net>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 051/228] arm64: dts: qcom: msm8916: Replace invalid bias-pull-none property
Date:   Thu, 20 Aug 2020 11:20:26 +0200
Message-Id: <20200820091610.165989878@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 1b6a1a162defe649c5599d661b58ac64bb6f31b6 ]

msm8916-pins.dtsi specifies "bias-pull-none" for most of the audio
pin configurations. This was likely copied from the qcom kernel fork
where the same property was used for these audio pins.

However, "bias-pull-none" actually does not exist at all - not in
mainline and not in downstream. I can only guess that the original
intention was to configure "no pull", i.e. bias-disable.

Change it to that instead.

Fixes: 143bb9ad85b7 ("arm64: dts: qcom: add audio pinctrls")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20200605185916.318494-2-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916-pins.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi b/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
index 4cb0b58341432..69ba1d79bcd5d 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916-pins.dtsi
@@ -542,7 +542,7 @@ pinconf {
 				pins = "gpio63", "gpio64", "gpio65", "gpio66",
 				       "gpio67", "gpio68";
 				drive-strength = <8>;
-				bias-pull-none;
+				bias-disable;
 			};
 		};
 		cdc_pdm_lines_sus: pdm_lines_off {
@@ -571,7 +571,7 @@ pinconf {
 				pins = "gpio113", "gpio114", "gpio115",
 				       "gpio116";
 				drive-strength = <8>;
-				bias-pull-none;
+				bias-disable;
 			};
 		};
 
@@ -599,7 +599,7 @@ pinmux {
 			pinconf {
 				pins = "gpio110";
 				drive-strength = <8>;
-				bias-pull-none;
+				bias-disable;
 			};
 		};
 
@@ -625,7 +625,7 @@ pinmux {
 			pinconf {
 				pins = "gpio116";
 				drive-strength = <8>;
-				bias-pull-none;
+				bias-disable;
 			};
 		};
 		ext_mclk_tlmm_lines_sus: mclk_lines_off {
@@ -653,7 +653,7 @@ pinconf {
 				pins = "gpio112", "gpio117", "gpio118",
 					"gpio119";
 				drive-strength = <8>;
-				bias-pull-none;
+				bias-disable;
 			};
 		};
 		ext_sec_tlmm_lines_sus: tlmm_lines_off {
-- 
2.25.1



