Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D165E3288C3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:46:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238883AbhCARns (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:43:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:59904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234700AbhCARkL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:40:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3E2F64FC7;
        Mon,  1 Mar 2021 16:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617776;
        bh=A4RpwhzWqUG12ho5899rGBpkXEQBnkKQYletbRJNlDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMbMFsM8U7cY6IpAJYrnRg7pfHTmEd6/jqLknvF9vDhao8+KTdHJn/lXQB6KdtEDX
         rQI5Zw7LHUmMROkor89MpQJhyqicBWFr3BuMyacTAkwayUfNR4PnYSLRLujDnZkq/Z
         nP5sBDPyCilG67C9sOUuToFSFnFFIdDCt7Siop2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Marek <jonathan@marek.ca>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 191/340] regulator: qcom-rpmh: fix pm8009 ldo7
Date:   Mon,  1 Mar 2021 17:12:15 +0100
Message-Id: <20210301161057.711978780@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index a47f87b8373df..68d22acdb037a 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -874,7 +874,7 @@ static const struct rpmh_vreg_init_data pm8009_vreg_data[] = {
 	RPMH_VREG("ldo4",   "ldo%s4",  &pmic5_nldo,      "vdd-l4"),
 	RPMH_VREG("ldo5",   "ldo%s5",  &pmic5_pldo,      "vdd-l5-l6"),
 	RPMH_VREG("ldo6",   "ldo%s6",  &pmic5_pldo,      "vdd-l5-l6"),
-	RPMH_VREG("ldo7",   "ldo%s6",  &pmic5_pldo_lv,   "vdd-l7"),
+	RPMH_VREG("ldo7",   "ldo%s7",  &pmic5_pldo_lv,   "vdd-l7"),
 	{},
 };
 
-- 
2.27.0



