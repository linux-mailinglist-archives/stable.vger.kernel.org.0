Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485AB3C3753
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhGJXvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229674AbhGJXvp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:51:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D256861355;
        Sat, 10 Jul 2021 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960939;
        bh=LxXAEoD5Ila78o+YYGT3jjqLa2D/vUuiuMAS6PHKgPI=;
        h=From:To:Cc:Subject:Date:From;
        b=q/4Bgtf5a2ZzoJCiMBmjmqMDrwldiG+JiBY0N2DCa28G5uJOqjzeDDRjaeLauN58H
         okuRtU4t7lrOkSxJ+J0k3VwaKKeopmz+luA/Ds5dF38P1PMT7oy7aDxbP+c0956A5/
         LBluaMzZQopsSkNrIF4sCuCC31F0z/P+1CaNLqIanpq+XoUKfCxUVvPI7RrtQD+g4h
         HNPYSBA0A1VCaClijH7zXN6l3cjLN9xEQDUG7+fusW57JxC6BQiTTC/6tnfdG456pG
         Ag2zv/TXM+A+cJwU1LzUMYUY+2NznovYsyXKd0KQnKDztTyuJutjp3J3DmmvRI+2sr
         nZwBREniUhbUg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 01/53] power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:48:05 -0400
Message-Id: <20210710234857.3220040-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 603fcfb9d4ec1cad8d66d3bb37f3613afa8a661a ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc27xx_fuel_gauge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/sc27xx_fuel_gauge.c b/drivers/power/supply/sc27xx_fuel_gauge.c
index 9c627618c224..1ae8374e1ceb 100644
--- a/drivers/power/supply/sc27xx_fuel_gauge.c
+++ b/drivers/power/supply/sc27xx_fuel_gauge.c
@@ -1342,6 +1342,7 @@ static const struct of_device_id sc27xx_fgu_of_match[] = {
 	{ .compatible = "sprd,sc2731-fgu", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, sc27xx_fgu_of_match);
 
 static struct platform_driver sc27xx_fgu_driver = {
 	.probe = sc27xx_fgu_probe,
-- 
2.30.2

