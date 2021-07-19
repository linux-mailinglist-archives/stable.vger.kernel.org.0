Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B2C3CD8BE
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242758AbhGSOZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:58284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243206AbhGSOWt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:22:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 30A8A61175;
        Mon, 19 Jul 2021 15:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626706976;
        bh=FoONX3ZOfkpWvhodWQ/lNmjzW83iMuuZ8KZhxY9TO7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X7YvEt6SguUUFuMOxbNpAZuujxgWv9+lZSm1yOZoXKPClUUbWwOiKHadFlVu00h+v
         iFb2rH/EDpq1jEFHh5BMJ2pAmj7s2DJ/O+WNdGeC0FjMR3RyFhm5wgm+U5lmutCKjR
         03k3EsgHJL7oGkyVsRocSiUd4ElH+cfZRuZkdo10=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 172/188] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:36 +0200
Message-Id: <20210719144942.117190252@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144913.076563739@linuxfoundation.org>
References: <20210719144913.076563739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/power/charger-manager.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/charger-manager.c b/drivers/power/charger-manager.c
index 1ea5d1aa268b..6656f847ed93 100644
--- a/drivers/power/charger-manager.c
+++ b/drivers/power/charger-manager.c
@@ -1490,6 +1490,7 @@ static const struct of_device_id charger_manager_match[] = {
 	},
 	{},
 };
+MODULE_DEVICE_TABLE(of, charger_manager_match);
 
 static struct charger_desc *of_cm_parse_desc(struct device *dev)
 {
-- 
2.30.2



