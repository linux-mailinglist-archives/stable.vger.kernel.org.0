Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E48C33E5D7
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhCQBUT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:20:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230416AbhCQA4Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D8DB164FB1;
        Wed, 17 Mar 2021 00:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942585;
        bh=s9tbicg6FU+e3+qxYO7NkpENUvhge4Rp1iWy9LE5DuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pVTckC2ZxCo3poAtT/vUxVgYVTbwKKEJOl5PmtPkzjp/aD+kuPloK3PMdtvaXROSq
         mDBcKrZjRv3Mgd9w4+VMGvYlkcIp10ov6AeteuhzzommMBjHW43Mj2Y9D51YyI0C0W
         PPeISqahdPtkuQ0lQWK4/UNKi2yP3jMC+8Jl8ZOMeR8ee0VYBS6UUkzjAvY1TSUujS
         y2ZasCWUHZa4r4U+KbKfV+VgURZ9FqXMgWKE0BhUFt/Fx9F1S9LFCkJBZFJcBZvhzF
         FOAGSV5hHePpSu1hdQ5WVwdRMJlts3VWROXV6/9ErxxHwkexBimmoVJjEraLKmNJ6m
         wqp7B0W1pAqXg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     satya priya <skakit@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 41/61] regulator: qcom-rpmh: Use correct buck for S1C regulator
Date:   Tue, 16 Mar 2021 20:55:15 -0400
Message-Id: <20210317005536.724046-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: satya priya <skakit@codeaurora.org>

[ Upstream commit dfe03bca8db4957d4b60614ff7df4d136ba90f37 ]

Use correct buck, that is, pmic5_hfsmps515 for S1C regulator
of PM8350C PMIC.

Signed-off-by: satya priya <skakit@codeaurora.org>
Link: https://lore.kernel.org/r/1614155592-14060-7-git-send-email-skakit@codeaurora.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 2351a232d90e..0fd3da36f62e 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -901,7 +901,7 @@ static const struct rpmh_vreg_init_data pm8350_vreg_data[] = {
 };
 
 static const struct rpmh_vreg_init_data pm8350c_vreg_data[] = {
-	RPMH_VREG("smps1",  "smp%s1",  &pmic5_hfsmps510, "vdd-s1"),
+	RPMH_VREG("smps1",  "smp%s1",  &pmic5_hfsmps515, "vdd-s1"),
 	RPMH_VREG("smps2",  "smp%s2",  &pmic5_ftsmps510, "vdd-s2"),
 	RPMH_VREG("smps3",  "smp%s3",  &pmic5_ftsmps510, "vdd-s3"),
 	RPMH_VREG("smps4",  "smp%s4",  &pmic5_ftsmps510, "vdd-s4"),
-- 
2.30.1

