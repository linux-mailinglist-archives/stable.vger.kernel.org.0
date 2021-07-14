Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5048E3C8FE2
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240264AbhGNTxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240640AbhGNTt6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:49:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 528EC613DC;
        Wed, 14 Jul 2021 19:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626291944;
        bh=dydekw1/JdNtKj+p/nzgqhqzGkE8uOqo7BdpW50xPI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z1l4J3QkkQQ+tMyi6Ju30fI9ToemqxEhoRjzzUeGwXoc/bMH18Pgu21lTemSkX2tF
         2U18cyUJL7F2t5qbKiTcDq1R7z2FjPx3fW8QrRGC7qARHfmZ8iHPzFq5DIxQ+j3wFA
         8jDPyRE5j4md7gNDG7ZSlIZ6yxJTrMphRyOl68J40JiuE3spwtctcFZeRVDpTQZE02
         2J8piP0m85CuZfyXcKnduMCwchGJXUNSmQjNS8FDm3skjhFtQ/hy0tEQXvdK6S9lVd
         0mw9OK4A8epbdOsaBbMit6+FZOYpp/E6/MUU27e6r8uo9nvCEA6Grbit6eIw6jN8TR
         tiuJ3CMYfNSCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 21/51] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Wed, 14 Jul 2021 15:44:43 -0400
Message-Id: <20210714194513.54827-21-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194513.54827-1-sashal@kernel.org>
References: <20210714194513.54827-1-sashal@kernel.org>
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

