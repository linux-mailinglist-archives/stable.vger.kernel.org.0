Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 803893CDED1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:49:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343872AbhGSPGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343500AbhGSPEG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:04:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 449696113E;
        Mon, 19 Jul 2021 15:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709411;
        bh=6TI1VcIr4mzrs+GdVJ43oVNVfG3N/lmsYVGid/aPxEI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6jS/kdrVreZlz9VoEs9D6JSiLYTC4he91r1ygGiXW7TfaDf69OMIEOveIvEyFy67
         3WNBwKl76rQt33HE/8SHrwDOtyrnq61y3Kkkv4WR97u5YSCjYSvOWK89KNWno3PFA2
         uGfFriXB4pgGqykKcIyrBcocr7SDimfbaiF9L09A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 374/421] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:05 +0200
Message-Id: <20210719144959.208215631@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 708fd58cd62b..0fd24577112e 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1120,6 +1120,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 76b6c60cde80..0f379fa3385e 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3639,6 +3639,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 8bb89c697c1e..b0e77324b016 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3221,6 +3221,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
-- 
2.30.2



