Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3A63C376D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232095AbhGJXwK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:52:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232024AbhGJXwE (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 62C496135C;
        Sat, 10 Jul 2021 23:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625960959;
        bh=31Q2SxNVO6mzsD2YnuunmRyukAVykWhnb+sZHX1XplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nyg2qE+SDjPq0HNai5YXQkbQDq9ZzlEHYsa9yzlGEtXZqYM7SB8HVFk75TXvB+Gvf
         QfCkiBC+q8lnfCDwtCpTe5/zoLN3Ga7n6DZ4/eQaa+ek97z77aMx+oTcoUszX19K9B
         0DnTKds85rRdpB8WcbMUfiVcOQpCP3S9uuw/k0hwoa0GfaNTF0pFP3EgCTmnyLEeR2
         QrEMmX8OQOX9CrMCbiFQi6NqFvL+l8oJlWkk21SYiPovBLokTdh2Zrg0b+cKgqMl8l
         lLfgTKShIgAk0e8cahroLBLm9Ft5w8165Dz3zaXnjcQsrMNgX7nd9/tC6bQseuLVDK
         SMThqwrcRWrUQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 02/43] power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:48:34 -0400
Message-Id: <20210710234915.3220342-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710234915.3220342-1-sashal@kernel.org>
References: <20210710234915.3220342-1-sashal@kernel.org>
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

