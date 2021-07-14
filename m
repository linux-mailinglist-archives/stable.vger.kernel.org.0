Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0D033C8CB5
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234290AbhGNTmi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:42:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234737AbhGNTmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C14A613D1;
        Wed, 14 Jul 2021 19:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291560;
        bh=JHkbQ6R+N16lTtYFgNYwppOpJcg1irluqDQTEAfFrOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elXCk4RRXTUAxXNQ+dvHhXDEiBHpx+5yKG8dEJ6IWkx/ZUl45eYq81tNfIMI8AM/o
         8DKXEsdgqKdRsLlbq0MT194+64nPUde6nWxsSHWbotGrmUh8bBQUWxQ8qIXfzmlxkY
         0L9Id2qQ6WoRCAEqHtBBRGPPKBybyqd/XHW/13bduNuhSLIkKEqBGnsH4fzbnZJn3Q
         w91xNc1mmIfx2Y9BR+hd/gs6OKCGwM1+gSHFU+D+jVvZKaJy5S9MoXSpOK6QWxZkW9
         6iqEbKVT3wNAgwYQ3R3r1h5XbeXXT32Z4z8XTiyy14RyZI53yDV21X1zmHezn3IEuE
         s2LcIGxRou2LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonathan Marek <jonathan@marek.ca>,
        Stephen Boyd <swboyd@chromium.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 055/108] arm64: dts: qcom: sm8250: fix display nodes
Date:   Wed, 14 Jul 2021 15:37:07 -0400
Message-Id: <20210714193800.52097-55-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714193800.52097-1-sashal@kernel.org>
References: <20210714193800.52097-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
@@ -2370,7 +2370,7 @@ videocc: clock-controller@abf0000 {
 		};
 
 		mdss: mdss@ae00000 {
-			compatible = "qcom,sdm845-mdss";
+			compatible = "qcom,sm8250-mdss";
 			reg = <0 0x0ae00000 0 0x1000>;
 			reg-names = "mdss";
 
@@ -2402,7 +2402,7 @@ mdss: mdss@ae00000 {
 			ranges;
 
 			mdss_mdp: mdp@ae01000 {
-				compatible = "qcom,sdm845-dpu";
+				compatible = "qcom,sm8250-dpu";
 				reg = <0 0x0ae01000 0 0x8f000>,
 				      <0 0x0aeb0000 0 0x2008>;
 				reg-names = "mdp", "vbif";
-- 
2.30.2

