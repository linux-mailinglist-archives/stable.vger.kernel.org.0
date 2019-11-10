Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA1DF657B
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbfKJCpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbfKJCpT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:45:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA1DC21655;
        Sun, 10 Nov 2019 02:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353918;
        bh=gOAVXjwy6vR30WXWpwBc3912Jaop/VrTFamikl0hOYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SqUILZXyLDJCkg9Ojn6zg1ubl6lNiwijkxOA41cyw/8fqgJVp+UFy9PDDz0NX1aJC
         3dz7V4iWONrp+oD7gNe3J59claQQ7GVPuOBtqSpxC+YngnQ9Uzn7NpAGrCtUVOakAQ
         +vX/BwnGCo7vNOE3RJaRt45wD/ffWixdghWGjJyY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 181/191] rtc: tx4939: fixup nvmem name and register size
Date:   Sat,  9 Nov 2019 21:40:03 -0500
Message-Id: <20191110024013.29782-181-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 2ab78755e93a10f6216c860a2012f3592f395603 ]

The default word_size and stride of 1 are correct for the tx4939. Also fix
the nvmem folder name.

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-tx4939.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tx4939.c b/drivers/rtc/rtc-tx4939.c
index 08dbefc79520e..61c110b2045f8 100644
--- a/drivers/rtc/rtc-tx4939.c
+++ b/drivers/rtc/rtc-tx4939.c
@@ -253,9 +253,7 @@ static int __init tx4939_rtc_probe(struct platform_device *pdev)
 	struct resource *res;
 	int irq, ret;
 	struct nvmem_config nvmem_cfg = {
-		.name = "rv8803_nvram",
-		.word_size = 4,
-		.stride = 4,
+		.name = "tx4939_nvram",
 		.size = TX4939_RTC_REG_RAMSIZE,
 		.reg_read = tx4939_nvram_read,
 		.reg_write = tx4939_nvram_write,
-- 
2.20.1

