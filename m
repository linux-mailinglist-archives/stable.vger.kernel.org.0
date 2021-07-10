Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30E43C397E
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhGKAAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234007AbhGJX6C (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14DF061432;
        Sat, 10 Jul 2021 23:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961176;
        bh=sOegZowR/q6LjkYuDLD0rmnPgFbxkZDZqKqGHP7LqKk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBccE+z/gbgOShBKpIBlj9Tm7c4fY6kVHMEMr/257CurPrD2n1/M8Gukgdtw3pViN
         CPQjp/sA/N1Wpedbg4zehdc5V47qY3nctFCX88pI/ZOXh7n7ySfxzdBDYbMgGy+gFK
         uqKoiscSuIzK4mkpErJPdQqknZHYl0gmBZhxcEqnHysWf/r/vnNfVNG1/0hf52ov/Q
         ODAnUWP+AxY4YdfmXsuKiVEr2xFnv71YJuhrH233kJaGYVSSYN4d7F7tAvR/rWySVr
         bOHbciWFpA/qwhFzDE7yPJ27iGaajLjjmAYnB1F6Qmx8VLvCl5DMZPCQXGfAB+ukVA
         xzYBUCqZIf/Gw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/16] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:52:36 -0400
Message-Id: <20210710235240.3222618-12-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235240.3222618-1-sashal@kernel.org>
References: <20210710235240.3222618-1-sashal@kernel.org>
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
index 6ffdc18f2599..9f17d81767ea 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1181,6 +1181,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 2d44a68b62c0..56b502331433 100644
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
index ea8c26a108f0..d6079e892e11 100644
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

