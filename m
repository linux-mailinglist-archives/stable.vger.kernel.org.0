Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B1BF10154F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbfKSFmr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:37584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729356AbfKSFmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4D9D222A4;
        Tue, 19 Nov 2019 05:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142165;
        bh=gOAVXjwy6vR30WXWpwBc3912Jaop/VrTFamikl0hOYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Gn9+pA6oXe5Gs13SXy1agGsKwLQWFMr/vQCJWcpFRpeOnjPQcvwBMef3MUOckk3G
         Y13soPxSe4FTUQqtuc9ij1aRqdE4/ENo67dTBTqTXcfj+Yal8QSYJCnffW0DukyESQ
         yriftmGAG4P0qKgU3CcXqGV9un4Plik207sog8/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 412/422] rtc: tx4939: fixup nvmem name and register size
Date:   Tue, 19 Nov 2019 06:20:09 +0100
Message-Id: <20191119051425.890716018@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



