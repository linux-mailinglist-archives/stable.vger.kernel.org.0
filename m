Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2EEF3C3868
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233526AbhGJXy4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233551AbhGJXx6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:53:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF90B6135E;
        Sat, 10 Jul 2021 23:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961069;
        bh=xDDqPtISmtoJbD92SaB2g1bXCd4plRfczxuEqxbeOlQ=;
        h=From:To:Cc:Subject:Date:From;
        b=uaN+yShLEd3LZgQz5uNK5CJ1wczwlyKOPUrIFOP2LmMn3E8eXiqlcaQy2EB5yqfcm
         WxbEtGPlL1nfv8i/aGNVg/eVJZQxrUZH3yyFbpazcZda8Db0Q+TI9aCga0N0AXjmJ6
         CEcN5t/w5j6B7TCagprfV1/EUntZ9P1QcJyvH6YNNXz4hf88Jkimt04NEt8jhssG2v
         Sfzzc4qyrNZeSzPo103OkOuBxrxMEFDvXFYNtzM7SFP32C/AHL//8KkKCqL3frhHKX
         OFAVR8AuQ/9sUtpcdYOgH7g//tL3+adUABQusicgJBxPWLlm5ZBbB2oMOf+vVl/9aA
         59VeUIpaye7mg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 01/28] power: supply: sc27xx: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:50:40 -0400
Message-Id: <20210710235107.3221840-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit 603fcfb9d4ec1cad8d66d3bb37f3613afa8a661a ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/sc27xx_fuel_gauge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/supply/sc27xx_fuel_gauge.c b/drivers/power/supply/sc27xx_fuel_gauge.c
index bc8f5bda5762..5e5bcdbf2e69 100644
--- a/drivers/power/supply/sc27xx_fuel_gauge.c
+++ b/drivers/power/supply/sc27xx_fuel_gauge.c
@@ -1215,6 +1215,7 @@ static const struct of_device_id sc27xx_fgu_of_match[] = {
 	{ .compatible = "sprd,sc2731-fgu", },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, sc27xx_fgu_of_match);
 
 static struct platform_driver sc27xx_fgu_driver = {
 	.probe = sc27xx_fgu_probe,
-- 
2.30.2

