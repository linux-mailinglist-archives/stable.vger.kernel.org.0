Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993FC33E49F
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232291AbhCQBAO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231796AbhCQA6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88E9D64FEB;
        Wed, 17 Mar 2021 00:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942716;
        bh=UZkiUS5VU/CJAW2Dy68Jg1kT2hdab6xvmILpYTbU4Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HME9i6aSvBrdclV9qxaWojDRJ1Dd3aZpbKpDujqWMerxyujHRZ5XYWzuR99eQW7yb
         VDRpJ9v7H3tHXv46qWTIkOzdB4FC8T58koDNBMqfZEdrgFr0P1Nmx+rHA5PXM/0+Qh
         BAPC7uZtbTQUTfVvPjiq0+TKW+ATThyUoUVMVVQuoEvFy4XSpk2yxVLnakoj5ywEJp
         amOKj9c39IWNRJVpYpjyt1d6KnjQzXgK2sTEeYFpaJ0A5Gil4QH1LzWYoarlkNTgs2
         5LuVwLyUl3za0fe3w2k+iC8gwWaO3htUbs2zZX7MhY1u34HcFXJhxWaGn/9E7N+lx7
         c/q8aOHQ5teKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     satya priya <skakit@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 27/37] regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck
Date:   Tue, 16 Mar 2021 20:57:52 -0400
Message-Id: <20210317005802.725825-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
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
index 68d22acdb037..2de7af13288e 100644
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

