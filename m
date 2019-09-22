Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECABBA5C5
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389310AbfIVSpa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:41158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389295AbfIVSp3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B9C0206C2;
        Sun, 22 Sep 2019 18:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177929;
        bh=UGihAmaLW362vg11BnS10tyWxVR4P37dFjOZO5GGe6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tDmkWRqGaXRdASz3radFUOYosxwz37LZyyo9jxcdU7goaCKB2uHh3SmEmHeFmfPAO
         jaqioiKQXF/Tqu+YtN1hPs/GMWuyjwwADTPIsOLcxFJFEIdZEQlId7Bbm37MgI22rc
         uQJoGKaCJZEwjP7CYcOmDqAYwss4KxRWInUd1AL8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Richard Fitzgerald <rf@opensource.cirrus.com>,
        Charles Keepax <ckeepax@opensource.cirrus.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>, patches@opensource.cirrus.com,
        linux-gpio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 040/203] gpio: madera: Add support for Cirrus Logic CS47L15
Date:   Sun, 22 Sep 2019 14:41:06 -0400
Message-Id: <20190922184350.30563-40-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit d06be8bc290aa255b9fd8602e60fb9f487aa0f48 ]

As the gpio is common to all madera codecs all that is needed
is to setup the correct number of GPIO pins for the CS47L15.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20190722090748.20807-3-ckeepax@opensource.cirrus.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-madera.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-madera.c b/drivers/gpio/gpio-madera.c
index 4dbc837d12155..19db5a500eb0d 100644
--- a/drivers/gpio/gpio-madera.c
+++ b/drivers/gpio/gpio-madera.c
@@ -136,6 +136,9 @@ static int madera_gpio_probe(struct platform_device *pdev)
 	madera_gpio->gpio_chip.parent = pdev->dev.parent;
 
 	switch (madera->type) {
+	case CS47L15:
+		madera_gpio->gpio_chip.ngpio = CS47L15_NUM_GPIOS;
+		break;
 	case CS47L35:
 		madera_gpio->gpio_chip.ngpio = CS47L35_NUM_GPIOS;
 		break;
-- 
2.20.1

