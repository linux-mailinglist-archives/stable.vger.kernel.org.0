Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 069D640EFA0
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 04:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243615AbhIQChA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 22:37:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243260AbhIQCgS (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 22:36:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0320261260;
        Fri, 17 Sep 2021 02:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631846096;
        bh=PaL2obuOxeOjy9Zxz/WgmfbDkT0BvVxEMnRbqCoV0bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MZTBZZHllYtAbghhPcru2XJeDvwFTv7BGitSrP9AV7xFqB9xvEeG2jdccwA+h0Hyu
         ZxlcQzVkWTEKIo5mJTV1J3XcjZXWyvpzJlK9vlhyU6sM1JLdgLS05R3lM0kXiBJuri
         bqzZFvKCBJiBs7lZwlhxK84CZ8IXDnXhyDxwZe8+OZ+TX98KDh8JRNsj3IAyVS0DvW
         CiPzHbFv95eqe4ZiVDawpEp/2kmj5EtkokPb04VdMofZz3uA0h149eQ963y4zlv1qj
         MlNuVXNN4vj+qtZd8Azt2AIX9W+mFaCm8M/LRy6XnyzRZalx18+8Swj4qxcCVHSavJ
         3GoBRWdd9qMSg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yu-Tung Chang <mtwget@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, a.zummo@towertech.it,
        linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 5/5] rtc: rx8010: select REGMAP_I2C
Date:   Thu, 16 Sep 2021 22:34:49 -0400
Message-Id: <20210917023449.816713-5-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210917023449.816713-1-sashal@kernel.org>
References: <20210917023449.816713-1-sashal@kernel.org>
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
index 9ae7ce3f5069..0ad8d84aeb33 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -625,6 +625,7 @@ config RTC_DRV_FM3130
 
 config RTC_DRV_RX8010
 	tristate "Epson RX8010SJ"
+	select REGMAP_I2C
 	help
 	  If you say yes here you get support for the Epson RX8010SJ RTC
 	  chip.
-- 
2.30.2

