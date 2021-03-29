Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3601F34C9A3
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231842AbhC2Iak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:30:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233932AbhC2IaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:30:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B70D261864;
        Mon, 29 Mar 2021 08:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006609;
        bh=s9tbicg6FU+e3+qxYO7NkpENUvhge4Rp1iWy9LE5DuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEmyRLotZ2YQLPP1A2ELUgSGYN33Vf5LKy4A83C6egaaxPHR+5ihhEDv0iq88GTSL
         4yLz+TXx4Q4ESXW2eBKVVotgRXXCF80FR6w2a/zrFg2srlUQ8JRZIOU5bHc/uUKlAp
         mZlytq74YjG1obt1z7eQrKtimKCeR/SY7pg+zNU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, satya priya <skakit@codeaurora.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 041/254] regulator: qcom-rpmh: Use correct buck for S1C regulator
Date:   Mon, 29 Mar 2021 09:55:57 +0200
Message-Id: <20210329075634.500245107@linuxfoundation.org>
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



