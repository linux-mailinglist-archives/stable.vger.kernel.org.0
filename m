Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1323C8F39
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:56:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239742AbhGNTwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:52:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238192AbhGNTsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:48:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85F45613D6;
        Wed, 14 Jul 2021 19:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291830;
        bh=dydekw1/JdNtKj+p/nzgqhqzGkE8uOqo7BdpW50xPI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1I4ajPQnxVBHOfHZOBm0If8/f2KuKhZO9OnxPbWvUHzgpGKfS0HXlWzGPjPB8xHh
         DDwavqgySgA3sdvIiJ1rCrpiQ2is4JtycAjTTClbp3My2g0UCOZKNcI+0grM9q15FI
         Se+YM1x8sQySDtiy/CH0nTeA0lZtq5rKk2GN11H7l4Kkx771ycaRNvLNwkac3ILfqB
         v25GlCOEZ9dpBH+FmN8wFJY3h7jtk0MZ6xc3DXBrVojSpSf5l7ll5abGg7YhrlOb+l
         BOtmMSHG1SyJkAaePGi9Vybj2+5/1S4wMGqXivOAsZrJuP4cHxbq5BE8xTZIWesEur
         maMcwp0n9AG4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 29/88] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Wed, 14 Jul 2021 15:42:04 -0400
Message-Id: <20210714194303.54028-29-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194303.54028-1-sashal@kernel.org>
References: <20210714194303.54028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 206e04ec7539e7bfdde9aa79a7cde656c9eb308e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210508031509.53735-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index 91534560fe2a..d349cef09cb7 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -373,6 +373,7 @@ static const struct of_device_id mxc_ids[] = {
 	{ .compatible = "fsl,imx53-rtc", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mxc_ids);
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
-- 
2.30.2

