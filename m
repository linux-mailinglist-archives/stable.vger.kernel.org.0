Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35EFC419BB7
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhI0RVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236916AbhI0RTk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:19:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AE43610E8;
        Mon, 27 Sep 2021 17:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762777;
        bh=lo2reoXgCgtAPcNhJj31DpCDLlXh3mqqTd+mLD9N984=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nV1KFb0iQ8t5QvLJm11Hnw4lk95HKGKeIlEHcNF/MMPh/jW5284pYciQl8ywMdn3R
         xM+hvBxTrNqBe5FNznCPvZwrEgGK830tPFEjk+XiURn7rgdOkCPEQRoAOSNXZeTHfQ
         UD8hcYLYmNlk6tq+nu/QIwLHVEGyCrF6Z+hq+pls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 047/162] regulator: qcom-rpmh-regulator: fix pm8009-1 ldo7 resource name
Date:   Mon, 27 Sep 2021 19:01:33 +0200
Message-Id: <20210927170235.128107549@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 863580418bc82062083be854355f2213d3d804f5 ]

Fix a typo in the pm8009 LDO7 declaration, it uses resource name ldo%s6
instead of ldo%s7.

Fixes: 951384cabc5d ("regulator: qcom-rpmh-regulator: add pm8009-1 chip revision")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20210901114350.1106073-1-dmitry.baryshkov@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 6cca910a76de..7f458d510483 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -991,7 +991,7 @@ static const struct rpmh_vreg_init_data pm8009_1_vreg_data[] = {
 	RPMH_VREG("ldo4",   "ldo%s4",  &pmic5_nldo,      "vdd-l4"),
 	RPMH_VREG("ldo5",   "ldo%s5",  &pmic5_pldo,      "vdd-l5-l6"),
 	RPMH_VREG("ldo6",   "ldo%s6",  &pmic5_pldo,      "vdd-l5-l6"),
-	RPMH_VREG("ldo7",   "ldo%s6",  &pmic5_pldo_lv,   "vdd-l7"),
+	RPMH_VREG("ldo7",   "ldo%s7",  &pmic5_pldo_lv,   "vdd-l7"),
 	{}
 };
 
-- 
2.33.0



