Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE26C3CDFD1
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:54:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245756AbhGSPMP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:12:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245743AbhGSPKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 11:10:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7402D60FED;
        Mon, 19 Jul 2021 15:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709851;
        bh=SqMSKcVET3eL/CjFpttP+c/eX1PAOvEaZL+V4uhj9J0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUmIW4DnsV6LzVjeL6jyUuLC5MAuSwS5F80VwMKLJnXz31iWzrXgBfYNwVcLTJOh9
         QQU10XDbEQYE2fzIHBdq7xuit0+rfVa8gufVvigKtI39yRip4kJ7PRDQVqWyTs+Jri
         QPQWaU32t70JOA+c4RYeCX4U3O5yt6g1+3dFDq0U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 122/149] reset: brcmstb: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 19 Jul 2021 16:53:50 +0200
Message-Id: <20210719144930.270901127@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144901.370365147@linuxfoundation.org>
References: <20210719144901.370365147@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit e207457f9045343a24d936fbb67eb4b412f1c6ad ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: 77750bc089e4 ("reset: Add Broadcom STB SW_INIT reset controller driver")
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Link: https://lore.kernel.org/r/1620789283-15048-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/reset-brcmstb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/reset/reset-brcmstb.c b/drivers/reset/reset-brcmstb.c
index f213264c8567..42c9d5241c53 100644
--- a/drivers/reset/reset-brcmstb.c
+++ b/drivers/reset/reset-brcmstb.c
@@ -111,6 +111,7 @@ static const struct of_device_id brcmstb_reset_of_match[] = {
 	{ .compatible = "brcm,brcmstb-reset" },
 	{ /* sentinel */ }
 };
+MODULE_DEVICE_TABLE(of, brcmstb_reset_of_match);
 
 static struct platform_driver brcmstb_reset_driver = {
 	.probe	= brcmstb_reset_probe,
-- 
2.30.2



