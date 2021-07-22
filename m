Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B65F43D2989
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 19:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234918AbhGVQFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 12:05:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233420AbhGVQDw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Jul 2021 12:03:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C1B961C71;
        Thu, 22 Jul 2021 16:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626972246;
        bh=ToHPHCSJF2WG4YeTUnEG8RVXT2dtGFwMgCE15/wD/m4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SP3M2CQdb+RAHH5VUZf8qpMADgHZLjbS7o9G3wcfjTIM6vh2aikjIIQHl8MQr2j5y
         a1tlffzeo4xcRSz/Juwixr170M2okDy+es8IZdLDn165Nvv+GSjs8kaRevsx9TmC1I
         y/tfz5QuB6ZXFUjJYZyfYEa1ipyNogow4tZpT8CI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Bixuan Cui <cuibixuan@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 034/156] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Thu, 22 Jul 2021 18:30:09 +0200
Message-Id: <20210722155629.522013004@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210722155628.371356843@linuxfoundation.org>
References: <20210722155628.371356843@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a577a74aaf75..5e0383401629 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -372,6 +372,7 @@ static const struct of_device_id mxc_ids[] = {
 	{ .compatible = "fsl,imx53-rtc", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mxc_ids);
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
-- 
2.30.2



