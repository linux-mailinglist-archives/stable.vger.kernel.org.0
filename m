Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECFD91480E4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:15:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390267AbgAXLP0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:51726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389800AbgAXLPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:11 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89C222075D;
        Fri, 24 Jan 2020 11:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864511;
        bh=uIcusasGqxcdAfNdaFdkLZojC9vgBvOmkhzrXL2/xac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igA/T9zshoPDD4bmTUcRTSDjGrWkHsFxbzILiCzlD/SCRTz1yG3aOPdXw03DkAA2p
         5M/CPSXo7A73ae37JxlwCks20KyPUXGgf1FUzEiaDeJSRAJlgY4+Gs+nwXehvNsUrn
         oGjre7tF6csYx6kfUHjfS2RmkErC3ZXoAipFx4D0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 262/639] regulator: lp87565: Fix missing register for LP87565_BUCK_0
Date:   Fri, 24 Jan 2020 10:27:12 +0100
Message-Id: <20200124093119.565627377@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index c192357d1dea0..7cd6862406b70 100644
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



