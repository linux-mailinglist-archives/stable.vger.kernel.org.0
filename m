Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 071BC3CA86B
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhGOTBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:34728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243210AbhGOTAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:00:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E07610C7;
        Thu, 15 Jul 2021 18:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375442;
        bh=6rF2GL9WIIQWkZO/BED3ShKt4VEZx8DQg4Uu0Zr1E20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lg6vLErifHd8hCP16l2a7LQTRICooTvN0mjVoHN3Shu8Ggtn/P3wQ8JJHFBhSpDmU
         1H7jwJX3XjO2QDevH7c0v3BVRd5P0z0VftTHjaXkHIaanDnuY+9CYPzIiNt8YLj4a7
         JV10QkYlwF4C+u2UZtoqgn8zuOEgvX/5cHhdZRHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zou Wei <zou_wei@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 089/242] cw1200: add missing MODULE_DEVICE_TABLE
Date:   Thu, 15 Jul 2021 20:37:31 +0200
Message-Id: <20210715182608.721340691@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182551.731989182@linuxfoundation.org>
References: <20210715182551.731989182@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zou Wei <zou_wei@huawei.com>

[ Upstream commit dd778f89225cd258e8f0fed2b7256124982c8bb5 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1620788714-14300-1-git-send-email-zou_wei@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/st/cw1200/cw1200_sdio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/st/cw1200/cw1200_sdio.c b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
index b65ec14136c7..4c30b5772ce0 100644
--- a/drivers/net/wireless/st/cw1200/cw1200_sdio.c
+++ b/drivers/net/wireless/st/cw1200/cw1200_sdio.c
@@ -53,6 +53,7 @@ static const struct sdio_device_id cw1200_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_STE, SDIO_DEVICE_ID_STE_CW1200) },
 	{ /* end: all zeroes */			},
 };
+MODULE_DEVICE_TABLE(sdio, cw1200_sdio_ids);
 
 /* hwbus_ops implemetation */
 
-- 
2.30.2



