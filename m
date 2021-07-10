Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43FB53C383D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbhGJXyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233153AbhGJXxn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25AC8613E3;
        Sat, 10 Jul 2021 23:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961051;
        bh=Msty9ciBjP5m9SthITIk4KQonM2HpjFQVAmZcKQt8cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nr+UOQcq+JmIzQt1hR7CrAKoZa9ZuS2Z6WRfe4+fuevdiD+CyqY34/79WwGsLe/9c
         QsEBTjbBAHnE2PHSdi5IDwxK5OUZpil3TDvSzEb/gArOpZSpuqiTGRpWDjlS6np934
         Lh3+SPJoeDng7xPaUDF2OCApwZ6HoV3AIUHCWmjBEJH1sGii0+MMgs5uzQkk+ttbVG
         mwoMdybrshZ9lMTVaD15bnMZdZRZem0Ade8F7DtKMJC/aQhRXWENSY/qFSv3ESf33b
         W+2zbshWY8ZbmUgKujWnV+Q2vGXJxDkMWWKJKa1iCtZsFP8p4AlfLwc9sG1hZad6Me
         NpGJeCKpipjEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 26/37] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:50:04 -0400
Message-Id: <20210710235016.3221124-26-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235016.3221124-1-sashal@kernel.org>
References: <20210710235016.3221124-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 073b5d5b1f9cc94a3eea25279fbafee3f4f5f097 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/charger-manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index 6fcebe441552..333349275b96 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1279,6 +1279,7 @@ static const struct of_device_id charger_manager_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, charger_manager_match);
 
 static struct charger_desc *of_cm_parse_desc(struct device *dev)
 {
-- 
2.30.2

