Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0A613CE51B
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbhGSPrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:47:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:46056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349620AbhGSPpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB8D160C40;
        Mon, 19 Jul 2021 16:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626711949;
        bh=2rR0rVgLaARphT4nDKLGrLJwcXz84IRtKSSnkhgnpcQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjeSZ2JhcjJ2XTSOllvdo95+V8lryR2AmvN2yBINk+ywoylcvEQxtK2yjVNsoxces
         Nfh//3EJ4GUNLX1fJVemCb1+/LF655EIAeEktg3pxicVk2lLRy4MaDXtnT45majmh1
         OeDbCSS6DFgZwd1JsXdCLgQvLUm0vBhJSG/xw2KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 159/292] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:41 +0200
Message-Id: <20210719144947.723808593@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.514164272@linuxfoundation.org>
References: <20210719144942.514164272@linuxfoundation.org>
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
index d20345386b1e..69f67edf83c5 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -1135,6 +1135,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 893185448284..163d6098e8e0 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3667,6 +3667,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 06ff42c71f24..2fe41091fa03 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -3218,6 +3218,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
-- 
2.30.2



