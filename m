Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8999933E41A
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhCQA6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:36880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhCQA5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C2BB64FE0;
        Wed, 17 Mar 2021 00:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942660;
        bh=Usc0eiGhhPiYmNvlsMHzWrjR6Ey/DywCN3lPhaMFtQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IsPmkaLMauBPMql3wqIWy41iKgaluZT+Y0laBFYR6ozSeyMSsAacH/zM8NkP5NvCc
         NhHCto4eeZCzg+iJyblI2pqG8m03VeqARTB6W9PXw2GiR/xpMIw9PYZCeBFtW6D6tQ
         z0SXb3LxsJXkCR0rJzm2rZvP7rYQSezKyQQFoWPT6dKTna58sM2U9btSxL9NeqOicf
         TVYBVMaZKctKhFZgsPpj3546YE7QyYsMkwMBpr3dRW2HVExBi3QZ0tC8SgArVAnu4J
         8kcc2IZxhZyYx18bJGrHM82vCab1+re/htgqPoH/bkJCxBz1O1mLXtR9rFXk3FmqJs
         +cVbeNq3+XNrw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     satya priya <skakit@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 38/54] regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck
Date:   Tue, 16 Mar 2021 20:56:37 -0400
Message-Id: <20210317005654.724862-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: satya priya <skakit@codeaurora.org>

[ Upstream commit e610e072c87a30658479a7b4c51e1801cb3f450c ]

Correct the REGULATOR_LINEAR_RANGE and n_voltges for
pmic5_hfsmps515 buck.

Signed-off-by: satya priya <skakit@codeaurora.org>
Link: https://lore.kernel.org/r/1614155592-14060-4-git-send-email-skakit@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 52e4396d4071..c3036591b259 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -726,8 +726,8 @@ static const struct rpmh_vreg_hw_data pmic5_ftsmps510 = {
 static const struct rpmh_vreg_hw_data pmic5_hfsmps515 = {
 	.regulator_type = VRM,
 	.ops = &rpmh_regulator_vrm_ops,
-	.voltage_range = REGULATOR_LINEAR_RANGE(2800000, 0, 4, 16000),
-	.n_voltages = 5,
+	.voltage_range = REGULATOR_LINEAR_RANGE(320000, 0, 235, 16000),
+	.n_voltages = 236,
 	.pmic_mode_map = pmic_mode_map_pmic5_smps,
 	.of_map_mode = rpmh_regulator_pmic4_smps_of_map_mode,
 };
-- 
2.30.1

