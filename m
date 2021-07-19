Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B823CE14E
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 18:11:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347260AbhGSPZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:25:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346337AbhGSPRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:17:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3152610FB;
        Mon, 19 Jul 2021 15:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626710242;
        bh=Msty9ciBjP5m9SthITIk4KQonM2HpjFQVAmZcKQt8cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nt1jAqkHS4/6pRF2qob1y6P8GjAgvAFUCMDZe8DbEBY/F66A3bPwKfGFvOlPziMZ6
         dufmRzMVEGnPG1PkOYdUQwgCDywHK6DgQtsOPB+CrWM4vQlBIVWSfC5Otnp1t5WjWq
         YHZQhpey6H+xWPcjecpfwJUsqqodbAjDB+tz3XNI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/243] power: supply: charger-manager: add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:52:44 +0200
Message-Id: <20210719144945.268884439@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.904087935@linuxfoundation.org>
References: <20210719144940.904087935@linuxfoundation.org>
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



