Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 571E53C3992
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233787AbhGKAA7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 20:00:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:48828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233456AbhGJX6o (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:58:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D3361426;
        Sat, 10 Jul 2021 23:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961195;
        bh=FoONX3ZOfkpWvhodWQ/lNmjzW83iMuuZ8KZhxY9TO7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QAb0PWmEG8MyRjFP+g8JLNhR8jpeVkf2pZBf0dQYpMe0IiGFQioyk3RX1luV7dk0Z
         NrmhHS85LhuTeUQqg5IgoZzFvP5de/5Z3hAuUYtb887J8iR8JIpnqwCe9qIffbLkFe
         Fln/03xrZNu6ojgKFVxJBjwVSvy0oYnJVfOJ497vhJ6SCS8Qdt3Neshe6QXuczM/h6
         EqobTCN4rlOU9CIdKLtXbzLZiXqOdttwDHdjZlPFxYH/TwrROAONC0yONJ0AmJsvDE
         ZZ9uoWIRZJMi/oCJFdrXla+/9MdO+D49UJG8MKQWKyQHCkD/dFcvI1+Yl40E12nzrz
         NHzKMolHv3gzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 09/12] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:52:59 -0400
Message-Id: <20210710235302.3222809-9-sashal@kernel.org>
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

