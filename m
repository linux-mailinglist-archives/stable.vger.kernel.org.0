Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F10FE3C38AB
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbhGJXzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:55:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233878AbhGJXyx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D7CB61360;
        Sat, 10 Jul 2021 23:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961091;
        bh=Zgnyj7OietzwhR2T7kQGYpNELKJs2BYJDF1TZ96K5mw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aIRVtdbXuneJTRoplo2vL5BR7OgspejB9QoG7Gen+mETGP6bqo8VmoR4GU2nq0OBd
         J+HKXOiXGelM8HeNDBEHpP97pcmevH2VF7Nh9j3Xin7t7DFH1GMJt4bFzFoK0rVamO
         ciarXASrcqmvdZDQGz1CW8g2c/AbTf9vjRWnzdVzkkYAFOjIBPNBxGWV2wkcgNYj2T
         KZW3EDilmEqyGxawi9sgjr9Vx2I60S9ZgqM/gIZJnTXcqkkKIewjX129XV6RYwFlrU
         LqXq10AZarZ0VjX7m7KvajnbsT9hw6cjx8mnfO1a6y5i7K/e24/k3rKHV6EtyJrRDf
         0vLUCnX9k+hhw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 19/28] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:50:58 -0400
Message-Id: <20210710235107.3221840-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235107.3221840-1-sashal@kernel.org>
References: <20210710235107.3221840-1-sashal@kernel.org>
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
index a21e1a2673f8..1a215b6d9447 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -1470,6 +1470,7 @@ static const struct of_device_id charger_manager_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, charger_manager_match);
 
 static struct charger_desc *of_cm_parse_desc(struct device *dev)
 {
-- 
2.30.2

