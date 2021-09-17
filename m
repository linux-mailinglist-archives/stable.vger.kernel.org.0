Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACF340EF75
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243038AbhIQCgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242898AbhIQCfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:35:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B637961108;
        Fri, 17 Sep 2021 02:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846069;
        bh=vlCK4WYy/KKRxhgcgvPHcdRA5PJwzpKCtn2Prgoeo20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OMGoVNo07NCoRTDuqCWkxv1cCBRwIzFaYzpqaldOwUbmbuDoft27Vb7XBOW+eYSNZ
         NgGxMUhwfEvVNJoJ95a0gClwKc6N4bpqV1n1cl1UET4ZGt1XQo0HwpnmovuHWAF15M
         Yb4yBDQYDw85A9ors7cd/s51lfrnFHkVQOCe6n674Wk+iPwZaaJwEGxlncIYS71frZ
         AtfllYBJ6QULAWPXPl0AKTIULUQ2Iab7ti7Dye68uUwti5ZGymMMVtTbqYR0E0e0S3
         SsZKX0DwXLQ7glbjMJWJrylDYKyYrRX0i7aAYgkFz3r30y/jJFyFJAYbynF0u+T1a8
         h6uge3MSLe2sA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu-Tung Chang <mtwget@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it
Subject: [PATCH AUTOSEL 5.14 18/21] rtc: rx8010: select REGMAP_I2C
Date:   Thu, 16 Sep 2021 22:33:12 -0400
Message-Id: <20210917023315.816225-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023315.816225-1-sashal@kernel.org>
References: <20210917023315.816225-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu-Tung Chang <mtwget@gmail.com>

[ Upstream commit 0c45d3e24ef3d3d87c5e0077b8f38d1372af7176 ]

The rtc-rx8010 uses the I2C regmap but doesn't select it in Kconfig so
depending on the configuration the build may fail. Fix it.

Signed-off-by: Yu-Tung Chang <mtwget@gmail.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210830052532.40356-1-mtwget@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 12153d5801ce..f7bf87097a9f 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -624,6 +624,7 @@ config RTC_DRV_FM3130
 
 config RTC_DRV_RX8010
 	tristate "Epson RX8010SJ"
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Epson RX8010SJ RTC
 	  chip.
-- 
2.30.2

