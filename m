Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9431C3C386D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhGJXy6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:54:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233582AbhGJXyB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:54:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDB3C613B6;
        Sat, 10 Jul 2021 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961070;
        bh=31Q2SxNVO6mzsD2YnuunmRyukAVykWhnb+sZHX1XplY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IdCfux7knLCBRFPBtRWD1FUq2WFeCHMTI4aLMQ/XOUOUowB8yJ2KHIbkRzbAOBtMb
         tjoEN5ZcGJsxOQuJZ0DiGR9RlbYaegZmLewG2s1Jmj0mnOssy2gExK721MBEV+bnyV
         ga3HpsoKYB3/Y+hKAHE9kM2f4/a1caCe1UgOIbyXpOZP8tSoNGJQ6VCFSK2Rr3Ot1n
         bzaVf3PlBPiPNDS2FpT9w9KzK59Wg6w2ZgFSxdk9MAb/rddeBg/IuNwqTdmGOHshc8
         mnp687yamiwgJ4et4sP6VYdCoRtPPMlnMX+hFzwtxvh6kE5M8yo5qPpLi8x1jcvCJl
         /M+rlhfZGA0Iw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zou Wei <zou_wei@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 02/28] power: supply: sc2731_charger: Add missing MODULE_DEVICE_TABLE
Date:   Sat, 10 Jul 2021 19:50:41 -0400
Message-Id: <20210710235107.3221840-2-sashal@kernel.org>
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

