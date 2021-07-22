Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 877AF3D29AD
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhGVQFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:39720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233987AbhGVQD7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB6D613D2;
        Thu, 22 Jul 2021 16:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972262;
        bh=f/nDuTmSBM2zGQCvfMo5Y9OdQYViJSBdYlNdo6D9zlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atjJ5CuMkLtMKsuOvEDSlrzRLCeY3E8r7j4bxZ1Dfs32hE8PWOcSiZOGEMy3+yevK
         GDQYC40SvIy6evAJyItQvLZWfpLykA3Rvl+qX8VaeoUsc9GdBhSFZlAGlRqK/wYpuD
         waPwsS8CY4nIyltd0IaXBot83w5syFnBKK3bfJok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Jonathan Marek <jonathan@marek.ca>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 048/156] arm64: dts: qcom: sm8250: fix display nodes
Date:   Thu, 22 Jul 2021 18:30:23 +0200
Message-Id: <20210722155629.960745197@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit dc5d91250ae6b810bc8d599d8d6590a06a4ce84a ]

Use sm8250 compatibles instead of sdm845 compatibles

Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20210329120051.3401567-5-dmitry.baryshkov@linaro.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 4c0de12aaba6..75f9476109e6 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2370,7 +2370,7 @@
 		};
 
 		mdss: mdss@ae00000 {
-			compatible = "qcom,sdm845-mdss";
+			compatible = "qcom,sm8250-mdss";
 			reg = <0 0x0ae00000 0 0x1000>;
 			reg-names = "mdss";
 
@@ -2402,7 +2402,7 @@
 			ranges;
 
 			mdss_mdp: mdp@ae01000 {
-				compatible = "qcom,sdm845-dpu";
+				compatible = "qcom,sm8250-dpu";
 				reg = <0 0x0ae01000 0 0x8f000>,
 				      <0 0x0aeb0000 0 0x2008>;
 				reg-names = "mdp", "vbif";
-- 
2.30.2



