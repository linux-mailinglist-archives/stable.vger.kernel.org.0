Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB25EF649A
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:01:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbfKJDBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:01:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:47236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729240AbfKJC4q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:56:46 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D318A222C2;
        Sun, 10 Nov 2019 02:47:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354069;
        bh=xOH+ix3LhRxkW9EZ3qVwZJdXRhikzraxle2sk20ZrZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C4gAE5BNRk/vw47KeattMvkGaJP9AztOEeY33dTpPuOv2eDToAZcTAQWsWPAnDik5
         zXsPSQseTiOJqDGI5OUqf6eC7ATzQCJ/7YucSVLmu+bi/SPCzfW6CvhN4Ff00mH5NU
         gyCkLToK/0VtM6ra0t7vwtjuxfiZx9m54fkpRgmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hauke Mehrtens <hauke@hauke-m.de>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 072/109] phy: lantiq: Fix compile warning
Date:   Sat,  9 Nov 2019 21:45:04 -0500
Message-Id: <20191110024541.31567-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024541.31567-1-sashal@kernel.org>
References: <20191110024541.31567-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

[ Upstream commit 3a00dae006623d799266d85f28b5f76ef07d6b6c ]

This local variable is unused, remove it.

Fixes: dea54fbad332 ("phy: Add an USB PHY driver for the Lantiq SoCs using the RCU module")
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/lantiq/phy-lantiq-rcu-usb2.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
index 986224fca9e91..5a180f71d8d4d 100644
--- a/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
+++ b/drivers/phy/lantiq/phy-lantiq-rcu-usb2.c
@@ -156,7 +156,6 @@ static int ltq_rcu_usb2_of_parse(struct ltq_rcu_usb2_priv *priv,
 {
 	struct device *dev = priv->dev;
 	const __be32 *offset;
-	int ret;
 
 	priv->reg_bits = of_device_get_match_data(dev);
 
-- 
2.20.1

