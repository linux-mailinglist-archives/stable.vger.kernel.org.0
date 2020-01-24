Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BC5D147C84
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:52:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387904AbgAXJwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:52:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:54636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388013AbgAXJwm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:52:42 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF6BE20709;
        Fri, 24 Jan 2020 09:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859561;
        bh=3/A6QtC9u1yfCZvKc9BqnXDuZzbqey7clByzLwFbj6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/szarRqXefCWvFZwrnNZd9EvA0BkVG0DRq0sgekXNFCLHiu4Amkhl6gycIuvBGZH
         t2g4BmERF5ne7oeU0ppY88h2Ir6AVtw+VD6IZX8/XXhhjLQ1/MIAB3Cz7kCi/ks51O
         /B7fgOxrmR6sECktdVbJ4LKIjd/uuqkfn5LXkhGA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Keerthy <j-keerthy@ti.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 143/343] regulator: lp87565: Fix missing register for LP87565_BUCK_0
Date:   Fri, 24 Jan 2020 10:29:21 +0100
Message-Id: <20200124092938.797512195@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
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
index cfdbe294fb6af..32d4e6ec2e198 100644
--- a/drivers/regulator/lp87565-regulator.c
+++ b/drivers/regulator/lp87565-regulator.c
@@ -188,7 +188,7 @@ static int lp87565_regulator_probe(struct platform_device *pdev)
 	struct lp87565 *lp87565 = dev_get_drvdata(pdev->dev.parent);
 	struct regulator_config config = { };
 	struct regulator_dev *rdev;
-	int i, min_idx = LP87565_BUCK_1, max_idx = LP87565_BUCK_3;
+	int i, min_idx = LP87565_BUCK_0, max_idx = LP87565_BUCK_3;
 
 	platform_set_drvdata(pdev, lp87565);
 
-- 
2.20.1



