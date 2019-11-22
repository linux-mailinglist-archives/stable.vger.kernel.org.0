Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD0A1063D0
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728719AbfKVGNL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:13:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728697AbfKVGNK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:13:10 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D935820717;
        Fri, 22 Nov 2019 06:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574403189;
        bh=2NavNmSSRIUFC61aNh873EINxN+3wfIG+QCBYvnDcQ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a7YmesbZd3v+t2ed/lPjgaVlaD5/O4RFwNdXExqYaa3E1k7uyBPzjFfLSgDwz41/c
         7jTTWMayFnWBjYnwVkEN1eRwaKalkGk5sdX0zm8comTlHLJFRrJtKhYLeQQ4BMQw3M
         qpZMQBXbMOf2HoHAE88MjkM2mpWEjqO0HOj+A7F4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Meyer <thomas@m3y3r.de>,
        Kevin Hilman <khilman@baylibre.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 07/68] PM / AVS: SmartReflex: NULL check before some freeing functions is not needed
Date:   Fri, 22 Nov 2019 01:12:00 -0500
Message-Id: <20191122061301.4947-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122061301.4947-1-sashal@kernel.org>
References: <20191122061301.4947-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>

[ Upstream commit 14d338a857f05f894ba3badd9e6d3039c68b8180 ]

NULL check before some freeing functions is not needed.

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
Reviewed-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/avs/smartreflex.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/power/avs/smartreflex.c b/drivers/power/avs/smartreflex.c
index db9973bb53f19..ecc59798fd0aa 100644
--- a/drivers/power/avs/smartreflex.c
+++ b/drivers/power/avs/smartreflex.c
@@ -1001,8 +1001,7 @@ static int omap_sr_remove(struct platform_device *pdev)
 
 	if (sr_info->autocomp_active)
 		sr_stop_vddautocomp(sr_info);
-	if (sr_info->dbg_dir)
-		debugfs_remove_recursive(sr_info->dbg_dir);
+	debugfs_remove_recursive(sr_info->dbg_dir);
 
 	pm_runtime_disable(&pdev->dev);
 	list_del(&sr_info->node);
-- 
2.20.1

