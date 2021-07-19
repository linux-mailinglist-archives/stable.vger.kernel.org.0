Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EBC3CDCA6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243472AbhGSOxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344178AbhGSOtX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:49:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0154C60FE7;
        Mon, 19 Jul 2021 15:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708602;
        bh=+J6ow8Q1wEWMZN6vZWYnPmbsRapmBlShLSR5g5qhNXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q3RI4PijupHG1tACFSKVZ1qlx6TDlTHn/REgtQbgyOjPlUqVppeQVcDHKg4CLBJnH
         Q7Ubk50JfefhKKzPupL6Vb1XB6di0PVMU2kTxRCZF8qJiupcQjpxj2WijlVkZgSrg8
         LYx41fQJGzlLnYbtJSzx3KtPXGsjHwyKCY4SFIcE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>, Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 055/421] regulator: uniphier: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:47:46 +0200
Message-Id: <20210719144948.111555410@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit d019f38a1af3c6015cde6a47951a3ec43beeed80 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620705198-104566-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/uniphier-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/uniphier-regulator.c b/drivers/regulator/uniphier-regulator.c
index abf22acbd13e..a2e3654b6332 100644
--- a/drivers/regulator/uniphier-regulator.c
+++ b/drivers/regulator/uniphier-regulator.c
@@ -197,6 +197,7 @@ static const struct of_device_id uniphier_regulator_match[] = {
 	},
 	{ /* Sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, uniphier_regulator_match);
 
 static struct platform_driver uniphier_regulator_driver = {
 	.probe = uniphier_regulator_probe,
-- 
2.30.2



