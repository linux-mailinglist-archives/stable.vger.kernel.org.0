Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470A73C376A
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232052AbhGJXwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232010AbhGJXwD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFDEC61355;
        Sat, 10 Jul 2021 23:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960957;
        bh=LxXAEoD5Ila78o+YYGT3jjqLa2D/vUuiuMAS6PHKgPI=;
        h=From:To:Cc:Subject:Date:From;
        b=nmxOV97WcWkdbLsMcDHOxjjVy8JvfQjxrogDEODX5sI042slnZyez2TA/f6nZJTZl
         Dg6fznw3XQn4BBeRXkOo3B2gce5hUTkZ2W9TNY5eLWPJjP2MfEVLQ6YG33V0g+LCWo
         ef02aa83dlzFbnMvGYXaldiGHv3eKdL4mjg3Tzl7yvapUSzT9p7e4XSulHDyPC3Gvq
         0dw7lMN5p8XRBH3CI/oQT8Olq9x3Ovu4LOZhmd15KSpojmrSx1E/BYe/eAuQKGJoIU
         9GDmKkaWcx6PcZ0lHOUG4LJsX4OxXCfghPiqPuE9Tvi567CYIZagLYIe1akK9PaR9S
         5Sm9zdr+Pu7gA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 01/43] power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:48:33 -0400
Message-Id: <20210710234915.3220342-1-sashal@kernel.org>
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

