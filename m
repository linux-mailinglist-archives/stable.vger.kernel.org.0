Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD143CE2D8
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbhGSPcY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:32:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242896AbhGSPaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:30:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0754B613FE;
        Mon, 19 Jul 2021 16:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710983;
        bh=svTgcOKOptpczp/inFy4NH/j4eGSbCUjzJZ0vIcHdqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1W5vUIHhrtaWEjEiTn4OO4Rvnig3CFX3ViCLWo2t3G9eE+aKpPYysx+Dzfs0GBkAJ
         NyBuyjqFQPjR2ij0+9V6D5gSOr1b8Ae3wxqTzzJGw3rRxUx6xG0/crdum9CzX+CqvP
         foodNUDtiiOqhqwsNOjrkiQZis4hstUJNeqJ7+4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 183/351] power: reset: regulator-poweroff: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:09 +0200
Message-Id: <20210719144951.034905210@linuxfoundation.org>
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

[ Upstream commit 4465b3a621e761d82d1a92e3fda88c5d33c804b8 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/reset/regulator-poweroff.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/reset/regulator-poweroff.c b/drivers/power/reset/regulator-poweroff.c
index f697088e0ad1..20701203935f 100644
--- a/drivers/power/reset/regulator-poweroff.c
+++ b/drivers/power/reset/regulator-poweroff.c
@@ -64,6 +64,7 @@ static const struct of_device_id of_regulator_poweroff_match[] = {
 	{ .compatible = "regulator-poweroff", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, of_regulator_poweroff_match);
 
 static struct platform_driver regulator_poweroff_driver = {
 	.probe = regulator_poweroff_probe,
-- 
2.30.2



