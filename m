Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26CC21F2A8E
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731189AbgFIAJu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:09:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729578AbgFHXUV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:20:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 77C0620842;
        Mon,  8 Jun 2020 23:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658421;
        bh=aabELFPpLNSTh/+hI9W6tY2XbTcKlJNwu4snZepzc7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SHLetaPTwpEiWu1MEvNrs2mps8EN5TeRHZVxKSWqar+hA/Pu8P4QdEGxISoQ9jf88
         IWoQaeUoa5lbcjJ9h42xXMdY0x7CaogTubP5zsUSFxO9SZjvFYZxIV1T5zZDUrSHil
         l9FeFKIEQt+c0Ahg0IKXs9GYqI1JK7TM6ZQsPUG0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 068/175] regulator: qcom-rpmh: Fix typos in pm8150 and pm8150l
Date:   Mon,  8 Jun 2020 19:17:01 -0400
Message-Id: <20200608231848.3366970-68-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bjorn Andersson <bjorn.andersson@linaro.org>

[ Upstream commit 906746ba26d0b45688f4c3b730c35f765dc958ba ]

Fix typos in pm8150 l13/l16/l17 and pm8150l ldo8 supplies.

Fixes: 06369bcc15a1 ("regulator: qcom-rpmh: Add support for SM8150")
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Tested-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20200415053708.717623-1-bjorn.andersson@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 0246b6f99fb5..f11e4bfbc91b 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -832,11 +832,11 @@ static const struct rpmh_vreg_init_data pm8150_vreg_data[] = {
 	RPMH_VREG("ldo10",  "ldo%s10", &pmic5_pldo,      "vdd-l2-l10"),
 	RPMH_VREG("ldo11",  "ldo%s11", &pmic5_nldo,      "vdd-l1-l8-l11"),
 	RPMH_VREG("ldo12",  "ldo%s12", &pmic5_pldo_lv,   "vdd-l7-l12-l14-l15"),
-	RPMH_VREG("ldo13",  "ldo%s13", &pmic5_pldo,      "vdd-l13-l6-l17"),
+	RPMH_VREG("ldo13",  "ldo%s13", &pmic5_pldo,      "vdd-l13-l16-l17"),
 	RPMH_VREG("ldo14",  "ldo%s14", &pmic5_pldo_lv,   "vdd-l7-l12-l14-l15"),
 	RPMH_VREG("ldo15",  "ldo%s15", &pmic5_pldo_lv,   "vdd-l7-l12-l14-l15"),
-	RPMH_VREG("ldo16",  "ldo%s16", &pmic5_pldo,      "vdd-l13-l6-l17"),
-	RPMH_VREG("ldo17",  "ldo%s17", &pmic5_pldo,      "vdd-l13-l6-l17"),
+	RPMH_VREG("ldo16",  "ldo%s16", &pmic5_pldo,      "vdd-l13-l16-l17"),
+	RPMH_VREG("ldo17",  "ldo%s17", &pmic5_pldo,      "vdd-l13-l16-l17"),
 	RPMH_VREG("ldo18",  "ldo%s18", &pmic5_nldo,      "vdd-l3-l4-l5-l18"),
 	{},
 };
@@ -857,7 +857,7 @@ static const struct rpmh_vreg_init_data pm8150l_vreg_data[] = {
 	RPMH_VREG("ldo5",   "ldo%s5",  &pmic5_pldo,      "vdd-l4-l5-l6"),
 	RPMH_VREG("ldo6",   "ldo%s6",  &pmic5_pldo,      "vdd-l4-l5-l6"),
 	RPMH_VREG("ldo7",   "ldo%s7",  &pmic5_pldo,      "vdd-l7-l11"),
-	RPMH_VREG("ldo8",   "ldo%s8",  &pmic5_pldo_lv,   "vdd-l1-l8-l11"),
+	RPMH_VREG("ldo8",   "ldo%s8",  &pmic5_pldo_lv,   "vdd-l1-l8"),
 	RPMH_VREG("ldo9",   "ldo%s9",  &pmic5_pldo,      "vdd-l9-l10"),
 	RPMH_VREG("ldo10",  "ldo%s10", &pmic5_pldo,      "vdd-l9-l10"),
 	RPMH_VREG("ldo11",  "ldo%s11", &pmic5_pldo,      "vdd-l7-l11"),
-- 
2.25.1

