Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6F34C9A2
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbhC2Iai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233714AbhC2I3p (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:29:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7157619EA;
        Mon, 29 Mar 2021 08:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006585;
        bh=K1j1U7j24OoKSGW34SRxXl9SHbrgiM5w89vvUwSaNl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r6NnEM9ThldenhrJdzhfJz57qFCgpuc1mBSDmHFfQ/SdiTgGobIlnogbcWk8RkB8p
         gs+GJNAdGFOxIDn9b3X8SsKeVVyrR8af/OjYejPdT0UiS6LgROxs9rixJuOAy+8OX5
         EzFT96pN5wnXv/UyK5rvz2kIeeG1+k3CQiElEqu4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, satya priya <skakit@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 040/254] regulator: qcom-rpmh: Correct the pmic5_hfsmps515 buck
Date:   Mon, 29 Mar 2021 09:55:56 +0200
Message-Id: <20210329075634.469335890@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 37a2abbe85c7..2351a232d90e 100644
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



