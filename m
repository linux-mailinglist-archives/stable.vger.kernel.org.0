Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A9C3C3993
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232989AbhGKABA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:01:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234325AbhGJX6w (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B89D1613AF;
        Sat, 10 Jul 2021 23:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961196;
        bh=rzyprTXoujcTc1uUtwZJEXB6M9vxG1VTdx4qM9kIjVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=loNi5Sil2S7WU2B1VvtCqYQ0xrEN0GrR1TqvPiKvgHDe5Oe1w8VRBVos1kTeTvnN5
         X3yMLne7ne8a6waaIY3gWKPDbjhk0JdYfnSm0yQAlHsDz+3t4zFgMSIggTWS5KiAIS
         +u7/9d0AO5oft9NPnaO28MIub1z+uKY5KrNInKJwptUBZKezspfEWj2T87GKQNCbeg
         mYh3oPvyPdFlBPDvPRTz7H5qRevL2r7d4woiiNXEdQw5qPF5FS0tdlHQRH5OhPOhea
         uoGi6vneOsNVXfSg1gZL6EUeXVymrcMljxD7Ut2KFB2ftIiHWcAkH6C9VqX99W5s5f
         CIM8WCJrNNlqg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 10/12] power: supply: ab8500: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:53:00 -0400
Message-Id: <20210710235302.3222809-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235302.3222809-1-sashal@kernel.org>
References: <20210710235302.3222809-1-sashal@kernel.org>
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
 drivers/power/ab8500_btemp.c   | 1 +
 drivers/power/ab8500_charger.c | 1 +
 drivers/power/ab8500_fg.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/power/ab8500_btemp.c b/drivers/power/ab8500_btemp.c
index 8f8044e1acf3..24732df01cf9 100644
--- a/drivers/power/ab8500_btemp.c
+++ b/drivers/power/ab8500_btemp.c
@@ -1186,6 +1186,7 @@ static const struct of_device_id ab8500_btemp_match[] = {
 	{ .compatible = "stericsson,ab8500-btemp", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_btemp_match);
 
 static struct platform_driver ab8500_btemp_driver = {
 	.probe = ab8500_btemp_probe,
diff --git a/drivers/power/ab8500_charger.c b/drivers/power/ab8500_charger.c
index 98724c3a28e5..1a7013ec0caf 100644
--- a/drivers/power/ab8500_charger.c
+++ b/drivers/power/ab8500_charger.c
@@ -3756,6 +3756,7 @@ static const struct of_device_id ab8500_charger_match[] = {
 	{ .compatible = "stericsson,ab8500-charger", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_charger_match);
 
 static struct platform_driver ab8500_charger_driver = {
 	.probe = ab8500_charger_probe,
diff --git a/drivers/power/ab8500_fg.c b/drivers/power/ab8500_fg.c
index d91111200dde..c58b496ca05a 100644
--- a/drivers/power/ab8500_fg.c
+++ b/drivers/power/ab8500_fg.c
@@ -3239,6 +3239,7 @@ static const struct of_device_id ab8500_fg_match[] = {
 	{ .compatible = "stericsson,ab8500-fg", },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, ab8500_fg_match);
 
 static struct platform_driver ab8500_fg_driver = {
 	.probe = ab8500_fg_probe,
-- 
2.30.2

