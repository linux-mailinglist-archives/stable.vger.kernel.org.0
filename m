Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3212E3CE2E3
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235105AbhGSPcn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:45468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346920AbhGSPah (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3CCF561405;
        Mon, 19 Jul 2021 16:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710988;
        bh=EVoQo/wQldVJ4TDb1Y4SCn5k4qEfs7Kpjsid7Zy3B/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lo/EAzLWcdOws3Wioo+2YH3lry0vfHoe2EQM14sDPU9EiVvqoEzV7PDUPHQBCUf2Z
         Dchaz4Bm2lsXgQSRCVrrZJ52HKDlqnwfwAK5SjAg6xgwIF+6t8ZSKlXyVEvXBsAQve
         bQrWThqL7VchbZG0a829NxEdmJ/ItdkjJQDNZGSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 185/351] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:11 +0200
Message-Id: <20210719144951.101487584@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144944.537151528@linuxfoundation.org>
References: <20210719144944.537151528@linuxfoundation.org>
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
index 3598b5a748e7..4df305c767c5 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1104,6 +1104,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index e6f23ae05f95..98127e3591f9 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3708,6 +3708,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index acf0f2471c0b..46c718e9ebb7 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3218,6 +3218,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
-- 
2.30.2



