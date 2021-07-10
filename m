Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B60D3C37F7
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233354AbhGJXxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232601AbhGJXxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9124F610A2;
        Sat, 10 Jul 2021 23:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961019;
        bh=31Q2SxNVO6mzsD2YnuunmRyukAVykWhnb+sZHX1XplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IOYFUS1pK8JxjbaN1BLKIFDd4TLNMtRTcwT0/kVar+JjYyizbBBzHEMa/lJJpLtDg
         kk3HYtGvAyBFn24vFV2OYj1RIA7SGNBMeXOdJnU7o4/4Cx86sNAeiQGHqG9WjkbY0U
         eI/ZS6LhFlmXSgEkugicqqJIijNsbeKsjfzFhtK3cTIqVbLfYsmz5orq98v6tmOeMB
         CXMf5VN+z+Fs9RRfyDCqEqudXSZLx2pozpx8hc1ClbTfp4OzgdGgLGxiAJzhCG6KPb
         a+D2jxS/QgL4ZGTyK3ZTfqwSHevXN6QPSkTAwn6UKclx/6UkevbXlHMGdhD7OTGMgY
         GOWf8ApcVfzOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 02/37] power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:49:40 -0400
Message-Id: <20210710235016.3221124-2-sashal@kernel.org>
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

[ Upstream commit 2aac79d14d76879c8e307820b31876e315b1b242 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc2731_charger.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/sc2731_charger.c b/drivers/power/supply/sc2731_charger.c
index 335cb857ef30..288b79836c13 100644
--- a/drivers/power/supply/sc2731_charger.c
+++ b/drivers/power/supply/sc2731_charger.c
@@ -524,6 +524,7 @@ static const struct of_device_id sc2731_charger_of_match[] = {
 	{ .compatible = "sprd,sc2731-charger", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, sc2731_charger_of_match);
 
 static struct platform_driver sc2731_charger_driver = {
 	.driver = {
-- 
2.30.2

