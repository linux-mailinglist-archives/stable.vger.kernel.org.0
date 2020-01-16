Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2AF13E3D2
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 18:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbgAPREV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:04:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388468AbgAPRCq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C5002077B;
        Thu, 16 Jan 2020 17:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194165;
        bh=yWz3ZAM8JzxV06O8K1q2DzXUMeRG4Y/JBQ6uDlAoXl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LSgci6XdmO1LAXOa3ZE5nAym7hHeMPO+KAw+FUTlcJoRr7YZaVGlmuWIiKN7eVV/M
         phpc5E4mNDMK9H7NBvKv2QiYQawLOEC8FVwSpHjaEF0RCqnQHcjUUXfUp3bsHp6FoM
         Wd5wP1XD2ytnyVJkDs8YiwamUw8V+FFSFmX0cmDg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Axel Lin <axel.lin@ingics.com>, Keerthy <j-keerthy@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 246/671] regulator: lp87565: Fix missing register for LP87565_BUCK_0
Date:   Thu, 16 Jan 2020 11:52:35 -0500
Message-Id: <20200116165940.10720-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

[ Upstream commit d1a6cbdf1e597917cb642c655512d91b71a35d22 ]

LP87565_BUCK_0 is missed, fix it.

Fixes: f0168a9bf ("regulator: lp87565: Add support for lp87565 PMIC regulators")
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Keerthy <j-keerthy@ti.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/lp87565-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lp87565-regulator.c b/drivers/regulator/lp87565-regulator.c
index c192357d1dea..7cd6862406b7 100644
--- a/drivers/regulator/lp87565-regulator.c
+++ b/drivers/regulator/lp87565-regulator.c
@@ -193,7 +193,7 @@ static int lp87565_regulator_probe(struct platform_device *pdev)
 	struct lp87565 *lp87565 = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
-	int i, min_idx = LP87565_BUCK_1, max_idx = LP87565_BUCK_3;
+	int i, min_idx = LP87565_BUCK_0, max_idx = LP87565_BUCK_3;
 
 	platform_set_drvdata(pdev, lp87565);
 
-- 
2.20.1

