Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5A33C393B
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbhGJX60 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:58:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233784AbhGJX5O (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C27C461418;
        Sat, 10 Jul 2021 23:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961152;
        bh=2MGni7B5wZNEWF6vJLpZ9cH5IFFk7fHkR+8ePWBlKb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fcYuDh/e2B1MQ+LW8ypHJjOzNu6a6dtKorbDClZT2Af2lFRtMc1wWTbRkcluc+6q8
         bzxDQub58srYVewSABPZ7W5B3gr6ECHtTBjHIDdrfmJuWTfNz7etFZcZuHWYX79CpL
         HkgYEev4+0QPp22FwOHium6KmAmHLWCZZeMMcwPHn+xsexFqw8BmeHqJv0LwTD5Vyj
         s/8GHBQQmJO6BgfosAGcNbBKH1pFhtm+qPQXFbnN0WJ3SIZJktKbMRvaGZcZK7fXsT
         dsbuaR7itFR97OceHyXTRR/QfCwksgpbmdC6yrSRIlt/UkwpR3S9mjEFWcLL+d79WG
         QQj8Qy3ekFZSA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 15/21] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:52:06 -0400
Message-Id: <20210710235212.3222375-15-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235212.3222375-1-sashal@kernel.org>
References: <20210710235212.3222375-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit dfe52db13ab8d24857a9840ec7ca75eef800c26c ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c   | 1 +
 drivers/power/supply/ab8500_charger.c | 1 +
 drivers/power/supply/ab8500_fg.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index f7a35ebfbab2..97423a04fc0f 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1177,6 +1177,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 8e74d27fad29..fe2341e92be9 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3752,6 +3752,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index b87768238b70..2677592ed7af 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3229,6 +3229,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
-- 
2.30.2

