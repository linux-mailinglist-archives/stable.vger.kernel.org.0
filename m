Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B08E32903E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242773AbhCAUDu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:58994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242527AbhCATxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67D5465351;
        Mon,  1 Mar 2021 17:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621241;
        bh=GfpR+AIiFODvWI2ggqBabrxYX95Uy68JbJwZc6puhdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gNooUgsshHj6z/Cznea254bbe0avY4F9WWzkvJxmVIxt2oXwTiWKnKOxZ23/0MCu5
         gjQJgp8thFekdrLs0yLgwMixumtx4LNzjLSXpLYqn+/oyWdF4n2Xi+MMxcq+Mixtid
         +1pfy5xdXKvCOYyizcPY3carzpGK+xHgBaOROMOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 445/775] regulator: qcom-rpmh: fix pm8009 ldo7
Date:   Mon,  1 Mar 2021 17:10:13 +0100
Message-Id: <20210301161223.545510420@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Marek <jonathan@marek.ca>

[ Upstream commit 20ccc362c3d20da734af896e075b74222589f2c0 ]

Use the correct name to avoid ldo7 commands being sent to ldo6's address.

Fixes: 06369bcc15a1 ("regulator: qcom-rpmh: Add support for SM8150")
Signed-off-by: Jonathan Marek <jonathan@marek.ca>
Reviewed-by: Vinod Koul <vkoul@kernel.org>
Link: https://lore.kernel.org/r/20210211034935.5622-1-jonathan@marek.ca
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 98320e1d8bf66..37a2abbe85c72 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -937,7 +937,7 @@ static const struct rpmh_vreg_init_data pm8009_vreg_data[] = {
 	RPMH_VREG("ldo4",   "ldo%s4",  &pmic5_nldo,      "vdd-l4"),
 	RPMH_VREG("ldo5",   "ldo%s5",  &pmic5_pldo,      "vdd-l5-l6"),
 	RPMH_VREG("ldo6",   "ldo%s6",  &pmic5_pldo,      "vdd-l5-l6"),
-	RPMH_VREG("ldo7",   "ldo%s6",  &pmic5_pldo_lv,   "vdd-l7"),
+	RPMH_VREG("ldo7",   "ldo%s7",  &pmic5_pldo_lv,   "vdd-l7"),
 	{},
 };
 
-- 
2.27.0



